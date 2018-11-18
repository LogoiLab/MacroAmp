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
use rocket::data::Data;
use rocket::Outcome;
use rocket::http::Status;
use rocket::request::{self, Request, FromRequest};

use std::io;
use std::path::{Path, PathBuf};
use std::fs::remove_file;

use rocket::response::NamedFile;

#[allow(proc_macro_derive_resolution_fallback)]

struct ID(String);

#[derive(Debug)]
enum IDError {
    BadCount,
    Missing,
    Invalid,
}

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
fn is_paused(id: i32, connection: db::Connection) -> Json<Value> {
    let sessions: Vec<Session> = Session::is_paused(&connection, id);
    let pause: String = format!("{}", sessions[0].paused);
    Json(json!(pause))
}


#[get("/<id>")]
fn read(id: i32, connection: db::Connection) -> Json<Value> {
    Json(json!(Session::read(&connection, id)))
}

#[post("/<id>", format = "application/json", data = "<session>")]
fn update(id: i32, session: Json<Session>, connection: db::Connection) -> Json<Value> {
    let update = Session { id: Some(id), ..session.into_inner() };
    Json(json!({
        "success": Session::update(id, update, &connection)
    }))
}

#[delete("/<id>")]
fn delete(id: i32, connection: db::Connection) -> Json<Value> {
    remove_file(format!("./static/{}.mp3", &id)).unwrap();
    Json(json!({
        "success": Session::delete(id, &connection)
    }))
}

#[post("/upload", format = "text/plain", data = "<data>")]
fn upload(data: Data, sess_id: ID) -> std::io::Result<String> {
    let path: String = format!("./static/{}.mp3", sess_id.0);
    data.stream_to_file(path).map(|n| n.to_string())
}

fn is_valid(key: &str) -> bool {
    key.len() <= 6
}

impl<'a, 'r> FromRequest<'a, 'r> for ID {
    type Error = IDError;

    fn from_request(request: &'a Request<'r>) -> request::Outcome<Self, Self::Error> {
        let keys: Vec<_> = request.headers().get("sess_id").collect();
        match keys.len() {
            0 => Outcome::Failure((Status::BadRequest, IDError::Missing)),
            1 if is_valid(keys[0]) => Outcome::Success(ID(keys[0].to_string())),
            1 => Outcome::Failure((Status::BadRequest, IDError::Invalid)),
            _ => Outcome::Failure((Status::BadRequest, IDError::BadCount)),
        }
    }
}

#[get("/<file..>")]
fn files(file: PathBuf) -> Option<NamedFile> {
    NamedFile::open(Path::new("./static/").join(file)).ok()
}

fn main() {
    rocket::ignite()
        .manage(db::connect())
        .mount("/session", routes![create, update, delete, read, upload])
        .mount("/sessions", routes![read_all])
        .mount("/static", routes![files])
        .mount("/status", routes![is_paused])
        .launch();
}
