//
//  ViewController.swift
//  Notey
//
//  Created by Antonija Pek on 13/02/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//
import UIKit
import QuartzCore
import AVFoundation
import iAd

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate, Deletable {
    
    @IBOutlet weak var inputField: CustomTextField!
    @IBOutlet weak var notesTable: UITableView!
    @IBOutlet weak var iadBanner: ADBannerView!
    
    var addSound: AVAudioPlayer!
    var notes = [Notes]()
    
    // MARK: - Sound
    
    func playSound() {
        if addSound.playing {
            addSound.stop()
        }
        
        addSound.play()
    }
    

    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notes.count < 1 {
            return 0
        } else {
            return notes.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("cell") as! CustomCell
        
        // Fetches the appropriate meal for the data source layout.
        let note = notes[indexPath.row]
        
        if note.selected == true {
            cell.deleteBtn.hidden = false
        } else if note.selected == false {
            cell.deleteBtn.hidden = true
        }
        
        cell.cellLabel!.text = note.item
        
        if cell.delegate == nil {
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = notesTable.cellForRowAtIndexPath(indexPath) as! CustomCell

        if notes[indexPath.row].selected == false {
            notes[indexPath.row].selected = true
            cell.deleteBtn.hidden = false

        } else if notes[indexPath.row].selected == true {
            notes[indexPath.row].selected = false
            cell.deleteBtn.hidden = true
        }
        
        inputField.resignFirstResponder()
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = notesTable.cellForRowAtIndexPath(indexPath) as! CustomCell
        notes[indexPath.row].selected = false
        cell.deleteBtn.hidden = true
    
    }
    
    
    // MARK: - Methods
    
    @IBAction func addButton(sender: UIButton) {
        if let item = Notes(item: inputField.text!) {
            notes.insert(item, atIndex: 0)
            saveItems()
            playSound()
            inputField.text = nil
            notesTable.reloadData()
        }
        
        inputField.resignFirstResponder()
    }
    
    func deleteButtonPressed(cell: CustomCell) {
        let cellRow = notesTable.indexPathForCell(cell)?.row
        notes.removeAtIndex(cellRow!)
        
        notesTable.reloadData()
        saveItems()
        
        cell.deleteBtn.hidden = true
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        notesTable.reloadData()
    }
    
    // MARK: NSCoding
    
    func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(notes, toFile: Notes.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save")
        }
    }
    
    func loadItems() -> [Notes]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Notes.ArchiveURL.path!) as? [Notes]
    }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iAd Setup
        iadBanner.hidden = true
        iadBanner.delegate = self
        
        // Connect and prepare audio
        let path = NSBundle.mainBundle().pathForResource("pop_drip", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        
        do {
            try addSound = AVAudioPlayer(contentsOfURL: soundURL)
            addSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        if let savedItems = loadItems() {
            notes += savedItems
        }
        
        notesTable.delegate = self
        notesTable.dataSource = self
        
        // You have to declare self as the delegate, to respond to user inputs
        inputField.delegate = self
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("Error loading iAds")
        iadBanner.hidden = false
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        iadBanner.hidden = false
    }

    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        for note in notes {
            note.selected = false
        }
        notesTable.reloadData()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        inputField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        inputField.resignFirstResponder()
        saveWithReturn()
        return true
    }
    
    
    func saveWithReturn() {
        if let item = Notes(item: inputField.text!) {
            notes.insert(item, atIndex: 0)
            saveItems()
            playSound()
            inputField.text = nil
            notesTable.reloadData()
        }

    }
    
    // This function dismisses the keyboard when user touches outside the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

