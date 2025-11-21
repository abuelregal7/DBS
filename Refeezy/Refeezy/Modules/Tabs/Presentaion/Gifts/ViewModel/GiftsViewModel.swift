//
//  GiftsViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/04/2025.
//

import Foundation
import Combine

enum GiftsFilter: Equatable {
    case refresh
    case nextPage
}

protocol GiftsViewModelProtocol {
    // Inputs
    var input: GiftsViewModel.Input { get }
    
    // Outputs
    var output: GiftsViewModel.Output { get }
    
    var giftsData: [HomeGiftsData] { get }
    var giftsDataPublisher: Published<[HomeGiftsData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfGifts: Int { get }
    func getGiftsData(at index: Int) -> HomeGiftsData?
    
    func getHasMoreGifts() -> Bool
}

class GiftsViewModel: BaseViewModel, GiftsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let reloadWithFilter: PassthroughSubject<GiftsFilter, Never>
    }
    
    struct Output {
        let reloadGiftsCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var giftsData: [HomeGiftsData] = []
    var giftsDataPublisher: Published<[HomeGiftsData]>.Publisher{ $giftsData }
    
    @Published var isEmptyState: Bool = false
    var isEmptyStatePublisher: Published<Bool>.Publisher { $isEmptyState }
    
    // MARK: - Private Properties
    private var page = 1
    private var hasMoreGifts = true
    private var isFetchingMoreGifts = false
    
    private let reloadGiftsCollectionsSubject = PassthroughSubject<Void, Never>()
    
    // Use Case
    private var giftsUseCase: HomeGiftsUseCase
    private var giftsRequest: AllRoomesRequest = .init()
    
    // MARK: - Init
    init(giftsUseCase: HomeGiftsUseCase) {
        self.giftsUseCase = giftsUseCase
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            reloadGiftsCollections: reloadGiftsCollectionsSubject.eraseToAnyPublisher()
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
                self.getGiftsData(body: self.giftsRequest)
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
    var numberOfGifts: Int {
        return giftsData.count
    }
    
    func getGiftsData(at index: Int) -> HomeGiftsData? {
        guard !giftsData.isEmpty, index >= 0, index < giftsData.count else { return nil }
        return giftsData[index]
    }
    
    func getHasMoreGifts() -> Bool {
        return hasMoreGifts
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: GiftsFilter) {
        switch filter {
        case .refresh:
            giftsData.removeAll()
            page = 1
            giftsRequest.page = page
            getGiftsData(body: giftsRequest)
        case .nextPage:
            guard !isFetchingMoreGifts, hasMoreGifts else { return }
            page += 1
            giftsRequest.page = page
            getGiftsData(body: giftsRequest)
        }
    }
    
    private
    func getGiftsData(body: AllRoomesRequest) {
        isFetchingMoreGifts = true
        isLoading.send(true)
        giftsUseCase.execute()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                self.isFetchingMoreGifts = false
                
                switch completion {
                case .finished:
                    print("Finished loading home data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Handle the data
                self.giftsData = request
                
                // Update empty state
                self.isEmptyState = self.giftsData.isEmpty
                //self.giftsData.append(contentsOf: request.data ?? [])
                //
                //// Update pagination state
                //if request.meta?.lastPage == self.page {
                //    self.hasMoreGifts = false
                //} else {
                //    self.hasMoreGifts = true
                //}
                
                self.reloadGiftsCollectionsSubject.send()
            })
            .store(in: &cancellables)
    }
    
}
