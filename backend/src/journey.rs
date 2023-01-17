use crate::{
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct PodrozBasic {
    pub id: i64,
    pub nazwa: String,
    pub cena: String,
    pub data_rozpoczecia: String,
    pub data_ukonczenia: String,
    pub opis: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct Podroz {
    pub id: i64,
    pub nazwa: String,
    pub cena: String,
    pub data_rozpoczecia: String,
    pub data_ukonczenia: String,
    pub opis: String,
}
