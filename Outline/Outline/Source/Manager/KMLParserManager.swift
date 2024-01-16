//
//  KMLParserManager.swift
//  Outline
//
//  Created by hyebin on 10/17/23.
//

import CoreLocation
import Foundation

class KMLParserManager: NSObject, XMLParserDelegate {
    private var coordinates: [CLLocationCoordinate2D] = []
    private var currentElement = ""
    private var currentCoordinates = ""
    
    func parseKMLFile(atPath path: String) -> [CLLocationCoordinate2D] {
        if let parser = XMLParser(contentsOf: URL(fileURLWithPath: path)) {
            parser.delegate = self
            parser.parse()
        }
        return coordinates
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if elementName == "coordinates" {
            currentCoordinates = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "coordinates" {
            currentCoordinates += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "coordinates" {
            let coordinateStrings = currentCoordinates.components(separatedBy: " ")
            for coordinateString in coordinateStrings {
                let components = coordinateString.components(separatedBy: ",")
                if components.count == 3, let longitude = Double(components[0]), let latitude = Double(components[1]) {
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    coordinates.append(coordinate)
                }
            }
        }
    }
}
