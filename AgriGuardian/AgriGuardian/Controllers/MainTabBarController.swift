//
//  MainTabBarController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var chosenDevice = Device()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let historyVC = mainStoryboard.instantiateViewController(identifier: "YearlyHistoryView") as! YearlyHistoryTableViewController
        let devicesVC = mainStoryboard.instantiateViewController(identifier: "DevicesView") as! DeviceTableViewController
        let settingVC = mainStoryboard.instantiateViewController(identifier: "SettingsView")
        let homeVC = mainStoryboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        
        let historyNC = UINavigationController(rootViewController: historyVC)
        let devicesNC = UINavigationController(rootViewController: devicesVC)
        let settingsNC = UINavigationController(rootViewController: settingVC)
        let homeNC = UINavigationController(rootViewController: homeVC)
        
        historyNC.navigationBar.prefersLargeTitles = true
        devicesNC.navigationBar.prefersLargeTitles = true
        settingsNC.navigationBar.prefersLargeTitles = true
        homeNC.navigationBar.prefersLargeTitles = true
        
        historyNC.tabBarItem = UITabBarItem(title: "Rides", image: nil, tag: 0)
        devicesNC.tabBarItem = UITabBarItem(title: "Devices", image: nil, tag: 1)
        settingsNC.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 2)
        homeNC.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 3)
        
        homeVC.currDevice = chosenDevice
        
        let tabBarList = [historyNC, devicesNC, settingsNC, homeNC]
        self.viewControllers = tabBarList
        
        print("GOT IT: \(chosenDevice.name)")
        
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
