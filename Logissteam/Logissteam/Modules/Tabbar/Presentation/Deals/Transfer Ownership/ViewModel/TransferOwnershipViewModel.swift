//
//  TransferOwnershipViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 05/10/2024.
//

import Foundation
import Combine

protocol TransferOwnershipViewModelProtocol {
    var input: TransferOwnershipViewModel.Input { get }
    var output: TransferOwnershipViewModel.Output { get }
}

class TransferOwnershipViewModel: BaseViewModel, TransferOwnershipViewModelProtocol {

    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
        let didTapOnTransfereButton: PassthroughSubject<Void, Never>
        let textPhone: CurrentValueSubject<String, Never>
    }

    struct Output {
        let isPhoneValid: AnyPublisher<Bool, Never>
        let navigateToSucess: PassthroughSubject<Void, Never>
    }

    // MARK: - Input & Output
    var input: Input
    var output: Output

    // MARK: - Private
    private var dealId: Int?
    private var transfereOwnershipUseCase: TransferOwnershipUseCase
    private var transferOwnershipRequest: TransferOwnershipRequest = .init()

    init(transfereOwnershipUseCase: TransferOwnershipUseCase, dealId: Int?) {
        self.transfereOwnershipUseCase = transfereOwnershipUseCase
        self.dealId = dealId

        // Initializing Inputs
        let textPhoneSubject = CurrentValueSubject<String, Never>("")
        let viewDidLoadSubject = PassthroughSubject<Void, Never>()
        let didTapOnTransfereButtonSubject = PassthroughSubject<Void, Never>()

        self.input = Input(
            viewDidLoad: viewDidLoadSubject,
            didTapOnTransfereButton: didTapOnTransfereButtonSubject,
            textPhone: textPhoneSubject
        )

        // Setting up Outputs
        let isPhoneValidPublisher = textPhoneSubject
            .map { $0.replacedArabicDigitsWithEnglish.isValidPhone }
            .eraseToAnyPublisher()

        let navigateToSucessSubject = PassthroughSubject<Void, Never>()

        self.output = Output(
            isPhoneValid: isPhoneValidPublisher,
            navigateToSucess: navigateToSucessSubject
        )

        super.init()

        // Binding Input to Actions
        bindInputs()
    }

    // MARK: - Private Methods

    private func bindInputs() {
        // Handle login button tap
        input.didTapOnTransfereButton
            .sink { [weak self] in
                guard let self  = self else { return }
                self.handleLoginButtonTapped()
            }
            .store(in: &cancellables)
    }

    private func handleLoginButtonTapped() {
        transferOwnershipRequest.user_deal_id = dealId
        transferOwnershipRequest.phone = input.textPhone.value.replacedArabicDigitsWithEnglish
        transferOwnership(body: transferOwnershipRequest)
    }

    private 
    func transferOwnership(body: TransferOwnershipRequest) {
        isLoading.send(true)
        
        transfereOwnershipUseCase.execute(request: body) // Assuming `execute` returns `AnyPublisher<Void, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished transfer ownership")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                // Trigger navigation to success screen after the transfer
                self.output.navigateToSucess.send()
            })
            .store(in: &cancellables)
    }

}
