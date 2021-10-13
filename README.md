# gRPC Cheatsheet

This repo contains notes of the key elements of gRPC. Most of the notes
were taken while following the ["Building Java Microservices with gRPC"](https://www.linkedin.com/learning/building-java-microservices-with-grpc)
course on LinkedIn Learning.

# 1. Introduction to gRPC

## A brief history of inter-service communication

In the beginning we had RPC with frameworks like Java RMI and Corba.
However, implementing applications with these frameworks was extremely
cumbersome.

So the world moved on to SOAP. But SOAP required developers to deal with
huge XML configuration files that added a lot of overhead. This overhead
was there even tiny projects and tiny messages. SOAP is still alive
in some legacy enterprise applications.

So the world moved on to REST over HTTP. This is still very popular and
in some aspects is an overcompensation from the strict days of SOAP.
REST is extremely flexible, but that flexibility comes at some costs:
- Serialization and deserialization overheads of test based messages.
- REST is not type safe.
- It is difficult to discover APIs. REST relies heavily on convention
  and documentation.

gRPC is the next evolution in the inter-service communication history.

## gRPC framework overview

### gRPC features
- Works with HTTP/2, making it highly performant.
  - HTTP/2 is binary, so it takes away the overhead serializing and
    deserializing text based data (like JSON), which is the standard in
    HTTP/1.
  - Also, binary data takes much less space over the wire.
- gRPC uses protocol buffers (over HTTP/2) or "protobuffs". A protobuff
  is an interface definition language (IDL).
  - protobuffs is not the only way to define an interface, but it is the
    promoted way.
- gRPC has strictly defined interfaces. You can define the service
  contract first before working in the implementation details of the
  service with full confidence.
- It is strongly typed.
- It is multi-language. Once you create the protobuffs, you can generate
  the client and server stubs in multiple languages.
- Supports unidirectional and bidirectional streaming.
- Has built-in support for cross-cutting concerns like authentication
  and error-handling.

#### gRPC disadvantages
- Limited support to call a gRPC server form a browser. This is why it
  is typically used only for server-to-server communication.
- Request and response data is binary, so it is not human-readable. This
  is by design, but hopefully you will no longer have the need to read
  what is travelling in the wire.

## gRPC foundations
Stuff you need to understand before understanding gRPC

### HTTP2 basics
Some HTTP2 terminology:
- **Stream**: bidirectional flow of data between client and server. It
  contains multiple messages. Each stream is uniquely identified by a
  `streamID`.
- **Message**: a sequence of frames that correspond to an HTTP request or
  response.
- **Frame**: is the smallest unit of data. Each frame contains a header
  and a body. Each frame carries the `StreamID` that it belongs to.
  - Frames are sent over a single TCP connection and frames from
    different streams can be interleaved and fully-multiplexed on the
    same connection. The messages are re-assembled at the client and
    server and there is no waiting for "previous requests" to finish.

#### How is HTTP/2 better than HTTP/1?
- Supports request/response multiplexing over a single connection in a
  bidirectional way.
- Supports bi-directional streaming.
- Compresses HTTP headers.
- Overall it is faster, efficient with less latency.

### Protobuff basics
Protobuff is a language that allows us to define the contract to which
  services will abide. That contract defines how data will be structured
  (request and responses) and what APIs are available.

The protobuff language is programming language agnostic. You can
generate client and server stubs out of the same protobuff spec for
multiple languages: C, C#, Go, Java, Kotlin, Dart, Python, Ruby and
Objective-C.

## High-level steps to develop a gRPC service
1. Write your service definition using protobuffs (or any of the
   supported IDLs) in a `.proto` file.
2. Use the protoc compiler to transform the `.proto` specification into
   auto-generated classes and client / server stubs written in your
   target programming language. You will need a `protoc-gen-grpc` plugin
   for you target programming languages to do this.
3. Implement the server methods enforced by the stubs and run a gRPC
   service in the language you chose. (e.g. Java)
4. Write your client with using the generated client stubs for the
   programming language you want (e.g. Go).
