import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let mysqlConfig = MySQLConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tlsConfiguration: .none
    )
    
    app.databases.use(.mysql(configuration: mysqlConfig), as: .mysql)


    app.migrations.add(Cheese.Migration())
    app.migrations.add(Characteristic.Migration())
    app.migrations.add(CheeseChar.Migration())
    
    try app.autoRevert().wait()
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
