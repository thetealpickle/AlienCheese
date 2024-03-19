//
//  File.swift
//  
//
//  Created by Jessica Joseph on 12/13/22.
//

import Fluent

extension Characteristic {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database
                .enum("characteristic")
                .case("flavor")
                .case("color")
                .create()
                .flatMap { enumType in
                    database.schema(Characteristic.schema)
                        .id()
                        .field("createdAt", .datetime)
                        .field("updatedAt", .datetime)
                        .field("deletedAt", .datetime)
                    
                        .field("title", .string, .required)
                        .field("type",  enumType, .required)
                        .create()
                }
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Characteristic.schema)
                .delete().flatMap {
                    database.enum("characteristic").delete()
                }
        }
    }
    
}
