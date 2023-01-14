--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.0

-- Started on 2022-12-14 11:02:19

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
-- TOC entry 265 (class 1255 OID 17098)
-- Name: inflacja(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inflacja(IN procenty integer)
    LANGUAGE plpgsql
    AS $$
declare 
cnt integer:=(select max(id) from "Podroz");
begin
  while cnt>0 loop
    update "Podroz"
    set "Cena"="Cena"+"Cena"*(procenty/100)
    where id=cnt;
  end loop;
  
end; 
$$;


ALTER PROCEDURE public.inflacja(IN procenty integer) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 16735)
-- Name: zysk_z_podrozy(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.zysk_z_podrozy(id bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
begin
return max(coalesce(
(select (select count(*) from "Klient_Podroz" as "kp" where kp."Podroz_ID"=id)* 
 (select (select SUM(z."Koszt")  from "Zakwaterowanie_Podroz"  zp left join "Zakwaterowanie" as z on z."ID" =zp."Zakwaterowanie_ID" where zp."Podroz_ID"=id  )+
  (select SUM(a."Koszt") from "Podroz_Atrakcja"  pa   left join "Atrakcja" a on a."ID" = pa."Atrakcja_ID" where pa."Podroz_ID"=id ) +
  (select SUM(e."Koszt")  from "Etap_Podroz"  ep   left join "Etap" e on e."ID" = ep."Etap_ID" where ep."Podroz_ID"=id )-
  (select SUM(p."Cena") from "Podroz" as p where p."ID" = id))), Money(0))); 
end;
$$;


ALTER FUNCTION public.zysk_z_podrozy(id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16736)
-- Name: Atrakcja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Atrakcja" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Sezon" character varying(255)[] NOT NULL,
    "Opis" text,
    "Adres" character varying(255) NOT NULL,
    "Koszt" money NOT NULL
);


ALTER TABLE public."Atrakcja" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16741)
-- Name: Atrakcja_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Atrakcja" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Atrakcja_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 16742)
-- Name: Atrakcja_Przewodnik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Atrakcja_Przewodnik" (
    "Atrakcja_ID" bigint NOT NULL,
    "Przewodnik_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Atrakcja_Przewodnik" OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17099)
-- Name: Atrakcja_Przewodnik_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Atrakcja_Przewodnik" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Atrakcja_Przewodnik_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 16745)
-- Name: Etap; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Etap" (
    "ID" bigint NOT NULL,
    "Punkt_poczatkowy" character varying(255) NOT NULL,
    "Punkt_konczowy" character varying(255) NOT NULL,
    "Koszt" money NOT NULL,
    "Data_poczatkowa" timestamp with time zone NOT NULL,
    "Data_koncowa" timestamp with time zone NOT NULL
);


ALTER TABLE public."Etap" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16750)
-- Name: Etap_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Etap_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Etap_ID_seq" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16751)
-- Name: Etap_ID_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Etap" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Etap_ID_seq1"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16752)
-- Name: Etap_Podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Etap_Podroz" (
    "Etap_ID" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Etap_Podroz" OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 17105)
-- Name: Etap_Podroz_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Etap_Podroz" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Etap_Podroz_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 16755)
-- Name: Firma_transportowa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Firma_transportowa" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Telefon" character varying(12) NOT NULL,
    "Adres" character varying(255) NOT NULL
);


ALTER TABLE public."Firma_transportowa" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16760)
-- Name: Firma_transportowa_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Firma_transportowa" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Firma_transportowa_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 16761)
-- Name: Jezyk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Jezyk" (
    "Kod" character varying(5) NOT NULL,
    "Nazwa" character(255) NOT NULL
);


ALTER TABLE public."Jezyk" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16764)
-- Name: Jezyk_Pracownik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Jezyk_Pracownik" (
    "Jezyk_Kod" character varying(5) NOT NULL,
    "Pracownik_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Jezyk_Pracownik" OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17111)
