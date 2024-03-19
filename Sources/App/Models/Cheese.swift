//
//  File.swift
//  
//
//  Created by Jessica Joseph on 12/13/22.
//

import Fluent

final class Cheese: Model {
    static var schema: String { "cheeses" }
    
    @ID(custom: .id)
    var id: Int?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdPotato: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deletedAt", on: .delete)
    var deletedAt: Date?
    
    @Field(key: "title")
    var title: String
    
    
    @Siblings(through: CheeseChar.self, from: \.$cheese, to: \.$characteristic)
    var characteristics: [Characteristic]
    
    init() {}
}
