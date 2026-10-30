-- Forge game data: classes, stat types, base stats, level gains and settings.
-- Player characters are not included.
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

--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.classes VALUES (1, 'Paladin');
INSERT INTO public.classes VALUES (2, 'Warrior');
INSERT INTO public.classes VALUES (3, 'Black Mage');
INSERT INTO public.classes VALUES (4, 'White Mage');
INSERT INTO public.classes VALUES (5, 'Archer');
INSERT INTO public.classes VALUES (6, 'Scout');
INSERT INTO public.classes VALUES (7, 'Gladiator');


--
-- Data for Name: stat_types; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.stat_types VALUES (1, 'Strength', 'STR', 'physical attack power, carrying capacity');
INSERT INTO public.stat_types VALUES (2, 'Intelligence', 'INT', 'magic power, spell effectiveness');
INSERT INTO public.stat_types VALUES (3, 'Agility', 'AGI', 'speed, dodge chance, critical hit rate');
INSERT INTO public.stat_types VALUES (4, 'Vitality', 'VIT', 'maximum health pool, physical defense');
INSERT INTO public.stat_types VALUES (5, 'Wisdom', 'WIS', 'mana pool, healing effectiveness, magic defense');
INSERT INTO public.stat_types VALUES (6, 'Luck', 'LCK', 'critical hit chance, item drop rates, random event influence');


--
-- Data for Name: class_basestats; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.class_basestats VALUES (1, 1, 7);
INSERT INTO public.class_basestats VALUES (1, 2, 3);
INSERT INTO public.class_basestats VALUES (1, 3, 3);
INSERT INTO public.class_basestats VALUES (1, 4, 8);
INSERT INTO public.class_basestats VALUES (1, 5, 6);
INSERT INTO public.class_basestats VALUES (1, 6, 3);
INSERT INTO public.class_basestats VALUES (2, 1, 9);
INSERT INTO public.class_basestats VALUES (2, 2, 1);
INSERT INTO public.class_basestats VALUES (2, 3, 4);
INSERT INTO public.class_basestats VALUES (2, 4, 9);
INSERT INTO public.class_basestats VALUES (2, 5, 1);
INSERT INTO public.class_basestats VALUES (2, 6, 6);
INSERT INTO public.class_basestats VALUES (3, 1, 1);
INSERT INTO public.class_basestats VALUES (3, 2, 10);
INSERT INTO public.class_basestats VALUES (3, 3, 3);
INSERT INTO public.class_basestats VALUES (3, 4, 2);
INSERT INTO public.class_basestats VALUES (3, 5, 8);
INSERT INTO public.class_basestats VALUES (3, 6, 6);
INSERT INTO public.class_basestats VALUES (4, 1, 1);
INSERT INTO public.class_basestats VALUES (4, 2, 8);
INSERT INTO public.class_basestats VALUES (4, 3, 3);
INSERT INTO public.class_basestats VALUES (4, 4, 2);
INSERT INTO public.class_basestats VALUES (4, 5, 10);
INSERT INTO public.class_basestats VALUES (4, 6, 6);
INSERT INTO public.class_basestats VALUES (5, 1, 8);
INSERT INTO public.class_basestats VALUES (5, 2, 2);
INSERT INTO public.class_basestats VALUES (5, 3, 8);
INSERT INTO public.class_basestats VALUES (5, 4, 4);
INSERT INTO public.class_basestats VALUES (5, 5, 2);
INSERT INTO public.class_basestats VALUES (5, 6, 6);
INSERT INTO public.class_basestats VALUES (6, 1, 5);
INSERT INTO public.class_basestats VALUES (6, 2, 2);
INSERT INTO public.class_basestats VALUES (6, 3, 10);
INSERT INTO public.class_basestats VALUES (6, 4, 4);
INSERT INTO public.class_basestats VALUES (6, 5, 2);
INSERT INTO public.class_basestats VALUES (6, 6, 7);
INSERT INTO public.class_basestats VALUES (7, 1, 10);
INSERT INTO public.class_basestats VALUES (7, 2, 1);
INSERT INTO public.class_basestats VALUES (7, 3, 6);
INSERT INTO public.class_basestats VALUES (7, 4, 6);
INSERT INTO public.class_basestats VALUES (7, 5, 1);
INSERT INTO public.class_basestats VALUES (7, 6, 6);


