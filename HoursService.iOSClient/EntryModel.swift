//
//  UserModel.swift
//  HoursService.iOSClient
//
//  Created by Ian Roberts on 2/21/15.
//  Copyright (c) 2015 Ian Roberts. All rights reserved.
//

import Foundation
/*
{
comments = "did a bunch I work";
created = "2015-02-22T12:42:01.789679Z";
day = "2015-02-19";
"end_time" = "14:13:09";
hours = "8.00";
id = 20;
overtime = 0;
"project_id" = 1;
"project_task_id" = 1;
"start_time" = "14:13:09";
status = Open;
tags = "";
updated = "2015-02-22T12:42:01.789729Z";
user = 1;
}
*/

class EntryModel : NSObject {
    var id: Int
    var comments: String
    var hours: NSString
    var created:NSString
    var date:NSString
    var endtime:NSString
    var overtime:Bool
    var project_id:Int
    var project_task_id:Int
    var start_time:NSString
    var status:NSString
    var tags:NSString
    var updated:NSString
    var user:Int
    
    init(dictEntry:NSDictionary){
        id = dictEntry["id"] as! Int
        comments = dictEntry["comments"] as! String
        hours = dictEntry["hours"] as! String
        created = dictEntry["created"] as! String
        date = dictEntry["day"] as! String
        endtime = dictEntry["end_time"] as! String
        overtime = dictEntry["overtime"] as! Bool
        project_id = dictEntry["project_id"] as! Int
        project_task_id = dictEntry["project_task_id"] as! Int
        start_time = dictEntry["start_time"] as! String
        status = dictEntry["status"] as! String
        tags = dictEntry["tags"] as! String
        updated = dictEntry["updated"] as! String
        user = dictEntry["user"] as! Int
    }
    override init() {
        id = 0
        comments = ""
        hours = ""
        created = ""
        date = ""
        endtime = ""
        overtime = false
        project_id = 0
        project_task_id = 0
        start_time = ""
        status = ""
        tags = ""
        updated = ""
        user = 0
    }
    
}