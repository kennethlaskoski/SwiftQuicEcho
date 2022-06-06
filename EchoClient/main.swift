//
//  main.swift
//  EchoClient
//
//  Created by Kenneth Laskoski on 06/06/22.
//

import Quic
import Darwin

let certPEM = 2
let keyPEM = 3

let main = Task {
  do {
    let bootClient = Client.bootstrap
    // TODO: configure client
    let client = try await bootClient()
    print("Client started ...")
    let connection = try await client.connect()
    let stream = try await connection.accept()
    print("Connected...")
    while let sendData = readLine() {
      try await stream.send(sendData.data(using: .utf8)!)
      let recvData = try await stream.receive()
      print("Received \(String(data: recvData, encoding: .utf8)!)")
    }
  } catch {
    print(error)
    exit(-1)
  }
}

while true {
  sleep(.max)
}
