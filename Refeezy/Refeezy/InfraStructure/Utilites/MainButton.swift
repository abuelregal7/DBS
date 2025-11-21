//
//  MainButton.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

enum MainButtonStatus: String {
    case filled = "Filled"
    case bordered = "Bordered"
    case dimmed = "Dimmed"
}

class MainButton: UIButton {

    private var mainButtonStatus: MainButtonStatus = .filled
    
    // MARK: - IBInspectable
    @IBInspectable var status: String {
        get {
            return mainButtonStatus.rawValue
        }
        set {
            self.mainButtonStatus = MainButtonStatus.init(rawValue: newValue) ?? .filled
            configure()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.PrimaryOrange {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = .appFont(ofSize: 14, weight: .medium)
        self.layer.cornerRadius = 8
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    // MARK: - Functions
    private func configure() {
        switch mainButtonStatus {
        case .filled:
            filledState()
        case .bordered:
            borderedState()
        case .dimmed:
            dimmedState()
        }
    }
    
    private func filledState() {
        backgroundColor = color
        setTitleColor(.white, for: .normal)
        layer.borderColor = nil
        layer.borderWidth = 0
    }
    
    private func borderedState() {
        backgroundColor = .clear
        setTitleColor(color, for: .normal)
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
    }
    private func dimmedState() {
        backgroundColor = .lightGray
        setTitleColor(.gray, for: .normal)
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
    }
}
