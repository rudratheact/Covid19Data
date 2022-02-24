//
//  CasesEntity+CoreDataProperties.swift
//  Covid19Data
//
//  Created by Rudra Evolut on 24/02/22.
//
//

import Foundation
import CoreData


extension CasesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CasesEntity> {
        return NSFetchRequest<CasesEntity>(entityName: "CasesEntity")
    }

    @NSManaged public var date: String
    @NSManaged public var totalconfirmed: String
    @NSManaged public var totaldeceased: String
    @NSManaged public var totalrecovered: String

}

extension CasesEntity : Identifiable {

}
