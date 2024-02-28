//
//  util.swift
//  quiz
//
//  Created by kehinde on 25/02/2024.
//

import Foundation


let alphabets = ["A" , "B" , "C" , "D" , "E"]



func callApi() async throws -> Quiz? {
    if let url = URL(string: "https://opentdb.com/api.php?amount=10"){
        let requestUrl = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        let(data , response) = try await URLSession(configuration: config).data(for: requestUrl)
        
        
        guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
            print("sssj")
            throw MyError.networkError
        }
        do{
            let decodedData = try JSONDecoder().decode(Quiz.self , from : data)
            return decodedData
            
        }catch{
            print("error")
        }
    }
    return nil
}
