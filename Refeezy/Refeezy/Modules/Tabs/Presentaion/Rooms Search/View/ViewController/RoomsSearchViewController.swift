//
//  RoomsSearchViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/05/2025.
//

import UIKit

class RoomsSearchViewController: BaseViewControllerWithVM<RoomesViewModel> {
    
    @IBOutlet weak var searchTF: LimitedLengthField!
    @IBOutlet weak var removeTextButton: UIButton!
    
    @IBOutlet weak var roomsCollectionView: UICollectionView!{
        didSet {
            roomsCollectionView.contentInset.bottom = 80
            roomsCollectionView.delegate = self
            roomsCollectionView.dataSource = self
            roomsCollectionView.register(UINib(nibName: "HomeRoomsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeRoomsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var emptyStateView: UIView!
    
    var dismiss: ((Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.becomeFirstResponder()
    }
    
    override func bind() {
        super.bind()
        
        setupSearchBarListeners()
        
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
    
    func setupSearchBarListeners() {
        
        //let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
        //publisher.compactMap {
        //    ($0.object as! UISearchTextField).text
        //}
        
        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTF)
        publisher.compactMap {
            ($0.object as! UITextField).text
        }
        .debounce(for: .milliseconds(600), scheduler: RunLoop.main)
        .sink { [weak self] (search) in
            guard let self = self else { return }
            if search == "" {
                print("search is empty")
                self.viewModel.input.reloadWithFilter.send(.search(text: ""))
            } else {
                self.viewModel.input.reloadWithFilter.send(.search(text: search))
            }
            
        }.store(in: &cancellables)
        
    }
    
}

extension RoomsSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        dismissAllViewControllers(animated: true) { [weak self] in
            guard let self = self else { return }
            let item = viewModel.getRoomesData(at: indexPath.row)
            self.dismiss?(item?.id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (roomsCollectionView.frame.size.width) / 2, height: 325)
    }
    
}
