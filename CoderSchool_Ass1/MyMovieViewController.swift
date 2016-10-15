//
//  MyMovieViewController.swift
//  CoderSchool_Ass1
//
//  Created by Pj on 10/11/16.
//  Copyright © 2016 Pj Nguyen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import ReachabilitySwift

class MyMovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var viewNetwork: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    
    
    
    @IBOutlet weak var lbErrorNetwork: UILabel!
    
    var movies = [NSDictionary]()
    var baseURL: String = "https://image.tmdb.org/t/p/w342"
    var endpoint:String = "now_playing"
    
    
    let reachability = Reachability()!

    var searchActive : Bool = false
    var filtered = [String]()
    
    var titleMovie: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        loadDataForTableView()
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        
    }
    
    @IBAction func segmentSwitch(_ sender: AnyObject) {
        switch segmentControll.selectedSegmentIndex {
        case 0:
            tableView.reloadData()
        case 1:
            tableView.reloadData()
        default:
            break
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        filtered = titleMovie.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                viewNetwork.isHidden = true
               // let refreshControl = UIRefreshControl()
                print("Reachable via WiFi")
                //refreshControlAction(refreshControl)
            } else {
                print("Reachable via Cellular")
            }
        } else {
            viewNetwork.isHidden = false
        }
    }
    
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let attrCollor = [NSForegroundColorAttributeName:UIColor.red]
        // set text refresh controll action
        refreshControl.attributedTitle = NSAttributedString(string: "refreshing movies", attributes: attrCollor)
        refreshControl.tintColor = UIColor.red
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        // Display HUD right before the request is made
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.label.text = "Loading Movies"
        
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        //print("response: \(responseDictionary)")
                                        self.movies = (responseDictionary["results"] as? [NSDictionary])!
                                        self.tableView.reloadData()
                                        
                                        // end refresh controll action when finish fetch data
                                        refreshControl.endRefreshing()
                                    }
                                }
                                MBProgressHUD.hide(for: self.view, animated: true)
            })
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadDataForTableView() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
            
            
            // Display HUD right before the request is made
        )
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.label.text = "Loading Movies"
        
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        //print("response: \(responseDictionary)")
                                        self.movies = (responseDictionary["results"] as? [NSDictionary])!
                                        self.tableView.reloadData()
                                        for movie in self.movies{
                                            let title = movie["title"]!
                                            self.titleMovie.append(title as! String)
                                            //print(self.titleMovie.count)
                                        }
                                    }
                                }
                                MBProgressHUD.hide(for: self.view, animated: true)
            })
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        if segmentControll.selectedSegmentIndex == 0 {
            return movies.count
        } else if segmentControll.selectedSegmentIndex == 1 {
            return movies.count / 2
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        let cellGrid = tableView.dequeueReusableCell(withIdentifier: "gridCell") as! GridMovieCell
        
        if(searchActive){
            print("dsadasdas")
            cell.lbTitle.text = filtered[indexPath.row]
            for movie in self.movies {
                let titleM = movie["title"]! as? String
                if (titleM == filtered[indexPath.row]){
                    let overviewM = movie["overview"]
                    cell.lbOverview.text = overviewM as! String?
                    
                    if let posterPath = movie["poster_path"]! as? String{
                        let posterUrl = URL(string: baseURL + posterPath)
                        cell.posterImg.setImageWith(posterUrl!)
                    }
                    
                }
                
                
            }
            
        } else {
            if(segmentControll.selectedSegmentIndex == 0){
                cell.lbTitle.text = movies[indexPath.row]["title"] as? String
                cell.lbOverview.text = movies[indexPath.row]["overview"] as? String
                
                if let posterPath =  movies[indexPath.row]["poster_path"] as? String {
                    let posterUrl = URL(string: baseURL + posterPath)
                    cell.posterImg.setImageWith(posterUrl!)
                    return cell
                }
            }
            else{
                let index = indexPath.row * 2
                if let posterPathLeft =  movies[index]["poster_path"] as? String,
                    let posterPathRight = movies[index + 1]["poster_path"] as? String {
                    let posterUrlLeft = URL(string: baseURL + posterPathLeft)
                    let posterUrlRight = URL(string: baseURL + posterPathRight)
                    
                    cellGrid.imgGridLeft.setImageWith(posterUrlLeft!)
                    
                    
                    cellGrid.imgGridRight.setImageWith(posterUrlRight!)
                    
                    return cellGrid
                }
                
            }
            //            cell.lbTitle.text = movies[indexPath.row]["title"] as? String
            //            cell.lbOverview.text = movies[indexPath.row]["overview"] as? String
            //
            //            if let posterPath =  movies[indexPath.row]["poster_path"] as? String {
            //                let posterUrl = URL(string: baseURL + posterPath)
            //                cell.posterImg.setImageWith(posterUrl!)
            //            }
        }
        
        
        //        cell.lbTitle.text = movies[indexPath.row]["title"] as? String
        //        cell.lbOverview.text = movies[indexPath.row]["overview"] as? String
        //
        //        if let posterPath =  movies[indexPath.row]["poster_path"] as? String {
        //            let posterUrl = URL(string: baseURL + posterPath)
        //            cell.posterImg.setImageWith(posterUrl!)
        //        }
        return cell
    }
    
    
    var movieShown = [Bool](repeating: false, count: 20)
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (movieShown[indexPath.row] == false) {
            cell.alpha = 0
            let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 10, 0)
            cell.layer.transform = transform
            
            UIView.animate(withDuration: 1.0) {
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            }
            movieShown[indexPath.row] = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let selectedRow = tableView.indexPathForSelectedRow?.row
            
            if (searchActive){
                
                if let des = segue.destination as? DetailViewController{
                    for movie in self.movies{
                        let titleM = movie["title"]! as? String
                        if( titleM == filtered[selectedRow!]){
                            des.titleMovie = titleM
                            
                            let overviewM = movie["overview"]! as? String
                            des.overviewDetail = overviewM
                            let posterPath = movie["poster_path"]! as? String
                            let posterUrl = baseURL + posterPath!
                            des.urlDetail = posterUrl
                            let releaseM = movie["release_date"]! as? String
                            des.releaseDateMovie = releaseM
                            let langM = movie["original_language"]! as? String
                            des.language = langM
                            let voteM = movie["vote_count"]! as? Int
                            des.voteInfo = voteM
                        }
                    }
                }
                
                
            }
            else{
                if let des = segue.destination as? DetailViewController{
                    des.overviewDetail = (movies[(selectedRow)!]["overview"] as? String)!
                    des.titleMovie = (movies[(selectedRow)!]["title"] as? String)!
                    des.releaseDateMovie = (movies[selectedRow!]["release_date"] as? String)!
                    des.language = (movies[selectedRow!]["original_language"] as? String)!
                    des.voteInfo = (movies[selectedRow!]["vote_count"] as? Int)!
                    if let posterPath = movies[selectedRow!]["poster_path"] as? String {
                        let posterUrl = baseURL + posterPath
                        des.urlDetail = posterUrl
                    }
                }
            }
            
            
        }
    }
    
    
    
}
