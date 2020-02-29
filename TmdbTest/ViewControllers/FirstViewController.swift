//
//  FirstViewController.swift
//  TmdbTest
//
//  Created by Joaquin Cubero on 2/28/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import CoreData
import ObjectMapper
import UIKit

class FirstViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var movies = [Movie]()

    @IBOutlet var table: UITableView!
    @IBAction func PerformSort(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            movies = movies.sorted {
                $0.title! < $1.title!
            }
        case 1:
            movies = movies.sorted {
                $1.releaseDate! < $0.releaseDate!
            }
        case 2:
            movies = movies.sorted {
                $1.rating! < $0.rating!
            }
        default:
            break
        }
        table.reloadData()
    }

    override func viewWillAppear(_: Bool) {
        fetchMovies()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        // register table view cell
        table.register(UINib(nibName: "TMDBCustomCell", bundle: nil), forCellReuseIdentifier: "TMDBCustomCell")
    }

    @objc func buttonAction(sender _: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ThirdViewController")
        present(controller, animated: true, completion: nil)
    }

    func searchBar(_: UISearchBar, textDidChange _: String) {
        // performSearch(title: name.text!)
    }

    func numberOfSections(in _: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("get sections")
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
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
        cell.year.text = GetOnlyDateMonthYearFromFullDate(currentDateFormate: "yyyy-MM-dd", conVertFormate: "YYYY", convertDate: movie.releaseDate!) as String
        cell.rating.text = String(format: "%.1f", movie.rating ?? "NA")
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
                if data.isLiked == true {
                    cell.isLiked = true
                    cell.likeButton.setImage(UIImage(named: "Like"), for: UIControl.State.normal)
                } else {
                    cell.isLiked = false
                    cell.likeButton.setImage(UIImage(named: "UnLike"), for: UIControl.State.normal)
                }
            }
        } catch {
            print("Failed")
        }
        cell.callback = { () -> Void in
        }
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 240
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        performSegue(withIdentifier: "FirstSegue", sender: vc)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue,
                          sender _: Any?) {
        let vc = segue.destination as! MovieDetailViewController
        let movieIndex = table.indexPathForSelectedRow?.row
        vc.movie = movies[movieIndex!]
    }
}

// MARK: - Alamofire

extension FirstViewController {
    func fetchMovies() {
        AF.request(url, method: .get, parameters: ["sort_by": "popularity.desc"]).responseObject { (response:
            DataResponse<SearchResponse>) in
        print("response is: \(response)")
        switch response.result {
        case let .success(value):
            let searchResponse = value
            if searchResponse.results != nil {
                self.movies = (searchResponse.results)!.sorted {
                    $1.rating! < $0.rating!
                }
            } else {
                self.movies = [Movie]()
            }
            self.table.reloadData()
        case .failure:
            self.movies = [Movie]()
            self.table.reloadData()
        }
        }
    }

    func performSearch(for _: String) {}
}
