//
//  types.swift
//  
//
//  Created by Astrian Zheng on 2022/4/27.
//

public struct SANReqParams {
  
  public init(query: [String: String]? = nil, body: [String: Any]? = nil, header: [String: String]? = nil) {
    self.query = query
    self.body = body
    self.header = header
  }
  
  var query: [String: String]?
  var body: [String: Any]?
  var header: [String: String]?
}
