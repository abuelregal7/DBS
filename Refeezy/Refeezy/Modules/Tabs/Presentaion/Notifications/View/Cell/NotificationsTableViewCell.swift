//
//  NotificationsTableViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 16/04/2025.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationDescLabel: UILabel!
    @IBOutlet weak var notificationDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure() {
        
    }
    
}
