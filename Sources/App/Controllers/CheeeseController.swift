//
//  File.swift
//  
//
//  Created by Jessica Joseph on 12/13/22.
//

import Fluent
import Vapor

extension Cheese: Content {}
//extension Characteristic: Content {}

struct CheeseCollection: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cheeseRoute = routes.grouped("cheeses")
        
        cheeseRoute.post(use: post)
        cheeseRoute.get(use: get)
        cheeseRoute.get("full", use: getFull)
        cheeseRoute.delete(":id", use: delete)
        cheeseRoute.delete("wipe", ":id", use: wipe)
        
        cheeseRoute.post(":id", "char", ":charId", use: attachChar)        
    }
    
    func getFull(_ req: Request) throws -> EventLoopFuture<[Cheese]> {
        Cheese
            .query(on: req.db)
            .with(\.$characteristics)
            .all()
    }
    
    func attachChar(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let idStr = req.parameters.get("id"),
              let id = Int(idStr),
              let charStr = req.parameters.get("charId"),
              let charId = UUID(charStr) else {
            throw Abort(.notAcceptable, reason: "hello, we're missing params 💩")
        }
        
        return req.db.transaction { database in
            Cheese
                .query(on: database)
                .filter(\.$id == id)
                .first()
                .unwrap(or: Abort(.notFound, reason: "cheese does not exist 😭"))
                .flatMap { cheese in
                    Characteristic
                        .query(on: database)
                        .filter(\.$id == charId)
                        .first()
                        .unwrap(or: Abort(.notFound, reason: "char does not exist ☠️"))
                        .flatMap { char in
                            cheese.$characteristics
                                .attach(char, on: database)
                                .transform(to: HTTPStatus.ok)
                        }
                }
        }
    }
    
    func wipe(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Cheese
            .query(on: req.db)
            .withDeleted()
            .all()
            .flatMap { cheeses in
                guard let idStr = req.parameters.get("id"),
                      let cheeseId = Int(idStr),
                      let cheese = cheeses.first(where: { $0.id ==  cheeseId }) else {
                    return req.db.eventLoop.future(error: Abort(.notFound, reason: "😭 not found"))
                }
                
                return cheese
                    .delete(force: true, on: req.db)
                    .transform(to: HTTPStatus.ok)
            }
    }
    
    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Cheese
            .find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { cheese in
                cheese
                    .delete(on: req.db)
                    .transform(to: HTTPStatus.ok)
            }
    }
    
    func post(_ req: Request) throws -> EventLoopFuture<Cheese> {
        let content = try req.content.decode(Cheese.self)
        
        return Cheese
            .query(on: req.db)
            .filter(\.$title == content.title)
            .first()
            .flatMap { cheeseOpt in
                guard cheeseOpt == nil else {
                    return req.db.eventLoop.future(error: Abort(.notAcceptable, reason: "😭 already exists"))
                }
                
                return content
                    .save(on: req.db)
                    .map { content }
            }
    }
    
    func get(_ req: Request) throws -> EventLoopFuture<[Cheese]> {
        Cheese
            .query(on: req.db)
            .all()
    }
}
