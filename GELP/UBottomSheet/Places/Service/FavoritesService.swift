//
//  FavoritesService.swift
//  UBottomSheet
//
//  Created by Gurpal Bhoot on 11/9/18.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit
import CoreData

class FavoritesService {
    
    static let instance = FavoritesService()
    
    private var favoritePlaces = [Favorite]()
    
    func addNewPlace(withPlaceName: String) {
        self.save(create: true, mTitle: withPlaceName) { (success) in
            if success {
                print("Created and saved")
            }
        }
    }
    
    func removePlace(withIndex: Int) {
        self.delete(index: withIndex) { (success) in
            if success {
                print("Deleted and saved")
            }
        }
    }
    
    func returnPlaces() -> [Favorite] {
        fetchCoreDataObjects()
        
        return favoritePlaces
    }
    
    
    func delete(index: Int, completion: CompletionHand) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(favoritePlaces[index])
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func save(create: Bool, mTitle: String?, completion: CompletionHand) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        if create {
            guard let title = mTitle else { return }
            let place = Favorite(context: managedContext)
            
            place.placeName = title
        }
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }


    func fetchCoreDataObjects() {
        self.fetch { (success) in
            if success {
                print("Successfully fetched data")
            }
        }
    }
    
    func fetch(completion: CompletionHand) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        
        do {
            favoritePlaces = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
}
