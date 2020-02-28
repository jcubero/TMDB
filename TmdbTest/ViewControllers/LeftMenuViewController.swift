//
//  LeftMenuViewController.swift
//  TmdbTestJoaquin
//
//  Created by Joaquin Cubero on 2/25/20.
//  Copyright © 2020 Joaquin Cubero. All rights reserved.
//

import UIKit
import SideMenu

class LeftMenuViewController: SideMenuNavigationController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var options = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        options.append("Watch History")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let menu = navigationController as? SideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
        
        // Set up a cool background image for demo purposes
        let imageView = UIImageView(image: #imageLiteral(resourceName: "UnLike"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.backgroundView = imageView
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
        return 1
    }

       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = UITableViewVibrantCell()
        cell.textLabel?.text = options[indexPath.row]
        if let menu = navigationController as? SideMenuNavigationController {
            cell.blurEffectStyle = menu.blurEffectStyle
        }
        return cell
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
