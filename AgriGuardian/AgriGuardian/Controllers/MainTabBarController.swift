//
//  MainTabBarController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let historyVC = mainStoryboard.instantiateViewController(identifier: "YearlyHistoryView") as! YearlyHistoryTableViewController
        let devicesVC = mainStoryboard.instantiateViewController(identifier: "DevicesView") as! DeviceTableViewController
        let settingVC = mainStoryboard.instantiateViewController(identifier: "SettingsView")
        
        let historyNC = UINavigationController(rootViewController: historyVC)
        let devicesNC = UINavigationController(rootViewController: devicesVC)
        let settingsNC = UINavigationController(rootViewController: settingVC)
        
        historyNC.navigationBar.prefersLargeTitles = true
        devicesNC.navigationBar.prefersLargeTitles = true
        settingsNC.navigationBar.prefersLargeTitles = true
        
        historyNC.tabBarItem = UITabBarItem(title: "Rides", image: nil, tag: 0)
        devicesNC.tabBarItem = UITabBarItem(title: "Devices", image: nil, tag: 1)
        settingsNC.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 2)
        
        let tabBarList = [historyNC, devicesNC, settingsNC]
        self.viewControllers = tabBarList
        
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
