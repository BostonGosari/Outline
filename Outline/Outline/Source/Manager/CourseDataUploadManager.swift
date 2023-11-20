//
//  CourseDataUploadManager.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import CoreLocation
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct CourseDataUploadView: View {
    private let coureDataUploadMananger = CourseDataUploadManager.shared
    private let parseManager = KMLParserManager()
    
    @State var gpsArtCourse: [GPSArtCourse] = []
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(gpsArtCourse, id: \.id) { course in
                    Text(course.title)
                }
                .foregroundStyle(.customWhite)
            }
            Button {
                setCourseData()
            } label: {
                Text("write data")
            }
            Button {
                readAllCourseData()
            } label: {
                Text("read all course data")
            }
            Button {
                readCourseData(id: "FFE76A93-71A1-41FC-BE24-0BC3749A28A9")
            } label: {
                Text("read course data")
            }
        }
    }
    
    func readAllCourseData() {
        coureDataUploadMananger.readAllCourses { res in
            switch res {
            case .success(let allCourse):
                self.gpsArtCourse = allCourse
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func readCourseData(id: String) {
        coureDataUploadMananger.readCourse(id: id) { res in
            switch res {
            case .success(let course):
                self.gpsArtCourse = []
                gpsArtCourse.append(course)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setCourseData() {
        let parsedCoordinates = parseCooridinates(fileName: "pohangDangDangRun")
        let centerLocation  = CLLocationCoordinate2D(latitude: 36.0259635, longitude: 129.361410)
        getPlaceMarks(coordinate: centerLocation) { newPlaceMark in
            let gpsArtCourse = GPSArtCourse(
                id: UUID().uuidString,
                courseName: "댕댕런",
                locationInfo: newPlaceMark,
                courseLength: 5,
                courseDuration: 50,
                centerLocation: Coordinate(longitude: centerLocation.longitude, latitude: centerLocation.latitude),
                distance: 0,
                level: .hard,
                alley: .lots,
                coursePaths: parsedCoordinates,
                heading: 1.5,
                thumbnail: "https://firebasestorage.googleapis.com/v0/b/outline-5640c.appspot.com/o/courseImages%2FcourseImage_duckRun.jpg?alt=media&token=479a261d-0534-4e21-ac27-a9b2b27bfce7&_gl=1*4pvvwz*_ga*MTE2MDQ4NzcyNy4xNjk3MTE2NTg4*_ga_CW55HF8NVT*MTY5NzcxNDc1Ny4zMy4xLjE2OTc3MTUyOTEuNTEuMC4w",
                regionDisplayName: "포항시 북구 효자동"
            )
            coureDataUploadMananger.uploadData(course: gpsArtCourse)
        }
    }
        
    func parseCooridinates(fileName: String) -> [Coordinate] {
        if let kmlFilePath = Bundle.main.path(forResource: fileName, ofType: "kml") {
            let kmlParser = KMLParserManager()
            return kmlParser.parseKMLFile(atPath: kmlFilePath).map { clLocation2D in
                Coordinate(longitude: clLocation2D.longitude, latitude: clLocation2D.latitude)
            }
        }
        return []
    }
    
    func getPlaceMarks(coordinate: CLLocationCoordinate2D, completion: @escaping (_ newPlaceMark: Placemark) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                completion(Placemark(
                    name: placemark.name ?? "",
                    isoCountryCode: placemark.isoCountryCode ?? "",
                    administrativeArea: placemark.administrativeArea ?? "",
                    subAdministrativeArea: placemark.subAdministrativeArea ?? "",
                    locality: placemark.locality ?? "",
                    subLocality: placemark.subLocality ?? "",
                    throughfare: placemark.thoroughfare ?? "",
                    subThroughfare: placemark.subThoroughfare ?? ""
                ))
            }
        }
        
    }
}

final class CourseDataUploadManager {
    static let shared = CourseDataUploadManager()
    private init() {}
    private let courseListRef = Firestore.firestore().collection("allGPSArtCourses")
    
    func uploadData(course: GPSArtCourse) {
        do {
            courseListRef.document("\(course.id)")
            try courseListRef.document("\(course.id)").setData(from: course)
            print("success")
        } catch {
            print("fail to write")
        }
    }
    
    func readCourse(id: String, completion: @escaping (Result<GPSArtCourse, GPSArtError>) -> Void) {
        courseListRef.document(id).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                completion(.failure(.dataNotFound))
                return
            }
            
            do {
                let courseInfo = try snapshot.data(as: GPSArtCourse.self)
                completion(.success(courseInfo))
            } catch {
                completion(.failure(.typeError))
            }
        }
    }
    
    func readAllCourses(completion: @escaping (Result<AllGPSArtCourses, GPSArtError>) -> Void) {
        courseListRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(.dataNotFound))
                return
            }
            do {
                var courseList: [GPSArtCourse] = []
                for snapshot in snapshot.documents {
                    let course = try snapshot.data(as: GPSArtCourse.self)
                    courseList.append(course)
                }
                completion(.success(courseList))
            } catch {
                completion(.failure(.typeError))
            }
        }
    }
    
}
