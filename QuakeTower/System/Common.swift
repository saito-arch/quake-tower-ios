//
//  Common.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import MapKit

let IS_TESTING = { (isTesting: String?) -> Bool in
    if case let .some(value) = isTesting, value == "true" {
        return true
    }
    return false
}(ProcessInfo().environment["IS_TESTING"])

let MAX_COUNT_SIGN_IN_FAILURE = 5

let JAPAN_CENTER = CLLocationCoordinate2DMake(35, 137.5)

let INIT_HP = 3
let INIT_HEIGHT = 1

func log(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {

    var file = "NONE"

    if let fileLast = file.components(separatedBy: "/").last {
        file = fileLast.replacingOccurrences(of: ".swift", with: "")
        file = file.replacingOccurrences(of: "ViewController", with: "Vc")
        file = file.replacingOccurrences(of: "Repository", with: "Rp")
        file = file.replacingOccurrences(of: "Interactor", with: "Ir")
        file = file.replacingOccurrences(of: "Presenter", with: "Ps")
    }

    print("\(file):\(line) [\(function)]: \(message)")
}

enum Prefecture: Int, CaseIterable {
    case hokkaido = 1
    case aomori
    case iwate
    case miyagi
    case akita
    case yamagata
    case fukushima
    case ibaraki
    case tochigi
    case gunma
    case saitama
    case chiba
    case tokyo
    case kanagawa
    case niigata
    case toyama
    case ishikawa
    case fukui
    case yamanashi
    case nagano
    case gifu
    case shizuoka
    case aichi
    case mie
    case shiga
    case kyoto
    case osaka
    case hyogo
    case nara
    case wakayama
    case tottori
    case shimane
    case okayama
    case hiroshima
    case yamaguchi
    case tokushima
    case kagawa
    case ehime
    case kochi
    case fukuoka
    case saga
    case nagasaki
    case kumamoto
    case oita
    case miyazaki
    case kagoshima
    case okinawa

    func getLatMin() -> Double {
        switch self {
        case .hokkaido: 42.723890
        case .aomori: 40.532211
        case .iwate: 39.116354
        case .miyagi: 38.038424
        case .akita: 39.206426
        case .yamagata: 37.967783
        case .fukushima: 37.216334
        case .ibaraki: 36.072234
        case .tochigi: 36.464602
        case .gunma: 36.324280
        case .saitama: 35.918550
        case .chiba: 35.344948
        case .tokyo: 35.679803
        case .kanagawa: 35.356922
        case .niigata: 37.092672
        case .toyama: 36.505029
        case .ishikawa: 36.203347
        case .fukui: 35.825710
        case .yamanashi: 35.479083
        case .nagano: 35.493645
        case .gifu: 35.496690
        case .shizuoka: 34.820169
        case .aichi: 34.917858
        case .mie: 34.326776
        case .shiga: 34.946778
        case .kyoto: 35.026326
        case .osaka: 34.410775
        case .hyogo: 34.828265
        case .nara: 34.047108
        case .wakayama: 33.821220
        case .tottori: 35.377419
        case .shimane: 35.130835
        case .okayama: 34.668197
        case .hiroshima: 34.463384
        case .yamaguchi: 34.107146
        case .tokushima: 33.748974
        case .kagawa: 34.184786
        case .ehime: 33.495547
        case .kochi: 33.550350
        case .fukuoka: 33.193108
        case .saga: 33.212609
        case .nagasaki: 32.867857
        case .kumamoto: 32.258188
        case .oita: 32.906533
        case .miyazaki: 31.751355
        case .kagoshima: 31.361659
        case .okinawa: 24.283410
        }
    }

    func getLngMin() -> Double {
        switch self {
        case .hokkaido: 141.717850
        case .aomori: 140.329788
        case .iwate: 140.899988
        case .miyagi: 140.568516
        case .akita: 140.066485
        case .yamagata: 139.907579
        case .fukushima: 139.700585
        case .ibaraki: 140.283941
        case .tochigi: 139.530101
        case .gunma: 138.730653
        case .saitama: 139.098417
        case .chiba: 140.101176
        case .tokyo: 139.191553
        case .kanagawa: 139.132765
        case .niigata: 138.801844
        case .toyama: 136.961609
        case .ishikawa: 136.522990
        case .fukui: 136.144113
        case .yamanashi: 138.358349
        case .nagano: 137.756907
        case .gifu: 136.869580
        case .shizuoka: 137.882531
        case .aichi: 136.915835
        case .mie: 136.249620
        case .shiga: 135.963075
        case .kyoto: 135.450062
        case .osaka: 135.476528
        case .hyogo: 134.527584
        case .nara: 135.738753
        case .wakayama: 135.251677
        case .tottori: 133.445205
        case .shimane: 132.453559
        case .okayama: 133.542536
        case .hiroshima: 132.309166
        case .yamaguchi: 131.202819
        case .tokushima: 134.100817
        case .kagawa: 133.747997
        case .ehime: 132.574102
        case .kochi: 133.202069
        case .fukuoka: 130.554209
        case .saga: 129.930612
        case .nagasaki: 129.731421
        case .kumamoto: 130.673613
        case .oita: 131.298124
        case .miyazaki: 131.123592
        case .kagoshima: 130.380272
        case .okinawa: 122.981714
        }
    }

    func getLatMax() -> Double {
        switch self {
        case .hokkaido: 44.122730
        case .aomori: 40.815710
        case .iwate: 40.174933
        case .miyagi: 38.635639
        case .akita: 40.308553
        case .yamagata: 38.905945
        case .fukushima: 37.683618
        case .ibaraki: 36.773496
        case .tochigi: 36.958628
        case .gunma: 36.719632
        case .saitama: 36.134982
        case .chiba: 35.679734
        case .tokyo: 35.750810
        case .kanagawa: 35.492610
        case .niigata: 37.819066
        case .toyama: 36.743949
        case .ishikawa: 36.515399
        case .fukui: 36.055831
        case .yamanashi: 35.806532
        case .nagano: 36.752185
        case .gifu: 36.249466
        case .shizuoka: 35.214209
        case .aichi: 35.170887
        case .mie: 34.845427
        case .shiga: 35.471299
        case .kyoto: 35.318297
        case .osaka: 34.888401
        case .hyogo: 35.148848
        case .nara: 34.656364
        case .wakayama: 34.295248
        case .tottori: 35.495101
        case .shimane: 35.201456
        case .okayama: 35.150634
        case .hiroshima: 34.769556
        case .yamaguchi: 34.284109
        case .tokushima: 34.085430
        case .kagawa: 34.267347
        case .ehime: 33.661015
        case .kochi: 33.762061
        case .fukuoka: 33.854038
        case .saga: 33.426479
        case .nagasaki: 32.968023
        case .kumamoto: 32.979252
        case .oita: 33.213365
        case .miyazaki: 32.665174
        case .kagoshima: 31.703713
        case .okinawa: 26.834406
        }
    }

    func getLngMax() -> Double {
        switch self {
        case .hokkaido: 143.396743
        case .aomori: 141.109061
        case .iwate: 141.641247
        case .miyagi: 140.958766
        case .akita: 140.723030
        case .yamagata: 140.353561
        case .fukushima: 140.842663
        case .ibaraki: 140.575001
        case .tochigi: 140.094472
        case .gunma: 139.148059
        case .saitama: 139.625587
        case .chiba: 140.376853
        case .tokyo: 139.726592
        case .kanagawa: 139.566854
        case .niigata: 139.144383
        case .toyama: 137.498063
        case .ishikawa: 136.747857
        case .fukui: 136.609607
        case .yamanashi: 138.896591
        case .nagano: 138.140518
        case .gifu: 137.275556
        case .shizuoka: 138.208421
        case .aichi: 137.588097
        case .mie: 136.470708
        case .shiga: 136.297263
        case .kyoto: 135.751200
        case .osaka: 135.636061
        case .hyogo: 135.166056
        case .nara: 135.983985
        case .wakayama: 135.505917
        case .tottori: 134.349224
        case .shimane: 133.081437
        case .okayama: 134.145905
        case .hiroshima: 133.198401
        case .yamaguchi: 131.963031
        case .tokushima: 134.476512
        case .kagawa: 134.229131
        case .ehime: 132.972561
        case .kochi: 133.940814
        case .fukuoka: 130.806088
        case .saga: 130.315467
        case .nagasaki: 130.074362
        case .kumamoto: 130.986585
        case .oita: 131.756521
        case .miyazaki: 131.462891
        case .kagoshima: 130.926885
        case .okinawa: 128.297486
        }
    }

    func calculateCenterCoordinate() -> CLLocationCoordinate2D {
        let latLng = calculateCenterLatLng()
        return CLLocationCoordinate2D(latitude: latLng.latitude, longitude: latLng.longitude)
    }

    func calculateCenterLatLng() -> LatLng {
        LatLng(
            latitude: (self.getLatMin() + self.getLatMax()) / 2,
            longitude: (self.getLngMin() + self.getLngMax()) / 2
        )
    }

    func getRandomLatLng() -> LatLng {
        let latUnit = (getLatMax() - getLatMin()) / 100
        let lngUnit = (getLngMax() - getLngMin()) / 100
        let lat = getLatMin() + latUnit * (Double)(Int.random(in: 0...100))
        let lng = getLngMin() + lngUnit * (Double)(Int.random(in: 0...100))
        
        return LatLng(latitude: lat, longitude: lng)
    }
}

struct LatLng {
    let latitude: Double
    let longitude: Double
}

enum Command: Int {
    case build = 1
    case extend
    case reinforce
    case repair

    func calculateGold(height: Int) -> Int? {
        switch self {
        case .build:
            return Session.shared.currentAccount.goldBuildBase
        case .extend:
            if let goldExtendBase = Session.shared.currentAccount.goldExtendBase {
                let level = calculateLevel(height: height)
                return goldExtendBase * Int(powl(2.0, Double(level)))
            }
            return nil
        case .reinforce:
            if let goldReinforceBase = Session.shared.currentAccount.goldReinforceBase {
                let level = calculateLevel(height: height)
                return goldReinforceBase * Int(powl(2.0, Double(level)))
            }
            return nil
        case .repair:
            if let goldRepairBase = Session.shared.currentAccount.goldRepairBase {
                let level = calculateLevel(height: height)
                return goldRepairBase * Int(powl(2.0, Double(level)))
            }
            return nil
        }
    }

    private func calculateLevel(height: Int) -> Int {
        height / 10
    }

    func getAlertMessage(gold: Int, prefectureName: String) -> String {
        switch self {
        case .build:
            return String(format: MESSAGE_BUILD, gold, prefectureName)
        case .extend:
            return String(format: MESSAGE_EXTEND, gold)
        case .reinforce:
            return String(format: MESSAGE_REINFORCE, gold)
        case .repair:
            return String(format: MESSAGE_REPAIR, gold)
        }
    }
}
