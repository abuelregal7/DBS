//
//  PhotoPreviewViewController.swift
//  Wala
//
//  Created by Ahmed Abo Al-Regal on 04/12/2024.
//

import UIKit

class PhotoPreviewViewController: BaseViewController {
    
    @IBOutlet weak var parentContainerView: UIView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    private var fromRegister: Bool?
    
    private var imageToPreview: String?
    private var imageeToPreview: UIImage?
    
    init(fromRegister: Bool?, imageToPreview: String?, imageeToPreview: UIImage?) {
        self.fromRegister = fromRegister
        self.imageToPreview = imageToPreview
        self.imageeToPreview = imageeToPreview
        super.init(nibName: "PhotoPreviewViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        self.parentContainerView.addGestureRecognizer(tapGesture)
        
        if fromRegister == true {
            imageViewOutlet.image = imageeToPreview
        }else{
            imageViewOutlet.loadImage(imageToPreview)
        }
        
    }
    
}
