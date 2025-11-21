//
//  Hud.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

class Hud: NSObject {
    
    private static var rootView: UIView? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    }

    private static var parentView: UIView?

    class func show(view: UIView? = nil) {
        guard let rootView = rootView else {
            return
        }

        parentView = UIView(frame: rootView.bounds)
        parentView?.backgroundColor = .clear
        rootView.addSubview(parentView!)

        let loader = CircularLoaderView(strokeColor: DesignSystem.Colors.PrimaryOrange.color)
        loader.translatesAutoresizingMaskIntoConstraints = false
        parentView?.addSubview(loader)

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: parentView!.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: parentView!.centerYAnchor),
            loader.widthAnchor.constraint(equalToConstant: 90),
            loader.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    class func hide() {
        DispatchQueue.main.async {
            parentView?.removeFromSuperview()
            parentView = nil
        }
    }

    @objc class func someAction(_ sender: UITapGestureRecognizer) {
        Hud.hide()
    }
    
    class func isLoading() -> Bool {
        return parentView != nil
    }
}
