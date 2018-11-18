#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
#[macro_use] extern crate rocket_contrib;
#[macro_use] extern crate serde_derive;
extern crate rand;
#[cfg(test)] mod tests;

use std::sync::Mutex;
use std::collections::HashMap;
use std::time::{SystemTime, UNIX_EPOCH};

//use rand::{thread_rng, Rng};
use rocket::State;
use rocket_contrib::json::{Json, JsonValue};


// The type to represent the ID of a message.
type ID = usize;

// We're going to store all of the messages here. No need for a DB.
type SessionMap = Mutex<HashMap<ID, Session>>;
type Epoch = u64;

#[derive(Serialize, Deserialize, Clone)]
struct Session {
    id: ID,
    start_at: Option<u64>,
    data: Option<String>

}

// TODO: This example can be improved by using `route` with multiple HTTP verbs.

#[put("/<id>", format = "json", data = "<req>")]
fn update(id: ID, req: Json<Session>, map: State<SessionMap>) -> Option<JsonValue> {
    let mut hashmap = map.lock().unwrap();
    if hashmap.contains_key(&id.clone()) {
        hashmap.insert(id.clone(), req.0);
        let mut updated: Session = Session{id: 0, start_at: None, data: None};
        hashmap.get(&id.clone()).clone().map(|sess| {
            let old_sess = sess.clone();
            updated = Session{id: old_sess.id, start_at: Some(SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs() + 5), data: old_sess.data};
        });
        hashmap.insert(id.clone(), updated);
        Some(json!({
            "code": "200",
            "status": "ok"
        }))
    } else {
        None
    }
}

#[get("/<id>", format = "json")]
fn join(id: ID, map: State<SessionMap>) -> Option<Json<Session>> {
    let mut hashmap = map.lock().unwrap();
    let mut updated: Session = Session{id: 0, start_at: None, data: None};
    hashmap.get(&id.clone()).clone().map(|sess| {
        let old_sess = sess.clone();
        updated = Session{id: old_sess.id, start_at: Some(SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs() + 5), data: old_sess.data};
    });
    hashmap.insert(id.clone(), updated);
    hashmap.get(&id.clone()).map(|session| {
        Json(Session {
            id: session.id,
            start_at: session.start_at,
            data: session.data
        })
    })
}

#[post("/<id>", format = "json", data = "<req>")]
fn new_session(id: ID, req: Json<Session>, map: State<SessionMap>) -> JsonValue {
    let mut hashmap = map.lock().unwrap();
    hashmap.insert(id.clone(), req.0);
    let mut updated: Session = Session{id: 0, start_at: None, data: None};
    hashmap.get(&id.clone()).clone().map(|sess| {
        let old_sess = sess.clone();
        updated = Session{id: old_sess.id, start_at: Some(SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs() + 5), data: old_sess.data};
    });
    hashmap.insert(id.clone(), updated);
    json!({
        "code": "200",
        "status": "ok"
    })
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
        .mount("/req", routes![update, join, new_session])
        .register(catchers![not_found, server_error])
        .manage(Mutex::new(HashMap::<ID, Session>::new()))
}

fn main() {
    rocket().launch();
}
