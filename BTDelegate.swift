//
//  BTDelegate.swift
//  RopaTrabajo
//
//  Created by Bear on 5/05/17.
//  Copyright © 2017 BearCreeekMining. All rights reserved.
//

import CoreBluetooth

protocol BTDelegate {
    
    func encontreUnDevicexD(_ lista: Array<CBPeripheral>)
}
