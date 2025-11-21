//
//  RoomDetailsViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation
import Combine

protocol RoomDetailsViewModelProtocol {
    // Inputs
    var input: RoomDetailsViewModel.Input { get }
    
    // Outputs
    var output: RoomDetailsViewModel.Output { get }
    
    func viewDidLoad()
    
    var roomDetailsData: RoomDetailsData? { get }
    var roomDetailsDataPublisher: Published<RoomDetailsData?>.Publisher { get }
    
    var roomImagesData: [String]? { get }
    var roomImagesDataPublisher: Published<[String]?>.Publisher { get }
    
    var numberOfRoomesImages: Int { get }
    func getRoomesImagesData(at index: Int) -> String?
    
}

class RoomDetailsViewModel: BaseViewModel, RoomDetailsViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let reloadRoomesCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var roomDetailsData : RoomDetailsData?
    var roomDetailsDataPublisher   : Published<RoomDetailsData?>.Publisher{ $roomDetailsData }
    
    @Published var roomImagesData : [String]?
    var roomImagesDataPublisher   : Published<[String]?>.Publisher{ $roomImagesData }
    
    private let reloadRoomesCollectionsSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Private
    private var roomeDetailsUseCase: RoomeDetailsUseCase
    private var roomDetailsRequest: RoomDetailsRequest = .init()
    
    private var roomID: Int?
    private var price: Double?
    
    init(roomeDetailsUseCase: RoomeDetailsUseCase, roomID: Int?) {
        self.roomeDetailsUseCase = roomeDetailsUseCase
        self.roomID = roomID
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject()
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
                self.roomDetailsRequest.id = getRoomID()
                self.getRoomDetailsProfile(body: roomDetailsRequest)
            }
            .store(in: &cancellables)
    }
    
    var numberOfRoomesImages: Int {
        return roomImagesData?.count ?? 0
    }
    func getRoomesImagesData(at index: Int) -> String? {
        guard !(roomImagesData?.isEmpty ?? false), index >= 0, index < roomImagesData?.count ?? 0 else { return nil }
        return roomImagesData?[index]
    }
    
    func getRoomID() -> Int? {
        return roomID
    }
    
    func getPrice() -> Double? {
        return price
    }
    
    func viewDidLoad() {
        roomDetailsRequest.id = getRoomID()
        getRoomDetailsProfile(body: roomDetailsRequest)
    }
    
    // MARK: - Private Methods
    private
    func getRoomDetailsProfile(body: RoomDetailsRequest) {
        isLoading.send(true)
        
        roomeDetailsUseCase.execute(body: body)
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
                self.roomDetailsData = request
                self.roomImagesData = request.product?.images
                self.price = request.price
                self.reloadRoomesCollectionsSubject.send()
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }
    
}
