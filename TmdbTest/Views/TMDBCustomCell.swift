//
//  TMDBCustomCell.swift
//  TmdbTest
//
//  Created by Joaquin Cubero on 2/28/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import CoreData

class TMDBCustomCell: UITableViewCell {

    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var title: UILabel!
    var callback: (() -> Void)?
    var isLiked = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var movie: Movie!
    
    @IBAction func AddFavorite(_ sender: UIButton, forEvent event: UIEvent) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        request.predicate = NSPredicate(format: "id = %d", movie.id!)
        let context = appDelegate.persistentContainer.viewContext
        var isAdded = false
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
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
        
        if callback != nil {
            callback!()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
