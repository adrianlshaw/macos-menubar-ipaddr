import SwiftUI
import AppKit

struct ContentView: View {
    @ObservedObject var ipManager: IPManager
    
    var body: some View {
        Menu {
            // IP Display Section
            Text("Current IP: \(ipManager.currentIP)")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Divider()
            
            // Copy IP Menu Item
            Button(action: copyIPToClipboard) {
                Text("Copy IP")
                Text("⌘C").foregroundColor(.secondary)
            }
            .keyboardShortcut("c")
            
            Divider()
            
            // Refresh Menu Item
            Button(action: ipManager.fetchIP) {
                Text("Refresh")
                Text("⌘R").foregroundColor(.secondary)
            }
            .keyboardShortcut("r")
            
            Divider()
            
            // Quit Menu Item
            Button(action: quitApp) {
                Text("Quit WiFiStatusBar")
                Text("⌘Q").foregroundColor(.secondary)
            }
            .keyboardShortcut("q")
        } label: {
            EmptyView()
        }
        .frame(width: 200)
    }
    
    private func copyIPToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(ipManager.currentIP, forType: .string)
    }
    
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
} 