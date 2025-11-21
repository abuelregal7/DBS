//
//  AddNewAddressViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class AddNewAddressViewController: BaseViewControllerWithVM<AddNewAddressViewModel> {
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var Reload: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        addressTF.creatTextFieldBindingOptional(with: viewModel.textAddressSubject, storeIn: &cancellables)
        cityTF.creatTextFieldBindingOptional(with: viewModel.textCitySubject, storeIn: &cancellables)
        emailTF.creatTextFieldBinding(with: viewModel.textEmailSubject, storeIn: &cancellables)
        phoneNumberTF.creatTextFieldBinding(with: viewModel.textPhoneNumberSubject, storeIn: &cancellables)
        
        if viewModel.getAddress() == nil {
            viewModel.textAddressSubject.send(nil)
        }else {
            addressTF.text = viewModel.getAddress()
            viewModel.textAddressSubject.send(viewModel.getAddress())
        }
        
        if viewModel.getCity() == nil {
            viewModel.textCitySubject.send(nil)
        }else {
            cityTF.text = viewModel.getCity()
            viewModel.textCitySubject.send(viewModel.getCity())
        }
        
        viewModel.output.navigatoToMyAddresses
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.dismiss(animated: true) { [weak self] in
                    guard let self else { return }
                    self.Reload?()
                }
            }
            .store(in: &cancellables)
        
        cancelButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        confirmButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                
                guard self.addressTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter Address")
                    return
                }
                
                guard self.cityTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter City")
                    return
                }
                
                guard self.emailTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter E-mail")
                    return
                }
                
                guard self.emailTF.text?.isValidEmail == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid Email".localized)
                    return
                }
                
                guard self.phoneNumberTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter mobile number".localized)
                    return
                }
                
                guard self.phoneNumberTF.text?.isValidPhone == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid mobile number".localized)
                    return
                }
                
                self.viewModel.input.viewDidLoad.send()
                
            }
            .store(in: &cancellables)
        
    }
    
}
