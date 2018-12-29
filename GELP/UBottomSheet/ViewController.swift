//
//  ViewController.swift
//  UBottomSheet
//
//  Created by ugur on 13.08.2018.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, BottomSheetDelegate {

   @IBOutlet weak var mapView: MKMapView!
   fileprivate let locationManager = CLLocationManager()
   fileprivate var startedLoadingPOIs = false
//   fileprivate var arViewController: ARViewController!
   
   @IBOutlet weak var backView: UIView!
    @IBOutlet weak var container: UIView!
   var type :String = ""
   var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = DataService.instance.returnPlaces()[type]!
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
      
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
      locationManager.requestWhenInUseAuthorization()
    }
    
   @IBAction func BackBtnClicked(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BottomSheetViewController{
            vc.bottomSheetDelegate = self
            vc.parentView = container
            vc.type = type
        }
    }
    
    func updateBottomSheet(frame: CGRect) {
        container.frame = frame
       backView.frame = self.view.frame.offsetBy(dx: 0, dy: 15 + container.frame.minY - self.view.frame.height)
       backView.backgroundColor = UIColor.black.withAlphaComponent(1 - (frame.minY)/200)
    }
}


extension ViewController: CLLocationManagerDelegate {
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //1
      if locations.count > 0 {
         let location = locations.last!
         print("Accuracy: \(location.horizontalAccuracy)")
         
         //2
         if location.horizontalAccuracy < 100 { //Accuracy
            //3
            manager.stopUpdatingLocation()
            let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.region = region
            self.mapView.showsUserLocation = true
            // More code later...
            
            for place in places{
               let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.placeName)
               
               DispatchQueue.main.async {
                  self.mapView.addAnnotation(annotation)
               }
            }
            
         }
         
         
      }
      
      
   }
}

//extension ViewController: ARDataSource {
//   func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
//      let annotationView = AnnotationView()
//      annotationView.annotation = viewForAnnotation
//      annotationView.delegate = self
//      annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
//
//      return annotationView
//   }
//}

extension ViewController: AnnotationViewDelegate {
   func didTouch(annotationView: AnnotationView) {
      //1
      if let annotation = annotationView.annotation as? Place {
         //2
         let placesLoader = PlacesService()
         placesLoader.loadDetailInformation(forPlace: annotation) { resultDict, error in
            
            //3
            if let infoDict = resultDict?.object(forKey: "result") as? NSDictionary {
               annotation.phoneNumber = infoDict.object(forKey: "formatted_phone_number") as? String
               annotation.website = infoDict.object(forKey: "website") as? String
               
               //4
               self.showInfoView(forPlace: annotation)
            }
         }
      }
   }
   
   func showInfoView(forPlace place: Place) {
      //1
      let alert = UIAlertController(title: place.placeName , message: place.infoText, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      //2
//      arViewController.present(alert, animated: true, completion: nil)
   }
}
