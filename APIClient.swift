//
//  APIClient.swift
//  The API Awakens
//
//  Created by Alexey Papin on 02.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

public let ZZHNetworkingErrorDomain = "com.zzheads.MovieNight.NetworkingError"
public let MissingHTTPResponseError: Int = 10

typealias JSON = [String: AnyObject]
typealias JSONArray = [AnyObject]
typealias JSONTaskCompletion = (JSON?, HTTPURLResponse?, Error?) -> Void
typealias JSONArrayTaskCompletion = (JSONArray?, HTTPURLResponse?, Error?) -> Void
typealias JSONTask = URLSessionDataTask


enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

enum APIResultArray<T> {
    case Success([T])
    case Failure(Error)
}

protocol JSONDecodable {
    init?(JSON: JSON)
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

protocol APIClient {
    var configuration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWithRequest(request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (APIResult<T>) -> Void)
}

extension APIClient {
    
    func JSONTaskWithRequest(request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask {
        let task = session.dataTask(with: request) { data, response, error in
//            print("Request in JSONTask: \(request)")
//            print("Data in JSONTask: \(data)")
//            print("Response in JSONTask: \(response)")
//            print("Error in JSONTask: \(error)")
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: ZZHNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    completion(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        completion(json, HTTPResponse, nil)
                    } catch let error {
                        completion(nil, HTTPResponse, error)
                    }
                    
                default:
                    if let errorCode = HTTPStatusCodeError(rawValue: HTTPResponse.statusCode) {
                        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(errorCode.description, comment: "")]
                        let error = NSError(domain: ZZHNetworkingErrorDomain, code: errorCode.rawValue, userInfo: userInfo)
                        completion(nil, HTTPResponse, error)
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(HTTPStatusCodeError.UnknownHTTPStatusCode.description, comment: "")]
                        let error = NSError(domain: ZZHNetworkingErrorDomain, code: HTTPStatusCodeError.UnknownHTTPStatusCode.rawValue, userInfo: userInfo)
                        completion(nil, HTTPResponse, error)
                    }
                    return
                    
                }
            }
        }
        return task
    }

    func JSONArrayTaskWithRequest(request: URLRequest, completion: @escaping JSONArrayTaskCompletion) -> JSONTask {
        let task = session.dataTask(with: request) { data, response, error in
            //print("Request in JSONTask: \(request)")
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: ZZHNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    completion(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject]
                        completion(json, HTTPResponse, nil)
                    } catch let error {
                        completion(nil, HTTPResponse, error)
                    }
                default:
                    if let errorCode = HTTPStatusCodeError(rawValue: HTTPResponse.statusCode) {
                        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(errorCode.description, comment: "")]
                        let error = NSError(domain: ZZHNetworkingErrorDomain, code: errorCode.rawValue, userInfo: userInfo)
                        completion(nil, HTTPResponse, error)
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(HTTPStatusCodeError.UnknownHTTPStatusCode.description, comment: "")]
                        let error = NSError(domain: ZZHNetworkingErrorDomain, code: HTTPStatusCodeError.UnknownHTTPStatusCode.rawValue, userInfo: userInfo)
                        completion(nil, HTTPResponse, error)
                    }
                    return
                }
            }
        }
        return task
    }

    
    func fetch<T>(request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWithRequest(request: request) { json, response, error in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(.Failure(error))
                    } else {
                        completion(.Failure(HTTPStatusCodeError.UnknownHTTPStatusCode))
                    }
                    return
                }
                if let value = parse(json) {
                    completion(.Success(value))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(HTTPStatusCodeError.UnknownHTTPStatusCode.description, comment: "")]
                    let error = NSError(domain: ZZHNetworkingErrorDomain, code: HTTPStatusCodeError.UnknownHTTPStatusCode.rawValue, userInfo: userInfo)
                    completion(.Failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchArray<T>(request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (APIResultArray<T>) -> Void) {
        let task = JSONArrayTaskWithRequest(request: request) { json, response, error in
            
            DispatchQueue.main.async {
                guard let jsonArray = json as? [JSON] else {
                    if let error = error {
                        completion(.Failure(error))
                    } else {
                        completion(.Failure(HTTPStatusCodeError.UnknownHTTPStatusCode))
                    }
                    return
                }
                var valuesArray: [T] = []
                for jsonElement in jsonArray {
                    if let value = parse(jsonElement) {
                        valuesArray.append(value)
                    }
                }
                if (!valuesArray.isEmpty) {
                    completion(.Success(valuesArray))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(HTTPStatusCodeError.UnknownHTTPStatusCode.description, comment: "")]
                    let error = NSError(domain: ZZHNetworkingErrorDomain, code: HTTPStatusCodeError.UnknownHTTPStatusCode.rawValue, userInfo: userInfo)
                    completion(.Failure(error))
                }
            }
        }
        task.resume()
    }

    
}
