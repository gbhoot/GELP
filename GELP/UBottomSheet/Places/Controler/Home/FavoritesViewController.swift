//
//  FavoritesViewController.swift
//  UBottomSheet
//
//  Created by Gurpal Bhoot on 11/9/18.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    var favoritePlaces = [Favorite]()
    @IBOutlet weak var favoritesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoritePlaces = FavoritesService.instance.returnPlaces()
    }
    
    func setupView() {
        favoritesTV.delegate = self
        favoritesTV.dataSource = self
        favoritesTV.reloadData()
    }
    
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteCell else { return UITableViewCell() }
        
        let place = favoritePlaces[indexPath.row]
        cell.configureCell(index: indexPath.row-1, name: place.placeName!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
