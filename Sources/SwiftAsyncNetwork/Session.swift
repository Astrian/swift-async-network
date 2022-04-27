import Foundation

public struct Session {
  
  static let `default` = Session()
  
  // MARK: - GET method
  func request(_ method: String = "GET", _ urlString: String, params: SANReqParams? = nil) async throws -> (Data, HTTPURLResponse?) {
    
    // Create URL components
    var urlComponents = URLComponents()
    
    // Create query items
    var query: [URLQueryItem] = []
    
    // Split protocols and address
    guard urlString.components(separatedBy: "://").count == 2 else {
      throw SANErrors.invaildURL
    }
    urlComponents.scheme = urlString.components(separatedBy: "://")[0]
    
    // Split domain
    var urlSpreadedBySlash = urlString.components(separatedBy: "://")[1].components(separatedBy: "/")
    urlComponents.host = urlSpreadedBySlash[0]
    
    // Process query params inside URL string
    if urlSpreadedBySlash[urlSpreadedBySlash.count - 1].components(separatedBy: "?").count == 2 {
      let queryString = urlSpreadedBySlash[urlSpreadedBySlash.count - 1].components(separatedBy: "?")[1]
      urlSpreadedBySlash[urlSpreadedBySlash.count - 1] = urlSpreadedBySlash[urlSpreadedBySlash.count - 1].components(separatedBy: "?")[0]
      let queryInURLString = queryString.components(separatedBy: "&")
      for item in queryInURLString {
        query.append(URLQueryItem(name: item.components(separatedBy: "=")[0], value: item.components(separatedBy: "=")[1]))
      }
    }
    
    // Combine query in params
    let queryInParams = params?.query
    if queryInParams != nil {
      for (key, value) in queryInParams! {
        query.append(URLQueryItem(name: key, value: value))
      }
    }
    
    // Write queries
    urlComponents.queryItems = query
    
    // Get path
    var path: String = ""
    for item in urlSpreadedBySlash {
      if item == urlComponents.host {
        continue
      }
      path += "/\(item)"
    }
    urlComponents.path = path
    
    // Output URL
    guard let url = urlComponents.url else {
      throw SANErrors.internalError
    }
    
    // Generate request, write params
    var request = URLRequest(url: url)
    request.httpMethod = method
    
    // Write body
    if method != "GET" && params?.body != nil {
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: params!.body!, options: .prettyPrinted)
      } catch {
        throw SANErrors.internalError
      }
    }
    
    // Write header
    if params?.header != nil {
      let header: [String: String] = params!.header!
      for (key, value) in header {
        request.addValue(value, forHTTPHeaderField: key)
      }
    }
    
    // Trigger request
    let session = URLSession.shared
    let (data, res) = try await session.data(for: request)
    
    return (data, res as? HTTPURLResponse)
  }
  
}
