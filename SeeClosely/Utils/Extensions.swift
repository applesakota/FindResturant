//
//  Extensions.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/9/22.
//

import Foundation
import UIKit


//MARK: - Encodable
extension Encodable {
    
    /// Function will encode specific object into JSON data format if possible.
    /// - Parameter object: Encodable object that will be encoded into JSON data.
    /// - Returns : JSON data representation of encodable object
    static func encodeObject<T: Encodable>(_ object: T?) -> Data? {
        var data: Data? = nil
        if let object = object {
            do {
                data = try JSONEncoder().encode(object)
                print("Encoding \(type(of: T.self)) completed seccessfully!")
            } catch EncodingError.invalidValue(let key, let context) {
                print("Encoding invalidValue: \(key) -> \(context.debugDescription)")
            } catch {
                print("Encoding unknown \(error.localizedDescription)")
            }
        }
        return data
    }
    
    
}

//MARK: - Decodable
extension Decodable {
    
    /// Function will decode JSON data into specific object if possible
    /// - Parameter object: JSON data representation of decodable object.
    /// - Returns: Decodable object that was decoded from JSON data.
    static func decodeData<T: Decodable>(_ data: Data?) -> T? {
        var object: T? = nil
        if let data = data {
            do {
                object = try JSONDecoder().decode(T.self, from: data)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("⬅️ Decoding keyNotFound: \(key) -> \(context.debugDescription)")
                
            } catch DecodingError.typeMismatch(_, let context) {
                print("⬅️ Decoding typeMismatch: \(context.codingPath) -> \(context.debugDescription)")
                
            } catch DecodingError.valueNotFound(_, let context) {
                print("⬅️ Decoding valueNotFound: \(context.codingPath) -> \(context.debugDescription)")
                
            } catch DecodingError.dataCorrupted(let context) {
                print("⬅️ Decoding dataCorrupted: \(context.codingPath) -> \(context.debugDescription)")
                
            } catch {
                print("⬅️ Decoding unknown: \(error.localizedDescription)")
            }
        }
        return object
    }
}

extension Data {
    
    /// Function will convert data to NSDictionary
    /// - Returns: NSDictionary
    func toDictionary() -> NSDictionary? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? NSDictionary
        } catch let error as NSError {
            print("Failed to serilize \(error)")
            return nil
        }
    }
     
    func toDictionaries() -> [NSDictionary]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [NSDictionary]
            
        } catch let error as NSError {
            print("Failed to seriliize \(error)")
            return nil
        }
    }
}


//MARK: - DOUBLE

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

//MARK: - UIStoryBoard

extension UIStoryboard {
    
    /// Returns instance of main storyboard
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    /// Instantiate view controller from storyboard
    ///  - Parameter identifier: Unique view controller identifier from storyboard
    func instantiate<T: UIViewController>(_ identifier: String) -> T {
        return self.instantiateViewController(withIdentifier: identifier) as! T
    }
    
}


//MARK: - UITableViewCell

extension UITableViewCell {
    
    static var emptyCell: UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Empty cell"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        return cell
    }
    
}
