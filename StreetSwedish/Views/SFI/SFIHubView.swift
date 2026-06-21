import SwiftUI

public struct SFIHubView: View {
    @EnvironmentObject var progressManager: ProgressManager
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.primaryGold)
                            
                            Text(progressManager.loc("SFI Swedish", "SFI Svenska"))
                                .font(.sfRounded(size: 26, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text(progressManager.loc("Swedish For Immigrants — Grammar & Verb Reference", "Svenska För Invandrare — Grammatik & Verbrefens"))
                                .font(.sfStandard(size: 14))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                        
                        // Grammar Card
                        NavigationLink(destination: SFIGrammarView()) {
                            sfiCard(
                                icon: "text.alignleft",
                                iconColor: .accentSMS,
                                title: progressManager.loc("Grammar", "Grammatik"),
                                subtitle: progressManager.loc("Word order, nouns, adjectives & pronouns", "Ordföljd, substantiv, adjektiv & pronomen"),
                                badge: progressManager.loc("5 Topics", "5 Ämnen")
                            )
                        }
                        
                        // Verbs Card
                        NavigationLink(destination: SFIVerbsView()) {
                            sfiCard(
                                icon: "hourglass",
                                iconColor: .accentSocial,
                                title: progressManager.loc("Verbs", "Verb"),
                                subtitle: progressManager.loc("100 most common verbs — present, past & past participle", "100 vanligaste verben — presens, preteritum & supinum"),
                                badge: progressManager.loc("100 Verbs", "100 Verb")
                            )
                        }
                        
                        // Divider
                        HStack {
                            VStack { Divider().background(Color.textMuted.opacity(0.3)) }
                            Text(progressManager.loc("EXAMS", "PROV"))
                                .font(.sfRounded(size: 11, weight: .black))
                                .foregroundColor(.textMuted)
                                .tracking(1.5)
                            VStack { Divider().background(Color.textMuted.opacity(0.3)) }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // Course C Exam
                        NavigationLink(destination: SFIExamView(exam: SFIExamData.courseCExam)) {
                            examCard(
                                exam: SFIExamData.courseCExam,
                                icon: "doc.text.fill",
                                iconColor: .appSuccess,
                                subtitle: progressManager.loc("Everyday Swedish — Reading, Grammar & Vocabulary", "Vardagssvenska — Läsning, Grammatik & Ordförråd")
                            )
                        }
                        
                        // Course D Exam
                        NavigationLink(destination: SFIExamView(exam: SFIExamData.courseDExam)) {
                            examCard(
                                exam: SFIExamData.courseDExam,
                                icon: "doc.text.fill",
                                iconColor: .primaryBlue,
                                subtitle: progressManager.loc("Workplace Swedish — Advanced Reading & Grammar", "Arbetssvenska — Avancerad Läsning & Grammatik")
                            )
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("SFI")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func sfiCard(icon: String, iconColor: Color, title: String, subtitle: String, badge: String) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(iconColor.opacity(0.15))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(iconColor)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.sfRounded(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(subtitle)
                    .font(.sfStandard(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(badge)
                    .font(.sfRounded(size: 11, weight: .bold))
                    .foregroundColor(.primaryGold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.primaryGold.opacity(0.12))
                    .cornerRadius(8)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textMuted)
            }
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    private func examCard(exam: SFIExam, icon: String, iconColor: Color, subtitle: String) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(iconColor.opacity(0.15))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(iconColor)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(progressManager.loc("Course \(exam.courseLevel) Exam", "Kurs \(exam.courseLevel) Prov"))
                        .font(.sfRounded(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    if let best = progressManager.examBestScore(examID: exam.id), best >= exam.passingScore {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.appSuccess)
                    }
                }
                Text(subtitle)
                    .font(.sfStandard(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("\(exam.totalQuestions) \(progressManager.loc("Q", "F"))")
                    .font(.sfRounded(size: 11, weight: .bold))
                    .foregroundColor(iconColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(iconColor.opacity(0.12))
                    .cornerRadius(8)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textMuted)
            }
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}
