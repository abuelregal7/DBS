//
//  DealsViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 22/08/2024.
//

import UIKit

class DealsViewController: BaseViewControllerWithVM<MyDealsViewModel> {
    
    @IBOutlet weak var currentDealsLabel: UILabel!
    @IBOutlet weak var currentDealsSelectedView: UIView!
    @IBOutlet weak var currentDealsButton: UIButton!
    
    @IBOutlet weak var previousDealsLabel: UILabel!
    @IBOutlet weak var previousSelectedView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var dealsTableView: UITableView!{
        didSet {
            dealsTableView.separatorStyle = .none
            
            dealsTableView.delegate = self
            dealsTableView.dataSource = self
            
            dealsTableView.register(UINib(nibName: "DealsTableViewCell", bundle: nil), forCellReuseIdentifier: "DealsTableViewCell")
        }
    }
    
    private var dealTypeIsCurrent: Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send("current")
        
        viewModel.output.reloadMyDealsTable
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.dealsTableView.reloadData()
            }
            .store(in: &cancellables)
        
        currentDealsButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.currentDealsLabel.textColor = UIColor().colorWithHexString(hexString: "EFEDFD")
                self.currentDealsSelectedView.backgroundColor = UIColor().colorWithHexString(hexString: "1A56DB")
                
                self.previousDealsLabel.textColor = UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.6)
                self.previousSelectedView.backgroundColor = UIColor.clear
                self.dealTypeIsCurrent = true
                self.viewModel.input.reloadWithFilter.send(.initial(text: "current"))
            }
            .store(in: &cancellables)
        
        previousButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.currentDealsLabel.textColor = UIColor().colorWithHexString(hexString: "EFEDFD").withAlphaComponent(0.6)
                self.currentDealsSelectedView.backgroundColor = UIColor.clear
                
                self.previousDealsLabel.textColor = UIColor().colorWithHexString(hexString: "EFEDFD")
                self.previousSelectedView.backgroundColor = UIColor().colorWithHexString(hexString: "1A56DB")
                self.dealTypeIsCurrent = false
                self.viewModel.input.reloadWithFilter.send(.initial(text: "previous"))
            }
            .store(in: &cancellables)
        
    }
    
}

extension DealsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.getHasMoreDeals() else { return }
        if indexPath.row == viewModel.numberOfmyDeals - 5 {
            viewModel.input.reloadWithFilter.send(.nextPage)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfmyDeals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dealsTableView.dequeueReusableCell(withIdentifier: "DealsTableViewCell", for: indexPath) as? DealsTableViewCell else { return UITableViewCell() }
        let item = viewModel.getmyDealsData(at: indexPath.row)
        cell.configure(item: item, dealTypeIsCurrent: dealTypeIsCurrent)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.getmyDealsData(at: indexPath.row)
        navigationController?.pushViewController(TabbarFactory.dealDetails(dealId: item?.id).viewController, animated: true)
    }
    
}

