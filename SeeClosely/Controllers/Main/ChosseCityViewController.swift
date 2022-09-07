//
//  ChosseCityViewController.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 9/6/22.
//

import UIKit

class ChosseCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    //MARK: - Globals
    class var identifier: String { return "ChosseCityViewController" }
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [String] = ["Paris","Lisbon","Madrid","Moscow"]
    
    
    class func instantiate() -> ChosseCityViewController {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: identifier) as! ChosseCityViewController
        return viewController
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Utils
    
    //MARK: - TableView DataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCityTableViewCell.identifier, for: indexPath) as! ChooseCityTableViewCell
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func presentHome(for location: String) {
        DispatchQueue.main.async {
            let viewController = HomeViewController.instantiate(with: location)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        guard let location = sender.currentTitle else { return }
        self.presentHome(for: location)
    }
    
}

class ChooseCityTableViewCell: UITableViewCell {
    
    class var identifier: String { return "ChooseCityTableViewCell" }
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    func configure(with location: String) {
        locationImageView.image = UIImage(named: location)
        locationImageView.alpha = 0.7
        locationButton.titleLabel?.font = UIFont(name: "Noteworthy-Bold", size: 24)
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.setTitle(location, for: .normal)
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.masksToBounds = true
        
    }
}

