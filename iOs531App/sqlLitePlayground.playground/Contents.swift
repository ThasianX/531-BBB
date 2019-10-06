import UIKit
import SQLite

let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

let db = try Connection("\(path)/db.sqlite3")

let id = Expression<Int64>("id")
let email = Expression<String>("email")
let balance = Expression<Double>("balance")
let verified = Expression<Bool>("verified")
let name = Expression<String?>("name")

let users = Table("users")

try db.run(users.create(ifNotExists: true) { t in
    t.column(id, primaryKey: true)
    t.column(email, unique: true)
    t.column(name)
})

do {
    let rowid = try db.run(users.insert(or: .replace, email <- "alice@mac.com", name <- "alice"))
    print("inserted id: \(rowid)")
} catch {
    print("insertion failed: \(error)")
}

for user in try db.prepare(users) {
    print("id: \(user[id]), email: \(user[email]), name: \(user[name])")
    // id: 1, email: alice@mac.com, name: Optional("Alice")
}
// SELECT * FROM "users"

let all = Array(try db.prepare(users))
print(all)
