//
//  ViewController.swift
//  SpectrumAssignment
//
//  Created by C02VM0S0HV2D on 24/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello")
        
        networkManager.getCompanyDetails { (Response, error) in
            if let error = error {
                print("Get Response error: \(error.localizedDescription)")
                return
            }
            guard let Response = Response  else { return }
            print("Current Response Object:")
            print(Response)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }


}

