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

class MovieDetailViewController: UIViewController {

    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var poster: UIImageView!

    @IBOutlet weak var rating: UILabel!

    @IBOutlet weak var sinopsis: UITextView!
    public var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
