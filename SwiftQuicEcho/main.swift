//
//  main.swift
//  SwiftQuicEcho
//
//  Created by Kenneth Laskoski on 03/06/22.
//

import Foundation

import Quic
import Darwin

let certPEM = 2
let keyPEM = 3

let main = Task {
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
          print("Received \(data)")
          try await stream.send(data)
        }
      }
    }
  }
}

while true {
  sleep(.max)
}
