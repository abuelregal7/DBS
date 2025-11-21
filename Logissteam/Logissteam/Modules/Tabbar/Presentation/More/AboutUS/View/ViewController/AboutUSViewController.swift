//
//  AboutUSViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 19/08/2024.
//

import UIKit

class AboutUSViewController: BaseViewControllerWithVM<AboutUSViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var aboutUsImage: UIImageView!
    @IBOutlet weak var aboutUsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.viewDidLoad()
        
        viewModel.aboutUSDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.aboutUsImage.loadPagesImage(data?.image)
                self.aboutUsTextView.text = data?.body
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
