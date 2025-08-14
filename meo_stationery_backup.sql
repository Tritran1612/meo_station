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
-- Name: Gender; Type: TYPE; Schema: public; Owner: meo_admin
--

CREATE TYPE public."Gender" AS ENUM (
    'Male',
    'Female',
    'Other'
);


ALTER TYPE public."Gender" OWNER TO meo_admin;

--
-- Name: OrderStatus; Type: TYPE; Schema: public; Owner: meo_admin
--

CREATE TYPE public."OrderStatus" AS ENUM (
    'PENDING',
    'PROCESSING',
    'SHIPPED',
    'DELIVERED',
    'CANCELLED'
);


ALTER TYPE public."OrderStatus" OWNER TO meo_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Address; Type: TABLE; Schema: public; Owner: meo_admin
--

CREATE TABLE public."Address" (
    id integer NOT NULL,
    street text NOT NULL,
    ward text,
    district text,
    city text,
    country text,
    apartment text
);


ALTER TABLE public."Address" OWNER TO meo_admin;

--
-- Name: Address_id_seq; Type: SEQUENCE; Schema: public; Owner: meo_admin
--

CREATE SEQUENCE public."Address_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Address_id_seq" OWNER TO meo_admin;

--
-- Name: Address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meo_admin
--

ALTER SEQUENCE public."Address_id_seq" OWNED BY public."Address".id;


--
-- Name: Order; Type: TABLE; Schema: public; Owner: meo_admin
--

CREATE TABLE public."Order" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    status public."OrderStatus" DEFAULT 'PENDING'::public."OrderStatus" NOT NULL,
    "createdAt" text NOT NULL
);


ALTER TABLE public."Order" OWNER TO meo_admin;

--
-- Name: OrderItem; Type: TABLE; Schema: public; Owner: meo_admin
--

CREATE TABLE public."OrderItem" (
    "orderId" integer NOT NULL,
    "productId" text NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public."OrderItem" OWNER TO meo_admin;

--
-- Name: Order_id_seq; Type: SEQUENCE; Schema: public; Owner: meo_admin
--

CREATE SEQUENCE public."Order_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Order_id_seq" OWNER TO meo_admin;

--
-- Name: Order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meo_admin
--

ALTER SEQUENCE public."Order_id_seq" OWNED BY public."Order".id;


--
-- Name: Payment; Type: TABLE; Schema: public; Owner: meo_admin
--

CREATE TABLE public."Payment" (
    id integer NOT NULL,
    "orderId" integer NOT NULL,
    amount integer NOT NULL,
    method text NOT NULL,
    status text NOT NULL,
    "createdAt" text NOT NULL
);


ALTER TABLE public."Payment" OWNER TO meo_admin;

--
-- Name: Payment_id_seq; Type: SEQUENCE; Schema: public; Owner: meo_admin
--

CREATE SEQUENCE public."Payment_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Payment_id_seq" OWNER TO meo_admin;

--
-- Name: Payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meo_admin
--

ALTER SEQUENCE public."Payment_id_seq" OWNED BY public."Payment".id;


--
-- Name: Product; Type: TABLE; Schema: public; Owner: meo_admin
--

CREATE TABLE public."Product" (
    id text NOT NULL,
    name text NOT NULL,
    price integer NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public."Product" OWNER TO meo_admin;

--
-- Name: User; Type: TABLE; Schema: public; Owner: meo_admin
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    "fullName" text NOT NULL,
    email text NOT NULL,
    gender public."Gender" NOT NULL,
    "dateOfBirth" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "addressId" integer NOT NULL
);


ALTER TABLE public."User" OWNER TO meo_admin;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: meo_admin
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."User_id_seq" OWNER TO meo_admin;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meo_admin
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: meo_admin
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO meo_admin;

--
-- Name: Address id; Type: DEFAULT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Address" ALTER COLUMN id SET DEFAULT nextval('public."Address_id_seq"'::regclass);


--
-- Name: Order id; Type: DEFAULT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Order" ALTER COLUMN id SET DEFAULT nextval('public."Order_id_seq"'::regclass);


--
-- Name: Payment id; Type: DEFAULT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Payment" ALTER COLUMN id SET DEFAULT nextval('public."Payment_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Data for Name: Address; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."Address" (id, street, ward, district, city, country, apartment) FROM stdin;
\.


--
-- Data for Name: Order; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."Order" (id, "userId", status, "createdAt") FROM stdin;
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
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: meo_admin
--

COPY public."User" (id, "fullName", email, gender, "dateOfBirth", "createdAt", "addressId") FROM stdin;
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
-- Name: Address Address_pkey; Type: CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Address"
    ADD CONSTRAINT "Address_pkey" PRIMARY KEY (id);


--
-- Name: OrderItem OrderItem_pkey; Type: CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_pkey" PRIMARY KEY ("orderId", "productId");


--
-- Name: Order Order_pkey; Type: CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_pkey" PRIMARY KEY (id);


--
-- Name: Payment Payment_pkey; Type: CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_pkey" PRIMARY KEY (id);


--
-- Name: Product Product_pkey; Type: CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: meo_admin
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: OrderItem OrderItem_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: OrderItem OrderItem_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Order Order_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Payment Payment_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: User User_addressId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: meo_admin
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_addressId_fkey" FOREIGN KEY ("addressId") REFERENCES public."Address"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

