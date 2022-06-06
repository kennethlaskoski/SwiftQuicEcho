//
//  main.swift
//  EchoServer
//
//  Created by Kenneth Laskoski on 06/06/22.
//

import Quic
import Darwin

let certPEM = 2
let keyPEM = 3

let main = Task {
  do {
    let bootServer = Server.bootstrap
    // TODO: configure server
    let server = try await bootServer()
    print("Server started ...")
    try await withThrowingTaskGroup(of: Void.self) { group in
      while true {
        let connection = try await server.accept()
        group.addTask {
          let stream = try await connection.accept()
          print("Connected...")
          while true {
            let data = try await stream.receive()
            print("Received \(String(data: data, encoding: .utf8)!)")
            try await stream.send(data)
          }
        }
      }
    }
  } catch {
    print(error)
    exit(-1)
  }
}

while true {
  sleep(.max)
}
