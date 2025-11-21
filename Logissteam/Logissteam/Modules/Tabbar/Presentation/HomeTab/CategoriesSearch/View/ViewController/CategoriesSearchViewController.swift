//
//  CategoriesSearchViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 21/08/2024.
//

import UIKit

class CategoriesSearchViewController: BaseViewControllerWithVM<CategoriesSearchViewModel> {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!{
        didSet {
            categoriesCollectionView.keyboardDismissMode = .onDrag
            categoriesCollectionView.delegate = self
            categoriesCollectionView.dataSource = self
            categoriesCollectionView.register(UINib(nibName: "HomeCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoriesCollectionViewCell")
        }
    }
    
    @IBOutlet weak var searchTF: LimitedLengthField!
    @IBOutlet weak var removeTextButton: UIButton!
    
    var dismiss: ((Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.becomeFirstResponder()
    }
    
    override func bind() {
        super.bind()
        
        setupSearchBarListeners()
        
        // Send viewDidLoad event to ViewModel's input
        viewModel.input.viewDidLoad.send(())
        
        // Bind the output reloadSearchCollections to update the collection view
        viewModel.output.reloadSearchCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.categoriesCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        removeTextButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.searchTF.text = ""
                self.viewModel.input.reloadWithFilter.send(.search(text: ""))
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

extension CategoriesSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.getHasisLoadingMore() else { return }
        if indexPath.row == viewModel.numberOfDeals - 5 {
            viewModel.input.reloadWithFilter.send(.nextPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfDeals
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoriesCollectionViewCell", for: indexPath) as? HomeCategoriesCollectionViewCell else { return UICollectionViewCell() }
        let item = viewModel.getDealsData(at: indexPath.row)
        cell.configureSearch(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissAllViewControllers(animated: true) { [weak self] in
            guard let self = self else { return }
            let item = viewModel.getDealsData(at: indexPath.row)
            self.dismiss?(item?.id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (categoriesCollectionView.frame.size.width - 10) / 2, height: 310)
    }
    
}
