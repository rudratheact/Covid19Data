//
//  StatesEntity+CoreDataProperties.swift
//  Covid19Data
//
//  Created by Rudra Evolut on 24/02/22.
//
//

import Foundation
import CoreData


extension StatesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatesEntity> {
        return NSFetchRequest<StatesEntity>(entityName: "StatesEntity")
    }

    @NSManaged public var recovered: String
    @NSManaged public var state: String
    @NSManaged public var active: String
    @NSManaged public var deaths: String

}

extension StatesEntity : Identifiable {

}
