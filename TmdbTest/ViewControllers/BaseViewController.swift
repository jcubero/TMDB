//
//  BaseViewController.swift
//  TmdbTestJoaquin
//
//  Created by Joaquin Cubero on 2/24/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CoreData
import SideMenu

class BaseViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isMenu = false
    let url = "https://api.themoviedb.org/3/discover/movie?api_key=c82a2ecc048f6be2dd8a873143be57aa&"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSideMenu()

    }
    func SaverForLater(movieId: Int) {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
      request.predicate = NSPredicate(format: "id = %@", movieId)
      let context = appDelegate.persistentContainer.viewContext
      var isAdded = false
      request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                data.setValue(true, forKey: "IsLater")
                isAdded = true;
                break
            }
            if !isAdded{
                let entity = NSEntityDescription.entity(forEntityName: "MovieData", in: context)
                let newMovie = NSManagedObject(entity: entity!, insertInto: context)
                newMovie.setValue(movieId, forKey: "id")
                newMovie.setValue(false, forKey: "isLiked")
                do {
                    try context.save()
                } catch {
                   print("Failed saving")
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    private func setupSideMenu() {
        // Define the menus
        let viewController : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuViewController") as UIViewController
        
        SideMenuManager.default.leftMenuNavigationController = viewController as? SideMenuNavigationController
        SideMenuManager.default.rightMenuNavigationController = viewController as? SideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
