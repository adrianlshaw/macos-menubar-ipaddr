import SwiftUI

@available(macOS 13.0, *)
@main
struct WiFiStatusBarApp: App {
    @StateObject private var ipManager = IPManager()
    
    @available(macOS 13.0, *)
    var body: some Scene {
        MenuBarExtra {
            Button("Copy IP") {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(ipManager.currentIP, forType: .string)
            }
            .keyboardShortcut("c")
            
            //Divider()
            
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
            // What shows in the menu bar
            Text(ipManager.currentIP)
                .font(.system(size: 13, design: .monospaced))
        }
        .menuBarExtraStyle(.menu)
    }
} 