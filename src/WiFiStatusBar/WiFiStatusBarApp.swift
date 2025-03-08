import SwiftUI

@available(macOS 13.0, *)
@main
struct WiFiStatusBarApp: App {
    @StateObject private var ipManager = IPManager()
    @State private var showCopiedMessage = false
    
    @available(macOS 13.0, *)
    var body: some Scene {
        MenuBarExtra {
            Button("Copy IP") {
                copyToClipboard()
            }
            .keyboardShortcut("c")
            
            Button("Refresh") {
                ipManager.fetchIP()
            }
            .keyboardShortcut("r")
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        } label: {
            Group {
                if showCopiedMessage {
                    Text("Copied!")
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(.green)
                } else {
                    Text(ipManager.currentIP)
                        .font(.system(size: 13, design: .monospaced))
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSMenu.didBeginTrackingNotification)) { _ in
                copyToClipboard()
                showCopiedMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showCopiedMessage = false
                }
            }
        }
        .menuBarExtraStyle(.menu)
    }
    
    init() {
        //copyToClipboard()
    }
    
    private func copyToClipboard() {
        guard !ipManager.currentIP.isEmpty else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(ipManager.currentIP, forType: .string)
    }
} 