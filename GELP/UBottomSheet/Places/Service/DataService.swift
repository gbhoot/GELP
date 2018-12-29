//
//  Places.swift
//  Places
//
//  Created by Kim Do on 11/8/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import UIKit
import CoreLocation

class DataService{
  
  static let instance = DataService()
  
  private var places = [String: [Place]]()
  
  func addPlace(place: Place, type: String) {
    if var _ = places[type] {
      places[type]!.append(place)
    } else {
      places[type] = [Place]()
      places[type]?.append(place)
    }
  }
   
   func addPhotosToPlace(withType type: String, index: Int, andImage image: UIImage) {
      places[type]![index].photos.append(image)
   }
  
  func returnPlaces() -> [String: [Place]] {
    return places
  }
}

