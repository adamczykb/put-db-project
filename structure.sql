--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.1

-- Started on 2022-12-10 00:20:08 UTC

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
-- TOC entry 254 (class 1255 OID 16753)
-- Name: zysk_z_podrozy(bigint); Type: FUNCTION; Schema: public; Owner: bartek
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


ALTER FUNCTION public.zysk_z_podrozy(id bigint) OWNER TO bartek;

create or replace procedure select_klient
(
  procenty int
)
language plpgsql
as $$
declare 
cnt int=(select max(id) from Podroz);
begin
  while cnt>0 loop
    update Podroz
    set cena=cena+cena*(procenty/100)
    where id=cnt;
  end loop;
end; 
$$;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16444)
-- Name: Atrakcja; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Atrakcja" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Sezon" character varying(255)[] NOT NULL,
    "Opis" text,
    "Adres" character varying(255) NOT NULL,
    "Koszt" money NOT NULL
);


ALTER TABLE public."Atrakcja" OWNER TO bartek;

--
-- TOC entry 235 (class 1259 OID 16712)
-- Name: Atrakcja_ID_seq; Type: SEQUENCE; Schema: public; Owner: bartek
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
-- TOC entry 227 (class 1259 OID 16479)
-- Name: Atrakcja_Przewodnik; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Atrakcja_Przewodnik" (
    "Atrakcja_ID" bigint NOT NULL,
    "Przewodnik_ID" bigint NOT NULL
);


ALTER TABLE public."Atrakcja_Przewodnik" OWNER TO bartek;

--
-- TOC entry 215 (class 1259 OID 16411)
-- Name: Etap; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Etap" (
    "ID" bigint NOT NULL,
    "Punkt_poczatkowy" character varying(255) NOT NULL,
    "Punkt_konczowy" character varying(255) NOT NULL,
    "Koszt" money NOT NULL,
    "Data_poczatkowa" timestamp with time zone NOT NULL,
    "Data_koncowa" timestamp with time zone NOT NULL
);


ALTER TABLE public."Etap" OWNER TO bartek;

--
-- TOC entry 234 (class 1259 OID 16711)
-- Name: Etap_ID_seq; Type: SEQUENCE; Schema: public; Owner: bartek
--

CREATE SEQUENCE public."Etap_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Etap_ID_seq" OWNER TO bartek;

--
-- TOC entry 236 (class 1259 OID 16714)
-- Name: Etap_ID_seq1; Type: SEQUENCE; Schema: public; Owner: bartek
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
-- TOC entry 233 (class 1259 OID 16497)
-- Name: Etap_Podroz; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Etap_Podroz" (
    "Etap_ID" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL
);


ALTER TABLE public."Etap_Podroz" OWNER TO bartek;

--
-- TOC entry 217 (class 1259 OID 16423)
-- Name: Firma_transportowa; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Firma_transportowa" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Telefon" character varying(12) NOT NULL,
    "Adres" character varying(255) NOT NULL
);


ALTER TABLE public."Firma_transportowa" OWNER TO bartek;

--
-- TOC entry 237 (class 1259 OID 16715)
-- Name: Firma_transportowa_ID_seq; Type: SEQUENCE; Schema: public; Owner: bartek
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
-- TOC entry 222 (class 1259 OID 16458)
-- Name: Jezyk; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Jezyk" (
    "Kod" character varying(5) NOT NULL,
    "Nazwa" character(255) NOT NULL
);


ALTER TABLE public."Jezyk" OWNER TO bartek;

--
-- TOC entry 230 (class 1259 OID 16488)
-- Name: Jezyk_Pracownik; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Jezyk_Pracownik" (
    "Jezyk_Kod" character varying(5) NOT NULL,
    "Pracownik_ID" bigint NOT NULL
);


ALTER TABLE public."Jezyk_Pracownik" OWNER TO bartek;

--
-- TOC entry 229 (class 1259 OID 16485)
-- Name: Jezyk_Przewodnik; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Jezyk_Przewodnik" (
    "Jezyk_Kod" character varying(5) NOT NULL,
    "Przewodnik_ID" bigint NOT NULL
);


