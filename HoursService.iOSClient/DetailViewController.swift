//
//  DetailViewController.swift
//  HoursService.iOSClient
//
//  Created by Ian Roberts on 2/22/15.
//  Copyright (c) 2015 Ian Roberts. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    // model to display
//    var comments: String?
//    var hours: String?
    
    var entryModel:EntryModel?
    
    @IBOutlet weak var lblComments: UILabel!
    
    @IBOutlet weak var lblHours: UILabel!
    
    @IBOutlet weak var start_time:UILabel!
    
    @IBOutlet weak var end_time:UILabel!
    
    @IBOutlet weak var day:UILabel!
    
    @IBOutlet weak var overtime:UILabel!
    
    @IBAction func onClickEdit(){
        let entryScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EntryScreenViewController") as EntryScreenViewController
        entryScreenViewController.tempEntry = entryModel
        entryScreenViewController.detailViewController = self
        
        self.navigationController?.pushViewController(entryScreenViewController, animated: true)
    }
    
    func fillLabelsFromEntryModel(){
        self.lblComments!.text = entryModel?.comments
        self.lblHours!.text = entryModel?.hours
        self.day!.text = entryModel?.date
        self.start_time!.text = entryModel?.start_time
        self.end_time!.text = entryModel?.endtime
        
        if entryModel?.overtime == true
        {
            self.overtime!.text = "Yes"
        }
        else
        {
            self.overtime!.text = "No"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fillLabelsFromEntryModel()
        // display the item
    }
}
