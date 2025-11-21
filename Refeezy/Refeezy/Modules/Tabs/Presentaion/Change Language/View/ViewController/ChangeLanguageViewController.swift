//
//  ChangeLanguageViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 16/04/2025.
//

import UIKit

class ChangeLanguageViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var arabicView: UIView!
    @IBOutlet weak var arabicCheckMarkIcon: UIImageView!
    
    @IBOutlet weak var englishView: UIView!
    @IBOutlet weak var englishCheckMarkIcon: UIImageView!
    
    var selectedLanguage = Language.currentAppleLanguage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()
    }
    
    override func bind() {
        super.bind()
        
        backButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        arabicView.addTapGesture { [weak self] in
            guard let self else { return }
            self.selectedLanguage = "ar"
            self.englishCheckMarkIcon.image = UIImage(named: "unCheckboxbase")
            self.arabicCheckMarkIcon.image = UIImage(named: "Checkboxbase")
        }
        
        englishView.addTapGesture { [weak self] in
            guard let self else { return }
            self.selectedLanguage = "en"
            self.arabicCheckMarkIcon.image = UIImage(named: "unCheckboxbase")
            self.englishCheckMarkIcon.image = UIImage(named: "Checkboxbase")
        }
        
        saveButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                
                if self.selectedLanguage == Language.currentAppleLanguage() {
                    self.navigationController?.popViewController(animated: true)
                }else {
                    Language.setAppleLAnguageTo(lang: self.selectedLanguage)
                    UIApplication.initWindow()
                }
                
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Functions
    func setupLocalization() {
        if Language.currentAppleLanguage() == "en" {
            arabicCheckMarkIcon.image = UIImage(named: "unCheckboxbase")
            englishCheckMarkIcon.image = UIImage(named: "Checkboxbase")
        } else {
            englishCheckMarkIcon.image = UIImage(named: "unCheckboxbase")
            arabicCheckMarkIcon.image = UIImage(named: "Checkboxbase")
        }
    }
    
}
