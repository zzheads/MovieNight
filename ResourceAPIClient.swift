//
//  MovieAPIClient.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

enum ResourceType: Endpoint {
    
    enum MovieRequests {
        case Details(id: Int)
        case Credits(id: Int)
        case Keywords(id: Int)
        case Images(id: Int)
        case Popular(pages: Int)
        case TopRated(pages: Int)
        case Upcoming(pages: Int)
        case NowPlaying(pages: Int)
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
        case Popular(pages: Int)
    }
    enum SearchRequests {
        case Companies(query: String, pages: Int)
        case Collections(query: String, pages: Int)
        case Keywords(query: String, pages: Int)
        case Movies(query: String, pages: Int)
        case MultiSearch(query: String, pages: Int)
        case People(query: String, pages: Int)
        case TVShows(query: String, pages: Int)
        
        var query: String {
            switch self {
            case .Collections(let query,_), .Companies(let query,_), .Keywords(let query,_), .Movies(let query,_), .MultiSearch(let query,_), .People(let query,_), .TVShows(let query,_): return query
            }
        }
    }
    enum GenreRequests {
        case MovieList
        case TVList
        case Movies(id: Int, pages: Int)
    }
    
    case Movie(MovieRequests)
    case Collection(CollectionRequests)
    case Person(PersonRequests)
    case Configuration
    case Timezones
    case Jobs
    case Search(SearchRequests)
    case Genre(GenreRequests)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        var path: String
        
        switch self {
        case .Movie(let req):
            switch req {
            case .Details(let id): path = "movie/\(id)"
            case .Credits(let id): path = "movie/\(id)/credits"
            case .Keywords(let id): path = "movie/\(id)/keywords"
            case .Images(let id): path = "movie/\(id)/images"
            case .NowPlaying(_): path = "movie/now_playing"
            case .Popular(_): path = "movie/popular"
            case .TopRated(_): path = "movie/top_rated"
            case .Upcoming(_): path = "movie/upcoming"
            }
        case .Collection(let req):
            switch req {
            case .Details(let id): path = "collection/\(id)"
            case .Images(let id): path = "collection/\(id)/images"
            }
        case .Person(let req):
            switch req {
            case .Details(let id): path = "person/\(id)"
            case .MovieCredits(let id): path = "person/\(id)/movie_credits"
            case .TVCredits(let id): path = "person/\(id)/tv_credits"
            case .CombainedCredits(let id): path = "person/\(id)/combained_credits"
            case .Images(let id): path = "person/\(id)/images"
            case .Popular(_): path = "person/popular"
            }
        case .Configuration: path = "configuration"
        case .Timezones: path = "timezones/list"
        case .Jobs: path = "job/list"
        case .Search(let req):
            switch req {
            case .Collections(_): path = "search/collection"
            case .Companies(_): path = "search/company"
            case .Keywords(_): path = "search/keyword"
            case .Movies(_): path = "search/movie"
            case .MultiSearch(_): path = "search/multi"
            case .People(_): path = "search/person"
            case .TVShows(_): path = "search/tv"
            }
        case .Genre(let req):
            switch req {
            case .MovieList: path = "genre/movie/list"
            case .TVList: path = "genre/tv/list"
            case .Movies(let id): path = "genre/\(id)/movies"
            }
        }
        
        if let key = keyAdd {
            path += "?api_key=\(key)"
        }
        if let query = queryAdd {
            path += "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        }
        if let page = pageAdd {
            path += "&page=\(page)"
        }
        if let lang = langAdd {
            path += "&language=\(lang)"
        }
        return path
    }
    
    var keyAdd: String? {
        return "c2bdc0def5bdb6efb985dfe31785e312"
    }
    
    var langAdd: String? {
        switch self {
        case .Movie(let movieRequest):
            switch movieRequest {
            case .Images(_): return nil
            default: break
            }
        default: break
        }
        return "en-US"
    }

    var queryAdd: String? {
        switch self {
        case .Search(let searchReq):
            switch searchReq {
            case .Collections(let query,_), .Companies(let query,_), .Keywords(let query,_), .Movies(let query,_), .MultiSearch(let query,_), .People(let query,_), .TVShows(let query,_): return query
            }
        default: return nil
        }
    }
    
