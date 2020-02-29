//
//  SecondViewController.swift
//  TmdbTest
//
//  Created by Joaquin Cubero on 2/27/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import CoreData
class SecondViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    public var movieData = [MovieData]()
    public var movie = [Movie]()

    @IBOutlet var table: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        table.register(UINib.init(nibName: "TMDBCustomCell", bundle: nil), forCellReuseIdentifier: "TMDBCustomCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    func reloadData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        request.predicate = NSPredicate(format: "isLiked == YES")
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            movieData = result as! [MovieData]
        } catch {
            print("Failed")
        }
        table.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("get sections")
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("get movie count")
        return movieData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TMDBCustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TMDBCustomCell
        let movie = movieData[indexPath.row]
        cell.title?.text = movie.value(forKey: "title") as? String
        cell.movie = Movie()
        cell.movie.id = movie.value(forKey: "id") as? Int
        if movie.value(forKey: "posterUrl") != nil{
            let url = "https://image.tmdb.org/t/p/w200"
            let imageURL = movie.value(forKey: "posterUrl")! as! String
            if  let url = URL(string: url + imageURL) {
                cell.posterImage.contentMode = .scaleAspectFill
                downloadImage(url: url, imageView: cell.posterImage)
            }
        }
        cell.isLiked = true
        cell.likeButton.setImage(UIImage(named:"Like"), for: UIControl.State.normal)
        cell.callback = { () -> Void in
            self.reloadData()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
           URLSession.shared.dataTask(with: url) {
               (data, response, error) in
               completion(data, response, error)
               }.resume()
       }
       
       func downloadImage(url: URL, imageView: UIImageView) {
           print("Download Started")
           getDataFromUrl(url: url) { (data, response, error)  in
               DispatchQueue.main.sync() { () -> Void in
                   guard let data = data, error == nil else { return }
                   print(response?.suggestedFilename ?? url.lastPathComponent)
                   print("Download Finished")
                   imageView.image = UIImage(data: data)
               }
           }
       }

}

