//
//  UIImage+EX.swift
//  BaseProgect
//
//  Created by Restart Technology on 14/09/2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func loadProfileCover(_ url : String?) {

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "background"),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])

        self.kf.indicatorType = .activity

    }
    func loadImageProfile(_ url : String?) {

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "emptyProfileImage"),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])

        self.kf.indicatorType = .activity

    }
    
    func loadCompanyImage(_ url : String?) {
        //ahn800
        //placeholder_2

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: ""),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])

        self.kf.indicatorType = .activity

    }
    
    func loadImage(_ url: String?) {
        // Ensure the URL is valid
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: linkString) else { return }
        
        // Set the activity indicator before loading
        let customIndicator = ColoredActivityIndicator(color: .white)
        self.kf.indicatorType = .custom(indicator: customIndicator) //.activity

        // Load image using Kingfisher
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Offer X-App-Icon"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    func loadPagesImage(_ url : String?) {
        //ahn800
        //placeholder_2

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])

        self.kf.indicatorType = .activity

    }
    
    func loadStore(_ url : String?) {
        //ahn800
        //placeholder_2

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic_vendor_default_logo"),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])

        self.kf.indicatorType = .activity

    }
    
    func loadOffer(_ url : String?) {
        //ahn800
        //placeholder_2

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "offer_card_default_image"),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])

        self.kf.indicatorType = .activity

    }
    
    func loadCategory(_ url : String?) {
        //ahn800
        //placeholder_2

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic_vendor_categories"),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])
        self.kf.indicatorType = .activity

    }

    func loadChatImage(_ url : String?) {
        //ahn800
        //placeholder_2

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "noun-send-3993472"),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])

        self.kf.indicatorType = .activity

    }
}

import UIKit
import Kingfisher

class ColoredActivityIndicator: UIView, Indicator {
    
    let activityIndicator: UIActivityIndicatorView

    var view: UIView {
        return self
    }

    required init(color: UIColor = .red) { // Choose your custom color
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = color
        super.init(frame: .zero)
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimatingView() {
        activityIndicator.startAnimating()
        isHidden = false
    }

    func stopAnimatingView() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
