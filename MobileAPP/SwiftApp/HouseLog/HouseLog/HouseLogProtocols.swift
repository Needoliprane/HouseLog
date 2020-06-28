//
//  HouseLogProtocols.swift
//  HouseLog
//
//  Created by Arthur Boulliard on 17/06/2020.
//  Copyright © 2020 Arthur Boulliard. All rights reserved.
//

import Foundation

protocol HouseLogSensorDelegate {
    func sensorUpdate(_ state: SensorState)
}

protocol HouseLogCellDelegate {
    func placingSensor(indexPath:)
}
