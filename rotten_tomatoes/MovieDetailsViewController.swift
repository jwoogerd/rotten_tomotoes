//
//  MovieDetailsViewController.swift
//  rotten_tomatoes
//
//  Created by Jayme Woogerd on 4/16/15.
//  Copyright (c) 2015 Jayme Woogerd. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String

        var url_string = movie.valueForKeyPath("posters.thumbnail") as! String
        let range = url_string.rangeOfString(".*cloudfront.net/",
            options: .RegularExpressionSearch)
        
        if let range = range {
            url_string = url_string.stringByReplacingCharactersInRange(range,
                withString: "https://content6.flixster.com/")
           }
       
        let url = NSURL(string: url_string)!
        posterImageView.setImageWithURL(url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
