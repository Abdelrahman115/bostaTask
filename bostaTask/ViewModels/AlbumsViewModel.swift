import Foundation
import Combine


// MARK: - ViewModel using combine
class AlbumsViewModel: ObservableObject {
    @Published var userAlbums: [UserAlbumsResponse]?
    weak var delegate: ViewModelsDelegate?

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchUserAlbums()
    }
    
    func fetchUserAlbums() {
        NetworkManager.shared.fetchUserAlbums()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self.delegate?.Failure(error: error)
                }
            }, receiveValue: { [weak self] albums in
                self?.userAlbums = albums
            })
            .store(in: &cancellables)
    }
}


// MARK: - View Model to URLSession network manager

/*
 class AlbumsViewModel{
     weak var delegate: ViewModelsDelegate?
     var bindUserAlbums:(() -> ()) = {}
     
     var userAlbums:[UserAlbumsResponse]?{
         didSet{
             bindUserAlbums()
         }
     }
     

     
     func fetchUserAlbums(){
         NetworkManager.shared.fetchUserAlbums { [weak self] result in
             guard let self = self else {return}
             switch result{
             case.success(let model):
                 self.userAlbums = model
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
