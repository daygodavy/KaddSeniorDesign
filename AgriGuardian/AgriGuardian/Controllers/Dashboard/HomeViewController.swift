//
//  HomeViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import CoreLocation

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private let reuseIdentifier = "Cell"
    private let headerId = "DashHeader"
    private let lastRideId = "LastRideId"
    private let statId = "StatCell"
    private let detailId = "DetailCell"
    private let locationId = "LocationCell"
    var devices: [Device] = []
    var currDevice = Device()
    var user = User()
    var dataManager = DataManager()
    var fbManager = FirebaseManager()
    var weeklyRides = RideWeek()
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var lastRide: Ride?
    var lastLocation: CLLocation?
    
    var activityView = UIActivityIndicatorView()
    

    
    fileprivate let spacing: CGFloat = 16.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showActivityIndicator()
        self.setupNavBar()
        registerFlowLayout()
  

        self.loadNibs()
        self.collectionView.reloadData()
        self.activityView.stopAnimating()
        
        let rideHistory = currDevice.rideHistory
        let currMonth = rideHistory.getCurrentMonth()
        let prevMonth = rideHistory.getPreviousMonth()
        lastRide = rideHistory.getLastRide()
        lastLocation = lastRide?.getLastLocation()
        
        
        weeklyRides = RideWeek(currMonth: currMonth, prevMonth: prevMonth)
        print("success")
    
        let sender = PushNotificationSender()
        print("STARTING")
        fbManager.getFcmToken { tok in
            sender.sendPushNotification(to: tok, title: "AgriGuardian", body: "Rollover Detected!!!!!!!")
            print("DID IT")
        }
        print("DONEEEEEEEEEE")

