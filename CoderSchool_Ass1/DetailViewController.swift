//
//  DetailViewController.swift
//  CoderSchool_Ass1
//
//  Created by Pj on 10/11/16.
//  Copyright © 2016 Pj Nguyen. All rights reserved.
//

import UIKit
import AFNetworking
class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterDetail: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbOverview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var imgLanguage: UIImageView!
    @IBOutlet weak var imgVote: UIImageView!
    @IBOutlet weak var lbLanguage: UILabel!
    @IBOutlet weak var lbVote: UILabel!
    
    
    var overviewDetail:String!
    var urlDetail:String!
    var titleMovie: String!
    var releaseDateMovie: String!
    var language:String!
    var voteInfo:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        posterDetail.setImageWith(URL(string: urlDetail)!)
        lbTitle.text = titleMovie
        lbOverview.text = overviewDetail
        lbOverview.sizeToFit()
        releaseDate.text = releaseDateMovie
        imgLanguage.image = UIImage(named: "language")
        imgVote.image = UIImage(named: "vote")
        lbLanguage.text = language
        lbVote.text = String(voteInfo)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
