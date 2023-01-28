--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.1

-- Started on 2023-01-28 19:50:46 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--




ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 252 (class 1255 OID 16954)
-- Name: inflacja(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inflacja(IN procenty integer)
    LANGUAGE plpgsql
    AS $$
declare 
cnt integer:=(select max(id) from "podroz");
begin
    update podroz
    set cena=cena*(100+procenty/100) ;
end; 
$$;


ALTER PROCEDURE public.inflacja(IN procenty integer) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 17435)
-- Name: zysk_z_podrozy(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.zysk_z_podrozy(call_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
begin
return coalesce(
(select (select count(*) from "klient_podroz" as "kp" where kp."podroz_id"=call_id)* 
 ( (select sum(p."cena") from "podroz" as p where p."id" = call_id)+(select * from coalesce((select sum(z."koszt")  from "zakwaterowanie_podroz"  zp  join "zakwaterowanie" as z on z."id" =zp."zakwaterowanie_id" where zp."podroz_id"=call_id),0))-
  (select * from coalesce((select sum(a."koszt") from "podroz_atrakcja"  pa    join "atrakcja" a on a."id" = pa."atrakcja_id" where pa."podroz_id"=call_id ),0)) -
  (select * from coalesce((select sum(e."koszt")  from "etap" e join "etap_podroz" ep on ep."etap_id"=e."id"  where ep."podroz_id"=call_id ),0))
 )),0); 
end;

$$;


ALTER FUNCTION public.zysk_z_podrozy(call_id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16956)
-- Name: atrakcja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atrakcja (
    id bigint NOT NULL,
    nazwa character varying(255) NOT NULL,
    sezon character varying(255)[] NOT NULL,
    opis text,
    adres character varying(255) NOT NULL,
    koszt bigint NOT NULL
);


ALTER TABLE public.atrakcja OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16961)
-- Name: atrakcja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.atrakcja ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.atrakcja_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 16962)
-- Name: atrakcja_przewodnik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atrakcja_przewodnik (
    atrakcja_id bigint NOT NULL,
    przewodnik_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.atrakcja_przewodnik OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16965)
-- Name: atrakcja_przewodnik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.atrakcja_przewodnik ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.atrakcja_przewodnik_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 16966)
-- Name: etap; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.etap (
    id bigint NOT NULL,
    punkt_poczatkowy character varying(255) NOT NULL,
    punkt_konczowy character varying(255) NOT NULL,
    koszt bigint NOT NULL,
    data_poczatkowa timestamp with time zone NOT NULL,
    data_koncowa timestamp with time zone NOT NULL
);


ALTER TABLE public.etap OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16971)
-- Name: etap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.etap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.etap_id_seq OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16972)
-- Name: etap_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.etap ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.etap_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 16973)
-- Name: etap_podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.etap_podroz (
    etap_id bigint NOT NULL,
    podroz_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.etap_podroz OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16976)
-- Name: etap_podroz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.etap_podroz ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.etap_podroz_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 16977)
-- Name: firma_transportowa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.firma_transportowa (
    id bigint NOT NULL,
    nazwa character varying(255) NOT NULL,
    telefon character varying(12) NOT NULL,
    adres character varying(255) NOT NULL
);


ALTER TABLE public.firma_transportowa OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16982)
-- Name: firma_transportowa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.firma_transportowa ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.firma_transportowa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 16983)
-- Name: jezyk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jezyk (
    kod character varying(5) NOT NULL,
    nazwa character varying(255) NOT NULL
);


ALTER TABLE public.jezyk OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16986)
-- Name: jezyk_pracownik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jezyk_pracownik (
    jezyk_kod character varying(5) NOT NULL,
    pracownik_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.jezyk_pracownik OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16989)
-- Name: jezyk_pracownik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.jezyk_pracownik ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.jezyk_pracownik_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16990)
-- Name: jezyk_przewodnik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jezyk_przewodnik (
    jezyk_kod character varying(5) NOT NULL,
    przewodnik_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.jezyk_przewodnik OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16993)
