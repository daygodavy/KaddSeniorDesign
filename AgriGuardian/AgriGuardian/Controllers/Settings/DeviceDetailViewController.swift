//
//  DeviceDetailViewController.swift
//  
//
//  Created by Daniel Weatrowski on 4/25/20.
//

import UIKit

class DeviceDetailViewController: UITableViewController {
    // MARK: - Properties
    var thisDevice: Device = Device()
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var removeDeviceCell: UITableViewCell!
    var isNew: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    fileprivate func setupView() {
        if (!isNew) {
            self.navigationItem.rightBarButtonItem = self.editButtonItem
            self.submitButton.setTitle("Save", for: .normal)
            self.removeButton.setTitle("Remove Device", for: .normal)
            self.removeButton.tintColor = .systemRed
        } else {
            removeDeviceCell.isHidden = true
        }
        self.submitButton.setTitle("Save", for: .normal)


    }

    // MARK: - Table view data source


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
