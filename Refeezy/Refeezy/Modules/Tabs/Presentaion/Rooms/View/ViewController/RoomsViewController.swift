//
//  RoomsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/03/2025.
//

import UIKit

class RoomsViewController: BaseViewControllerWithVM<RoomesViewModel> {
    
    @IBOutlet weak var roomsCollectionView: UICollectionView!{
        didSet {
            roomsCollectionView.contentInset.bottom = 80
            roomsCollectionView.delegate = self
            roomsCollectionView.dataSource = self
            roomsCollectionView.register(UINib(nibName: "HomeRoomsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeRoomsCollectionViewCell")
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var emptyStateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add Refresh Control
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshRoomsCollectionView), for: .valueChanged)
        roomsCollectionView.refreshControl = refreshControl
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadRoomesCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.roomsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isEmptyStatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmpty in
                guard let self else { return }
                self.emptyStateView.isHidden = !isEmpty
                self.roomsCollectionView.isHidden = isEmpty
            }
            .store(in: &cancellables)
        
    }
    
    @objc private func refreshRoomsCollectionView() {
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
                self.roomsCollectionView.reloadData()
            }
        }
    }
    
}

extension RoomsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.getHasMoreRoomes() else { return }
        if indexPath.row == viewModel.numberOfRoomes - 3 {
            viewModel.input.reloadWithFilter.send(.nextPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRoomes
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = roomsCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeRoomsCollectionViewCell", for: indexPath) as? HomeRoomsCollectionViewCell else { return UICollectionViewCell() }
        let item = viewModel.getRoomesData(at: indexPath.item)
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.getRoomesData(at: indexPath.item)
        navigationController?.pushViewController(TabsVCBuilder.roomDetails(roomID: item?.id).viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (roomsCollectionView.frame.size.width) / 2, height: 325)
    }
    
}
