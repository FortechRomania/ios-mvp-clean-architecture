//
//  JSON.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/25/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

/**
Extension on `Dictionary` that adds different helper methods such as JSON `Data` serialization
*/
public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any  {
	
	/**
	Heper method that serializes the `Dictionary` to JSON `Data`
	
	- returns: `Data` containing the serialized JSON or empty `Data` (e.g. `Data()`) if the serialization fails
	*/
	public func toJsonData() -> Data {
		do {
			return try JSONSerialization.data(withJSONObject: self, options: [])
		} catch {
			return Data()
		}
	}
}

/**
Extension on `Array` that adds different helper methods such as JSON `Data` serialization
*/
public extension Array where Element: Any {
	/**
	Heper method that serializes the `Array` to JSON `Data`
	
	- returns: `Data` containing the serialized JSON or empty `Data` (e.g. `Data()`) if the serialization fails
	*/
	public func toJsonData() -> Data {
		do {
			return try JSONSerialization.data(withJSONObject: self, options: [])
		} catch {
			return Data()
		}
	}
}
