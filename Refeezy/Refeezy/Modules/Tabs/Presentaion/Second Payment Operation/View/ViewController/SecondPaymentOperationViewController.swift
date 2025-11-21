//
//  SecondPaymentOperationViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class SecondPaymentOperationViewController: UIViewController {
    
    @IBOutlet weak var productsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productsTableView: UITableView!{
        didSet {
            productsTableView.delegate = self
            productsTableView.dataSource = self
            productsTableView.register(UINib(nibName: "SecondPaymentOperationTableViewCell", bundle: nil), forCellReuseIdentifier: "SecondPaymentOperationTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            productsTableView.addGradientBorder(colors: [UIColor().colorWithHexString(hexString: "FABB17").withAlphaComponent(0.5), UIColor().colorWithHexString(hexString: "45F882").withAlphaComponent(0.2)], borderWidth: 1, cornerRadius: 12, sides: [.top, .left])
            
            self.view.layoutIfNeeded()
            self.productsTableViewHeight.constant = self.productsTableView.contentSize.height
            self.productsTableView.layoutIfNeeded()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            productsTableView.addGradientBorder(colors: [UIColor().colorWithHexString(hexString: "FABB17").withAlphaComponent(0.5), UIColor().colorWithHexString(hexString: "45F882").withAlphaComponent(0.2)], borderWidth: 1, cornerRadius: 12, sides: [.top, .left])
            
            self.view.layoutIfNeeded()
            self.productsTableViewHeight.constant = self.productsTableView.contentSize.height
            self.productsTableView.layoutIfNeeded()
        }
        
    }
    
}

extension SecondPaymentOperationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productsTableView.dequeueReusableCell(withIdentifier: "SecondPaymentOperationTableViewCell", for: indexPath) as? SecondPaymentOperationTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
