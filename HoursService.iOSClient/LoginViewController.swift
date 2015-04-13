//
//  LoginViewController.swift
//  HoursService.iOSClient
//
//  Created by Ian Roberts on 2/10/15.
//  Copyright (c) 2015 Ian Roberts. All rights reserved.
//


import UIKit
import Alamofire

public class LoginViewController: UIViewController {
    
    var api: ServiceApi = ServiceApi()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, message:String){
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    public override func viewDidAppear(animated: Bool) {

    }
    public override func viewDidLoad(){
//        super.viewDidAppear(animated)
        
//        var token = NSUserDefaults.standardUserDefaults().stringForKey("token")
//        
//        if token?.isEmpty == false
//        {
//            self.performSegueWithIdentifier("gotoTabVC", sender: self)
//        }
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
    
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnLoginTouch(sender: AnyObject) {
        
        var username = txtUserName.text
        var password = txtPassword.text
        
        var error = ""
        
        if (username == "" || password == "")
        {
            error = "Please enter in a username and password"
        }
        
        if error != "" {
            displayAlert("Error in Form", message: error)
        }
        else{
            
            //Start loader
            startLoader()
            
            //Attempt to login
            api.authenticateUser(username, password: password, callback: { (success:String?, error:String?) -> () in
                
                //Stop the loader
                self.stopLoader()
                
                if ((error) != nil) {
                    
                    self.displayAlert("Login Error", message: error!)
                } else {
                    
                    //Save the token to memory
                    NSUserDefaults.standardUserDefaults().setObject(success!, forKey: "token")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    //Move the user along
                    self.performSegueWithIdentifier("gotoTabVC", sender: self)
                }
            })

        }
    }
    
}