-- Name: Jezyk_Pracownik_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Jezyk_Pracownik" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Jezyk_Pracownik_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 16767)
-- Name: Jezyk_Przewodnik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Jezyk_Przewodnik" (
    "Jezyk_Kod" character varying(5) NOT NULL,
    "Przewodnik_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Jezyk_Przewodnik" OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 17117)
-- Name: Jezyk_Przewodnik_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Jezyk_Przewodnik" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Jezyk_Przewodnik_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 16770)
-- Name: Klient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Klient" (
    "Pesel" bigint NOT NULL,
    "Imie" character varying(255) NOT NULL,
    "Nazwisko" character varying(255) NOT NULL,
    "Adres" character varying(255) NOT NULL,
    "Numer_telefonu" character varying(12) NOT NULL,
    "Data_urodzenia" date NOT NULL
);


ALTER TABLE public."Klient" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16775)
-- Name: Klient_Podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Klient_Podroz" (
    "Klient_Pesel" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Klient_Podroz" OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17123)
-- Name: Klient_Podroz_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Klient_Podroz" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Klient_Podroz_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16778)
-- Name: Podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Podroz" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Data_rozpoczęcia" timestamp with time zone NOT NULL,
    "Data_ukonczenia" timestamp with time zone NOT NULL,
    "Opis" text,
    "Cena" money NOT NULL
);


ALTER TABLE public."Podroz" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16783)
-- Name: Podroz_Atrakcja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Podroz_Atrakcja" (
    "Podroz_ID" bigint NOT NULL,
    "Atrakcja_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Podroz_Atrakcja" OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 17129)
-- Name: Podroz_Atrakcja_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Podroz_Atrakcja" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Podroz_Atrakcja_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16786)
-- Name: Podroz_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Podroz" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Podroz_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 16787)
-- Name: Pracownik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Pracownik" (
    "ID" bigint NOT NULL,
    "Imie" character varying(255) NOT NULL,
    "Nazwisko" character varying(255) NOT NULL,
    "Numer_telefon" character varying(12) NOT NULL,
    "Adres" character varying(255) NOT NULL
);


ALTER TABLE public."Pracownik" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16792)
-- Name: Pracownik_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Pracownik" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Pracownik_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 16793)
-- Name: Pracownik_Podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Pracownik_Podroz" (
    "Pracownik_ID" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Pracownik_Podroz" OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17135)
-- Name: Pracownik_Podroz_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Pracownik_Podroz" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Pracownik_Podroz_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 16796)
-- Name: Przewodnik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Przewodnik" (
    "ID" bigint NOT NULL,
    "Imie" character varying(255) NOT NULL,
    "Nazwisko" character varying(255) NOT NULL,
    "Adres" character varying(255) NOT NULL,
    "Numer_telefonu" character varying(12) NOT NULL
);


ALTER TABLE public."Przewodnik" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16801)
-- Name: Przewodnik_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Przewodnik" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Przewodnik_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 16802)
-- Name: Przewodnik_Podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Przewodnik_Podroz" (
    "Przewodnik_ID" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Przewodnik_Podroz" OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17141)
-- Name: Przewodnik_Podroz_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Przewodnik_Podroz" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Przewodnik_Podroz_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 16805)
-- Name: Transport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Transport" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Liczba_jednostek" bigint NOT NULL,
    "Liczba_miejsc" bigint NOT NULL
);


ALTER TABLE public."Transport" OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16808)
-- Name: Transport_Firma_transportowa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Transport_Firma_transportowa" (
    "Transport_ID" bigint NOT NULL,
    "Firma_transportowa_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Transport_Firma_transportowa" OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17147)
-- Name: Transport_Firma_transportowa_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Transport_Firma_transportowa" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Transport_Firma_transportowa_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 16811)
-- Name: Transport_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Transport" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Transport_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 16812)
-- Name: Zakwaterowanie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Zakwaterowanie" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Koszt" money,
    "Ilosc_miejsc" bigint,
    "Standard_zakwaterowania" character varying(255) NOT NULL,
    "Adres" character varying(255) NOT NULL
);