ALTER TABLE public."Jezyk_Przewodnik" OWNER TO bartek;

--
-- TOC entry 218 (class 1259 OID 16430)
-- Name: Klient; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Klient" (
    "Pesel" bigint NOT NULL,
    "Imie" character varying(255) NOT NULL,
    "Nazwisko" character varying(255) NOT NULL,
    "Adres" character varying(255) NOT NULL,
    "Numer_telefonu" character varying(12) NOT NULL,
    "Data_urodzenia" date NOT NULL
);


ALTER TABLE public."Klient" OWNER TO bartek;

--
-- TOC entry 232 (class 1259 OID 16494)
-- Name: Klient_Podroz; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Klient_Podroz" (
    "Klient_Pesel" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL
);


ALTER TABLE public."Klient_Podroz" OWNER TO bartek;

--
-- TOC entry 214 (class 1259 OID 16404)
-- Name: Podroz; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Podroz" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Data_rozpoczęcia" timestamp with time zone NOT NULL,
    "Data_ukonczenia" timestamp with time zone NOT NULL,
    "Opis" text,
    "Cena" money NOT NULL
);


ALTER TABLE public."Podroz" OWNER TO bartek;

--
-- TOC entry 226 (class 1259 OID 16476)
-- Name: Podroz_Atrakcja; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Podroz_Atrakcja" (
    "Podroz_ID" bigint NOT NULL,
    "Atrakcja_ID" bigint NOT NULL
);


ALTER TABLE public."Podroz_Atrakcja" OWNER TO bartek;

--
-- TOC entry 238 (class 1259 OID 16716)
-- Name: Podroz_ID_seq; Type: SEQUENCE; Schema: public; Owner: bartek
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
-- TOC entry 223 (class 1259 OID 16463)
-- Name: Pracownik; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Pracownik" (
    "ID" bigint NOT NULL,
    "Imie" character varying(255) NOT NULL,
    "Nazwisko" character varying(255) NOT NULL,
    "Numer_telefon" character varying(12) NOT NULL,
    "Adres" character varying(255) NOT NULL
);


ALTER TABLE public."Pracownik" OWNER TO bartek;

--
-- TOC entry 239 (class 1259 OID 16717)
-- Name: Pracownik_ID_seq; Type: SEQUENCE; Schema: public; Owner: bartek
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
-- TOC entry 231 (class 1259 OID 16491)
-- Name: Pracownik_Podroz; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Pracownik_Podroz" (
    "Pracownik_ID" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL
);


ALTER TABLE public."Pracownik_Podroz" OWNER TO bartek;

--
-- TOC entry 221 (class 1259 OID 16451)
-- Name: Przewodnik; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Przewodnik" (
    "ID" bigint NOT NULL,
    "Imie" character varying(255) NOT NULL,
    "Nazwisko" character varying(255) NOT NULL,
    "Adres" character varying(255) NOT NULL,
    "Numer_telefonu" character varying(12) NOT NULL
);


ALTER TABLE public."Przewodnik" OWNER TO bartek;

--
-- TOC entry 240 (class 1259 OID 16718)
-- Name: Przewodnik_ID_seq; Type: SEQUENCE; Schema: public; Owner: bartek
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
-- TOC entry 228 (class 1259 OID 16482)
-- Name: Przewodnik_Podroz; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Przewodnik_Podroz" (
    "Przewodnik_ID" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL
);


ALTER TABLE public."Przewodnik_Podroz" OWNER TO bartek;

--
-- TOC entry 216 (class 1259 OID 16418)
-- Name: Transport; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Transport" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Liczba_jednostek" bigint NOT NULL,
    "Liczba_miejsc" bigint NOT NULL
);


ALTER TABLE public."Transport" OWNER TO bartek;

--
-- TOC entry 224 (class 1259 OID 16470)
-- Name: Transport_Firma_transportowa; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Transport_Firma_transportowa" (
    "Transport_ID" bigint NOT NULL,
    "Firma_transportowa_ID" bigint NOT NULL
);


