import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section("遊戲設定") {
                    Toggle("音效", isOn: $viewModel.settings.soundEnabled)
                    Toggle("震動回饋", isOn: $viewModel.settings.hapticEnabled)
                }
                
                Section("遊戲數據") {
                    HStack {
                        Text("最高分")
                        Spacer()
                        Text("\(viewModel.highScore)")
                            .font(.title2.bold())
                            .foregroundColor(.purple)
                    }
                    
                    Button("重置最高分", role: .destructive) {
                        showResetAlert = true
                    }
                }
                
                Section("鍵盤對應") {
                    ForEach(BopomofoConstants.keyboardLayout, id: \.self) { row in
                        Text(row.joined(separator: " "))
                            .font(.system(size: 24))
                    }
                }
            }
            .navigationTitle("設定")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        viewModel.saveSettings()
                        dismiss()
                    }
                }
                #else
                ToolbarItem(placement: .primaryAction) {
                    Button("完成") {
                        viewModel.saveSettings()
                        dismiss()
                    }
                }
                #endif
            }
            .alert("重置最高分", isPresented: $showResetAlert) {
                Button("取消", role: .cancel) { }
                Button("確定重置", role: .destructive) {
                    viewModel.resetHighScore()
                }
            } message: {
                Text("確定要重置最高分嗎?")
            }
        }
    }
}
