//
//  MovieDetailViewController.swift
//  TmdbTestJoaquin
//
//  Created by Joaquin Cubero on 2/28/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import CoreData
import ObjectMapper
import UIKit

class MovieDetailViewController: BaseViewController {
    @IBOutlet var name: UILabel!
    @IBOutlet var poster: UIImageView!
    @IBOutlet var rating: UILabel!
    @IBOutlet var sinopsis: UITextView!
    @IBOutlet var year: UILabel!
    @IBOutlet var likeButton: UIButton!
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
    var isLiked = false
    public var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = "https://image.tmdb.org/t/p/w200" + movie.posterURL!
        name.text = movie.title
        if let url = URL(string: imageURL) {
            poster.contentMode = .scaleAspectFill
            downloadImage(url: url, imageView: poster)
        }
        sinopsis.text = movie.sinopsis!
        rating.text = String(format: "%.1f", movie.rating ?? "NA")
        name.text = movie.title!
        year.text = GetOnlyDateMonthYearFromFullDate(currentDateFormate: "yyyy-MM-dd", conVertFormate: "YYYY", convertDate: movie.releaseDate!) as String
        checkInitialState()
    }

    func checkInitialState() {
        request.predicate = NSPredicate(format: "id = %d", movie.id!)
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = false
        var isAdded = false
        do {
            let result = try context.fetch(request)
            for data in result as! [MovieData] {
                isAdded = true
                if data.isLiked {
                    likeButton.setImage(UIImage(named: "Like"), for: UIControl.State.normal)
                    isLiked = true
                } else {
                    likeButton.setImage(UIImage(named: "UnLike"), for: UIControl.State.normal)
                    isLiked = false
                }
                break
            }

            if !isAdded {
                likeButton.setImage(UIImage(named: "UnLike"), for: UIControl.State.normal)
                isLiked = false
            }
        } catch {
            print("Failed")
        }
    }

    @IBAction func PerformLike(_: Any) {
        request.predicate = NSPredicate(format: "id = %d", movie.id!)
        let context = appDelegate.persistentContainer.viewContext
        var isAdded = false
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [MovieData] {
                isAdded = true
                if !isLiked {
                    likeButton.setImage(UIImage(named: "Like"), for: UIControl.State.normal)
                    data.setValue(true, forKey: "isLiked")
                    isLiked = true
                } else {
                    data.setValue(false, forKey: "isLiked")
                    likeButton.setImage(UIImage(named: "UnLike"), for: UIControl.State.normal)
                    isLiked = false
                }
                break
            }

            if !isAdded {
                if !isLiked {
                    likeButton.setImage(UIImage(named: "Like"), for: UIControl.State.normal)
                    isLiked = true
                } else {
                    likeButton.setImage(UIImage(named: "UnLike"), for: UIControl.State.normal)
                    isLiked = false
                }
                let entity = NSEntityDescription.entity(forEntityName: "MovieData", in: context)
                let newMovie = NSManagedObject(entity: entity!, insertInto: context)
                newMovie.setValue(movie.id, forKey: "id")
                newMovie.setValue(movie.title, forKey: "title")
                newMovie.setValue(movie.rating, forKey: "rating")
                newMovie.setValue(movie.posterURL, forKey: "posterUrl")
                newMovie.setValue(movie.releaseDate, forKey: "year")
                newMovie.setValue(movie.sinopsis, forKey: "sinopsis")
                newMovie.setValue(isLiked, forKey: "isLiked")
            }
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        } catch {
            print("Failed")
        }
    }
}
