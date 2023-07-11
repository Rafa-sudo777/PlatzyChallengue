//
//  DetailViewModel.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import Foundation

final class DetailViewModel: ObservableObject  {
    @Published var character: String?
    let networkLayer = NetworkLayer()
    
    func fetchCharacters(index: String) {
        Task {
            character = await networkLayer.getCharacters(url: "https://www.anapioficeandfire.com/api/characters/" + index) .name
        }
    }
}
