//
//  UpcomingPaymentsViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 22/08/2024.
//

import UIKit
import SafariServices

class UpcomingPaymentsViewController: BaseViewControllerWithVM<UpcomingPaymentsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var upcomingPaymentsTableView: UITableView!{
        didSet {
            upcomingPaymentsTableView.separatorStyle = .none
            
            upcomingPaymentsTableView.delegate = self
            upcomingPaymentsTableView.dataSource = self
            
            upcomingPaymentsTableView.register(UINib(nibName: "UpcomingPaymentsTableViewCell", bundle: nil), forCellReuseIdentifier: "UpcomingPaymentsTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.output.reloadUpcomingPaymentsTable
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.upcomingPaymentsTableView.reloadData()
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

extension UpcomingPaymentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.getHasMorePayments() else { return }
        if indexPath.row == viewModel.numberOfUpcomingPayments - 5 {
            viewModel.input.reloadWithFilter.send(.nextPage)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUpcomingPayments
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upcomingPaymentsTableView.dequeueReusableCell(withIdentifier: "UpcomingPaymentsTableViewCell", for: indexPath) as? UpcomingPaymentsTableViewCell else { return UITableViewCell() }
        let item = viewModel.getUpcomingPaymentsData(at: indexPath.row)
        cell.configure(item: item)
        cell.DownloadAction = { [weak self] in
            guard let self = self else { return }
            //self.openPDF(link: item?.attachment ?? "")
            self.openPDFInSafari(urlString: item?.attachment ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
