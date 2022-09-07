//
//  RESTManager.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 5/27/22.
//

import Foundation

///Common Manager Class
///Contains all comon REST api end points
class RESTManager {
    
    //MARK: - Globals
    
    let service: RESTService
    let storage: LocalStorage
    let locale: String
    
    static let shared = RESTManager(service: RESTServiceManager.shared, storage: LocalStorage.standard, locale: "en")
        
    /// List of all possible http methods we use
    enum HTTPMethod: String {
        case get    = "GET"
        case post   = "POST"
        case put    = "PUT"
        case delete = "DELETE"
    }
    
    
    /// `ResponseResult`  is a wrapper object that should be used with all api requests to get data from the server side.
    struct ResponseResult<T: Decodable> {
        let result: Result<T?, RESTError>
        let rawData: Data?
        let statusCode: Int?
    }
    
    /// `AnyResult` can be used when we want to skip decoding server returned data
    struct AnyResult: Decodable { /* We don't care about data */ }
    
    /// `FailableResult` can be used if we want to execute failable decoding. If used with array of random elements we can ignore some of them instead of ignoring whole array.
    struct FailableResult<T: Decodable>: Decodable {
        let result: Result<T?, RESTError>
        
        init(from decoder: Decoder) throws {
            let decoderResult = Result(catching: { try T(from: decoder) })
            switch decoderResult {
            case .success(let success):
                self.result = .success(success)
            case .failure(let failure):
                self.result = .failure(failure.asAuthError)
            }
        }
    }
    
    enum RESTError: Error, Equatable, LocalizedError {
        case network
        case server
        case client(message: String)
        case invalidData
        case unknown
        
        
        public var errorDescription: String? {
            switch self {
            case .network:             return "Network Error"
            case .server:              return "Server Error"
            case .client(let message): return message
            case .invalidData:         return "Invalid Data Error"
            case .unknown:             return "Something Went Wrong"
            }
        }
    }
    
    //MARK: - Constructor
    
     init(service: RESTService, storage: LocalStorage, locale: String) {
        self.service = service
        self.storage = storage
        self.locale = locale
    }
    
    // MARK: - Public API
    
    // Network calls
    
    /// Get all tags
    func getAllTags(location: String, callback: @escaping (Result<([TagModel]), RESTError>)->Swift.Void) {
        service.executeGetAllTags(location: location) { result in
            switch result.result {
            case .success(let model):
                if let model = model {
                    callback(.success(model.results))
                } else {
                    callback(.failure(RESTError.invalidData))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
        
    }
    
    /// Get all resturants
    func getAllResturants(location: String, callback: @escaping (Result<([ResturantResults.ResturantModel]), RESTError>)->Swift.Void) {
        service.executeAllResturants(location: location) { result in
            switch result.result {
            case .success(let model):
                if let model = model {
                    callback(.success(model.results))
                } else {
                    callback(.failure(RESTError.invalidData))
                }
            case .failure(let error): callback(.failure(error))
            }
        }
    }
    
    /// Get all resturants by tag
    func getAllResturansByTag(location: String, for tag: String, callback: @escaping (Result<([ResturantResults.ResturantModel]), RESTError>)->Swift.Void) {
        service.executeAllResturantsByTag(location: location, for: tag) { result in
            switch result.result {
            case .success(let model):
                if let model = model {
                    callback(.success(model.results ))
                } else {
                    callback(.failure(RESTError.invalidData))
                }
            case .failure(let error): callback(.failure(error))
            }
        }
    }
}


extension Error {
    
    var asAuthError: RESTManager.RESTError {
        if let error = self as? RESTManager.RESTError {
            return error
        }
        return .unknown
    }
    
}
