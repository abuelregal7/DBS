//
//  EditeProfileViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import UIKit

class EditeProfileViewController: BaseViewControllerWithVM<EditProfileViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileNumberTF: LimitedLengthField!
    @IBOutlet weak var uploadIbanStackView: UIStackView!
    @IBOutlet weak var ibanImage: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var removeImage: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backrevertButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var ibanData: Data?
    var ibanImageValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialDesign()
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
                self.nameTF.text = data?.name
                self.emailTF.text = data?.email
                self.mobileNumberTF.text = data?.phone
                self.ibanImage.loadImage(data?.ibanImage)
                if data?.ibanImage == nil || data?.ibanImage == "" {
                    self.uploadIbanStackView.isHidden = false
                    self.ibanImage.isHidden = true
                }else {
                    self.uploadIbanStackView.isHidden = true
                    self.ibanImage.isHidden = false
                }
                
                self.nameTF.isEnabled = false
                self.emailTF.isEnabled = false
                self.mobileNumberTF.isEnabled = false
                self.editButton.isHidden = false
                self.backrevertButton.isHidden = true
                self.removeImage.isHidden = true
                self.confirmButton.isEnabled = self.editButton.isHidden
                self.uploadButton.isEnabled = self.editButton.isHidden
                self.removeImage.isEnabled = self.editButton.isHidden
                if self.editButton.isHidden {
                    self.uploadIbanStackView.isHidden = false
                }else {
                    self.uploadIbanStackView.isHidden = true
                }
                self.ibanImage.isHidden = false
                
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
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        uploadButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                //self.openPDFPicker()
                self.OpenCameraORGallary()
            }
            .store(in: &cancellables)
        
        removeImage
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.ibanImage.image = nil
                self.ibanImage.isHidden = true
                self.removeImage.isHidden = true
            }
            .store(in: &cancellables)
        
        editButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.nameTF.isEnabled = true
                self.emailTF.isEnabled = true
                self.mobileNumberTF.isEnabled = true
                self.editButton.isHidden = true
                self.backrevertButton.isHidden = false
                self.removeImage.isHidden = false
                self.confirmButton.isEnabled = self.editButton.isHidden
                self.uploadButton.isEnabled = self.editButton.isHidden
                self.removeImage.isEnabled = self.editButton.isHidden
                if self.editButton.isHidden {
                    self.uploadIbanStackView.isHidden = false
                }else {
                    self.uploadIbanStackView.isHidden = true
                }
            }
            .store(in: &cancellables)
        
        backrevertButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.nameTF.isEnabled = false
                self.emailTF.isEnabled = false
                self.mobileNumberTF.isEnabled = false
                self.editButton.isHidden = false
                self.backrevertButton.isHidden = true
                self.removeImage.isHidden = true
                self.confirmButton.isEnabled = self.editButton.isHidden
                self.uploadButton.isEnabled = self.editButton.isHidden
                self.removeImage.isEnabled = self.editButton.isHidden
                if self.editButton.isHidden {
                    self.uploadIbanStackView.isHidden = false
                }else {
                    self.uploadIbanStackView.isHidden = true
                }
                self.ibanImage.isHidden = false
                self.ibanImage.loadImage(self.viewModel.getIbanImage())
                self.nameTF.text = self.viewModel.getName()
                self.emailTF.text = self.viewModel.getEmail()
                self.mobileNumberTF.text = self.viewModel.getPhone()
            }
            .store(in: &cancellables)
        
        confirmButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.viewModel.didTapOnUpdateButton(iban_image: ibanData)
            }
            .store(in: &cancellables)
        
        ibanImage.addTapGesture { [weak self] in
            guard let self = self else { return }
            let vc = PhotoPreviewViewController(fromRegister: false, imageToPreview: self.viewModel.getIbanImage(), imageeToPreview: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
        
    }
    
    func setInitialDesign() {
        confirmButton.isEnabled = false
        uploadButton.isEnabled = false
        removeImage.isEnabled = false
        removeImage.isHidden = true
    }
    
}