-- Name: jezyk_przewodnik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.jezyk_przewodnik ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.jezyk_przewodnik_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 249 (class 1259 OID 17385)
-- Name: klient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klient (
    pesel character varying(255) NOT NULL,
    imie character varying(255) NOT NULL,
    nazwisko character varying(255) NOT NULL,
    adres character varying(255) NOT NULL,
    numer_telefonu character varying(12) NOT NULL,
    data_urodzenia date NOT NULL
);


ALTER TABLE public.klient OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17395)
-- Name: klient_podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klient_podroz (
    klient_pesel character varying(255) NOT NULL,
    podroz_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.klient_podroz OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17394)
-- Name: klient_podroz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.klient_podroz ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.klient_podroz_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 17003)
-- Name: podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.podroz (
    id bigint NOT NULL,
    nazwa character varying(255) NOT NULL,
    data_rozpoczecia timestamp with time zone NOT NULL,
    data_ukonczenia timestamp with time zone NOT NULL,
    opis character varying(1000),
    cena bigint NOT NULL
);


ALTER TABLE public.podroz OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17008)
-- Name: podroz_atrakcja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.podroz_atrakcja (
    podroz_id bigint NOT NULL,
    atrakcja_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.podroz_atrakcja OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17011)
-- Name: podroz_atrakcja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.podroz_atrakcja ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.podroz_atrakcja_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 17012)
-- Name: podroz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.podroz ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.podroz_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 17013)
-- Name: pracownik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pracownik (
    id bigint NOT NULL,
    imie character varying(255) NOT NULL,
    nazwisko character varying(255) NOT NULL,
    numer_telefon character varying(12) NOT NULL,
    adres character varying(255) NOT NULL
);


ALTER TABLE public.pracownik OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17018)
-- Name: pracownik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pracownik ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pracownik_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 17019)
-- Name: pracownik_podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pracownik_podroz (
    pracownik_id bigint NOT NULL,
    podroz_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.pracownik_podroz OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17022)
-- Name: pracownik_podroz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pracownik_podroz ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pracownik_podroz_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 17023)
-- Name: przewodnik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.przewodnik (
    id bigint NOT NULL,
    imie character varying(255) NOT NULL,
    nazwisko character varying(255) NOT NULL,
    adres character varying(255) NOT NULL,
    numer_telefonu character varying(12) NOT NULL
);


ALTER TABLE public.przewodnik OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17028)
-- Name: przewodnik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.przewodnik ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.przewodnik_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 17029)
-- Name: przewodnik_podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.przewodnik_podroz (
    przewodnik_id bigint NOT NULL,
    podroz_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.przewodnik_podroz OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17032)
-- Name: przewodnik_podroz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.przewodnik_podroz ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.przewodnik_podroz_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 17033)
-- Name: transport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transport (
    id bigint NOT NULL,
    nazwa character varying(255) NOT NULL,
    liczba_jednostek bigint NOT NULL,
    liczba_miejsc bigint NOT NULL
);


ALTER TABLE public.transport OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17036)
-- Name: transport_firma_transportowa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transport_firma_transportowa (
    transport_id bigint NOT NULL,
    firma_transportowa_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.transport_firma_transportowa OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 17039)
-- Name: transport_firma_transportowa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.transport_firma_transportowa ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.transport_firma_transportowa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 245 (class 1259 OID 17041)
-- Name: zakwaterowanie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zakwaterowanie (
    id bigint NOT NULL,
    nazwa character varying(255) NOT NULL,
    koszt bigint,
    ilosc_miejsc bigint,
    standard_zakwaterowania character varying(255) NOT NULL,
    adres character varying(255) NOT NULL
);


ALTER TABLE public.zakwaterowanie OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 17046)
-- Name: zakwaterowanie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.zakwaterowanie ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.zakwaterowanie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 247 (class 1259 OID 17047)
-- Name: zakwaterowanie_podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zakwaterowanie_podroz (
    zakwaterowanie_id bigint NOT NULL,
    podroz_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.zakwaterowanie_podroz OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 17050)
-- Name: zakwaterowanie_podroz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.zakwaterowanie_podroz ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.zakwaterowanie_podroz_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3509 (class 0 OID 16956)
-- Dependencies: 214
-- Data for Name: atrakcja; Type: TABLE DATA; Schema: public; Owner: postgres
--




