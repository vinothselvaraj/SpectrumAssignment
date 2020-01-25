//
//  CompanyDetails.swift
//  SpectrumAssignment
//
//  Created by C02VM0S0HV2D on 25/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import Foundation

struct CompanyDetails:Codable {
    let _id:String
    let company:String
    let website:String
    let logo:String
    let about:String
    let members:[MemberDetails]
    let favorite:Bool?
}
