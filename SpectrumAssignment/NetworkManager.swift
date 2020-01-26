//
//  NetworkManager.swift
//  SpectrumAssignment
//
//  Created by C02VM0S0HV2D on 24/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager {

    func getCompanyDetails(completion: @escaping (_ CompanyDetails: [CompanyDetails]?, _ error: Error?) -> Void) {
        getJSONFromURL(urlString: dataURL) { (data, error) in
            guard let data = data, error == nil else {
                print("Failed to get data")
                return completion(nil, error)
            }
            
            self.createWeatherObjectWith(json: data, completion: { (CompanyDetails, error) in
                if let error = error {
                    print("Failed to convert data")
                    return completion(nil, error)
                }
                return completion(CompanyDetails, nil)
            })
        }
    }

}

extension NetworkManager {
    private func getJSONFromURL(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error: Cannot create URL from string")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                print("Error calling api")
                return completion(nil, error)
            }
            guard let responseData = data else {
                print("Data is nil")
                return completion(nil, error)
            }
            completion(responseData, nil)
        }
        task.resume()
    }
    
    private func createWeatherObjectWith(json: Data, completion: @escaping (_ data: [CompanyDetails]?, _ error: Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode([CompanyDetails].self, from: json)
            return completion(response, nil)
        } catch let error {
            print("Error creating current weather from JSON because: \(error.localizedDescription)")
            return completion(nil, error)
        }
    }
}
