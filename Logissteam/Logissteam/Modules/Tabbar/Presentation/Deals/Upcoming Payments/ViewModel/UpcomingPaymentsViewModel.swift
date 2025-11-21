//
//  UpcomingPaymentsViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 04/10/2024.
//

import Foundation
import Combine

enum UpcomingPaymentsFilter: Equatable {
    case refresh
    case nextPage
}

protocol UpcomingPaymentsViewModelProtocol {
    // Inputs
    var input: UpcomingPaymentsViewModel.Input { get }
    
    // Outputs
    var output: UpcomingPaymentsViewModel.Output { get }
    
    var upcomingPaymentsData: [DealsPaymentData] { get }
    var upcomingPaymentsDataPublisher: Published<[DealsPaymentData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfUpcomingPayments: Int { get }
    func getUpcomingPaymentsData(at index: Int) -> DealsPaymentData?
    
    func getHasMorePayments() -> Bool
}

class UpcomingPaymentsViewModel: BaseViewModel, UpcomingPaymentsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let reloadWithFilter: PassthroughSubject<UpcomingPaymentsFilter, Never>
    }
    
    struct Output {
        let reloadUpcomingPaymentsTable: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var upcomingPaymentsData: [DealsPaymentData] = []
    var upcomingPaymentsDataPublisher: Published<[DealsPaymentData]>.Publisher{ $upcomingPaymentsData }
    
    // MARK: - Private Properties
    private var upcomingPaymentsRequest: DealsPaymentsRequest = .init()
    private var upcomingPaymentsUseCase: DealsPaymentsUseCase
    
    private var dealId: Int?
    private var page: Int = 1
    private var isLoadingMore: Bool = true
    
    // Subjects to handle input/output
    private let reloadUpcomingPaymentsTableSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(upcomingPaymentsUseCase: DealsPaymentsUseCase, dealId: Int?) {
        self.upcomingPaymentsUseCase = upcomingPaymentsUseCase
        self.dealId = dealId
        
        // Initialize inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize outputs
        output = Output(
            reloadUpcomingPaymentsTable: reloadUpcomingPaymentsTableSubject.eraseToAnyPublisher()
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
                self.upcomingPaymentsRequest.user_deal_id = dealId
                self.getUpcomingPaymentsData(body: self.upcomingPaymentsRequest)
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
    var numberOfUpcomingPayments: Int {
        return upcomingPaymentsData.count
    }
    
    func getUpcomingPaymentsData(at index: Int) -> DealsPaymentData? {
        guard !upcomingPaymentsData.isEmpty, index >= 0, index < upcomingPaymentsData.count else { return nil }
        return upcomingPaymentsData[index]
    }
    
    func getHasMorePayments() -> Bool {
        return isLoadingMore
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: UpcomingPaymentsFilter) {
        switch filter {
        case .refresh:
            upcomingPaymentsData.removeAll()
            page = 1
            upcomingPaymentsRequest.page = page
            upcomingPaymentsRequest.user_deal_id = dealId
            getUpcomingPaymentsData(body: upcomingPaymentsRequest)
        case .nextPage:
            guard !isLoadingMore else { return }
            page += 1
            upcomingPaymentsRequest.page = page
            upcomingPaymentsRequest.user_deal_id = dealId
            getUpcomingPaymentsData(body: upcomingPaymentsRequest)
        }
    }
    
    private 
    func getUpcomingPaymentsData(body: DealsPaymentsRequest) {
        isLoading.send(true)
        
        upcomingPaymentsUseCase.execute(body: body) // Assuming `upcomingPaymentsUseCase.execute` returns `AnyPublisher<DealsPaymentsResponse, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading upcoming payments")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Append to the existing upcomingPaymentsData
                self.upcomingPaymentsData.append(contentsOf: request.data ?? [])
                
                // Handle pagination logic
                if request.meta?.lastPage == self.page {
                    self.isLoadingMore = false
                } else {
                    self.isLoadingMore = true
                }
                
                // Notify to reload the table
                self.reloadUpcomingPaymentsTableSubject.send()
            })
            .store(in: &cancellables)
    }

}
