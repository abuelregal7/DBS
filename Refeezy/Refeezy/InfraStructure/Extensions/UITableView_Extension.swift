//
//  UITableView_Extension.swift
//  ElmakGhanem
//
//  Created by IOS-Zinab on 29/09/2022.
//

import UIKit

extension UITableView {

    func registerNib(named: String, identifier: String = "") {
        register(UINib.init(nibName: named, bundle: nil), forCellReuseIdentifier: identifier.isEmpty ? named : identifier)
    }
    
    func deselectSelectedRow(animated: Bool) {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            self.deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }
}