--
-- TOC entry 3511 (class 0 OID 16962)
-- Dependencies: 216
-- Data for Name: atrakcja_przewodnik; Type: TABLE DATA; Schema: public; Owner: postgres
--




--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 215
-- Name: atrakcja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.atrakcja_id_seq', 11, true);


--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 217
-- Name: atrakcja_przewodnik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.atrakcja_przewodnik_id_seq', 93, true);


--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 219
-- Name: etap_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etap_id_seq', 1, false);


--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 220
-- Name: etap_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etap_id_seq1', 54, true);


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 222
-- Name: etap_podroz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etap_podroz_id_seq', 14, true);


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 224
-- Name: firma_transportowa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.firma_transportowa_id_seq', 7, true);


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 227
-- Name: jezyk_pracownik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jezyk_pracownik_id_seq', 24, true);


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 229
-- Name: jezyk_przewodnik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jezyk_przewodnik_id_seq', 39, true);


--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 250
-- Name: klient_podroz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.klient_podroz_id_seq', 16, true);


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 232
-- Name: podroz_atrakcja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.podroz_atrakcja_id_seq', 51, true);


--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 233
-- Name: podroz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.podroz_id_seq', 10, true);


--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 235
-- Name: pracownik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pracownik_id_seq', 4, true);


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 237
-- Name: pracownik_podroz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pracownik_podroz_id_seq', 44, true);


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 239
-- Name: przewodnik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.przewodnik_id_seq', 21, true);


--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 241
-- Name: przewodnik_podroz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.przewodnik_podroz_id_seq', 68, true);


--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 244
-- Name: transport_firma_transportowa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transport_firma_transportowa_id_seq', 14, true);


--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 246
-- Name: zakwaterowanie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zakwaterowanie_id_seq', 6, true);


--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 248
-- Name: zakwaterowanie_podroz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zakwaterowanie_podroz_id_seq', 12, true);


--
-- TOC entry 3272 (class 2606 OID 17052)
-- Name: atrakcja atrakcja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atrakcja
    ADD CONSTRAINT atrakcja_pkey PRIMARY KEY (id);


--
-- TOC entry 3279 (class 2606 OID 17056)
-- Name: etap etap_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etap
    ADD CONSTRAINT etap_pkey PRIMARY KEY (id);


--
-- TOC entry 3283 (class 2606 OID 17054)
-- Name: etap_podroz etap_podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etap_podroz
    ADD CONSTRAINT etap_podroz_pkey PRIMARY KEY (id);


--
-- TOC entry 3285 (class 2606 OID 17058)
-- Name: firma_transportowa firma_transportowa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firma_transportowa
    ADD CONSTRAINT firma_transportowa_pkey PRIMARY KEY (id);


--
-- TOC entry 3289 (class 2606 OID 17064)
-- Name: jezyk jezyk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk
    ADD CONSTRAINT jezyk_pkey PRIMARY KEY (kod);


--
-- TOC entry 3291 (class 2606 OID 17060)
-- Name: jezyk_pracownik jezyk_pracownik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_pracownik
    ADD CONSTRAINT jezyk_pracownik_pkey PRIMARY KEY (id);


--
-- TOC entry 3293 (class 2606 OID 17062)
-- Name: jezyk_przewodnik jezyk_przewodnik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_przewodnik
    ADD CONSTRAINT jezyk_przewodnik_pkey PRIMARY KEY (id);


--
-- TOC entry 3325 (class 2606 OID 17391)
-- Name: klient klient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klient
    ADD CONSTRAINT klient_pkey PRIMARY KEY (pesel);


--
-- TOC entry 3328 (class 2606 OID 17399)
-- Name: klient_podroz klient_podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klient_podroz
    ADD CONSTRAINT klient_podroz_pkey PRIMARY KEY (id);


--
-- TOC entry 3277 (class 2606 OID 17090)
-- Name: atrakcja_przewodnik pk_atrakcja_przewodnik; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atrakcja_przewodnik
    ADD CONSTRAINT pk_atrakcja_przewodnik PRIMARY KEY (id);


--
-- TOC entry 3299 (class 2606 OID 17070)
-- Name: podroz_atrakcja podroz_atrakcja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.podroz_atrakcja
    ADD CONSTRAINT podroz_atrakcja_pkey PRIMARY KEY (id);


