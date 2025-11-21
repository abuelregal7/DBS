//
//  TermsConditionsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 16/04/2025.
//

import UIKit

class TermsConditionsViewController: BaseViewControllerWithVM<TermsConditionsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var termsConditionsImage: UIImageView!
    @IBOutlet weak var termsConditionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.viewDidLoad()
        
        viewModel.termsConditionsDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.termsConditionsImage.loadPagesImage(data?.image)
                self.termsConditionsTextView.text = data?.body?.htmlToString
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
