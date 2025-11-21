//
//  HomeCategoriesCollectionViewCell.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import UIKit

class HomeCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var dealImage: UIImageView!
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var reservePriceLabel: UILabel!
    @IBOutlet private weak var dealDescriptionLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    var PurchasePlanes: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(item: HomeDealsData?) {
        dealImage.loadImage(item?.image)
        categoryNameLabel.text = item?.name
        reservePriceLabel.text = (item?.reservePrice?.string.doubleValue.clean ?? "0") + " " + "SR".localized
        dealDescriptionLabel.text = item?.desc?.htmlToString
        quantityLabel.text = "\(item?.quantity ?? 0)"
        priceLabel.text = (item?.price?.string.doubleValue.clean ?? "0") + " " + "SR".localized
    }
    
    func configureSearch(item: CategoryData?) {
        dealImage.loadImage(item?.image)
        categoryNameLabel.text = item?.name
        reservePriceLabel.text = (item?.reservePrice?.string.doubleValue.clean ?? "0") + " " + "SR".localized
        dealDescriptionLabel.text = item?.desc?.htmlToString
        quantityLabel.text = "\(item?.quantity ?? 0)"
        priceLabel.text = (item?.price?.string.doubleValue.clean ?? "0") + " " + "SR".localized
    }
    
    @IBAction func didTapPurchasePlansButton(_ sender: Any) {
        PurchasePlanes?()
    }
    
}
