//
//  MyDealsViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 03/10/2024.
//

import Foundation
import Combine

enum MyDealsFilter: Equatable {
    case refresh
    case initial(text: String)
    case nextPage
}

protocol MyDealsViewModelProtocol {
    // Inputs
    var input: MyDealsViewModel.Input { get }
    
    // Outputs
    var output: MyDealsViewModel.Output { get }
    
    var myDealsData: [MyDealData] { get }
    var myDealsDataPublisher: Published<[MyDealData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfmyDeals: Int { get }
    func getmyDealsData(at index: Int) -> MyDealData?
    
    func getHasMoreDeals() -> Bool
}

class MyDealsViewModel: BaseViewModel, MyDealsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<String, Never>
        let reloadWithFilter: PassthroughSubject<MyDealsFilter, Never>
    }
    
    struct Output {
        let reloadMyDealsTable: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var myDealsData: [MyDealData] = []
    var myDealsDataPublisher: Published<[MyDealData]>.Publisher{ $myDealsData }
    
    // MARK: - Private Properties
    private var myDealsRequest: MyDealsRequest = .init()
    private var myDealsUseCase: MyDealsUseCase
    
    private var page: Int = 1
    private var isLoadingMore: Bool = true
    
    // Subjects to handle input/output
    private let reloadMyDealsTableSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(myDealsUseCase: MyDealsUseCase) {
        self.myDealsUseCase = myDealsUseCase
        
        // Initialize inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize outputs
        output = Output(
            reloadMyDealsTable: reloadMyDealsTableSubject.eraseToAnyPublisher()
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
                self.myDealsRequest.type = type
                self.getMyDealsData(body: self.myDealsRequest)
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
    var numberOfmyDeals: Int {
        return myDealsData.count
    }
    
    func getmyDealsData(at index: Int) -> MyDealData? {
        guard !myDealsData.isEmpty, index >= 0, index < myDealsData.count else { return nil }
        return myDealsData[index]
    }
    
    func getHasisLoadingMore() -> Bool {
        return isLoadingMore
    }
    
    func getHasMoreDeals() -> Bool {
        return isLoadingMore
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: MyDealsFilter) {
        switch filter {
        case .refresh:
            myDealsData.removeAll()
            page = 1
            myDealsRequest.page = page
            getMyDealsData(body: myDealsRequest)
        case .initial(let text):
            myDealsData.removeAll()
            page = 1
            myDealsRequest.page = page
            myDealsRequest.type = text
            getMyDealsData(body: myDealsRequest)
        case .nextPage:
            guard !isLoadingMore else { return }
            page += 1
            myDealsRequest.page = page
            getMyDealsData(body: myDealsRequest)
        }
    }
    
    private 
    func getMyDealsData(body: MyDealsRequest) {
        isLoading.send(true)
        
        myDealsUseCase.execute(body: body) // Assuming `myDealsUseCase.execute` returns `AnyPublisher<MyDealsResponse, NetworkError>`
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
                self.myDealsData.append(contentsOf: request.data ?? [])
                
                // Handle pagination logic
                if request.meta?.lastPage == self.page {
                    self.isLoadingMore = false
                } else {
                    self.isLoadingMore = true
                }
                
                // Notify to reload the table
                self.reloadMyDealsTableSubject.send()
            })
            .store(in: &cancellables)
    }

}
