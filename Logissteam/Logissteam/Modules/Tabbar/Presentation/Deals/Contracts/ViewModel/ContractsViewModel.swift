//
//  ContractsViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 04/10/2024.
//

import Foundation
import Combine

enum ContractsViewModelFilter: Equatable {
    case refresh
    case nextPage
}

protocol ContractsViewModelProtocol {
    // Inputs
    var input: ContractsViewModel.Input { get }
    
    // Outputs
    var output: ContractsViewModel.Output { get }
    
    var contractsData: [DealsContractData] { get }
    var contractsDataPublisher: Published<[DealsContractData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfContracts: Int { get }
    func getContractsData(at index: Int) -> DealsContractData?
    
    func getHasMoreContracts() -> Bool
}

class ContractsViewModel: BaseViewModel, ContractsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let reloadWithFilter: PassthroughSubject<ContractsViewModelFilter, Never>
    }
    
    struct Output {
        let reloadContractsTable: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var contractsData: [DealsContractData] = []
    var contractsDataPublisher: Published<[DealsContractData]>.Publisher{ $contractsData }
    
    // MARK: - Private Properties
    private var contractsRequest: DealsContractsRequest = .init()
    private var contractsUseCase: DealsContractsUseCase
    
    private var dealId: Int?
    private var page: Int = 1
    private var isLoadingMore: Bool = true
    
    // Subjects to handle input/output
    private let reloadContractsTableSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(contractsUseCase: DealsContractsUseCase, dealId: Int?) {
        self.contractsUseCase = contractsUseCase
        self.dealId = dealId
        
        // Initialize inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize outputs
        output = Output(
            reloadContractsTable: reloadContractsTableSubject.eraseToAnyPublisher()
        )
        
        super.init()
        
        bindInputs()
    }
    
    // MARK: - Input Binding
    private func bindInputs() {
        // Handle viewDidLoad
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                self.contractsRequest.user_deal_id = dealId
                self.getContractsData(body: self.contractsRequest)
            }
            .store(in: &cancellables)
        
        // Handle filter reloads
        input.reloadWithFilter
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] filter in
                guard let self = self else { return }
                self.applyFilter(filter)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Output Data
    var numberOfContracts: Int {
        return contractsData.count
    }
    
    func getContractsData(at index: Int) -> DealsContractData? {
        guard !contractsData.isEmpty, index >= 0, index < contractsData.count else { return nil }
        return contractsData[index]
    }
    
    func getHasMoreContracts() -> Bool {
        return isLoadingMore
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: ContractsViewModelFilter) {
        switch filter {
        case .refresh:
            contractsData.removeAll()
            page = 1
            contractsRequest.page = page
            contractsRequest.user_deal_id = dealId
            getContractsData(body: contractsRequest)
        case .nextPage:
            guard !isLoadingMore else { return }
            page += 1
            contractsRequest.page = page
            contractsRequest.user_deal_id = dealId
            getContractsData(body: contractsRequest)
        }
    }
    
    private 
    func getContractsData(body: DealsContractsRequest) {
        isLoading.send(true)
        
        contractsUseCase.execute(body: body) // Assuming `contractsUseCase.execute` returns `AnyPublisher<DealsContractsResponse, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading contracts")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Append to the existing contractsData
                self.contractsData.append(contentsOf: request.data ?? [])
                
                // Handle pagination logic
                if request.meta?.lastPage == self.page {
                    self.isLoadingMore = false
                } else {
                    self.isLoadingMore = true
                }
                
                // Notify to reload the table
                self.reloadContractsTableSubject.send()
            })
            .store(in: &cancellables)
    }

}
