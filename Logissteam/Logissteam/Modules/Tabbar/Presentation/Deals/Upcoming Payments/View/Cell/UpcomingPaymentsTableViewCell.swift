//
//  UpcomingPaymentsTableViewCell.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 22/08/2024.
//

import UIKit

class UpcomingPaymentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var DownloadAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: DealsPaymentData?) {
        amountLabel.text = (item?.amount?.string.doubleValue.clean ?? "0") + " " + "SR".localized
        statusLabel.text = item?.status
        dateLabel.text = item?.dueDate
    }
    
    @IBAction func didTapDownloadButton(_ sender: Any) {
        DownloadAction?()
    }
    
}
