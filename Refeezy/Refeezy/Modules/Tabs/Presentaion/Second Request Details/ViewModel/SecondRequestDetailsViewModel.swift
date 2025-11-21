//
//  SecondRequestDetailsViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 15/04/2025.
//

import Foundation
import Combine

protocol SecondRequestDetailsViewModelProtocol {
    // Inputs
    var input: SecondRequestDetailsViewModel.Input { get }
    
    // Outputs
    var output: SecondRequestDetailsViewModel.Output { get }
    
    func viewDidLoad()
    
    var showOrdereData: ShowOrdereData? { get }
    var showOrdereDataPublisher: Published<ShowOrdereData?>.Publisher { get }
    
    var productsData: [ShowOrdereRoomItem] { get }
    var productsDataPublisher: Published<[ShowOrdereRoomItem]>.Publisher { get }
    
    var numberOfProducts: Int { get }
    func getProductData(index: Int) -> ShowOrdereRoomItem?
    
}

class SecondRequestDetailsViewModel: BaseViewModel, SecondRequestDetailsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let reloadProductsTable: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var showOrdereData : ShowOrdereData?
    var showOrdereDataPublisher   : Published<ShowOrdereData?>.Publisher{ $showOrdereData }
    
    @Published var productsData : [ShowOrdereRoomItem] = []
    var productsDataPublisher   : Published<[ShowOrdereRoomItem]>.Publisher{ $productsData }
    
    private let reloadProductsTableSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Private
    private var myOrderDetailsUseCase: MyOrderDetailsUseCase
    private var showOrdereRequest: ShowOrdereRequest = .init()
    
    private var roomID: Int?
    
    init(myOrderDetailsUseCase: MyOrderDetailsUseCase, roomID: Int?) {
        self.myOrderDetailsUseCase = myOrderDetailsUseCase
        self.roomID = roomID
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            reloadProductsTable: reloadProductsTableSubject.eraseToAnyPublisher()
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
                self.showOrdereRequest.id = getRoomID()
                self.getMyOrderDetailsProfile(body: showOrdereRequest)
            }
            .store(in: &cancellables)
    }
    
    func getRoomID() -> Int? {
        return roomID
    }
    
    var numberOfProducts: Int {
        return productsData.count
    }
    func getProductData(index: Int) -> ShowOrdereRoomItem? {
        guard !productsData.isEmpty, index >= 0, index < productsData.count else { return nil }
        return productsData[index]
    }
    
    func viewDidLoad() {
        showOrdereRequest.id = getRoomID()
        getMyOrderDetailsProfile(body: showOrdereRequest)
    }
    
    // MARK: - Private Methods
    private
    func getMyOrderDetailsProfile(body: ShowOrdereRequest) {
        isLoading.send(true)
        
        myOrderDetailsUseCase.execute(body: body)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Profile update successful")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                self.showOrdereData = request
                self.productsData = request.roomItems ?? []
                self.reloadProductsTableSubject.send()
            })
            .store(in: &cancellables)
    }
    
}
