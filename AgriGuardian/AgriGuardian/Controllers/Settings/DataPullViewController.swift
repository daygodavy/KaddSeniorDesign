//
//  DataPullViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 4/25/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//
// TODO: Implement Bluetooth transfer

import UIKit
import CoreBluetooth

class DataPullViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var atvImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var centralManager: CBCentralManager!
    var raspberryPiPeripheral: CBPeripheral!
    var tempCharacteristic: CBUUID!
    let raspberryPi = CBUUID(string: "27cf08c1-076a-41af-becd-02ed6f6109b9")
    var datagrams = [Datagram]()
  
    var data: String?
    // MARK: - Actions
    @IBAction func didTapStart(_ sender: Any) {
        atvImage.isHidden = false
        statusLabel.text = "Connecting..."
        startButton.setTitle("Stop", for: .normal)
        animateAtv()
        centralManager.scanForPeripherals(withServices: [raspberryPi])

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        presentBasicAlert(title: "Initiating data transfer", message: "Please make sure device is on and in range") {
             
         }

    }
    
    // MARK: - Private Functions
    
    fileprivate func setupViews() {
        buttonView.layer.cornerRadius = buttonView.frame.size.width / 2
        startButton.layer.cornerRadius = startButton.frame.size.width / 2
        atvImage.isHidden = true
        statusLabel.text = "Press start to begin."
    }
    
    fileprivate func animateAtv() {
        let orbit = CAKeyframeAnimation(keyPath: "position")
        var affineTransform = CGAffineTransform(rotationAngle: 0.0)
        affineTransform = affineTransform.rotated(by: .pi)
        let arcCenter = self.view.center
        
        let radius = self.buttonView.frame.size.width / 2 + 12
  
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        orbit.path = circlePath.cgPath
        orbit.duration = 4
        orbit.repeatCount = 100
        orbit.calculationMode = CAAnimationCalculationMode.paced
        orbit.rotationMode = CAAnimationRotationMode.rotateAuto

        atvImage.layer.add(orbit, forKey: "orbit")
    }
    // MARK: - Private Functions
    /**
    Repeatedly reads datagrams from pi until a FYN (datagram key == 6) is read. Upon reading FYN, datagrams are stopped being read and an AWK message is written to the pi to acknowledge that all datagrams have been recieved

    - Parameter characteristic: characteristic being used from pi
    - Parameter peripheral: peripheral of the pi uuid


    - Returns: Nothing for now.
    */
    fileprivate func processDatagrams(_ characteristic: CBCharacteristic, _ peripheral: CBPeripheral) {
        // check for nil data
        guard let charVal = characteristic.value else {
            fatalError("Unexpectedly found nil when unwrapping characteristic value")
        }
        // check for nil datagram
        if let datagram = Datagram.decode(charVal) {
            // all message datagrams have key of 0
            if (datagram.header.key == UInt(0)) {
                datagrams.append(datagram)
                peripheral.readValue(for: characteristic)
            } else {
                // send ack - write back to pi
                let ack = Data("ACK".utf8)
                peripheral.writeValue(ack, for: characteristic, type: .withResponse)
                
                // reconsruct datagrams into message
                var reconstructed: Message?
                let manager = MessageManager { message in
                    reconstructed = message
                }
                for datagram in datagrams {
                    try! manager.process(datagramData: datagram.encoded)
                }
                // temp string storing message contents
                data = String(decoding: reconstructed!.data, as: UTF8.self)
                print(data)
                
                // TODO: parse data and send to firebase
            }
            
        } else {
            print("ERROR")
        }
    }
}

extension DataPullViewController: CBCentralManagerDelegate {
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

        @unknown default:
            fatalError("Unknown Peripheral State")
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
        statusLabel.text = "Connected!"
        raspberryPiPeripheral.discoverServices(nil)

    }
}

extension DataPullViewController: CBPeripheralDelegate {
    
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
                processDatagrams(characteristic, peripheral)
        default:
          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
}

