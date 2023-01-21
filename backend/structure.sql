--
-- PostgreSQL database dump
--

-- dumped from database version 15.1 (debian 15.1-1.pgdg110+1)
-- dumped by pg_dump version 15.0

-- started on 2022-12-14 11:02:19

set statement_timeout = 0;
set lock_timeout = 0;
set idle_in_transaction_session_timeout = 0;
set client_encoding = 'utf8';
set standard_conforming_strings = on;
select pg_catalog.set_config('search_path', '', false);
set check_function_bodies = false;
set xmloption = content;
set client_min_messages = warning;
set row_security = off;

--
-- toc entry 265 (class 1255 oid 17098)
-- name: inflacja(integer); type: procedure; schema: public; owner: postgres
--

create procedure public.inflacja(in procenty integer)
    language plpgsql
    as $$
declare 
cnt integer:=(select max(id) from "podroz");
begin
  while cnt>0 loop
    update "podroz"
    set "cena"="cena"+"cena"*(procenty/100)
    where id=cnt;
  end loop;
  
end; 
$$;


alter procedure public.inflacja(in procenty integer) owner to postgres;

--
-- toc entry 264 (class 1255 oid 16735)
-- name: zysk_z_podrozy(bigint); type: function; schema: public; owner: postgres
--

create function public.zysk_z_podrozy(id bigint) returns numeric
    language plpgsql
    as $$
begin
return max(coalesce(
(select (select count(*) from "klient_podroz" as "kp" where kp."podroz_id"=id)* 
 (select (select sum(z."koszt")  from "zakwaterowanie_podroz"  zp left join "zakwaterowanie" as z on z."id" =zp."zakwaterowanie_id" where zp."podroz_id"=id  )+
  (select sum(a."koszt") from "podroz_atrakcja"  pa   left join "atrakcja" a on a."id" = pa."atrakcja_id" where pa."podroz_id"=id ) +
  (select sum(e."koszt")  from "etap_podroz"  ep   left join "etap" e on e."id" = ep."etap_id" where ep."podroz_id"=id )-
  (select sum(p."cena") from "podroz" as p where p."id" = id))), 0)); 
end;
$$;


alter function public.zysk_z_podrozy(id bigint) owner to postgres;

set default_tablespace = '';

set default_table_access_method = heap;

--
-- toc entry 214 (class 1259 oid 16736)
-- name: atrakcja; type: table; schema: public; owner: postgres
--

create table if not exists public."atrakcja" (
    "id" bigint not null,
    "nazwa" character varying(255) not null,
    "sezon" character varying(255)[] not null,
    "opis" text,
    "adres" character varying(255) not null,
    "koszt" bigint not null
);


alter table public."atrakcja" owner to postgres;

--
-- toc entry 215 (class 1259 oid 16741)
-- name: atrakcja_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."atrakcja" alter column "id" add generated always as identity (
    sequence name public."atrakcja_id_seq"
    start with 1
    increment by 1
    no minvalue
    maxvalue 9223372036854775806
    cache 1
);


--
-- toc entry 216 (class 1259 oid 16742)
-- name: atrakcja_przewodnik; type: table; schema: public; owner: postgres
--

create table if not exists public."atrakcja_przewodnik" (
    "atrakcja_id" bigint not null,
    "przewodnik_id" bigint not null,
    "id" bigint not null
);


alter table public."atrakcja_przewodnik" owner to postgres;

