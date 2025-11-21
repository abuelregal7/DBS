//
//  HomeBannerCollectionViewCell.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: HomeSlider?) {
        bannerImage.loadImage(item?.image)
    }
    
}
