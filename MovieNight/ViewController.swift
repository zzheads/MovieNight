//
//  ViewController.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiClient = ResourceAPIClient()
//        apiClient.fetchResource(resource: ResourceType.Movie(.Details(id: 100)), class: Movie.self) { result in
//            switch result {
//            case .Success(let movie):
//                apiClient.fetchResource(resource: ResourceType.Movie(.Credits(id: 100)), class: Credits.self) { result in
//                    switch result {
//                    case .Success(let credits):
//                        print("\(movie)")
//                        print("Credits: \(credits)")
//                    case .Failure(let error):
//                        print("\(error.localizedDescription)")
//                    }
//                }
//                
//                    
//            case .Failure(let error):
//                print("\(error.localizedDescription)")
//            }
//        }
        apiClient.fetchResource(resource: ResourceType.Configuration, class: Configuration.self) { result in
            switch result {
            case .Success(let config):
                print("\(config)")
            case .Failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }

}

