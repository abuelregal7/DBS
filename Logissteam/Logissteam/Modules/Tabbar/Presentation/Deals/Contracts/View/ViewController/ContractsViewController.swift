//
//  ContractsViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 22/08/2024.
//

import UIKit
import SafariServices

class ContractsViewController: BaseViewControllerWithVM<ContractsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var contractsTableView: UITableView!{
        didSet {
            contractsTableView.separatorStyle = .none
            
            contractsTableView.delegate = self
            contractsTableView.dataSource = self
            
            contractsTableView.register(UINib(nibName: "ContractsTableViewCell", bundle: nil), forCellReuseIdentifier: "ContractsTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadContractsTable
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.contractsTableView.reloadData()
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

extension ContractsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.getHasMoreContracts() else { return }
        if indexPath.row == viewModel.numberOfContracts - 5 {
            viewModel.input.reloadWithFilter.send(.nextPage)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfContracts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contractsTableView.dequeueReusableCell(withIdentifier: "ContractsTableViewCell", for: indexPath) as? ContractsTableViewCell else { return UITableViewCell() }
        let item = viewModel.getContractsData(at: indexPath.row)
        cell.configure(item: item)
        cell.ContractsAction = { [weak self] in
            guard let self = self else { return }
            //self.openPDF(link: item?.attachment ?? "")
            self.openPDFInSafari(urlString: item?.attachment ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
