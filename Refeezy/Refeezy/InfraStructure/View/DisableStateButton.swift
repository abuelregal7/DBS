//
//  DisableStateButton.swift
//  Cashier
//
//  Created by Ahmed Abo Al-Regal on 07/10/2023.
//

import Foundation
import UIKit

class DisableStateButton: UIButton {
   
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.alpha = 1
            } else {
                self.alpha = 0.5
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isEnabled = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isEnabled = false
    }
}