ALTER TABLE public."Zakwaterowanie" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16817)
-- Name: Zakwaterowanie_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Zakwaterowanie" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Zakwaterowanie_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 16818)
-- Name: Zakwaterowanie_Podroz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public."Zakwaterowanie_Podroz" (
    "Zakwaterowanie_ID" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."Zakwaterowanie_Podroz" OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 17153)
-- Name: Zakwaterowanie_Podroz_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Zakwaterowanie_Podroz" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Zakwaterowanie_Podroz_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3514 (class 0 OID 16736)
-- Dependencies: 214
-- Data for Name: Atrakcja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Atrakcja" ("ID", "Nazwa", "Sezon", "Opis", "Adres", "Koszt") FROM stdin;
\.


--
-- TOC entry 3516 (class 0 OID 16742)
-- Dependencies: 216
-- Data for Name: Atrakcja_Przewodnik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Atrakcja_Przewodnik" ("Atrakcja_ID", "Przewodnik_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3517 (class 0 OID 16745)
-- Dependencies: 217
-- Data for Name: Etap; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Etap" ("ID", "Punkt_poczatkowy", "Punkt_konczowy", "Koszt", "Data_poczatkowa", "Data_koncowa") FROM stdin;
\.


--
-- TOC entry 3520 (class 0 OID 16752)
-- Dependencies: 220
-- Data for Name: Etap_Podroz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Etap_Podroz" ("Etap_ID", "Podroz_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3521 (class 0 OID 16755)
-- Dependencies: 221
-- Data for Name: Firma_transportowa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Firma_transportowa" ("ID", "Nazwa", "Telefon", "Adres") FROM stdin;
\.


--
-- TOC entry 3523 (class 0 OID 16761)
-- Dependencies: 223
-- Data for Name: Jezyk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Jezyk" ("Kod", "Nazwa") FROM stdin;
\.


--
-- TOC entry 3524 (class 0 OID 16764)
-- Dependencies: 224
-- Data for Name: Jezyk_Pracownik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Jezyk_Pracownik" ("Jezyk_Kod", "Pracownik_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3525 (class 0 OID 16767)
-- Dependencies: 225
-- Data for Name: Jezyk_Przewodnik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Jezyk_Przewodnik" ("Jezyk_Kod", "Przewodnik_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3526 (class 0 OID 16770)
-- Dependencies: 226
-- Data for Name: Klient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Klient" ("Pesel", "Imie", "Nazwisko", "Adres", "Numer_telefonu", "Data_urodzenia") FROM stdin;
\.


--
-- TOC entry 3527 (class 0 OID 16775)
-- Dependencies: 227
-- Data for Name: Klient_Podroz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Klient_Podroz" ("Klient_Pesel", "Podroz_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3528 (class 0 OID 16778)
-- Dependencies: 228
-- Data for Name: Podroz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Podroz" ("ID", "Nazwa", "Data_rozpoczęcia", "Data_ukonczenia", "Opis", "Cena") FROM stdin;
\.


--
-- TOC entry 3529 (class 0 OID 16783)
-- Dependencies: 229
-- Data for Name: Podroz_Atrakcja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Podroz_Atrakcja" ("Podroz_ID", "Atrakcja_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3531 (class 0 OID 16787)
-- Dependencies: 231
-- Data for Name: Pracownik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Pracownik" ("ID", "Imie", "Nazwisko", "Numer_telefon", "Adres") FROM stdin;
\.


--
-- TOC entry 3533 (class 0 OID 16793)
-- Dependencies: 233
-- Data for Name: Pracownik_Podroz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Pracownik_Podroz" ("Pracownik_ID", "Podroz_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3534 (class 0 OID 16796)
-- Dependencies: 234
-- Data for Name: Przewodnik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Przewodnik" ("ID", "Imie", "Nazwisko", "Adres", "Numer_telefonu") FROM stdin;
\.


--
-- TOC entry 3536 (class 0 OID 16802)
-- Dependencies: 236
-- Data for Name: Przewodnik_Podroz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Przewodnik_Podroz" ("Przewodnik_ID", "Podroz_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3537 (class 0 OID 16805)
-- Dependencies: 237
-- Data for Name: Transport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Transport" ("ID", "Nazwa", "Liczba_jednostek", "Liczba_miejsc") FROM stdin;
\.


