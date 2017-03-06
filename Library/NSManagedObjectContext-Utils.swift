//
//  NSManagedObjectContext-Utils.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/24/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
import CoreData

protocol NSManagedObjectContextProtocol {
	func allEntities<T: NSManagedObject>(withType type: T.Type) throws -> [T]
	func allEntities<T: NSManagedObject>(withType type: T.Type, predicate: NSPredicate?) throws -> [T]
	func addEntity<T: NSManagedObject>(withType type : T.Type) -> T?
	func save() throws
	func delete(_ object: NSManagedObject)
}

extension NSManagedObjectContext: NSManagedObjectContextProtocol {
	func allEntities<T: NSManagedObject>(withType type: T.Type) throws -> [T] {
		return try allEntities(withType: type, predicate: nil)
	}
	
	func allEntities<T : NSManagedObject>(withType type: T.Type, predicate: NSPredicate?) throws -> [T] {
		let request = NSFetchRequest<T>(entityName: T.description())
		request.predicate = predicate
		let results = try self.fetch(request)
		
		return results
	}
	
	func addEntity<T : NSManagedObject>(withType type: T.Type) -> T? {
		let entityName = T.description()
		
		guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: self) else {
			return nil
		}
		
		let record = T(entity: entity, insertInto: self)
		
		return record
	}
}
