//
//  ChangeLanguageViewController.swift
//  Wala
//
//  Created by Ahmed Abo Al-Regal on 27/04/2024.
//

import UIKit

class ChangeLanguageViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backTitleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var arabicCheckMarkIcon: UIImageView!
    
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var englishCheckMarkIcon: UIImageView!
    
    @IBOutlet weak var topContainerView: UIView!
    
    // MARK: - Variables
    var selectedLanguage = Language.currentAppleLanguage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()
        
    }
    
    override func bind() {
        super.bind()
        
        backTitleLabel.addTapGesture { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        backButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        saveButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                
                if selectedLanguage == Language.currentAppleLanguage() {
                    self.navigationController?.popViewController(animated: true)
                }else {
                    Language.setAppleLAnguageTo(lang: selectedLanguage)
                    UIApplication.initWindow()
                }
                
                //UD.languageState = false
            }
            .store(in: &cancellables)
        
        arabicButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.selectedLanguage = "ar"
                self.englishCheckMarkIcon.tintColor = UIColor.clear
                self.arabicCheckMarkIcon.tintColor = UIColor().colorWithHexString(hexString: "EFEDFD")
            }
            .store(in: &cancellables)
        
        englishButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.selectedLanguage = "en"
                self.arabicCheckMarkIcon.tintColor = UIColor.clear
                self.englishCheckMarkIcon.tintColor = UIColor().colorWithHexString(hexString: "EFEDFD")
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Functions
    func setupLocalization() {
        if Language.currentAppleLanguage() == "en" {
            arabicCheckMarkIcon.tintColor = UIColor.clear
            englishCheckMarkIcon.tintColor = UIColor().colorWithHexString(hexString: "EFEDFD")
        } else {
            englishCheckMarkIcon.tintColor = UIColor.clear
            arabicCheckMarkIcon.tintColor = UIColor().colorWithHexString(hexString: "EFEDFD")
        }
    }
    
}
