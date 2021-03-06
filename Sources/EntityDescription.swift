//
// Copyright (c) Vatsal Manot
//

import CoreData
import Foundation
import Swift

public struct EntityDescription<Object: NSManagedObject>: NSEntityDescriptionConvertible {
    public let name: String

    public private(set) var managedObjectClassName: String!
    public private(set) var subentities: [EntityDescription] = []
    public private(set) var properties: [EntityPropertyDescription] = []

    public init(name: String) {
        self.name = name
        self.managedObjectClassName = NSStringFromClass(Object.self)
    }
}

extension EntityDescription {
    public func toNSEntityDescription() -> NSEntityDescription {
        let result = NSEntityDescription()

        result.name = name
        result.managedObjectClassName = managedObjectClassName
        result.properties = properties.map({ $0.toNSPropertyDescription() })

        return result
    }
}

extension EntityDescription {
    public func subentities(@ArrayBuilder<EntityDescription> _ subentities: () -> [EntityDescription]) -> EntityDescription {
        var result = self

        result.subentities = subentities()

        return result
    }

    public func properties(@ArrayBuilder<EntityPropertyDescription> _ properties: (EntityAttributeDescriptionBuilder<Object>) -> [EntityPropertyDescription]) -> EntityDescription {
        var result = self

        result.properties = properties(.init())

        return result
    }
}
