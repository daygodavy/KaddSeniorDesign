//
//  StatisticsCell.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/8/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import ScrollableGraphView

class StatisticsCell: UICollectionViewCell {

    
    // MARK: - Properties
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var testData = [88.0, 26.5, 30.2, 97.3, 53.3, 10, 66.6]
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupGraph()
    }
    
    func setupGraph() {
        let graphView = ScrollableGraphView(frame: self.graphView.frame, dataSource: self)

        // Setup the plot
        let barPlot = BarPlot(identifier: "bar")

        barPlot.barWidth = 25
        barPlot.barLineWidth = 1
        barPlot.barLineColor = .gray
        barPlot.barColor = .systemGray4
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        barPlot.animationDuration = 1.5

        // Setup the reference lines
        let referenceLines = ReferenceLines()

        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white

        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)

        // Setup the graph
        graphView.backgroundFillColor = .systemGray6

        graphView.shouldAnimateOnStartup = true

        graphView.rangeMax = 100
        graphView.rangeMin = 0

        // Add everything
        graphView.addPlot(plot: barPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        self.addSubview(graphView)
    }

}
extension StatisticsCell: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return testData[pointIndex]
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return days[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return days.count
    }
    
    
}
