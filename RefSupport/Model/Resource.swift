//
//  Resource.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-19.
//

import Foundation


struct Link {
    let title: String
    let description: String
    let url: URL
    var viewValue: Int?
    var parentField: String?
}


struct ExtendedResourceLink {
    let title: String
    let description: String
    let url: URL
    var viewValue: Int
    var parentField: String
}
