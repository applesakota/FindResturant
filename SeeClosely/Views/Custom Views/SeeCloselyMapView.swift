//
//  SeeCloselyMapView.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 7/7/22.
//

import UIKit
import MapKit

final class SeeCloselyMapView: UIView, UITextFieldDelegate {
    
    //MARK: - Globals
    
    static var nibName: String { return "SeeCloselyMapView" }
    
    @IBOutlet weak var mapView: MKMapView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        let view = loadNibFromView()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        insertSubview(view, at: 0)
        
    }
    
    func loadNibFromView() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: SeeCloselyMapView.nibName, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func set(location: String?) {
        self.isHidden = true
        
        guard let location = location else {
            return
        }

        CLGeocoder().geocodeAddressString(location) { placemarks, error in
            if let coordinate = placemarks?.first?.location?.coordinate {
                self.configureMapMarker(for: coordinate, location: location)
            }
        }
    }

    
    
    private func configureMapMarker(for coordinate: CLLocationCoordinate2D, location: String) {
        DispatchQueue.main.async {
            // Configure map.
            self.mapView.camera = MKMapCamera(
                lookingAtCenter: coordinate,
                fromDistance: 400,
                pitch: 30,
                heading: 0
            )
            
            // Configure marker.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location
            self.mapView.addAnnotation(annotation)

            self.isHidden = false
        }
    }
}

