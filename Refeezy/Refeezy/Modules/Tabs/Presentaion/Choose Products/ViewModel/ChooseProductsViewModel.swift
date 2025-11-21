//
//  ChooseProductsViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation
import Combine

enum ChooseProductsFilter: Equatable {
    case refresh
    case nextPage
}

protocol ChooseProductsViewModelProtocol {
    // Inputs
    var input: ChooseProductsViewModel.Input { get }
    
    // Outputs
    var output: ChooseProductsViewModel.Output { get }
    
    var productsData: [RoomItemsDataData] { get }
    var productsDataPublisher: Published<[RoomItemsDataData]>.Publisher { get }
    // Input/Output structure
    var numberOfProducts: Int { get }
    func getProductsData(at index: Int) -> RoomItemsDataData?
    
    func getHasMoreProducts() -> Bool
}

class ChooseProductsViewModel: BaseViewModel, ChooseProductsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let reloadWithFilter: PassthroughSubject<ChooseProductsFilter, Never>
    }
    
    struct Output {
        let reloadProductsCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var productsData: [RoomItemsDataData] = []
    var productsDataPublisher: Published<[RoomItemsDataData]>.Publisher{ $productsData }
    
    @Published var isEmptyState: Bool = false
    var isEmptyStatePublisher: Published<Bool>.Publisher { $isEmptyState }
    
    // MARK: - Private Properties
    private var page = 1
    private var hasMoreProducts = true
    private var isFetchingMoreProducts = false
    private var roomID: Int?
    private var selectedFilterProducts: [Int] = []
    private var selectedProducts: [RoomItemsDataData]? = []
    private var price: Double?
    
    private let reloadProductsCollectionsSubject = PassthroughSubject<Void, Never>()
    let totalPriceSubject = CurrentValueSubject<Double?, Never>(0.0)
    let selectedProductsCountSubject = CurrentValueSubject<Int?, Never>(0)
    
    // Use Case
    private var roomItemsUseCase: RoomItemsUseCase
    private var roomItemsRequest: RoomItemsRequest = .init()
    
    // MARK: - Init
    init(roomItemsUseCase: RoomItemsUseCase, roomID: Int?, price: Double?) {
        self.roomItemsUseCase = roomItemsUseCase
        self.roomID = roomID
        self.price = price
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            reloadProductsCollections: reloadProductsCollectionsSubject.eraseToAnyPublisher()
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
                self.roomItemsRequest.id = getRoomID()
                self.getProductsData(body: self.roomItemsRequest)
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
    
    func getRoomID() -> Int? {
        return roomID
    }
    
    func getPrice() -> Double? {
        return price
    }
    
    func getProducts() -> [RoomItemsDataData]? {
        return selectedProducts
    }
    
    // MARK: - Output Data
    var numberOfProducts: Int {
        return productsData.count
    }
    
    func getProductsData(at index: Int) -> RoomItemsDataData? {
        guard !productsData.isEmpty, index >= 0, index < productsData.count else { return nil }
        return productsData[index]
    }
    
    func getHasMoreProducts() -> Bool {
        return hasMoreProducts
    }
    
    func toggleProductsSelected(at index: Int) {
        if productsData[index].isSelected == nil || productsData[index].isSelected == false {
            productsData[index].isSelected = true
        }else {
            productsData[index].isSelected = false
        }
        getFilterProductsSelected()
        getProductsSelected()
    }
    
    func getFilterProductsSelected() {
        // Remove array
        selectedFilterProducts.removeAll()
        totalPriceSubject.value = nil
        selectedProductsCountSubject.value = nil
        // Use filter to get only the selected children
        let selectedProductsData = productsData.filter { $0.isSelected == true }
        // Now you have an array of selected PereferencesChild instances
        for selectedProducts in selectedProductsData {
            if let selectedValue = selectedProducts.id {
                // Use the selected value here
                print("Selected value: \(selectedValue)")
                selectedFilterProducts.append(selectedValue)
            }
        }
        totalPriceSubject.value = Double(selectedFilterProducts.count) * (price ?? 0.0)
        selectedProductsCountSubject.value = selectedFilterProducts.count
        print("selectedFilteProducts => \(selectedFilterProducts)")
        print("totalPriceSubjectValue => \(totalPriceSubject.value ?? 0.0)")
        print("selectedProductsCountSubjectValue => \(selectedProductsCountSubject.value ?? 0)")
    }
    
    func getProductsSelected() {
        // Clear previous selections
        selectedProducts?.removeAll()
        
        // Filter and append selected products
        let selectedProductsData = productsData.filter { $0.isSelected == true }
        
        for product in selectedProductsData {
            selectedProducts?.append(product)
            print("Selected product: \(product)")
        }
        
        print("Total selected products: \(selectedProducts?.count ?? 0)")
    }
    
    func getSelectedProductsTotalPrice() -> Double {
        let totalPrice = productsData
            .filter { $0.isSelected == true }
            .compactMap { $0.price }
            .reduce(0, +)
        return totalPrice
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: ChooseProductsFilter) {
        switch filter {
        case .refresh:
            productsData.removeAll()
            page = 1
            roomItemsRequest.page = page
            roomItemsRequest.id = getRoomID()
            getProductsData(body: roomItemsRequest)
        case .nextPage:
            guard !isFetchingMoreProducts, hasMoreProducts else { return }
            page += 1
            roomItemsRequest.page = page
            roomItemsRequest.id = getRoomID()
            getProductsData(body: roomItemsRequest)
        }
    }
    
    private
    func getProductsData(body: RoomItemsRequest) {
        isFetchingMoreProducts = true
        isLoading.send(true)
        roomItemsUseCase.execute(body: body)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                self.isFetchingMoreProducts = false
                
                switch completion {
                case .finished:
                    print("Finished loading home data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Handle the data
                self.productsData.append(contentsOf: request.data ?? [])
                
                // Update empty state
                self.isEmptyState = self.productsData.isEmpty
                
                // Update pagination state
                if request.meta?.lastPage == self.page {
                    self.hasMoreProducts = false
                } else {
                    self.hasMoreProducts = true
                }
                
                self.reloadProductsCollectionsSubject.send()
            })
            .store(in: &cancellables)
    }
    
}
