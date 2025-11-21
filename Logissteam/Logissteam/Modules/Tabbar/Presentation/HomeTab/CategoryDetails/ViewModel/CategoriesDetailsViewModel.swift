//
//  CategoriesDetailsViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation
import Combine

enum CategoriesDetailsFilter: Equatable {
    case refresh
}

protocol CategoriesDetailsViewModelProtocol {
    // Inputs
    var input: CategoriesDetailsViewModel.Input { get }
    
    // Outputs
    var output: CategoriesDetailsViewModel.Output { get }
    
    var dealDetailsData: DealDetailsData? { get }
    var dealDetailsDataPublisher: Published<DealDetailsData?>.Publisher { get }
    
    // Input/Output structure
    var numberOfDealImages: Int { get }
    func getDealsData(at index: Int) -> String?
    
    func getDealId() -> Int?
    
}

class CategoriesDetailsViewModel: BaseViewModel, CategoriesDetailsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let didTapOnBuyORBookDealButton: PassthroughSubject<String, Never>
        let reloadWithFilter: PassthroughSubject<CategoriesDetailsFilter, Never>
    }
    
    struct Output {
        let reloadImagesCollections: AnyPublisher<Void, Never>
        let navigateToSucess: AnyPublisher<Void, Never>
        
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var dealDetailsData: DealDetailsData?
    var dealDetailsDataPublisher: Published<DealDetailsData?>.Publisher{ $dealDetailsData }
    
    // MARK: - Private Properties
    private var dealDetailsRequest: DealDetailsRequest = .init()
    private var dealDetailsUseCase: DealDetailsUseCase
    
    private var dealReservationRequest: DealsReservationRequest = .init()
    private var dealReservationUseCase: DealsReservationUseCase
    
    private var dealId: Int?
    private var page: Int = 1
    private var isLoadingMore: Bool = true
    private var planId: Int?
    private var planTitle: String?
    private var checkBoxSelect: String = ""
    
    // Subjects to handle input/output
    private let reloadImagesCollectionsSubject = PassthroughSubject<Void, Never>()
    private let navigateToSucessSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(dealDetailsUseCase: DealDetailsUseCase, dealReservationUseCase: DealsReservationUseCase, dealId: Int?, planId: Int?, planTitle: String?, checkBoxSelect: String) {
        self.dealDetailsUseCase = dealDetailsUseCase
        self.dealReservationUseCase = dealReservationUseCase
        self.dealId = dealId
        self.planId = planId
        self.planTitle = planTitle
        self.checkBoxSelect = checkBoxSelect
        
        // Initialize inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            didTapOnBuyORBookDealButton: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize outputs
        output = Output(
            reloadImagesCollections: reloadImagesCollectionsSubject.eraseToAnyPublisher(),
            navigateToSucess: navigateToSucessSubject.eraseToAnyPublisher()
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
                self.dealDetailsRequest.id = dealId
                self.getDealDetailsData(body: self.dealDetailsRequest)
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
        
        // Handle login button tap
        input.didTapOnBuyORBookDealButton
            .sink { [weak self] type in
                guard let self  = self else { return }
                self.dealReservationRequest.type = type
                self.dealReservationRequest.payment_method = "cash"
                self.dealReservationRequest.deal_id = getDealId()
                self.dealReservationRequest.buy_plan_id = getPlanId()
                self.handleBuyORBookDealButtonTapped()
            }
            .store(in: &cancellables)
        
    }
    
    func getPlanId() -> Int? {
        return planId
    }
    func getPlanTitle() -> String? {
        return planTitle
    }
    func getCheckBoxSelect() -> String {
        return checkBoxSelect
    }
    
    // MARK: - Output Data
    var numberOfDealImages: Int {
        return dealDetailsData?.image?.count ?? 0
    }
    
    func getDealsData(at index: Int) -> String? {
        guard !(dealDetailsData?.image?.isEmpty ?? false), index >= 0, index < dealDetailsData?.image?.count ?? 0 else { return nil }
        return dealDetailsData?.image?[index]
    }
    
    func getDealId() -> Int? {
        return dealId
    }
    
    // MARK: - Private Methods
    
    private func handleBuyORBookDealButtonTapped() {
        
        postDealReservationData(body: dealReservationRequest)
    }
    
    private func applyFilter(_ filter: CategoriesDetailsFilter) {
        switch filter {
        case .refresh:
            getDealDetailsData(body: dealDetailsRequest)
        }
    }
    
    private 
    func getDealDetailsData(body: DealDetailsRequest) {
        isLoading.send(true)
        
        dealDetailsUseCase.execute(body: body) // Assuming `dealDetailsUseCase.execute` returns `AnyPublisher<DealDetailsResponse, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading deal details")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Update deal details data
                self.dealDetailsData = request
                
                // Notify to reload collections
                self.reloadImagesCollectionsSubject.send()
            })
            .store(in: &cancellables)
    }
    
    private 
    func postDealReservationData(body: DealsReservationRequest) {
        isLoading.send(true)
        
        dealReservationUseCase.execute(request: body) // Assuming `dealReservationUseCase.execute` returns `AnyPublisher<DealReservationResponse, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished posting deal reservation")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                // Navigate to success after reservation
                self.navigateToSucessSubject.send()
            })
            .store(in: &cancellables)
    }
}
