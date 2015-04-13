//
//  EntryScreenViewController.swift
//  HoursService.iOSClient
//
//  Created by Ian Roberts on 2/10/15.
//  Copyright (c) 2015 Ian Roberts. All rights reserved.
//

import UIKit

class EntryScreenViewController: UIViewController {
    
    var api: ServiceApi = ServiceApi()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var tempEntry:EntryModel?
    var detailViewController:DetailViewController?
    
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    func clearForm(){
        self.txtComments.text = ""
        self.txtHours.text = "8";
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        self.txtDay.text = dateFormatter.stringFromDate(NSDate())
        
        self.txtStartTime.text = "08:00"
        self.txtEndTime.text = "17:00"
    }
    
    @IBOutlet weak var txtComments: UITextField!
    
    @IBOutlet weak var txtHours: UITextField!
    
    @IBOutlet weak var txtStartTime: UITextField!
    
    @IBOutlet weak var txtEndTime: UITextField!
    
    @IBOutlet weak var switchOvertime: UISwitch!
    
    @IBOutlet weak var txtDay: UITextField!
    
    @IBAction func btnCancelPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tapOnDay(sender: UITextField){
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.minuteInterval = 30
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDayDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func btnStartTimePressed(sender: UITextField) {
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.minuteInterval = 30
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleStartTimeDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func txtEndTimePressed(sender: UITextField) {
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.minuteInterval = 30
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleEndTimeDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    
    }
    
    func handleDayDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        txtDay.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func handleStartTimeDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        txtStartTime.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func handleEndTimeDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        txtEndTime.text = dateFormatter.stringFromDate(sender.date)

    }
    func changeEntry(){
        
    }
    @IBAction func btnSavePressed(sender: AnyObject) {
        var token = NSUserDefaults.standardUserDefaults().stringForKey("token")
        var comments = txtComments.text
        var hours = txtHours.text
        
        startLoader()
        
        var entry:EntryModel = EntryModel()
        entry.id = 0
        if tempEntry != nil{
            entry = tempEntry!
        }
        entry.hours = hours
        entry.comments = comments
        entry.start_time = txtStartTime.text
        entry.endtime = txtEndTime.text
        entry.date = txtDay.text
        
        if switchOvertime.on == true{
            entry.overtime = true;//(txtOvertime.text as NSString).integerValue
        }else{
            entry.overtime = false;
        }
        if tempEntry != nil
        {
            api.changeEntry(entry, token: token!, callback: { (success:String?, error:String?) -> () in
                
                if ((error) != nil) {
                    self.stopLoader()
                    
                    self.displayAlert("Error Saving Entry", message: error!)
                } else {
                    //Stop the loading
                    self.stopLoader()
                    self.detailViewController!.entryModel = entry
                    self.detailViewController!.fillLabelsFromEntryModel()
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    //clear the form
                    self.clearForm()
                }
            })
            return
        }
        api.addEntry(entry, token: token!, callback: { (success:String?, error:String?) -> () in
            
            if ((error) != nil) {
                self.stopLoader()
                
                self.displayAlert("Error Saving Entry", message: error!)
            } else {
                //Stop the loading
                self.stopLoader()
                
                //clear the form
                self.clearForm()
            }
            
        })
    }
    func convertDateFormat(dateString:NSString)->String{
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var date:NSDate = formatter.dateFromString(dateString as String)!
        
        
        formatter.dateFormat = "d MMMM yyyy"
        var converted:NSString = formatter.stringFromDate(date)

        return converted as String
    }
    func convertTimeFormat(timeString:NSString)->String{
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        var date:NSDate = formatter.dateFromString(timeString as String)!
        
        formatter.dateFormat = "H:mm"
        var converted:NSString = formatter.stringFromDate(date)
        
        return converted as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if tempEntry != nil
        {
            txtComments.text = tempEntry!.comments
            txtHours.text = tempEntry!.hours as String
            txtDay.text = convertDateFormat(tempEntry!.date)
            txtStartTime.text = convertTimeFormat(tempEntry!.start_time)
            txtEndTime.text = convertTimeFormat(tempEntry!.endtime)
            
            if tempEntry!.overtime == true
            {
                switchOvertime.setOn(true, animated: true)
            }else
            {
                switchOvertime.setOn(false, animated: true)
            }
        }
        else
        {
            clearForm()
        }
        var tapgesture = UITapGestureRecognizer(target: self, action: Selector("tapOnDay:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        if tempEntry == nil{
            clearForm()
        }
    }
}

