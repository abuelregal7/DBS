//
//  MainStoreTabbarViewController.swift
//  HC
//
//  Created by ahmed abu elregal on 06/06/2023.
//

import UIKit

enum TabBarButtons: Int {
    case home
    case deals
    case baseMyAccount
    case baseMore
}

class TabBarViewController: UIViewController {
    
    @IBOutlet weak var tabsViewHieghtCons: NSLayoutConstraint!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var viewForTab: UIView!
    @IBOutlet private weak var stackContainerOfButtonTabs: UIStackView!
    
    @IBOutlet private weak var tab_1_View: UIView!
    @IBOutlet private weak var tab_1_Icon: UIImageView!
    @IBOutlet private weak var tab_1_Label: UILabel!
    
    @IBOutlet private weak var tab_2_View: UIView!
    @IBOutlet private weak var tab_2_Icon: UIImageView!
    @IBOutlet private weak var tab_2_Label: UILabel!
    
    @IBOutlet private weak var tab_3_View: UIView!
    @IBOutlet private weak var tab_3_Icon: UIImageView!
    @IBOutlet private weak var tab_3_Label: UILabel!
    
    @IBOutlet private weak var tab_4_View: UIView!
    @IBOutlet private weak var tab_4_Icon: UIImageView!
    @IBOutlet private weak var tab_4_Label: UILabel!
    
    // MARK: Variables
    var vc1: UIViewController!
    var vc2: UIViewController!
    var vc3: UIViewController!
    var vc4: UIViewController!
    
    var selectedIndex: Int = 0
    var viewControllers: [UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        vc1 = TabbarFactory.home.viewController
        vc2 = TabbarFactory.deals.viewController
        vc3 = MyAccountFactory.baseMyAccount.viewController
        vc4 = MoreFactory.baseMore.viewController
        
        viewControllers = [vc1, vc2, vc3, vc4]
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.forSwitchControllers(type: .home)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func forSwitchControllers(type: TabBarButtons) {
        
        let previousIndex = selectedIndex
        selectedIndex = type.rawValue
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        switch type {
        case .home:
            UIView.animate(withDuration: 0.45) { [weak self] in
                guard let self = self else { return }
                self.tab_1_Label.textColor        =  UIColor().colorWithHexString(hexString: "1A56DB")
                self.tab_2_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_3_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_4_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                
                self.tab_1_Icon.image             =  UIImage(named: "selectedHome")
                self.tab_2_Icon.image             =  UIImage(named: "unselectedDeals")
                self.tab_3_Icon.image             =  UIImage(named: "unselectedMyAccount")
                self.tab_4_Icon.image             =  UIImage(named: "unselectedMore")
            }
        case .deals:
            UIView.animate(withDuration: 0.45) { [weak self] in
                guard let self = self else { return }
                self.tab_1_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_2_Label.textColor        =  UIColor().colorWithHexString(hexString: "1A56DB")
                self.tab_3_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_4_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                
                self.tab_1_Icon.image             =  UIImage(named: "unselectedHome")
                self.tab_2_Icon.image             =  UIImage(named: "selectedDeals")
                self.tab_3_Icon.image             =  UIImage(named: "unselectedMyAccount")
                self.tab_4_Icon.image             =  UIImage(named: "unselectedMore")
            }
        case .baseMyAccount:
            UIView.animate(withDuration: 0.45) { [weak self] in
                guard let self = self else { return }
                self.tab_1_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_2_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_3_Label.textColor        =  UIColor().colorWithHexString(hexString: "1A56DB")
                self.tab_4_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                
                self.tab_1_Icon.image             =  UIImage(named: "unselectedHome")
                self.tab_2_Icon.image             =  UIImage(named: "unselectedDeals")
                self.tab_3_Icon.image             =  UIImage(named: "selectedMyAccount")
                self.tab_4_Icon.image             =  UIImage(named: "unselectedMore")
            }
            
        case .baseMore:
            UIView.animate(withDuration: 0.45) { [weak self] in
                guard let self = self else { return }
                self.tab_1_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_2_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_3_Label.textColor        =  UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.8)
                self.tab_4_Label.textColor        =  UIColor().colorWithHexString(hexString: "1A56DB")
                
                self.tab_1_Icon.image             =  UIImage(named: "unselectedHome")
                self.tab_2_Icon.image             =  UIImage(named: "unselectedDeals")
                self.tab_3_Icon.image             =  UIImage(named: "unselectedMyAccount")
                self.tab_4_Icon.image             =  UIImage(named: "selectedMore")
            }
        }
    }
    
    @IBAction func onClickTabBar(_ sender: UIButton) {
        switch sender.tag {
        case 0: forSwitchControllers(type: .home)
        case 1: forSwitchControllers(type: .deals)
        case 2: forSwitchControllers(type: .baseMyAccount)
        case 3: forSwitchControllers(type: .baseMore)
        default:
            break
        }
    }
}
