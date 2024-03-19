import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: CheeseCollection())
    try app.register(collection: CharCollection())
}
