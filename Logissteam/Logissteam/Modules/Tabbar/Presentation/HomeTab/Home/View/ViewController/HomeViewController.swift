//
//  HomeViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 19/08/2024.
//

import UIKit

class HomeViewController: BaseViewControllerWithVM<HomeViewModel> {
    
    @IBOutlet weak var homeScrollView: UIScrollView!{
        didSet {
            homeScrollView.delegate = self
        }
    }
    @IBOutlet weak var bannerCollectionView: UICollectionView!{
        didSet {
            bannerCollectionView.delegate = self
            bannerCollectionView.dataSource = self
            bannerCollectionView.register(UINib(nibName: "HomeBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBannerCollectionViewCell")
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var categoriesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!{
        didSet {
            categoriesCollectionView.delegate = self
            categoriesCollectionView.dataSource = self
            categoriesCollectionView.register(UINib(nibName: "HomeCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoriesCollectionViewCell")
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    var timer: Timer?
    var currentIndex = 0
    
    var planId: Int?
    var planTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
        pageControl.currentPage = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.updateConstraintsIfNeeded()
            self.view.layoutIfNeeded()
            
            // Dynamically adjust the height of the collection view based on its content size
            self.categoriesCollectionViewHeight.constant = self.categoriesCollectionView.contentSize.height
            self.categoriesCollectionView.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func bind() {
        super.bind()
        
        userNameLabel.text = UD.user?.name
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadHomeCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.bannerCollectionView.reloadData()
                self.categoriesCollectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.numberOfSlider
            }
            .store(in: &cancellables)
        
        searchButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.present(TabbarFactory.categoriesSearch(dismiss: { [weak self] dealId in
                    guard let self else { return }
                    self.navigationController?.pushViewController(TabbarFactory.categoryDetaisl(dealId: dealId).viewController, animated: true)
                }).viewController, animated: true)
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
        let totalItems = bannerCollectionView.numberOfItems(inSection: 0)
        
        if totalItems == 0 { return }
        
        currentIndex = (currentIndex + 1) % totalItems
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // Update the page control
        pageControl.currentPage = currentIndex
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Ensure the collection view is still scrolling and has more deals to load
        guard viewModel.getHasMoreDeals() else { return }
        
        // Calculate how far the user has scrolled
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Prevent triggering pagination if the content is not long enough
        guard contentHeight > frameHeight else { return }
        
        // Trigger pagination when the user scrolls near the bottom (e.g., 100 points before the end)
        if contentOffsetY > contentHeight - frameHeight - 100 {
            print("Triggering pagination for next page")
            viewModel.input.reloadWithFilter.send(.nextPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return viewModel.numberOfSlider
        }else {
            return viewModel.numberOfDeals
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            
            guard let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else { return UICollectionViewCell() }
            let item = viewModel.getSliderData(at: indexPath.item)
            cell.configure(item: item)
            return cell
            
        }else {
            
            guard let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoriesCollectionViewCell", for: indexPath) as? HomeCategoriesCollectionViewCell else { return UICollectionViewCell() }
            let item = viewModel.getDealsData(at: indexPath.item)
            cell.configure(item: item)
            cell.PurchasePlanes = { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(TabbarFactory.purchasePlanes(dealId: item?.id, CallBacks: { [weak self] id, title in
                    guard let self = self else { return }
                    print(id, title)
                    self.planId = id
                    self.planTitle = title
                }).viewController, animated: true)
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            
        }else {
            let item = viewModel.getDealsData(at: indexPath.item)
            navigationController?.pushViewController(TabbarFactory.categoryDetaisl(dealId: item?.id).viewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: (bannerCollectionView.frame.size.width), height: 137)
        }else {
            return CGSize(width: (categoriesCollectionView.frame.size.width - 10) / 2, height: 310)
        }
    }
    
}
