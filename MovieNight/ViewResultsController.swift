//
//  ViewResultsController.swift
//  MovieNight
//
//  Created by Alexey Papin on 13.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation
import UIKit

typealias Matcher = (element: MovieHead, inFirst: Int, inSecond: Int)
fileprivate let margin = CGFloat(12)

class ViewResultsController: UIViewController {
    
    let watchers: [Watcher]
    var moviesList: [MovieHead] = []
    var genresForBoth: [Genre] = []
    var actorsForBoth: [Actor] = []
    var results: [Matcher] = []
    var ratings: [(forFirst: Double, forSecond: Double)] = []
    
    lazy var backgroundView: UIView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg-iphone6.png"))
        image.translatesAutoresizingMaskIntoConstraints = false
        let view = UIView(frame: image.bounds)
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.leftAnchor.constraint(equalTo: view.leftAnchor),
            image.rightAnchor.constraint(equalTo: view.rightAnchor),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        return view
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.backgroundView = self.backgroundView
        return table
    }()
    
    lazy var progress: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.color = AppColors.LightBlue.color
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.isHidden = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    lazy var progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.progressTintColor = AppColors.Blue.color
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let apiClient = ResourceAPIClient()
    
    init(watchers: [Watcher]) {
        self.watchers = watchers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Best matches"
        self.navigationController?.toolbar.barStyle = .blackOpaque
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
        
        self.view.addSubview(self.progress)
        NSLayoutConstraint.activate([
            self.progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.progress.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        
        self.view.addSubview(self.progressBar)
        NSLayoutConstraint.activate([
            self.progressBar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin * 5),
            self.progressBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin * 5),
            self.progressBar.topAnchor.constraint(equalTo: self.progress.bottomAnchor, constant: margin)
            ])
        
        self.progress.startAnimating()
        
        for watcher in watchers {
            if let genres = watcher.genres {
                genresForBoth.append(contentsOf: genres)
            }
            if let actors = watcher.actors {
                actorsForBoth.append(contentsOf: actors)
            }
        }

        for i in 0..<self.genresForBoth.count {
            let genre = self.genresForBoth[i]
            self.apiClient.fetchPages(resourceType: ResourceType.Genre(.Movies(id: genre.id, pages: 10)), resourceClass: MovieHead.self) { movieHeads in
                self.moviesList.append(contentsOf: movieHeads)
                if (i == self.genresForBoth.count - 1) {
                    self.apiClient.fetchPages(resourceType: ResourceType.Discover(sort_by: nil, with_cast: self.actorsForBoth.stringWithIds, with_genres: nil, pages: 39), resourceClass: MovieHead.self) { movieHeads in
                        self.moviesList.append(contentsOf: movieHeads)
                        guard
                            let sorted1 = self.moviesList.sortByRating(for: self.watchers[0]),
                            let sorted2 = self.moviesList.sortByRating(for: self.watchers[1])
                            else {
                                print("Error, cant't sort!")
                                return
                        }
                        
                        if let matchers = self.findIntersectionBest(first: sorted1 as! [MovieHead], second: sorted2 as! [MovieHead], number: 20) {
                            self.results = matchers
                            for match in matchers {
                                let id = match.element.id
                                if let index = self.moviesList.index(where: { $0.id == id }) {
                                    guard
                                        let rating1 = self.moviesList.rating(for: self.watchers[0], index: index),
                                        let rating2 = self.moviesList.rating(for: self.watchers[0], index: index)
                                        else {
                                            self.ratings.append((forFirst: -1, forSecond: -1))
                                            break
                                    }
                                    let ratings = (forFirst: rating1, forSecond: rating2)
                                    self.ratings.append(ratings)
                                }
                            }
                        }
                        self.tableView.reloadData()
                        self.progress.stopAnimating()
                        self.progressBar.isHidden = true
                    }
                }
            }
        }
    }
        
    func setProgress(value: Float) {
        self.progressBar.setProgress(value, animated: true)
    }
}

extension ViewResultsController {
    
    func findIntersection(first: [MovieHead], second: [MovieHead]) -> [(element: MovieHead, inFirst: Int, inSecond: Int)]? {
        var result: [(element: MovieHead, inFirst: Int, inSecond: Int)] = []
        for i in 0..<first.count {
            let elem = first[i]
            if let indexInSecond = second.index(where: { $0.id == elem.id }) {
                result.append((element: elem, inFirst: i, inSecond: indexInSecond))
            }
        }
        if !result.isEmpty {
            return result
        }
        return nil
    }
    
    func findIntersectionBest(first: [MovieHead], second: [MovieHead], number: Int) -> [(element: MovieHead, inFirst: Int, inSecond: Int)]? {
        var result: [(element: MovieHead, inFirst: Int, inSecond: Int)] = []
        guard let intersection = findIntersection(first: first, second: second) else {
            return nil
        }
        let sorted = intersection.sorted(by: { ($0.inFirst + $0.inSecond) < ($1.inFirst + $1.inSecond) })
        let maxCount = number > sorted.count ? sorted.count : number
        for i in 0...maxCount {
            result.append(sorted[i])
        }
        return result
    }
}

extension ViewResultsController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell\(String(describing: ViewResultsController.self))\(indexPath)"
        
        guard let oldCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            let cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
            
            let matcher = self.results[indexPath.row]
            let ratings = self.ratings[indexPath.row]
            
            var image: UIImageView
            if (indexPath.row % 2 == 0) {
                image = UIImageView(image: #imageLiteral(resourceName: "blue.png"))
            } else {
                image = UIImageView(image: #imageLiteral(resourceName: "lightBlue.png"))
            }
            
            cell.contentView.addSubview(image)
            image.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                image.leftAnchor.constraint(equalTo: cell.leftAnchor),
                image.topAnchor.constraint(equalTo: cell.topAnchor),
                image.widthAnchor.constraint(equalToConstant: 80),
                image.heightAnchor.constraint(equalToConstant: 80)
                ])
            
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 11)
            label.text = "\(matcher.element.title) [\(matcher.inFirst) \(matcher.inSecond)]"
            label.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(label)
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: margin),
                label.bottomAnchor.constraint(equalTo: cell.centerYAnchor),
                label.rightAnchor.constraint(equalTo: cell.rightAnchor),
                label.heightAnchor.constraint(equalToConstant: 40)
                ])
            
            if let date = matcher.element.date {
                let year = NSCalendar.current.component(.year, from: date)
                let labelYear = UILabel()
                labelYear.textColor = .gray
                //labelYear.text = "\(year)"
                labelYear.font = UIFont.boldSystemFont(ofSize: 11)
                labelYear.text = String.init(format: "%.2f %.2f", ratings.forFirst, ratings.forSecond)
                labelYear.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(labelYear)
                NSLayoutConstraint.activate([
                    labelYear.leftAnchor.constraint(equalTo: image.rightAnchor, constant: margin),
                    labelYear.topAnchor.constraint(equalTo: cell.centerYAnchor),
                    labelYear.rightAnchor.constraint(equalTo: cell.rightAnchor),
                    labelYear.heightAnchor.constraint(equalToConstant: 40)
                    ])
            }
            return cell
        }
        return oldCell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {   // Default is 1 if not implemented
        return 1
    }
    
}

extension ViewResultsController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController(movieId: self.results[indexPath.row].element.id, watchers: self.watchers)
        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
        
}

