//
//  HomePageViewController.swift
//  UBottomSheet
//
//  Created by Kim Do on 11/8/18.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import AVFoundation

class HomePageViewController: UIViewController {

   // Outlets
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var alphaView: UIView!
   @IBOutlet weak var backAgainLbl: UILabel!
   @IBOutlet weak var gifView: UIImageView!
   @IBOutlet weak var partTwoLbl: UILabel!
   
   // Variables
   fileprivate let locationManager = CLLocationManager()
   fileprivate var startedLoadingPOIs = false
   fileprivate var retrievedAllObjects = false
   fileprivate var movedLabel = false
   var type = ""
   var player: AVAudioPlayer?
   let funkTheFloorStr = "funkTheFloor"
   let thunderStr = "thunder"
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.dataSource = self
      tableView.delegate   = self
      tableView.alwaysBounceVertical = false
      // Do any additional setup after loading the view.
      
      
      setupView()
      getCurrentLocation()
   }
   
   // Functions
   func setupView() {
      partTwoLbl.isHidden = true
      gifView.loadGif(name: "dancing")
      musicPlayer(songName: funkTheFloorStr, playPause: true)
   }
   
   func disableSplashElements() {
      alphaView.isHidden = true
      gifView.isHidden = true
      backAgainLbl.isHidden = true
      musicPlayer(songName: funkTheFloorStr, playPause: false)
      if !movedLabel {
         animateViewIncomingFromLeft()
      }
   }
   
   func getCurrentLocation() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
      locationManager.requestWhenInUseAuthorization()
   }
   
   func musicPlayer(songName: String, playPause: Bool) {
      if let asset = NSDataAsset(name: songName) {
         do {
            player = try AVAudioPlayer(data: asset.data, fileTypeHint: "caf")
            player?.volume = 0.7
            if playPause {
               player?.play()
            } else {
               player?.pause()
            }
         } catch let error as NSError {
            print(error.localizedDescription)
         }
      }
   }
   
   func animateViewIncomingFromLeft() {
      musicPlayer(songName: thunderStr, playPause: true)
      partTwoLbl.center.x = view.center.x
      partTwoLbl.center.x -= view.center.x
      partTwoLbl.isHidden = false
      UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseIn, animations: {
         self.partTwoLbl.center.x += self.view.center.x + 30
      }) { (success) in
         if success {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
               self.partTwoLbl.center.x -= 30
            }, completion: { (success) in
               if success {
                  self.movedLabel = true
                  self.musicPlayer(songName: self.thunderStr, playPause: false)
               }
            })
         }
      }
   }
}

extension HomePageViewController: CLLocationManagerDelegate {
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //1
      if locations.count > 0 {
         let location = locations.last!
         print("Accuracy: \(location.horizontalAccuracy)")
         
         //2
         if location.horizontalAccuracy < 100 { //Accuracy
            //3
//            manager.stopUpdatingLocation()
//           let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
//           let region = MKCoordinateRegion(center: location.coordinate, span: span)
//           mapView.region = region
            // More code later...
            
            //1
            if !startedLoadingPOIs {
               startedLoadingPOIs = true
               //2
               let loader = PlacesService()
               loader.loadPOIS(location: location, radius: 1000) { placesDict, error in
                  //3
                  if let dict = placesDict {
                     //1
                     guard let placesArray = dict.object(forKey: "results") as? [NSDictionary]  else { return }
                     //2
                     for placeDict in placesArray {
                        //3
                        let latitude = placeDict.value(forKeyPath: "geometry.location.lat") as! CLLocationDegrees
                        let longitude = placeDict.value(forKeyPath: "geometry.location.lng") as! CLLocationDegrees
                        let reference = placeDict.object(forKey: "reference") as! String
                        let name = placeDict.object(forKey: "name") as! String
                        let address = placeDict.object(forKey: "vicinity") as! String
                        
                        let location = CLLocation(latitude: latitude, longitude: longitude)
                        //4
                        let placeID = placeDict.object(forKey: "place_id") as! String
                        //got place id
                        let place = Place(location: location, reference: reference, name: name, address: address, placeID: placeID)
                        
                        if let rating : Double = placeDict.object(forKey: "rating") as? Double{
                           place.rating = rating
                        }
                        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID, callback: { (photos, error) in
                           if let error = error {
                              print("Error: \(error), \(error.localizedDescription)")
                           } else {
                              if let results = photos?.results {
                                 for result in results {
                                    self.loadImageForMetadata(photoMetada: result, completion: { (success, image) in
                                       if success {
                                          place.addImage(image: image)
                                       }
                                    })
                                 }
                              }
                              for type in placeDict["types"] as! NSArray{
                                 let typeAsString : String = type as! String
                                 DataService.instance.addPlace(place: place, type: typeAsString)
                              }
                           }
                        })
                     }
                     self.retrievedAllObjects = true
                  }
               }
            } else {
               if self.retrievedAllObjects {
                  manager.stopUpdatingLocation()
                  self.disableSplashElements()
               }
            }
         }
      }
   }
   
   func loadImageForMetadata(photoMetada: GMSPlacePhotoMetadata, completion: @escaping CompletionHandler) {
      GMSPlacesClient.shared().loadPlacePhoto(photoMetada) { (photo, error) in
         if let error = error {
            print("Error: \(error), \(error.localizedDescription)")
         } else {
            completion(true, photo!)
         }
      }
   }
   
}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate, PassData {
   
   func moveToMapVC(type: String) {
      self.type = type
      performSegue(withIdentifier: "segueToMap", sender: type)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destination = segue.destination as! ViewController
      destination.type = self.type
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CatergoryTableCell", for: indexPath) as! HomeCatergoryTableViewCell
      cell.delegate = self
//      cell.index = indexPath.row*2
      // set text label to the model that is corresponding to the row in array
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 400
   }
}
