//
//  File.swift
//  
//
//  Created by Jessica Joseph on 12/13/22.
//

import Fluent

extension CheeseChar {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(CheeseChar.schema)
                .id()
                .field("cheese_id", .int, .required)
                .field("char_id", .uuid, .required)
                .unique(on: "cheese_id", "char_id")
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(CheeseChar.schema).delete()
        }
    }
}
