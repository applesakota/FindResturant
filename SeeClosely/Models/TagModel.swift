//
//  TagModel.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/10/22.
//

import Foundation

struct TagResults: Codable {
    
    let results: [TagModel]
    
    //MARK: - Globals
    init(results: [TagModel]) {
        self.results = results
    }
}

struct TagModel: Codable {
    
    let name: String
    let label: String
    let score: Double
    let poiCount: Int?
    //MARK: - Constructor
    
    init(name: String, label: String, score: Double, poiCount: Int? = nil) {
        self.name = name
        self.label = label
        self.score = score
        self.poiCount = poiCount
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case label = "label"
        case score = "score"
        case poiCount = "poi_count"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        //Required
        name  = try values.decode(String.self, forKey: .name)
        label = try values.decode(String.self, forKey: .label)
        score = try values.decode(Double.self, forKey: .score)
        
        // Optional
        poiCount = try values.decodeIfPresent(Int.self, forKey: .poiCount)
    }
}
