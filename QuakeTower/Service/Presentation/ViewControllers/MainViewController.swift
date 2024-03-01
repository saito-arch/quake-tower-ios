//
//  MainViewController.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/27.
//

import Foundation
import UIKit
import MapKit

protocol MainUserInterface: UserInterface, Alertable where Presenter: MainPresentation {
    func showIndicator()
    func hideIndicator()
}

class MainViewController: UIViewController {
    
    var presenter: Presenter?

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            self.mapView.delegate = self
            var region: MKCoordinateRegion = mapView.region
            region.center = JAPAN_CENTER
            mapView.setRegion(region, animated: false)
        }
    }

    @IBOutlet weak var labelGold: UILabel!

    lazy var indicator: UIActivityIndicatorView? = {
        UIActivityIndicatorView.instantiate(view: self.view)
    }()
    
    // MARK: - Lifecycle Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(indicator!)
    }
}

extension MainViewController: MainUserInterface {

    typealias Presenter = MainPresenter<MainViewController, MainInteractor, MainRouter>

    func set(presenter: Presenter) {
        self.presenter = presenter
    }

    func showIndicator() {
        self.indicator?.startAnimating()
    }

    func hideIndicator() {
        self.indicator?.stopAnimating()
    }
}

extension MainViewController: MKMapViewDelegate {
}
