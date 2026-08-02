-- ============================================================
-- URBANCART -- E-Commerce Sales Analytics
-- Star Schema | MySQL
-- orders (fact) + customers, products, location, shipping
-- ============================================================

CREATE TABLE customers (
    customer_id     VARCHAR(10) PRIMARY KEY,
    customer_name   VARCHAR(100) NOT NULL,
    segment         VARCHAR(20) NOT NULL   -- Consumer, Corporate, Home Office
) ENGINE=InnoDB;

CREATE TABLE products (
    product_id      VARCHAR(10) PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(30) NOT NULL,   -- Electronics, Furniture, Clothing
    sub_category    VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE location (
    location_id     VARCHAR(10) PRIMARY KEY,
    city            VARCHAR(50) NOT NULL,
    state           VARCHAR(50) NOT NULL,
    region          VARCHAR(20) NOT NULL   -- North, South, East, West
) ENGINE=InnoDB;

CREATE TABLE shipping (
    shipping_id     VARCHAR(10) PRIMARY KEY,
    ship_mode       VARCHAR(20) NOT NULL,   -- Standard, Express, Same Day
    payment_method  VARCHAR(20) NOT NULL,   -- Card, UPI, COD
    order_status    VARCHAR(20) NOT NULL    -- Delivered, Cancelled, Returned
) ENGINE=InnoDB;

CREATE TABLE orders (
    order_id        VARCHAR(10)   NOT NULL,
    order_date      DATE          NOT NULL,
    customer_id     VARCHAR(10)   NOT NULL,
    product_id      VARCHAR(10)   NOT NULL,
    location_id     VARCHAR(10)   NOT NULL,
    shipping_id     VARCHAR(10)   NOT NULL,
    quantity        INT           NOT NULL,
    sales           DECIMAL(12,2) NOT NULL,
    discount        DECIMAL(4,2)  NOT NULL,   -- stored as a fraction, e.g. 0.15 = 15%
    profit          DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (shipping_id) REFERENCES shipping(shipping_id)
) ENGINE=InnoDB;

-- Load order (respects FK constraints):
-- customers -> products -> location -> shipping -> orders
-- LOAD DATA INFILE 'customers.csv' INTO TABLE customers
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- (repeat for each table, in the order above)