--
-- TOC entry 3538 (class 0 OID 16808)
-- Dependencies: 238
-- Data for Name: Transport_Firma_transportowa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Transport_Firma_transportowa" ("Transport_ID", "Firma_transportowa_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3540 (class 0 OID 16812)
-- Dependencies: 240
-- Data for Name: Zakwaterowanie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Zakwaterowanie" ("ID", "Nazwa", "Koszt", "Ilosc_miejsc", "Standard_zakwaterowania", "Adres") FROM stdin;
\.


--
-- TOC entry 3542 (class 0 OID 16818)
-- Dependencies: 242
-- Data for Name: Zakwaterowanie_Podroz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Zakwaterowanie_Podroz" ("Zakwaterowanie_ID", "Podroz_ID", "ID") FROM stdin;
\.


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 215
-- Name: Atrakcja_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Atrakcja_ID_seq"', 1, false);


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 243
-- Name: Atrakcja_Przewodnik_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Atrakcja_Przewodnik_ID_seq"', 1, false);


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 218
-- Name: Etap_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Etap_ID_seq"', 1, false);


--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 219
-- Name: Etap_ID_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Etap_ID_seq1"', 1, false);


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 244
-- Name: Etap_Podroz_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Etap_Podroz_ID_seq"', 1, false);


--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 222
-- Name: Firma_transportowa_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Firma_transportowa_ID_seq"', 1, false);


--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 245
-- Name: Jezyk_Pracownik_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Jezyk_Pracownik_ID_seq"', 1, false);


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 246
-- Name: Jezyk_Przewodnik_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Jezyk_Przewodnik_ID_seq"', 1, false);


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 247
-- Name: Klient_Podroz_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Klient_Podroz_ID_seq"', 1, false);


--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 248
-- Name: Podroz_Atrakcja_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Podroz_Atrakcja_ID_seq"', 1, false);


--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 230
-- Name: Podroz_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Podroz_ID_seq"', 1, true);


--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 232
-- Name: Pracownik_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Pracownik_ID_seq"', 1, false);


--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 249
-- Name: Pracownik_Podroz_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Pracownik_Podroz_ID_seq"', 1, false);


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 235
-- Name: Przewodnik_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Przewodnik_ID_seq"', 1, false);


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 250
-- Name: Przewodnik_Podroz_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Przewodnik_Podroz_ID_seq"', 1, false);


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 251
-- Name: Transport_Firma_transportowa_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Transport_Firma_transportowa_ID_seq"', 1, false);


--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 239
-- Name: Transport_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Transport_ID_seq"', 1, false);


--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 241
-- Name: Zakwaterowanie_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Zakwaterowanie_ID_seq"', 1, false);


--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 252
-- Name: Zakwaterowanie_Podroz_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Zakwaterowanie_Podroz_ID_seq"', 1, false);


--
-- TOC entry 3273 (class 2606 OID 16822)
-- Name: Atrakcja Atrakcja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Atrakcja"
    ADD CONSTRAINT "Atrakcja_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3284 (class 2606 OID 17110)
-- Name: Etap_Podroz Etap_Podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3280 (class 2606 OID 16824)
-- Name: Etap Etap_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap"
    ADD CONSTRAINT "Etap_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3286 (class 2606 OID 16826)
-- Name: Firma_transportowa Firma_transportowa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Firma_transportowa"
    ADD CONSTRAINT "Firma_transportowa_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3292 (class 2606 OID 17116)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3294 (class 2606 OID 17122)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3290 (class 2606 OID 16828)
-- Name: Jezyk Jezyk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk"
    ADD CONSTRAINT "Jezyk_pkey" PRIMARY KEY ("Kod");


--
-- TOC entry 3299 (class 2606 OID 17128)
-- Name: Klient_Podroz Klient_Podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3296 (class 2606 OID 16830)
-- Name: Klient Klient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Klient"
    ADD CONSTRAINT "Klient_pkey" PRIMARY KEY ("Pesel");


