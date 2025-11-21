//
//  VerificationCodeViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/03/2025.
//

import UIKit
import IQKeyboardManagerSwift

class VerificationCodeViewController: BaseViewControllerWithVM<VerificationCodeViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var parentContainerViewOfOTP: UIView!{
        didSet {
            parentContainerViewOfOTP.semanticContentAttribute = .forceLeftToRight
        }
    }
    @IBOutlet weak var stackContainerOfOTP: UIStackView!{
        didSet {
            stackContainerOfOTP.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @IBOutlet weak var viewNo1: UIView!
    @IBOutlet weak var no1: UITextField!
    
    @IBOutlet weak var viewNo2: UIView!
    @IBOutlet weak var no2: UITextField!
    
    @IBOutlet weak var viewNo3: UIView!
    @IBOutlet weak var no3: UITextField!
    
    @IBOutlet weak var viewNo4: UIView!
    @IBOutlet weak var no4: UITextField!
    
    var timer: Timer?
    var remainingTime: Int = 240 // 4 minutes in seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentContainerViewOfOTP.semanticContentAttribute = .forceLeftToRight
        stackContainerOfOTP.semanticContentAttribute = .forceLeftToRight
        
        [no1, no2, no3, no4].forEach {
            $0?.delegate = self
        }
        //---------------------------------------------------------------------------------------
        // For each UITextField add target action for ( editingChanged )
        //---------------------------------------------------------------------------------------
        [no1, no2, no3, no4].forEach {
            $0?.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        }
        //---------------------------------------------------------------------------------------
        // Add line as no1.becomeFirstResponder() to open keyboard for first field
        //---------------------------------------------------------------------------------------
        no1.becomeFirstResponder()
        
        startTimer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func bind() {
        super.bind()
        
        no1.creatTextFieldBinding(with: viewModel.textCode1Subject, storeIn: &cancellables)
        no2.creatTextFieldBinding(with: viewModel.textCode2Subject, storeIn: &cancellables)
        no3.creatTextFieldBinding(with: viewModel.textCode3Subject, storeIn: &cancellables)
        no4.creatTextFieldBinding(with: viewModel.textCode4Subject, storeIn: &cancellables)
        
        viewModel.textCode1Subject
            .sink { [weak self] check in
                guard let self else { return }
                print(check)
                self.viewModel.validateCode1(code: self.no1.text ?? "")
                self.viewModel.validateCode2(code: self.no2.text ?? "")
                self.viewModel.validateCode3(code: self.no3.text ?? "")
                self.viewModel.validateCode4(code: self.no4.text ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.textCode2Subject
            .sink { [weak self] check in
                guard let self else { return }
                print(check)
                self.viewModel.validateCode1(code: self.no1.text ?? "")
                self.viewModel.validateCode2(code: self.no2.text ?? "")
                self.viewModel.validateCode3(code: self.no3.text ?? "")
                self.viewModel.validateCode4(code: self.no4.text ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.textCode3Subject
            .sink { [weak self] check in
                guard let self else { return }
                print(check)
                self.viewModel.validateCode1(code: self.no1.text ?? "")
                self.viewModel.validateCode2(code: self.no2.text ?? "")
                self.viewModel.validateCode3(code: self.no3.text ?? "")
                self.viewModel.validateCode4(code: self.no4.text ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.textCode4Subject
            .sink { [weak self] check in
                guard let self else { return }
                print(check)
                self.viewModel.validateCode1(code: self.no1.text ?? "")
                self.viewModel.validateCode2(code: self.no2.text ?? "")
                self.viewModel.validateCode3(code: self.no3.text ?? "")
                self.viewModel.validateCode4(code: self.no4.text ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.enabledConfirmButtonPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] check in
                guard let self else { return }
                print(check)
                if check == false {
                    self.confirmButton.isEnabled = false
                }else {
                    self.confirmButton.isEnabled = true
                }
            }.store(in: &cancellables)
        
        viewModel.navigatoToSucess
            .receive(on: RunLoop.main)
            .sink {
                UIApplication.setRoot(TabBarViewController(), animated: false)
            }.store(in: &cancellables)
        
        confirmButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.viewModel.didTapOnConfirm()
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
        
    }
    
    func startTimer() {
        updateLabel() // Set initial time
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateLabel()
            timerLabel.isHidden = false
            resendButton.isEnabled = false
        } else {
            timer?.invalidate()
            timer = nil
            timerLabel.isHidden = true
            resendButton.isEnabled = true
        }
    }
    
    func updateLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

}

extension VerificationCodeViewController: UITextFieldDelegate {
    
    //-------------------------------------------------------------------------------------------
    // Add method textFieldDidChange with @objc
    // When changed value in textField
    //-------------------------------------------------------------------------------------------
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        //-----------------------------------------------------------------------------------
        // when text lenght equal to 1
        //-----------------------------------------------------------------------------------
        if text?.count == 1 {
            switch textField {
            case no1:
                no2.becomeFirstResponder()
            case no2:
                no3.becomeFirstResponder()
            case no3:
                no4.becomeFirstResponder()
            case no4:
                no4.becomeFirstResponder()
                view.endEditing(true)
                viewModel.textCode1Subject.send(no1.text ?? "")
                viewModel.textCode2Subject.send(no2.text ?? "")
                viewModel.textCode3Subject.send(no3.text ?? "")
                viewModel.textCode4Subject.send(no4.text ?? "")
                viewModel.didTapOnConfirm()
            default:
                break
            }
        }
        //-----------------------------------------------------------------------------------
        // when text lenght equal to 0
        //-----------------------------------------------------------------------------------
        if text?.count == 0 {
            switch textField {
            case no1:
                no1.becomeFirstResponder()
            case no2:
                no1.becomeFirstResponder()
            case no3:
                no2.becomeFirstResponder()
            case no4:
                no3.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == no1 {
            
            let maxLength = 1
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
            
        }else if textField == no2 {
            
            let maxLength = 1
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
            
        }else if textField == no3 {
            
            let maxLength = 1
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
            
        }else {
            
            let maxLength = 1
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
            
        }
        
    }
    
}
