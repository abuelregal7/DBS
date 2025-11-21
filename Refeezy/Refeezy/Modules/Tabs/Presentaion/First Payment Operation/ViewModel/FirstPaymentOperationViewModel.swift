//
//  FirstPaymentOperationViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 15/04/2025.
//

import Foundation
import Combine

protocol FirstPaymentOperationViewModelProtocol {
    
    // Inputs
    var input: FirstPaymentOperationViewModel.Input { get }
    
    // Outputs
    var output: FirstPaymentOperationViewModel.Output { get }
    
    var productsData: [RoomItemsDataData]? { get }
    var productsDataPublisher: Published<[RoomItemsDataData]?>.Publisher { get }
    
    var placeOrderData: PlaceOrderData? { get }
    var placeOrderDataPublisher: Published<PlaceOrderData?>.Publisher { get }
    
    var numberOfProducts: Int { get }
    func getProductsData(at index: Int) -> RoomItemsDataData?
    func removeSelectedProduct(at index: Int)
    
}

class FirstPaymentOperationViewModel: BaseViewModel, FirstPaymentOperationViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let didTapBuyNow: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let reloadProductsTable: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var productsData: [RoomItemsDataData]? = []
    var productsDataPublisher: Published<[RoomItemsDataData]?>.Publisher{ $productsData }
    
    @Published var placeOrderData: PlaceOrderData?
    var placeOrderDataPublisher: Published<PlaceOrderData?>.Publisher{ $placeOrderData }
    
    private var roomID: Int?
    private var selectedFilterProducts: [Int] = []
    
    private let reloadProductsTableSubject = PassthroughSubject<Void, Never>()
    
    var item_idsSubject: CurrentValueSubject<[Int]?, Never> = CurrentValueSubject<[Int]?,Never>(nil)
    var delivery_typeSubject: CurrentValueSubject<String?, Never> = CurrentValueSubject<String?,Never>(nil)
    var address_idSubject: CurrentValueSubject<Int?, Never> = CurrentValueSubject<Int?,Never>(nil)
    var warehouse_idSubject: CurrentValueSubject<Int?, Never> = CurrentValueSubject<Int?,Never>(nil)
    
    // Use Case
    private var placeOrderUseCase: PlaceOrderUseCase
    private var placeOrderRequest: PlaceOrderRequest = .init()
    
    init(placeOrderUseCase: PlaceOrderUseCase, productsData: [RoomItemsDataData]?, roomID: Int?) {
        self.placeOrderUseCase = placeOrderUseCase
        self.productsData = productsData
        self.roomID = roomID
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            didTapBuyNow: PassthroughSubject()
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
        input.didTapBuyNow
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] filter in
                guard let self = self else { return }
                self.getFilterProductsSelected()
                self.placeOrderRequest.room_id = self.roomID
                self.placeOrderRequest.item_ids = self.item_idsSubject.value
                self.placeOrderRequest.address_id = UD.address?.id
                self.postPlaceOrder(body: self.placeOrderRequest)
            }
            .store(in: &cancellables)
    }
    
    func getRoomID() -> Int? {
        return roomID
    }
    
    // MARK: - Output Data
    var numberOfProducts: Int {
        return productsData?.count ?? 0
    }
    
    func getProductsData(at index: Int) -> RoomItemsDataData? {
        guard !(productsData?.isEmpty ?? false), index >= 0, index < productsData?.count ?? 0 else { return nil }
        return productsData?[index]
    }
    
    func removeSelectedProduct(at index: Int) {
        guard index >= 0 && index < productsData?.count ?? 0 else {
            print("Index out of range")
            return
        }
        productsData?.remove(at: index)
        print("Removed item at index \(index). Remaining count: \(productsData?.count ?? 0)")
        reloadProductsTableSubject.send()
    }
    
    func getFilterProductsSelected() {
        // Remove array
        selectedFilterProducts.removeAll()
        item_idsSubject.value = nil
        // Use filter to get only the selected children
        let selectedProductsData = productsData?.filter { $0.isSelected == true }
        // Now you have an array of selected PereferencesChild instances
        for selectedProducts in selectedProductsData ?? [] {
            if let selectedValue = selectedProducts.id {
                // Use the selected value here
                print("Selected value: \(selectedValue)")
                selectedFilterProducts.append(selectedValue)
            }
        }
        item_idsSubject.value = selectedFilterProducts
        print("selectedFilteProducts => \(selectedFilterProducts)")
    }
    
    private
    func postPlaceOrder(body: PlaceOrderRequest) {
        isLoading.send(true)
        placeOrderUseCase.execute(body: body)
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
                self.placeOrderData = request
                
            })
            .store(in: &cancellables)
    }
    
}
