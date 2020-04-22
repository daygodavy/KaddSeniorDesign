//
//  YearlyHistoryTableViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class YearlyHistoryTableViewController: UITableViewController {
    var dataManager = DataManager()
    var fbManager = FirebaseManager()
    var user = User()
    var rideHistory = RideHistory()
    var devices = [Device]()
    var currDevice = Device()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
//        user = dataManager.loadSampleData()
//        currDevice = user.currentDevice
//        rideHistory = currDevice.rideHistory
        fbManager.loadUserProfile { currUser in
            self.user = currUser
            self.currDevice = self.user.currentDevice // must string match devId to find it
            self.rideHistory = self.currDevice.rideHistory
            let nib = UINib(nibName: "MonthHistoryTableViewCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "MonthCell")
            self.tableView.reloadData()
        }
    }
    // MARK: - Private functions
    private func setupNavBar() {
        self.navigationItem.title = "Trip History"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return rideHistory.getYears().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rideHistory.getMonths(yearIndex: section).count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rideHistory.getYearName(yearIndex: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthCell") as! MonthHistoryTableViewCell
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MonthlyHistoryView") as! MonthlyHistoryTableViewController
        vc.title = "Sec: \(indexPath.section) Row: \(indexPath.row)"
        vc.thisRideMonth = rideHistory.getMonth(yearIndex: indexPath.section, monthIndex: indexPath.row)
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
