//
//  MyAddressesViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class MyAddressesViewController: BaseViewControllerWithVM<MyAddressesViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var myAddressesTableView: UITableView!{
        didSet {
            myAddressesTableView.separatorStyle = .none
            myAddressesTableView.delegate = self
            myAddressesTableView.dataSource = self
            myAddressesTableView.register(UINib(nibName: "MyAddressesTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAddressesTableViewCell")
        }
    }
    
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var addNewAddressButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshMyAddressesTableView), for: .valueChanged)
        myAddressesTableView.refreshControl = refreshControl
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadMyAddressesCollections
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.myAddressesTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isEmptyStatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmpty in
                guard let self else { return }
                self.emptyStateView.isHidden = !isEmpty
                self.myAddressesTableView.isHidden = isEmpty
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
        
        addNewAddressButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.present(TabsVCBuilder.addNewAddress(Reload: { [weak self] in
                    guard let self else { return }
                    self.viewModel.input.viewDidLoad.send()
                }, address: nil, city: nil, lat: nil, long: nil).viewController, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    @objc private func refreshMyAddressesTableView() {
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
                self.myAddressesTableView.reloadData()
            }
        }
    }
    
}

extension MyAddressesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMyAddresses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myAddressesTableView.dequeueReusableCell(withIdentifier: "MyAddressesTableViewCell", for: indexPath) as? MyAddressesTableViewCell else { return UITableViewCell() }
        
        let item = viewModel.getMyAddressesData(at: indexPath.row)
        
        cell.configuare(item: item)
        
        cell.DeleteAddressAction = { [weak self] in
            guard let self = self else { return }
            if item?.isDefault == 1 {
                print("Do Nothing")
            }else {
                self.viewModel.addressID.send(item?.id)
                self.viewModel.input.reloadWithFilter.send(.delete)
            }
        }
        
        cell.MakeAddressDefualtAction = { [weak self] in
            guard let self = self else { return }
            if item?.isDefault == 1 {
                print("Do Nothing")
            }else {
                self.viewModel.addressID.send(item?.id)
                self.viewModel.input.reloadWithFilter.send(.makeDefualt)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = viewModel.getMyAddressesData(at: indexPath.row)
    }
    
}
