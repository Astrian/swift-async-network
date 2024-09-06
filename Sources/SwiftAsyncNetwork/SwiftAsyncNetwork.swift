//
//  File.swift
//
//
//  Created by Astrian Zheng on 2022/4/27.
//

import Foundation
import SwiftUI

public let SAN = Session.default
public class SANInstance: ObservableObject {
  static let `default` = Session()
  
  // Input base URL
  public init(baseURL: String) {
    // Detect the URL is valid
    guard let _ = URL(string: baseURL) else {
      fatalError("Invalid URL")
    }
    // remove the last slash
    if baseURL.last == "/" {
      self.baseURL = String(baseURL.dropLast())
    } else {
      self.baseURL = baseURL
    }
  }
  
  // Request function, calling Session.request
  public func request(_ method: String = "GET", _ path: String, params: SANReqParams? = nil) async throws -> (Data, HTTPURLResponse?) {
    // if the first character of path is not "/", add it
    var path = path
    if path.first != "/" {
      path = "/\(path)"
    }
    return try await Session.default.request(method, baseURL + path, params: params)
  }
  
  var baseURL: String
}
