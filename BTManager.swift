//
//  BTManager.swift
//  RopaInteligente
//
//  Created by Gustavo Herminio Lapa Velásquez on 8/01/17.
//  Copyright © 2017 BearCreekMining. All rights reserved.
//

import UIKit
import CoreBluetooth

let BLEServiceUUID = CBUUID(string: "713D0000-503E-4C75-BA94-3148F18D941E")
let characterTx = CBUUID(string: "713D0002-503E-4C75-BA94-3148F18D941E")
let characterRx = CBUUID(string: "713D0003-503E-4C75-BA94-3148F18D941E")
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"
//let btDiscoverySharedInstance = BTManager();
class BTManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var delegate : BTDelegate? // variable optional delegate
    var periferico: CBPeripheral?//variable optional periferico
    var positionCharacteristic: CBCharacteristic?//variable optional positionCharasteristic
    var centralManager: CBCentralManager?//variable optional centralManager
    var ListaPerifericos: Array<CBPeripheral> = Array<CBPeripheral>() //lista de periifericos
    
    func getLista() -> Array<CBPeripheral> {
        return ListaPerifericos //retorna lista de perifericos
    }
    /// Save the single instance
    static private var instance : BTManager {
        return sharedInstance //retorna una instancia de la clase
    }
    private static let sharedInstance = BTManager()// variable estatica que permite tener solo una instancia de la clase
    
    /**
     Singleton pattern method
     
     - returns: Bluetooth single instance
     */
    
    static func getInstance() -> BTManager {
        return instance
    }
    
    //////////////////////Descubriendo dispositivos///////////////////////
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Viendo si hay bluetooth :P")
    }
    
    func desconectando()  {
        centralManager?.cancelPeripheralConnection(periferico!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            print("State : Powered Off")
            //self.clearDevices()
            
        case .unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            break
            
        case .unknown:
            // Wait for another event
            break
            
        case .poweredOn:
            self.startScanning()
            
        case .resetting:
            print("State : reseteando ando")
            //self.clearDevices()
            
        case .unsupported:
            break
        }
    }
    
    func clearDevices() {
        //self.bleService = nil
        periferico = nil
    }
    
    func startScanning() {
        if let central = centralManager {
            central.scanForPeripherals(withServices: [BLEServiceUUID], options: nil) //busca BLEs cercanos cuyo servicio  sean del BLEServiceUUID
        }
    }
    
    func conectarDevice(periferal: CBPeripheral) {
        centralManager?.connect(periferal, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey : true])//Se connecta al Ble
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {//funcion que se ejecuta cada vez que se descubre un BLE
        ListaPerifericos.append(peripheral)//agregamos a la lista
        delegate?.encontreUnDevicexD(ListaPerifericos)//llevamos la lista a otra clase
        print(ListaPerifericos)
        print("encontre un periferico u.u")
    }
    //funcion que se ejecuta una vez que se conecta al BLE
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        periferico = peripheral//peripheral es un objeto que tiene nombre,UUID, service, estado.....
        peripheral.delegate = self
        centralManager?.stopScan()
        startDiscoveringServices()//comienza a descubrir sus servicios
    }
    //Cuando se desconecta el  BLE
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // See if it was our peripheral that disconnected
        if (peripheral == periferico) {
            //self.bleService = nil;
            //periferico = nil;
        }
        // Start scanning for new devices
        //self.startScanning()
    }
    
    //////////////////////Usando el servicio del device////////////////////////////
    func startDiscoveringServices() {
        self.periferico?.discoverServices([BLEServiceUUID])
    }
    func reset() {
        if periferico != nil {
            periferico = nil
        }
        
        // Deallocating therefore send notification
        self.sendBTServiceNotificationWithIsBluetoothConnected(false)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let uuidsForBTService: [CBUUID] = [characterRx]
        if (peripheral != self.periferico) {
            // Wrong Peripheral
            return
        }
        if (error != nil) {
            return
        }
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            // No Services
            return
        }
        for service in peripheral.services! {
            print(service)
            print("LOL")
            if service.uuid == BLEServiceUUID {
                peripheral.discoverCharacteristics(uuidsForBTService, for: service)
            }
        }
        print("OMO 3")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (peripheral != periferico) {
            // Wrong Peripheral
            return
        }
        if (error != nil) {
            return
        }
        print("OMO 4")
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print(characteristic)
                if characteristic.uuid == characterRx {
                    self.positionCharacteristic = (characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("OMO 5")
                    //print(positionCharacteristic ?? "xD")
                    // Send notification that Bluetooth is connected and all required characteristics are discovered
                    self.sendBTServiceNotificationWithIsBluetoothConnected(true)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // let value = characteristic.value
        //  let data = valu
        
        let data:Data = characteristic.value!
        print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "FUCK")
    }
    
    func writePosition(_ position: String) {
        if let positionCharacteristic = self.positionCharacteristic {
            print("OMO 7")
            //let data = Data()
            //print(data)
            periferico?.writeValue(position.data(using:String.Encoding.utf8, allowLossyConversion: true)!, for: positionCharacteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    
    /*  func readDataFromDevice(){
     periferico?.readValue(for: <#T##CBCharacteristic#>)
     }*/
    
    func sendBTServiceNotificationWithIsBluetoothConnected(_ isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NotificationCenter.default.post(name: Notification.Name(rawValue: BLEServiceChangedStatusNotification), object: self, userInfo: connectionDetails)
    }
}
