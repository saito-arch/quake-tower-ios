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
    func updateGoldAndAnnotations(gold: Int, towerAnnotations: [TowerAnnotation], buildTowerAnnotations: [BuildTowerAnnotation])
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

    @IBOutlet weak var viewTowerInfo: UIView!
    @IBOutlet weak var labelPrefecture: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelHp: UILabel!
    @IBOutlet weak var buttonExtend: UIButton!
    @IBOutlet weak var buttonReinforce: UIButton!
    @IBOutlet weak var buttonRepair: UIButton!

    lazy var indicator: UIActivityIndicatorView? = {
        UIActivityIndicatorView.instantiate(view: self.view)
    }()
    
    // MARK: - Lifecycle Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(indicator!)
    }

    // MARK: - User Actions

    @IBAction func onTouchExtendButton(_ sender: UIButton) {

    }

    @IBAction func onTouchReinforceButton(_ sender: UIButton) {

    }

    @IBAction func onTouchRepairButton(_ sender: UIButton) {

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

    func updateGoldAndAnnotations(gold: Int, towerAnnotations: [TowerAnnotation], buildTowerAnnotations: [BuildTowerAnnotation]) {
        labelGold.text = "\(gold)G"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(towerAnnotations)
        mapView.addAnnotations(buildTowerAnnotations)
    }
}

extension MainViewController: MKMapViewDelegate {
}