ALTER TABLE public."Transport_Firma_transportowa" OWNER TO bartek;

--
-- TOC entry 241 (class 1259 OID 16719)
-- Name: Transport_ID_seq; Type: SEQUENCE; Schema: public; Owner: bartek
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
-- TOC entry 219 (class 1259 OID 16437)
-- Name: Zakwaterowanie; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Zakwaterowanie" (
    "ID" bigint NOT NULL,
    "Nazwa" character varying(255) NOT NULL,
    "Koszt" money,
    "Ilosc_miejsc" bigint,
    "Standard_zakwaterowania" character varying(255) NOT NULL
);


ALTER TABLE public."Zakwaterowanie" OWNER TO bartek;

--
-- TOC entry 242 (class 1259 OID 16720)
-- Name: Zakwaterowanie_ID_seq; Type: SEQUENCE; Schema: public; Owner: bartek
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
-- TOC entry 225 (class 1259 OID 16473)
-- Name: Zakwaterowanie_Podroz; Type: TABLE; Schema: public; Owner: bartek
--

CREATE TABLE public."Zakwaterowanie_Podroz" (
    "Zakwaterowanie_ID" bigint NOT NULL,
    "Podroz_ID" bigint NOT NULL
);


ALTER TABLE public."Zakwaterowanie_Podroz" OWNER TO bartek;

--
-- TOC entry 3473 (class 0 OID 16444)
-- Dependencies: 220
-- Data for Name: Atrakcja; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Atrakcja" ("ID", "Nazwa", "Sezon", "Opis", "Adres", "Koszt") FROM stdin;
\.


--
-- TOC entry 3480 (class 0 OID 16479)
-- Dependencies: 227
-- Data for Name: Atrakcja_Przewodnik; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Atrakcja_Przewodnik" ("Atrakcja_ID", "Przewodnik_ID") FROM stdin;
\.


--
-- TOC entry 3468 (class 0 OID 16411)
-- Dependencies: 215
-- Data for Name: Etap; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Etap" ("ID", "Punkt_poczatkowy", "Punkt_konczowy", "Koszt", "Data_poczatkowa", "Data_koncowa") FROM stdin;
\.


--
-- TOC entry 3486 (class 0 OID 16497)
-- Dependencies: 233
-- Data for Name: Etap_Podroz; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Etap_Podroz" ("Etap_ID", "Podroz_ID") FROM stdin;
\.


--
-- TOC entry 3470 (class 0 OID 16423)
-- Dependencies: 217
-- Data for Name: Firma_transportowa; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Firma_transportowa" ("ID", "Nazwa", "Telefon", "Adres") FROM stdin;
\.


--
-- TOC entry 3475 (class 0 OID 16458)
-- Dependencies: 222
-- Data for Name: Jezyk; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Jezyk" ("Kod", "Nazwa") FROM stdin;
\.


--
-- TOC entry 3483 (class 0 OID 16488)
-- Dependencies: 230
-- Data for Name: Jezyk_Pracownik; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Jezyk_Pracownik" ("Jezyk_Kod", "Pracownik_ID") FROM stdin;
\.


--
-- TOC entry 3482 (class 0 OID 16485)
-- Dependencies: 229
-- Data for Name: Jezyk_Przewodnik; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Jezyk_Przewodnik" ("Jezyk_Kod", "Przewodnik_ID") FROM stdin;
\.


--
-- TOC entry 3471 (class 0 OID 16430)
-- Dependencies: 218
-- Data for Name: Klient; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Klient" ("Pesel", "Imie", "Nazwisko", "Adres", "Numer_telefonu", "Data_urodzenia") FROM stdin;
\.


--
-- TOC entry 3485 (class 0 OID 16494)
-- Dependencies: 232
-- Data for Name: Klient_Podroz; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Klient_Podroz" ("Klient_Pesel", "Podroz_ID") FROM stdin;
\.


