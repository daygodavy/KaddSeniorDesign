//
//  MainTabBarController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    var chosenDevice = Device()
    var fbManager = FirebaseManager()
    var user = User()
//    var currDevice = Device()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let historyVC = mainStoryboard.instantiateViewController(identifier: "YearlyHistoryView") as! YearlyHistoryTableViewController
        let settingVC = mainStoryboard.instantiateViewController(identifier: "SettingsView") as! SettingsViewController
        let homeVC = mainStoryboard.instantiateViewController(identifier: "Dashboard") as! HomeViewController
        
        let historyNC = UINavigationController(rootViewController: historyVC)
     
        let settingsNC = UINavigationController(rootViewController: settingVC)
        let homeNC = UINavigationController(rootViewController: homeVC)
        
        historyNC.navigationBar.prefersLargeTitles = true
        settingsNC.navigationBar.prefersLargeTitles = true
        homeNC.navigationBar.prefersLargeTitles = true
        
        homeNC.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)
        historyNC.tabBarItem = UITabBarItem(title: "Rides", image: nil, tag: 1)
        settingsNC.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 2)
        
        
        // ========================================================================
        if let uid = Auth.auth().currentUser?.uid {
            self.fbManager.getUser(uid: uid) { (currUser) in
                self.user = currUser
                self.fbManager.getDevices(uid: uid) { (currDevs) in
                    self.user.devices = currDevs
                    
                    self.chosenDevice = self.loadCurrDev(devId: self.user.currentDevice.devId)
//                    self.user.currentDevice = self.chosenDevice
                    
                    // load ride history ONLY for the current device
                    // ACCOMMODATE FOR WHEN ThERE ARE NO RIDES AVAILABLE...
                    self.fbManager.getRides(devId: self.chosenDevice.devId) { (rides) in
                        self.chosenDevice.rides = rides
                        let history = self.fbManager.getRideHistory(rides: rides)
                        self.chosenDevice.rideHistory = history
                        
                        self.user.currentDevice = self.chosenDevice
                        
                        // pass data to view controllers
                        homeVC.currDevice = self.chosenDevice
                        homeVC.user = self.user
                        
                        historyVC.currDevice = self.chosenDevice
                        historyVC.user = self.user
                        
                        settingVC.currDevice = self.chosenDevice
                        settingVC.user = self.user
                        
                        let tabBarList = [homeNC, historyNC, settingsNC]
                        self.viewControllers = tabBarList
                    }
                    
                    
                    
                }
            }
        }
        // ========================================================================
        
    }
    
    
    func loadCurrDev(devId: String) -> Device {
        if !devId.isEmpty {
            // is devId exists, set current Device
            for dev in self.user.devices {
                if devId == dev.devId {
                    return dev
                }
            }
        }
        else if user.devices.count > 0 {
            return user.devices.first!
        }
        // if the user has no current device set.. no current device so set to default?
        return Device()
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