--
-- toc entry 243 (class 1259 oid 17099)
-- name: atrakcja_przewodnik_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."atrakcja_przewodnik" alter column "id" add generated always as identity (
    sequence name public."atrakcja_przewodnik_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 217 (class 1259 oid 16745)
-- name: etap; type: table; schema: public; owner: postgres
--

create table if not exists public."etap" (
    "id" bigint not null,
    "punkt_poczatkowy" character varying(255) not null,
    "punkt_konczowy" character varying(255) not null,
    "koszt" bigint not null,
    "data_poczatkowa" timestamp with time zone not null,
    "data_koncowa" timestamp with time zone not null
);


alter table public."etap" owner to postgres;

--
-- toc entry 218 (class 1259 oid 16750)
-- name: etap_id_seq; type: sequence; schema: public; owner: postgres
--

create sequence public."etap_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;


alter table public."etap_id_seq" owner to postgres;

--
-- toc entry 219 (class 1259 oid 16751)
-- name: etap_id_seq1; type: sequence; schema: public; owner: postgres
--

alter table public."etap" alter column "id" add generated always as identity (
    sequence name public."etap_id_seq1"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 220 (class 1259 oid 16752)
-- name: etap_podroz; type: table; schema: public; owner: postgres
--

create table if not exists public."etap_podroz" (
    "etap_id" bigint not null,
    "podroz_id" bigint not null,
    "id" bigint not null
);


alter table public."etap_podroz" owner to postgres;

--
-- toc entry 244 (class 1259 oid 17105)
-- name: etap_podroz_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."etap_podroz" alter column "id" add generated always as identity (
    sequence name public."etap_podroz_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 221 (class 1259 oid 16755)
-- name: firma_transportowa; type: table; schema: public; owner: postgres
--

create table if not exists public."firma_transportowa" (
    "id" bigint not null,
    "nazwa" character varying(255) not null,
    "telefon" character varying(12) not null,
    "adres" character varying(255) not null
);


alter table public."firma_transportowa" owner to postgres;

--
-- toc entry 222 (class 1259 oid 16760)
-- name: firma_transportowa_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."firma_transportowa" alter column "id" add generated always as identity (
    sequence name public."firma_transportowa_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 223 (class 1259 oid 16761)
-- name: jezyk; type: table; schema: public; owner: postgres
--

create table if not exists public."jezyk" (
    "kod" character varying(5) not null,
    "nazwa" character varying(255) not null
);


alter table public."jezyk" owner to postgres;

--
-- toc entry 224 (class 1259 oid 16764)
-- name: jezyk_pracownik; type: table; schema: public; owner: postgres
--

create table if not exists public."jezyk_pracownik" (
    "jezyk_kod" character varying(5) not null,
    "pracownik_id" bigint not null,
    "id" bigint not null
);


alter table public."jezyk_pracownik" owner to postgres;

--
-- toc entry 245 (class 1259 oid 17111)
-- name: jezyk_pracownik_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."jezyk_pracownik" alter column "id" add generated always as identity (
    sequence name public."jezyk_pracownik_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 225 (class 1259 oid 16767)
-- name: jezyk_przewodnik; type: table; schema: public; owner: postgres
--

create table if not exists public."jezyk_przewodnik" (
    "jezyk_kod" character varying(5) not null,
    "przewodnik_id" bigint not null,
    "id" bigint not null
);


alter table public."jezyk_przewodnik" owner to postgres;

--
-- toc entry 246 (class 1259 oid 17117)
-- name: jezyk_przewodnik_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."jezyk_przewodnik" alter column "id" add generated always as identity (
    sequence name public."jezyk_przewodnik_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 226 (class 1259 oid 16770)
-- name: klient; type: table; schema: public; owner: postgres
--

create table if not exists public."klient" (
    "pesel" bigint not null,
    "imie" character varying(255) not null,
    "nazwisko" character varying(255) not null,
    "adres" character varying(255) not null,
    "numer_telefonu" character varying(12) not null,
    "data_urodzenia" date not null
);


alter table public."klient" owner to postgres;

--
-- toc entry 227 (class 1259 oid 16775)
-- name: klient_podroz; type: table; schema: public; owner: postgres
--

create table if not exists public."klient_podroz" (
    "klient_pesel" bigint not null,
    "podroz_id" bigint not null,
    "id" bigint not null
);


alter table public."klient_podroz" owner to postgres;

--
-- toc entry 247 (class 1259 oid 17123)
-- name: klient_podroz_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."klient_podroz" alter column "id" add generated always as identity (
    sequence name public."klient_podroz_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 228 (class 1259 oid 16778)
-- name: podroz; type: table; schema: public; owner: postgres
--

create table if not exists public."podroz" (
    "id" bigint not null,
    "nazwa" character varying(255) not null,
    "data_rozpoczęcia" timestamp with time zone not null,
    "data_ukonczenia" timestamp with time zone not null,
    "opis" text,
    "cena" bigint not null
);


alter table public."podroz" owner to postgres;

--
-- toc entry 229 (class 1259 oid 16783)
-- name: podroz_atrakcja; type: table; schema: public; owner: postgres
--

create table if not exists public."podroz_atrakcja" (
    "podroz_id" bigint not null,
    "atrakcja_id" bigint not null,
    "id" bigint not null
);


alter table public."podroz_atrakcja" owner to postgres;

--
-- toc entry 248 (class 1259 oid 17129)
-- name: podroz_atrakcja_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."podroz_atrakcja" alter column "id" add generated always as identity (
    sequence name public."podroz_atrakcja_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 230 (class 1259 oid 16786)
-- name: podroz_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."podroz" alter column "id" add generated always as identity (
    sequence name public."podroz_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 231 (class 1259 oid 16787)
-- name: pracownik; type: table; schema: public; owner: postgres
--

create table if not exists public."pracownik" (
    "id" bigint not null,
    "imie" character varying(255) not null,
    "nazwisko" character varying(255) not null,
    "numer_telefon" character varying(12) not null,
    "adres" character varying(255) not null
);


alter table public."pracownik" owner to postgres;

--
-- toc entry 232 (class 1259 oid 16792)
-- name: pracownik_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."pracownik" alter column "id" add generated always as identity (
    sequence name public."pracownik_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 233 (class 1259 oid 16793)
-- name: pracownik_podroz; type: table; schema: public; owner: postgres
--

create table if not exists public."pracownik_podroz" (
    "pracownik_id" bigint not null,
    "podroz_id" bigint not null,
    "id" bigint not null
);


alter table public."pracownik_podroz" owner to postgres;

--
-- toc entry 249 (class 1259 oid 17135)
-- name: pracownik_podroz_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."pracownik_podroz" alter column "id" add generated always as identity (
    sequence name public."pracownik_podroz_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 234 (class 1259 oid 16796)
-- name: przewodnik; type: table; schema: public; owner: postgres
--

create table if not exists public."przewodnik" (
    "id" bigint not null,
    "imie" character varying(255) not null,
    "nazwisko" character varying(255) not null,
    "adres" character varying(255) not null,
    "numer_telefonu" character varying(12) not null
);


alter table public."przewodnik" owner to postgres;

--
-- toc entry 235 (class 1259 oid 16801)
-- name: przewodnik_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."przewodnik" alter column "id" add generated always as identity (
    sequence name public."przewodnik_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 236 (class 1259 oid 16802)
-- name: przewodnik_podroz; type: table; schema: public; owner: postgres
--

create table if not exists public."przewodnik_podroz" (
    "przewodnik_id" bigint not null,
    "podroz_id" bigint not null,
    "id" bigint not null
);


alter table public."przewodnik_podroz" owner to postgres;

--
-- toc entry 250 (class 1259 oid 17141)
-- name: przewodnik_podroz_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."przewodnik_podroz" alter column "id" add generated always as identity (
    sequence name public."przewodnik_podroz_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 237 (class 1259 oid 16805)
-- name: transport; type: table; schema: public; owner: postgres
--

create table if not exists public."transport" (
    "id" bigint not null,
    "nazwa" character varying(255) not null,
    "liczba_jednostek" bigint not null,
    "liczba_miejsc" bigint not null
);


alter table public."transport" owner to postgres;

--
-- toc entry 238 (class 1259 oid 16808)
-- name: transport_firma_transportowa; type: table; schema: public; owner: postgres
--

create table if not exists public."transport_firma_transportowa" (
    "transport_id" bigint not null,
    "firma_transportowa_id" bigint not null,
    "id" bigint not null
);


alter table public."transport_firma_transportowa" owner to postgres;

--
-- toc entry 251 (class 1259 oid 17147)
-- name: transport_firma_transportowa_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."transport_firma_transportowa" alter column "id" add generated always as identity (
    sequence name public."transport_firma_transportowa_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 239 (class 1259 oid 16811)
-- name: transport_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."transport" alter column "id" add generated always as identity (
    sequence name public."transport_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 240 (class 1259 oid 16812)
-- name: zakwaterowanie; type: table; schema: public; owner: postgres
--

create table if not exists public."zakwaterowanie" (
    "id" bigint not null,
    "nazwa" character varying(255) not null,
    "koszt" bigint, 
    "ilosc_miejsc" bigint,
    "standard_zakwaterowania" character varying(255) not null,
    "adres" character varying(255) not null
);


alter table public."zakwaterowanie" owner to postgres;

--
-- toc entry 241 (class 1259 oid 16817)
-- name: zakwaterowanie_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."zakwaterowanie" alter column "id" add generated always as identity (
    sequence name public."zakwaterowanie_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 242 (class 1259 oid 16818)
-- name: zakwaterowanie_podroz; type: table; schema: public; owner: postgres
--

create table if not exists public."zakwaterowanie_podroz" (
    "zakwaterowanie_id" bigint not null,
    "podroz_id" bigint not null,
    "id" bigint not null
);


alter table public."zakwaterowanie_podroz" owner to postgres;

--
-- toc entry 252 (class 1259 oid 17153)
-- name: zakwaterowanie_podroz_id_seq; type: sequence; schema: public; owner: postgres
--

alter table public."zakwaterowanie_podroz" alter column "id" add generated always as identity (
    sequence name public."zakwaterowanie_podroz_id_seq"
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1
);


--
-- toc entry 3514 (class 0 oid 16736)
-- dependencies: 214
-- data for name: atrakcja; type: table data; schema: public; owner: postgres
--





--
-- toc entry 3516 (class 0 oid 16742)
-- dependencies: 216
-- data for name: atrakcja_przewodnik; type: table data; schema: public; owner: postgres
--





--
-- toc entry 3517 (class 0 oid 16745)
-- dependencies: 217
-- data for name: etap; type: table data; schema: public; owner: postgres
--



--
-- toc entry 3520 (class 0 oid 16752)
-- dependencies: 220
-- data for name: etap_podroz; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3521 (class 0 oid 16755)
-- dependencies: 221
-- data for name: firma_transportowa; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3523 (class 0 oid 16761)
-- dependencies: 223
-- data for name: jezyk; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3524 (class 0 oid 16764)
-- dependencies: 224
-- data for name: jezyk_pracownik; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3525 (class 0 oid 16767)
-- dependencies: 225
-- data for name: jezyk_przewodnik; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3526 (class 0 oid 16770)
-- dependencies: 226
-- data for name: klient; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3527 (class 0 oid 16775)
-- dependencies: 227
-- data for name: klient_podroz; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3528 (class 0 oid 16778)
-- dependencies: 228
-- data for name: podroz; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3529 (class 0 oid 16783)
-- dependencies: 229
-- data for name: podroz_atrakcja; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3531 (class 0 oid 16787)
-- dependencies: 231
-- data for name: pracownik; type: table data; schema: public; owner: postgres
--




--
-- toc entry 3533 (class 0 oid 16793)
-- dependencies: 233
-- data for name: pracownik_podroz; type: table data; schema: public; owner: postgres
--



--
-- toc entry 3559 (class 0 oid 0)
-- dependencies: 215
-- name: atrakcja_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."atrakcja_id_seq"', 1, false);


--
-- toc entry 3560 (class 0 oid 0)
-- dependencies: 243
-- name: atrakcja_przewodnik_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."atrakcja_przewodnik_id_seq"', 1, false);


--
-- toc entry 3561 (class 0 oid 0)
-- dependencies: 218
-- name: etap_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."etap_id_seq"', 1, false);


--
-- toc entry 3562 (class 0 oid 0)
-- dependencies: 219
-- name: etap_id_seq1; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."etap_id_seq1"', 1, false);


--
-- toc entry 3563 (class 0 oid 0)
-- dependencies: 244
-- name: etap_podroz_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."etap_podroz_id_seq"', 1, false);


--
-- toc entry 3564 (class 0 oid 0)
-- dependencies: 222
-- name: firma_transportowa_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."firma_transportowa_id_seq"', 1, false);


--
-- toc entry 3565 (class 0 oid 0)
-- dependencies: 245
-- name: jezyk_pracownik_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."jezyk_pracownik_id_seq"', 1, false);


--
-- toc entry 3566 (class 0 oid 0)
-- dependencies: 246
-- name: jezyk_przewodnik_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."jezyk_przewodnik_id_seq"', 1, false);


--
-- toc entry 3567 (class 0 oid 0)
-- dependencies: 247
-- name: klient_podroz_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."klient_podroz_id_seq"', 1, false);


--
-- toc entry 3568 (class 0 oid 0)
-- dependencies: 248
-- name: podroz_atrakcja_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."podroz_atrakcja_id_seq"', 1, false);


--
-- toc entry 3569 (class 0 oid 0)
-- dependencies: 230
-- name: podroz_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."podroz_id_seq"', 1, true);


--
-- toc entry 3570 (class 0 oid 0)
-- dependencies: 232
-- name: pracownik_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."pracownik_id_seq"', 1, false);


--
-- toc entry 3571 (class 0 oid 0)
-- dependencies: 249
-- name: pracownik_podroz_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."pracownik_podroz_id_seq"', 1, false);


--
-- toc entry 3572 (class 0 oid 0)
-- dependencies: 235
-- name: przewodnik_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."przewodnik_id_seq"', 1, false);


--
-- toc entry 3573 (class 0 oid 0)
-- dependencies: 250
-- name: przewodnik_podroz_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."przewodnik_podroz_id_seq"', 1, false);


--
-- toc entry 3574 (class 0 oid 0)
-- dependencies: 251
-- name: transport_firma_transportowa_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."transport_firma_transportowa_id_seq"', 1, false);


--
-- toc entry 3575 (class 0 oid 0)
-- dependencies: 239
-- name: transport_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."transport_id_seq"', 1, false);


--
-- toc entry 3576 (class 0 oid 0)
-- dependencies: 241
-- name: zakwaterowanie_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."zakwaterowanie_id_seq"', 1, false);


--
-- toc entry 3577 (class 0 oid 0)
-- dependencies: 252
-- name: zakwaterowanie_podroz_id_seq; type: sequence set; schema: public; owner: postgres
--

select pg_catalog.setval('public."zakwaterowanie_podroz_id_seq"', 1, false);


--
-- toc entry 3273 (class 2606 oid 16822)
-- name: atrakcja atrakcja_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."atrakcja"
    add constraint "atrakcja_pkey" primary key ("id");


--
-- toc entry 3284 (class 2606 oid 17110)
-- name: etap_podroz etap_podroz_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."etap_podroz"
    add constraint "etap_podroz_pkey" primary key ("id");


--
-- toc entry 3280 (class 2606 oid 16824)
-- name: etap etap_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."etap"
    add constraint "etap_pkey" primary key ("id");


--
-- toc entry 3286 (class 2606 oid 16826)
-- name: firma_transportowa firma_transportowa_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."firma_transportowa"
    add constraint "firma_transportowa_pkey" primary key ("id");


--
-- toc entry 3292 (class 2606 oid 17116)
-- name: jezyk_pracownik jezyk_pracownik_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."jezyk_pracownik"
    add constraint "jezyk_pracownik_pkey" primary key ("id");


--
-- toc entry 3294 (class 2606 oid 17122)
-- name: jezyk_przewodnik jezyk_przewodnik_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."jezyk_przewodnik"
    add constraint "jezyk_przewodnik_pkey" primary key ("id");


--
-- toc entry 3290 (class 2606 oid 16828)
-- name: jezyk jezyk_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."jezyk"
    add constraint "jezyk_pkey" primary key ("kod");


--
-- toc entry 3299 (class 2606 oid 17128)
-- name: klient_podroz klient_podroz_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."klient_podroz"
    add constraint "klient_podroz_pkey" primary key ("id");


--
-- toc entry 3296 (class 2606 oid 16830)
-- name: klient klient_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."klient"
    add constraint "klient_pkey" primary key ("pesel");


--
-- toc entry 3305 (class 2606 oid 17134)
-- name: podroz_atrakcja podroz_atrakcja_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."podroz_atrakcja"
    add constraint "podroz_atrakcja_pkey" primary key ("id");


--
-- toc entry 3301 (class 2606 oid 16832)
-- name: podroz podroz_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."podroz"
    add constraint "podroz_pkey" primary key ("id");


--
-- toc entry 3311 (class 2606 oid 17140)
-- name: pracownik_podroz pracownik_podroz_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."pracownik_podroz"
    add constraint "pracownik_podroz_pkey" primary key ("id");


--
-- toc entry 3307 (class 2606 oid 16834)
-- name: pracownik pracownik_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."pracownik"
    add constraint "pracownik_pkey" primary key ("id");


--
-- toc entry 3317 (class 2606 oid 17146)
-- name: przewodnik_podroz przewodnik_podroz_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."przewodnik_podroz"
    add constraint "przewodnik_podroz_pkey" primary key ("id");


--
-- toc entry 3313 (class 2606 oid 16836)
-- name: przewodnik przewodnik_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."przewodnik"
    add constraint "przewodnik_pkey" primary key ("id");


--
-- toc entry 3323 (class 2606 oid 17152)
-- name: transport_firma_transportowa transport_firma_transportowa_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."transport_firma_transportowa"
    add constraint "transport_firma_transportowa_pkey" primary key ("id");


--
-- toc entry 3319 (class 2606 oid 16838)
-- name: transport transport_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."transport"
    add constraint "transport_pkey" primary key ("id");


--
-- toc entry 3329 (class 2606 oid 17158)
-- name: zakwaterowanie_podroz zakwaterowanie_podroz_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."zakwaterowanie_podroz"
    add constraint "zakwaterowanie_podroz_pkey" primary key ("id");


--
-- toc entry 3325 (class 2606 oid 16840)
-- name: zakwaterowanie zakwaterowanie_pkey; type: constraint; schema: public; owner: postgres
--

alter table only public."zakwaterowanie"
    add constraint "zakwaterowanie_pkey" primary key ("id");


--
-- toc entry 3278 (class 2606 oid 17104)
-- name: atrakcja_przewodnik pk_atrakcja_przewodnik; type: constraint; schema: public; owner: postgres
--

alter table only public."atrakcja_przewodnik"
    add constraint pk_atrakcja_przewodnik primary key ("id");


--
-- toc entry 3276 (class 2606 oid 17085)
-- name: atrakcja uniq_atrakcje; type: constraint; schema: public; owner: postgres
--

alter table only public."atrakcja"
    add constraint uniq_atrakcje unique ("nazwa", "adres");


--
-- toc entry 3282 (class 2606 oid 17083)
-- name: etap uniq_etapy; type: constraint; schema: public; owner: postgres
--

alter table only public."etap"
    add constraint uniq_etapy unique ("punkt_poczatkowy", "punkt_konczowy", "data_poczatkowa");


--
-- toc entry 3288 (class 2606 oid 17087)
-- name: firma_transportowa uniq_firma_transportowa; type: constraint; schema: public; owner: postgres
--

alter table only public."firma_transportowa"
    add constraint uniq_firma_transportowa unique ("nazwa", "adres");


--
-- toc entry 3303 (class 2606 oid 17089)
-- name: podroz uniq_podroz; type: constraint; schema: public; owner: postgres
--

alter table only public."podroz"
    add constraint uniq_podroz unique ("nazwa", "data_rozpoczęcia");


--
-- toc entry 3309 (class 2606 oid 17091)
-- name: pracownik uniq_pracownik; type: constraint; schema: public; owner: postgres
--

alter table only public."pracownik"
    add constraint uniq_pracownik unique ("imie", "nazwisko", "adres");


--
-- toc entry 3315 (class 2606 oid 17093)
-- name: przewodnik uniq_przewodnik; type: constraint; schema: public; owner: postgres
--

alter table only public."przewodnik"
    add constraint uniq_przewodnik unique ("imie", "nazwisko", "adres");


--
-- toc entry 3321 (class 2606 oid 17095)
-- name: transport uniq_transport; type: constraint; schema: public; owner: postgres
--

alter table only public."transport"
    add constraint uniq_transport unique ("nazwa", "liczba_jednostek", "liczba_miejsc");


--
-- toc entry 3327 (class 2606 oid 17097)
-- name: zakwaterowanie uniq_zakwaterowanie; type: constraint; schema: public; owner: postgres
--

alter table only public."zakwaterowanie"
    add constraint uniq_zakwaterowanie unique ("adres");


--
-- toc entry 3274 (class 1259 oid 16841)
-- name: nazwa_indx; type: index; schema: public; owner: postgres
--

create index "nazwa_indx" on public."atrakcja" using btree ("nazwa" text_pattern_ops);

alter table public."atrakcja" cluster on "nazwa_indx";


--
-- toc entry 3297 (class 1259 oid 16842)
-- name: nazwisko_indx; type: index; schema: public; owner: postgres
--

create index "nazwisko_indx" on public."klient" using btree ("nazwisko" varchar_ops);


--
-- toc entry 3330 (class 2606 oid 16843)
-- name: atrakcja_przewodnik atrakcja_przewodnik_atrakcja_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."atrakcja_przewodnik"
    add constraint "atrakcja_przewodnik_atrakcja_id_fkey" foreign key ("atrakcja_id") references public."atrakcja"("id") not valid;


--
-- toc entry 3331 (class 2606 oid 16848)
-- name: atrakcja_przewodnik atrakcja_przewodnik_atrakcja_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."atrakcja_przewodnik"
    add constraint "atrakcja_przewodnik_atrakcja_id_fkey1" foreign key ("atrakcja_id") references public."atrakcja"("id") not valid;


--
-- toc entry 3332 (class 2606 oid 16853)
-- name: atrakcja_przewodnik atrakcja_przewodnik_przewodnik_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."atrakcja_przewodnik"
    add constraint "atrakcja_przewodnik_przewodnik_id_fkey" foreign key ("przewodnik_id") references public."przewodnik"("id") not valid;


--
-- toc entry 3333 (class 2606 oid 16858)
-- name: atrakcja_przewodnik atrakcja_przewodnik_przewodnik_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."atrakcja_przewodnik"
    add constraint "atrakcja_przewodnik_przewodnik_id_fkey1" foreign key ("przewodnik_id") references public."przewodnik"("id") not valid;


--
-- toc entry 3334 (class 2606 oid 16863)
-- name: etap etap_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."etap"
    add constraint "etap_id_fkey" foreign key ("id") references public."transport"("id") not valid;


--
-- toc entry 3335 (class 2606 oid 16868)
-- name: etap etap_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."etap"
    add constraint "etap_id_fkey1" foreign key ("id") references public."transport"("id") not valid;


--
-- toc entry 3336 (class 2606 oid 16873)
-- name: etap_podroz etap_podroz_etap_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."etap_podroz"
    add constraint "etap_podroz_etap_id_fkey" foreign key ("etap_id") references public."etap"("id") not valid;


--
-- toc entry 3337 (class 2606 oid 16878)
-- name: etap_podroz etap_podroz_etap_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."etap_podroz"
    add constraint "etap_podroz_etap_id_fkey1" foreign key ("etap_id") references public."etap"("id") not valid;


--
-- toc entry 3338 (class 2606 oid 16883)
-- name: etap_podroz etap_podroz_podroz_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."etap_podroz"
    add constraint "etap_podroz_podroz_id_fkey" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3339 (class 2606 oid 16888)
-- name: etap_podroz etap_podroz_podroz_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."etap_podroz"
    add constraint "etap_podroz_podroz_id_fkey1" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3340 (class 2606 oid 16893)
-- name: jezyk_pracownik jezyk_pracownik_jezyk_kod_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."jezyk_pracownik"
    add constraint "jezyk_pracownik_jezyk_kod_fkey" foreign key ("jezyk_kod") references public."jezyk"("kod") not valid;


--
-- toc entry 3341 (class 2606 oid 16898)
-- name: jezyk_pracownik jezyk_pracownik_jezyk_kod_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."jezyk_pracownik"
    add constraint "jezyk_pracownik_jezyk_kod_fkey1" foreign key ("jezyk_kod") references public."jezyk"("kod") not valid;


--
-- toc entry 3342 (class 2606 oid 16903)
-- name: jezyk_pracownik jezyk_pracownik_pracownik_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."jezyk_pracownik"
    add constraint "jezyk_pracownik_pracownik_id_fkey" foreign key ("pracownik_id") references public."pracownik"("id") not valid;


--
-- toc entry 3343 (class 2606 oid 16908)
-- name: jezyk_pracownik jezyk_pracownik_pracownik_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."jezyk_pracownik"
    add constraint "jezyk_pracownik_pracownik_id_fkey1" foreign key ("pracownik_id") references public."pracownik"("id") not valid;


--
-- toc entry 3344 (class 2606 oid 16913)
-- name: jezyk_przewodnik jezyk_przewodnik_jezyk_kod_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."jezyk_przewodnik"
    add constraint "jezyk_przewodnik_jezyk_kod_fkey" foreign key ("jezyk_kod") references public."jezyk"("kod") not valid;


--
-- toc entry 3345 (class 2606 oid 16918)
-- name: jezyk_przewodnik jezyk_przewodnik_jezyk_kod_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."jezyk_przewodnik"
    add constraint "jezyk_przewodnik_jezyk_kod_fkey1" foreign key ("jezyk_kod") references public."jezyk"("kod") not valid;


--
-- toc entry 3346 (class 2606 oid 16923)
-- name: jezyk_przewodnik jezyk_przewodnik_przewodnik_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."jezyk_przewodnik"
    add constraint "jezyk_przewodnik_przewodnik_id_fkey" foreign key ("przewodnik_id") references public."przewodnik"("id") not valid;


--
-- toc entry 3347 (class 2606 oid 16928)
-- name: jezyk_przewodnik jezyk_przewodnik_przewodnik_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."jezyk_przewodnik"
    add constraint "jezyk_przewodnik_przewodnik_id_fkey1" foreign key ("przewodnik_id") references public."przewodnik"("id") not valid;


--
-- toc entry 3348 (class 2606 oid 16933)
-- name: klient_podroz klient_podroz_klient_pesel_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."klient_podroz"
    add constraint "klient_podroz_klient_pesel_fkey" foreign key ("klient_pesel") references public."klient"("pesel") not valid;


--
-- toc entry 3349 (class 2606 oid 16938)
-- name: klient_podroz klient_podroz_klient_pesel_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."klient_podroz"
    add constraint "klient_podroz_klient_pesel_fkey1" foreign key ("klient_pesel") references public."klient"("pesel") not valid;


--
-- toc entry 3350 (class 2606 oid 16943)
-- name: klient_podroz klient_podroz_podroz_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."klient_podroz"
    add constraint "klient_podroz_podroz_id_fkey" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3351 (class 2606 oid 16948)
-- name: klient_podroz klient_podroz_podroz_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."klient_podroz"
    add constraint "klient_podroz_podroz_id_fkey1" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3352 (class 2606 oid 16953)
-- name: podroz_atrakcja podroz_atrakcja_atrakcja_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."podroz_atrakcja"
    add constraint "podroz_atrakcja_atrakcja_id_fkey" foreign key ("atrakcja_id") references public."atrakcja"("id") not valid;


--
-- toc entry 3353 (class 2606 oid 16958)
-- name: podroz_atrakcja podroz_atrakcja_atrakcja_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."podroz_atrakcja"
    add constraint "podroz_atrakcja_atrakcja_id_fkey1" foreign key ("atrakcja_id") references public."atrakcja"("id") not valid;


--
-- toc entry 3354 (class 2606 oid 16963)
-- name: podroz_atrakcja podroz_atrakcja_podroz_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."podroz_atrakcja"
    add constraint "podroz_atrakcja_podroz_id_fkey" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3355 (class 2606 oid 16968)
-- name: podroz_atrakcja podroz_atrakcja_podroz_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."podroz_atrakcja"
    add constraint "podroz_atrakcja_podroz_id_fkey1" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3356 (class 2606 oid 16973)
-- name: pracownik_podroz pracownik_podroz_podroz_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."pracownik_podroz"
    add constraint "pracownik_podroz_podroz_id_fkey" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3357 (class 2606 oid 16978)
-- name: pracownik_podroz pracownik_podroz_podroz_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."pracownik_podroz"
    add constraint "pracownik_podroz_podroz_id_fkey1" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3358 (class 2606 oid 16983)
-- name: pracownik_podroz pracownik_podroz_pracownik_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."pracownik_podroz"
    add constraint "pracownik_podroz_pracownik_id_fkey" foreign key ("pracownik_id") references public."pracownik"("id") not valid;


--
-- toc entry 3359 (class 2606 oid 16988)
-- name: pracownik_podroz pracownik_podroz_pracownik_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."pracownik_podroz"
    add constraint "pracownik_podroz_pracownik_id_fkey1" foreign key ("pracownik_id") references public."pracownik"("id") not valid;


--
-- toc entry 3360 (class 2606 oid 16993)
-- name: przewodnik_podroz przewodnik_podroz_podroz_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."przewodnik_podroz"
    add constraint "przewodnik_podroz_podroz_id_fkey" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3361 (class 2606 oid 16998)
-- name: przewodnik_podroz przewodnik_podroz_podroz_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."przewodnik_podroz"
    add constraint "przewodnik_podroz_podroz_id_fkey1" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3362 (class 2606 oid 17003)
-- name: przewodnik_podroz przewodnik_podroz_przewodnik_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."przewodnik_podroz"
    add constraint "przewodnik_podroz_przewodnik_id_fkey" foreign key ("przewodnik_id") references public."przewodnik"("id") not valid;


--
-- toc entry 3363 (class 2606 oid 17008)
-- name: przewodnik_podroz przewodnik_podroz_przewodnik_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."przewodnik_podroz"
    add constraint "przewodnik_podroz_przewodnik_id_fkey1" foreign key ("przewodnik_id") references public."przewodnik"("id") not valid;


--
-- toc entry 3364 (class 2606 oid 17013)
-- name: transport_firma_transportowa transport_firma_transportowa_firma_transportowa_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."transport_firma_transportowa"
    add constraint "transport_firma_transportowa_firma_transportowa_id_fkey" foreign key ("firma_transportowa_id") references public."firma_transportowa"("id") not valid;


--
-- toc entry 3365 (class 2606 oid 17018)
-- name: transport_firma_transportowa transport_firma_transportowa_firma_transportowa_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."transport_firma_transportowa"
    add constraint "transport_firma_transportowa_firma_transportowa_id_fkey1" foreign key ("firma_transportowa_id") references public."firma_transportowa"("id") not valid;


--
-- toc entry 3366 (class 2606 oid 17023)
-- name: transport_firma_transportowa transport_firma_transportowa_transport_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."transport_firma_transportowa"
    add constraint "transport_firma_transportowa_transport_id_fkey" foreign key ("transport_id") references public."transport"("id") not valid;


--
-- toc entry 3367 (class 2606 oid 17028)
-- name: transport_firma_transportowa transport_firma_transportowa_transport_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."transport_firma_transportowa"
    add constraint "transport_firma_transportowa_transport_id_fkey1" foreign key ("transport_id") references public."transport"("id") not valid;


--
-- toc entry 3368 (class 2606 oid 17033)
-- name: zakwaterowanie_podroz zakwaterowanie_podroz_podroz_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."zakwaterowanie_podroz"
    add constraint "zakwaterowanie_podroz_podroz_id_fkey" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3369 (class 2606 oid 17038)
-- name: zakwaterowanie_podroz zakwaterowanie_podroz_podroz_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."zakwaterowanie_podroz"
    add constraint "zakwaterowanie_podroz_podroz_id_fkey1" foreign key ("podroz_id") references public."podroz"("id") not valid;


--
-- toc entry 3370 (class 2606 oid 17043)
-- name: zakwaterowanie_podroz zakwaterowanie_podroz_zakwaterowanie_id_fkey; type: fk constraint; schema: public; owner: postgres
--

alter table only public."zakwaterowanie_podroz"
    add constraint "zakwaterowanie_podroz_zakwaterowanie_id_fkey" foreign key ("zakwaterowanie_id") references public."zakwaterowanie"("id") not valid;


--
-- toc entry 3371 (class 2606 oid 17048)
-- name: zakwaterowanie_podroz zakwaterowanie_podroz_zakwaterowanie_id_fkey1; type: fk constraint; schema: public; owner: postgres
--

alter table only public."zakwaterowanie_podroz"
    add constraint "zakwaterowanie_podroz_zakwaterowanie_id_fkey1" foreign key ("zakwaterowanie_id") references public."zakwaterowanie"("id") not valid;


--
-- toc entry 3558 (class 0 oid 0)
-- dependencies: 5
-- name: schema public; type: acl; schema: -; owner: pg_database_owner
--

grant all on schema public to postgres;


-- completed on 2022-12-14 11:02:19

--
-- postgresql database dump complete
--

