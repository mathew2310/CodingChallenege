//
//  ViewControlelrTest.swift
//  MathewChallengeTests
//
//  Created by Mathew Ijidakinro on 17/05/2022.
//

import XCTest
@testable import MathewChallenge

class ViewControllerTest: XCTestCase {

    var viewController: ViewController!
    
    override func setUpWithError() throws {

        viewController = ViewController()
    }


    func testTitle() {
        
        viewController.viewDidLoad()
        
        XCTAssertEqual(viewController.title, "Movies")
    }

   

}
