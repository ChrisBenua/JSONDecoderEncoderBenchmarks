//
//  String+CodingKey.swift
//  codable-benchmark-package
//
//  Created by Kristian Benua on 23.08.2025.
//

extension String: CodingKey {
  public init?(stringValue: String) {
    self = stringValue
  }
  public init?(intValue: Int) { nil }
  public var intValue: Int? { nil }
  public var stringValue: String {
    self
  }
}
