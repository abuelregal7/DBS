//
//  HomeGiftsCollectionViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/03/2025.
//

import UIKit

class HomeGiftsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCardHeight: NSLayoutConstraint!
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var giftTitleLabel: UILabel!
    @IBOutlet weak var giftTitleIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: HomeGiftsData?) {
        giftImage.loadImage(item?.image)
        giftTitleLabel.text = item?.title
    }
    
}
