//
//  MovieModel.swift
//  Cinemapp
//
//  Created by Hilario Cuervo on 17/01/2022.
//

import Foundation


struct CurrentMovieModel: Decodable {
    let title: String
    let backdropPath: String?
    let genres: [GenresModel]
    let releaseDate: String
    let overview: String
    let posterPath: String?
}


struct GenresModel: Decodable {
    let id: Int
    let name: String
}
