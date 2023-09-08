//
//  ViewController.swift
//  bostaTask
//
//  Created by Abdelrahman on 06/09/2023.
//

import UIKit
import Foundation
import Combine

class AlbumsViewController: UIViewController {
    
    // MARK: - View Properties
    private var cancellables: Set<AnyCancellable> = []
    var viewModel:AlbumsViewModel!
    var albums:[UserAlbumsResponse] = []
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Albums"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAlbumsData()
        viewModel.delegate = self
    }

    // MARK: - Setup tableView
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - API Call (Combine)
    private func fetchAlbumsData() {
        viewModel = AlbumsViewModel()

        viewModel.$userAlbums
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] albums in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.albums = albums
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchUserAlbums()
    }
    
    // MARK: - API Call (URLsession)
    /*private func fetchAlbumsData(){
        viewModel = AlbumsViewModel()
        viewModel.fetchUserAlbums()
        viewModel.bindUserAlbums = {[weak self] in
            guard let self = self else {return}
            guard let albums = self.viewModel.userAlbums else {return}
            DispatchQueue.main.async {
                self.albums = albums
                self.tableView.reloadData()
            }
        }
    }*/
}



// MARK: - TableView Extension
extension AlbumsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let album = albums[indexPath.row]
        cell.textLabel?.text = album.title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let albumID = String(albums[indexPath.row].id)
        let vc = photosViewController(albumID: albumID)
        vc.hidesBottomBarWhenPushed = true
        vc.title = albums[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - ViewModels Delegate Extensions to handle connection errors
extension AlbumsViewController:ViewModelsDelegate{
   
    func Failure(error: Error) {
        let message = error.localizedDescription
        AlertManager.shared.alertConnectionError(message: message, viewController: self)
    }
}
