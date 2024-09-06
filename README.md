# Swift Async Network
Swift Async Network (SAN) is a package used to make requests in the Swift program.

## Usage
### General method
You can use `try await SAN.request("METHOD", "https://example.com/endpoint")` to execute a network request.

``` swift
import SwiftAsyncNetwork

func someFunction() async {
  let (data, res) = try await SAN.request(
    "GET", "https://httpstat.us/200",
    params: SANReqParams(
      query: ["hello": "world"],
      header: ["Content-Type": "application/json", "Accept": "application/json"]
    )
  )
}
```

### Shortcut methods
The HTTP method can be executed as a shortcut method.

``` swift
import SwiftAsyncNetwork

func someFunction() async {
  let (data, res) = try await SAN.POST(
    "https://httpstat.us/200",
    params: SANReqParams(
      query: ["hello": "world"],
      body: ["key": "value"],
      header: ["Content-Type": "application/json", "Accept": "application/json"]
    )
  )
}
```

### Authentication
SAN supports the `Basic` and `Bearer` authentication header structures.

``` swift
import SwiftAsyncNetwork

func someFunction() async {
  // Basic auth
  let (data, res) = try await SAN.POST(
    "https://httpstat.us/200",
    params: SANReqParams(
      auth: SANAuthCred(username: "ren_amaniya", password: "takeurheart")
    )
  )

  // Bearer auth
  let (data, res) = try await SAN.POST(
    "https://httpstat.us/200",
    params: SANReqParams(
      auth: SANAuthCred(token: "kaitochannel")
    )
  )
}
```

### Instantiation
You can create a unique SAN instance to manage the config (domain or base URL of the backend, headers, authentication parameters, etc.) at the instance level. Note that the `body` and `query` parameters are not supported inside the instance.

You can also pass the SAN instance through the environment objects to create and manage the network requests at the whole project level.

Shortcut methods and config overwritten features are also supported in the instance.


``` swift
import SwiftAsyncNetwork
import SwiftUI

struct magusApp: App {
  var backend = try! SANInstance(baseURL: "https://backe.nd/", params: SANReqParams(
    auth: SANAuthCred(username: "ren_amaniya", password: "takeurheart")
  ))
  
  var body: some Scene {
    WindowGroup {
      ContentView().environmentObject(backend)
    }
  }
}

struct ContentView: View {
  @EnvironmentObject var backend: SANInstance
  var body: some View {
    VStack {
      Text("Hello World!")
    }.onAppear {
        Task {
          let (data, _) = try await backend.GET("/endpoint.json", params: SANReqParams(query: ["page":"1"]))
          let dataString = String(data: data, encoding: .utf8)
          print(dataString ?? "")
        }
      }
  }
}

```