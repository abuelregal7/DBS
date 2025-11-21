//
//  ChooseProductsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 02/04/2025.
//

import UIKit

class ChooseProductsViewController: BaseViewControllerWithVM<ChooseProductsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet {
            mainScrollView.contentInset.bottom = 150
        }
    }
    @IBOutlet weak var productsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productsCollectionView: UICollectionView!{
        didSet {
            productsCollectionView.delegate = self
            productsCollectionView.dataSource = self
            productsCollectionView.register(UINib(nibName: "ChooseProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChooseProductsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var selectedProductsCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productsPriceSymbolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attachment = NSTextAttachment()
        
        // Use image and apply rendering mode to support tint color
        if let image = UIImage(named: "sar_symbol")?.withRenderingMode(.alwaysTemplate) {
            let tintedImage = image.withTintColor(UIColor().colorWithHexString(hexString: "#FFBE18"), renderingMode: .alwaysOriginal) // or .alwaysTemplate if UILabel has tintColor
            attachment.image = tintedImage
            
            // Optional: resize
            attachment.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
            
            let attachmentString = NSAttributedString(attachment: attachment)
            let fullString = NSMutableAttributedString(string: "")
            fullString.append(attachmentString)
            productsPriceSymbolLabel.attributedText = fullString
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            self.productsCollectionViewHeight.constant = self.productsCollectionView.contentSize.height
            self.productsCollectionView.layoutIfNeeded()
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadProductsCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.productsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isEmptyStatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmpty in
                guard let self else { return }
                self.emptyStateView.isHidden = !isEmpty
                self.productsCollectionView.isHidden = isEmpty
            }
            .store(in: &cancellables)
        
        viewModel.totalPriceSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] total in
                guard let self else { return }
                self.totalPriceLabel.text = "\(total ?? 0)"
            }
            .store(in: &cancellables)
        
        viewModel.selectedProductsCountSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                guard let self else { return }
                selectedProductsCountLabel.text = "\(count ?? 0)"
            }
            .store(in: &cancellables)
        
        backButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        buyButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.pushViewController(TabsVCBuilder.firstPaymentOperation(productsData: self.viewModel.getProducts(), roomID: self.viewModel.getRoomID()).viewController, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
}

extension ChooseProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "ChooseProductsCollectionViewCell", for: indexPath) as? ChooseProductsCollectionViewCell else { return UICollectionViewCell() }
        let item = viewModel.getProductsData(at: indexPath.item)
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.toggleProductsSelected(at: indexPath.item)
        let _ = viewModel.getSelectedProductsTotalPrice()
        productsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (productsCollectionView.frame.size.width - 10) / 2, height: 275)
    }
    
}
