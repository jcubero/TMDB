//
//  MovieDetailViewController.swift
//  TmdbTestJoaquin
//
//  Created by Joaquin Cubero on 2/24/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class MovieDetailViewController: BaseViewController {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var sinopsis: UITextView!

    public var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = "https://image.tmdb.org/t/p/w200" + movie.posterURL!
        self.name.text = self.movie.title
        if let url = URL(string: imageURL) {
            self.poster.contentMode = .scaleAspectFill
            self.downloadImage(url: url, imageView: self.poster)
        }
        self.sinopsis.text = self.movie.sinopsis!
        self.rating.text = String(format:"%.1f", movie.rating ?? "NA")
        self.name.text = self.movie.title!
        
    }
}
