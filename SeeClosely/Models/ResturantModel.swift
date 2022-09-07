//
//  ResturantModel.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/20/22.
//

import Foundation
import UIKit


struct ResturantResults: Codable {
    
    // MARK: - Globals
    
    let results: [ResturantModel]
    
    
    struct ResturantModel: Codable {
        
        let id: String
        let name: String
        let score: Double
        let intro: String
        let eatingScore: Double?
        let tagLabels: [String]?
        let longitude: Double?
        let latitude: Double?
        let mediumUrl: String?
        let originalUrl: String?
        let thumbnailUrl: String?
    
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case score
            case intro
            case coordinates
            case images
            case eatingScore = "eatingout_score"
            case tagLabels =   "tag_labels"
        }
                
        enum LocationCodingKeys: String, CodingKey {
            case longitude = "longitude"
            case latitude  = "latitude"
        }
        
        enum SizesCodingKeys: String, CodingKey {
            case sizes
        }
        
        enum ImagesCodingKeys: String, CodingKey {
            case medium
            case original
            case thumbnail
        }
        
        enum ImageUrlCodingKeys: String, CodingKey {
            case url
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let locationContainer = try? values.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .coordinates)
            var container = try? values.nestedUnkeyedContainer(forKey: .images)
            let sizesContainer = try? container?.nestedContainer(keyedBy: SizesCodingKeys.self)
            let imageContainer = try sizesContainer?.nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .sizes)
            let mediumImage = try? imageContainer?.nestedContainer(keyedBy: ImageUrlCodingKeys.self, forKey: .medium)
            let originalImage =  try? imageContainer?.nestedContainer(keyedBy: ImageUrlCodingKeys.self, forKey: .original)
            let thumbnailImage =  try? imageContainer?.nestedContainer(keyedBy: ImageUrlCodingKeys.self, forKey: .thumbnail)
            
            id            = try values.decode(String.self, forKey: .id)
            name          = try values.decode(String.self, forKey: .name)
            score         = try values.decode(Double.self, forKey: .score)
            intro         = try values.decode(String.self, forKey: .intro)
            eatingScore   = try values.decodeIfPresent(Double.self, forKey: .eatingScore)
            tagLabels     = try values.decodeIfPresent([String].self, forKey: .tagLabels)
            longitude     = try locationContainer?.decodeIfPresent(Double.self, forKey: .longitude)
            latitude      = try locationContainer?.decodeIfPresent(Double.self, forKey: .latitude)
            mediumUrl     = try mediumImage?.decodeIfPresent(String.self, forKey: .url)
            originalUrl   = try originalImage?.decodeIfPresent(String.self, forKey: .url)
            thumbnailUrl  = try thumbnailImage?.decodeIfPresent(String.self, forKey: .url)
    
        }
        
        func encode(to encoder: Encoder) throws {
            var values = encoder.container(keyedBy: CodingKeys.self)
            var locationContainer = try? values.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .coordinates)
            
        }
        
        var mediumImage: UIImage? {
            if let mediumUrl = mediumUrl {
                let url = URL(string: mediumUrl)!
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    return UIImage(data: imageData)
                } else {
                    return UIImage(named: "lunch")
                }
            }
            return UIImage(named: "lunch")
        }
        var originalImage: UIImage? {
            if let originalUrl = originalUrl {
                let url = URL(string: originalUrl)!
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    return UIImage(data: imageData)
                } else {
                    return UIImage(named: "lunch")
                }
            }
            return UIImage(named: "lunch")
        }
        
        
        var thumbnailImage: UIImage? {
            if let thumbnailUrl = thumbnailUrl {
                let url = URL(string: thumbnailUrl)!
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    return UIImage(data: imageData)
                } else {
                    return UIImage(named: "lunch")
                }
            }
            return UIImage(named: "lunch")
        }
        
        var formattedScore: String {
            return score.format(f: ".2")
        }
        
        var tagLabel: String {
            return tagLabels!.first ?? ""
        }
            
    }
}
