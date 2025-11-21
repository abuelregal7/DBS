//
//  SoldRoomCollectionViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/03/2025.
//

import UIKit

class SoldRoomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var roomTileLabel: UILabel!
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomDescLabel: UILabel!
    @IBOutlet weak var winnerTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var totalProductsLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var expirationDateStackView: UIStackView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: HomeCompletedRoomsData?) {
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
        
        if item?.expiredAt == nil {
            expirationDateStackView.isHidden = true
        }else{
            expirationDateStackView.isHidden = false
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = formatter.date(from: item?.expiredAt ?? "") {
                let calendar = Calendar.current
                
                let day = calendar.component(.day, from: date)
                let hour = calendar.component(.hour, from: date)
                let minute = calendar.component(.minute, from: date)
                let second = calendar.component(.second, from: date)
                print("Day: \(day), Hour: \(hour), Minute: \(minute), Second: \(second)")
                dayLabel.text = "\(day)"
                hourLabel.text = "\(hour)"
                minuteLabel.text = "\(minute)"
                secondLabel.text = "\(second)"
            } else {
                print("Invalid date format.")
            }
        }
    }
    
}
