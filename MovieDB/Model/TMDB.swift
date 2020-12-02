//
//  TMDB.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/24.
//  Copyright © 2020 Ethan. All rights reserved.
//

import Foundation

struct TMDB: Codable {
    let results: [TMDB_Info]
    let total_pages: Int
}

struct TMDB_Info: Codable {
    let popularity: Double?
    let video: Bool?
    let genre_ids: [ Int ]?
    let overview: String?
    let release_date: String?
    let original_title: String?
    let poster_path: String?
    let adult: Bool?
    let backdrop_path: String?
    let vote_average: Double?
    let title: String?
    let vote_count: Int?
    let id: Int?
    let original_language: String?
}

// MARK: - 電影海報
struct PosterPaths: Codable {
    let results: [PosterPath]
    let total_pages: Int
}

struct PosterPath: Codable {
    let poster_path: String?
}
