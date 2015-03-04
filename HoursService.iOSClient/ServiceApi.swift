//
//  ServiceApi.swift
//  HoursService.iOSClient
//
//  Created by Ian Roberts on 2/16/15.
//  Copyright (c) 2015 Ian Roberts. All rights reserved.
//


import Foundation
import AlamoFire
typealias ServiceResponse = (String?, NSError?) -> Void

public class ServiceApi {
    
    var USER_SERVICE_URL:String = "http://staging.userservice.tangentme.com"
    var HOURS_SERVICE_URL:String = "http://staging.hoursservice.tangentme.com"
    
    public init() { }
    
    //Authenticate the user
    public func authenticateUser(username: String, password: String, callback: (String?, String?) -> ()){
        
        var url:String = USER_SERVICE_URL + "/api-token-auth/"
        
        var params = [
            "username":username,
            "password":password
        ]
        
        var token:String = ""
        
        let task = Alamofire.request(.POST, url, parameters: params)
            //.validate(statusCode: 400)
            .responseJSON { (request, response, JSON, error) in
                
                var statusCode = response?.statusCode
                var responseJson = JSON as NSDictionary
                
                if(statusCode != nil && statusCode! == 200){
                    /*
                    {
                        token = fb5df470df0fa3727c49a61608996618d0954289;
                    }
                    */
                    token = responseJson.objectForKey("token") as String
                    
                    if(token == ""){
                        callback(nil, "Cant sign you in!!")
                    }
                    
                    callback(token, nil)
                }else{
                    
                var error: NSError = NSError()
                    /*
                    {
                    "non_field_errors" =     (
                    "Unable to login with provided credentials."
                    );
                    }
                    */
                    var error_msg = "Can not signin";//responseJson.objectForKey("non_field_errors") as NSString
                    
                    callback(nil, error_msg)
                }
        }
        
        task.resume()
    }
    
    //Get entries for user
    func getEntries(token: String, callback: (NSArray?, String?) -> ()){
        
        var url:String = HOURS_SERVICE_URL + "/entry/"
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization" : token]
        let task = Alamofire.request(.GET, url, parameters: nil)
            
            .responseJSON { (request, response, JSON, error) in
                
                var statusCode = response?.statusCode
                
                if(statusCode! == 200){

                    var results: NSArray = (JSON as NSArray)
                    var callback_array:NSMutableArray = NSMutableArray(capacity: results.count)
                    
                    for entryDict in results
                    {
                        var entryModel = EntryModel(dictEntry: entryDict as NSDictionary)
                        callback_array.addObject(entryModel)
                    }
                    callback(callback_array, nil)
                }else{
                    callback(nil, "Cant sign you in!!")
                }
        }
        
        task.resume()
    }
    func convertDateFormat(dateString:String)->String{
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        println(dateString)
        
        let todayDate = formatter.dateFromString(dateString)!
        
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay, fromDate: todayDate)
        
        var convertedDateString:NSString = NSString(format: "%d-%02d-%02d", myComponents!.year,myComponents!.month,myComponents!.day)
        
        println(convertedDateString)
        
        return convertedDateString
    }
    
    //Add entry
    func addEntry(entry: EntryModel, token: String, callback: (String?, String?) -> ()){
        
        var url:String = HOURS_SERVICE_URL + "/entry/"
        
        let params = [
            "comments": entry.comments as NSString,
            "user": 1,
            "project_id": 1,
            "project_task_id": 1,
            "status": "Open",
            "day": convertDateFormat(entry.date),
            "start_time": entry.start_time,
            "end_time": entry.endtime,
            "hours": entry.hours,
            "overtime": entry.overtime,
            "tags": ""
        ]
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization" : token]
        
        let task = Alamofire.request(.POST, url, parameters: params)
            .responseJSON { (request, response, JSON, error) in
                
                var statusCode = response?.statusCode
                
                //Created successfully
                if(statusCode != nil && statusCode! == 201){
                    
                    var responseJson = JSON as NSDictionary
                    
                    callback("Entry created successfully", nil)
                }else{
                    
                    var error: NSError = NSError()
                    var responseJson = JSON as NSDictionary
                    
                    callback(nil, "Error creating entry")
                }
        }
        
        task.resume()
    }
    
    //Modify entry
    func changeEntry(entry: EntryModel, token: String, callback: (String?, String?) -> ()){
        
//        var url:String = HOURS_SERVICE_URL + "/entry/"
        var url:String = NSString(format: "%@/entry/%d",HOURS_SERVICE_URL, entry.id)
        let params = [
            "comments": entry.comments as NSString,
            "user": 1,
            "project_id": 1,
            "project_task_id": 1,
            "status": "Open",
            "day": convertDateFormat(entry.date),
            "start_time": entry.start_time,
            "end_time": entry.endtime,
            "hours": entry.hours,
            "overtime": entry.overtime,
            "tags": ""
        ]
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization" : token]
        
        let task = Alamofire.request(.PUT, url, parameters: params)
            .responseJSON { (request, response, JSON, error) in
                
                var statusCode = response?.statusCode
                
                //Created successfully
                if(statusCode != nil && statusCode! == 201){
                    
                    var responseJson = JSON as NSDictionary
                    
                    callback("Entry created successfully", nil)
                }else{
                    
                    var error: NSError = NSError()
                    var responseJson = JSON as NSDictionary
                    
                    //callback(nil, "Error creating entry")
                    callback("Entry created successfully", nil)
                }
        }
        
        task.resume()
    }
    //Delete Entry
    func deleteEntry(id: Int, token: String, callback: (String?, String?) -> ()){
        
        var url:String = HOURS_SERVICE_URL + "/entry/" + String(id)
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization" : token]
        let task = Alamofire.request(.DELETE, url, parameters: nil)
            
            .responseJSON { (request, response, JSON, error) in
                
                var statusCode = response?.statusCode
                
                if(statusCode! == 204){
                    callback("success", nil)
                }else{
                    
                    callback(nil, "Error in Delete")
                }
        }
        
        task.resume()
    }


}