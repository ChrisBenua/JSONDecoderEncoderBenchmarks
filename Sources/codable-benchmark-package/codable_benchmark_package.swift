// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import FastCoders
import QuartzCore

enum Mode: String, ExpressibleByArgument, Codable {
    case decode
    case decode_new
    case encode
    case encode_new
}

@main
struct CodableBenchmarkPackage: ParsableCommand {
    @Option(name: .shortAndLong, help: "Running mode")
    var mode: Mode

    mutating func run() throws {
        switch mode {
        case .decode:
            decodeJSON()
        case .decode_new:
            decodeJSONNew()
        case .encode:
            encodeJSON()
        case .encode_new:
            encodeJSONNew()
        }
    }

    func decodeJSON() {
        guard let fileURL = Bundle.module.url(forResource: "A1_Hierarchy", withExtension: "json") else {
            fatalError("File A1_Hierarchy.json is not found")
        }
        let jsonData: Data
        do {
            jsonData = try Data(contentsOf: fileURL)
        } catch {
            fatalError("Failed to load JSON file: \(error)")
        }

        let decoder = JSONDecoder()

        let start = CACurrentMediaTime()
        do {
            blackHole(try testDecodingAllClasses(decoder: decoder, jsonData: jsonData))
        } catch {
            print("Decoding error: \(error)")
        }
        let finish = CACurrentMediaTime()

        print("Decoding duration: \(finish - start)")
    }

    func decodeJSONNew() {
        guard let fileURL = Bundle.module.url(forResource: "A1_Hierarchy", withExtension: "json") else {
            fatalError("File A1_Hierarchy.json is not found")
        }
        let jsonData: Data
        do {
            jsonData = try Data(contentsOf: fileURL)
        } catch {
            fatalError("Failed to load JSON file: \(error)")
        }

        let decoder = FastJSONDecoder()

        let start = CACurrentMediaTime()
        do {
            blackHole(try testDecodingAllClasses(decoder: decoder, jsonData: jsonData))
        } catch {
            print("Decoding error: \(error)")
        }
        let finish = CACurrentMediaTime()

        print("Decoding duration: \(finish - start)")
    }

    func encodeJSON() {
        let encoder = JSONEncoder()

        let start = CACurrentMediaTime()
        do {
            try testEncodingAllClasses(encoder: encoder)
        } catch {
            print("Encoding error: \(error)")
        }
        let finish = CACurrentMediaTime()

        print("Encoding duration: \(finish - start)")
    }

    func encodeJSONNew() {
        let encoder = FastJSONEncoder()

        let start = CACurrentMediaTime()
        do {
            try testEncodingAllClasses(encoder: encoder)
        } catch {
            print("Encoding error: \(error)")
        }
        let finish = CACurrentMediaTime()

        print("Encoding duration: \(finish - start)")
    }
}

