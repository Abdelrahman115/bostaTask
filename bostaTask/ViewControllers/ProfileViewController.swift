//
//  ProfileViewController.swift
//  bostaTask
//
//  Created by Abdelrahman on 06/09/2023.
//

import UIKit
import Foundation
import Combine

class ProfileViewController: UIViewController {
    
    

    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - View Properties
    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var emailValue: UILabel!
    @IBOutlet weak var phoneValue: UILabel!
    @IBOutlet weak var websiteValue: UILabel!
    @IBOutlet weak var streetValue: UILabel!
    @IBOutlet weak var suiteValue: UILabel!
    @IBOutlet weak var cityValue: UILabel!
    @IBOutlet weak var zipValue: UILabel!
    
    var viewModel:UserDataViewModel!
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .secondarySystemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfileData()
        viewModel.delegate = self
    }
    
    
    // MARK: - API Call (Combine)
    private func fetchProfileData() {
        viewModel = UserDataViewModel()

        viewModel.$userData
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] userData in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.nameValue.text = userData.name
                    self.emailValue.text = userData.email
                    self.phoneValue.text = userData.phone
                    self.websiteValue.text = userData.website
                    self.streetValue.text = userData.address.street
                    self.suiteValue.text = userData.address.suite
                    self.cityValue.text = userData.address.city
                    self.zipValue.text = userData.address.zipcode
                }
            }
            .store(in: &cancellables)

        viewModel.fetchUserData()
    }
    
    // MARK: - API Call (URLSession)
    /*private func fetchProfileData(){
        viewModel = UserDataViewModel()
        viewModel.fetchUserData()
        viewModel.bindUserData = {[weak self] in
            guard let self = self else {return}
            guard let userData = self.viewModel.userData else {return}
            DispatchQueue.main.async {
                self.nameValue.text = userData.name
                self.emailValue.text = userData.email
                self.phoneValue.text = userData.phone
                self.websiteValue.text = userData.website
                self.streetValue.text = userData.address.street
                self.suiteValue.text = userData.address.suite
                self.cityValue.text = userData.address.city
                self.zipValue.text = userData.address.zipcode
            }
        }
    }*/
}




// MARK: - ViewModels Delegate Extensions to handle connection errors
extension ProfileViewController:ViewModelsDelegate{
    func Failure(error: Error) {
        let message = error.localizedDescription
        AlertManager.shared.alertConnectionError(message: message, viewController: self)
    }
}
