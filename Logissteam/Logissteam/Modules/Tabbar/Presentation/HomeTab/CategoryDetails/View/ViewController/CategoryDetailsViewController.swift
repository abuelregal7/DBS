//
//  CategoryDetailsViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 21/08/2024.
//

import UIKit

class CategoryDetailsViewController: BaseViewControllerWithVM<CategoriesDetailsViewModel> {
    
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
    @IBOutlet weak var reserveTermsTextView: UILabel!
    
    @IBOutlet weak var purchasePlansButton: UIButton!
    @IBOutlet weak var bookDealButton: UIButton!
    @IBOutlet weak var buyDealButton: UIButton!
    
    @IBOutlet weak var receivingDealButton: UIButton!
    @IBOutlet weak var approvalPowerButton: UIButton!
    @IBOutlet weak var receivingDealSelectButton: UIButton!
    @IBOutlet weak var approvalPowerSelectButton: UIButton!
    
    @IBOutlet weak var reservationDurationValueLabel: UILabel!
    @IBOutlet weak var bookConditionValueLabel: UILabel!
    @IBOutlet weak var costValueLabel: UILabel!
    
    var timer: Timer?
    var currentIndex = 0
    
    private var planId: Int?
    private var planTitle: String?
    private var checkBoxSelect: String = ""
    
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
                self.priceLabel.text = (data?.price?.string.doubleValue.clean ?? "0") + " " + "SR".localized
                //self.reserveTermsTextView.text = data?.reserveTerms
                self.reservationDurationValueLabel.text = "\(data?.reserveDays ?? 0)" + " " + "day".localized
                self.bookConditionValueLabel.text = data?.reserveTerms
                self.costValueLabel.text = (data?.reservePrice?.string.doubleValue.clean ?? "0") + " " + "SR".localized
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
        
        purchasePlansButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.pushViewController(TabbarFactory.purchasePlanes(dealId: self.viewModel.getDealId(), CallBacks: { [weak self] id, title in
                    guard let self = self else { return }
                    print(id, title)
                    self.planId = id
                    self.planTitle = title
                }).viewController, animated: true) //buyDeal
            }
            .store(in: &cancellables)
        
        receivingDealSelectButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.receivingDealButton.setImage(UIImage(named: "checkbox"), for: .normal)
                self.approvalPowerButton.setImage(UIImage(named: "unCheckbox"), for: .normal)
                self.checkBoxSelect = "Receiving the deal".localized
            }
            .store(in: &cancellables)
        
        approvalPowerSelectButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.receivingDealButton.setImage(UIImage(named: "unCheckbox"), for: .normal)
                self.approvalPowerButton.setImage(UIImage(named: "checkbox"), for: .normal)
                self.checkBoxSelect = "Approval of a power of attorney to sell the deal".localized
            }
            .store(in: &cancellables)
        
        bookDealButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                
                guard planId != nil else {
                    self.showAlert(title: "", message: "Please, select purchase plan".localized)
                    return
                }
                
                guard checkBoxSelect != "" else {
                    let msg = "Please".localized + " " + "select".localized + " " + "Receiving the deal".localized + " " + "or".localized + " " + "Approval of a power of attorney to sell the deal".localized
                    self.showAlert(title: "", message: msg)
                    return
                }
                
                self.navigationController?.pushViewController(TabbarFactory.bookDeal(dealId: self.viewModel.getDealId(), planId: self.planId, planTitle: self.planTitle, checkBoxSelect: self.checkBoxSelect).viewController, animated: true)
            }
            .store(in: &cancellables)
        
        buyDealButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                
                guard planId != nil else {
                    self.showAlert(title: "", message: "Please, select purchase plan".localized)
                    return
                }
                
                guard checkBoxSelect != "" else {
                    let msg = "Please".localized + " " + "select".localized + " " + "Receiving the deal".localized + " " + "or".localized + " " + "Approval of a power of attorney to sell the deal".localized
                    self.showAlert(title: "", message: msg)
                    return
                }
                
                self.navigationController?.pushViewController(TabbarFactory.buyDeal(dealId: self.viewModel.getDealId(), planId: self.planId, planTitle: self.planTitle, checkBoxSelect: self.checkBoxSelect).viewController, animated: true)
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

extension CategoryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