--
-- TOC entry 3295 (class 2606 OID 17072)
-- Name: podroz podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.podroz
    ADD CONSTRAINT podroz_pkey PRIMARY KEY (id);


--
-- TOC entry 3301 (class 2606 OID 17076)
-- Name: pracownik pracownik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownik
    ADD CONSTRAINT pracownik_pkey PRIMARY KEY (id);


--
-- TOC entry 3305 (class 2606 OID 17074)
-- Name: pracownik_podroz pracownik_podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownik_podroz
    ADD CONSTRAINT pracownik_podroz_pkey PRIMARY KEY (id);


--
-- TOC entry 3307 (class 2606 OID 17080)
-- Name: przewodnik przewodnik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przewodnik
    ADD CONSTRAINT przewodnik_pkey PRIMARY KEY (id);


--
-- TOC entry 3311 (class 2606 OID 17078)
-- Name: przewodnik_podroz przewodnik_podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przewodnik_podroz
    ADD CONSTRAINT przewodnik_podroz_pkey PRIMARY KEY (id);


--
-- TOC entry 3317 (class 2606 OID 17082)
-- Name: transport_firma_transportowa transport_firma_transportowa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport_firma_transportowa
    ADD CONSTRAINT transport_firma_transportowa_pkey PRIMARY KEY (id);


--
-- TOC entry 3313 (class 2606 OID 17084)
-- Name: transport transport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport
    ADD CONSTRAINT transport_pkey PRIMARY KEY (id);


--
-- TOC entry 3275 (class 2606 OID 17092)
-- Name: atrakcja uniq_atrakcje; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atrakcja
    ADD CONSTRAINT uniq_atrakcje UNIQUE (nazwa, adres);


--
-- TOC entry 3281 (class 2606 OID 17094)
-- Name: etap uniq_etapy; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etap
    ADD CONSTRAINT uniq_etapy UNIQUE (punkt_poczatkowy, punkt_konczowy, data_poczatkowa);


--
-- TOC entry 3287 (class 2606 OID 17096)
-- Name: firma_transportowa uniq_firma_transportowa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firma_transportowa
    ADD CONSTRAINT uniq_firma_transportowa UNIQUE (nazwa, adres);


--
-- TOC entry 3297 (class 2606 OID 17098)
-- Name: podroz uniq_podroz; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.podroz
    ADD CONSTRAINT uniq_podroz UNIQUE (nazwa, data_rozpoczecia);


--
-- TOC entry 3303 (class 2606 OID 17100)
-- Name: pracownik uniq_pracownik; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownik
    ADD CONSTRAINT uniq_pracownik UNIQUE (imie, nazwisko, adres);


--
-- TOC entry 3309 (class 2606 OID 17102)
-- Name: przewodnik uniq_przewodnik; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przewodnik
    ADD CONSTRAINT uniq_przewodnik UNIQUE (imie, nazwisko, adres);


--
-- TOC entry 3315 (class 2606 OID 17104)
-- Name: transport uniq_transport; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport
    ADD CONSTRAINT uniq_transport UNIQUE (nazwa, liczba_jednostek, liczba_miejsc);


--
-- TOC entry 3319 (class 2606 OID 17106)
-- Name: zakwaterowanie uniq_zakwaterowanie; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zakwaterowanie
    ADD CONSTRAINT uniq_zakwaterowanie UNIQUE (adres);


--
-- TOC entry 3321 (class 2606 OID 17088)
-- Name: zakwaterowanie zakwaterowanie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zakwaterowanie
    ADD CONSTRAINT zakwaterowanie_pkey PRIMARY KEY (id);


--
-- TOC entry 3323 (class 2606 OID 17086)
-- Name: zakwaterowanie_podroz zakwaterowanie_podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zakwaterowanie_podroz
    ADD CONSTRAINT zakwaterowanie_podroz_pkey PRIMARY KEY (id);


--
-- TOC entry 3273 (class 1259 OID 17107)
-- Name: nazwa_indx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nazwa_indx ON public.atrakcja USING btree (nazwa text_pattern_ops);

ALTER TABLE public.atrakcja CLUSTER ON nazwa_indx;


