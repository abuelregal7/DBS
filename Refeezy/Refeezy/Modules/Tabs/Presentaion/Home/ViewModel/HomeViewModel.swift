//
//  HomeViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/04/2025.
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
    
    var homeSliderData: [HomeSliderData] { get }
    var homeSliderDataPublisher: Published<[HomeSliderData]>.Publisher { get }
    
    var homeRoomsData: [HomeRoomsData] { get }
    var homeRoomsDataPublisher: Published<[HomeRoomsData]>.Publisher { get }
    
    var homeGiftsData: [HomeGiftsData] { get }
    var homeGiftsDataPublisher: Published<[HomeGiftsData]>.Publisher { get }
    
    var homeCompletedRoomsData: [HomeCompletedRoomsData] { get }
    var homeCompletedRoomsDataPublisher: Published<[HomeCompletedRoomsData]>.Publisher { get }
    
    // Input/Output structure
    var numberOfSliders: Int { get }
    func getSlidersData(at index: Int) -> HomeSliderData?
    
    var numberOfRooms: Int { get }
    func getRoomsData(at index: Int) -> HomeRoomsData?
    
    var numberOfGifts: Int { get }
    func getGiftsData(at index: Int) -> HomeGiftsData?
    
    var numberOfCompletedRooms: Int { get }
    func getCompletedRoomsData(at index: Int) -> HomeCompletedRoomsData?
    
}

