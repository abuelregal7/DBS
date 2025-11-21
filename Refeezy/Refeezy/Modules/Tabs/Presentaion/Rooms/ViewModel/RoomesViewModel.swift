//
//  RoomesViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/04/2025.
//

import Foundation
import Combine

enum RoomesFilter: Equatable {
    case refresh
    case nextPage
    case search(text: String)
}

protocol RoomesViewModelProtocol {
    // Inputs
    var input: RoomesViewModel.Input { get }
    
    // Outputs
    var output: RoomesViewModel.Output { get }
    
    var roomesData: [AllRoomes] { get }
    var roomesDataPublisher: Published<[AllRoomes]>.Publisher { get }
    // Input/Output structure
    var numberOfRoomes: Int { get }
    func getRoomesData(at index: Int) -> AllRoomes?
    
    func getHasMoreRoomes() -> Bool
}

class RoomesViewModel: BaseViewModel, RoomesViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let reloadWithFilter: PassthroughSubject<RoomesFilter, Never>
    }
    
    struct Output {
        let reloadRoomesCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var roomesData: [AllRoomes] = []
    var roomesDataPublisher: Published<[AllRoomes]>.Publisher{ $roomesData }
    
    @Published var isEmptyState: Bool = false
    var isEmptyStatePublisher: Published<Bool>.Publisher { $isEmptyState }
    
    // MARK: - Private Properties
    private var page = 1
    private var hasMoreRoomes = true
    private var isFetchingMoreRoomes = false
    
    private let reloadRoomesCollectionsSubject = PassthroughSubject<Void, Never>()
    
    // Use Case
    private var roomesUseCase: AllRoomesUseCase
    private var roomesRequest: AllRoomesRequest = .init()
    
    // MARK: - Init
    init(roomesUseCase: AllRoomesUseCase) {
        self.roomesUseCase = roomesUseCase
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject(),
            reloadWithFilter: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            reloadRoomesCollections: reloadRoomesCollectionsSubject.eraseToAnyPublisher()
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
                self.getRoomesData(body: self.roomesRequest)
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
    var numberOfRoomes: Int {
        return roomesData.count
    }
    
    func getRoomesData(at index: Int) -> AllRoomes? {
        guard !roomesData.isEmpty, index >= 0, index < roomesData.count else { return nil }
        return roomesData[index]
    }
    
    func getHasMoreRoomes() -> Bool {
        return hasMoreRoomes
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(_ filter: RoomesFilter) {
        switch filter {
        case .refresh:
            roomesData.removeAll()
            page = 1
            roomesRequest.page = page
            getRoomesData(body: roomesRequest)
        case .nextPage:
            guard !isFetchingMoreRoomes, hasMoreRoomes else { return }
            page += 1
            roomesRequest.page = page
            getRoomesData(body: roomesRequest)
        case .search(let text):
            roomesData.removeAll()
            page = 1
            roomesRequest.search = text
            roomesRequest.page = page
            getRoomesData(body: roomesRequest)
        }
    }
    
    private
    func getRoomesData(body: AllRoomesRequest) {
        isFetchingMoreRoomes = true
        isLoading.send(true)
        roomesUseCase.execute(body: body)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                self.isFetchingMoreRoomes = false
                
                switch completion {
                case .finished:
                    print("Finished loading home data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
//                // Handle the data
//                self.roomesData.append(contentsOf: request.data ?? [])
//                
//                self.isEmptyState = self.roomesData.isEmpty
//
//                // Update pagination state
//                if request.meta?.lastPage == self.page {
//                    self.hasMoreRoomes = false
//                } else {
//                    self.hasMoreRoomes = true
//                }
                
                self.roomesData.append(contentsOf: request.data ?? [])
                
                // Update empty state
                self.isEmptyState = self.roomesData.isEmpty
                
                // Update pagination state
                self.hasMoreRoomes = request.meta?.lastPage != self.page
                
                self.reloadRoomesCollectionsSubject.send()
            })
            .store(in: &cancellables)
    }
    
}
