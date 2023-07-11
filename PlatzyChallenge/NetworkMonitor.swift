//
//  NetworkMonitor.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import Network
import Foundation

enum NetworkStatus {
    case wifi
    case cellular
    case disconnected
}

final class NetworkMonitor: ObservableObject {
    private let monitor: NWPathMonitor
    @Published var status: NetworkStatus
    
    init() {
        self.monitor = NWPathMonitor()
        self.status = .disconnected
        
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if path.isExpensive {
                        self.status = .cellular
                    } else if path.usesInterfaceType(.wifi) {
                        self.status = .wifi
                    } else {
                        self.status = .disconnected
                    }
                } else {
                    self.status = .disconnected
                }
            }
        }
        
        self.monitor.start(queue: .main)
    }
}
