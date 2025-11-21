//
//  BaseMyAccountViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import UIKit

class BaseMyAccountViewController: BaseViewControllerWithVM<BaseMyAccountViewModel> {
    
    @IBOutlet weak var myAccountTableView: UITableView!{
        didSet {
            myAccountTableView.delegate = self
            myAccountTableView.dataSource = self
            
            myAccountTableView.register(UINib(nibName: "BaseMyAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "BaseMyAccountTableViewCell")
            myAccountTableView.register(UINib(nibName: "DeleteAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "DeleteAccountTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let myAccountFrame = CGRect(x: 0, y: 0, width: myAccountTableView.frame.size.width, height: 0.5)
        myAccountTableView.tableFooterView = UIView(frame: myAccountFrame)
        myAccountTableView.tableHeaderView = UIView(frame: myAccountFrame)
        myAccountTableView.separatorColor = UIColor.white
    }
    
    override func bind() {
        super.bind()
        
        viewModel.setSettingData()
        
        viewModel.navigatoToLogin
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                UserDefaults.standard.removeObject(forKey: "AccessToken")
                UserDefaults.standard.removeObject(forKey: "user")
                //UIApplication.initWindow()
                self.set(AuthVCBuilder.login.viewController)
            }.store(in: &cancellables)
        
        viewModel.navigaAfterDeleteAccount
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                UserDefaults.standard.removeObject(forKey: "AccessToken")
                UserDefaults.standard.removeObject(forKey: "user")
                UIApplication.initWindow()
            }.store(in: &cancellables)
        
    }
    
}

extension BaseMyAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.getSettingDataCount()
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = myAccountTableView.dequeueReusableCell(withIdentifier: "BaseMyAccountTableViewCell", for: indexPath) as? BaseMyAccountTableViewCell else { return UITableViewCell() }
            
            cell.iconImage.image = UIImage(named: viewModel.getSettingData(index: indexPath.row).icon ?? "")
            cell.titleLabel.text = viewModel.getSettingData(index: indexPath.row).title
            
            return cell
        }else {
            guard let cell = myAccountTableView.dequeueReusableCell(withIdentifier: "DeleteAccountTableViewCell", for: indexPath) as? DeleteAccountTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if UD.accessToken == nil {
                    let alert = UIAlertController(title: "Login".localized, message: "".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK".localized, style: .default) { [weak self] (action) in
                        guard let self = self else { return }
                        self.set(AuthVCBuilder.login.viewController)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                } else {
                    navigationController?.pushViewController(MyAccountFactory.editeProfile.viewController, animated: true)
                }
            }else if indexPath.row == 1 {
                navigationController?.pushViewController(MyAccountFactory.appLanguage.viewController, animated: true)
            }else if indexPath.row == 2 {
                let alert = UIAlertController(title: "Logout".localized, message: "Are you sure, want to logout ?".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized, style: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    self.viewModel.didTapOnLogoutButton()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
        }else {
            if UD.accessToken == nil {
                let alert = UIAlertController(title: "Login".localized, message: "".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized, style: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    self.set(AuthVCBuilder.login.viewController)
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }else {
                let alert = UIAlertController(title: "Delete Account".localized, message: "Are you sure, want to delete account ?".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized, style: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    self.viewModel.didTapOnDeleteAccountButton()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
            
        }
    }
    
}