--
-- Data for Name: class_level_gains; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.class_level_gains VALUES (1, 1, 2);
INSERT INTO public.class_level_gains VALUES (1, 2, 1);
INSERT INTO public.class_level_gains VALUES (1, 3, 1);
INSERT INTO public.class_level_gains VALUES (1, 4, 3);
INSERT INTO public.class_level_gains VALUES (1, 5, 2);
INSERT INTO public.class_level_gains VALUES (1, 6, 1);
INSERT INTO public.class_level_gains VALUES (2, 1, 3);
INSERT INTO public.class_level_gains VALUES (2, 2, 0);
INSERT INTO public.class_level_gains VALUES (2, 3, 1);
INSERT INTO public.class_level_gains VALUES (2, 4, 3);
INSERT INTO public.class_level_gains VALUES (2, 5, 0);
INSERT INTO public.class_level_gains VALUES (2, 6, 1);
INSERT INTO public.class_level_gains VALUES (3, 1, 0);
INSERT INTO public.class_level_gains VALUES (3, 2, 4);
INSERT INTO public.class_level_gains VALUES (3, 3, 1);
INSERT INTO public.class_level_gains VALUES (3, 4, 0);
INSERT INTO public.class_level_gains VALUES (3, 5, 3);
INSERT INTO public.class_level_gains VALUES (3, 6, 1);
INSERT INTO public.class_level_gains VALUES (4, 1, 0);
INSERT INTO public.class_level_gains VALUES (4, 2, 2);
INSERT INTO public.class_level_gains VALUES (4, 3, 1);
INSERT INTO public.class_level_gains VALUES (4, 4, 1);
INSERT INTO public.class_level_gains VALUES (4, 5, 4);
INSERT INTO public.class_level_gains VALUES (4, 6, 1);
INSERT INTO public.class_level_gains VALUES (5, 1, 2);
INSERT INTO public.class_level_gains VALUES (5, 2, 0);
INSERT INTO public.class_level_gains VALUES (5, 3, 3);
INSERT INTO public.class_level_gains VALUES (5, 4, 1);
INSERT INTO public.class_level_gains VALUES (5, 5, 0);
INSERT INTO public.class_level_gains VALUES (5, 6, 3);
INSERT INTO public.class_level_gains VALUES (6, 1, 1);
INSERT INTO public.class_level_gains VALUES (6, 2, 0);
INSERT INTO public.class_level_gains VALUES (6, 3, 4);
INSERT INTO public.class_level_gains VALUES (6, 4, 1);
INSERT INTO public.class_level_gains VALUES (6, 5, 0);
INSERT INTO public.class_level_gains VALUES (6, 6, 3);
INSERT INTO public.class_level_gains VALUES (7, 1, 4);
INSERT INTO public.class_level_gains VALUES (7, 2, 0);
INSERT INTO public.class_level_gains VALUES (7, 3, 2);
INSERT INTO public.class_level_gains VALUES (7, 4, 2);
INSERT INTO public.class_level_gains VALUES (7, 5, 0);
INSERT INTO public.class_level_gains VALUES (7, 6, 1);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.settings OVERRIDING SYSTEM VALUE VALUES (1, 'max_level', '50', 'Max Level for the character');
INSERT INTO public.settings OVERRIDING SYSTEM VALUE VALUES (2, 'xp_multiplier', '100', 'Experience Mulitplier for the character');


--
-- Name: settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.settings_setting_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--


