//
//  BaseMoreViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation

class BaseMoreViewModel: BaseViewModel {
    
    // MARK: - Private
    private var MoreData = [BaseMoreModel]()
    
    
    func getMoreDataCount() -> Int {
        return MoreData.count
    }
    
    func getSMoreData(index: Int) -> BaseMoreModel {
        return MoreData[index]
    }
    
    func setMoreData() {
        
        MoreData.append(contentsOf: [
            BaseMoreModel(title: "About US".localized, icon: "aboutus"),
            BaseMoreModel(title: "Terms And Conditions".localized, icon: "terms"),
            BaseMoreModel(title: "Privacy Policy".localized, icon: "privacy"),
            BaseMoreModel(title: "Contact US".localized, icon: "Contact")
        ])
        
    }
}
