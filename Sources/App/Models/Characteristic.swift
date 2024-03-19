//
//  File.swift
//  
//
//  Created by Jessica Joseph on 12/13/22.
//

import Fluent


final class Characteristic: Model {
    static var schema: String { "characteristics" }
    
    @ID()
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdPotato: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deletedAt", on: .delete)
    var deletedAt: Date?
    
    @Field(key: "title")
    var title: String
    
    @Enum(key: "type")
    var type: CharType
    
    @Siblings(through: CheeseChar.self, from: \.$characteristic, to: \.$cheese)
    var cheeses: [Cheese]
    
    init() {}
}

enum CharType: String, Codable {
    case flavor
    case color
}

