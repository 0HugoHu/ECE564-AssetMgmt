//
//  FetchData.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/31/23.
//

import Foundation


/*
 Fetch data from API
 
 - Parameters:
 - endpoint: API endpoint to fetch data from
 - responseType: Type of data to decode from JSON
 - completion: Completion handler to return data or error
 */
func fetchData<T: Decodable>(from apiUrl: URL, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }
        
        guard let data = data else {
            completion(.failure(.emptyResponseData))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(.invalidResponse))
        }
    }
    
    task.resume()
}
