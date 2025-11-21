//
//  NotificationsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 16/04/2025.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var notificationTableView: UITableView!{
        didSet {
            notificationTableView.separatorStyle = .none
            notificationTableView.delegate = self
            notificationTableView.dataSource = self
            notificationTableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as? NotificationsTableViewCell else { return UITableViewCell() }
        return cell
    }
    
}
