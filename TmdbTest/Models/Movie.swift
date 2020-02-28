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
    
    var id: String?
    var title: String?
    var poster_path: String?
    var overview: String?
    var vote_average: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["Title"]
        vote_average <- map["vote_average"]
        poster_path <- map["poster_path"]
        overview <- map["overview"]
    }
}


