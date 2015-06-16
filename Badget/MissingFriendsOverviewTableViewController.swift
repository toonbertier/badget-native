//
//  MissingFriendsOverviewTableViewController.swift
//  Badget
//
//  Created by Toon Bertier on 05/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

protocol MissingFriendsOverviewTableViewControllerDelegate:class {
    
    func didSelectMissingFriend(data:User)
    func showLoadingView()
    func removeLoadingView()
    
}

class MissingFriendsOverviewTableViewController: UITableViewController {
    
    var loadingView:UIView?
    var missingFriends:Array<User>! {
        didSet {
            loadProfilePictures()
        }
    }
    var refreshC:UIRefreshControl!
    weak var delegate:MissingFriendsOverviewTableViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        loadMissingFriends()
    }

    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoadingView() {
        self.delegate?.showLoadingView()
    }
    
    func removeLoadingView() {
        self.delegate?.removeLoadingView()
    }
    
    func loadMissingFriends() {
        self.missingFriends = Array<User>()
        FBLoginViewController.doActionOnFacebookFriends(checkForMissingFriends)
    }
    
    func loadProfilePictures() {
        for (index, friend) in enumerate(self.missingFriends) {
            var path = "/\(friend.facebookId)/picture?type=normal&redirect=false"
            
            let pictureRequest = FBSDKGraphRequest(graphPath: path, parameters: nil)
            pictureRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
                if error == nil {
                    if let resultUnwrapped:AnyObject = result {
                        let resultDict = resultUnwrapped as! NSDictionary
                        let data = resultDict["data"] as! NSDictionary
                        let url = data["url"] as! String
                        self.missingFriends[index].picture = url
                    }
                } else {
                    println("\(error)")
                }
                
                self.tableView.reloadData()
            })
        }
    }
    
    func checkForMissingFriends(friends:NSArray) {
        
        showLoadingView()
        
        for friend in friends {
            var friendId = friend["id"] as! String
            var url = "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/users/facebookids/\(friendId)"
            Alamofire.request(.GET, url).responseJSON(completionHandler: { (_, _, data, error) -> Void in
                if let dataUnwrapped:AnyObject = data {
                    self.addMissingUserToArray(data!)
                }
            })
        }
        
        removeLoadingView()
        self.refreshC.endRefreshing()
    }
    
    func addMissingUserToArray(data:AnyObject) {
        var json = JSON(data)
        
        if(json["missing"] == 1) {
            
            var deviceId = json["device_id"].stringValue
            var facebookId = json["facebook_id"].stringValue
            var name = json["name"].stringValue
            var missing = json["missing"].intValue
            var latitude = json["latitude"].doubleValue
            var longitude = json["longitude"].doubleValue
            
            var user = User(deviceId: deviceId, facebookId: facebookId, name: name, missing: missing, latitude: latitude, longitude: longitude)
            self.missingFriends.append(user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(MissingFriendCell.classForCoder(), forCellReuseIdentifier: "MissingFriendCell")
        
        self.refreshC = UIRefreshControl()
        self.refreshC.attributedTitle = NSAttributedString(string: "Herladen")
        self.refreshC.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshC)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh(sender:UIRefreshControl) {
        loadMissingFriends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if(self.missingFriends.count > 0) {
            self.tableView.separatorStyle = .SingleLine
            self.tableView.backgroundView = nil
            self.tableView.backgroundColor = .clearColor()
            return 1
        } else {
            showNoMissingFriendsLabel()
        }
        return 0
    }
    
    func showNoMissingFriendsLabel() {
        let label = UILabel(frame: self.tableView.frame)
        label.text = "Er loopt niemand verloren. Geniet van Pukkelpop!"
        label.numberOfLines = 0
        label.textAlignment = .Center
        
        self.tableView.backgroundView = label as UIView
        self.tableView.separatorStyle = .None
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.missingFriends.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MissingFriendCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MissingFriendCell", forIndexPath: indexPath) as! MissingFriendCell

        // Configure the cell...
        
        let data = self.missingFriends[indexPath.row]
        cell.textLabel?.text = data.name
        
        if(data.latitude != 0) {
            cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        }
        
        if let picture = data.picture {
            let stringUrl = picture
            let url = NSURL(string: stringUrl)
            let contents = NSData(contentsOfURL: url!)
            let image = UIImage(data: contents!)
            cell.imageView?.image = image
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        println("tapped accessory button")
        let data = self.missingFriends[indexPath.row]
        self.delegate?.didSelectMissingFriend(data)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
