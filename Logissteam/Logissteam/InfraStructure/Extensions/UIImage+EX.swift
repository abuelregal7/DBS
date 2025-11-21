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
            placeholder: UIImage(named: ""),
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
    
    func loadImage(_ url : String?) {
        //ahn800
        //placeholder_2

        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }

        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Offer X-App-Icon"),
            options: [

                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage

            ])

        self.kf.indicatorType = .activity

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
