//
//  HomeViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/03/2025.
//

import UIKit
import SafariServices

class HomeViewController: BaseViewControllerWithVM<HomeViewModel> {
    
    @IBOutlet weak var parentScrollView: UIScrollView!{
        didSet {
            parentScrollView.contentInset.bottom = 80
        }
    }
    
    @IBOutlet weak var welcomeANdNameLabel: UILabel!
    @IBOutlet weak var notificationCountLabel: PaddedLabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView!{
        didSet {
            bannerCollectionView.delegate = self
            bannerCollectionView.dataSource = self
            bannerCollectionView.register(UINib(nibName: "HomeBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBannerCollectionViewCell")
        }
    }
    
    @IBOutlet weak var roomsCollectionView: UICollectionView!{
        didSet {
            roomsCollectionView.delegate = self
            roomsCollectionView.dataSource = self
            roomsCollectionView.register(UINib(nibName: "HomeRoomsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeRoomsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var giftsCollectionView: UICollectionView!{
        didSet {
            giftsCollectionView.contentInset.left = 16
            giftsCollectionView.contentInset.right = 16
            giftsCollectionView.delegate = self
            giftsCollectionView.dataSource = self
            giftsCollectionView.register(UINib(nibName: "HomeGiftsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeGiftsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var solidRoomsCollectionView: UICollectionView!{
        didSet {
            solidRoomsCollectionView.delegate = self
            solidRoomsCollectionView.dataSource = self
            solidRoomsCollectionView.register(UINib(nibName: "SoldRoomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SoldRoomCollectionViewCell")
        }
    }
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var notificationView: UIView!
    
    let refreshControl = UIRefreshControl()
    
    var timer: Timer?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the refresh control
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        parentScrollView.addSubview(refreshControl) // Add refresh control to the scroll view
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notificationCountLabel.layer.masksToBounds = true
        notificationCountLabel.layer.cornerRadius = notificationCountLabel.frame.size.height / 2
    }
    
    override func bind() {
        super.bind()
        
        welcomeANdNameLabel.text = ("Welcome".localized) + (" ") + (UD.user?.name ?? "") + (" ") + ("!")
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadHomeCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.bannerCollectionView.reloadData()
                self.roomsCollectionView.reloadData()
                self.giftsCollectionView.reloadData()
                self.solidRoomsCollectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.numberOfSliders
            }
            .store(in: &cancellables)
        
        searchButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                let vc = TabsVCBuilder.roomsSearch(dismiss: { [weak self] roomId in
                    guard let self else { return }
                    self.navigationController?.pushViewController(TabsVCBuilder.roomDetails(roomID: roomId).viewController, animated: true)
                }).viewController
                self.present(vc, animated: true)
            }
            .store(in: &cancellables)
        
        notificationView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            
        }
        
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
    
    @objc private func handleRefresh() {
        // Perform your data loading or other actions here
        print("Refreshing data...")
        viewModel.input.viewDidLoad.send()
        
        if bannerCollectionView.numberOfItems(inSection: 0) > 0 {
            bannerCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        if roomsCollectionView.numberOfItems(inSection: 0) > 0 {
            roomsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        if giftsCollectionView.numberOfItems(inSection: 0) > 0 {
            giftsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        if solidRoomsCollectionView.numberOfItems(inSection: 0) > 0 {
            solidRoomsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }

        // End refreshing after a delay (simulate network loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
    }
    
    func openPDFInSafari(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(page)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return viewModel.numberOfSliders
        }else if collectionView == roomsCollectionView {
            return viewModel.numberOfRooms
        }else if collectionView == giftsCollectionView {
            return viewModel.numberOfGifts
        }else {
            return viewModel.numberOfCompletedRooms
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            guard let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else { return UICollectionViewCell() }
            let item = viewModel.getSlidersData(at: indexPath.item)
            cell.configure(item: item)
            return cell
        }else if collectionView == roomsCollectionView {
            guard let cell = roomsCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeRoomsCollectionViewCell", for: indexPath) as? HomeRoomsCollectionViewCell else { return UICollectionViewCell() }
            let item = viewModel.getRoomsData(at: indexPath.item)
            cell.configure(item: item)
            return cell
        }else if collectionView == giftsCollectionView {
            guard let cell = giftsCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeGiftsCollectionViewCell", for: indexPath) as? HomeGiftsCollectionViewCell else { return UICollectionViewCell() }
            let item = viewModel.getGiftsData(at: indexPath.item)
            cell.configure(item: item)
            return cell
        }else {
            guard let cell = solidRoomsCollectionView.dequeueReusableCell(withReuseIdentifier: "SoldRoomCollectionViewCell", for: indexPath) as? SoldRoomCollectionViewCell else { return UICollectionViewCell() }
            let item = viewModel.getCompletedRoomsData(at: indexPath.item)
            cell.configure(item: item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: bannerCollectionView.frame.size.width, height: 210)
        }else if collectionView == roomsCollectionView {
            return CGSize(width: 230, height: 325)
        }else if collectionView == giftsCollectionView {
            return CGSize(width: 70, height: 90)
        }else {
            return CGSize(width: 230, height: 325)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            let item = viewModel.getSlidersData(at: indexPath.item)
            if item?.roomID == nil {
                openPDFInSafari(urlString: item?.url ?? "")
            }else {
                navigationController?.pushViewController(TabsVCBuilder.roomDetails(roomID: item?.id).viewController, animated: true)
            }
        }else if collectionView == roomsCollectionView {
            let item = viewModel.getRoomsData(at: indexPath.item)
            navigationController?.pushViewController(TabsVCBuilder.roomDetails(roomID: item?.id).viewController, animated: true)
        }else if collectionView == giftsCollectionView {
            
        }else {
            let item = viewModel.getCompletedRoomsData(at: indexPath.item)
            if item?.expiredAt == nil {
                navigationController?.pushViewController(TabsVCBuilder.firstRequestDetails(roomID: item?.id).viewController, animated: true)
            }else {
                navigationController?.pushViewController(TabsVCBuilder.secondRequestDetails(roomID: item?.id).viewController, animated: true)
            }
        }
    }
    
}
