//
//  DealDetailsViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 22/08/2024.
//

import UIKit

class DealDetailsViewController: BaseViewControllerWithVM<CategoriesDetailsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!{
        didSet {
            categoriesCollectionView.delegate = self
            categoriesCollectionView.dataSource = self
            categoriesCollectionView.register(UINib(nibName: "CategoriesDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesDetailsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var dealTitleLabel: UILabel!
    @IBOutlet weak var dealDescriptionLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var purchasePlaneLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var checkBoxTermsLabel: UILabel!
    
    @IBOutlet weak var contractsButton: UIButton!
    @IBOutlet weak var transfereOwnershipButton: UIButton!
    @IBOutlet weak var viewPaymentsButton: UIButton!
    
    var timer: Timer?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
        pageControl.currentPage = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func bind() {
        super.bind()
        
        // Send viewDidLoad event to ViewModel's input
        viewModel.input.viewDidLoad.send(())
        
        // Bind the output reloadSearchCollections to update the collection view
        viewModel.output.reloadImagesCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.categoriesCollectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.numberOfDealImages
            }
            .store(in: &cancellables)
        
        viewModel.dealDetailsDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.dealTitleLabel.text = data?.name
                self.dealDescriptionLabel.text = data?.desc?.htmlToString
                self.quantityLabel.text = "\(data?.quantity ?? 0)"
                self.priceLabel.text = (data?.reservePrice?.string.doubleValue.clean ?? "0") + " " + "SR".localized
                //self.purchasePlaneLabel.text = data.p
                //self.paymentMethodLabel.text = data?.p
                //self.checkBoxTermsLabel.text = data?.reserveTerms
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
        
        contractsButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.pushViewController(TabbarFactory.contracts(dealId: self.viewModel.getDealId()).viewController, animated: true)
            }
            .store(in: &cancellables)
        
        transfereOwnershipButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.pushViewController(TabbarFactory.transferOwnership(dealId: self.viewModel.getDealId()).viewController, animated: true)
            }
            .store(in: &cancellables)
        
        viewPaymentsButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.pushViewController(TabbarFactory.upcomingPayments(dealId: self.viewModel.getDealId()).viewController, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func scrollToNextItem() {
        let totalItems = categoriesCollectionView.numberOfItems(inSection: 0)
        
        if totalItems == 0 { return }
        
        currentIndex = (currentIndex + 1) % totalItems
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // Update the page control
        pageControl.currentPage = currentIndex
    }
    
}

extension DealDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfDealImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesDetailsCollectionViewCell", for: indexPath) as? CategoriesDetailsCollectionViewCell else { return UICollectionViewCell() }
        cell.categoryImage.loadImage(viewModel.getDealsData(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (categoriesCollectionView.frame.size.width), height: 320)
    }
    
}
