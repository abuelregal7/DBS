//
//  CounterLabel.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 05/12/2023.
//

import UIKit

protocol CounterLabelDelegate: AnyObject {
    func timerDidEnd(label: CounterLabel)
}

class CounterLabel: UILabel {
    
    var counter = 60
    var timer: Timer?
    weak var delegate: CounterLabelDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    private func commonInit() {
        startTimer()
    }
    
    func startTimer() {
        counter = 60
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateCounter() {
        if counter >= 0 {
            let minutes = counter / 60
            let seconds = counter % 60
            self.text = String(format: "%02d:%02d", minutes, seconds)
            counter -= 1
        } else {
            self.stopTimer()
            delegate?.timerDidEnd(label: self)
        }
    }
}