    var pageAdd: Int? {
        switch self {
        case .Search(let searchReq):
            switch searchReq {
            case .Collections(_,let page), .Companies(_,let page), .Keywords(_,let page), .Movies(_,let page), .MultiSearch(_,let page), .People(_,let page), .TVShows(_,let page): return page
            }
        case .Movie(let movieReq):
            switch movieReq {
            case .NowPlaying(let page), .Popular(let page), .TopRated(let page), .Upcoming(let page): return page
            default: return nil
            }
        case .Genre(let genreReq):
            switch genreReq {
            case .Movies(_, let page): return page
            default: return nil
            }
        case .Person(.Popular(let page)): return page
        default: return nil
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        let request = URLRequest(url: url)
        return request
    }
    
    var pages: Int? {
        switch self {
        case .Search(.Movies(_, let pages)): return pages
        case .Search(.People(_, let pages)): return pages
        case .Search(.Collections(_, let pages)): return pages
        case .Search(.Companies(_, let pages)): return pages
        case .Search(.Keywords(_, let pages)): return pages
        case .Search(.TVShows(_, let pages)): return pages
            
        case .Movie(.NowPlaying(let pages)): return pages
        case .Movie(.Popular(let pages)): return pages
        case .Movie(.Upcoming(let pages)): return pages
        case .Movie(.TopRated(let pages)): return pages
            
        case .Genre(.Movies(_, let pages)): return pages
            
        case .Person(.Popular(let pages)): return pages
            
        default: return nil
        }
    }
}

extension ResourceType: CustomStringConvertible {
    var description: String {
        switch self {
        case .Collection(_): return "Collection"
        case .Configuration: return "Configuration"
        case .Genre(_): return "Genre"
        case .Jobs: return "Jobs"
        case .Movie(.Details(_)): return "Details of movie"
        case .Movie(.Credits(_)): return "Credits of movie"
        case .Movie(.Images(_)): return "Images of movie"
        case .Movie(.NowPlaying(_)): return "NowPlaying movies"
        case .Movie(.Popular(_)): return "Popular movies"
        case .Movie(.TopRated(_)): return "TopRated movies"
        case .Movie(.Upcoming(_)): return "Upcoming movies"
        case .Person(_): return "Person"
        case .Search(_): return "Search"
        case .Timezones: return "Timezones"
        default: return "Unknown: \(self)"
        }
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
    
    func fetchResource<T>(resource: ResourceType, resourceClass: T.Type, completion: @escaping (APIResult<T>) -> Void) where T: JSONDecodable {
        let request = resource.request
        //print("Request: \(request)")
        fetch(request: request, parse: { json -> T? in
            let value = T(JSON: json)
            //print("Parsed to \(T.self): \(value)")
            return value
        }, completion: completion)
    }    
    
    func fetchArrayOfResources<T>(resource: ResourceType, resourceClass: T.Type, completion: @escaping (APIResultArray<T>) -> Void) where T: JSONDecodable {
        let request = resource.request
        //print("Request: \(request)")
        fetchArray(request: request, parse: { json -> T? in
        let value = T(JSON: json)
        //print("Parsed to \(T.self): \(value)")
        return value
        }, completion: completion)
    }
    
    func fetchPages<T>(resourceType: ResourceType, resourceClass: T.Type, completion: @escaping ([T]) -> Void) where T: JSONDecodable {
        let apiClient = ResourceAPIClient()
        var pageNumber = 1
        var results: [T] = []
        var maxPages = 999
        if let pages = resourceType.pages {
            maxPages = pages
        }
        
        func listPage(completion: @escaping ([T]) -> Void) {
            var resourceTypeWithPage: ResourceType = .Search(.Movies(query: "", pages: 0))
            
            switch resourceType {
            case .Search(.Movies(let query, _)): resourceTypeWithPage = .Search(.Movies(query: query, pages: pageNumber))
            case .Search(.People(let query, _)): resourceTypeWithPage = .Search(.People(query: query, pages: pageNumber))
            case .Search(.Collections(let query, _)): resourceTypeWithPage = .Search(.Collections(query: query, pages: pageNumber))
            case .Search(.Companies(let query, _)): resourceTypeWithPage = .Search(.Companies(query: query, pages: pageNumber))
            case .Search(.Keywords(let query, _)): resourceTypeWithPage = .Search(.Keywords(query: query, pages: pageNumber))
            case .Search(.TVShows(let query, _)): resourceTypeWithPage = .Search(.TVShows(query: query, pages: pageNumber))
                
            case .Movie(.NowPlaying(_)): resourceTypeWithPage = .Movie(.NowPlaying(pages: pageNumber))
            case .Movie(.Popular(_)): resourceTypeWithPage = .Movie(.Popular(pages: pageNumber))
            case .Movie(.Upcoming(_)): resourceTypeWithPage = .Movie(.Upcoming(pages: pageNumber))
            case .Movie(.TopRated(_)): resourceTypeWithPage = .Movie(.TopRated(pages: pageNumber))
                
            case .Genre(.Movies(let id, _)): resourceTypeWithPage = .Genre(.Movies(id: id, pages: pageNumber))
                
            case .Person(.Popular(_)): resourceTypeWithPage = .Person(.Popular(pages: pageNumber))
                
            default: break
            }

            fetchResource(resource: resourceTypeWithPage, resourceClass: Page.self) { result in
                switch result {
                case .Success(let resourcePage):
                    for jsonElement in resourcePage.results {
                        if let element = T(JSON: jsonElement) {
                            results.append(element)
                        } else {
                        }
                    }
                    print("Fetching \(pageNumber) of \(resourceTypeWithPage) page...")
                    let pagesMax = resourcePage.total_pages > maxPages ? maxPages : resourcePage.total_pages
                    if pageNumber < pagesMax {
                        pageNumber += 1
                        listPage(completion: completion)
                    } else {
                        completion(results)
                        return
                    }
                
                case .Failure(let error as NSError):
                    switch error.code {
                    case HTTPStatusCodeError.TooManyRequests.rawValue:
                        print("Too many requests, will sleep 1 second...")
                        sleep(1)
                        listPage(completion: completion)
                        
                    default:
                        print("fetchPages can't handle error: \(error.localizedDescription)")
                    }
                    
                default: break
                }
            }
        }
        
        listPage(completion: completion)
    }
}
