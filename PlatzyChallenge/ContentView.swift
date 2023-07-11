//
//  ContentView.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 10/07/23.
//

import SwiftUI
import CoreData

struct MainView: View {
    @ObservedObject private var viewModel = ListViewModel()
    @State private var showToast = false
    @State private var toastMessage = ""
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        VStack {
            NavigationView {
                if viewModel.books.isEmpty && networkMonitor.status == .disconnected {
                    Text("No internet conection.\nPlease conect to network")
                } else {
                    List(Array(viewModel.books.enumerated()), id: \.element.self) { index, book in
                        NavigationLink(destination: DetailView(book: book,
                                                               index: index)) {
                            VStack(alignment: .leading, spacing: 20, content: {
                                Text(book.name)
                                    .font(.title3)
                                HStack() {
                                    if let dateFormat = book.released.convertToDate() {
                                        Text(dateFormat)
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("Pag: " + String(book.numberOfPages))
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                            })
                        }
                    }
                    .navigationTitle("Books")
                }
            }
        }
        .toast(message: toastMessage,
               isShowing: $showToast,
               duration: Toast.long)
        .onChange(of: networkMonitor.status) { status in
            switch status {
                case .wifi:
                    toastMessage = "Conected over Wifi"
                case .cellular:
                    toastMessage = "Conected over Cellular"
            case .disconnected:
                    toastMessage = "No internet connection"
            }
               showToast = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
