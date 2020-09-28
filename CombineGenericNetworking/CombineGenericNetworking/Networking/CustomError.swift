//
//  CustomError.swift
//  CombineGenericNetworking
//
//  Created by Gagan  Vishal on 9/27/20.
//

import Foundation

enum CustomError: Error {
    case invalidURL
    case invalidRequest
    case serverError
    case clientSideError
    case other(Error)
    
    static func map(error: Error) -> CustomError {
        return (error as? CustomError) ?? other(error)
    }
}
