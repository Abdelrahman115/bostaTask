//
//  NetworkManager.swift
//  bostaTask
//
//  Created by Abdelrahman on 06/09/2023.
//

import Foundation
import Combine



// MARK: - Network manager using combine

final class NetworkManager {
    static let shared = NetworkManager()
    
    let baseURL = "https://jsonplaceholder.typicode.com"
    let userParameter = "/users"
    let albumsParameter = "/albums"
    let photosParameter = "/photos"
    let userID = "/4"
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    // Fetch profile data
    func fetchUserData() -> AnyPublisher<UserDataResponse, Error> {
        let stringURL = baseURL + userParameter + userID
        let url = URL(string: stringURL)!
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: UserDataResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // Fetch Albums
    func fetchUserAlbums() -> AnyPublisher<[UserAlbumsResponse], Error> {
        let stringURL = baseURL + userParameter + userID + albumsParameter
        let url = URL(string: stringURL)!
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [UserAlbumsResponse].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    // Fetch Photos
    func fetchAlbumPhotos(albumID: String) -> AnyPublisher<[AlbumPhotosResponse], Error> {
        let stringURL = baseURL + albumsParameter + "/\(albumID)" + photosParameter
        let url = URL(string: stringURL)!
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [AlbumPhotosResponse].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}





// MARK: - Network manager using URLSESSION
/*
 final class NetworkManager{
     static let shared = NetworkManager()
     
     let baseURL = "https://jsonplaceholder.typicode.com"
     let userParameter = "/users"
     let albumsParameter = "/albums"
     let photosParameter = "/photos"
     let userID = "/4"
     
     public func fetchUserData(completion:@escaping(Result<UserDataResponse, Error>) -> Void){
         let stringURL = baseURL + userParameter + userID
         let url = URL(string: stringURL)
         let request = URLRequest(url: url!)
         
         let task = URLSession.shared.dataTask(with: request) { data, _, error in
             guard let data = data else {
                 print(error!.localizedDescription)
                 completion(.failure(error!))
                 return
             }
             
             do{
                 let result = try JSONDecoder().decode(UserDataResponse.self, from: data)
                 completion(.success(result))
             }catch{
                 print(error.localizedDescription)
                 completion(.failure(error))
             }
             
         }
         task.resume()
     }
     
     public func fetchUserAlbums(completion:@escaping(Result<[UserAlbumsResponse], Error>) -> Void){
         let stringURL = baseURL + userParameter + userID + albumsParameter
         let url = URL(string: stringURL)
         let request = URLRequest(url: url!)
         
         let task = URLSession.shared.dataTask(with: request) { data, _, error in
             guard let data = data else {
                 print(error!.localizedDescription)
                 completion(.failure(error!))
                 return
             }
             
             do{
                 let result = try JSONDecoder().decode([UserAlbumsResponse].self, from: data)
                 completion(.success(result))
             }catch{
                 print(error.localizedDescription)
                 completion(.failure(error))
             }
             
         }
         task.resume()
     }
     
     
     public func fetchAlbumPhotos(albumID:String,completion:@escaping(Result<[albumPhotosResponse], Error>) -> Void){
         let stringURL = baseURL + albumsParameter + "/\(albumID)" + photosParameter
         let url = URL(string: stringURL)
         let request = URLRequest(url: url!)
         
         let task = URLSession.shared.dataTask(with: request) { data, _, error in
             guard let data = data else {
                 print(error!.localizedDescription)
                 completion(.failure(error!))
                 return
             }
             
             do{
                 let result = try JSONDecoder().decode([albumPhotosResponse].self, from: data)
                 completion(.success(result))
             }catch{
                 print(error.localizedDescription)
                 completion(.failure(error))
             }
             
         }
         task.resume()
     }
     
     
 }
 */
