//
//  ThirdViewController.swift
//  TmdbTestJoaquin
//
//  Created by Joaquin Cubero on 2/22/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import CoreData

class ThirdViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    public var movies = [MovieData]()
    @IBOutlet var table: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        table.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        request.predicate = NSPredicate(format: "isLater == YES")
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            movies = result as! [MovieData]
        } catch {
            print("Failed")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("get sections")
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("get movie count")
        return movies.count
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TMDBCustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TMDBCustomCell
        let movie = movies[indexPath.row]
        cell.title?.text = movie.value(forKey: "title") as? String
        if movie.value(forKey: "posterUrl") != nil{
            if  let url = URL(string: movie.value(forKey: "posterUrl")! as! String) {
                cell.posterImage.contentMode = .scaleAspectFill
                downloadImage(url: url, imageView: cell.posterImage)
            }

        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
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
