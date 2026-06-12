import Foundation

public final class SRSScheduler: ObservableObject {
    private let userDefaultsKey = "srs_items_v1"
    
    @Published public var items: [String: SRSItem] = [:]
    
    public init() {
        loadItems()
    }
    
    // MARK: - Persistence
    public func loadItems() {
        guard let dict = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: Data] else {
            self.items = [:]
            return
        }
        
        var loaded: [String: SRSItem] = [:]
        let decoder = JSONDecoder()
        for (key, data) in dict {
            if let item = try? decoder.decode(SRSItem.self, from: data) {
                loaded[key] = item
            }
        }
        self.items = loaded
    }
    
    public func saveItems() {
        let encoder = JSONEncoder()
        var dict: [String: Data] = [:]
        for (key, item) in items {
            if let data = try? encoder.encode(item) {
                dict[key] = data
            }
        }
        UserDefaults.standard.set(dict, forKey: userDefaultsKey)
    }
    
    // MARK: - SRS Engine Update
    /// Updates the SRS item progress based on review response.
    /// - Parameters:
    ///   - itemID: Unique ID of the vocabulary item.
    ///   - isCorrect: Whether the user answered correctly.
    ///   - responseQuality: Quality score between 0.0 (worst) and 1.0 (best).
    public func recordResponse(itemID: String, isCorrect: Bool, responseQuality: Double) {
        var item = items[itemID] ?? SRSItem(itemID: itemID)
        let now = Date()
        
        item.lastSeenDate = now
        item.lastResponseQuality = responseQuality
        
        if isCorrect {
            item.repetitionCount += 1
            
            // Progress stages
            switch item.stage {
            case 0: // Unseen -> Introduced
                item.stage = 1
                item.intervalDays = 4.0 / 24.0 // 4 hours
                item.nextReviewDate = now.addingTimeInterval(4 * 3600)
                
            case 1: // Introduced -> Recognition (requires 1 correct review to move to Stage 2)
                item.stage = 2
                item.intervalDays = 1.0 // 1 day
                item.nextReviewDate = now.addingTimeInterval(24 * 3600)
                
            case 2: // Recognition (Needs 2 correct at this stage to move to Recall)
                // We use repetitionCount at this stage. Since they just hit correct, let's look at consecutive hits.
                if item.repetitionCount >= 2 {
                    item.stage = 3
                    item.intervalDays = 3.0 // 3 days
                    item.nextReviewDate = now.addingTimeInterval(3 * 24 * 3600)
                } else {
                    item.intervalDays = 1.0 // keep at 1 day
                    item.nextReviewDate = now.addingTimeInterval(24 * 3600)
                }
                
            case 3: // Recall (Needs 2 correct at this stage to move to Usage)
                // If they have 2 correct since entering stage 3 (e.g. repetitionCount >= 4 total, or let's check consecutive)
                if item.repetitionCount >= 4 {
                    item.stage = 4
                    item.intervalDays = 7.0 // 7 days
                    item.nextReviewDate = now.addingTimeInterval(7 * 24 * 3600)
                } else {
                    item.intervalDays = 3.0 // keep at 3 days
                    item.nextReviewDate = now.addingTimeInterval(3 * 24 * 3600)
                }
                
            case 4: // Usage (Needs 2 correct at this stage to move to Mastered)
                if item.repetitionCount >= 6 {
                    item.stage = 5
                    // First entry into Stage 5 (Mastered): set initial interval and EF
                    item.intervalDays = 14.0
                    item.nextReviewDate = now.addingTimeInterval(14 * 24 * 3600)
                } else {
                    item.intervalDays = 7.0 // keep at 7 days
                    item.nextReviewDate = now.addingTimeInterval(7 * 24 * 3600)
                }
                
            case 5: // Mastered (SM-2 engine)
                // Convert quality 0-1 to SM-2 quality 0-5
                // 1.0 -> 5, 0.8 -> 4, etc.
                let q = responseQuality * 5.0
                
                // Update easiness factor
                let newEF = item.easinessFactor + (0.1 - (5.0 - q) * (0.08 + (5.0 - q) * 0.02))
                item.easinessFactor = max(1.3, newEF)
                
                // Calculate SM-2 intervals
                if item.repetitionCount == 1 {
                    item.intervalDays = 1.0
                } else if item.repetitionCount == 2 {
                    item.intervalDays = 6.0
                } else {
                    item.intervalDays = round(item.intervalDays * item.easinessFactor)
                }
                item.nextReviewDate = now.addingTimeInterval(item.intervalDays * 24 * 3600)
                
            default:
                break
            }
        } else {
            // Failure drops stage by 1 and reschedules sooner
            item.failureCount += 1
            item.repetitionCount = 0 // Reset consecutive count
            
            if item.stage > 1 {
                item.stage -= 1
            } else {
                item.stage = 1 // Min stage is 1 after being introduced
            }
            
            // Reschedule sooner: 4 hours for Stage 1, 1 day for others
            if item.stage == 1 {
                item.intervalDays = 4.0 / 24.0
                item.nextReviewDate = now.addingTimeInterval(4 * 3600)
            } else {
                item.intervalDays = 1.0
                item.nextReviewDate = now.addingTimeInterval(24 * 3600)
            }
        }
        
        items[itemID] = item
        saveItems()
    }
    
    /// Overrides stage to "Mastered" directly (e.g. "Mark as Known" gesture)
    public func markAsKnown(itemID: String) {
        var item = items[itemID] ?? SRSItem(itemID: itemID)
        item.stage = 5
        item.repetitionCount = 6
        item.intervalDays = 30.0
        item.nextReviewDate = Date().addingTimeInterval(30 * 24 * 3600)
        items[itemID] = item
        saveItems()
    }
    
    /// Resets progress for a word
    public func resetProgress(itemID: String) {
        items.removeValue(forKey: itemID)
        saveItems()
    }
    
    // MARK: - Queue Builder
    /// Generates the daily queue by combining due reviews and new items, interleaved 3:1.
    /// - Parameters:
    ///   - allItemIDs: List of all vocabulary item IDs available in the system.
    ///   - maxNewCount: Maximum number of new items allowed today (default 10).
    ///   - maxReviewCount: Maximum number of due review items (default 50).
    public func getDailyQueue(allItemIDs: [String], maxNewCount: Int = 10, maxReviewCount: Int = 50) -> [String] {
        let now = Date()
        
        // 1. Gather due review items (items at Stage 1-5 where nextReviewDate <= now)
        let dueReviews = items.values
            .filter { $0.stage > 0 && $0.nextReviewDate <= now }
            .sorted { $0.nextReviewDate < $1.nextReviewDate } // oldest due first
            .prefix(maxReviewCount)
            .map { $0.itemID }
        
        // 2. Gather new items (items at Stage 0 / Unseen)
        // Note: items not in self.items are considered Stage 0
        let unseenIDs = allItemIDs.filter { id in
            let item = items[id]
            return item == nil || item?.stage == 0
        }
        let newItems = Array(unseenIDs.prefix(maxNewCount))
        
        // 3. Interleave 3 reviews : 1 new
        var queue: [String] = []
        var reviewIndex = 0
        var newIndex = 0
        
        while reviewIndex < dueReviews.count || newIndex < newItems.count {
            // Add up to 3 reviews
            var reviewsAdded = 0
            while reviewsAdded < 3 && reviewIndex < dueReviews.count {
                queue.append(dueReviews[reviewIndex])
                reviewIndex += 1
                reviewsAdded += 1
            }
            
            // Add 1 new item
            if newIndex < newItems.count {
                queue.append(newItems[newIndex])
                newIndex += 1
            }
        }
        
        return queue
    }
    
    /// Returns the counts of due items vs new items for dashboard display
    public func getQueueCounts(allItemIDs: [String]) -> (due: Int, new: Int) {
        let now = Date()
        let dueCount = items.values.filter { $0.stage > 0 && $0.nextReviewDate <= now }.count
        let unseenCount = allItemIDs.filter { id in
            let item = items[id]
            return item == nil || item?.stage == 0
        }.count
        return (dueCount, unseenCount)
    }
}