class HomeViewModel: BaseViewModel, HomeViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let reloadHomeCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    @Published var homeSliderData: [HomeSliderData] = []
    var homeSliderDataPublisher: Published<[HomeSliderData]>.Publisher{ $homeSliderData }
    
    @Published var homeRoomsData: [HomeRoomsData] = []
    var homeRoomsDataPublisher: Published<[HomeRoomsData]>.Publisher{ $homeRoomsData }
    
    @Published var homeGiftsData: [HomeGiftsData] = []
    var homeGiftsDataPublisher: Published<[HomeGiftsData]>.Publisher{ $homeGiftsData }
    
    @Published var homeCompletedRoomsData: [HomeCompletedRoomsData] = []
    var homeCompletedRoomsDataPublisher: Published<[HomeCompletedRoomsData]>.Publisher{ $homeCompletedRoomsData }
    
    // MARK: - Private Properties
    private let reloadHomeCollectionsSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Use Case
    private var homeSliderUseCase         :  HomeSliderUseCase
    private var homeRoomsUseCase          :  HomeRoomsUseCase
    private var homeGiftsUseCase          :  HomeGiftsUseCase
    private var homeCompletedRoomsUseCase :  HomeCompletedRoomsUseCase
    
    private var homeLoadingTask: Task<Void, Never>?
    
    // MARK: - Init
    init(homeSliderUseCase: HomeSliderUseCase, homeRoomsUseCase: HomeRoomsUseCase, homeGiftsUseCase: HomeGiftsUseCase, homeCompletedRoomsUseCase: HomeCompletedRoomsUseCase) {
        self.homeSliderUseCase          =  homeSliderUseCase
        self.homeRoomsUseCase           =  homeRoomsUseCase
        self.homeGiftsUseCase           =  homeGiftsUseCase
        self.homeCompletedRoomsUseCase  =  homeCompletedRoomsUseCase
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            reloadHomeCollections: reloadHomeCollectionsSubject.eraseToAnyPublisher()
        )
        
        super.init()
        
        bindInputs()
    }
    
    deinit {
        homeLoadingTask?.cancel()
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Input Binding
    private func bindInputs() {
        // Handle viewDidLoad
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                
                // Cancel previous task if exists
                self.homeLoadingTask?.cancel()
                
                // Start new task
                self.homeLoadingTask = Task { [weak self] in
                    guard let self = self else { return }
                    
                        do {
                            // Run all requests concurrently
                            async let sliders = self.getHomeSliderData()
                            async let rooms = self.getHomeRoomsData()
                            async let gifts = self.getHomeGiftsData()
                            async let completedRooms = self.getHomeCompletedRoomsData()
                            
                            // Await all results
                            let (sliderData, roomData, giftData, completedRoomData) = try await (
                                sliders, rooms, gifts, completedRooms
                            )
                            
                            //// Update UI on main thread
                            //await MainActor.run {
                            //    self.homeSliderData = sliderData
                            //    self.homeRoomsData = roomData
                            //    self.homeGiftsData = giftData
                            //    self.homeCompletedRoomsData = completedRoomData
                            //    self.reloadHomeCollectionsSubject.send()
                            //}
                            
                        } catch {
                            print("Error fetching home data: \(error)")
                            await MainActor.run {
                                self.handleError(error)
                            }
                        }
                    
                    
                    //    do {
                    //
                    //        // 2. Run requests sequentially
                    //        let sliderData = try await self.getHomeSliderData()
                    //        let roomData = try await self.getHomeRoomsData()
                    //        let giftData = try await self.getHomeGiftsData()
                    //        let completedRoomData = try await self.getHomeCompletedRoomsData()
                    //
                    //        // 3. Update data on main thread
                    //        //await MainActor.run {
                    //        //    self.homeSliderData = sliderData
                    //        //    self.homeRoomsData = roomData
                    //        //    self.homeGiftsData = giftData
                    //        //    self.homeCompletedRoomsData = completedRoomData
                    //        //    self.reloadHomeCollectionsSubject.send()
                    //        //    self.isLoading.send(false)
                    //        //}
                    //
                    //    } catch {
                    //        // 4. Handle errors
                    //        await MainActor.run {
                    //            self.isLoading.send(false)
                    //            self.handleError(error)
                    //        }
                    //        print("Error fetching home data: \(error)")
                    //    }
                    
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Output Data
    var numberOfSliders: Int {
        return homeSliderData.count
    }
    
    func getSlidersData(at index: Int) -> HomeSliderData? {
        guard !homeSliderData.isEmpty, index >= 0, index < homeSliderData.count else { return nil }
        return homeSliderData[index]
    }
    
    var numberOfRooms: Int {
        return homeRoomsData.count
    }
    
    func getRoomsData(at index: Int) -> HomeRoomsData? {
        guard !homeRoomsData.isEmpty, index >= 0, index < homeRoomsData.count else { return nil }
        return homeRoomsData[index]
    }
    
    var numberOfGifts: Int {
        return homeGiftsData.count
    }
    
    func getGiftsData(at index: Int) -> HomeGiftsData? {
        guard !homeGiftsData.isEmpty, index >= 0, index < homeGiftsData.count else { return nil }
        return homeGiftsData[index]
    }
    
    var numberOfCompletedRooms: Int {
        return homeCompletedRoomsData.count
    }
    
    func getCompletedRoomsData(at index: Int) -> HomeCompletedRoomsData? {
        guard !homeCompletedRoomsData.isEmpty, index >= 0, index < homeCompletedRoomsData.count else { return nil }
        return homeCompletedRoomsData[index]
    }
    
    private func fetchData<T>(
        useCase: AnyPublisher<T, NetworkError>,
        loadingState: Bool = true,
        onSuccess: ((T) -> Void)? = nil
    ) async throws -> T {
        if loadingState {
            isLoading.send(true)
        }
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            let cancellable = useCase
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }
                        if loadingState {
                            self.isLoading.send(false)
                        }
                        
                        switch completion {
                        case .failure(let error):
                            self.handleError(error)
                            continuation.resume(throwing: error)
                        case .finished:
                            break
                        }
                    },
                    receiveValue: { value in
                        onSuccess?(value)
                        continuation.resume(returning: value)
                    }
                )
            
            // Store the cancellable safely
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.cancellables.insert(cancellable)
            }
        }
    }
    
    private
    func getHomeSliderData() async throws -> [HomeSliderData] {
        try await fetchData(
            useCase: homeSliderUseCase.execute(),
            onSuccess: { [weak self] data in
                guard let self = self else { return }
                self.homeSliderData = data
                self.reloadHomeCollectionsSubject.send()
            }
        )
    }

    private
    func getHomeRoomsData() async throws -> [HomeRoomsData] {
        try await fetchData(
            useCase: homeRoomsUseCase.execute(),
            onSuccess: { [weak self] data in
                guard let self = self else { return }
                self.homeRoomsData = data
                self.reloadHomeCollectionsSubject.send()
            }
        )
    }

    private
    func getHomeGiftsData() async throws -> [HomeGiftsData] {
        try await fetchData(
            useCase: homeGiftsUseCase.execute(),
            onSuccess: { [weak self] data in
                guard let self = self else { return }
                self.homeGiftsData = data
                self.reloadHomeCollectionsSubject.send()
            }
        )
    }

    private
    func getHomeCompletedRoomsData() async throws -> [HomeCompletedRoomsData] {
        try await fetchData(
            useCase: homeCompletedRoomsUseCase.execute(),
            onSuccess: { [weak self] data in
                guard let self = self else { return }
                self.homeCompletedRoomsData = data
                self.reloadHomeCollectionsSubject.send()
            }
        )
    }
    
