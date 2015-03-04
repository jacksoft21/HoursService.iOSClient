//
//  HoursService_iOSClientTests.swift
//  HoursService.iOSClientTests
//
//  Created by Ian Roberts on 2/10/15.
//  Copyright (c) 2015 Ian Roberts. All rights reserved.
//

import UIKit
import XCTest
import HoursService_iOSClient

class HoursService_iOSClientTests: XCTestCase {
    
    var token: String = ""
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddEntry(){
        var data = [
            "user": 1,
            "project_id": 1,
            "project_task_id": 1,
            "status": "Open",
            "day": "2015-02-19",
            "start_time": "14:13:09",
            "end_time": "14:13:09",
            "comments": "Test post",
            "hours": "4.00",
            "overtime": false,
            "tags": ""
        ]
    }
    
    func testAuthUserSuccess(){
        
        var serviceApi = ServiceApi()
        
        var username: String = "admin"
        var password: String = "a"
        
        serviceApi.authenticateUser(username, password: password, callback: { (success:String?, error:String?) -> () in
            
            XCTAssertNil(error, "Auth user error should return nil")
            XCTAssertNotNil(success, "A token should be returned")
            
            self.token = success!
        })
    }
    
    func testAuthUserFail(){
        
        var serviceApi = ServiceApi()
        
        var username: String = "fail"
        var password: String = "fail"
        
        serviceApi.authenticateUser(username, password: password, callback: { (success:String?, error:String?) -> () in
            
            XCTAssertNil(success, "Auth user should return nil")
            XCTAssertNotNil(error, "A token should be returned")
        })
    }
    
    func testGetEntriesSuccess(){
        
        /*var serviceApi = ServiceApi()
        
        serviceApi.getEntries(token, callback: { (success:NSArray?, error:String?) -> () in
            
            XCTAssertNil(error, "Get entry error should return nil")
            XCTAssertNotNil(success, "An array of data should be returned")
            XCTAssertGreaterThan(success!.count, 70, "More then 0 entries were returned")
            XCTAssertNotNil(success?[0]["comments"], "Comments exist")
        })
        */
        
    }
}
