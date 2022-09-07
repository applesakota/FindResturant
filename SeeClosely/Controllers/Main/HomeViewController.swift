//
//  HomeViewController.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 5/27/22.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Globals
    
    class var identifier: String { return "HomeViewController" }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var location: String!
    
    class func instantiate(with location: String) -> HomeViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! HomeViewController
        viewController.location = location
        return viewController
    }
    
    var dataSource: [TagModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var resturantsDataSource: [ResturantResults.ResturantModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apiFetchAllTags(location: location) { tags in
            self.dataSource = tags
        }
        self.apiFetchAllResturants(location: location) { resturants in
            self.resturantsDataSource = resturants
        }
        prepareThemeAndLocalization()
    }
    
    //MARK: - Utils
    
    private func prepareThemeAndLocalization() {
        // Theme
        self.tableView.backgroundColor = UIColor.systemGray6
        self.tableView.layer.cornerRadius = 20
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionView.collectionViewLayout = layout
    }

    //MARK: - API
    
    private func apiFetchAllTags(location: String, callback: @escaping ([TagModel])->Swift.Void )  {
        let loader = LoaderView.create(for: self.view)
        AppGlobals.restManager.getAllTags(location: location) { result in
            loader.dismiss()
            switch result {
            case .success(let model): callback(model)
            case .failure: break
            }
        }
        
    }
    
    private func apiFetchAllResturants(location: String, callback: @escaping ([ResturantResults.ResturantModel])->Swift.Void ) {
        let loader = LoaderView.create(for: self.view)
        AppGlobals.restManager.getAllResturants(location: location) { result in
            loader.dismiss()
            switch result {
            case .success(let model): callback(model)
            case .failure: break
            }
        }
    }
    
    private func apiFetchAllResturantsByTag(location: String, for tag: String, callback: @escaping ([ResturantResults.ResturantModel])->Swift.Void) {
        let loader = LoaderView.create(for: self.view)
        AppGlobals.restManager.getAllResturansByTag(location: location, for: tag) { result in
            loader.dismiss()
            switch result {
            case .success(let model): callback(model)
            case .failure: break
            }
        }
    }
    
    private func presentFoodPlaces(with data: [ResturantResults.ResturantModel]) {
        DispatchQueue.main.async {
            let viewController = FoodPlacesViewController.instantiate(data: data)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func presentPlaceDetail(with place: ResturantResults.ResturantModel) {
        DispatchQueue.main.async {
            let viewController = PlaceDetailViewController.instantiate(with: place)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK: - DataSources / Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceViewCell", for: indexPath) as! PlaceViewCell
        let model = dataSource[indexPath.row]
        cell.titleLabel.text = model.name
        cell.setTheme()
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let tag = dataSource[indexPath.row].label
        self.apiFetchAllResturantsByTag(location: location, for: tag) { model in
            print(model)
            self.presentFoodPlaces(with: model)
        }
    }
}

//MARK: - TableViewDelegate TableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resturantsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeeCloselyFoodTableViewCell.identifier, for: indexPath) as! SeeCloselyFoodTableViewCell
        cell.configure(for: resturantsDataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let place = resturantsDataSource[indexPath.row]
        self.presentPlaceDetail(with: place)
    }
}

// MARK: - HomeCollectionViewCell

class HomeViewCell: UICollectionViewCell {
    
    class var identifier: String { return "HomeViewCell" }

    @IBOutlet weak var titleLabel: UILabel!
    
    func setTheme() {
        titleLabel.textColor = UIColor.black
        self.backgroundColor = UIColor.orange
        self.layer.cornerRadius = 20
    }
}

//MARK: - SeeCloselyFoodTableViewCell

class SeeCloselyFoodTableViewCell: UITableViewCell {

    class var identifier: String { return "SeeCloselyFoodTableViewCell" }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func configure(for model: ResturantResults.ResturantModel) {
        print(model)
        titleLabel.text = model.name
        descriptionLabel.text = model.tagLabel
        iconImageView.image = model.thumbnailImage
        ratingLabel.text = model.formattedScore
        priceLabel.text = "$$"
        timeLabel.text = "35min"
    }
}



