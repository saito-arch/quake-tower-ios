//
//  Tower.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/27.
//

import Foundation

struct Tower: Entity {
    let id: Int
    let prefectureId: Int
    let latitude: Double
    let longitude: Double
    let hp: Int
    let maxHp: Int
    let height: Int
    let goldHour: Int
}
