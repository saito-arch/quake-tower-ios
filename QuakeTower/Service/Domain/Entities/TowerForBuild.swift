//
//  TowerForBuild.swift
//  QuakeTower
//
//  Created by Saito on 2024/03/07.
//

import Foundation

struct TowerForBuild: Entity {
    let prefectureId: Int
    let latitude: Double
    let longitude: Double

    func toDictionary() -> [String: Any] {
        return [
            "prefectureId": prefectureId,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}
