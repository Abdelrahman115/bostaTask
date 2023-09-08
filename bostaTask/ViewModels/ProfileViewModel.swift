//
//  ProfileViewModel.swift
//  bostaTask
//
//  Created by Abdelrahman on 06/09/2023.
//

import Foundation
import Combine



// MARK: - ViewModel using combine
class UserDataViewModel: ObservableObject {
    @Published var userData: UserDataResponse?
    weak var delegate: ViewModelsDelegate?

    private var cancellables: Set<AnyCancellable> = []

    init() {
        fetchUserData()
    }

    func fetchUserData() {
        NetworkManager.shared.fetchUserData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self.delegate?.Failure(error: error)
                }
            }, receiveValue: { [weak self] user in
                self?.userData = user
            })
            .store(in: &cancellables)
    }
}




// MARK: - View Model to URLSession network manager
/*
 class UserDataViewModel{
     weak var delegate: ViewModelsDelegate?
     
     var bindUserData:(() -> ()) = {}
     
     var userData:UserDataResponse?{
         didSet{
             bindUserData()
         }
     }
     

     
     func fetchUserData(){
         NetworkManager.shared.fetchUserData { [weak self] result in
             guard let self = self else {return}
             switch result{
             case.success(let model):
                 self.userData = model
             case .failure(let error):
                 print(error.localizedDescription)
                 DispatchQueue.main.async {
                     self.delegate?.Failure(error: error)
                 }
             }
         }
     }
     
 }
 */