--
-- TOC entry 3467 (class 0 OID 16404)
-- Dependencies: 214
-- Data for Name: Podroz; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Podroz" ("ID", "Nazwa", "Data_rozpoczęcia", "Data_ukonczenia", "Opis", "Cena") FROM stdin;
\.


--
-- TOC entry 3479 (class 0 OID 16476)
-- Dependencies: 226
-- Data for Name: Podroz_Atrakcja; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Podroz_Atrakcja" ("Podroz_ID", "Atrakcja_ID") FROM stdin;
\.


--
-- TOC entry 3476 (class 0 OID 16463)
-- Dependencies: 223
-- Data for Name: Pracownik; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Pracownik" ("ID", "Imie", "Nazwisko", "Numer_telefon", "Adres") FROM stdin;
\.


--
-- TOC entry 3484 (class 0 OID 16491)
-- Dependencies: 231
-- Data for Name: Pracownik_Podroz; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Pracownik_Podroz" ("Pracownik_ID", "Podroz_ID") FROM stdin;
\.


--
-- TOC entry 3474 (class 0 OID 16451)
-- Dependencies: 221
-- Data for Name: Przewodnik; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Przewodnik" ("ID", "Imie", "Nazwisko", "Adres", "Numer_telefonu") FROM stdin;
\.


--
-- TOC entry 3481 (class 0 OID 16482)
-- Dependencies: 228
-- Data for Name: Przewodnik_Podroz; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Przewodnik_Podroz" ("Przewodnik_ID", "Podroz_ID") FROM stdin;
\.


--
-- TOC entry 3469 (class 0 OID 16418)
-- Dependencies: 216
-- Data for Name: Transport; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Transport" ("ID", "Nazwa", "Liczba_jednostek", "Liczba_miejsc") FROM stdin;
\.


--
-- TOC entry 3477 (class 0 OID 16470)
-- Dependencies: 224
-- Data for Name: Transport_Firma_transportowa; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Transport_Firma_transportowa" ("Transport_ID", "Firma_transportowa_ID") FROM stdin;
\.


--
-- TOC entry 3472 (class 0 OID 16437)
-- Dependencies: 219
-- Data for Name: Zakwaterowanie; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Zakwaterowanie" ("ID", "Nazwa", "Koszt", "Ilosc_miejsc", "Standard_zakwaterowania") FROM stdin;
\.


--
-- TOC entry 3478 (class 0 OID 16473)
-- Dependencies: 225
-- Data for Name: Zakwaterowanie_Podroz; Type: TABLE DATA; Schema: public; Owner: bartek
--

COPY public."Zakwaterowanie_Podroz" ("Zakwaterowanie_ID", "Podroz_ID") FROM stdin;
\.


--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 235
-- Name: Atrakcja_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Atrakcja_ID_seq"', 1, false);


--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 234
-- Name: Etap_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Etap_ID_seq"', 1, false);


--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 236
-- Name: Etap_ID_seq1; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Etap_ID_seq1"', 1, false);


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 237
-- Name: Firma_transportowa_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Firma_transportowa_ID_seq"', 1, false);


--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 238
-- Name: Podroz_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Podroz_ID_seq"', 1, true);


--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 239
-- Name: Pracownik_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Pracownik_ID_seq"', 1, false);


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 240
-- Name: Przewodnik_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Przewodnik_ID_seq"', 1, false);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 241
-- Name: Transport_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Transport_ID_seq"', 1, false);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 242
-- Name: Zakwaterowanie_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: bartek
--

SELECT pg_catalog.setval('public."Zakwaterowanie_ID_seq"', 1, false);


--
-- TOC entry 3275 (class 2606 OID 16450)
-- Name: Atrakcja Atrakcja_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Atrakcja"
    ADD CONSTRAINT "Atrakcja_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3264 (class 2606 OID 16417)
-- Name: Etap Etap_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Etap"
    ADD CONSTRAINT "Etap_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3268 (class 2606 OID 16429)
