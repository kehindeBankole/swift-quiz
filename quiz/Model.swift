//
//  Model.swift
//  quiz
//
//  Created by kehinde on 25/02/2024.
//

import Foundation


enum MyError: Error {
    case badParsing
    case badRequest
    case networkError
    case invalidHTTPStatusCode
}

struct Quiz : Decodable {
    var response_code : Int
    var results : [resultsArray]
    
}

struct resultsArray : Decodable {
    var type : String
    var difficulty : String
    var category : String
    var question : String
    var correct_answer : String
    var incorrect_answers : [String]
}
