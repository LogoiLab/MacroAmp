#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
#[macro_use] extern crate rocket_contrib;
#[macro_use] extern crate serde_derive;
extern crate rand;

#[cfg(test)] mod tests;

use std::sync::Mutex;
use std::collections::HashMap;
use std::time::{SystemTime, UNIX_EPOCH};

use rand::{thread_rng, Rng};
use rocket::State;
use rocket_contrib::json::{Json, JsonValue};

// The type to represent the ID of a message.
type ID = usize;

// We're going to store all of the messages here. No need for a DB.
type ReqMap = Mutex<HashMap<ID, String>>;
type SessionMap = Mutex<HashMap<ID, Session>>;
type Epoch = u64;

#[derive(Serialize, Deserialize)]
struct Req {
    id: Option<ID>,
    contents: String
}

#[derive(Serialize, Deserialize, Clone)]
struct Session {
    id: ID,
    start_at: Option<u64>,

}

// TODO: This example can be improved by using `route` with multiple HTTP verbs.
#[post("/<id>", format = "json", data = "<req>")]
fn new(id: ID, req: Json<Req>, map: State<ReqMap>) -> JsonValue {
    let mut hashmap = map.lock().expect("map lock.");
    if hashmap.contains_key(&id) {
        json!({
            "status": "error",
            "reason": "ID exists. Try put."
        })
    } else {
        hashmap.insert(id, req.0.contents);
        json!({ "status": "ok" })
    }
}

#[put("/<id>", format = "json", data = "<req>")]
fn update(id: ID, req: Json<Req>, map: State<ReqMap>) -> Option<JsonValue> {
    let mut hashmap = map.lock().unwrap();
    if hashmap.contains_key(&id) {
        hashmap.insert(id, req.0.contents);
        Some(json!({ "status": "ok" }))
    } else {
        None
    }
}

#[get("/<id>", format = "json")]
fn join(id: ID, map: State<ReqMap>) -> Option<Json<Req>> {
    let hashmap = map.lock().unwrap();
    hashmap.get(&id).map(|contents| {
        Json(Req {
            id: Some(id),
            contents: contents.clone()
        })
    })
}

#[post("/new_session")]
fn new_session(map: State<SessionMap>) -> JsonValue {
    let mut hashmap = map.lock().unwrap();
    let sess: Session = gen_session();
    hashmap.insert(sess.id, sess.clone());
    json!({"id": sess.id})
}

fn gen_session() -> Session {
    let mut rng = thread_rng();
    let id: usize = rng.gen_range(0, 999999);
    Session{id: id, start_at: None}
}

#[catch(404)]
fn not_found() -> JsonValue {
    json!({
        "code": "404",
        "status": "error",
        "reason": "Resource was not found."
    })
}

#[catch(500)]
fn server_error() -> JsonValue {
    json!({
        "code": "500",
        "status": "error",
        "reason": "Internal server error."
    })
}

fn rocket() -> rocket::Rocket {
    rocket::ignite()
        .mount("/req", routes![new, update, join, new_session])
        .register(catchers![not_found, server_error])
        .manage(Mutex::new(HashMap::<ID, String>::new()))
}

fn main() {
    rocket().launch();
}