-- Name: Firma_transportowa Firma_transportowa_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Firma_transportowa"
    ADD CONSTRAINT "Firma_transportowa_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3280 (class 2606 OID 16462)
-- Name: Jezyk Jezyk_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk"
    ADD CONSTRAINT "Jezyk_pkey" PRIMARY KEY ("Kod");


--
-- TOC entry 3270 (class 2606 OID 16436)
-- Name: Klient Klient_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Klient"
    ADD CONSTRAINT "Klient_pkey" PRIMARY KEY ("Pesel");


--
-- TOC entry 3262 (class 2606 OID 16410)
-- Name: Podroz Podroz_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Podroz"
    ADD CONSTRAINT "Podroz_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3282 (class 2606 OID 16469)
-- Name: Pracownik Pracownik_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Pracownik"
    ADD CONSTRAINT "Pracownik_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3278 (class 2606 OID 16457)
-- Name: Przewodnik Przewodnik_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Przewodnik"
    ADD CONSTRAINT "Przewodnik_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3266 (class 2606 OID 16422)
-- Name: Transport Transport_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Transport"
    ADD CONSTRAINT "Transport_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3273 (class 2606 OID 16443)
-- Name: Zakwaterowanie Zakwaterowanie_pkey; Type: CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Zakwaterowanie"
    ADD CONSTRAINT "Zakwaterowanie_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3276 (class 1259 OID 16754)
-- Name: Nazwa_indx; Type: INDEX; Schema: public; Owner: bartek
--

CREATE INDEX "Nazwa_indx" ON public."Atrakcja" USING btree ("Nazwa" text_pattern_ops);

ALTER TABLE public."Atrakcja" CLUSTER ON "Nazwa_indx";


--
-- TOC entry 3271 (class 1259 OID 16755)
-- Name: Nazwisko_indx; Type: INDEX; Schema: public; Owner: bartek
--

CREATE INDEX "Nazwisko_indx" ON public."Klient" USING btree ("Nazwisko" varchar_ops);


--
-- TOC entry 3297 (class 2606 OID 16535)
-- Name: Atrakcja_Przewodnik Atrakcja_Przewodnik_Atrakcja_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT "Atrakcja_Przewodnik_Atrakcja_ID_fkey" FOREIGN KEY ("Atrakcja_ID") REFERENCES public."Atrakcja"("ID") NOT VALID;


--
-- TOC entry 3298 (class 2606 OID 16641)
-- Name: Atrakcja_Przewodnik Atrakcja_Przewodnik_Atrakcja_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT "Atrakcja_Przewodnik_Atrakcja_ID_fkey1" FOREIGN KEY ("Atrakcja_ID") REFERENCES public."Atrakcja"("ID") NOT VALID;


--
-- TOC entry 3299 (class 2606 OID 16540)
-- Name: Atrakcja_Przewodnik Atrakcja_Przewodnik_Przewodnik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT "Atrakcja_Przewodnik_Przewodnik_ID_fkey" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3300 (class 2606 OID 16646)
-- Name: Atrakcja_Przewodnik Atrakcja_Przewodnik_Przewodnik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Atrakcja_Przewodnik"
    ADD CONSTRAINT "Atrakcja_Przewodnik_Przewodnik_ID_fkey1" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3283 (class 2606 OID 16500)
-- Name: Etap Etap_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Etap"
    ADD CONSTRAINT "Etap_ID_fkey" FOREIGN KEY ("ID") REFERENCES public."Transport"("ID") NOT VALID;


--
-- TOC entry 3284 (class 2606 OID 16606)
-- Name: Etap Etap_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Etap"
    ADD CONSTRAINT "Etap_ID_fkey1" FOREIGN KEY ("ID") REFERENCES public."Transport"("ID") NOT VALID;


--
-- TOC entry 3321 (class 2606 OID 16595)
-- Name: Etap_Podroz Etap_Podroz_Etap_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_Etap_ID_fkey" FOREIGN KEY ("Etap_ID") REFERENCES public."Etap"("ID") NOT VALID;


