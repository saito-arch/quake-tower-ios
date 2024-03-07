//
//  TowerAnnotation.swift
//  QuakeTower
//
//  Created by Saito on 2024/03/01.
//

import Foundation
import MapKit

class TowerAnnotation: MKPointAnnotation {
    let tower: Tower
    let image: UIImage?
    let identifier = "tower"

    init(tower: Tower) {
        self.tower = tower
        if tower.hp < tower.maxHp / 2 {
            self.image = UIImage(named: "TowerDamaged")
        } else {
            self.image = UIImage(named: "TowerNormal")
        }
        super.init()
        super.coordinate = CLLocationCoordinate2D(latitude: tower.latitude, longitude: tower.longitude)
    }
}
