//
//  File.swift
//  
//
//  Created by Jessica Joseph on 12/13/22.
//

import Vapor

extension Characteristic: Content {}

struct CharCollection: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let charRoutes = routes.grouped("char")
        
        charRoutes.post(use: post)
        charRoutes.get( use: get)
    }
    
    func get(_ req: Request) throws -> EventLoopFuture<[Characteristic]> {
        Characteristic
            .query(on: req.db)
            .all()
    }
    
    func post(_ req: Request) throws -> EventLoopFuture<Characteristic> {
        let content = try req.content.decode(Characteristic.self)
        
        return content
            .save(on: req.db)
            .map { content }
    }
}