//    private
//    func getHomeSliderData() async throws -> [HomeSliderData] {
//        // Start loading state
//        isLoading.send(true)
//        
//        // Use a continuation to wrap the Combine publisher
//        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HomeSliderData], Error>) in
//            homeSliderUseCase.execute()
//                .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
//                .sink(receiveCompletion: { [weak self] completion in
//                    // Ensure self is still alive to prevent memory leaks
//                    guard let self = self else { return }
//                    
//                    // Stop loading state regardless of success or failure
//                    self.isLoading.send(false)
//                    
//                    switch completion {
//                    case .finished:
//                        print("HomeRooms finished successfully")
//                    case .failure(let error):
//                        // Handle the error and resume with throwing the error
//                        self.handleError(error) // Call your error handling logic
//                        continuation.resume(throwing: error) // Resume with the error
//                    }
//                }, receiveValue: { [weak self] data in
//                    // Ensure self is still alive
//                    guard let self = self else { return }
//                    
//                    // Navigate to verification code screen upon successful login
//                    self.homeSliderData = data
//                    self.reloadHomeCollectionsSubject.send()
//                    continuation.resume(returning: data) // Resume with loginData
//                })
//                .store(in: &cancellables) // Keep the subscription alive
//        }
//    }
//    
//    private
//    func getHomeRoomsData() async throws -> [HomeRoomsData] {
//        // Start loading state
//        isLoading.send(true)
//        
//        // Use a continuation to wrap the Combine publisher
//        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HomeRoomsData], Error>) in
//            homeRoomsUseCase.execute()
//                .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
//                .sink(receiveCompletion: { [weak self] completion in
//                    // Ensure self is still alive to prevent memory leaks
//                    guard let self = self else { return }
//                    
//                    // Stop loading state regardless of success or failure
//                    self.isLoading.send(false)
//                    
//                    switch completion {
//                    case .finished:
//                        print("HomeRooms finished successfully")
//                    case .failure(let error):
//                        // Handle the error and resume with throwing the error
//                        self.handleError(error) // Call your error handling logic
//                        continuation.resume(throwing: error) // Resume with the error
//                    }
//                }, receiveValue: { [weak self] data in
//                    // Ensure self is still alive
//                    guard let self = self else { return }
//                    
//                    // Navigate to verification code screen upon successful login
//                    self.homeRoomsData = data
//                    self.reloadHomeCollectionsSubject.send()
//                    continuation.resume(returning: data) // Resume with loginData
//                })
//                .store(in: &cancellables) // Keep the subscription alive
//        }
//    }
//    
//    private
//    func getHomeGiftsData() async throws -> [HomeGiftsData] {
//        // Start loading state
//        isLoading.send(true)
//        
//        // Use a continuation to wrap the Combine publisher
//        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HomeGiftsData], Error>) in
//            homeGiftsUseCase.execute()
//                .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
//                .sink(receiveCompletion: { [weak self] completion in
//                    // Ensure self is still alive to prevent memory leaks
//                    guard let self = self else { return }
//                    
//                    // Stop loading state regardless of success or failure
//                    self.isLoading.send(false)
//                    
//                    switch completion {
//                    case .finished:
//                        print("HomeRooms finished successfully")
//                    case .failure(let error):
//                        // Handle the error and resume with throwing the error
//                        self.handleError(error) // Call your error handling logic
//                        continuation.resume(throwing: error) // Resume with the error
//                    }
//                }, receiveValue: { [weak self] data in
//                    // Ensure self is still alive
//                    guard let self = self else { return }
//                    
//                    // Navigate to verification code screen upon successful login
//                    self.homeGiftsData = data
//                    self.reloadHomeCollectionsSubject.send()
//                    continuation.resume(returning: data) // Resume with loginData
//                })
//                .store(in: &cancellables) // Keep the subscription alive
//        }
//    }
//    
//    private
//    func getHomeCompletedRoomsData() async throws -> [HomeCompletedRoomsData] {
//        // Start loading state
//        isLoading.send(true)
//        
//        // Use a continuation to wrap the Combine publisher
//        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HomeCompletedRoomsData], Error>) in
//            homeCompletedRoomsUseCase.execute()
//                .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
//                .sink(receiveCompletion: { [weak self] completion in
//                    // Ensure self is still alive to prevent memory leaks
//                    guard let self = self else { return }
//                    
//                    // Stop loading state regardless of success or failure
//                    self.isLoading.send(false)
//                    
//                    switch completion {
//                    case .finished:
//                        print("HomeRooms finished successfully")
//                    case .failure(let error):
//                        // Handle the error and resume with throwing the error
//                        self.handleError(error) // Call your error handling logic
//                        continuation.resume(throwing: error) // Resume with the error
//                    }
//                }, receiveValue: { [weak self] data in
//                    // Ensure self is still alive
//                    guard let self = self else { return }
//                    
//                    // Navigate to verification code screen upon successful login
//                    self.homeCompletedRoomsData = data
//                    self.reloadHomeCollectionsSubject.send()
//                    continuation.resume(returning: data) // Resume with loginData
//                })
//                .store(in: &cancellables) // Keep the subscription alive
//        }
//    }
    
}
