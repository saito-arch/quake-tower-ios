//
//  UserInfo.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/27.
//

import Foundation

struct PlayerInfo: Entity {
    let gold: Int
    let goldHour: Int
    let towers: [Tower]
    let gameInfo: GameInfo
}
