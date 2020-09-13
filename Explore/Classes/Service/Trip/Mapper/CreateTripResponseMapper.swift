//
//  CreateTripResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class CreateTripResponseMapper {
    static func map(response: Any, toCoordinate: Coordinate) -> Trip? {
        guard let model = CreateTripResponse.parseFromDictionary(any: response) else {
            return nil
        }
        
        return Trip(id: model.id,
                    toCoordinate: toCoordinate)
    }
}

// TODO: Apply realy mapper for response when API will done
private struct CreateTripResponse: Model {
    let id: Int
    
    enum Keys: String, CodingKey {
        case data = "_data"
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
    }
}