--
-- TOC entry 3322 (class 2606 OID 16701)
-- Name: Etap_Podroz Etap_Podroz_Etap_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_Etap_ID_fkey1" FOREIGN KEY ("Etap_ID") REFERENCES public."Etap"("ID") NOT VALID;


--
-- TOC entry 3323 (class 2606 OID 16600)
-- Name: Etap_Podroz Etap_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3324 (class 2606 OID 16706)
-- Name: Etap_Podroz Etap_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Etap_Podroz"
    ADD CONSTRAINT "Etap_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3309 (class 2606 OID 16565)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_Jezyk_Kod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_Jezyk_Kod_fkey" FOREIGN KEY ("Jezyk_Kod") REFERENCES public."Jezyk"("Kod") NOT VALID;


--
-- TOC entry 3310 (class 2606 OID 16671)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_Jezyk_Kod_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_Jezyk_Kod_fkey1" FOREIGN KEY ("Jezyk_Kod") REFERENCES public."Jezyk"("Kod") NOT VALID;


--
-- TOC entry 3311 (class 2606 OID 16570)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_Pracownik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_Pracownik_ID_fkey" FOREIGN KEY ("Pracownik_ID") REFERENCES public."Pracownik"("ID") NOT VALID;


--
-- TOC entry 3312 (class 2606 OID 16676)
-- Name: Jezyk_Pracownik Jezyk_Pracownik_Pracownik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk_Pracownik"
    ADD CONSTRAINT "Jezyk_Pracownik_Pracownik_ID_fkey1" FOREIGN KEY ("Pracownik_ID") REFERENCES public."Pracownik"("ID") NOT VALID;


--
-- TOC entry 3305 (class 2606 OID 16555)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_Jezyk_Kod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_Jezyk_Kod_fkey" FOREIGN KEY ("Jezyk_Kod") REFERENCES public."Jezyk"("Kod") NOT VALID;


--
-- TOC entry 3306 (class 2606 OID 16661)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_Jezyk_Kod_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_Jezyk_Kod_fkey1" FOREIGN KEY ("Jezyk_Kod") REFERENCES public."Jezyk"("Kod") NOT VALID;


--
-- TOC entry 3307 (class 2606 OID 16560)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_Przewodnik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_Przewodnik_ID_fkey" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3308 (class 2606 OID 16666)
-- Name: Jezyk_Przewodnik Jezyk_Przewodnik_Przewodnik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Jezyk_Przewodnik"
    ADD CONSTRAINT "Jezyk_Przewodnik_Przewodnik_ID_fkey1" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3317 (class 2606 OID 16585)
-- Name: Klient_Podroz Klient_Podroz_Klient_Pesel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_Klient_Pesel_fkey" FOREIGN KEY ("Klient_Pesel") REFERENCES public."Klient"("Pesel") NOT VALID;


--
-- TOC entry 3318 (class 2606 OID 16691)
-- Name: Klient_Podroz Klient_Podroz_Klient_Pesel_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_Klient_Pesel_fkey1" FOREIGN KEY ("Klient_Pesel") REFERENCES public."Klient"("Pesel") NOT VALID;


--
-- TOC entry 3319 (class 2606 OID 16590)
-- Name: Klient_Podroz Klient_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3320 (class 2606 OID 16696)
-- Name: Klient_Podroz Klient_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Klient_Podroz"
    ADD CONSTRAINT "Klient_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3293 (class 2606 OID 16530)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_Atrakcja_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_Atrakcja_ID_fkey" FOREIGN KEY ("Atrakcja_ID") REFERENCES public."Atrakcja"("ID") NOT VALID;


--
-- TOC entry 3294 (class 2606 OID 16636)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_Atrakcja_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_Atrakcja_ID_fkey1" FOREIGN KEY ("Atrakcja_ID") REFERENCES public."Atrakcja"("ID") NOT VALID;


