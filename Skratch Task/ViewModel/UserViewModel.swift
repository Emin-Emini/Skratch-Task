//
//  UserViewModel.swift
//  Skratch Task
//
//  Created by Emin Emini on 4.4.21.
//

import Foundation
import UIKit

struct UserViewModel {
    let gender: String
    let name: Name
    let picture: Picture
    let dob: SinceDate
    let registered: SinceDate
    let location: Location
    let login: Login
    let email: String
    let phone: String
    
    init(with model: User) {
        gender = model.gender
        name = model.name
        picture = model.picture
        dob = model.dob
        registered = model.registered
        location = model.location
        login = model.login
        email = model.email
        phone = model.phone
    }
}
