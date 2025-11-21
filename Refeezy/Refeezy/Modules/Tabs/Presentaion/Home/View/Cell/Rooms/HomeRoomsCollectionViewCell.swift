//
//  HomeRoomsCollectionViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/03/2025.
//

import UIKit

class HomeRoomsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var roomTileLabel: UILabel!
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomDescLabel: UILabel!
    @IBOutlet weak var winnerTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var totalProductsLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: HomeRoomsData?) {
        giftImage.loadImage(item?.superGift?.image)
        roomTileLabel.text = item?.title
        roomImage.loadImage(item?.image)
        roomDescLabel.text = item?.description
        winnerTitleLabel.text = item?.winnerItem?.gift?.title
        let attachment = NSTextAttachment()
        
        // Use image and apply rendering mode to support tint color
        if let image = UIImage(named: "sar_symbol")?.withRenderingMode(.alwaysTemplate) {
            let tintedImage = image.withTintColor(UIColor().colorWithHexString(hexString: "#F0F0F0"), renderingMode: .alwaysOriginal) // or .alwaysTemplate if UILabel has tintColor
            attachment.image = tintedImage
            
            // Optional: resize
            attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
            
            let attachmentString = NSAttributedString(attachment: attachment)
            let fullString = NSMutableAttributedString(string: "")
            fullString.append(attachmentString)
            fullString.append(NSAttributedString(string: "\(item?.price ?? 0)"))
            productPriceLabel.attributedText = fullString
        }
        totalProductsLabel.text = "\(item?.productCount ?? 0)"
        remainingLabel.text = "\(item?.remainCount ?? 0)"
    }
    //sar_symbol
    func configure(item: AllRoomes?) {
        giftImage.loadImage(item?.superGift?.image)
        roomTileLabel.text = item?.title
        roomImage.loadImage(item?.image)
        roomDescLabel.text = item?.description
        winnerTitleLabel.text = item?.winnerItem?.gift?.title
        productPriceLabel.text = "\(item?.price ?? 0)" + " " + "SAR".localized
        totalProductsLabel.text = "\(item?.productCount ?? 0)"
        remainingLabel.text = "\(item?.remainCount ?? 0)"
    }
    
}
