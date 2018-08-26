//
//  TasktapeJobData.swift
//  TaskTape AR Features
//
//  Created by Chris Mathias on 7/15/18.
//  Copyright © 2018 SolipsAR. All rights reserved.
//

import Foundation
import UIKit

public class JobData {
    
    //https://grokswift.com/json-swift-4/
    
    struct Job: Codable {
        
        var jobUuid: String?
        var name: String?
        var address: Address?
        var jobImage: Media?
        var createdUserFirstName: String?
        var createdUserLastName: String?
    }
    
    public struct Address: Codable {
        var city: String?
        var streetAddress: String?
        var postCode: String?
        var state: String?
        var geolocation:Geo?
    }
    
    public struct Media: Codable {
        
        public var mediaUuid: String?
        public var contentUrl: String?
        public var originalUrl: String?
        public var createdOn: Double
        public var createdUser: String?
        public var media_description: String?
        public var width: Int32
        public var height: Int32
    }

    public struct Geo: Codable {
        var lat: Float
        var lng: Float
    }
 
    
    static var jobs: [Job] = load()!
    
    static func getJob(_ id:String) -> Job? {
        for job in jobs {
            if job.jobUuid == id {
                return job
            }
        }
        return nil
    }
    
//    public func hydrate(_ jobData: String) -> Job {
//        let decoder = JSONDecoder()
//        do {
//
//            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//            jobs = try decoder.decode([Job].self, from: data)
//
//        } catch {
//            print("error trying to convert data to JSON")
//            print(error)
//        }
//    }

    static func load() -> [Job]? {
        print("Reading static jobs from JobData.json")
        if let path = Bundle.main.path(forResource: "JobData", ofType: "json") {

            let decoder = JSONDecoder()
            do {

                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return try decoder.decode([Job].self, from: data)

            } catch {
                print("error trying to convert data to JSON")
                print(error)
            }

        }
        return nil
    }
    
    
    
}
