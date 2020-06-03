//
//  MonthlyHistoryTableViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class MonthlyHistoryTableViewController: UITableViewController {
    var device: Device = Device()
    var rideHistory = RideHistory()
    var yearIndex = 0
    var monthIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        let nib = UINib(nibName: "RideTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "RideCell")

    }
    private func setupNavBar() {

        self.title = "Ride History"
        
        // automatically scroll to most selected month
        let indexPath = IndexPath(row: 0, section: monthIndex)
        print(monthIndex)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return rideHistory.getMonths(yearIndex: yearIndex).count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rideHistory.getMonths(yearIndex: yearIndex)[section].getRides().count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rideHistory.getMonths(yearIndex: yearIndex)[section].getMonthName()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideCell") as! RideTableViewCell
        cell.vehicleNameLabel.text = self.device.getVehicleName()
        cell.deviceNameLabel.text = self.device.getDeviceName()
        cell.dateLabel.text = rideHistory.getMonths(yearIndex: yearIndex)[indexPath.section].rides[indexPath.row].getDate()
        cell.mileageLabel.text = rideHistory.getMonths(yearIndex: yearIndex)[indexPath.section].rides[indexPath.row].getMileage()
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "RideDetailView") as! RideDetailCollectionViewController
        vc.thisRide = rideHistory.getRide(yearIndex: yearIndex, monthIndex: indexPath.section, rowIndex: indexPath.row)
        vc.thisDevice = self.device
        vc.title = rideHistory.getRide(yearIndex: yearIndex, monthIndex: indexPath.section, rowIndex: indexPath.row).getDate()
        navigationController?.pushViewController(vc, animated: true)
    }
    

   

}
