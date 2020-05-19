//
//  RideGraphCVCell.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 4/6/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit
import ScrollableGraphView

class RideGraphCVCell: UICollectionViewCell {
    
    var points = [CLLocation]()
    @IBOutlet weak var graphView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupGraph()
        
    }
    
    private func setupGraph() {
        let graphView = ScrollableGraphView(frame: self.graphView.frame, dataSource: self)
        let graph = LinePlot(identifier: "line")
        let dots = DotPlot(identifier: "dot")
        
        
        
        graph.lineStyle = .smooth
        graph.lineWidth = 1.0
        graph.shouldFill = true
        graph.fillType = .solid
        graph.lineColor = .systemBlue
        graph.fillColor = .systemGray4
        
        dots.dataPointSize = 2.0
        dots.dataPointFillColor = .systemBlue
        dots.dataPointType = .circle
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()

        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = .systemGray6
        graphView.shouldAnimateOnStartup = false
        graphView.rightmostPointPadding = 0.0
       //graphView.dataPointSpacing = 10.0
        
        graphView.rangeMax = 10
        graphView.rangeMin = 0
        
        
        // Add Everything
        graphView.addPlot(plot: graph)
        graphView.addPlot(plot: dots)
        graphView.addReferenceLines(referenceLines: referenceLines)
    
        self.graphView.addSubview(graphView)
    }

}

extension RideGraphCVCell: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return points[pointIndex].speed
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return points[pointIndex].timestamp.getTime()
    }
    
    func numberOfPoints() -> Int {
        return 100
    }
    
    
}
