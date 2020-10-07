//
//  APIError.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 4/21/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation

enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}