--
-- TOC entry 3295 (class 2606 OID 16525)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3296 (class 2606 OID 16631)
-- Name: Podroz_Atrakcja Podroz_Atrakcja_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Podroz_Atrakcja"
    ADD CONSTRAINT "Podroz_Atrakcja_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3313 (class 2606 OID 16580)
-- Name: Pracownik_Podroz Pracownik_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3314 (class 2606 OID 16686)
-- Name: Pracownik_Podroz Pracownik_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3315 (class 2606 OID 16575)
-- Name: Pracownik_Podroz Pracownik_Podroz_Pracownik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_Pracownik_ID_fkey" FOREIGN KEY ("Pracownik_ID") REFERENCES public."Pracownik"("ID") NOT VALID;


--
-- TOC entry 3316 (class 2606 OID 16681)
-- Name: Pracownik_Podroz Pracownik_Podroz_Pracownik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Pracownik_Podroz"
    ADD CONSTRAINT "Pracownik_Podroz_Pracownik_ID_fkey1" FOREIGN KEY ("Pracownik_ID") REFERENCES public."Pracownik"("ID") NOT VALID;


--
-- TOC entry 3301 (class 2606 OID 16550)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3302 (class 2606 OID 16656)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3303 (class 2606 OID 16545)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_Przewodnik_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_Przewodnik_ID_fkey" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3304 (class 2606 OID 16651)
-- Name: Przewodnik_Podroz Przewodnik_Podroz_Przewodnik_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Przewodnik_Podroz"
    ADD CONSTRAINT "Przewodnik_Podroz_Przewodnik_ID_fkey1" FOREIGN KEY ("Przewodnik_ID") REFERENCES public."Przewodnik"("ID") NOT VALID;


--
-- TOC entry 3285 (class 2606 OID 16510)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_Firma_transportowa_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_Firma_transportowa_ID_fkey" FOREIGN KEY ("Firma_transportowa_ID") REFERENCES public."Firma_transportowa"("ID") NOT VALID;


--
-- TOC entry 3286 (class 2606 OID 16616)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_Firma_transportowa_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_Firma_transportowa_ID_fkey1" FOREIGN KEY ("Firma_transportowa_ID") REFERENCES public."Firma_transportowa"("ID") NOT VALID;


--
-- TOC entry 3287 (class 2606 OID 16505)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_Transport_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_Transport_ID_fkey" FOREIGN KEY ("Transport_ID") REFERENCES public."Transport"("ID") NOT VALID;


--
-- TOC entry 3288 (class 2606 OID 16611)
-- Name: Transport_Firma_transportowa Transport_Firma_transportowa_Transport_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Transport_Firma_transportowa"
    ADD CONSTRAINT "Transport_Firma_transportowa_Transport_ID_fkey1" FOREIGN KEY ("Transport_ID") REFERENCES public."Transport"("ID") NOT VALID;


--
-- TOC entry 3289 (class 2606 OID 16520)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_Podroz_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_Podroz_ID_fkey" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3290 (class 2606 OID 16626)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_Podroz_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_Podroz_ID_fkey1" FOREIGN KEY ("Podroz_ID") REFERENCES public."Podroz"("ID") NOT VALID;


--
-- TOC entry 3291 (class 2606 OID 16515)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_Zakwaterowanie_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_Zakwaterowanie_ID_fkey" FOREIGN KEY ("Zakwaterowanie_ID") REFERENCES public."Zakwaterowanie"("ID") NOT VALID;


--
-- TOC entry 3292 (class 2606 OID 16621)
-- Name: Zakwaterowanie_Podroz Zakwaterowanie_Podroz_Zakwaterowanie_ID_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bartek
--

ALTER TABLE ONLY public."Zakwaterowanie_Podroz"
    ADD CONSTRAINT "Zakwaterowanie_Podroz_Zakwaterowanie_ID_fkey1" FOREIGN KEY ("Zakwaterowanie_ID") REFERENCES public."Zakwaterowanie"("ID") NOT VALID;


--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO bartek;


-- Completed on 2022-12-10 00:20:09 UTC

--
-- PostgreSQL database dump complete
--

