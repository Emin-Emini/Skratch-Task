//
//  Skratch_TaskTests.swift
//  Skratch TaskTests
//
//  Created by Emin Emini on 3.4.21.
//

import XCTest
@testable import Skratch_Task

class Skratch_TaskTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    //Testing MVVM
    func testUserViewModel() throws {
        let picture = Picture(large: URL(fileURLWithPath: "https://randomuser.me/api/portraits/men/4.jpg"),
                              medium: URL(fileURLWithPath: "https://randomuser.me/api/portraits/med/men/4.jpg"),
                              thumbnail: URL(fileURLWithPath: "https://randomuser.me/api/portraits/thumb/men/4.jpg"))
        
        let user = User(gender: "male",
                        name: Name.init(first: "Emin", last: "Emini"),
                        picture: picture,
                        dob: SinceDate(date: "1998-07-12T15:51:16.196Z", age: 22),
                        registered: SinceDate(date: "2021-04-03T10:00:00.000Z", age: 0),
                        location: Location.init(street: Street(number: 74, name: "Rexhep Dajkovci"),
                        city: "Gjilan",
                        state: "Kosovo",
                        country: "Kosovo",
                        coordinates: Coordinates(latitude: "", longitude: "")),
                        login: Login(username: "eminemini"),
                        email: "eemini798@gmail.com",
                        phone: "+383 49 123 456")
        
        let userViewModel = UserViewModel(with: user)
        
        //Test
        XCTAssertEqual(user.gender, userViewModel.gender)
        
        XCTAssertEqual(user.name.first, userViewModel.name.first)
        XCTAssertEqual(user.name.last, userViewModel.name.last)
        
        XCTAssertEqual(user.picture.thumbnail, userViewModel.picture.thumbnail)
        XCTAssertEqual(user.picture.medium, userViewModel.picture.medium)
        XCTAssertEqual(user.picture.large, userViewModel.picture.large)
        
        XCTAssertEqual(user.dob.date, userViewModel.dob.date)
        XCTAssertEqual(user.dob.age, userViewModel.dob.age)
        XCTAssertEqual(user.registered.date, userViewModel.registered.date)
        XCTAssertEqual(user.registered.age, userViewModel.registered.age)
        
        XCTAssertEqual(user.location.city, userViewModel.location.city)
        XCTAssertEqual(user.location.state, userViewModel.location.state)
        XCTAssertEqual(user.location.country, userViewModel.location.country)
        XCTAssertEqual(user.location.coordinates.latitude, userViewModel.location.coordinates.latitude)
        XCTAssertEqual(user.location.coordinates.longitude, userViewModel.location.coordinates.longitude)
        
        XCTAssertEqual(user.login.username, userViewModel.login.username)
        XCTAssertEqual(user.email, userViewModel.email)
        XCTAssertEqual(user.phone, userViewModel.phone)
    }
    
    //Testing API
    func testAPI() {
        let apiController = APIController(listSize: 5)
        
        XCTAssertNoThrow(
            apiController.getFriends(completion: { result in
                switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        print(users)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
        )
    }
    
    func testAPIDecode() throws {
        let apiController = APIController()
        let expectedError = APIError.responseProblem
        var error: APIError?
        
        
        XCTAssertThrowsError(
            apiController.getFriends(completion: { result in
                switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        print(users)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
        ) { thrownError in
            error = thrownError as? APIError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    //Testing TextField to API
    func testTextFieldToFriendsListSize() {
        let testListSize = 0
        let apiController = APIController(listSize: testListSize)
        
        apiController.getFriends(completion: { result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    print(users)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        })
        
        XCTAssertEqual(apiController.users.count, testListSize)
    }
    
    
}
