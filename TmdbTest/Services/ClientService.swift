//
//  ClientService.swift
//  TmdbTest
//
//  Created by Joaquin Cubero on 2/27/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import TMDBSwift
import Alamofire
import AlamofireObjectMapper
class ClientService {
    let apiKey = "c82a2ecc048f6be2dd8a873143be57aa&"
    let url = "https://api.themoviedb.org/3/discover/movie?"
    var popularMovies = [Movie]()

    func retrievePopularMovies(){
            
        Alamofire.request(url, method: .get, parameters: ["api_key": apiKey, "sort_by":"popularity.desc"]).responseObject{ (response:
            DataResponse<SearchResponse>) in
            print("response is: \(response)")
            switch response.result {
            case .success(let value):
            
                let searchResponse = value
                if(searchResponse.results != nil){
                    self.popularMovies = (searchResponse.results)!
                }
                else {
                    self.popularMovies = [Movie]()
                }
            case .failure( _):
                self.popularMovies = [Movie]()
            }
        }
    }
}
