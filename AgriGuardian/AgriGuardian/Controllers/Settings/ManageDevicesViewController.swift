//
//  ManageDevicesViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 4/21/20.
//  Copyright © 2020 Team Kadd. All rights reserved.

// Summary: For users to manage their devices (Edit or Delete)
// TODO: Load all devices. Segue to Device detail with isNew = false upon selection and send selected device
// to device detail - vc.thisDevice = devices[indexPath.row]

import UIKit


class ManageDevicesViewController: UITableViewController, RefreshDataDelegate {
    
    // MARK: - Properties
    let fbManager: FirebaseManager = FirebaseManager()
    var user: User = User()
    var devices: [Device] = []
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        self.navigationItem.rightBarButtonItem = addButton
        self.refreshData()
    }

    // MARK: - Actions
    @objc private func didTapAdd() {
        self.segueToDeviceDetailVC(isNewDev: true, thisDev: Device())
    }
    
    func startSpinner() {
        self.spinner.center = self.view.center
        self.spinner.style = .large
        self.spinner.startAnimating()
        self.view.addSubview(spinner)
    }
    
    func loadData() {
        fbManager.loadUserProfile { (user) in
            self.user = user
            //            self.currDevice = self.loadCurrentDevice()
            self.devices = user.getDevices()
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    func refreshData() {
        self.startSpinner()
        self.loadData()
    }
    
    func segueToDeviceDetailVC(isNewDev: Bool, thisDev: Device) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "DeviceDetail") as! DeviceDetailViewController

        if isNewDev {
            vc.title = "New Device"
        }
        else {
            vc.title = "Edit Device"
//            vc.deviceNameLabel.text = thisDev.name
//            vc.vehicleModelLabel.text = thisDev.atvModel
//            vc.geofenceToggle.isOn = thisDev.gfToggle
//            vc.geofenceRadius.text = String(thisDev.gfRadius)
//            vc.gfCenter = thisDev.gfCenter
        }
        
        vc.thisDevice = thisDev
        vc.isNew = isNewDev
        vc.viewDelegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.devices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageDeviceTableViewCell", for: indexPath) as! ManageDeviceTableViewCell

        // Configure the cell...
        cell.backgroundColor = .systemGray5
        cell.nameLabel.text = self.user.devices[indexPath.row].getDeviceName()
        cell.vehicleLabel.text = self.user.devices[indexPath.row].getVehicleName()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row \(indexPath.item) was pressed")
        self.segueToDeviceDetailVC(isNewDev: false, thisDev: self.devices[indexPath.item])
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

class ManageDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
