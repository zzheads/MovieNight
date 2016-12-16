//
//  SelectGenresViewController.swift
//  MovieNight
//
//  Created by Alexey Papin on 12.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation
import UIKit

fileprivate let cellIdentifier = "cell\(String(describing: SelectGenresViewController.self))"

class SelectGenresViewController: UIViewController {
    let delegateModifyPrefs: (Weights?, [Genre]?, [Actor]?) -> Void

    var genres: [Genre] = []
    var selectedGenres: [Genre] = [] {
        didSet {
            self.footerForTableView.text = titleForFooter
        }
    }

    var titleForFooter: String {
        return "Selected \(self.selectedGenres.count) of \(self.genres.count)"
    }
    
    lazy var footerForTableView: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: (self.navigationController?.navigationBar.bounds.size.height)!))
        label.backgroundColor = AppColors.Bordo.color
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = self.titleForFooter
        label.textAlignment = .center
        return label
    }()
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg-iphone6.png"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundView = self.backgroundImage
        table.allowsMultipleSelection = true
        table.allowsSelection = true
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    lazy var doneBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(sender:)))
        return button
    }()    
    
    let apiClient = ResourceAPIClient()
    
    init(delegate: @escaping (Weights?, [Genre]?, [Actor]?) -> Void) {
        self.delegateModifyPrefs = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.navigationItem.title = "Select genres"
        self.navigationController?.toolbar.barStyle = .blackOpaque
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        self.view.addSubview(self.backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundImage.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])

        apiClient.fetchResource(resource: ResourceType.Genre(.MovieList), resourceClass: Genres.self) { result in
            switch result {
            case .Success(let genres):
                for genre in genres.genres {
                    self.genres.append(genre)
                }
                self.tableView.reloadData()
                
            case .Failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func donePressed(sender: UIBarButtonItem) {
        self.delegateModifyPrefs(nil, self.selectedGenres, nil)
        
        let selectActorsController = SelectActorsViewController(delegate: self.delegateModifyPrefs)
        self.navigationController?.pushViewController(selectActorsController, animated: true)
    }
}

extension SelectGenresViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if self.genres.isEmpty {
            return cell
        }

        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        if cell.isSelected {
            cell.check()
        } else {
            cell.uncheck()
        }
        cell.textLabel?.text = self.genres[indexPath.row].name
    
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {   // Default is 1 if not implemented
        return 1
    }
    
}

extension SelectGenresViewController: UITableViewDelegate {

    // Variable height support
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (navigationController?.navigationBar.bounds.size.height)!
    }
 
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {   // custom view for footer. will be adjusted to default or specified footer height
        return self.footerForTableView
    }
    
    // Called after the user changes the selection.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.check()
        let genre = self.genres[indexPath.row]
        if !self.selectedGenres.contains(where: { $0.id == genre.id }) {
            self.selectedGenres.append(genre)
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.uncheck()
        let genre = self.genres[indexPath.row]
        self.selectedGenres.remove(at: selectedGenres.index(where: { $0.id == genre.id })!)
    }
    
}

extension UITableViewCell {
    func check() {
        self.imageView?.image = #imageLiteral(resourceName: "checked.png")
    }
    
    func uncheck() {
        self.imageView?.image = #imageLiteral(resourceName: "unchecked.png")
    }
}






