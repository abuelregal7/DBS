//
//  CurrentPreviousRequestsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class CurrentPreviousRequestsViewController: BaseViewControllerWithVM<CurrentPreviousRequestsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var requestsTableView: UITableView!{
        didSet {
            requestsTableView.delegate = self
            requestsTableView.dataSource = self
            requestsTableView.register(UINib(nibName: "CurrentPreviousRequestsTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentPreviousRequestsTableViewCell")
        }
    }
    
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var containerViewOfSegment: UIView!
    @IBOutlet weak var currentRequestsLabel: UILabel!
    @IBOutlet weak var currentRequestsSelectedView: UIImageView!
    @IBOutlet weak var currentRequestsButton: UIStackView!
    
    @IBOutlet weak var previousRequestsLabel: UILabel!
    @IBOutlet weak var previousRequestsSelectedView: UIImageView!
    @IBOutlet weak var previousRequestsButton: UIStackView!
    
    let refreshControl = UIRefreshControl()
    
    private var requestType: String = "previous"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewOfSegment.roundCornersWithMask([.topLeading, .topTrailing], radius: 12)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshRequestsTableView), for: .valueChanged)
        requestsTableView.refreshControl = refreshControl
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send("previous")
        
        viewModel.output.reloadMyOrderesTable
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.requestsTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isEmptyStatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmpty in
                guard let self else { return }
                self.emptyStateView.isHidden = !isEmpty
                self.requestsTableView.isHidden = isEmpty
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
        
        currentRequestsButton.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.currentRequestsLabel.textColor = UIColor().colorWithHexString(hexString: "FFBE18")
            self.currentRequestsSelectedView.isHidden = false
            
            self.previousRequestsLabel.textColor = UIColor().colorWithHexString(hexString: "F0F0F0").withAlphaComponent(0.6)
            self.previousRequestsSelectedView.isHidden = true
            self.requestType = "current"
            self.viewModel.input.reloadWithFilter.send(.initial(text: "current"))
        }
        
        previousRequestsButton.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.previousRequestsLabel.textColor = UIColor().colorWithHexString(hexString: "FFBE18")
            self.previousRequestsSelectedView.isHidden = false
            
            self.currentRequestsLabel.textColor = UIColor().colorWithHexString(hexString: "F0F0F0").withAlphaComponent(0.6)
            self.currentRequestsSelectedView.isHidden = true
            self.requestType = "previous"
            self.viewModel.input.reloadWithFilter.send(.initial(text: "previous"))
        }
        
    }
    
    @objc private func refreshRequestsTableView() {
        fetchDataFromAPI()
    }
    
    private func fetchDataFromAPI() {
        // Simulate API call
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            // Fetch your data here (e.g., URLSession or your networking layer)
            self.viewModel.input.reloadWithFilter.send(.initial(text: requestType))
            // Once done, update UI on main thread
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                if requestType == "previous" {
                    self.previousRequestsLabel.textColor = UIColor().colorWithHexString(hexString: "FFBE18")
                    self.previousRequestsSelectedView.isHidden = false
                    
                    self.currentRequestsLabel.textColor = UIColor().colorWithHexString(hexString: "F0F0F0").withAlphaComponent(0.6)
                    self.currentRequestsSelectedView.isHidden = true
                }else {
                    self.currentRequestsLabel.textColor = UIColor().colorWithHexString(hexString: "FFBE18")
                    self.currentRequestsSelectedView.isHidden = false
                    
                    self.previousRequestsLabel.textColor = UIColor().colorWithHexString(hexString: "F0F0F0").withAlphaComponent(0.6)
                    self.previousRequestsSelectedView.isHidden = true
                }
                
                self.refreshControl.endRefreshing()
                self.requestsTableView.reloadData()
            }
        }
    }
    
}

extension CurrentPreviousRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.getHasMoreMyOrderes() else { return }
        if indexPath.row == viewModel.numberOfMyOrderes - 3 {
            viewModel.input.reloadWithFilter.send(.nextPage)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMyOrderes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = requestsTableView.dequeueReusableCell(withIdentifier: "CurrentPreviousRequestsTableViewCell", for: indexPath) as? CurrentPreviousRequestsTableViewCell else { return UITableViewCell() }
        let item = viewModel.getMyOrderesData(at: indexPath.row)
        cell.configure(item: item)
        return cell
    }
    
}
