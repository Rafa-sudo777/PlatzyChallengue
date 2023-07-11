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
                    if path.usesInterfaceType(.cellular) || path.usesInterfaceType(.wifi) {
                        self.status = path.usesInterfaceType(.cellular) ? .cellular : .wifi
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
