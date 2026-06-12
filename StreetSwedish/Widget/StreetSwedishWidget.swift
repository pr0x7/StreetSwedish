import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let dailyProgressFraction: Double // e.g. 0.6 for 3/5 sessions
    let dailyProgressText: String     // e.g. "3/5"
    let reviewsDue: Int
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            streak: 3,
            dailyProgressFraction: 0.6,
            dailyProgressText: "3/5",
            reviewsDue: 4
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = fetchLatestProgress()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = fetchLatestProgress()
        // Refresh every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    // Fetch data using AppGroup group.com.streetswedish.app with UserDefaults fallback
    private func fetchLatestProgress() -> SimpleEntry {
        let defaults = UserDefaults(suiteName: "group.com.streetswedish.app") ?? UserDefaults.standard
        
        let streak = defaults.integer(forKey: "user_streak")
        let dailyGoal = defaults.integer(forKey: "daily_goal") == 0 ? 5 : defaults.integer(forKey: "daily_goal")
        let dailyCompleted = defaults.integer(forKey: "daily_completed")
        let reviewsDue = defaults.integer(forKey: "reviews_due")
        
        let fraction = Double(dailyCompleted) / Double(dailyGoal)
        let text = "\(dailyCompleted)/\(dailyGoal)"
        
        return SimpleEntry(
            date: Date(),
            streak: streak,
            dailyProgressFraction: fraction,
            dailyProgressText: text,
            reviewsDue: reviewsDue
        )
    }
}

// MARK: - Widget View
struct StreetSwedishWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            circularLockScreenView()
        case .accessoryRectangular:
            rectangularLockScreenView()
        case .systemSmall:
            smallHomeScreenView()
        default:
            smallHomeScreenView()
        }
    }
    
    // MARK: - Accessory Circular (Lock Screen)
    private func circularLockScreenView() -> some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 0) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 14))
                Text("\(entry.streak)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
            }
        }
    }
    
    // MARK: - Accessory Rectangular (Lock Screen)
    private func rectangularLockScreenView() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                Text("Streak: \(entry.streak) dagar")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
            }
            Text("\(entry.reviewsDue) ord att repetera")
                .font(.system(size: 11, design: .default))
                .opacity(0.8)
            
            Text("Mål idag: \(entry.dailyProgressText)")
                .font(.system(size: 10, design: .default))
                .opacity(0.6)
        }
    }
    
    // MARK: - System Small (Home Screen)
    private func smallHomeScreenView() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("SVEA")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundColor(Color("primaryGold"))
                    .tracking(1.5)
                Spacer()
                Image(systemName: "flame.fill")
                    .foregroundColor(Color("streakFlame"))
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(entry.streak) DAGAR")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("AKTIV STREAK")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                    .tracking(1.0)
            }
            
            HStack(spacing: 8) {
                // Progress circle
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 4)
                        .frame(width: 28, height: 28)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(min(entry.dailyProgressFraction, 1.0)))
                        .stroke(Color("appSuccess"), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 28, height: 28)
                        .rotationEffect(.degrees(-90))
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("Sessioner")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                    Text("\(entry.dailyProgressText) klara")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if entry.reviewsDue > 0 {
                    Text("\(entry.reviewsDue) öva")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color("appBackground"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color("primaryGold"))
                        .cornerRadius(6)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("appBackground"))
    }
}

// MARK: - Widget Config
public struct StreetSwedishWidget: Widget {
    let kind: String = "StreetSwedishWidget"

    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StreetSwedishWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Svea Framsteg")
        .description("Håll koll på din streak och dina dagliga mål direkt från hemskärmen.")
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular])
    }
}
