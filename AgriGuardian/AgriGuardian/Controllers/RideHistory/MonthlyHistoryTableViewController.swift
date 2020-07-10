//
//  MonthlyHistoryTableViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class MonthlyHistoryTableViewController: UITableViewController {
    var thisRideMonth = RideMonth()
    var device: Device = Device()
    var rideHistory = RideHistory()
    var yearIndex = 0
    var monthIndex = 0
    

    override func viewDidLoad() {
        print("VIEWDIDLOAD FOR THE MONTHLY!!!!!!!!!!")
        super.viewDidLoad()
        print("11111111111")
        setupNavBar()
        print("222222222222")
        let nib = UINib(nibName: "RideTableViewCell", bundle: nil)
        print("333333333333")
        self.tableView.register(nib, forCellReuseIdentifier: "RideCell")
        print("!!!!!!!!!!!!VIEWDIDLOAD FOR THE MONTHLY!!!!!!!!!!")

    }
    private func setupNavBar() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = filterButton
        self.title = "Ride History"
        
        // automatically scroll to most selected month
        // row: 3 cause bug.. need to fix so that it's dynamic... set to 0 temporarily
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
//        cell.vehicleNameLabel = thisRideMonth.rides[indexPath.row].
        cell.vehicleNameLabel.text = self.device.getVehicleName()
        cell.deviceNameLabel.text = self.device.getDeviceName()
//        cell.dateLabel.text = self.thisRideMonth.rides[indexPath.row].getDate()
//        cell.mileageLabel.text = self.thisRideMonth.rides[indexPath.row].getMileage() + " MI"
        cell.dateLabel.text = rideHistory.getMonths(yearIndex: yearIndex)[indexPath.section].rides[indexPath.row].getDate()
        cell.mileageLabel.text = rideHistory.getMonths(yearIndex: yearIndex)[indexPath.section].rides[indexPath.row].getMileage()
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ride = thisRideMonth.getRide(rideIndex: indexPath.row)
        print("Device ID:")
        print(ride.devIdx)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "RideDetailView") as! RideDetailCollectionViewController
        vc.thisRide = thisRideMonth.getRide(rideIndex: indexPath.row)
        vc.thisDevice = self.device
        vc.title = thisRideMonth.getRide(rideIndex: indexPath.row).getDate()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
