//
//  Endpoint.swift
//  Rimac
//
//  Created by Joseph Estanislao Calla Moreyra on 1/9/22.
//

import Foundation
import Alamofire

protocol EndPoint {
    var apiKey: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}
extension EndPoint {
    func toURL() -> URLConvertible {
        return baseURL + path + apiKey
    }
}

