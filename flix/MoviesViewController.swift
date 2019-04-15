//
//  MoviesViewController.swift
//  flix
//
//  Created by MRC on 4/8/19.
//  Copyright © 2019 tshridha@uci.edu. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate { // Added the last 2 import things (necessary)



    @IBOutlet weak var tableView: UITableView!
    

    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self // necessary
        tableView.delegate = self // necessary
        print("Hello")

        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                self.movies = dataDictionary["results"] as! [[String:Any]]

                // right here, we want to update the tableview every time
                self.tableView.reloadData() // this calls tableView functions...

                print(dataDictionary)
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data

            }
        }
        task.resume()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count // return number of rows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell

        let movie = movies[indexPath.row]
        let title = movie["title"] as! String // cast as a string... this is necessary
        let synopsis = movie["overview"] as! String


        cell.synopsisLabel.text = synopsis
        cell.titleLabel?.text = title

        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        // iOS has no default way of downloading imgs... cocoapods
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
        // for this particular row, gimme the cell --> is what it is saying
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
