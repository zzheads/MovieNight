//
//  ViewResultsController.swift
//  MovieNight
//
//  Created by Alexey Papin on 13.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation
import UIKit

fileprivate let cellIdentifier = "cell\(String(describing: ViewResultsController.self))"

class ViewResultsController: UIViewController {
    
    let watchers: [Watcher]
    
    var results: [Result] = [] {
        didSet {
            if self.results.count >= 10 {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.navigationItem.title = "Best matches"
        self.navigationController?.toolbar.barStyle = .blackOpaque
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])        
        
        apiClient.fetchPages(resourceType: ResourceType.Movie(.TopRated(pages: 20)), resourceClass: MovieHead.self) { movieHeads in
            guard
                let sorted1 = movieHeads.sortByRating(weights: self.watchers[0].weights, genres: self.watchers[0].genres, actors: self.watchers[0].actors),
                let sorted2 = movieHeads.sortByRating(weights: self.watchers[1].weights, genres: self.watchers[1].genres, actors: self.watchers[1].actors)
                else {
                    print("Error, cant't sort!")
                    return
            }
            
            guard let bestMatches = self.findIntersectionBest(first: sorted1 as! [MovieHead], second: sorted2 as! [MovieHead], number: 10) else {
                return
            }

            self.apiClient.fetchResource(resource: ResourceType.Configuration, resourceClass: Configuration.self) { result in
                switch result {
                case .Success(let config):

                    for match in bestMatches {
                        let id = match.element.id
                        self.apiClient.fetchResource(resource: ResourceType.Movie(.Images(id: id)), resourceClass: Image.self) { result in
                            switch result {
                            case .Success(let image):
                                let result = Result(intersection: match, config: config, image: image)
                                self.results.append(result)
                                
                            case .Failure(let error):
                                print("\(error.localizedDescription)")
                                return
                            }
                        }
                    }
                    
                case .Failure(let error):
                    print("\(error.localizedDescription)")
                    return
                }
            }
            
        }
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
        for i in 0...number {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let movie = self.results[indexPath.row]
        let image = movie.image
        image.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(image)
        NSLayoutConstraint.activate([
            image.leftAnchor.constraint(equalTo: cell.leftAnchor),
            image.topAnchor.constraint(equalTo: cell.topAnchor),
            image.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {   // Default is 1 if not implemented
        return 1
    }
}

extension ViewResultsController: UITableViewDelegate {
    
    // Variable height support
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = self.results[indexPath.row].image.image else {
            return 0
        }
        return image.size.height
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    // Called after the user changes the selection.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.results[indexPath.row]
    }
        
}

