//
//  EyeButton.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

class EyeButton: UIButton {
    
    private var didSelect: () -> Void = { } {
        willSet {}
    }

    private var didDeselect: () -> Void = { } {
        willSet {}
    }

    var isOn: Bool {
        didSet {
            if isOn {
                let image = #imageLiteral(resourceName: "show-password-icon").withRenderingMode(.alwaysTemplate)
                tintColor = tintColor
                setImage(image, for: .normal)
            } else {
                let image = #imageLiteral(resourceName: "hide").withRenderingMode(.alwaysTemplate)
                tintColor = tintColor
                setImage(image, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isOn = false
    }

    override init(frame: CGRect) {
        self.isOn = false
        super.init(frame: CGRect(x: frame.minX, y: frame.minY, width: 24, height: 24))
        addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        self.isOn = false
        super.init(coder: coder)
        addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }

    // MARK: - Callbacks
    public func onSelect(execute closure: @escaping () -> Void) {
        didSelect = closure
    }

    public func onDeselect(execute closure: @escaping () -> Void) {
        didDeselect = closure
    }

    @objc func clickAction() {
        isOn = !isOn
        if isOn {
            didSelect()
        } else {
            didDeselect()
        }
    }
}
