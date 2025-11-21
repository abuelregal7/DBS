//
//  MyAccountViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

protocol MyAccountViewModelProtocol {
    // Inputs
    func viewDidLoad()
    func didTapOnUpdateButton(image: Data?)
    
    var textPhoneSubject: CurrentValueSubject<String, Never> { get }
    var textNameSubject: CurrentValueSubject<String, Never> { get }
    var textEmailSubject: CurrentValueSubject<String, Never> { get }
    
    var profileData: ProfileData? { get }
    var profileDataPublisher: Published<ProfileData?>.Publisher { get }
    
    // Outputs
    var updateData: PassthroughSubject<String, Never> { get }
}

class MyAccountViewModel: BaseViewModel, MyAccountViewModelProtocol {
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textNameSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textEmailSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    var updateData: PassthroughSubject<String, Never> = .init()
    
    @Published var profileData : ProfileData?
    var profileDataPublisher   : Published<ProfileData?>.Publisher{ $profileData }
    
    // MARK: - Private
    private var profileUseCase: ProfileUseCase
    private var updateProfileUseCase: UpdateProfileUseCase
    private var updateProfileRequest: UpdateProfileRequest = .init()
    
    init(profileUseCase: ProfileUseCase, updateProfileUseCase: UpdateProfileUseCase) {
        self.profileUseCase = profileUseCase
        self.updateProfileUseCase = updateProfileUseCase
    }
    
    func viewDidLoad() {
        getProfile()
    }
    
    func didTapOnUpdateButton(image: Data? = nil) {
        updateProfileRequest.name = textNameSubject.value
        updateProfileRequest.phone = textPhoneSubject.value.replacedArabicDigitsWithEnglish
        updateProfileRequest.email = textEmailSubject.value
        updateProfileRequest.image = image
        updateProfile(body: updateProfileRequest)
    }
    
    func getIbanImage() -> String {
        return profileData?.image ?? ""
    }
    
    func getName() -> String {
        return profileData?.name ?? ""
    }
    
    func getEmail() -> String {
        return profileData?.email ?? ""
    }
    
    func getPhone() -> String {
        return profileData?.phone ?? ""
    }
    
    // MARK: - Private Methods
    private
    func getProfile() {
        isLoading.send(true)
        
        profileUseCase.execute() // Assuming this returns `AnyPublisher<ProfileModel, NetworkError>`
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Profile fetch successful")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                self.textNameSubject.value = request.name ?? ""
                self.textEmailSubject.value = request.email ?? ""
                self.textPhoneSubject.value = request.phone ?? ""
                self.profileData = request
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }
    
    private
    func updateProfile(body: UpdateProfileRequest) {
        isLoading.send(true)
        
        updateProfileUseCase.execute(request: body) // Assuming this returns `AnyPublisher<UpdateProfileModel, NetworkError>`
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
                self.updateData.send(request.message ?? "")
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }
    
}
