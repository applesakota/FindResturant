//
//  FoodPlacesViewController.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 7/14/22.
//

import UIKit
import MapKit

class FoodPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Globals
    class var identifier: String { return "FoodPlacesViewController" }
    
    @IBOutlet weak var navigationBackgroundView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [ResturantResults.ResturantModel] = []
    
    class func instantiate(data: [ResturantResults.ResturantModel]) -> FoodPlacesViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! FoodPlacesViewController
        viewController.dataSource = data
        return viewController
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareThemeAndLocalization()
        prepareNavigationBarTheme()
    }
    
    // MARK: - Utils
    
    func prepareThemeAndLocalization() {
        
        for resturant in dataSource {
            self.mapView.configureMapMarker(for: resturant)
        }
        if !dataSource.isEmpty {
         self.mapView.centerToLocation(dataSource.last!)
        }
    }
    
    private func prepareNavigationBarTheme() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        self.navigationBackgroundView.backgroundColor = .white
    }
    
    
    private func presentPlaceDetail(with place: ResturantResults.ResturantModel) {
        DispatchQueue.main.async {
            let viewController = PlaceDetailViewController.instantiate(with: place)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK: - TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeeCloselyFoodTableViewCell.identifier, for: indexPath) as! SeeCloselyFoodTableViewCell
        cell.configure(for: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
        let place = dataSource[indexPath.row]
        self.presentPlaceDetail(with: place)
    }

}


//MARK: - MKMapView

extension MKMapView {

    func centerToLocation(_ location: ResturantResults.ResturantModel) {
        let location = CLLocationCoordinate2D(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
        let region = MKCoordinateRegion(
            center: location,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000)
        setRegion(region, animated: true)
        
    }
    
    func configureMapMarker(for location: ResturantResults.ResturantModel) {
        // Configure Marker
        let annotation = MKPointAnnotation()
        annotation.title = location.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
        self.addAnnotation(annotation)
    }
}
