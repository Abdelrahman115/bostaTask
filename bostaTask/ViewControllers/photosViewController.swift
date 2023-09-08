//
//  photosViewController.swift
//  bostaTask
//
//  Created by Abdelrahman on 06/09/2023.
//

import UIKit
import Foundation
import Combine

class photosViewController: UIViewController{
    // MARK: - View Properties
    private var cancellables: Set<AnyCancellable> = []
    
    private let searchBar:UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.backgroundColor = .secondarySystemBackground
        searchBar.placeholder = "Search in images"
        return searchBar
    }()
    private let placeHolderlLabel:UILabel = {
       let label = UILabel()
        label.text = "No Images Found"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var collectionView:UICollectionView?
    private var id:String = ""
    
    var viewModel:PhotosViewModel!
    var photos:[AlbumPhotosResponse] = []
    var filteredPhotos:[AlbumPhotosResponse] = []
    
    // MARK: - Initializer
    init(albumID:String){
        self.id = albumID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        createSearchBar()
        setupCollectionView()
        fetchPhotos()
        viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 0, y: navigationController?.navigationBar.bottom ?? 0, width: view.width, height: 50)
        collectionView?.frame = CGRect(x: 0, y: searchBar.bottom, width: view.width, height: view.bounds.height - view.safeAreaInsets.bottom - searchBar.height - view.safeAreaInsets.top)
        placeHolderlLabel.frame = CGRect(x: 0, y: view.height / 2, width: view.width, height: 50)
    }
    
    // MARK: - Setup Collection View
    private func setupCollectionView(){
        view.backgroundColor = .systemBackground
        let layout = UICollectionViewFlowLayout()
        let size = (view.width - 4)/3
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        layout.itemSize = CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        //delegate dataSource
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {return}
        view.addSubview(collectionView)
        view.addSubview(placeHolderlLabel)
    }
    
    // MARK: - Create SearchBar
    private func createSearchBar(){
        view.addSubview(searchBar)
        searchBar.delegate = self
    }
    
    
    // MARK: - Fetch Photos Using Combine
    private func fetchPhotos() {
        viewModel = PhotosViewModel(albumID: id)

        viewModel.$albumPhotos
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] albumPhotos in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.photos = albumPhotos
                    self.filteredPhotos = albumPhotos
                    self.collectionView?.reloadData()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchAlbumPhotos(albumID: id)
    }
    
    // MARK: - Fetch Photos Using URLSession
    
    /*private func fetchAPIData(){
        viewModel = PhotosViewModel()
        viewModel.fetchUserAlbums(albumID: id)
        viewModel.bindalbumPhotos = {[weak self] in
            guard let self = self else {return}
            guard let albumPhotos = self.viewModel.albumPhotos else {return}
            DispatchQueue.main.async {
                self.photos = albumPhotos
                self.filteredPhotos = albumPhotos
                self.collectionView?.reloadData()
            }
        }
    }*/
}

// MARK: - Collection View Extension
extension photosViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = filteredPhotos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = filteredPhotos[indexPath.row]
        let vc = ImageViewerViewController(imageURL: photo.url)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - SearchBar Extension
extension photosViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredPhotos.removeAll()
            filteredPhotos = photos
            collectionView?.isHidden = false
            placeHolderlLabel.isHidden = true
            self.collectionView?.reloadData()
        } else {
            filteredPhotos.removeAll()
            filteredPhotos = photos.filter{
                $0.title.lowercased().contains(searchText.lowercased()) }
            
            if filteredPhotos.isEmpty{
                collectionView?.isHidden = true
                placeHolderlLabel.isHidden = false
            }else{
                collectionView?.isHidden = false
                placeHolderlLabel.isHidden = true
            }
            collectionView?.reloadData()
            
        }
    }
}


// MARK: - ViewModels delegate extension
extension photosViewController:ViewModelsDelegate{
    func Failure(error: Error) {
        let message = error.localizedDescription
        AlertManager.shared.alertConnectionError(message: message, viewController: self)
    }
}
