//
//  PurchasesPlansCollectionViewCell.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 21/08/2024.
//

import UIKit

class PurchasesPlansCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var planTypeLabel: UILabel!
    @IBOutlet weak var planPriceLabel: UILabel!
    @IBOutlet weak var childPlansStackView: UIStackView!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var paymentPeriodLabel: UILabel!
    @IBOutlet weak var firstPaymentPeriodLabel: UILabel!
    @IBOutlet weak var profitPercentLabel: UILabel!
    
    
    var DownloadAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        childPlansStackView.subviews.forEach({ $0.removeFromSuperview() })
//        for item in 0...3 {
//            print(item)
//            let purchasesPlansView = PurchasesPlansView()
//            //purchasesPlansView.childTitleLabel.text = item.name
//            childPlansStackView.addArrangedSubview(purchasesPlansView)
//        }
        
    }
    
    func configure(item: BuyPlansModelData?) {
        planTypeLabel.text = item?.title
        planPriceLabel.text = "\(item?.monthlyProfit ?? 0)"
        if Language.currentAppleLanguage() == "en" {
            periodLabel.text = "(\(item?.period ?? 0) " + "months)".localized
            paymentPeriodLabel.text = "(Every".localized + " \(item?.paymentPeriod ?? 0) " + "days)".localized
        }else {
            periodLabel.text = "(\(item?.period ?? 0) " + "شهور)".localized
            paymentPeriodLabel.text = "(كل".localized + " \(item?.paymentPeriod ?? 0) " + "يوم)".localized
        }
        firstPaymentPeriodLabel.text = item?.firstPaymentPeriod
        profitPercentLabel.text = "\(item?.profitPercent ?? 0) %"
        
        //planPriceLabel.text = item.
    }
    
    @IBAction func didTapOnDownloadButton(_ sender: Any) {
        DownloadAction?()
    }
    
}
