//
//  LoaderView.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/29/22.
//

import Foundation
import UIKit


final class LoaderView: UIView {
    
    private weak var owner: UIView?
    
    struct Config {
        var autoPresenter: Bool      = true
        var foregroundColor: UIColor = UIColor.black
        var backgroundColor: UIColor = UIColor.clear
        var useLargeSpinner: Bool    = true
    }
    
    /// Default Loader Config instance with predefined values.
    static var defaultLoaderConfig: Config {
        Config(
            autoPresenter:   true,
            foregroundColor: UIColor.black,
            backgroundColor: UIColor.clear,
            useLargeSpinner: true
        )
    }
    
    class func create(for view: UIView, config: Config = defaultLoaderConfig) -> LoaderView {
        
        let loader = LoaderView(frame: view.bounds)
        
        let activityIndicator: UIActivityIndicatorView
        activityIndicator = UIActivityIndicatorView(style: config.useLargeSpinner ? .large : .medium)
        activityIndicator.frame = loader.bounds
        activityIndicator.color = config.foregroundColor
        activityIndicator.startAnimating()
        loader.addSubview(activityIndicator)
        loader.backgroundColor = config.backgroundColor
        loader.isUserInteractionEnabled = true
        loader.owner = view
        
        if config.autoPresenter { loader.present() }
        return loader
    }
    
    
    func present() {
        DispatchQueue.main.async {
            if self.superview != nil {
                self.removeFromSuperview()
            }
            self.owner?.addSubview(self)
        }
    }
    
    
    func dismiss() {
        DispatchQueue.main.async {
            if self.superview != nil {
                self.removeFromSuperview()
            }
        }
    }
    
}
