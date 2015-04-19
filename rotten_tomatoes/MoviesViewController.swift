//
//  MoviesViewController.swift
//  rotten_tomatoes
//
//  Created by Jayme Woogerd on 4/15/15.
//  Copyright (c) 2015 Jayme Woogerd. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!

    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    let refreshDelay: Double = 1  // number of seconds to delay on refresh
    var distribution_type = "movies/box_office"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize navigation bar
        var nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.blackColor()
        nav?.tintColor = UIColor.yellowColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellowColor()]

        networkErrorView.hidden = true
        SVProgressHUD.show()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        self.getMovies(self.distribution_type)

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMovies(type: String) {
        let apiKey = "dagqdghwaq3e3mxyrp7kmmj5"
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/" + type + ".json?apikey=" + apiKey)!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let data = data {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json = json {
                    self.movies = json["movies"] as? [NSDictionary]
                    self.networkErrorView.hidden = true
                    self.tableView.reloadData()
                }
            } else {
                self.networkErrorView.hidden = false
                self.networkErrorView.frame.origin.y = self.networkErrorView.frame.height
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(refreshDelay, closure: {
            self.getMovies(self.distribution_type)
            self.refreshControl.endRefreshing()
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        return cell
    }

    @IBAction func onBoxOfficeButtonPressed(sender: AnyObject) {
        self.distribution_type = "movies/box_office"
        self.getMovies(self.distribution_type)
    }

    @IBAction func onDVDsButtonPressed(sender: AnyObject) {
        self.distribution_type = "dvds/top_rentals"
        self.getMovies(self.distribution_type)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
    }

}
