//
//  GiftsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 11/03/2025.
//

import UIKit

class GiftsViewController: BaseViewControllerWithVM<GiftsViewModel> {
    
    @IBOutlet weak var giftsCollectionView: UICollectionView!{
        didSet {
            giftsCollectionView.contentInset.bottom = 80
            giftsCollectionView.delegate = self
            giftsCollectionView.dataSource = self
            giftsCollectionView.register(UINib(nibName: "HomeGiftsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeGiftsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var emptyStateView: UIView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add Refresh Control
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshGiftsCollectionView), for: .valueChanged)
        giftsCollectionView.refreshControl = refreshControl
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadGiftsCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.giftsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isEmptyStatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmpty in
                guard let self else { return }
                self.emptyStateView.isHidden = !isEmpty
                self.giftsCollectionView.isHidden = isEmpty
            }
            .store(in: &cancellables)
        
    }
    
    @objc private func refreshGiftsCollectionView() {
        fetchDataFromAPI()
    }
    
    private func fetchDataFromAPI() {
        // Simulate API call
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            // Fetch your data here (e.g., URLSession or your networking layer)
            self.viewModel.input.viewDidLoad.send()
            // Once done, update UI on main thread
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.refreshControl.endRefreshing()
                self.giftsCollectionView.reloadData()
            }
        }
    }
    
}

extension GiftsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGifts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = giftsCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeGiftsCollectionViewCell", for: indexPath) as? HomeGiftsCollectionViewCell else { return UICollectionViewCell() }
        cell.viewCardHeight.constant = 82
        cell.imageHeight.constant = 75
        cell.imageWidth.constant = 95
        cell.giftTitleLabel.font = .appFont(ofSize: 10, weight: .heavy)
        let items = viewModel.getGiftsData(at: indexPath.item)
        cell.configure(item: items)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (giftsCollectionView.frame.size.width - 30) / 3, height: 125)
    }
    
}