--
-- TOC entry 3326 (class 1259 OID 17392)
-- Name: nazwisko_indx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nazwisko_indx ON public.klient USING btree (nazwisko varchar_ops);


--
-- TOC entry 3329 (class 2606 OID 17109)
-- Name: atrakcja_przewodnik atrakcja_przewodnik_atrakcja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atrakcja_przewodnik
    ADD CONSTRAINT atrakcja_przewodnik_atrakcja_id_fkey FOREIGN KEY (atrakcja_id) REFERENCES public.atrakcja(id) NOT VALID;


--
-- TOC entry 3330 (class 2606 OID 17114)
-- Name: atrakcja_przewodnik atrakcja_przewodnik_atrakcja_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atrakcja_przewodnik
    ADD CONSTRAINT atrakcja_przewodnik_atrakcja_id_fkey1 FOREIGN KEY (atrakcja_id) REFERENCES public.atrakcja(id) NOT VALID;


--
-- TOC entry 3331 (class 2606 OID 17119)
-- Name: atrakcja_przewodnik atrakcja_przewodnik_przewodnik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atrakcja_przewodnik
    ADD CONSTRAINT atrakcja_przewodnik_przewodnik_id_fkey FOREIGN KEY (przewodnik_id) REFERENCES public.przewodnik(id) NOT VALID;


--
-- TOC entry 3332 (class 2606 OID 17124)
-- Name: atrakcja_przewodnik atrakcja_przewodnik_przewodnik_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atrakcja_przewodnik
    ADD CONSTRAINT atrakcja_przewodnik_przewodnik_id_fkey1 FOREIGN KEY (przewodnik_id) REFERENCES public.przewodnik(id) NOT VALID;


--
-- TOC entry 3333 (class 2606 OID 17139)
-- Name: etap_podroz etap_podroz_etap_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etap_podroz
    ADD CONSTRAINT etap_podroz_etap_id_fkey FOREIGN KEY (etap_id) REFERENCES public.etap(id) NOT VALID;


--
-- TOC entry 3334 (class 2606 OID 17144)
-- Name: etap_podroz etap_podroz_etap_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etap_podroz
    ADD CONSTRAINT etap_podroz_etap_id_fkey1 FOREIGN KEY (etap_id) REFERENCES public.etap(id) NOT VALID;


--
-- TOC entry 3335 (class 2606 OID 17149)
-- Name: etap_podroz etap_podroz_podroz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etap_podroz
    ADD CONSTRAINT etap_podroz_podroz_id_fkey FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3336 (class 2606 OID 17154)
-- Name: etap_podroz etap_podroz_podroz_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etap_podroz
    ADD CONSTRAINT etap_podroz_podroz_id_fkey1 FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3337 (class 2606 OID 17159)
-- Name: jezyk_pracownik jezyk_pracownik_jezyk_kod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_pracownik
    ADD CONSTRAINT jezyk_pracownik_jezyk_kod_fkey FOREIGN KEY (jezyk_kod) REFERENCES public.jezyk(kod) NOT VALID;


--
-- TOC entry 3338 (class 2606 OID 17164)
-- Name: jezyk_pracownik jezyk_pracownik_jezyk_kod_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_pracownik
    ADD CONSTRAINT jezyk_pracownik_jezyk_kod_fkey1 FOREIGN KEY (jezyk_kod) REFERENCES public.jezyk(kod) NOT VALID;


--
-- TOC entry 3339 (class 2606 OID 17169)
-- Name: jezyk_pracownik jezyk_pracownik_pracownik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_pracownik
    ADD CONSTRAINT jezyk_pracownik_pracownik_id_fkey FOREIGN KEY (pracownik_id) REFERENCES public.pracownik(id) NOT VALID;


--
-- TOC entry 3340 (class 2606 OID 17174)
-- Name: jezyk_pracownik jezyk_pracownik_pracownik_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_pracownik
    ADD CONSTRAINT jezyk_pracownik_pracownik_id_fkey1 FOREIGN KEY (pracownik_id) REFERENCES public.pracownik(id) NOT VALID;


