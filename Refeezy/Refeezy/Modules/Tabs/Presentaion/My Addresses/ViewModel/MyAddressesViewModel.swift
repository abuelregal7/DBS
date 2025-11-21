//
//  MyAddressesViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

enum MyAddressesFilter: Equatable {
    case delete
    case makeDefualt
}

protocol MyAddressesViewModelProtocol {
    // Inputs
    var input: MyAddressesViewModel.Input { get }
    
    // Outputs
    var output: MyAddressesViewModel.Output { get }
    
    var myAddressesData: [MyAddressesData] { get }
    var myAddressesDataPublisher: Published<[MyAddressesData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfMyAddresses: Int { get }
    func getMyAddressesData(at index: Int) -> MyAddressesData?
    
    func getHasMoreMyAddresses() -> Bool
}

class MyAddressesViewModel: BaseViewModel, MyAddressesViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let reloadWithFilter: PassthroughSubject<MyAddressesFilter, Never>
    }
    
    struct Output {
        let reloadMyAddressesCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var myAddressesData: [MyAddressesData] = []
    var myAddressesDataPublisher: Published<[MyAddressesData]>.Publisher{ $myAddressesData }
    
    @Published var isEmptyState: Bool = false
    var isEmptyStatePublisher: Published<Bool>.Publisher { $isEmptyState }
    
    // MARK: - Private Properties
    private var page = 1
    private var hasMoreMyAddresses = true
    private var isFetchingMoreMyAddresses = false
    
    private let reloadMyAddressesCollectionsSubject = PassthroughSubject<Void, Never>()
    var addressID: CurrentValueSubject<Int?, Never> = CurrentValueSubject<Int?,Never>(nil)
    
    // Use Case
    private var myAddressesUseCase: MyAddressesUseCase
    private var deleteAddressUseCase: DeleteAddressUseCase
    private var makeAddressDefualtUseCase: MakeAddressDefualtUseCase
    
    private var deleteAddressRequest: DeleteAddressRequest = .init()
    private var makeAddressDefualtRequest: MakeAddressDefualtRequest = .init()
    
    // MARK: - Init
    init(myAddressesUseCase: MyAddressesUseCase, deleteAddressUseCase: DeleteAddressUseCase, makeAddressDefualtUseCase: MakeAddressDefualtUseCase) {
        self.myAddressesUseCase         =  myAddressesUseCase
        self.deleteAddressUseCase       =  deleteAddressUseCase
        self.makeAddressDefualtUseCase  =  makeAddressDefualtUseCase
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            reloadMyAddressesCollections: reloadMyAddressesCollectionsSubject.eraseToAnyPublisher()
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
                self.getMyAddressesData()
            }
            .store(in: &cancellables)
        
        // Handle reload with filter
        input.reloadWithFilter
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] filter in
                guard let self = self else { return }
                self.applyFilter(filter)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Output Data
    var numberOfMyAddresses: Int {
        return myAddressesData.count
    }
    
    func getMyAddressesData(at index: Int) -> MyAddressesData? {
        guard !myAddressesData.isEmpty, index >= 0, index < myAddressesData.count else { return nil }
        return myAddressesData[index]
    }
    
    func getHasMoreMyAddresses() -> Bool {
        return hasMoreMyAddresses
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: MyAddressesFilter) {
        switch filter {
        case .delete:
            deleteAddressRequest.id = addressID.value
            deleteMyAddress(body: deleteAddressRequest)
        case .makeDefualt:
            makeAddressDefualtRequest.id = addressID.value
            makeAddressDefualt(body: makeAddressDefualtRequest)
        }
    }
    
    private
    func getMyAddressesData() {
        isFetchingMoreMyAddresses = true
        isLoading.send(true)
        myAddressesUseCase.execute()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                self.isFetchingMoreMyAddresses = false
                
                switch completion {
                case .finished:
                    print("Finished loading home data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Handle the data
                self.myAddressesData = request
                // Update empty state
                self.isEmptyState = self.myAddressesData.isEmpty
                self.reloadMyAddressesCollectionsSubject.send()
            })
            .store(in: &cancellables)
    }
    
    private
    func deleteMyAddress(body: DeleteAddressRequest) {
        isLoading.send(true)
        deleteAddressUseCase.execute(body: body)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading home data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Handle the data
                getMyAddressesData()
            })
            .store(in: &cancellables)
    }
    
    private
    func makeAddressDefualt(body: MakeAddressDefualtRequest) {
        isLoading.send(true)
        makeAddressDefualtUseCase.execute(body: body)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading home data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Handle the data
                getMyAddressesData()
            })
            .store(in: &cancellables)
    }
    
}
