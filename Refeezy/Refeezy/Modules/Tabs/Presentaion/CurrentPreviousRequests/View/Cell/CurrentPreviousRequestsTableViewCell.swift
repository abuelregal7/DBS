//
//  CurrentPreviousRequestsTableViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class CurrentPreviousRequestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var borderContainerView: UIView!
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomTitleLabel: UILabel!
    @IBOutlet weak var roomDescLabel: UILabel!
    @IBOutlet weak var superRoomGiftImage: UIImageView!
    @IBOutlet weak var superRoomGiftTitleLabel: UILabel!
    @IBOutlet weak var superRoomGiftSubTitleLabel: UILabel!
    
    @IBOutlet weak var childCategoryStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            borderContainerView.addGradientBorder(colors: [UIColor().colorWithHexString(hexString: "FABB17").withAlphaComponent(0.5), UIColor().colorWithHexString(hexString: "45F882").withAlphaComponent(0.2)], borderWidth: 1, cornerRadius: 12, sides: [.top, .left])
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(item: MyOrderesDataData?) {
        roomImage.loadImage(item?.room?.image)
        roomTitleLabel.text = item?.room?.title
        roomDescLabel.text = item?.room?.description
        
        superRoomGiftSubTitleLabel.text = item?.room?.superGift?.title
        superRoomGiftImage.loadImage(item?.room?.superGift?.image)
        
        
        childCategoryStackView.subviews.forEach({ $0.removeFromSuperview() })
        for data in item?.roomItems ?? [] {
            let currentPreviousRequestsCustomView = CurrentPreviousRequestsCustomView()
            //currentPreviousRequestsCustomView.productImage.loadImage(data.)
            currentPreviousRequestsCustomView.productNumberLabel.text = "\(data.itemNum ?? 0)"
            currentPreviousRequestsCustomView.productGiftImage.loadImage(data.itemGift?.image)
            currentPreviousRequestsCustomView.productGiftNameLabel.text = data.itemGift?.title
            childCategoryStackView.addArrangedSubview(currentPreviousRequestsCustomView)
        }
        
    }
    
}
