//
//  VideosViewController.swift
//  Fleet
//
//  Created by Spencer Congero on 2/4/16.
//  Copyright © 2016 fleet. All rights reserved.
//

import UIKit

class VideosSearchViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource
{
    var bgColorRed: CGFloat = 255/255
    var bgColorGreen: CGFloat = 255/255
    var bgColorBlue: CGFloat = 255/255
    
    var fleetColorRed: CGFloat = 77/255
    var fleetColorGreen: CGFloat = 206/255
    var fleetColorBlue: CGFloat = 177/255
    
    var scrollButtonWidth: CGFloat = 150
    
    var hotBool: Bool = true
    var newBool: Bool = false
    var followBool: Bool = false
    
    var quicksandReg: String = "Quicksand-Regular"
    var quicksandBold: String = "Quicksand-Bold"
    var corbertReg: String = "Corbert-Regular"
    
    var fleetTitle: String = "fleet"
    
    var logoImg: String = "logo.png"
    var loginBoxImg: String = "login_box.png"
    var signUpBoxImg: String = "signup_box.png"
    
    // Do any additional setup after loading the view.
    
    //var videosLabel: UILabel!
    
    var videos: [Video]!
    var currentVideos: [Video]!
    
    var searchBar: UISearchBar!
    var scrollView: UIScrollView!
    var tableView: UITableView!
    
    var hotButton: UIButton!
    var newButton: UIButton!
    var followButton: UIButton!
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let bgColor = UIColor(red: bgColorRed, green: bgColorGreen, blue: bgColorBlue, alpha: 1)
        self.view.backgroundColor = bgColor
        
        // quickly just for testing, will delete later
        /*
        self.videosLabel = UILabel(frame: CGRect(x: self.view.center.x - 200/2, y: 100, width: 200, height: 50))
        self.videosLabel.attributedText = NSAttributedString(string: "videos", attributes: [NSForegroundColorAttributeName: UIColor(red: fleetColorRed, green: fleetColorGreen, blue: fleetColorBlue, alpha: 1), NSFontAttributeName: UIFont(name: corbertReg, size: 50)!])
        self.videosLabel.textAlignment = .Center
        self.videosLabel.backgroundColor = UIColor(white: 1, alpha: 0)
        
        self.view.addSubview(videosLabel)
        */
        
