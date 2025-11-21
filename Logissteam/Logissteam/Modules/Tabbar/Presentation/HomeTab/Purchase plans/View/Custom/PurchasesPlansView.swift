//
//  PurchasesPlansView.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 21/08/2024.
//

import UIKit

class PurchasesPlansView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var childTitleLabel: UILabel!
    @IBOutlet weak var childSubTitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
