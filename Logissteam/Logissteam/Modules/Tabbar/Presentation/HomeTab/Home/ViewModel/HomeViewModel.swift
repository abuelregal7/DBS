//
//  HomeViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

enum HomeFilter: Equatable {
    case refresh
    case nextPage
}

protocol HomeViewModelProtocol {
    // Inputs
    var input: HomeViewModel.Input { get }
    
    // Outputs
    var output: HomeViewModel.Output { get }
    
    var homeDealsData: [HomeDealsData] { get }
    var homeDealsDataPublisher: Published<[HomeDealsData]>.Publisher { get }
    
    var homeSliderData: [HomeSlider] { get }
    var homeSliderDataPublisher: Published<[HomeSlider]>.Publisher { get }
    
    // Input/Output structure
    var numberOfDeals: Int { get }
    func getDealsData(at index: Int) -> HomeDealsData?
    
    var numberOfSlider: Int { get }
    func getSliderData(at index: Int) -> HomeSlider?
    
    func getHasMoreDeals() -> Bool
}

class HomeViewModel: BaseViewModel, HomeViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let reloadWithFilter: PassthroughSubject<HomeFilter, Never>
    }
    
    struct Output {
        let reloadHomeCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var homeDealsData: [HomeDealsData] = []
    var homeDealsDataPublisher: Published<[HomeDealsData]>.Publisher{ $homeDealsData }
    
    @Published var homeSliderData: [HomeSlider] = []
    var homeSliderDataPublisher: Published<[HomeSlider]>.Publisher{ $homeSliderData }
    
    // MARK: - Private Properties
    private var page = 1
    private var hasMoreDeals = true
    private var isFetchingMoreDeals = false
    
    private let reloadHomeCollectionsSubject = PassthroughSubject<Void, Never>()
    
    // Use Case
    private var homeUseCase: HomeUseCase
    private var homeDealsRequest: HomeDealsRequest = .init()
    
    // MARK: - Init
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            reloadHomeCollections: reloadHomeCollectionsSubject.eraseToAnyPublisher()
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
                self.getHomeData(body: self.homeDealsRequest)
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
    var numberOfDeals: Int {
        return homeDealsData.count
    }
    
    func getDealsData(at index: Int) -> HomeDealsData? {
        guard !homeDealsData.isEmpty, index >= 0, index < homeDealsData.count else { return nil }
        return homeDealsData[index]
    }
    
    var numberOfSlider: Int {
        return homeSliderData.count
    }
    
    func getSliderData(at index: Int) -> HomeSlider? {
        guard !homeSliderData.isEmpty, index >= 0, index < homeSliderData.count else { return nil }
        return homeSliderData[index]
    }
    
    func getHasMoreDeals() -> Bool {
        return hasMoreDeals
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: HomeFilter) {
        switch filter {
        case .refresh:
            homeDealsData.removeAll()
            page = 1
            homeDealsRequest.page = page
            getHomeData(body: homeDealsRequest)
        case .nextPage:
            guard !isFetchingMoreDeals, hasMoreDeals else { return }
            page += 1
            homeDealsRequest.page = page
            getHomeData(body: homeDealsRequest)
        }
    }
    
    private 
    func getHomeData(body: HomeDealsRequest) {
        isFetchingMoreDeals = true
        isLoading.send(true)
        
        homeUseCase.execute(body: body) // Assuming `homeUseCase.execute` returns `AnyPublisher<HomeData, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                self.isFetchingMoreDeals = false
                
                switch completion {
                case .finished:
                    print("Finished loading home data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Handle the data
                self.homeSliderData = request.sliders ?? []
                self.homeDealsData.append(contentsOf: request.deals?.data ?? [])
                
                // Update pagination state
                if request.deals?.meta?.lastPage == self.page {
                    self.hasMoreDeals = false
                } else {
                    self.hasMoreDeals = true
                }
                
                self.reloadHomeCollectionsSubject.send()
            })
            .store(in: &cancellables)
    }
    
}
