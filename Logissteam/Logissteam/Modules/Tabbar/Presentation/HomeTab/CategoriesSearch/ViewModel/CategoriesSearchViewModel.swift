//
//  CategoriesSearchViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 08/09/2024.
//

import Foundation
import Combine

enum SearchFilter: Equatable {
    case refresh
    case search(text: String)
    case nextPage
}

protocol CategoriesSearchViewModelProtocol {
    // Inputs
    var input: CategoriesSearchViewModel.Input { get }
    
    // Outputs
    var output: CategoriesSearchViewModel.Output { get }
    
    var searchDealsData: [CategoryData] { get }
    var searchDealsDataPublisher: Published<[CategoryData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfDeals: Int { get }
    func getDealsData(at index: Int) -> CategoryData?
}

class CategoriesSearchViewModel: BaseViewModel, CategoriesSearchViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let reloadWithFilter: PassthroughSubject<SearchFilter, Never>
    }
    
    struct Output {
        let reloadSearchCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var searchDealsData: [CategoryData] = []
    var searchDealsDataPublisher: Published<[CategoryData]>.Publisher{ $searchDealsData }
    
    // MARK: - Private Properties
    private var searchDealsRequest: CategorySearchRequest = .init()
    private var categorySearchUseCase: CategorySearchUseCase
    
    private var page: Int = 1
    private var isLoadingMore: Bool = true
    
    // Subjects to handle input/output
    private let reloadSearchCollectionsSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(categorySearchUseCase: CategorySearchUseCase) {
        self.categorySearchUseCase = categorySearchUseCase
        
        // Initialize inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize outputs
        output = Output(
            reloadSearchCollections: reloadSearchCollectionsSubject.eraseToAnyPublisher()
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
                self.getSearchData(body: searchDealsRequest)
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
    var numberOfDeals: Int {
        return searchDealsData.count
    }
    
    func getDealsData(at index: Int) -> CategoryData? {
        guard !searchDealsData.isEmpty, index >= 0, index < searchDealsData.count else { return nil }
        return searchDealsData[index]
    }
    
    func getHasisLoadingMore() -> Bool {
        return isLoadingMore
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: SearchFilter) {
        switch filter {
        case .refresh:
            searchDealsData.removeAll()
            page = 1
            searchDealsRequest.search = ""
            searchDealsRequest.page = page
            getSearchData(body: searchDealsRequest)
        case .search(let text):
            searchDealsData.removeAll()
            page = 1
            searchDealsRequest.search = text
            searchDealsRequest.page = page
            getSearchData(body: searchDealsRequest)
        case .nextPage:
            guard !isLoadingMore else { return }
            page += 1
            searchDealsRequest.page = page
            getSearchData(body: searchDealsRequest)
        }
    }
    
    private 
    func getSearchData(body: CategorySearchRequest) {
        isLoading.send(true)
        
        categorySearchUseCase.execute(body: body) // Assuming `categorySearchUseCase.execute` returns `AnyPublisher<CategorySearchResponse, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading search data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Update search data
                self.searchDealsData.append(contentsOf: request.data ?? [])
                
                // Update pagination state
                if request.meta?.lastPage == self.page {
                    self.isLoadingMore = false
                } else {
                    self.isLoadingMore = true
                }
                
                self.reloadSearchCollectionsSubject.send()
            })
            .store(in: &cancellables)
    }
}
