//
//  NSManagedObjectContextSpy.swift
//  Library
//
//  Created by Cosmin Stirbu on 3/2/17.
//  MIT License
//
//  Copyright (c) 2017 Fortech
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import CoreData

@testable import Library

class NSManagedObjectContextSpy: NSManagedObjectContextProtocol {
    var fetchErrorToThrow: Error?
    var entitiesToReturn: [Any]?
    var addEntityToReturn: Any?
    var saveErrorToReturn: Error?
    var deletedObject: NSManagedObject?
    
    func allEntities<T: NSManagedObject>(withType type: T.Type) throws -> [T] {
        return try allEntities(withType: type, predicate: nil)
    }
    
    func allEntities<T: NSManagedObject>(withType type: T.Type, predicate: NSPredicate?) throws -> [T] {
        if let fetchErrorToThrow = fetchErrorToThrow {
            throw fetchErrorToThrow
        } else {
            return entitiesToReturn as! [T]
        }
    }
    
    func addEntity<T: NSManagedObject>(withType type : T.Type) -> T? {
        return addEntityToReturn as? T
    }
    
    func save() throws {
        if let saveErrorToReturn = saveErrorToReturn {
            throw saveErrorToReturn
        }
    }
    
    func delete(_ object: NSManagedObject) {
        deletedObject = object
    }
}
