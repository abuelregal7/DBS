//
//  HomeBannerCollectionViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/03/2025.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var homeBannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: HomeSliderData?) {
        homeBannerImage.loadImage(item?.image)
    }
    
    func configure(item: String?) {
        homeBannerImage.loadImage(item)
    }
    
}
