//
//  FirstViewController.swift
//  HoursService.iOSClient
//
//  Created by Ian Roberts on 2/10/15.
//  Copyright (c) 2015 Ian Roberts. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {

    var api: ServiceApi = ServiceApi()
    
    var entriesList:NSArray = NSArray()
    var groupedEntriesList:NSMutableArray = NSMutableArray()

    @IBOutlet var tvEntries: UITableView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, message:String){
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func startLoader(){
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func stopLoader(){
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    func getWeekDayFromDateString(dateString:String)->Int{
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let todayDate = formatter.dateFromString(dateString)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let myComponents = myCalendar?.components(.WeekdayCalendarUnit, fromDate: todayDate)


        var weekDay = myComponents?.weekday
        return weekDay!
    }
    func groupEntriesByWeekday(){
        let weekLabel = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        
        //Create Initial Buffer
        for var index = 0;index < 7;index++
        {
            let week_name:NSString = weekLabel[index] as NSString
            var weekEntriesList:NSMutableArray = NSMutableArray()

            var dataDict:NSDictionary = ["week_name":week_name,"entry_list":weekEntriesList]
            
            groupedEntriesList.addObject(dataDict)
        }
        
        //Add Entry to according weekday
        for oneEntry in entriesList{
            var modelEntry:EntryModel = oneEntry as! EntryModel
            
            var weekday:Int = getWeekDayFromDateString(modelEntry.date as String)
            weekday = weekday - 1
            let entry_dict:NSDictionary = (groupedEntriesList[weekday]) as! NSDictionary
            (entry_dict["entry_list"] as! NSMutableArray).addObject(modelEntry)
        }
        var tempArray:NSMutableArray = NSMutableArray()
        
        //Remove empty Week entry list
        for var weekIndex  = 0;weekIndex < 7;weekIndex++
        {
            let entryDict:NSDictionary = groupedEntriesList[weekIndex] as! NSDictionary
            var entryArray:NSArray
            entryArray = (entryDict["entry_list"] as! NSArray)
            
            if entryArray.count != 0
            {
                tempArray.addObject(entryDict)
            }
        }
        
        groupedEntriesList.removeAllObjects()
        groupedEntriesList.addObjectsFromArray(tempArray as [AnyObject])
        
        self.tvEntries.reloadData()
    }
    func loadEntries(){
        var token = NSUserDefaults.standardUserDefaults().stringForKey("token")
        groupedEntriesList.removeAllObjects()
        
        startLoader()
        
        api.getEntries(token!, callback: { (success:NSArray?, error:String?) -> () in
            
            self.entriesList = success!
            self.groupEntriesByWeekday()
            self.stopLoader()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let entryDict:NSDictionary = (groupedEntriesList[section] as! NSDictionary)
        let weekName:NSString = entryDict["week_name"] as! String

        return weekName as String
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupedEntriesList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupedEntriesList.count == 0
        {
            return 0
        }
        var entryList:NSArray = ((groupedEntriesList[section]) as! NSDictionary)["entry_list"] as! NSArray
        return entryList.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func convertTimeHourAndMinute(fulltimeString:NSString)->String{
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "HH-mm-ss"
        
        let todayDate = formatter.dateFromString(fulltimeString as String)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let myComponents = myCalendar?.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute, fromDate: todayDate)
        
        var convertedTime = NSString(format: "%02d:%02d", myComponents!.hour,myComponents!.minute)
        return convertedTime as String
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var entryCell:EntryCell = self.tableView.dequeueReusableCellWithIdentifier("entryCell") as! EntryCell

//        var entryModel = entriesList[indexPath.row] as EntryModel
//        
//        entryCell.comments.text = entryModel.comments
//        entryCell.hours.text = entryModel.hours

        var entryModel = ((groupedEntriesList[indexPath.section] as! NSDictionary)["entry_list"] as! NSArray)[indexPath.row] as! EntryModel
        
        entryCell.comments.text = entryModel.comments
        entryCell.hours.text = entryModel.hours as String
        
        entryCell.times.text = NSString(format: "%@ - %@", convertTimeHourAndMinute(entryModel.start_time), convertTimeHourAndMinute(entryModel.endtime)) as String
        
        return entryCell
    }
    
    override func tableView(tableView: (UITableView!), canEditRowAtIndexPath indexPath: (NSIndexPath!)) -> Bool {
        return true
    }
    
    override func tableView(tableView: (UITableView!), commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: (NSIndexPath!)) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            var deleteId:Int = (entriesList[indexPath.row] as! EntryModel).id
            var token = NSUserDefaults.standardUserDefaults().stringForKey("token")
            
            startLoader()
    
            api.deleteEntry(deleteId, token: token!, callback: { (success:String?, error:String?) -> () in
                
                self.stopLoader()
                
                if ((error) != nil) {
                    
                    self.displayAlert("Delete Error", message: error!)
                } else {
                    
                    self.loadEntries()
                }
            })
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject!) {
            
            if(sender is EntryCell){
                
                let cell = sender as! EntryCell
                let indexPath = self.tableView.indexPathForCell(cell)
                
                // load the selected model
//                let comments = self.entriesList[indexPath!.row].comments as String
//                let hours = self.entriesList[indexPath!.row].hours as String
                
                let detail = segue.destinationViewController as! DetailViewController
                // set the model to be viewed
                let entryDict:NSDictionary = groupedEntriesList[indexPath!.section] as! NSDictionary
                let entryModel:EntryModel = ((entryDict["entry_list"] as! NSArray)[indexPath!.row]) as! EntryModel
                
                detail.entryModel = entryModel;//self.entriesList[indexPath!.row] as? EntryModel
                
//                detail.comments = comments
//                detail.hours = hours
            }
    }

    override func viewDidAppear(animated: Bool) {
        
        loadEntries()
    }
}

