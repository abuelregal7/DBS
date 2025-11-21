//
//  AlertManager.swift
//  LocationServicesTask
//
//  Created by Sami Ahmed on 06/02/2025.
//


import UIKit

final class AlertManager {
    
    static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first?.rootViewController {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                rootViewController.present(alert, animated: true)
            }
        }
    }

}
