use diesel;
use diesel::prelude::*;
use diesel::mysql::MysqlConnection;
use crate::schema::sessions;
#[table_name = "sessions"]
#[derive(Serialize, Deserialize, Queryable, Insertable, AsChangeset, Clone)]
pub struct Session {
    pub id: Option<i32>,
    pub start_at: i32,
    pub start_on: i32,
    pub paused: bool
}

impl Session {
    pub fn create(session: Session, connection: &MysqlConnection) -> Session {
        diesel::insert_into(sessions::table)
            .values(&session)
            .execute(connection)
            .expect("Error creating new hero");

        sessions::table.order(sessions::id.desc()).first(connection).unwrap()
    }

    pub fn read_all(connection: &MysqlConnection) -> Vec<Session> {
        sessions::table.order(sessions::id).load::<Session>(connection).unwrap()
    }

    pub fn read(connection: &MysqlConnection, sess_id: i32) -> Vec<Session> {
        sessions::table.find(sess_id).load::<Session>(connection).unwrap()
    }

    pub fn update(id: i32, session: Session, connection: &MysqlConnection) -> bool {
        diesel::update(sessions::table.find(id)).set(&session).execute(connection).is_ok()
    }

    pub fn is_paused(connection: &MysqlConnection, id: i32) -> Vec<Session> {
        sessions::table.find(id).load::<Session>(connection).unwrap()
    }

    pub fn delete(id: i32, connection: &MysqlConnection) -> bool {
        diesel::delete(sessions::table.find(id)).execute(connection).is_ok()
    }
}