--
-- TOC entry 3341 (class 2606 OID 17179)
-- Name: jezyk_przewodnik jezyk_przewodnik_jezyk_kod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_przewodnik
    ADD CONSTRAINT jezyk_przewodnik_jezyk_kod_fkey FOREIGN KEY (jezyk_kod) REFERENCES public.jezyk(kod) NOT VALID;


--
-- TOC entry 3342 (class 2606 OID 17184)
-- Name: jezyk_przewodnik jezyk_przewodnik_jezyk_kod_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_przewodnik
    ADD CONSTRAINT jezyk_przewodnik_jezyk_kod_fkey1 FOREIGN KEY (jezyk_kod) REFERENCES public.jezyk(kod) NOT VALID;


--
-- TOC entry 3343 (class 2606 OID 17189)
-- Name: jezyk_przewodnik jezyk_przewodnik_przewodnik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_przewodnik
    ADD CONSTRAINT jezyk_przewodnik_przewodnik_id_fkey FOREIGN KEY (przewodnik_id) REFERENCES public.przewodnik(id) NOT VALID;


--
-- TOC entry 3344 (class 2606 OID 17194)
-- Name: jezyk_przewodnik jezyk_przewodnik_przewodnik_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jezyk_przewodnik
    ADD CONSTRAINT jezyk_przewodnik_przewodnik_id_fkey1 FOREIGN KEY (przewodnik_id) REFERENCES public.przewodnik(id) NOT VALID;


--
-- TOC entry 3365 (class 2606 OID 17400)
-- Name: klient_podroz klient_podroz_podroz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klient_podroz
    ADD CONSTRAINT klient_podroz_podroz_id_fkey FOREIGN KEY (podroz_id) REFERENCES public.podroz(id);


--
-- TOC entry 3366 (class 2606 OID 17405)
-- Name: klient_podroz klient_podroz_podroz_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klient_podroz
    ADD CONSTRAINT klient_podroz_podroz_id_fkey1 FOREIGN KEY (podroz_id) REFERENCES public.podroz(id);


--
-- TOC entry 3345 (class 2606 OID 17219)
-- Name: podroz_atrakcja podroz_atrakcja_atrakcja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.podroz_atrakcja
    ADD CONSTRAINT podroz_atrakcja_atrakcja_id_fkey FOREIGN KEY (atrakcja_id) REFERENCES public.atrakcja(id) NOT VALID;


--
-- TOC entry 3346 (class 2606 OID 17224)
-- Name: podroz_atrakcja podroz_atrakcja_atrakcja_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.podroz_atrakcja
    ADD CONSTRAINT podroz_atrakcja_atrakcja_id_fkey1 FOREIGN KEY (atrakcja_id) REFERENCES public.atrakcja(id) NOT VALID;


--
-- TOC entry 3347 (class 2606 OID 17229)
-- Name: podroz_atrakcja podroz_atrakcja_podroz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.podroz_atrakcja
    ADD CONSTRAINT podroz_atrakcja_podroz_id_fkey FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3348 (class 2606 OID 17234)
-- Name: podroz_atrakcja podroz_atrakcja_podroz_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.podroz_atrakcja
    ADD CONSTRAINT podroz_atrakcja_podroz_id_fkey1 FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3349 (class 2606 OID 17239)
-- Name: pracownik_podroz pracownik_podroz_podroz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownik_podroz
    ADD CONSTRAINT pracownik_podroz_podroz_id_fkey FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3350 (class 2606 OID 17244)
-- Name: pracownik_podroz pracownik_podroz_podroz_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownik_podroz
    ADD CONSTRAINT pracownik_podroz_podroz_id_fkey1 FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3351 (class 2606 OID 17249)
-- Name: pracownik_podroz pracownik_podroz_pracownik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownik_podroz
    ADD CONSTRAINT pracownik_podroz_pracownik_id_fkey FOREIGN KEY (pracownik_id) REFERENCES public.pracownik(id) NOT VALID;


--
-- TOC entry 3352 (class 2606 OID 17254)
-- Name: pracownik_podroz pracownik_podroz_pracownik_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownik_podroz
    ADD CONSTRAINT pracownik_podroz_pracownik_id_fkey1 FOREIGN KEY (pracownik_id) REFERENCES public.pracownik(id) NOT VALID;


