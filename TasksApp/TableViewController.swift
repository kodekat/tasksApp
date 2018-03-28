//
//  TableViewController.swift
//  TasksApp
//
//  Created by Teodora on 3/10/18.
//  Copyright © 2018 Teodora. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, TaskViewDelegate {
    
    //an array of dictionaries
    // keys = "title", "description"
    var arrTasks = [[String:String]]()
    var selectedIndex = -1

    @IBAction func addNewTask() {
        self.selectedIndex = 0
        
        //new dictionary with 2 keys
        let newDict = ["title" : "", "description" : ""]
        
        arrTasks.insert(newDict, atIndex: 0)
        self.tableView.reloadData()
        
        saveTasksArray()
        //segue
        performSegueWithIdentifier("showEditorSegue", sender: nil)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let newTasks = NSUserDefaults.standardUserDefaults().arrayForKey("tasks") as? [[String:String]] {
            
                arrTasks = newTasks
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            //return 5
            return arrTasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!as UITableViewCell
            cell.textLabel!.text = arrTasks[indexPath.row]["title"]
        
            return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            self.selectedIndex = indexPath.row
            performSegueWithIdentifier("showEditorSegue", sender: nil)
            
    }
   
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Delete the row
        if editingStyle == .Delete {
            arrTasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
        
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            let taskEditorVC = segue.destinationViewController as! TasksViewController
            taskEditorVC.navigationItem.title = arrTasks[self.selectedIndex]["title"]
            taskEditorVC.strBodyText = arrTasks[self.selectedIndex]["description"]
            taskEditorVC.delegate = self
    
    }
    
    func didUpdateTaskWithTitle(newTitle: String, andBody newBody:String) {
            
            //update
            self.arrTasks[self.selectedIndex]["title"] = newTitle
            self.arrTasks[self.selectedIndex]["description"] = newBody
            
            //refresh
            self.tableView.reloadData()
            saveTasksArray()
    }
    func saveTasksArray() {
        
        //save the newly updated array
        NSUserDefaults.standardUserDefaults().setObject(arrTasks, forKey: "tasks")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}