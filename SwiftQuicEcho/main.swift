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

let bootstrap: () async throws -> Server = {
  async let bootServer = Server.bootstrap
  // TODO: configure server
  return try await bootServer()
}

let connect: (Server) async throws -> Connection = {
  server in
  try await server.accept()
}

let accept: (Connection) async throws -> Quic.Stream = {
  connection in
  try await connection.accept()
}

let main = Task {
  let server = try await bootstrap()
  print("Started ...")
  let connection = try await connect(server)
  let stream = try await accept(connection)
  print("Connected...")
  while true {
    let data = try await stream.receive()
    print("Received \(data)")
    try await stream.send(data)
  }
}

while true {
  sleep(.max)
}
