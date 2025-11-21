//
//  DealsTableViewCell.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 22/08/2024.
//

import UIKit

class DealsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dealImage: UIImageView!
    @IBOutlet weak var dealTitleLabel: UILabel!
    @IBOutlet weak var dealDescLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nextBatchStack: UIStackView!
    @IBOutlet weak var nextBatchLabel: UILabel!
    @IBOutlet weak var nextPaymentStack: UIStackView!
    @IBOutlet weak var nextPaymentLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var OtherPaymentsAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: MyDealData?, dealTypeIsCurrent: Bool?) {
        dealImage.loadImage(item?.image)
        dealTitleLabel.text = item?.name
        dealDescLabel.text = item?.desc?.htmlToString
        quantityLabel.text = "\(item?.quantity ?? 0)"
        priceLabel.text = (item?.price?.string.doubleValue.clean ?? "0") + " " + "SR".localized
        nextBatchLabel.text = (item?.nextPaymentAmount?.string.doubleValue.clean ?? "0") + " " + "SR".localized
        nextPaymentLabel.text = item?.nextPaymentDate
        statusLabel.text = item?.status
        
        if dealTypeIsCurrent == true {
            statusView.isHidden = false
            nextPaymentStack.isHidden = false
            nextBatchStack.isHidden = false
        }else {
            statusView.isHidden = true
            nextPaymentStack.isHidden = true
            nextBatchStack.isHidden = true
        }
        
    }
    
    @IBAction func didTapOtherPaymentsButton(_ sender: Any) {
        OtherPaymentsAction?()
    }
    
}
