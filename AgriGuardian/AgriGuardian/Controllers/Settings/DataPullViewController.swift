//
//  DataPullViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 4/25/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class DataPullViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var atvImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func didTapStart(_ sender: Any) {
        atvImage.isHidden = false
        statusLabel.text = "Connecting..."
        startButton.setTitle("Stop", for: .normal)
        animateAtv()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private Functions
    
    fileprivate func setupViews() {
        buttonView.layer.cornerRadius = buttonView.frame.size.width / 2
        startButton.layer.cornerRadius = startButton.frame.size.width / 2
        atvImage.isHidden = true
        statusLabel.text = "Press start to begin."
    }
    
    fileprivate func animateAtv() {
        let orbit = CAKeyframeAnimation(keyPath: "position")
        var affineTransform = CGAffineTransform(rotationAngle: 0.0)
        affineTransform = affineTransform.rotated(by: .pi)
        let arcCenter = self.view.center
        
        let radius = self.buttonView.frame.size.width / 2 + 12
  
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        orbit.path = circlePath.cgPath
        orbit.duration = 4
        orbit.repeatCount = 100
        orbit.calculationMode = CAAnimationCalculationMode.paced
        orbit.rotationMode = CAAnimationRotationMode.rotateAuto

        atvImage.layer.add(orbit, forKey: "orbit")
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
