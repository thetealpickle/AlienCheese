//
//  File.swift
//  
//
//  Created by Jessica Joseph on 12/13/22.
//

import Fluent

final class CheeseChar: Model {
    static var schema: String { "cheese+char" }
    
    typealias IDValue = UUID
    
    @ID()
    var id: UUID?
    
    @Parent(key: "cheese_id")
    var cheese: Cheese
    
    @Parent(key: "char_id")
    var characteristic: Characteristic
    
    init() {}
    
    init(id: UUID?, cheese: Cheese, characteristic: Characteristic) throws {
        self.id = id
        self.$cheese.id = try cheese.requireID()
        self.$characteristic.id = try characteristic.requireID()
    }
}
