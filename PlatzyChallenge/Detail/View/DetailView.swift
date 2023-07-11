//
//  DetailView.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import SwiftUI
import AVKit

struct DetailView: View {
    @ObservedObject var viewModel = DetailViewModel()
    @EnvironmentObject var networkMonitor: NetworkMonitor
    private var book: BookModel!
    private var index = String()
    
    init (book: BookModel, index: Int) {
        self.book = book
        self.index = String(index + 1)
    }
    
    var body: some View {
        VStack {
            Text(book.name)
                .font(.largeTitle)
                .bold()
            VideoPlayer(player: .init(url: URL(string: "https://cloudinary-marketing-res.cloudinary.com/video/upload/e_preview:duration_15:max_seg_9:min_seg_dur_1/q_auto/f_auto/surfing_travel.mp4")!))
                .frame(width: 355,
                       height: 200,
                       alignment: .center)
            Form {
                if let character = viewModel.character, !character.isEmpty {
                    Section(header:
                                Text("Character")
                        .bold()
                    ) {
                        Text(character)
                    }
                }
                Section(header:
                            Text("General Info")
                    .bold()
                ) {
                    Group {
                        HStack {
                            Text("Country:")
                            Spacer()
                            Text("\(book.country.rawValue)")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Total pages:")
                            Spacer()
                            Text("\(book.numberOfPages)")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Publisher:")
                            Spacer()
                            Text("\(book.publisher)")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Media type:")
                            Spacer()
                            Text("\(book.mediaType)")
                                .foregroundColor(.gray)
                        }
                        if let dateFormat = book.released.convertToDate() {
                            HStack {
                                Text("Release Date:")
                                Spacer()
                                Text(dateFormat)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                Section(header:
                            Text("Authors")
                    .bold()
                ) {
                    ForEach(book.authors, id: \.self) { author in
                        Text(author.rawValue)
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.fetchCharacters(index: index)
        })
        //.environmentObject(networkMonitor)
    }
}
