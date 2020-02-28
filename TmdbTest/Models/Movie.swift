//
//  Movie.swift
//  TmdbTest
//
//  Created by Joaquin Cubero on 2/27/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class Movie: Mappable {
    // MARK: Properties
    
    var id: Int?
    var title: String?
    var posterURL: String?
    var sinopsis: String?
    var rating: Double?
    var releaseDate: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        rating <- map["vote_average"]
        posterURL <- map["poster_path"]
        sinopsis <- map["overview"]
        releaseDate <- map["release_date"]
    }
}


