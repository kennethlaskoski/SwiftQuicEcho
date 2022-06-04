//
//  main.swift
//  SwiftQuicEcho
//
//  Created by Kenneth Laskoski on 03/06/22.
//

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

let accept: (Connection) async throws -> Stream = {
  connection in
  try await connection.accept()
}

let receive: (Stream) async throws -> String = {
  stream in
  try await stream.receive()
}

let send: (Stream, String) async throws -> Void = {
  stream, string in
  try await stream.send(string)
}

let main = Task {
  let server = try await bootstrap()
  let connection = try await connect(server)
  let stream = try await accept(connection)
  for i in 0..<10 {
    let string = try await receive(stream)
    print(i, string)
    try await send(stream, "Sending \(i)")
  }
}

while true {
  sleep(.max)
}
