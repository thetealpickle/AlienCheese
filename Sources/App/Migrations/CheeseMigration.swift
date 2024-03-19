//
//  File.swift
//  
//
//  Created by Jessica Joseph on 12/13/22.
//

import Fluent

extension Cheese {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
                    database.schema(Cheese.schema)
                        .field("id", .int, .identifier(auto: true))
                        .field("createdAt", .datetime)
                        .field("updatedAt", .datetime)
                        .field("deletedAt", .datetime)
                    
                        .field("title", .string, .required)
                        .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database
                .schema(Cheese.schema)
                .delete()
        }
    }
}
