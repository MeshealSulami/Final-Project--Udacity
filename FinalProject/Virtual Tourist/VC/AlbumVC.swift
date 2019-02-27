//
//  ViewController1.swift
//  Virtual Tourist
//
//  Created by Shan'ana Fire on 08/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AlbumVC: UIViewController, MKMapViewDelegate  {
    private let reuseIdentifier = "PhotoCell"

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicatoor: UIActivityIndicatorView!
    
    @IBOutlet weak var newCollectionbutton: UIButton!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    private let persistanContainter = NSPersistentContainer(name: "Photo")
    var selectedPin : Pin!
    var photoData : [Photo] = [Photo]()
    var selectedIndexPaths = [NSIndexPath]()
    var photosSelected = false
    var currentPage = 0
    
    var presentingAlert = false
    var pin: Pin?
    var fetchedResultsController: NSFetchedResultsController<Photo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        debugPrint("Selected pin location: \(String(describing: selectedPin))")
        
        fetchPhotos()
        
        let space: CGFloat = 3.0
        let viewWidth = self.view.frame.width
        let dimension: CGFloat = (viewWidth-(2*space))/3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func getFlickrPhotos(page: Int){
        activityIndicatoor.startAnimating()
        
        FlickrClient.sharedInstance.getImagesFromFlickr(selectedPin, currentPage) { (results, error) in
            
            guard error == nil else {
                self.displayAlert(title: "Unable to get photos from Flickr", message: error?.localizedDescription)
                return
            }
            performUIUpdatesOnMain {
                if results != nil {
                    self.photoData = results!
                    
                    print("\(self.photoData.count) photos from Flickr fetched")
                    self.collectionView.reloadData()
                    self.activityIndicatoor.stopAnimating()
                }
            }
        }
    }
    
    func removePhotos() {
        
        if selectedIndexPaths.count > 0 {
            for indexPath in selectedIndexPaths {
                let photo = photoData[indexPath.row]
                CoreData.getContext().delete(photo)
                self.photoData.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath as IndexPath])
                print("Photo at row \(indexPath.row) was deleted")
            }
            CoreData.saveContext()
        }
        selectedIndexPaths = [NSIndexPath]()
    }
    
    @IBAction func newCollectionPressed(_ sender: Any) {
        if photosSelected {
            removePhotos()
            collectionView.reloadData()
            photosSelected = false
            newCollectionbutton.setTitle("New Collection", for: .normal)
        } else {
            for photo in photoData {
                CoreData.getContext().delete(photo)
            }
            CoreData.saveContext()
            currentPage += 1
            getFlickrPhotos(page: currentPage)
            
        }
    }
    
}
extension AlbumVC {
    
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        let lat = CLLocationDegrees(selectedPin.latitude)
        let lon = CLLocationDegrees(selectedPin.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.coordinate = coordinate
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension AlbumVC: NSFetchedResultsControllerDelegate {
    
    func fetchPhotos(){
        
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin = %@", selectedPin!)
        let context = CoreData.getContext()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        if let data = fetchedResultsController.fetchedObjects, data.count > 0 {
            print("\(data.count) photos from core data fetched.")
            photoData = data
            collectionView.reloadData()
        } else {
            getFlickrPhotos(page: currentPage)
        }
    }
}


extension AlbumVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let flickrCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let photo = photoData[indexPath.row]
        
        flickrCell.imageView.image = UIImage(named: "placeholder")
        flickrCell.activityIndicator.startAnimating()

        
        if photo.imageData != nil {
            performUIUpdatesOnMain {
                flickrCell.activityIndicator.stopAnimating()

            }
            flickrCell.imageView.image = UIImage(data: photo.imageData! as Data)
        } else {
            
            FlickrClient.sharedInstance.getDataFromUrl(photo.urlString!) { (results, error) in
                guard let imageData = results else {
                    self.displayAlert(title: "Image data error", message: error)
                    return
                }
                
                performUIUpdatesOnMain {
                    photo.imageData = imageData as NSData?
                    flickrCell.activityIndicator.stopAnimating()
                    flickrCell.imageView.image = UIImage(data: photo.imageData! as Data)
                }
            }
        }
        
        if selectedIndexPaths.index(of: indexPath as NSIndexPath) != nil {
            flickrCell.imageView.alpha = 0.25
        } else {
            flickrCell.imageView.alpha = 1.0
        }
        
        return flickrCell
    }
}


extension AlbumVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        let index = selectedIndexPaths.index(of: indexPath as NSIndexPath)
        
        if let index = index {
            selectedIndexPaths.remove(at: index)
            cell.imageView.alpha = 1.0
        } else {
            selectedIndexPaths.append(indexPath as NSIndexPath)
            print(selectedIndexPaths)
            selectedIndexPaths.sort{$1.row < $0.row}
            print("Selected IndexPaths: \(selectedIndexPaths)")
            
            cell.imageView.alpha = 0.25
        }
        
        if selectedIndexPaths.count > 0 {
            newCollectionbutton.setTitle("Delete", for: .normal)
            photosSelected = true
            
        } else {
            newCollectionbutton.setTitle("New Collection", for: .normal)
            photosSelected = false
            
        }
    }
}

