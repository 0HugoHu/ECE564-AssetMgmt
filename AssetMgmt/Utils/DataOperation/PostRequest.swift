//
//  PostRequest.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/2/23.
//

import Foundation


/*
 Post request
 
 - Parameters:
    - url: The URL to upload from
    - destinationURL: The URL to upload to
    - completion: A closure that is called when the upload is complete
 */
func postRequest(to url: URL, completion: @escaping (Bool) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
            logger.error("Error making the request: \(error)")
            completion(false)
            return
        }

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            completion(true)
        } else {
            logger.error("Request returned an error status code")
            completion(false)
        }
    }.resume()
}
