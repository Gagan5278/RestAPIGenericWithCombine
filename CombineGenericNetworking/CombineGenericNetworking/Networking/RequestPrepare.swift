//
//  RequestPrepare.swift
//  CombineGenericNetworking
//
//  Created by Gagan  Vishal on 9/27/20.
//

import Foundation

protocol PrepareRequest {
    associatedtype RequestedItem
    static func prepareRequest(request: inout URLRequest, with data: RequestedItem)
}

enum FormedRequestKind {
    //when there is no auth required for access database
    enum Public: PrepareRequest {
        typealias RequestedItem = Any?
        static func prepareRequest(request: inout URLRequest, with data: RequestedItem) {
            //1. set cache policy here
            request.cachePolicy = .reloadIgnoringLocalCacheData
            //2. Add supplied HTTPHeaderField
            if let dictData = data as? [String: String] {
                FormedRequestKind.createHttpHeader(dictData, &request)
            }
        }
    }
    
    //When auth token required for accessing database
    enum Private: PrepareRequest{
        typealias RequestedItem = Any?
        static func prepareRequest(request: inout URLRequest, with data: RequestedItem) {
            guard let accessToken  = AccessToken.acceessToken else { return }
            //1. Add access token in header
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            //2. Add supplied HTTPHeaderField
            if let dictData = data as? [String: String] {
                FormedRequestKind.createHttpHeader(dictData, &request)
            }
        }
    }
    
    //MARK:- Create HTTP header for supplied request
     private static func createHttpHeader(_ data: [String : String], _ request: inout URLRequest) {
        for (key, value) in data where value.isEmpty == false {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
}

