import SystemConfiguration
import Combine
import Foundation
import SwiftUI

class IPManager: ObservableObject {
    @Published var currentIP = "..."  // Initial loading state
    private var timer: Timer?
    
    init() {
        startUpdates()
    }
    
    func startUpdates() {
        fetchIP()
        timer = Timer.scheduledTimer(
            withTimeInterval: 43200.0, // twice a day
            repeats: true
        ) { [weak self] _ in
            self?.fetchIP()
        }
    }
    
    func fetchIP() {
        guard let url = URL(string: "https://api.ipify.org?format=json") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(IPResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.currentIP = response.ip
                    }
                } catch {
                    self?.getLocalIP()
                }
            } else {
                self?.getLocalIP()
            }
        }.resume()
    }
    
    private func getLocalIP() {
        var address = "No IP"
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        guard getifaddrs(&ifaddr) == 0 else { return }
        defer { freeifaddrs(ifaddr) }
        
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            
            guard let interface = ptr?.pointee,
                  interface.ifa_addr.pointee.sa_family == UInt8(AF_INET),
                  String(cString: interface.ifa_name) == "en0" || String(cString: interface.ifa_name) == "en1"
            else { continue }
            
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(
                interface.ifa_addr,
                socklen_t(interface.ifa_addr.pointee.sa_len),
                &hostname,
                socklen_t(hostname.count),
                nil,
                socklen_t(0),
                NI_NUMERICHOST
            )
            address = String(cString: hostname)
            break
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.currentIP = address
        }
    }
    
    private struct IPResponse: Codable {
        let ip: String
    }
} 