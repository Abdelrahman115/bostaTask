//
//  UserPhotosResponse.swift
//  bostaTask
//
//  Created by Abdelrahman on 06/09/2023.
//

import Foundation

struct albumPhotosResponse: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
