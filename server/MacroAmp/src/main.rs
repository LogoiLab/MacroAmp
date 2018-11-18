#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;
#[macro_use] extern crate rocket_contrib;
#[macro_use] extern crate serde_derive;
#[macro_use] extern crate diesel;

use rocket_contrib::{Json, Value};

mod db;
pub mod schema;
pub mod session;

use self::db::*;
use self::schema::*;

use self::session::Session;

#[post("/", format = "application/json", data = "<session>")]
fn create(session: Json<Session>, connection: db::Connection) -> Json<Session> {
    let insert = Session { id: session.id, ..session.into_inner() };
    Json(Session::create(insert, &connection))
}

#[get("/")]
fn read_all(connection: db::Connection) -> Json<Value> {
    Json(json!(Session::read_all(&connection)))
}

#[get("/<id>")]
fn read(id: i32, connection: db::Connection) -> Json<Value> {
    Json(json!(Session::read(&connection, id)))
}

#[put("/<id>", format = "application/json", data = "<session>")]
fn update(id: i32, session: Json<Session>, connection: db::Connection) -> Json<Value> {
    let update = Session { id: Some(id), ..session.into_inner() };
    Json(json!({
        "success": Session::update(id, update, &connection)
    }))
}

#[delete("/<id>")]
fn delete(id: i32, connection: db::Connection) -> Json<Value> {
    Json(json!({
        "success": Session::delete(id, &connection)
    }))
}

#[post("/upload", format = "plain", data = "<data>")]
fn upload(data: Data) -> io::Result<String> {
    data.stream_to_file("/tmp/upload.mp3").map(|n| n.to_string())
}


fn main() {
    rocket::ignite()
        .manage(db::connect())
        .mount("/session", routes![create, update, delete, read])
        .mount("/sessions", routes![read_all])
        .launch();
}
