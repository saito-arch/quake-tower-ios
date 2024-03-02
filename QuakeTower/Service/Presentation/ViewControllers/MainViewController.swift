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

    var selectedTower: Tower?

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
        if let tower = selectedTower {
            presenter?.onTouchExtendButton(tower: tower)
        }
    }

    @IBAction func onTouchReinforceButton(_ sender: UIButton) {
        if let tower = selectedTower {
            presenter?.onTouchReinforceButton(tower: tower)
        }
    }

    @IBAction func onTouchRepairButton(_ sender: UIButton) {
        if let tower = selectedTower {
            presenter?.onTouchRepairButton(tower: tower)
        }
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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        switch view.annotation {
        case let annotation as TowerAnnotation:
            let tower = annotation.tower
            selectedTower = tower
            if let prefecture = Prefecture(rawValue: tower.prefectureId) {
                labelPrefecture.text = "\(prefecture)"
            }
            labelHeight.text = String(tower.height)
            labelHp.text = "\(tower.hp)/\(tower.maxHp)"
            if let pocket = presenter?.playerInfo?.gold {
                if let cost = Command.extend.calculateGold(height: tower.height) {
                    if pocket >= cost {
                        buttonExtend.isEnabled = true
                    } else {
                        buttonExtend.isEnabled = false
                    }
                }
                if let cost = Command.reinforce.calculateGold(height: tower.height) {
                    if pocket >= cost {
                        buttonReinforce.isEnabled = true
                    } else {
                        buttonReinforce.isEnabled = false
                    }
                }
                if let cost = Command.repair.calculateGold(height: tower.height) {
                    if pocket >= cost {
                        buttonRepair.isEnabled = true
                    } else {
                        buttonRepair.isEnabled = false
                    }
                }
            } else {
                buttonExtend.isEnabled = false
                buttonReinforce.isEnabled = false
                buttonRepair.isEnabled = false
            }
            viewTowerInfo.isHidden = false

        case let annotation as BuildTowerAnnotation:
            if annotation.isEnabled {
                presenter?.onTouchBuildButton(prefecture: annotation.prefecture)
            }

        default:
            break
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        viewTowerInfo.isHidden = true
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        // TODO: fetchPlayerInfo
    }
}
