//
//  TasksViewController.swift
//  TasksApp
//
//  Created by Teodora on 3/10/18.
//  Copyright © 2018 Teodora. All rights reserved.
//

//import Cocoa
import UIKit


protocol TaskViewDelegate {
    func didUpdateTaskWithTitle(newTitle : String, andBody newBody :String)
}

class TasksViewController: UIViewController, UITextViewDelegate  {
    var delegate : TaskViewDelegate?
    @IBOutlet weak var txtBody : UITextView!
    @IBOutlet weak var btnDoneEditing: UIBarButtonItem!
    
    var strBodyText : String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //set text
        if self.txtBody.text != nil{
            self.txtBody.text = self.strBodyText }
        
        self.txtBody.becomeFirstResponder() //keyboard
        self.txtBody.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0) // green back button
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)]
        self.navigationController?.title
    
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //update the selected row
        
        if self.txtBody.text != nil {
            self.delegate!.didUpdateTaskWithTitle(self.navigationItem.title!, andBody: self.txtBody.text)
        }
    
    }
    @IBAction func doneEditingBody() {
        
    
        self.txtBody.resignFirstResponder() //hide keyboard
        
        self.btnDoneEditing.tintColor = UIColor.clearColor()
    
        if self.delegate != nil {
            self.delegate!.didUpdateTaskWithTitle( self.navigationItem.title!, andBody: self.txtBody.text)
        }
    }
    func textViewDidChange(textView: UITextView) {
        
        let components = self.txtBody.text.componentsSeparatedByString("\n")
        self.navigationItem.title = ""
        
        for thing in components {
        if thing.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).characters.count > 0 {
                self.navigationItem.title = thing
                break
            }
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        //color Done - actual RGB values
        self.btnDoneEditing.tintColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)
    }

}
