//
//  MyAccountViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class MyAccountViewController: BaseViewControllerWithVM<MyAccountViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var updateProfileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var updateProfileButton: UIButton!
    
    var imageData: Data?
    var imageValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        nameTF.creatTextFieldBinding(with: viewModel.textNameSubject, storeIn: &cancellables)
        emailTF.creatTextFieldBinding(with: viewModel.textEmailSubject, storeIn: &cancellables)
        mobileNumberTF.creatTextFieldBinding(with: viewModel.textPhoneSubject, storeIn: &cancellables)
        
        viewModel.viewDidLoad()
        
        viewModel.profileDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                
                self.viewModel.textNameSubject.send(data?.name ?? "")
                self.viewModel.textEmailSubject.send(data?.email ?? "")
                self.viewModel.textPhoneSubject.send(data?.phone ?? "")
                
                self.nameLabel.text = data?.name
                self.nameTF.text = data?.name
                self.emailTF.text = data?.email
                self.mobileNumberTF.text = data?.phone
                self.profileImage.loadImageProfile(data?.image)
                
            }
            .store(in: &cancellables)
        
        viewModel.updateData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.viewModel.viewDidLoad()
            }
            .store(in: &cancellables)
        
        backButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        updateProfileImage.addTapGesture { [weak self] in
            guard let self else { return }
            self.OpenCameraORGallary()
        }
        
        updateProfileButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                
                guard self.nameTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter full name".localized)
                    return
                }
                
                guard self.mobileNumberTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter mobile number".localized)
                    return
                }
                
                guard self.mobileNumberTF.text?.isValidPhone == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid mobile number".localized)
                    return
                }
                
                guard self.emailTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Please, Enter the email")
                    return
                }
                
                guard self.emailTF.text?.isValidEmail == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid Email".localized)
                    return
                }
                
                self.viewModel.didTapOnUpdateButton(image: imageData)
            }
            .store(in: &cancellables)
        
    }
    
}
