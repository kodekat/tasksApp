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
        //if newDict["title"] == "" {
       
        self.tableView.reloadData()
        saveTasksArray()
        //segue
        performSegueWithIdentifier("showEditorSegue", sender: nil)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)]
        if let newTasks = NSUserDefaults.standardUserDefaults().arrayForKey("tasks") as? [[String:String]]
        {
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
        // default Delete button
        /*if editingStyle == .Delete {
            arrTasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }*/
    }
     // --------
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // editable cells
        return true
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let complete = UITableViewRowAction(style: .Normal, title: "Check") { action, index in
            //tableView.cellForRowAtIndexPath(indexPath: NSIndexPath)?.endEditing(true)
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
            self.tableView.setEditing(false, animated: false) //moves cell back
            
            //print("Complete button tapped")//for debugging //✔️
        }
        complete.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 254/255, alpha: 1.0)
        //(red: 0/255, green: 177/255, blue: 106/255, alpha: 1.0) - shade of green
        
        
        let incomp = UITableViewRowAction(style: .Normal, title: "Uncheck") { action, index in
            //tableView.cellForRowAtIndexPath(indexPath: NSIndexPath)?.endEditing(true)
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .DisclosureIndicator
            self.tableView.setEditing(false, animated: false) //moves cell back
            
            //print("Incomplete button tapped")//for debugging //✖️
            
        }
        incomp.backgroundColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1.0)
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            self.arrTasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.reloadData()
            //print("Delete button tapped") //for debugging
        }
        delete.backgroundColor = UIColor(red: 202/255, green: 47/255, blue: 50/255, alpha: 1.0)
        
        return [delete, incomp, complete]
    }
    //overrides default delete
    //---------
    
    
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