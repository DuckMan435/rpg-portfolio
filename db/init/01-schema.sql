-- Forge database schema (tables, keys, constraints). Exported with pg_dump --schema-only.
-- Postgres runs files in /docker-entrypoint-initdb.d on first start of an empty volume.
--
-- PostgreSQL database dump
--


-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.6 (Debian 18.6-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.characters (
    character_id integer NOT NULL,
    character_name character varying(30) NOT NULL,
    level integer DEFAULT 1 NOT NULL,
    current_xp integer DEFAULT 0 NOT NULL,
    class_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT characters_name_format CHECK (((character_name)::text ~ '^[a-zA-Z0-9 ]+$'::text))
);


--
-- Name: characters_character_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.characters ALTER COLUMN character_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.characters_character_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_basestats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_basestats (
    class_id integer NOT NULL,
    stat_id integer NOT NULL,
    value integer
);


--
-- Name: class_level_gains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_level_gains (
    class_id integer NOT NULL,
    stat_id integer NOT NULL,
    gain_value integer NOT NULL
);


--
-- Name: classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classes (
    class_id integer CONSTRAINT class_id_not_null NOT NULL,
    class_name character varying CONSTRAINT class_name_not_null NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    setting_id integer NOT NULL,
    setting_name character varying(30) NOT NULL,
    setting_value character varying(30) NOT NULL,
    setting_description character varying(255)
);


--
-- Name: settings_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.settings ALTER COLUMN setting_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.settings_setting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stat_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stat_types (
    stat_id integer CONSTRAINT attributetype_id_not_null NOT NULL,
    stat_type character varying CONSTRAINT attributetype_attribute_not_null NOT NULL,
    stat_abbreviation character varying,
    stat_description character varying
);


--
-- Name: stat_types attributetype_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stat_types
    ADD CONSTRAINT attributetype_pk PRIMARY KEY (stat_id);


--
-- Name: stat_types attributetype_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stat_types
    ADD CONSTRAINT attributetype_unique UNIQUE (stat_type);


--
-- Name: characters characters_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pk PRIMARY KEY (character_id);


--
-- Name: characters characters_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_unique UNIQUE (character_name);


--
-- Name: class_basestats class_basestats_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_basestats
    ADD CONSTRAINT class_basestats_pk PRIMARY KEY (class_id, stat_id);


--
-- Name: class_level_gains class_level_gains_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_level_gains
    ADD CONSTRAINT class_level_gains_pk PRIMARY KEY (class_id, stat_id);


--
-- Name: classes class_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT class_pk PRIMARY KEY (class_id);


--
-- Name: settings settings_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (setting_id);


--
-- Name: settings settings_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_unique UNIQUE (setting_name);


--
-- Name: characters characters_classes_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_classes_fk FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: class_basestats class_basestats_classes_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_basestats
    ADD CONSTRAINT class_basestats_classes_fk FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: class_basestats class_basestats_stat_types_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_basestats
    ADD CONSTRAINT class_basestats_stat_types_fk FOREIGN KEY (stat_id) REFERENCES public.stat_types(stat_id);


--
-- Name: class_level_gains class_level_gains_classes_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_level_gains
    ADD CONSTRAINT class_level_gains_classes_fk FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: class_level_gains class_level_gains_stat_types_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_level_gains
    ADD CONSTRAINT class_level_gains_stat_types_fk FOREIGN KEY (stat_id) REFERENCES public.stat_types(stat_id);


--
-- PostgreSQL database dump complete
--


