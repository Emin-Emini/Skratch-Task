//
//  APIController.swift
//  Skratch Task
//
//  Created by Emin Emini on 3.4.21.
//

import Foundation

class APIController {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?results=10")!
    typealias CompletionHandler = (Error?) -> Void
    
    func getUsers(completion: @escaping CompletionHandler = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error gettings user \(error)")
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(nil)
                return
            }
            
            do {
                let newUsers = try JSONDecoder().decode(UserResult.self, from: data)
                self.users = newUsers.results
                print(newUsers)
            } catch {
                NSLog("Error decoding users \(error)")
                completion(error)
            }
            completion(nil)
        }.resume()
    }
}
