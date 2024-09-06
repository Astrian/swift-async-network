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
  public init(baseURL: String) throws {
    // Detect the URL is valid
    guard let _ = URL(string: baseURL) else {
      throw SANErrors.invaildURL
    }
    // remove the last slash
    if baseURL.last == "/" {
      self.baseURL = String(baseURL.dropLast())
    } else {
      self.baseURL = baseURL
    }
  }
  
  public init(baseURL: String, params: SANReqParams) throws {
    // Detect the URL is valid
    guard let _ = URL(string: baseURL) else {
      throw SANErrors.invaildURL
    }
    // remove the last slash
    if baseURL.last == "/" {
      self.baseURL = String(baseURL.dropLast())
    } else {
      self.baseURL = baseURL
    }
    
    // params should not have body and query
    if params.body != nil {
      throw SANErrors.notAllowedParamsInInstance
    }
    if params.query != nil {
      throw SANErrors.notAllowedParamsInInstance
    }
    
    self.params = params
  }
  
  // Request function, calling Session.request
  public func request(_ method: String = "GET", _ path: String, params: SANReqParams? = nil) async throws -> (Data, HTTPURLResponse?) {
    // if the first character of path is not "/", add it
    var path = path
    if path.first != "/" {
      path = "/\(path)"
    }
    
    // if params is not nil, user may need to overwrite the config from instance
    let newParams = SANReqParams(
      query: params?.query,
      body: params?.body,
      header: params?.header ?? self.params?.header,
      auth: params?.auth ?? self.params?.auth
    )
    
    return try await Session.default.request(method, baseURL + path, params: newParams)
  }
  
  // Shortcut methods
  public func GET(_ path: String, params: SANReqParams? = nil) async throws -> (Data, HTTPURLResponse?) {
    return try await request("GET", path, params: params)
  }
  public func POST(_ path: String, params: SANReqParams? = nil) async throws -> (Data, HTTPURLResponse?) {
    return try await request("POST", path, params: params)
  }
  public func PUT(_ path: String, params: SANReqParams? = nil) async throws -> (Data, HTTPURLResponse?) {
    return try await request("PUT", path, params: params)
  }
  public func DELETE(_ path: String, params: SANReqParams? = nil) async throws -> (Data, HTTPURLResponse?) {
    return try await request("DELETE", path, params: params)
  }
  
  var baseURL: String
  var params: SANReqParams?
}
