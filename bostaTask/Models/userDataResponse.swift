//
//  userDataResponse.swift
//  bostaTask
//
//  Created by Abdelrahman on 06/09/2023.
//

import Foundation

struct UserDataResponse:Codable{
    let id:Int
    let name:String
    let username:String
    let email:String
    let address:AddressDetails
    let phone:String
    let website:String
}

struct AddressDetails:Codable{
    let street:String
    let suite:String
    let city:String
    let zipcode:String
}