--
-- TOC entry 3305 (class 2606 OID 17134)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3301 (class 2606 OID 16832)
-- Name: Podroz Podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Podroz"
    ADD CONSTRAINT "Podroz_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3311 (class 2606 OID 17140)
-- Name: Pracownik_Podroz Pracownik_Podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3307 (class 2606 OID 16834)
-- Name: Pracownik Pracownik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pracownik"
    ADD CONSTRAINT "Pracownik_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3317 (class 2606 OID 17146)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3313 (class 2606 OID 16836)
-- Name: Przewodnik Przewodnik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Przewodnik"
    ADD CONSTRAINT "Przewodnik_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3323 (class 2606 OID 17152)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3319 (class 2606 OID 16838)
-- Name: Transport Transport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transport"
    ADD CONSTRAINT "Transport_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3329 (class 2606 OID 17158)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3325 (class 2606 OID 16840)
-- Name: Zakwaterowanie Zakwaterowanie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zakwaterowanie"
    ADD CONSTRAINT "Zakwaterowanie_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3278 (class 2606 OID 17104)
-- Name: Atrakcja_Przewodnik pk_atrakcja_przewodnik; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT pk_atrakcja_przewodnik PRIMARY KEY ("ID");


--
-- TOC entry 3276 (class 2606 OID 17085)
-- Name: Atrakcja uniq_atrakcje; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Atrakcja"
    ADD CONSTRAINT uniq_atrakcje UNIQUE ("Nazwa", "Adres");


--
-- TOC entry 3282 (class 2606 OID 17083)
-- Name: Etap uniq_etapy; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap"
    ADD CONSTRAINT uniq_etapy UNIQUE ("Punkt_poczatkowy", "Punkt_konczowy", "Data_poczatkowa");


--
-- TOC entry 3288 (class 2606 OID 17087)
-- Name: Firma_transportowa uniq_firma_transportowa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Firma_transportowa"
    ADD CONSTRAINT uniq_firma_transportowa UNIQUE ("Nazwa", "Adres");


--
-- TOC entry 3303 (class 2606 OID 17089)
-- Name: Podroz uniq_podroz; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Podroz"
    ADD CONSTRAINT uniq_podroz UNIQUE ("Nazwa", "Data_rozpoczęcia");


--
-- TOC entry 3309 (class 2606 OID 17091)
-- Name: Pracownik uniq_pracownik; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pracownik"
    ADD CONSTRAINT uniq_pracownik UNIQUE ("Imie", "Nazwisko", "Adres");


--
-- TOC entry 3315 (class 2606 OID 17093)
-- Name: Przewodnik uniq_przewodnik; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Przewodnik"
    ADD CONSTRAINT uniq_przewodnik UNIQUE ("Imie", "Nazwisko", "Adres");


--
-- TOC entry 3321 (class 2606 OID 17095)
-- Name: Transport uniq_transport; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transport"
    ADD CONSTRAINT uniq_transport UNIQUE ("Nazwa", "Liczba_jednostek", "Liczba_miejsc");


--
-- TOC entry 3327 (class 2606 OID 17097)
-- Name: Zakwaterowanie uniq_zakwaterowanie; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zakwaterowanie"
    ADD CONSTRAINT uniq_zakwaterowanie UNIQUE ("Adres");


--
-- TOC entry 3274 (class 1259 OID 16841)
-- Name: Nazwa_indx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Nazwa_indx" ON public."Atrakcja" USING btree ("Nazwa" text_pattern_ops);

ALTER TABLE public."Atrakcja" CLUSTER ON "Nazwa_indx";


--
-- TOC entry 3297 (class 1259 OID 16842)
-- Name: Nazwisko_indx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Nazwisko_indx" ON public."Klient" USING btree ("Nazwisko" varchar_ops);


