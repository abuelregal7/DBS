//
//  FirstRequestDetailsTableViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 15/04/2025.
//

import UIKit

class FirstRequestDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNumberLabel: UILabel!
    
    @IBOutlet weak var productGiftNameLabel: UILabel!
    @IBOutlet weak var productGiftImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(item: ShowOrdereRoomItem?) {
        //productImage.loadImage(item?.)
        productNumberLabel.text = "\(item?.itemNum ?? 0)"
        productGiftImage.loadImage(item?.itemGift?.image)
        productGiftNameLabel.text = item?.itemGift?.title
    }
    
}
