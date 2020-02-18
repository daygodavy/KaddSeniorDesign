//
//  PeripheralViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/16/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralViewController: UIViewController {
    
    // MARK: - Properties
    var centralManager: CBCentralManager!
    var raspberryPiPeripheral: CBPeripheral!
    var tempCharacteristic: CBUUID!
    let raspberryPi = CBUUID(string: "27cf08c1-076a-41af-becd-02ed6f6109b9")
    
    var datagrams = [Datagram]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)



        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PeripheralViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [raspberryPi])

        }


    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
      print(peripheral)
        raspberryPiPeripheral = peripheral
        raspberryPiPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(raspberryPiPeripheral, options: nil)
        
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected Bitch!")
        raspberryPiPeripheral.discoverServices(nil)

    }
}

extension PeripheralViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
          print(service)
          peripheral.discoverCharacteristics(nil, for: service)

        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print(characteristic)
            tempCharacteristic = characteristic.uuid
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)

            }
            if characteristic.properties.contains(.notify) {
              print("\(characteristic.uuid): properties contains .notify")
            }
            if characteristic.properties.contains(.write) {
              print("\(characteristic.uuid): properties contains .write")
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        switch characteristic.uuid {
            case tempCharacteristic:
                print(characteristic.value ?? "no value")
                let message = Message(key: 0, data: characteristic.value!)

                if let datagram = Datagram.decode(characteristic.value!) {
                    datagrams.append(datagram)
                    print(datagram.payload)
                    let offset = datagram.header.offset
                    peripheral.readValue(for: characteristic)
    //                let data = withUnsafeBytes(of: offset?.littleEndian) { Data($0) }
    //                peripheral.writeValue(data, for: characteristic, type: .withResponse)
                    print("offset: \(String(describing: offset))")
                } else {
                    print("NO MORE DATAGRAMS")
                    var reconstructed: Message?
                    let manager = MessageManager { message in
                        reconstructed = message
                    }
                    for datagram in datagrams {
                        try! manager.process(datagramData: datagram.encoded)
                    }
                    let str = String(decoding: reconstructed!.data, as: UTF8.self)
                    print("Success")

            }
                


//        let str = String(decoding: value, as: UTF8.self)
//        print("Data being read from pi: \(str)")
          
          
        default:
          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }


}
