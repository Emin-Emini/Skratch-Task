//
//  APIController.swift
//  Skratch Task
//
//  Created by Emin Emini on 3.4.21.
//

import Foundation

enum APIError: Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
    
    var errorDescription: String? {
        switch self {
        case .responseProblem:
            return "Response Problem"
        case .decodingProblem:
            return "Decoding Problem"
        case .encodingProblem:
            return "Encoding Problem"
        default:
            return "Other Error"
        }
    }
}

class APIController {
    
    var users: [User] = []
    
    var baseURL = URL(string: "https://randomuser.me/api/?results=5")!
    typealias CompletionHandler = (Error?) -> Void
    
    
    init(listSize: Int) {
        let resoucreString = "https://randomuser.me/api/?results=\(listSize)"
        guard let resourceURL = URL(string: resoucreString) else {print("Incorrect Pass");fatalError()}
        
        self.baseURL = resourceURL
    }
    
    init() {
        let resoucreString = "https://randomuser.me/api/?results=5"
        guard let resourceURL = URL(string: resoucreString) else {print("Incorrect Pass");fatalError()}
        
        self.baseURL = resourceURL
    }
    
    func getFriends(completion: @escaping(Result<UserResult?, APIError>) -> Void) {
        
        let urlRequest = URLRequest(url: baseURL)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                completion(.failure(.responseProblem))
                return
            }
            do {
                let newUsers = try JSONDecoder().decode(UserResult.self, from: jsonData)
                self.users = newUsers.results
                completion(.success(newUsers))
            } catch {
                completion(.failure(.decodingProblem))
                return
            }
        }
        dataTask.resume()
        
        
    }
}
