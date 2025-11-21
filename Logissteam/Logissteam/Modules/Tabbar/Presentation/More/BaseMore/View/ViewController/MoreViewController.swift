//
//  MoreViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 19/08/2024.
//

import UIKit

class MoreViewController: BaseViewControllerWithVM<BaseMoreViewModel> {
    
    @IBOutlet weak var moreTableView: UITableView!{
        didSet {
            moreTableView.delegate = self
            moreTableView.dataSource = self
            
            moreTableView.register(UINib(nibName: "MoreTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let moreFrame = CGRect(x: 0, y: 0, width: moreTableView.frame.size.width, height: 0.5)
        moreTableView.tableFooterView = UIView(frame: moreFrame)
        moreTableView.tableHeaderView = UIView(frame: moreFrame)
        moreTableView.separatorColor = UIColor.white
    }
    
    override func bind() {
        super.bind()
        
        viewModel.setMoreData()
        
    }
    
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMoreDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = moreTableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath) as? MoreTableViewCell else { return UITableViewCell() }
        
        cell.moreIcon.image = UIImage(named: viewModel.getSMoreData(index: indexPath.row).icon ?? "")
        cell.titleLabel.text = viewModel.getSMoreData(index: indexPath.row).title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.pushViewController(MoreFactory.aboutUS.viewController, animated: true)
        }else if indexPath.row == 1 {
            navigationController?.pushViewController(MoreFactory.termsConditions.viewController, animated: true)
        }else if indexPath.row == 2 {
            navigationController?.pushViewController(MoreFactory.privacyPolicy.viewController, animated: true)
        }else if indexPath.row == 3 {
            navigationController?.pushViewController(MoreFactory.contactUS.viewController, animated: true)
        }
    }
    
}
