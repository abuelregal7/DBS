//
//  UIColeectionView_Extenstion.swift
//  ElmakGhanem
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

extension UICollectionView {
    func registerNib(named: String, identifier: String = "") {
        register(UINib.init(nibName: named, bundle: nil), forCellWithReuseIdentifier: identifier.isEmpty ? named : identifier )
    }
}

class ArabicCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        
        if Language.currentAppleLanguage() == "ar" {
            
            return true
            
        }else{
            
            return false
            
        }
    }
    
}
