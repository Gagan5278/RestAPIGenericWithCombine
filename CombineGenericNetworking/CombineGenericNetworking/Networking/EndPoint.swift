//
//  EndPoint.swift
//  CombineGenericNetworking
//
//  Created by Gagan  Vishal on 9/27/20.
//

import Foundation

struct EndPoint<K: PrepareRequest, D: Decodable> {
    let path: String
    let queryItems: [URLQueryItem] = []
    let bobyHTTP : Data?
    
    init(path: String, data: Data? = nil) {
        self.bobyHTTP = data
        self.path = path
    }
}

extension EndPoint {
    func makeRequest(for data :K.RequestedHeaderItem, with httpMehod: HTTPMethod) -> URLRequest?  {
        var urlComponent = URLComponents()
        urlComponent.path = path
        urlComponent.scheme = "https"
        urlComponent.host = "reqres.in"
       // urlComponent.queryItems = queryItems
        guard let url = urlComponent.url else {
            return nil
        }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        if let boby = bobyHTTP {
            request.httpBody = boby
        }
        request.httpMethod = httpMehod.rawValue
        K.prepareRequest(request: &request, with: data)
        return request
    }
}

//MARK:- HTTP METHODS
enum HTTPMethod: String {
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
}

//BELOW EXTENSIONS ARE CREATED FOR DEMO PURPOSE ONLY. We can implement without creating Extension. See ViewController.swift PUT and DELETE request
//MARK:- GET
extension EndPoint where K == FormedRequestKind.Public, D == UserModel {
    static var featuredItems: Self {
        EndPoint(path: "/api/users?page=2",  data: nil)
    }

}

//MARK:- POST
extension EndPoint where K == FormedRequestKind.Public, D == Dictionary<String, String> {
    static func addNewUser() -> Self {
        let dic = ["name": "morpheus", "job": "T-leader", "id": "958", "createdAt":"2020-09-27T19:13:54.183Z"]
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return EndPoint(path: "/api/users", data: jsonString.data(using: .utf8)!)
            }
        }
       return EndPoint(path: "")
    }
}

