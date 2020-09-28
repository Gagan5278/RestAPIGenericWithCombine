//
//  Networking.swift
//  CombineGenericNetworking
//
//  Created by Gagan  Vishal on 9/27/20.
//

import Foundation
import Combine

struct Networking {
    
    //MARK:- Make URL request call for GET, POST, PUT, DELETE, PATCH
    static func makeRequest<K, R>(for endPoint: EndPoint<K, R>, with decoder: JSONDecoder = .init(), using data : K.RequestedItem, method: HTTPMethod) -> AnyPublisher<R?, CustomError> {
        //1. Check for request
        guard let request = endPoint.makeRequest(for: data, with: method) else {
            return Fail(error: CustomError.invalidRequest).eraseToAnyPublisher()
        }
        //2.make a request call
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                guard let httpURLResponse = response.response as? HTTPURLResponse, 200..<299 ~= httpURLResponse.statusCode  else {
                    throw CustomError.serverError
                }
                return response.data
            }
            .flatMap{ data -> AnyPublisher<R?, Error> in
                if data.isEmpty {
                    return Just((true as? R) ?? nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return Just(data).decode(type: R?.self, decoder: decoder)
                    .eraseToAnyPublisher()
            }
            .mapError{CustomError.map(error: $0)}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
