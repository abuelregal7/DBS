//
//  FirstRequestDetailsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class FirstRequestDetailsViewController: BaseViewControllerWithVM<FirstRequestDetailsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var containerViewOfDHMS: UIView!
    @IBOutlet weak var productNumberLabel: UILabel!
    
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomTitleLabel: UILabel!
    @IBOutlet weak var roomDescLabel: UILabel!
    
    @IBOutlet weak var superGiftTitleLabel: UILabel!
    @IBOutlet weak var superGiftImage: UIImageView!
    
    @IBOutlet weak var productsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productsTableView: UITableView!{
        didSet {
            productsTableView.delegate = self
            productsTableView.dataSource = self
            productsTableView.register(UINib(nibName: "FirstRequestDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FirstRequestDetailsTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewOfDHMS.roundCornersWithMask([.topLeading, .topTrailing], radius: 12)
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            self.productsTableViewHeight.constant = self.productsTableView.contentSize.height
            self.productsTableView.layoutIfNeeded()
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadProductsTable
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.productsTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.showOrdereDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.productNumberLabel.text = Language.isRTL ? "منتج رقم \(data?.room?.winnerItem?.itemNumber ?? "")" : "Product number \(data?.room?.winnerItem?.itemNumber ?? "")"
                self.roomImage.loadImage(data?.room?.image)
                self.roomTitleLabel.text = data?.room?.title
                self.roomDescLabel.text = data?.room?.description
                self.superGiftTitleLabel.text = data?.room?.superGift?.title
                self.superGiftImage.loadImage(data?.room?.superGift?.image)
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
        
    }
    
}

extension FirstRequestDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productsTableView.dequeueReusableCell(withIdentifier: "FirstRequestDetailsTableViewCell", for: indexPath) as? FirstRequestDetailsTableViewCell else { return UITableViewCell() }
        let item = viewModel.getProductData(index: indexPath.row)
        cell.configure(item: item)
        return cell
    }
    
}
