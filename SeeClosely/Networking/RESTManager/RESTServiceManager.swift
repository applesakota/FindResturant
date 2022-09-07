//
//  RESTServiceManager.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/9/22.
//

import Foundation


// Private class that will do all REST api requests for us and wrap functionality in single place.
final class RESTServiceManager: RESTService {

    var server: String { return AppEnvironment.triposoServer }
    var session: URLSession
    
    static let shared = RESTServiceManager(session: URLSession.shared)
    
    //MARK: - Init
    
    private init(session: URLSession) {
        self.session = session
    }
    
    
    //MARK: - Utils
    
    func createUrlRequst(url: URL, method: RESTManager.HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        
        //method
        request.httpMethod = method.rawValue
        
        //headers
        request.setValue(AppEnvironment.triposoAccount, forHTTPHeaderField: "X-Triposo-Account")
        request.setValue(AppEnvironment.triposoToken,   forHTTPHeaderField: "X-Triposo-Token")
        
        return request
    }
    
    //MARK: Execution
    
    ///Execute function will execute url request
    /// - Parameter callback: Callback function
    func execute<T>(request: URLRequest, _ callback: @escaping (RESTManager.ResponseResult<T>) -> Swift.Void) {
        session.dataTask(with: request) { data, response, error in
            
            //Error chech
            if let error = error {
                //Check for internet connection
                if let err = error as? URLError {
                    switch err.code {
                    case URLError.Code.notConnectedToInternet: fallthrough
                    case URLError.Code.networkConnectionLost: fallthrough
                    case URLError.Code.timedOut:
                        callback(RESTManager.ResponseResult(result: .failure(RESTManager.RESTError.network), rawData: data, statusCode: nil))
                    default:
                        callback(RESTManager.ResponseResult(result: .failure(RESTManager.RESTError.client(message: error.localizedDescription)), rawData: data, statusCode: nil))
                    }
                }
            } else if let response = response {
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                switch statusCode {
                case 1 ... 199:
                    callback(RESTManager.ResponseResult(result: .failure(RESTManager.RESTError.unknown), rawData: data, statusCode: statusCode))
                case 200 ... 299: // Success
                    
                    var object: T?
                    if statusCode != 204, data?.isEmpty == false {
                        object = T.decodeData(data)
                    }
                    callback(RESTManager.ResponseResult(result: .success(object), rawData: data, statusCode: statusCode))
                    
                    
                case 300 ... 399: // Redirection: Unexpected
                    
                    callback(RESTManager.ResponseResult(result: .failure(RESTManager.RESTError.unknown), rawData: data, statusCode: statusCode))
                    
                case 400 ... 499: // Client Error
                    // Token expires
                    
                    if statusCode == 401 {
                        callback(RESTManager.ResponseResult(result: .failure(RESTManager.RESTError.invalidData), rawData: data, statusCode: statusCode))
                    }
                    
                    callback(RESTManager.ResponseResult(result: .failure(RESTManager.RESTError.unknown), rawData: data, statusCode: statusCode))
                    
                default: // 500 or bigger, Server Error
                    callback(RESTManager.ResponseResult(result: .failure(RESTManager.RESTError.server), rawData: data, statusCode: statusCode))
                }
            } else {
                
                callback(RESTManager.ResponseResult(result: .failure(RESTManager.RESTError.unknown), rawData: data, statusCode: nil))
                
            }
        }.resume()
    }
    
    /// Set body to url request
    /// - Parameter body: NSDIctionary instance
    func setBody(request: inout URLRequest, body: NSDictionary) {
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
    }
    
    // MARK: - Public API
    
    /// AllTags api end point
    func executeGetAllTags(location: String, _ callback: @escaping (RESTManager.ResponseResult<TagResults>) -> Void) {
        let url = URL(string: "\(server)tag.json?location_id=\(location)&ancestor_label=cuisine&order_by=score&fields=name,poi_count,score,label")!
        let request = createUrlRequst(url: url, method: .get)
        execute(request: request, callback)
    }
    
    /// Execute all resturants
    func executeAllResturants(location: String, _ callback: @escaping (RESTManager.ResponseResult<ResturantResults>) -> Void) {
        let url = URL(string: "\(server)poi.json?location_id=\(location)&tag_labels=eatingout&count=10&fields=id,name,score,images,coordinates,intro,tag_labels,best_for&order_by=-score")!
        let request = createUrlRequst(url: url, method: .get)
        execute(request: request, callback)
    }
    
    /// Execute resturants by tag
    func executeAllResturantsByTag(location: String, for tag: String, _ callback: @escaping (RESTManager.ResponseResult<ResturantResults>) ->Swift.Void) {
        let url = URL(string: "\(server)poi.json?location_id=\(location)&tag_labels=\(tag)&count=10&fields=id,name,score,images,coordinates,intro,tag_labels,best_for&order_by=-score")!
        let request = createUrlRequst(url: url, method: .get)
        execute(request: request, callback)
    }

}
