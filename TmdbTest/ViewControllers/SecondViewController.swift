//
//  SecondViewController.swift
//  TmdbTest
//
//  Created by Joaquin Cubero on 2/28/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import CoreData
import UIKit
class SecondViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    public var movieData = [MovieData]()

    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "TMDBCustomCell", bundle: nil), forCellReuseIdentifier: "TMDBCustomCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    @IBAction func PerformSort(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            movieData = movieData.sorted {
                $0.title! < $1.title!
            }
        case 1:
            movieData = movieData.sorted {
                $1.year! < $0.year!
            }
        case 2:
            movieData = movieData.sorted {
                $1.rating < $0.rating
            }
        default:
            break
        }
        table.reloadData()
    }

    func reloadData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        request.predicate = NSPredicate(format: "isLiked == YES")
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            movieData = (result as! [MovieData]).sorted {
                $1.rating < $0.rating
            }
        } catch {
            print("Failed")
        }
        table.reloadData()
    }

    func numberOfSections(in _: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("get sections")
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
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
        if movie.value(forKey: "posterUrl") != nil {
            let url = "https://image.tmdb.org/t/p/w200"
            let imageURL = movie.value(forKey: "posterUrl")! as! String
            if let url = URL(string: url + imageURL) {
                cell.posterImage.contentMode = .scaleAspectFill
                downloadImage(url: url, imageView: cell.posterImage)
            }
        }
        cell.isLiked = true
        cell.likeButton.setImage(UIImage(named: "Like"), for: UIControl.State.normal)
        cell.rating.text = String(format: "%.1f", movie.rating)
        cell.year.text = GetOnlyDateMonthYearFromFullDate(currentDateFormate: "yyyy-MM-dd", conVertFormate: "YYYY", convertDate: movie.year!) as String

        cell.callback = { () -> Void in
            self.reloadData()
        }
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 240
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("did select %d", indexPath.row)

        let vc = MovieDetailViewController()
        performSegue(withIdentifier: "SecondSegue", sender: vc)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue,
                          sender _: Any?) {
        let vc = segue.destination as! MovieDetailViewController
        let movieIndex = (table.indexPathForSelectedRow?.row)!

        vc.movie = Movie()
        let data = movieData[movieIndex]
        vc.movie.id = Int(data.id)
        vc.movie.releaseDate = data.year
        vc.movie.title = data.title
        vc.movie.posterURL = data.posterUrl
        vc.movie.sinopsis = data.sinopsis
        vc.movie.rating = data.rating
    }
}