--
-- TOC entry 3353 (class 2606 OID 17259)
-- Name: przewodnik_podroz przewodnik_podroz_podroz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przewodnik_podroz
    ADD CONSTRAINT przewodnik_podroz_podroz_id_fkey FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3354 (class 2606 OID 17264)
-- Name: przewodnik_podroz przewodnik_podroz_podroz_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przewodnik_podroz
    ADD CONSTRAINT przewodnik_podroz_podroz_id_fkey1 FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3355 (class 2606 OID 17269)
-- Name: przewodnik_podroz przewodnik_podroz_przewodnik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przewodnik_podroz
    ADD CONSTRAINT przewodnik_podroz_przewodnik_id_fkey FOREIGN KEY (przewodnik_id) REFERENCES public.przewodnik(id) NOT VALID;


--
-- TOC entry 3356 (class 2606 OID 17274)
-- Name: przewodnik_podroz przewodnik_podroz_przewodnik_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przewodnik_podroz
    ADD CONSTRAINT przewodnik_podroz_przewodnik_id_fkey1 FOREIGN KEY (przewodnik_id) REFERENCES public.przewodnik(id) NOT VALID;


--
-- TOC entry 3357 (class 2606 OID 17279)
-- Name: transport_firma_transportowa transport_firma_transportowa_firma_transportowa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport_firma_transportowa
    ADD CONSTRAINT transport_firma_transportowa_firma_transportowa_id_fkey FOREIGN KEY (firma_transportowa_id) REFERENCES public.firma_transportowa(id) NOT VALID;


--
-- TOC entry 3358 (class 2606 OID 17284)
-- Name: transport_firma_transportowa transport_firma_transportowa_firma_transportowa_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport_firma_transportowa
    ADD CONSTRAINT transport_firma_transportowa_firma_transportowa_id_fkey1 FOREIGN KEY (firma_transportowa_id) REFERENCES public.firma_transportowa(id) NOT VALID;


--
-- TOC entry 3359 (class 2606 OID 17289)
-- Name: transport_firma_transportowa transport_firma_transportowa_transport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport_firma_transportowa
    ADD CONSTRAINT transport_firma_transportowa_transport_id_fkey FOREIGN KEY (transport_id) REFERENCES public.transport(id) NOT VALID;


--
-- TOC entry 3360 (class 2606 OID 17294)
-- Name: transport_firma_transportowa transport_firma_transportowa_transport_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport_firma_transportowa
    ADD CONSTRAINT transport_firma_transportowa_transport_id_fkey1 FOREIGN KEY (transport_id) REFERENCES public.transport(id) NOT VALID;


--
-- TOC entry 3361 (class 2606 OID 17299)
-- Name: zakwaterowanie_podroz zakwaterowanie_podroz_podroz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zakwaterowanie_podroz
    ADD CONSTRAINT zakwaterowanie_podroz_podroz_id_fkey FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3362 (class 2606 OID 17304)
-- Name: zakwaterowanie_podroz zakwaterowanie_podroz_podroz_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zakwaterowanie_podroz
    ADD CONSTRAINT zakwaterowanie_podroz_podroz_id_fkey1 FOREIGN KEY (podroz_id) REFERENCES public.podroz(id) NOT VALID;


--
-- TOC entry 3363 (class 2606 OID 17309)
-- Name: zakwaterowanie_podroz zakwaterowanie_podroz_zakwaterowanie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zakwaterowanie_podroz
    ADD CONSTRAINT zakwaterowanie_podroz_zakwaterowanie_id_fkey FOREIGN KEY (zakwaterowanie_id) REFERENCES public.zakwaterowanie(id) NOT VALID;


--
-- TOC entry 3364 (class 2606 OID 17314)
-- Name: zakwaterowanie_podroz zakwaterowanie_podroz_zakwaterowanie_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zakwaterowanie_podroz
    ADD CONSTRAINT zakwaterowanie_podroz_zakwaterowanie_id_fkey1 FOREIGN KEY (zakwaterowanie_id) REFERENCES public.zakwaterowanie(id) NOT VALID;


--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO postgres;


-- Completed on 2023-01-28 19:50:46 UTC

--
-- PostgreSQL database dump complete
--

