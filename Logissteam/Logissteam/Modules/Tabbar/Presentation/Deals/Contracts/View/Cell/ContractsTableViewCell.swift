//
//  ContractsTableViewCell.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 22/08/2024.
//

import UIKit

class ContractsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contractTitleLabel: UILabel!
    
    var ContractsAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: DealsContractData?) {
        contractTitleLabel.text = item?.title
    }
    
    @IBAction func didTapContractsButton(_ sender: Any) {
        ContractsAction?()
    }
    
}
