//
//  User.swift
//  Skratch Task
//
//  Created by Emin Emini on 3.4.21.
//

import Foundation

struct UserResult: Decodable {
    let results: [User]
}

struct User: Decodable {
    var gender: String
    var name: Name
    var picture: Picture
    var dob: SinceDate
    var registered: SinceDate
    
    var location: Location
    
    var login: Login
    var email: String
    var phone: String
}

struct Name: Decodable {
    var first: String
    var last: String
}

struct Picture: Decodable {
    var large: URL
    var medium: URL
    var thumbnail: URL
}

struct SinceDate: Decodable {
    var date: String
    var age: Int
}

struct Login: Decodable {
    var username: String
}

struct Location: Decodable {
    var street: Street
    var city: String
    var state: String
    var country: String
    var coordinates: Coordinates
}

struct Street: Decodable {
    var number: Int
    var name: String
}

struct Coordinates: Decodable {
    var latitude: String
    var longitude: String
}
