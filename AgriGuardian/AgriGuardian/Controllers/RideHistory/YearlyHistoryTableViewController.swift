//
//  YearlyHistoryTableViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase

class YearlyHistoryTableViewController: UITableViewController {
    var dataManager = DataManager()
    var fbManager = FirebaseManager()
    var user = User()
    var rideHistory = RideHistory()
    var devices = [Device]()
    var currDevice = Device()
    var sectionIdx: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        currDevice = user.currentDevice
        rideHistory = currDevice.rideHistory
        let nib = UINib(nibName: "MonthHistoryTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MonthCell")
        self.tableView.reloadData()
        
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
        self.sectionIdx = section
        return rideHistory.getYearName(yearIndex: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Sec: \(indexPath.section) Row: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthCell") as! MonthHistoryTableViewCell
        cell.monthLabel.text! = "\(rideHistory.getMonthName(yearIndex: self.sectionIdx, monthIndex: indexPath.item))"
        cell.rideCountLabel.text! = "\(String(rideHistory.years[self.sectionIdx].months[indexPath.item].rides.count))"
        cell.timeLabel.text! = rideHistory.years[self.sectionIdx].months[indexPath.item].getTimeLabel()
        cell.mileageLabel.text! = rideHistory.years[self.sectionIdx].months[indexPath.item].getMileageLabel()

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Sec: \(indexPath.section) Row: \(indexPath.row)")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MonthlyHistoryView") as! MonthlyHistoryTableViewController
        vc.title = "Sec: \(indexPath.section) Row: \(indexPath.row)"
        vc.device = self.currDevice
        
        vc.rideHistory = rideHistory
        vc.yearIndex = indexPath.section
        vc.monthIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }

}
