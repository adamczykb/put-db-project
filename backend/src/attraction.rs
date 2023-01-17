use crate::{
    language::Jezyk,
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct Atrakcja {
    pub id: i64,
    pub nazwa: String,
    pub adres: String,
    pub sezon: String,
    pub opis: String,
    pub koszt: i64,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct AtrakcjaBasic {
    pub id: i64,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefonu: String,
}
