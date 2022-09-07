//
//  PlaceDetailViewController.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 8/28/22.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    //MARK: - Globals
    static var identifier: String { return "PlaceDetailViewController" }
    
    @IBOutlet weak var navigationBackgroundView: UIView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeDescriptionTitle: UILabel!
    @IBOutlet weak var placeDescriptionValue: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    private(set) var place: ResturantResults.ResturantModel!
    
    class func instantiate(with place:  ResturantResults.ResturantModel) -> PlaceDetailViewController {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: identifier) as! PlaceDetailViewController
        viewController.place = place
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareNavigationBarTheme()
        self.prepareThemeAndLocalization()
    }
    
    
    func prepareNavigationBarTheme() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        self.navigationBackgroundView.backgroundColor = .white
        
    }
    
    func prepareThemeAndLocalization() {
        placeImageView.image = place.originalImage
        placeTitle.text = place.name
        placeDescriptionTitle.text = "Description"
        placeDescriptionValue.text = place.intro
        ratingLabel.text = place.formattedScore
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionView.collectionViewLayout = layout
        
    }

}
//MARK: UICollectionViewDelegate, UICOllectionViewDataSource

extension PlaceDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return place.tagLabels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceViewCell", for: indexPath) as! PlaceViewCell
        guard let model = place.tagLabels?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = model
        cell.setTheme()
        return cell
    }
}
    
// MARK: - HomeCollectionViewCell

class PlaceViewCell: UICollectionViewCell {
    
    class var identifier: String { return "PlaceViewCell" }
    @IBOutlet weak var titleLabel: UILabel!
    
    func setTheme() {
        titleLabel.textColor = UIColor.black
        self.backgroundColor = UIColor.orange
        self.layer.cornerRadius = 20
    }
}
