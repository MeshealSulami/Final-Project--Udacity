//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Shan'ana Fire on 26/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TouristVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var pinAnnotation: MKPointAnnotation? = nil
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    @IBOutlet weak var pinText: UILabel!
    
    var editLabel = false

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        performUIUpdatesOnMain {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.loadAnnotations()
        }
    }
    
    @IBAction func editPressed(_ sender: Any) {
        editLabel = !editLabel
        
        if editLabel {
            editButton.title = "Done"
            mapView.frame.origin.y -= 50
            pinText.isHidden = false
            
        } else {
            editButton.title = "Edit"
            mapView.frame.origin.y = 0
            pinText.isHidden = true
            
        }
    }
    
  
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            
            let location = sender.location(in: mapView)
            let newCoordinates = mapView.convert(location, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            addedPinSaved(lat: newCoordinates.latitude, lon: newCoordinates.longitude)
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    func addedPinSaved(lat: Double, lon: Double) {
        let context = CoreData.getContext()
        let pin : Pin = NSEntityDescription.insertNewObject(forEntityName: "Pin", into: context) as! Pin
        
        pin.latitude = lat
        pin.longitude = lon
        
        CoreData.saveContext()
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotoAlbumVC" {
            let controller = segue.destination as! AlbumVC
            let selectedPin = sender as! Pin
            controller.selectedPin = selectedPin
        }
    }
}


extension TouristVC {
    
    func loadAnnotations() {
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
            let searchResults = try CoreData.getContext().fetch(fetchRequest)
            print("There are \(searchResults.count) locations")
            var annotations = [MKPointAnnotation]()
            for result in searchResults as [Pin] {
                
                let lat = CLLocationDegrees(result.latitude)
                let long = CLLocationDegrees(result.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotations.append(annotation)
                
            }
            performUIUpdatesOnMain {
                self.mapView.addAnnotations(annotations)
                print("Annotations added to the map view.")
            }
        }
        catch {
            print("Error fetching annotations: \(error)")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        let lat = view.annotation?.coordinate.latitude
        let lon = view.annotation?.coordinate.longitude
        print("The selected pin's lat:\(String(describing: lat)), lon:\(String(describing: lon))")
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            let searchResults = try CoreData.getContext().fetch(fetchRequest)
            for pin in searchResults as [Pin] {
                if pin.latitude == lat!, pin.longitude == lon! {
                    let selectedPin = pin
                    print("Found pin info.")
                    if editLabel {
                        performUIUpdatesOnMain {
                            
                            CoreData.getContext().delete(selectedPin)
                            CoreData.saveContext()
                            self.mapView.removeAnnotation(view.annotation!)
                            print("Deleted the selected pin.")
                            
                        }
                    } else {
                        print("Perform segue to the photo album.")
                        performUIUpdatesOnMain {
                            self.performSegue(withIdentifier: "ShowPhotoAlbumVC", sender: selectedPin)
                        }
                    }
                }
            }
        }catch {
            print("Error: \(error)")
        }
    }
}


    

    

