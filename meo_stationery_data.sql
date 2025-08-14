--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13
-- Dumped by pg_dump version 15.13

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
-- Data for Name: Address; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."Address" (id, street, ward, district, city, country, apartment) FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."User" (id, "fullName", email, gender, "dateOfBirth", "createdAt", "addressId") FROM stdin;
\.


--
-- Data for Name: Order; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."Order" (id, "userId", status, "createdAt") FROM stdin;
\.


--
-- Data for Name: Product; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."Product" (id, name, price, description, "createdAt", quantity) FROM stdin;
A	Premium Spiral Notebook	15000	High-quality spiral notebook perfect for students and professionals	2025-08-09 13:42:00.649	50
B	Gel Pen Set	25000	Smooth writing gel pens in multiple colors	2025-08-09 13:42:00.651	100
C	Colored Pencil Set	45000	Professional grade colored pencils for artists	2025-08-09 13:42:00.653	30
D	Document Organizer	35000	Keep your documents organized and accessible	2025-08-09 13:42:00.655	25
E	Student Starter Kit	55000	Complete kit for students with essential supplies	2025-08-09 13:42:00.656	40
F	Weekly Planner	28000	Stay organized with this beautiful weekly planner	2025-08-09 13:42:00.657	35
G	Craft Paper Bundle	20000	Assorted craft papers for all your creative projects	2025-08-09 13:42:00.658	60
H	Highlighter Set	18000	Bright highlighters for studying and note-taking	2025-08-09 13:42:00.659	80
J	Leather Bound Journal	65000	Elegant leather journal for special thoughts	2025-08-09 13:42:00.66	20
K	Eraser Collection	12000	Various erasers for different needs	2025-08-09 13:42:00.662	90
L	Label Maker Kit	42000	Create professional labels for organization	2025-08-09 13:42:00.663	15
M	Permanent Marker Set	32000	Long-lasting permanent markers for various surfaces	2025-08-09 13:42:00.664	45
N	Hardcover Notebook	38000	Durable hardcover notebook for important notes	2025-08-09 13:42:00.665	30
O	Desk Organizer Set	48000	Complete desk organization solution	2025-08-09 13:42:00.666	25
P	Premium Paper Stack	22000	High-quality paper for printing and writing	2025-08-09 13:42:00.668	70
\.


--
-- Data for Name: OrderItem; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."OrderItem" ("orderId", "productId", quantity) FROM stdin;
\.


--
-- Data for Name: Payment; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."Payment" (id, "orderId", amount, method, status, "createdAt") FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
28975c29-d77f-4ade-bbd5-8a4623ec51e0	4784c099a3b18847cc44658dff082b11d8114e4bbebfffb72b1ffdc6774c377c	2025-08-09 04:27:47.580894+00	20250809042747_init	\N	\N	2025-08-09 04:27:47.538217+00	1
\.


--
-- Name: Address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meo_admin
--

SELECT pg_catalog.setval('public."Address_id_seq"', 1, false);


--
-- Name: Order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meo_admin
--

SELECT pg_catalog.setval('public."Order_id_seq"', 1, false);


--
-- Name: Payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meo_admin
--

SELECT pg_catalog.setval('public."Payment_id_seq"', 1, false);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meo_admin
--

SELECT pg_catalog.setval('public."User_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

