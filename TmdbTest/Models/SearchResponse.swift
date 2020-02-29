//
//  searchResponse.swift
//  TmdbTest
//
//  Created by Joaquin Cubero on 2/28/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper
import UIKit

class SearchResponse: Mappable {
    var results: [Movie]?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        results <- map["results"]
    }
}
