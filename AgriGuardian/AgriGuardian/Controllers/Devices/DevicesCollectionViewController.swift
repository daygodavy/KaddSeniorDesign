//
//  DevicesCollectionViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/3/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let deviceIdentifier = "DeviceCell"

class DevicesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    fileprivate let spacing: CGFloat = 16.0
    fileprivate var count = [1]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        registerFlowLayout()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let nib = UINib(nibName: "DeviceCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: deviceIdentifier)

        // Do any additional setup after loading the view.
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
        self.navigationItem.title = "Devices"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeMenu))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func closeMenu() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func didTapAdd() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "AddDevice")
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true)
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return count.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deviceIdentifier, for: indexPath) as! DeviceCollectionViewCell
    
        cell.backgroundColor = .systemGray5
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * spacing, height: 80)
    }

    
    // MARK: - Navigation
    @IBAction func unwindFromAddDevice(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is AddDeviceViewController {
            if let sourceVC = unwindSegue.source as? AddDeviceViewController {
                count.append(1)
            }
            collectionView.reloadData()
        }
    }




    

}
