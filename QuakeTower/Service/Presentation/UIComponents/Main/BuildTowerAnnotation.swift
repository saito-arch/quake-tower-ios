//
//  BuildTowerAnnotation.swift
//  QuakeTower
//
//  Created by Saito on 2024/03/02.
//

import Foundation
import MapKit

class BuildTowerAnnotation: MKPointAnnotation {
    let prefecture: Prefecture
    let image: UIImage?

    init(prefecture: Prefecture, isEnabled: Bool) {
        self.prefecture = prefecture
        if isEnabled {
            self.image = UIImage(named: "BuildTowerEnabled")
        } else {
            self.image = UIImage(named: "BuildTowerDisabled")
        }
        super.init()
        super.coordinate = prefecture.calculateCenterCoordinate()
    }
}
