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
    
    var errorDescription: String? {
        switch self {
        case .responseProblem:
            return "Response Problem"
        case .decodingProblem:
            return "Decoding Problem"
        default:
            return "Other Error"
        }
    }
}

var listSizeNumber: Int = 5

class APIController {
    
    var users: [User] = []
    
    /*Note:
     Usually baseurl I create it like a base, for instance in this case: https://randomuser.me/api/
     So I can use it later through the app, in this case the proejct was simple, and I put the whole api in the baseURL.
     */
    var baseURL = URL(string: "https://randomuser.me/api/?results=\(listSizeNumber)")!
    typealias CompletionHandler = (Error?) -> Void
    
    
    init(listSize: Int) {
        let resoucreString = "https://randomuser.me/api/?results=\(listSize)"
        guard let resourceURL = URL(string: resoucreString) else {print("Wrong URL"); fatalError()}
        
        self.baseURL = resourceURL
    }
    
    init() {
        let resoucreString = "https://randomuser.me/api/?results=\(listSizeNumber)"
        guard let resourceURL = URL(string: resoucreString) else {print("Wrong URL"); fatalError()}
        
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