        _generateVideos()
        
        
        _addSearch()
        _addScrollView()
        _addTableView()
        
        
        _setAlphas()
        
        
    }
    
    // MARK: - UISearchBar methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        
    }
    
    // MARK: - UITableView methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentVideos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! VideosTableViewCell
        
        cell.backgroundColor = UIColor(white: 1, alpha: 1)
        
        if (indexPath.row % 2 != 0) {
            cell.backgroundColor = UIColor(white: 0.98, alpha: 1)
        }
        
        cell.title.text = currentVideos[indexPath.row].title
        cell.user.text = currentVideos[indexPath.row].user
        
        if currentVideos[indexPath.row].timeRemaining < 10 {
            cell.timer.image = UIImage(named: "red_timer.png")
        }
        else if currentVideos[indexPath.row].timeRemaining < 20 {
            cell.timer.image = UIImage(named: "orange_timer.png")
        }
        else if currentVideos[indexPath.row].timeRemaining < 30 {
            cell.timer.image = UIImage(named: "yellow_timer.png")
        }
        else {
            cell.timer.image = UIImage(named: "green_timer.png")
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = VideoViewController()
        vc.videoTitle = currentVideos[indexPath.row].title
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    // MARK: - Internal methods
    
    func hotPressed(sender: UIButton!)
    {
        hotBool = true
        newBool = false
        followBool = false
        
        _setAlphas()
        _sortVideos()
    }
    
    func newPressed(sender: UIButton!)
    {
        hotBool = false
        newBool = true
        followBool = false
        
        _setAlphas()
        _sortVideos()
    }
    
    func followPressed(sender: UIButton!)
    {
        hotBool = false
        newBool = false
        followBool = true
        
        _setAlphas()
        _sortVideos()
    }
    
    // MARK: - Private methods
    
    private func _generateVideos()
    {
        var sampleVideos = [Video]()
            
        let currentDate = NSDate()
            
        for index in 1...20 {
            let randomMinute: NSInteger = Int(arc4random_uniform(60)) + 1
            let randomRating: NSInteger = Int(arc4random_uniform(10)) + 1
                
            sampleVideos.append(Video.init(newTitle: "Live Video \(index)", newUser: "sample user \(index)", newDatePosted: currentDate, newTimeRemaining: randomMinute))
            
            sampleVideos[index-1].rating = randomRating
        }
        self.videos = sampleVideos
        self.currentVideos = sampleVideos
    }
    
    private func _sortVideos()
    {
        self.currentVideos.removeAll()
        
        if hotBool {
            
            for video in self.videos {
                if video.rating > 8 {
                    self.currentVideos.append(video)
                }
            }
        }
        else if newBool {
            
            for video in self.videos {
                if video.timeRemaining > 45 {
                    self.currentVideos.append(video)
                }
            }
        }
        else if followBool {
            self.currentVideos = self.videos
        }
        
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    private func _setAlphas()
    {
        if hotBool {
            self.hotButton.alpha = 1
            self.newButton.alpha = 0.4
            self.followButton.alpha = 0.4
        }
        else if newBool {
            self.hotButton.alpha = 0.4
            self.newButton.alpha = 1
            self.followButton.alpha = 0.4
        }
        else if followBool {
            self.hotButton.alpha = 0.4
            self.newButton.alpha = 0.4
            self.followButton.alpha = 1
        }
    }
    
    private func _addSearch()
    {
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 22, width: self.view.frame.width, height: 40))
        self.searchBar.placeholder = "SEARCH"
        
        self.view.addSubview(searchBar)
    }
    
    private func _addScrollView()
    {
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 62, width: self.view.frame.width, height: 60))
        
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.hotButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 60))
        self.hotButton.setTitle("HOT", forState: .Normal)
        self.hotButton.setTitleColor(UIColor(red: fleetColorRed, green: fleetColorGreen, blue: fleetColorBlue, alpha: 1), forState: .Normal)
        self.hotButton.contentHorizontalAlignment = .Center
        self.hotButton.titleLabel?.font = UIFont(name: quicksandReg, size: 25)
        self.hotButton.addTarget(self, action: "hotPressed:", forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(hotButton)
        
        self.newButton = UIButton(frame: CGRect(x:0, y: 0, width: 130, height: 60))
        self.newButton.setTitle("NEW", forState: .Normal)
        self.newButton.setTitleColor(UIColor(red: fleetColorRed, green: fleetColorGreen, blue: fleetColorBlue, alpha: 1), forState: .Normal)
        self.newButton.contentHorizontalAlignment = .Center
        self.newButton.titleLabel?.font = UIFont(name: quicksandReg, size: 25)
        self.newButton.addTarget(self, action: "newPressed:", forControlEvents: .TouchUpInside)
        
        var newFrame = self.newButton.frame
        newFrame.origin.x = self.hotButton.frame.width
        self.newButton.frame = newFrame
        
        self.scrollView.addSubview(newButton)
        
        self.followButton = UIButton(frame: CGRect(x:0, y: 0, width: 250, height: 60))
        self.followButton.setTitle("FOLLOWING", forState: .Normal)
        self.followButton.setTitleColor(UIColor(red: fleetColorRed, green: fleetColorGreen, blue: fleetColorBlue, alpha: 1), forState: .Normal)
        self.followButton.contentHorizontalAlignment = .Center
        self.followButton.titleLabel?.font = UIFont(name: quicksandReg, size: 25)
        self.followButton.addTarget(self, action: "followPressed:", forControlEvents: .TouchUpInside)
        
        var followFrame = self.followButton.frame
        followFrame.origin.x = self.hotButton.frame.width+self.newButton.frame.width
        self.followButton.frame = followFrame
        
        self.scrollView.addSubview(followButton)
        
        self.scrollView.contentSize = CGSizeMake(self.hotButton.frame.width+self.newButton.frame.width+self.followButton.frame.width, 60)
        
        self.view.addSubview(scrollView)
    }
    
    private func _addTableView()
    {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 122, width: self.view.frame.width, height: self.view.frame.height - 122))
        
        self.tableView.registerClass(VideosTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorColor = UIColor(white: 1, alpha: 0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
}