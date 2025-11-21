//
//  CurrentPreviousRequestsViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation
import Combine

enum CurrentPreviousRequestsFilter: Equatable {
    case refresh
    case initial(text: String)
    case nextPage
}

protocol CurrentPreviousRequestsViewModelProtocol {
    // Inputs
    var input: CurrentPreviousRequestsViewModel.Input { get }
    
    // Outputs
    var output: CurrentPreviousRequestsViewModel.Output { get }
    
    var myOrderesData: [MyOrderesDataData] { get }
    var myOrderesDataPublisher: Published<[MyOrderesDataData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfMyOrderes: Int { get }
    func getMyOrderesData(at index: Int) -> MyOrderesDataData?
    
    func getHasMoreMyOrderes() -> Bool
}

class CurrentPreviousRequestsViewModel: BaseViewModel, CurrentPreviousRequestsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<String, Never>
        let reloadWithFilter: PassthroughSubject<CurrentPreviousRequestsFilter, Never>
    }
    
    struct Output {
        let reloadMyOrderesTable: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var myOrderesData: [MyOrderesDataData] = []
    var myOrderesDataPublisher: Published<[MyOrderesDataData]>.Publisher{ $myOrderesData }
    
    @Published var isEmptyState: Bool = false
    var isEmptyStatePublisher: Published<Bool>.Publisher { $isEmptyState }
    
    // MARK: - Private Properties
    private var myOrderesRequest: MyOrderesRequest = .init()
    private var myOrderesUseCase: MyOrderesUseCase
    
    private var page: Int = 1
    private var isLoadingMore: Bool = true
    
    // Subjects to handle input/output
    private let reloadMyOrderesTableSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(myOrderesUseCase: MyOrderesUseCase) {
        self.myOrderesUseCase = myOrderesUseCase
        
        // Initialize inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize outputs
        output = Output(
            reloadMyOrderesTable: reloadMyOrderesTableSubject.eraseToAnyPublisher()
        )
        
        super.init()
        
        bindInputs()
    }
    
    // MARK: - Input Binding
    private func bindInputs() {
        // Handle viewDidLoad
        input.viewDidLoad
            .sink { [weak self] type in
                guard let self = self else { return }
                self.myOrderesRequest.type = type
                self.getMyOrderesData(body: self.myOrderesRequest)
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
    var numberOfMyOrderes: Int {
        return myOrderesData.count
    }
    
    func getMyOrderesData(at index: Int) -> MyOrderesDataData? {
        guard !myOrderesData.isEmpty, index >= 0, index < myOrderesData.count else { return nil }
        return myOrderesData[index]
    }
    
    func getHasisLoadingMore() -> Bool {
        return isLoadingMore
    }
    
    func getHasMoreMyOrderes() -> Bool {
        return isLoadingMore
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: CurrentPreviousRequestsFilter) {
        switch filter {
        case .refresh:
            myOrderesData.removeAll()
            page = 1
            myOrderesRequest.page = page
            getMyOrderesData(body: myOrderesRequest)
        case .initial(let text):
            myOrderesData.removeAll()
            page = 1
            myOrderesRequest.page = page
            myOrderesRequest.type = text
            getMyOrderesData(body: myOrderesRequest)
        case .nextPage:
            guard !isLoadingMore else { return }
            page += 1
            myOrderesRequest.page = page
            getMyOrderesData(body: myOrderesRequest)
        }
    }
    
    private
    func getMyOrderesData(body: MyOrderesRequest) {
        isLoading.send(true)
        
        myOrderesUseCase.execute(body: body) // Assuming `myDealsUseCase.execute` returns `AnyPublisher<MyDealsResponse, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading my deals")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Append to the existing myDealsData
                self.myOrderesData.append(contentsOf: request.data ?? [])
                
                // Update empty state
                self.isEmptyState = self.myOrderesData.isEmpty
                
                // Handle pagination logic
                if request.meta?.lastPage == self.page {
                    self.isLoadingMore = false
                } else {
                    self.isLoadingMore = true
                }
                
                // Notify to reload the table
                self.reloadMyOrderesTableSubject.send()
            })
            .store(in: &cancellables)
    }

}
