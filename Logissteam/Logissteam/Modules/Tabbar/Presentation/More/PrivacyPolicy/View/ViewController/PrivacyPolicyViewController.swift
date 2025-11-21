//
//  PrivacyPolicyViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 19/08/2024.
//

import UIKit

class PrivacyPolicyViewController: BaseViewControllerWithVM<PrivacyPolicyViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var privacyPolicyImage: UIImageView!
    @IBOutlet weak var privacyPolicyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.viewDidLoad()
        
        viewModel.privacyPolicyDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.privacyPolicyImage.loadPagesImage(data?.image)
                self.privacyPolicyTextView.text = data?.body
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
    
}
