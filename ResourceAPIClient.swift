//
//  MovieAPIClient.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

enum ResourceType: Endpoint {
    
    static let API_KEY = "c2bdc0def5bdb6efb985dfe31785e312"
    
    enum MovieRequests {
        case Details(id: Int)
        case Credits(id: Int)
        case Keywords(id: Int)
        case Images(id: Int)
    }
    enum CollectionRequests {
        case Details(id: Int)
        case Images(id: Int)
    }
    enum PersonRequests {
        case Details(id: Int)
        case MovieCredits(id: Int)
        case TVCredits(id: Int)
        case CombainedCredits(id: Int)
        case Images(id: Int)
    }
    
    case Movie(MovieRequests)
    case Collection(CollectionRequests)
    case Person(PersonRequests)
    case Configuration
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .Movie(let req):
            switch req {
            case .Details(let id): return "movie/\(id)?api_key=\(ResourceType.API_KEY)"
            case .Credits(let id): return "movie/\(id)/credits?api_key=\(ResourceType.API_KEY)"
            case .Keywords(let id): return "movie/\(id)/keywords?api_key=\(ResourceType.API_KEY)"
            case .Images(let id): return "movie/\(id)/images?api_key=\(ResourceType.API_KEY)"
            }
        case .Collection(let req):
            switch req {
            case .Details(let id): return "collection/\(id)?api_key=\(ResourceType.API_KEY)"
            case .Images(let id): return "collection/\(id)/images?api_key=\(ResourceType.API_KEY)"
            }
        case .Person(let req):
            switch req {
            case .Details(let id): return "person/\(id)?api_key=\(ResourceType.API_KEY)"
            case .MovieCredits(let id): return "person/\(id)/movie_credits?api_key=\(ResourceType.API_KEY)"
            case .TVCredits(let id): return "person/\(id)/tv_credits?api_key=\(ResourceType.API_KEY)"
            case .CombainedCredits(let id): return "person/\(id)/combained_credits?api_key=\(ResourceType.API_KEY)"
            case .Images(let id): return "person/\(id)/images?api_key=\(ResourceType.API_KEY)"
            }
        case .Configuration: return "configuration?api_key=\(ResourceType.API_KEY)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        let request = URLRequest(url: url)
        return request
    }

}

final class ResourceAPIClient: APIClient {
    
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(config: URLSessionConfiguration) {
        self.configuration = config
    }
    
    convenience init() {
        self.init(config: .default)
    }
    
    func fetchResource<T>(resource: ResourceType, class: T.Type, completion: @escaping (APIResult<T>) -> Void) where T: JSONDecodable {
        let request = resource.request
        //print("Request: \(request)")
        fetch(request: request, parse: { json -> T? in
            let value = T(JSON: json)
            //print("Parsed to \(T.self): \(value)")
            return value
        }, completion: completion)
    }
}