--
-- TOC entry 3330 (class 2606 OID 16843)
-- Name: Atrakcja_Przewodnik Atrakcja_Przewodnik_Atrakcja_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT "Atrakcja_Przewodnik_Atrakcja_ID_fkey" FOREIGN KEY ("Atrakcja_ID") REFERENCES public."Atrakcja"("ID") NOT VALID;


--
-- TOC entry 3331 (class 2606 OID 16848)
-- Name: Atrakcja_Przewodnik Atrakcja_Przewodnik_Atrakcja_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT "Atrakcja_Przewodnik_Atrakcja_ID_fkey1" FOREIGN KEY ("Atrakcja_ID") REFERENCES public."Atrakcja"("ID") NOT VALID;


--
-- TOC entry 3332 (class 2606 OID 16853)
-- Name: Atrakcja_Przewodnik Atrakcja_Przewodnik_Przewodnik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT "Atrakcja_Przewodnik_Przewodnik_ID_fkey" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3333 (class 2606 OID 16858)
-- Name: Atrakcja_Przewodnik Atrakcja_Przewodnik_Przewodnik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT "Atrakcja_Przewodnik_Przewodnik_ID_fkey1" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3334 (class 2606 OID 16863)
-- Name: Etap Etap_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap"
    ADD CONSTRAINT "Etap_ID_fkey" FOREIGN KEY ("ID") REFERENCES public."Transport"("ID") NOT VALID;


--
-- TOC entry 3335 (class 2606 OID 16868)
-- Name: Etap Etap_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap"
    ADD CONSTRAINT "Etap_ID_fkey1" FOREIGN KEY ("ID") REFERENCES public."Transport"("ID") NOT VALID;


--
-- TOC entry 3336 (class 2606 OID 16873)
-- Name: Etap_Podroz Etap_Podroz_Etap_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_Etap_ID_fkey" FOREIGN KEY ("Etap_ID") REFERENCES public."Etap"("ID") NOT VALID;


--
-- TOC entry 3337 (class 2606 OID 16878)
-- Name: Etap_Podroz Etap_Podroz_Etap_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_Etap_ID_fkey1" FOREIGN KEY ("Etap_ID") REFERENCES public."Etap"("ID") NOT VALID;


--
-- TOC entry 3338 (class 2606 OID 16883)
-- Name: Etap_Podroz Etap_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3339 (class 2606 OID 16888)
-- Name: Etap_Podroz Etap_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3340 (class 2606 OID 16893)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_Jezyk_Kod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_Jezyk_Kod_fkey" FOREIGN KEY ("Jezyk_Kod") REFERENCES public."Jezyk"("Kod") NOT VALID;


--
-- TOC entry 3341 (class 2606 OID 16898)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_Jezyk_Kod_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_Jezyk_Kod_fkey1" FOREIGN KEY ("Jezyk_Kod") REFERENCES public."Jezyk"("Kod") NOT VALID;


--
-- TOC entry 3342 (class 2606 OID 16903)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_Pracownik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_Pracownik_ID_fkey" FOREIGN KEY ("Pracownik_ID") REFERENCES public."Pracownik"("ID") NOT VALID;


--
-- TOC entry 3343 (class 2606 OID 16908)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_Pracownik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_Pracownik_ID_fkey1" FOREIGN KEY ("Pracownik_ID") REFERENCES public."Pracownik"("ID") NOT VALID;


--
-- TOC entry 3344 (class 2606 OID 16913)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_Jezyk_Kod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_Jezyk_Kod_fkey" FOREIGN KEY ("Jezyk_Kod") REFERENCES public."Jezyk"("Kod") NOT VALID;


--
-- TOC entry 3345 (class 2606 OID 16918)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_Jezyk_Kod_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_Jezyk_Kod_fkey1" FOREIGN KEY ("Jezyk_Kod") REFERENCES public."Jezyk"("Kod") NOT VALID;


--
-- TOC entry 3346 (class 2606 OID 16923)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_Przewodnik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_Przewodnik_ID_fkey" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3347 (class 2606 OID 16928)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_Przewodnik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_Przewodnik_ID_fkey1" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3348 (class 2606 OID 16933)
-- Name: Klient_Podroz Klient_Podroz_Klient_Pesel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_Klient_Pesel_fkey" FOREIGN KEY ("Klient_Pesel") REFERENCES public."Klient"("Pesel") NOT VALID;