//        sender.sendPushNotification(to: "", title: "Notification title", body: "Notification body")

    }
    
    
    
    func loadNibs() {
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        let cellNib = UINib(nibName: "LastRideCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: lastRideId)
        
        let statNib = UINib(nibName: "StatisticsCell", bundle: nil)
        self.collectionView.register(statNib, forCellWithReuseIdentifier: statId)
        
        let detailNib = UINib(nibName: "WeekDetailCell", bundle: nil)
        self.collectionView.register(detailNib, forCellWithReuseIdentifier: detailId)
        
        let locoNib = UINib(nibName: "LastLocationCell", bundle: nil)
        self.collectionView.register(locoNib, forCellWithReuseIdentifier: locationId)
        
        // regisert main header
        let headerNib = UINib(nibName: "DashboardHeaderView", bundle: nil)
        self.collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
//        self.collectionView.reloadData()
    }
    
    func showActivityIndicator() {
        self.activityView.style = .large
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    
    private func loadCurrentDevice() -> Device {
        if currDevice.name.isEmpty {
            print("YES \(user)")
            return user.currentDevice
        }
        print("NO \(currDevice)")
        return currDevice
    }
    
    @objc func SignOutButtonPressed(_ sender: Any) {
        print("attempting to signout")
        self.userLogout()
        self.goToHome()
    }
    
    // MARK: - Private functions    
    fileprivate func registerFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView.collectionViewLayout = layout
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "\nDashboard"
        let image = UIImage(named: "menu-icon")?.withRenderingMode(.alwaysOriginal)
        let devicesButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showDevices))
        //self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = devicesButton
        
        let signoutImg = UIImage(systemName: "clear")
        let signoutButton = UIBarButtonItem(image: signoutImg, style: .plain, target: self, action: #selector(userLogout))
        self.navigationItem.rightBarButtonItem = signoutButton
    }
    

    
    @objc fileprivate func userLogout() {

        
        // Check provider ID to verify that the user has signed in with Apple
        if let providerId = Auth.auth().currentUser?.providerData.first?.providerID,
            providerId == "apple.com" {
            // Clear saved user ID
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
        } else {
            GIDSignIn.sharedInstance().signOut()
        }
        
        // Perform sign out from Firebase
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        self.goToHome()
    }
    
    @objc fileprivate func showDevices() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "DeviceMenu") as! DevicesCollectionViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    
    
    // ====TEMPORARY====: segue programatically (no unwind segue?)
    fileprivate func goToHome() {
        let onboardStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        let loginViewController = onboardStoryboard.instantiateViewController(withIdentifier: "InitialLoginViewController") as? InitialLoginViewController

        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()

    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            let lastRideCell = collectionView.dequeueReusableCell(withReuseIdentifier: lastRideId, for: indexPath) as! LastRideCell
            
            lastRideCell.titleLabel.text = "Last ride, \(weeklyRides.getDaysSinceLastRide(lastRide: lastRide)) day's ago"
            lastRideCell.timeLabel.text = weeklyRides.getLastRideTime(lastRide: lastRide)
            lastRideCell.detailLabel.text = weeklyRides.getLastRideMileage(lastRide: lastRide)
            return lastRideCell
        } else if (indexPath.row == 1) {
            let statCell = collectionView.dequeueReusableCell(withReuseIdentifier: statId, for: indexPath) as! StatisticsCell
            statCell.rideWeek = weeklyRides
            statCell.backgroundColor = .systemGray6
            return statCell
        } else if (indexPath.row == 2){
            let detCell = collectionView.dequeueReusableCell(withReuseIdentifier: detailId, for: indexPath) as! WeekDetailCell
            detCell.backgroundColor = .systemGray6
            detCell.nameLabel.text = "Miles"
            detCell.valueLabel.text = weeklyRides.getTotalMileage()
            return detCell
        } else if (indexPath.row == 3) {
            let detCell = collectionView.dequeueReusableCell(withReuseIdentifier: detailId, for: indexPath) as! WeekDetailCell
            detCell.nameLabel.text = "Hours"
            detCell.valueLabel.text = weeklyRides.getTotalHours()
            detCell.backgroundColor = .systemGray6
            return detCell
        } else if (indexPath.row == 4) {
            let detCell = collectionView.dequeueReusableCell(withReuseIdentifier: detailId, for: indexPath) as! WeekDetailCell
            detCell.nameLabel.text = "Rollovers"
            detCell.valueLabel.text = weeklyRides.getTotalRollovers()
            detCell.backgroundColor = .systemGray6
            return detCell
        }
        else if (indexPath.row == 5) {
            let locoCell = collectionView.dequeueReusableCell(withReuseIdentifier: locationId, for: indexPath) as! LastLocationCell
            let time = lastRide?.getLastUpdatedTime()
            locoCell.loadLastLocation(location: self.lastLocation)
            locoCell.dateLabel.text = "\(weeklyRides.getDaysSinceLastRide(lastRide: lastRide)) day's ago at \(time!)"
            locoCell.backgroundColor = .systemGray6
            return locoCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
    
        cell.backgroundColor = .systemGray5
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! DashboardHeaderView
        header.headerLabel.text = "\(currDevice.name) | \(currDevice.atvModel)"
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return .init(width: view.frame.width, height: 40)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = spacing
        
        let totalSpacing = (2.1 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        let widthWithSpacing = (view.frame.width - totalSpacing)/numberOfItemsPerRow
        let sizeWithSpacing = CGSize(width: widthWithSpacing, height: widthWithSpacing)
        switch(indexPath.row) {
        case 0:
            return .init(width: view.frame.width - 2 * spacing, height: 150)
        case 1:
            return .init(width: view.frame.width - 2 * spacing, height: 400)
        case 2:
            return sizeWithSpacing
        case 3:
            return sizeWithSpacing
        case 4:
            return sizeWithSpacing
        case 5:
            return .init(width: view.frame.width - 2 * spacing, height: 200)
        default:
            return .init(width: view.frame.width - 2 * spacing, height: 80)
        }
    }
}
