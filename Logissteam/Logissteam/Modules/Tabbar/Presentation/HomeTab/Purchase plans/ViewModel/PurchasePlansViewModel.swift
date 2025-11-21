//
//  PurchasePlansViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 05/10/2024.
//

import Foundation
import Combine

protocol PurchasePlansProtocol {
    // Inputs
    var input: PurchasePlansViewModel.Input { get }
    
    // Outputs
    var output: PurchasePlansViewModel.Output { get }
    
    var purchasePlansData: [BuyPlansModelData] { get }
    var purchasePlansDataPublisher: Published<[BuyPlansModelData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfPurchasePlans: Int { get }
    func getPurchasePlansData(at index: Int) -> BuyPlansModelData?
    
}

class PurchasePlansViewModel: BaseViewModel, PurchasePlansProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let reloadPurchasePlansCollection: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var purchasePlansData: [BuyPlansModelData] = []
    var purchasePlansDataPublisher: Published<[BuyPlansModelData]>.Publisher{ $purchasePlansData }
    
    // MARK: - Private Properties
    private var purchasePlansRequest: BuyPlansRequest = .init()
    private var purchasePlansUseCase: BuyPlansUseCase
    
    private var dealId: Int?
    private var page: Int = 1
    private var isLoadingMore: Bool = true
    
    // Subjects to handle input/output
    private let reloadPurchasePlansCollectionSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(purchasePlansUseCase: BuyPlansUseCase, dealId: Int?) {
        self.purchasePlansUseCase = purchasePlansUseCase
        self.dealId = dealId
        
        // Initialize inputs
        input = Input(
            viewDidLoad: PassthroughSubject()
        )
        
        // Initialize outputs
        output = Output(
            reloadPurchasePlansCollection: reloadPurchasePlansCollectionSubject.eraseToAnyPublisher()
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
                self.purchasePlansRequest.id = dealId
                self.getPurchasePlansData(body: self.purchasePlansRequest)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Output Data
    var numberOfPurchasePlans: Int {
        return purchasePlansData.count
    }
    
    func getPurchasePlansData(at index: Int) -> BuyPlansModelData? {
        guard !purchasePlansData.isEmpty, index >= 0, index < purchasePlansData.count else { return nil }
        return purchasePlansData[index]
    }
    
    // MARK: - Private Methods
    
    private 
    func getPurchasePlansData(body: BuyPlansRequest) {
        isLoading.send(true)
        
        purchasePlansUseCase.execute(body: body) // Assuming `purchasePlansUseCase.execute` returns `AnyPublisher<PurchasePlansResponse, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading purchase plans")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Update the purchase plans data
                self.purchasePlansData = request
                
                // Notify to reload purchase plans collection
                self.reloadPurchasePlansCollectionSubject.send()
            })
            .store(in: &cancellables)
    }

}
