# Swift Async Network

This is a package used for make request in Swift program.

## Useage
``` swift
import SwiftAsyncNetwork

func someFunction() async {
    let (data, res) = try await SAN.request(
        "GET", "https://httpstat.us/200",
        params: SANReqParams(
            query: ["hello": "world"],
            body: ["hello": "world"],
            header: ["Content-Type": "application/json", "Accept": "application/json"]
        )
    )
}
```
