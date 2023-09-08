//
//  PhotosViewModel.swift
//  bostaTask
//
//  Created by Abdelrahman on 06/09/2023.
//

import Foundation
import Combine


// MARK: - ViewModel using combine
class PhotosViewModel: ObservableObject {
    @Published var albumPhotos: [AlbumPhotosResponse]?
    weak var delegate: ViewModelsDelegate?

    private var cancellables: Set<AnyCancellable> = []

    init(albumID: String) {
        fetchAlbumPhotos(albumID: albumID)
    }

    func fetchAlbumPhotos(albumID: String) {
        NetworkManager.shared.fetchAlbumPhotos(albumID: albumID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self.delegate?.Failure(error: error)
                }
            }, receiveValue: { [weak self] photos in
                self?.albumPhotos = photos
            })
            .store(in: &cancellables)
    }
}



// MARK: - View Model to URLSession network manager

/*
 class PhotosViewModel{
     weak var delegate: ViewModelsDelegate?
     
     var bindalbumPhotos:(() -> ()) = {}
     
     var albumPhotos:[AlbumPhotosResponse]?{
         didSet{
             bindalbumPhotos()
         }
     }
     

     
     func fetchUserAlbums(albumID:String){
         NetworkManager.shared.fetchAlbumPhotos(albumID: albumID) { [weak self] result in
             guard let self = self else {return}
             switch result{
             case.success(let model):
                 self.albumPhotos = model
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
