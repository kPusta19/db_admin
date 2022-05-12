CREATE DATABASE userdb;
\c userdb
CREATE USER admin WITH SUPERUSER PASSWORD 'admin';
ALTER DATABASE userdb OWNER TO admin;
CREATE USER seller WITH PASSWORD 'seller';
CREATE USER manager WITH PASSWORD 'manager';
BEGIN;

CREATE TABLE IF NOT EXISTS public.buyer
(
    id serial NOT NULL,
    name character varying(150) NOT NULL,
    telephone character varying(11) NOT NULL,
    cash integer NOT NULL,
    email character varying,
    birthday date,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.order_
(
    id serial NOT NULL,
    buyer_id integer NOT NULL,
    branch_id integer NOT NULL,
    price numeric(9, 2) DEFAULT 0,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.product
(
    id serial NOT NULL,
    name character varying(100) NOT NULL,
    price numeric(9, 2) NOT NULL,
    producer character varying(100) NOT NULL,
    article integer NOT NULL,
    rating numeric(3, 2),
    guarantee integer,
    weight integer NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.staff
(
    id serial NOT NULL,
    branch_id integer NOT NULL,
    name character varying(120) NOT NULL,
    passport character varying(10) NOT NULL,
    position character varying(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.branch
(
    id serial NOT NULL,
    address character varying(120) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.sclad
(
    id serial NOT NULL,
    address character varying(120) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.category
(
    id serial NOT NULL,
    name character varying(120) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.product_category
(
    product_id integer NOT NULL,
    category_id integer NOT NULL,
    PRIMARY KEY (product_id, category_id)
);

CREATE TABLE IF NOT EXISTS public.order_product
(
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    amount integer NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE IF NOT EXISTS public.branch_product
(
    branch_id integer NOT NULL,
    product_id integer NOT NULL,
    amount integer NOT NULL,
    PRIMARY KEY (branch_id, product_id)
);

CREATE TABLE IF NOT EXISTS public.sclad_product
(
    sclad_id integer NOT NULL,
    product_id integer NOT NULL,
    amount integer NOT NULL,
    PRIMARY KEY (sclad_id, product_id)
);

ALTER TABLE IF EXISTS public.order_
    ADD FOREIGN KEY (buyer_id)
    REFERENCES public.buyer (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.staff
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.product_category
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.product_category
    ADD FOREIGN KEY (category_id)
    REFERENCES public.category (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_product
    ADD FOREIGN KEY (order_id)
    REFERENCES public.order_ (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.branch_product
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.branch_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sclad_product
    ADD FOREIGN KEY (sclad_id)
    REFERENCES public.sclad (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sclad_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;






CREATE OR REPLACE PROCEDURE discount( orderId integer, x integer) AS 
$$ 
    UPDATE public.order_
    SET price = price - (price * x / 100)
    WHERE id = orderId;
$$ 
LANGUAGE SQL;



CREATE OR REPLACE FUNCTION get_product_price( product_id integer) RETURNS numeric AS 
$$ 
    SELECT price FROM public.product WHERE id = product_id;
$$ 
LANGUAGE SQL;


CREATE OR REPLACE FUNCTION get_product_amount( orderId IN integer,productId IN integer, result OUT integer) AS 
$$ 
    SELECT amount FROM public.order_product WHERE order_id = orderId and product_id=productId;
$$ 
LANGUAGE SQL;



CREATE OR REPLACE PROCEDURE update_order_price( orderId integer,productId integer) AS 
$$ 
    UPDATE public.order_
    SET price = price + (get_product_price(productId)*get_product_amount(id, productId))
    WHERE id = orderId;
$$ 
LANGUAGE SQL;

CREATE OR REPLACE PROCEDURE del_update_order_price( orderId integer,productId integer, old_amount integer) AS 
$$ 
    UPDATE public.order_
    SET price = price - (get_product_price(productId)*old_amount)
    WHERE id = orderId;
$$ 
LANGUAGE SQL;

CREATE FUNCTION tg_update_order_price() RETURNS TRIGGER AS 
$$
BEGIN 
        CALL update_order_price(NEW.order_id, NEW.product_id);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_update 
AFTER INSERT ON public.order_product 
FOR EACH ROW EXECUTE PROCEDURE tg_update_order_price();

CREATE FUNCTION tg_del_update_order_price() RETURNS TRIGGER AS 
$$
BEGIN 
        CALL del_update_order_price(OLD.order_id, OLD.product_id, OLD.amount);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_del_update 
AFTER DELETE ON public.order_product 
FOR EACH ROW EXECUTE PROCEDURE tg_del_update_order_price();

END;



CREATE TABLE IF NOT EXISTS public.staff
(
    id serial NOT NULL,
    branch_id integer NOT NULL,
    name character varying(120) NOT NULL,
    passport character varying(10) NOT NULL,
    position character varying(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.branch
(
    id serial NOT NULL,
    address character varying(120) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.sclad
(
    id serial NOT NULL,
    address character varying(120) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.category
(
    id serial NOT NULL,
    name character varying(120) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.product_category
(
    product_id integer NOT NULL,
    category_id integer NOT NULL,
    PRIMARY KEY (product_id, category_id)
);

CREATE TABLE IF NOT EXISTS public.order_product
(
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    amount integer NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE IF NOT EXISTS public.branch_product
(
    branch_id integer NOT NULL,
    product_id integer NOT NULL,
    amount integer NOT NULL,
    PRIMARY KEY (branch_id, product_id)
);

CREATE TABLE IF NOT EXISTS public.sclad_product
(
    sclad_id integer NOT NULL,
    product_id integer NOT NULL,
    amount integer NOT NULL,
    PRIMARY KEY (sclad_id, product_id)
);

ALTER TABLE IF EXISTS public.order_
    ADD FOREIGN KEY (buyer_id)
    REFERENCES public.buyer (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.staff
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.product_category
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.product_category
    ADD FOREIGN KEY (category_id)
    REFERENCES public.category (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_product
    ADD FOREIGN KEY (order_id)
    REFERENCES public.order_ (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.branch_product
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.branch_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sclad_product
    ADD FOREIGN KEY (sclad_id)
    REFERENCES public.sclad (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sclad_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;






CREATE OR REPLACE PROCEDURE discount( orderId integer, x integer) AS 
$$ 
    UPDATE public.order_
    SET price = price - (price * x / 100)
    WHERE id = orderId;
$$ 
LANGUAGE SQL;



CREATE OR REPLACE FUNCTION get_product_price( product_id integer) RETURNS numeric AS 
$$ 
    SELECT price FROM public.product WHERE id = product_id;
$$ 
LANGUAGE SQL;


CREATE OR REPLACE FUNCTION get_product_amount( orderId IN integer,productId IN integer, result OUT integer) AS 
$$ 
    SELECT amount FROM public.order_product WHERE order_id = orderId and product_id=productId;
$$ 
LANGUAGE SQL;



CREATE OR REPLACE PROCEDURE update_order_price( orderId integer,productId integer) AS 
$$ 
    UPDATE public.order_
    SET price = price + (get_product_price(productId)*get_product_amount(id, productId))
    WHERE id = orderId;
$$ 
LANGUAGE SQL;

CREATE OR REPLACE PROCEDURE del_update_order_price( orderId integer,productId integer, old_amount integer) AS 
$$ 
    UPDATE public.order_
    SET price = price - (get_product_price(productId)*old_amount)
    WHERE id = orderId;
$$ 
LANGUAGE SQL;

CREATE FUNCTION tg_update_order_price() RETURNS TRIGGER AS 
$$
BEGIN 
        CALL update_order_price(NEW.order_id, NEW.product_id);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_update 
AFTER INSERT ON public.order_product 
FOR EACH ROW EXECUTE PROCEDURE tg_update_order_price();

CREATE FUNCTION tg_del_update_order_price() RETURNS TRIGGER AS 
$$
BEGIN 
        CALL del_update_order_price(OLD.order_id, OLD.product_id, OLD.amount);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_del_update 
AFTER DELETE ON public.order_product 
FOR EACH ROW EXECUTE PROCEDURE tg_del_update_order_price();

END;


CREATE TABLE IF NOT EXISTS public.sclad_product
(
    sclad_id integer NOT NULL,
    product_id integer NOT NULL,
    amount integer NOT NULL,
    PRIMARY KEY (sclad_id, product_id)
);

ALTER TABLE IF EXISTS public.order_
    ADD FOREIGN KEY (buyer_id)
    REFERENCES public.buyer (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.staff
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.product_category
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.product_category
    ADD FOREIGN KEY (category_id)
    REFERENCES public.category (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_product
    ADD FOREIGN KEY (order_id)
    REFERENCES public.order_ (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.branch_product
    ADD FOREIGN KEY (branch_id)
    REFERENCES public.branch (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.branch_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sclad_product
    ADD FOREIGN KEY (sclad_id)
    REFERENCES public.sclad (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sclad_product
    ADD FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;






CREATE OR REPLACE PROCEDURE discount( orderId integer, x integer) AS 
$$ 
    UPDATE public.order_
    SET price = price - (price * x / 100)
    WHERE id = orderId;
$$ 
LANGUAGE SQL;



CREATE OR REPLACE FUNCTION get_product_price( product_id integer) RETURNS numeric AS 
$$ 
    SELECT price FROM public.product WHERE id = product_id;
$$ 
LANGUAGE SQL;


CREATE OR REPLACE FUNCTION get_product_amount( orderId IN integer,productId IN integer, result OUT integer) AS 
$$ 
    SELECT amount FROM public.order_product WHERE order_id = orderId and product_id=productId;
$$ 
LANGUAGE SQL;



CREATE OR REPLACE PROCEDURE update_order_price( orderId integer,productId integer) AS 
$$ 
    UPDATE public.order_
    SET price = price + (get_product_price(productId)*get_product_amount(id, productId))
    WHERE id = orderId;
$$ 
LANGUAGE SQL;

CREATE OR REPLACE PROCEDURE del_update_order_price( orderId integer,productId integer, old_amount integer) AS 
$$ 
    UPDATE public.order_
    SET price = price - (get_product_price(productId)*old_amount)
    WHERE id = orderId;
$$ 
LANGUAGE SQL;

CREATE FUNCTION tg_update_order_price() RETURNS TRIGGER AS 
$$
BEGIN 
        CALL update_order_price(NEW.order_id, NEW.product_id);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_update 
AFTER INSERT ON public.order_product 
FOR EACH ROW EXECUTE PROCEDURE tg_update_order_price();

CREATE FUNCTION tg_del_update_order_price() RETURNS TRIGGER AS 
$$
BEGIN 
        CALL del_update_order_price(OLD.order_id, OLD.product_id, OLD.amount);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_del_update 
AFTER DELETE ON public.order_product 
FOR EACH ROW EXECUTE PROCEDURE tg_del_update_order_price();

END;