--
-- TOC entry 3349 (class 2606 OID 16938)
-- Name: Klient_Podroz Klient_Podroz_Klient_Pesel_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_Klient_Pesel_fkey1" FOREIGN KEY ("Klient_Pesel") REFERENCES public."Klient"("Pesel") NOT VALID;


--
-- TOC entry 3350 (class 2606 OID 16943)
-- Name: Klient_Podroz Klient_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3351 (class 2606 OID 16948)
-- Name: Klient_Podroz Klient_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3352 (class 2606 OID 16953)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_Atrakcja_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_Atrakcja_ID_fkey" FOREIGN KEY ("Atrakcja_ID") REFERENCES public."Atrakcja"("ID") NOT VALID;


--
-- TOC entry 3353 (class 2606 OID 16958)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_Atrakcja_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_Atrakcja_ID_fkey1" FOREIGN KEY ("Atrakcja_ID") REFERENCES public."Atrakcja"("ID") NOT VALID;


--
-- TOC entry 3354 (class 2606 OID 16963)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3355 (class 2606 OID 16968)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3356 (class 2606 OID 16973)
-- Name: Pracownik_Podroz Pracownik_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3357 (class 2606 OID 16978)
-- Name: Pracownik_Podroz Pracownik_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3358 (class 2606 OID 16983)
-- Name: Pracownik_Podroz Pracownik_Podroz_Pracownik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_Pracownik_ID_fkey" FOREIGN KEY ("Pracownik_ID") REFERENCES public."Pracownik"("ID") NOT VALID;


--
-- TOC entry 3359 (class 2606 OID 16988)
-- Name: Pracownik_Podroz Pracownik_Podroz_Pracownik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_Pracownik_ID_fkey1" FOREIGN KEY ("Pracownik_ID") REFERENCES public."Pracownik"("ID") NOT VALID;


--
-- TOC entry 3360 (class 2606 OID 16993)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3361 (class 2606 OID 16998)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3362 (class 2606 OID 17003)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_Przewodnik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_Przewodnik_ID_fkey" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3363 (class 2606 OID 17008)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_Przewodnik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_Przewodnik_ID_fkey1" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3364 (class 2606 OID 17013)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_Firma_transportowa_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_Firma_transportowa_ID_fkey" FOREIGN KEY ("Firma_transportowa_ID") REFERENCES public."Firma_transportowa"("ID") NOT VALID;


--
-- TOC entry 3365 (class 2606 OID 17018)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_Firma_transportowa_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_Firma_transportowa_ID_fkey1" FOREIGN KEY ("Firma_transportowa_ID") REFERENCES public."Firma_transportowa"("ID") NOT VALID;


--
-- TOC entry 3366 (class 2606 OID 17023)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_Transport_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_Transport_ID_fkey" FOREIGN KEY ("Transport_ID") REFERENCES public."Transport"("ID") NOT VALID;


--
-- TOC entry 3367 (class 2606 OID 17028)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_Transport_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_Transport_ID_fkey1" FOREIGN KEY ("Transport_ID") REFERENCES public."Transport"("ID") NOT VALID;


--
-- TOC entry 3368 (class 2606 OID 17033)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3369 (class 2606 OID 17038)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3370 (class 2606 OID 17043)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_Zakwaterowanie_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_Zakwaterowanie_ID_fkey" FOREIGN KEY ("Zakwaterowanie_ID") REFERENCES public."Zakwaterowanie"("ID") NOT VALID;


--
-- TOC entry 3371 (class 2606 OID 17048)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_Zakwaterowanie_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_Zakwaterowanie_ID_fkey1" FOREIGN KEY ("Zakwaterowanie_ID") REFERENCES public."Zakwaterowanie"("ID") NOT VALID;


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO postgres;


-- Completed on 2022-12-14 11:02:19

--
-- PostgreSQL database dump complete
--

