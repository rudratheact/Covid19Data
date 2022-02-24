//
//  TestsEntity+CoreDataProperties.swift
//  Covid19Data
//
//  Created by Rudra Evolut on 24/02/22.
//
//

import Foundation
import CoreData


extension TestsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestsEntity> {
        return NSFetchRequest<TestsEntity>(entityName: "TestsEntity")
    }

    @NSManaged public var testedasof: String
    @NSManaged public var dailyrtpcrsamplescollectedicmrapplication: String
    @NSManaged public var samplereportedtoday: String
    @NSManaged public var totaldosesadministered: String

}

extension TestsEntity : Identifiable {

}
