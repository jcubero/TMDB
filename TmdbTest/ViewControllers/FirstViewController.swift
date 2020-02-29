//
//  FirstViewController.swift
//  TmdbTest
//
//  Created by Joaquin Cubero on 2/27/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CoreData

class FirstViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var movies = [Movie]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        //register table view cell
        table.register(UINib.init(nibName: "TMDBCustomCell", bundle: nil), forCellReuseIdentifier: "TMDBCustomCell")
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let controller = storyboard.instantiateViewController(withIdentifier: "ThirdViewController")
       self.present(controller, animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //performSearch(title: name.text!)
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
        cell.movie = movie
        cell.title?.text = movie.title
        cell.year.text = self.GetOnlyDateMonthYearFromFullDate(currentDateFormate: "yyyy-MM-dd", conVertFormate: "YYYY", convertDate: movie.releaseDate!) as String
        cell.rating.text = String(format:"%.1f", movie.rating ?? "NA")
        let imageURL = "https://image.tmdb.org/t/p/w200" + movie.posterURL!
        if let url = URL(string: imageURL) {
            cell.posterImage.contentMode = .scaleAspectFill
            downloadImage(url: url, imageView: cell.posterImage)
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        request.predicate = NSPredicate(format: "id = %d", movie.id!)
        let context = appDelegate.persistentContainer.viewContext
        do {
            let result = try context.fetch(request)
            for data in result as! [MovieData] {
                if data.isLiked == true{
                    cell.isLiked = true
                    cell.likeButton.setImage(UIImage(named:"Like"), for: UIControl.State.normal)
                }
                else
                {
                    cell.isLiked = false
                    cell.likeButton.setImage(UIImage(named:"UnLike"), for: UIControl.State.normal)
                }
            }
      } catch {
            print("Failed")
        }
        cell.callback = { () -> Void in
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        performSegue(withIdentifier: "FirstSegue", sender: vc)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                 sender: Any?)
    {
        let vc = segue.destination as! MovieDetailViewController
        let movieIndex = table.indexPathForSelectedRow?.row
        vc.movie = movies[movieIndex!]
    }
}

// MARK: - Alamofire
extension FirstViewController {
  func fetchMovies() {
    AF.request(url, method: .get, parameters: ["sort_by":"popularity.desc"]).responseObject{ (response:
        DataResponse<SearchResponse>) in
        print("response is: \(response)")
        switch response.result {
        case .success(let value):
            let searchResponse = value
            if(searchResponse.results != nil) {
                self.movies = (searchResponse.results)!
            }
            else {
                self.movies = [Movie]()
            }
            self.table.reloadData()
        case .failure( _):
            self.movies = [Movie]()
            self.table.reloadData()
        }
    }
  }
  
  func performSearch(for title: String) {
  }
}
