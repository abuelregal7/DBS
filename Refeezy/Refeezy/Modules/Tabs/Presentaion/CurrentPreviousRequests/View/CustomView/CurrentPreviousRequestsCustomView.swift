//
//  CurrentPreviousRequestsCustomView.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 13/04/2025.
//

import UIKit

class CurrentPreviousRequestsCustomView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNumberLabel: UILabel!
    
    @IBOutlet weak var productGiftNameLabel: UILabel!
    @IBOutlet weak var productGiftImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
