//
//  RoomDetailsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/03/2025.
//

import UIKit

class RoomDetailsViewController: BaseViewControllerWithVM<RoomDetailsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            scrollView.contentInset.bottom = 200
        }
    }
    @IBOutlet weak var buyNowButton: UIButton!
    
    @IBOutlet weak var roomImagesCollectionView: UICollectionView! {
        didSet{
            roomImagesCollectionView.delegate = self
            roomImagesCollectionView.dataSource = self
            roomImagesCollectionView.register(UINib(nibName: "HomeBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBannerCollectionViewCell")
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var roomTitleLabel: UILabel!
    @IBOutlet weak var roomDescLabel: UILabel!
    
    @IBOutlet weak var productPricdLabel: UILabel!
    @IBOutlet weak var totalProductsLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBOutlet weak var superRoomGiftTitleLabel: UILabel!
    @IBOutlet weak var superRoomGiftSubTitleLabel: UILabel!
    @IBOutlet weak var superGiftImage: UIImageView!
    @IBOutlet weak var superGiftTitleLabel: UILabel!
    @IBOutlet weak var superGiftDescLabel: UILabel!
    
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
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadRoomesCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.roomImagesCollectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.numberOfRoomesImages
            }
            .store(in: &cancellables)
        
        viewModel.roomDetailsDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                roomTitleLabel.text = data?.title
                roomDescLabel.text = data?.description
                superGiftImage.loadImage(data?.superGift?.image)
                superGiftDescLabel.text = data?.superGift?.title
                let attachment = NSTextAttachment()
                
                // Use image and apply rendering mode to support tint color
                if let image = UIImage(named: "sar_symbol")?.withRenderingMode(.alwaysTemplate) {
                    let tintedImage = image.withTintColor(UIColor().colorWithHexString(hexString: "#F0F0F0"), renderingMode: .alwaysOriginal) // or .alwaysTemplate if UILabel has tintColor
                    attachment.image = tintedImage
                    
                    // Optional: resize
                    attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                    
                    let attachmentString = NSAttributedString(attachment: attachment)
                    let fullString = NSMutableAttributedString(string: "")
                    fullString.append(attachmentString)
                    fullString.append(NSAttributedString(string: "\(data?.price ?? 0)"))
                    productPricdLabel.attributedText = fullString
                }
                totalProductsLabel.text = "\(data?.productCount ?? 0)"
                remainingLabel.text = "\(data?.remainCount ?? 0)"
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
        
        buyNowButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.pushViewController(TabsVCBuilder.roomItems(roomID: self.viewModel.getRoomID(), price: self.viewModel.getPrice()).viewController, animated: true)
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
        let totalItems = roomImagesCollectionView.numberOfItems(inSection: 0)
        
        if totalItems == 0 { return }
        
        currentIndex = (currentIndex + 1) % totalItems
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        roomImagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // Update the page control
        pageControl.currentPage = currentIndex
    }
    
}

extension RoomDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(page)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRoomesImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = roomImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else { return UICollectionViewCell() }
        let item = viewModel.getRoomesImagesData(at: indexPath.item)
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (roomImagesCollectionView.frame.size.width), height: 285)
    }
    
}
