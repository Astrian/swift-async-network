//
//  types.swift
//
//
//  Created by Astrian Zheng on 2022/4/27.
//

public struct SANReqParams {
  public init(query: [String: String]? = nil, body: [String: Any]? = nil, header: [String: String]? = nil, auth: SANAuthCred? = nil) {
    self.query = query
    self.body = body
    self.header = header
    self.auth = auth
  }
  
  var query: [String: String]?
  var body: [String: Any]?
  var header: [String: String]?
  var auth: SANAuthCred?
}

public struct SANAuthCred {
  public init (type: SANAuthCredType, username: String, password: String) {
    if type != .basic {
      fatalError("The username and password fields are only for basic auth")
    }
    self.type = .basic
    self.username = username
    self.password = password
  }
  
  public init (type: SANAuthCredType, token: String) {
    if type != .bearer {
      fatalError("The token field is only for bearer auth")
    }
    self.type = .bearer
    self.token = token
  }
  
  var type: SANAuthCredType
  var username: String?
  var password: String?
  var token: String?
  
  public func exportHeader() -> [String: String] {
    switch type {
      case .basic:
        // Calculate base64
        let loginString = "\(username ?? ""):\(password ?? "")"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return ["Authorization": "Basic \(base64LoginString)"]
      case .bearer:
        return ["Authorization": "Bearer \(token ?? "")"]
    }
  }
}

public enum SANAuthCredType {
  case basic
  case bearer
}
