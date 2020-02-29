//
//  MovieDetailViewController.swift
//  TmdbTestJoaquin
//
//  Created by Joaquin Cubero on 2/28/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CoreData

class MovieDetailViewController: BaseViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var sinopsis: UITextView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
    var isLiked = false
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
        self.year.text = self.GetOnlyDateMonthYearFromFullDate(currentDateFormate: "yyyy-MM-dd", conVertFormate: "YYYY", convertDate: movie.releaseDate!) as String
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
                    likeButton.setImage(UIImage(named:"Like"), for: UIControl.State.normal)
                    isLiked = true
                }
                else {
                    likeButton.setImage(UIImage(named:"UnLike"), for: UIControl.State.normal)
                    isLiked = false
                }
                break
            }
            
            if !isAdded {
                likeButton.setImage(UIImage(named:"UnLike"), for: UIControl.State.normal)
                isLiked = false
            }
        } catch {
            print("Failed")
        }
    }
    
    @IBAction func PerformLike(_ sender: Any) {
        request.predicate = NSPredicate(format: "id = %d", movie.id!)
        let context = appDelegate.persistentContainer.viewContext
        var isAdded = false
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [MovieData] {
                isAdded = true;
                if !isLiked{
                    likeButton.setImage(UIImage(named:"Like"), for: UIControl.State.normal)
                    data.setValue(true, forKey: "isLiked")
                    isLiked = true
                }
                else {
                    data.setValue(false, forKey: "isLiked")
                    likeButton.setImage(UIImage(named:"UnLike"), for: UIControl.State.normal)
                    isLiked = false
                }
                break
            }
            
            if !isAdded {
                if !isLiked{
                    likeButton.setImage(UIImage(named:"Like"), for: UIControl.State.normal)
                    isLiked = true
                }
                else {
                    likeButton.setImage(UIImage(named:"UnLike"), for: UIControl.State.normal)
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
