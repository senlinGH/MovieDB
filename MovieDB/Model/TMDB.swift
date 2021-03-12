//
//  TMDB.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/24.
//  Copyright © 2020 Ethan. All rights reserved.
//

import Foundation

struct TmdbMovies: Codable {
    let results: [MovieDetailData]
    let total_pages: Int
}

struct MovieDetailData: Codable {
    
    let overview: String
    let release_date: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Double
    let title: String
    let vote_count: Int?
    let id: Int
    let original_title: String
    let job: String?
}

// MARK: - 電影預告
struct MovieVideo: Codable {
    let results: [VideoInfo]
}

struct VideoInfo: Codable ,Equatable {
    let key: String
    let type: String
    let size: Int
}

// MARK: - 電影分級
struct MovieCertification: Codable {
    let results: [DetailCertification]
    
}

struct DetailCertification: Codable {
    let iso_3166_1: String?
    let release_dates: [RelesaseDateDetail]
}

struct RelesaseDateDetail: Codable {
    let certification: String
}

// MARK: - 電影詳細資料
struct MovieDetail: Codable {
    let genres: [GenresInfo]
    let runtime: Int?   
}

struct GenresInfo: Codable {
    let name: String?
}

// MARK: - 卡司陣容
struct CastAndCrew: Codable {
    let cast: [CastDetail]
    let crew: [CrewDetail]
}

struct CastDetail: Codable {
    let id: Int
    let name: String?
    let profile_path: String?
    let character: String?
}

struct CrewDetail: Codable {
    let id: Int
    let name: String?
    let profile_path: String?
    let job: String?
}

struct MovieCreditsForPerson: Codable {
    let cast: [MovieDetailData]
    let crew: [MovieDetailData]
    let id : Int
}
