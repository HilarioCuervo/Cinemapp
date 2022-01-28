//
//  PopularMovieModel.swift
//  Cinemapp
//
//  Created by Hilario Cuervo on 19/01/2022.
//

import Foundation


struct ResultDataModel: Decodable {
    let results: [PopularMovieModel]
}


struct PopularMovieModel: Decodable {
    let posterPath: String?
    let id: Int
    let title: String
}
