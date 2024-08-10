//
//  CoordinateExtension.swift
//  Outline
//
//  Created by Hyunjun Kim on 1/23/24.
//

import CoreLocation

extension Coordinate {
    // Coordinate to CLLocationCoordinate2D
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(from clLocationCoordinate: CLLocationCoordinate2D) {
        self.init(longitude: clLocationCoordinate.longitude, latitude: clLocationCoordinate.latitude)
    }
}

extension CLLocationCoordinate2D {
    // CLLocationCoordinate2D to Coordinate
    func toCoordinate() -> Coordinate {
        return Coordinate(longitude: longitude, latitude: latitude)
    }

    init(from coordinate: Coordinate) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocation {
    convenience init(from clLocationCoordinate: CLLocationCoordinate2D) {
        self.init(latitude: clLocationCoordinate.latitude, longitude: clLocationCoordinate.longitude)
    }
}
