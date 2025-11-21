//
//  TransferOwnershipViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 22/08/2024.
//

import UIKit

class TransferOwnershipViewController: BaseViewControllerWithVM<TransferOwnershipViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var mobileNumberTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        // Binding the mobile number text field to the Input
        mobileNumberTF.creatTextFieldBinding(with: viewModel.input.textPhone, storeIn: &cancellables)
        
        // Binding the phone number validation output to enable/disable the confirm button
        viewModel.output.isPhoneValid
            .sink { [weak self] isValid in
                guard let self = self else { return }
                self.confirmButton.isEnabled = isValid
            }
            .store(in: &cancellables)
        
        // Binding the navigation to sucess from the Output
        viewModel.output.navigateToSucess
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.present(TabbarFactory.suceessTransfereOwnershipPopUp.viewController, animated: true)
            }
            .store(in: &cancellables)
        
        backButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        confirmButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.viewModel.input.didTapOnTransfereButton.send()
            }
            .store(in: &cancellables)
        
    }
    
}
