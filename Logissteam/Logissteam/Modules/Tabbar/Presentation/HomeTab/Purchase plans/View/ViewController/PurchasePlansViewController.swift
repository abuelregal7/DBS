//
//  PurchasePlansViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 21/08/2024.
//

import UIKit
import SafariServices

class PurchasePlansViewController: BaseViewControllerWithVM<PurchasePlansViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var plansCollectionView: UICollectionView!{
        didSet {
            plansCollectionView.delegate = self
            plansCollectionView.dataSource = self
            
            plansCollectionView.register(UINib(nibName: "PurchasesPlansCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PurchasesPlansCollectionViewCell")
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer: Timer?
    var currentIndex = 0
    
    var index = 0
    var CallBacks: ((Int, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadPurchasePlansCollection
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.plansCollectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.numberOfPurchasePlans
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
    
    func openPDFInSafari(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
}

extension PurchasePlansViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Detect scrolling to update the page control
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPurchasePlans
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = plansCollectionView.dequeueReusableCell(withReuseIdentifier: "PurchasesPlansCollectionViewCell", for: indexPath) as? PurchasesPlansCollectionViewCell else { return UICollectionViewCell() }
        let item = viewModel.getPurchasePlansData(at: indexPath.item)
        cell.configure(item: item)
        if indexPath.row == index {
            cell.containerView.layer.borderColor = UIColor.white.cgColor
            cell.containerView.layer.borderWidth = 1
        }else {
            cell.containerView.layer.borderColor = UIColor.clear.cgColor
            cell.containerView.layer.borderWidth = 0
        }
        
        cell.DownloadAction = { [weak self] in
            guard let self = self else { return }
            //self.openPDF(link: item?.attachment ?? "")
            self.openPDFInSafari(urlString: item?.attachment ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.getPurchasePlansData(at: indexPath.item)
        index = indexPath.item
        plansCollectionView.reloadData()
        CallBacks?(item?.id ?? 0, item?.title ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (plansCollectionView.frame.size.width), height: 500)
    }
    
}
