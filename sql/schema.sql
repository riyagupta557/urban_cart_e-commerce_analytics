-- ============================================================
-- URBANCART -- E-Commerce Sales Analytics
-- ============================================================

CREATE TABLE customers (
    customer_id     VARCHAR(10) PRIMARY KEY,
    customer_name   VARCHAR(100) NOT NULL,
    segment         VARCHAR(20) NOT NULL  
);

CREATE TABLE products (
    product_id      VARCHAR(10) PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(30) NOT NULL,   
    sub_category    VARCHAR(30) NOT NULL
);

CREATE TABLE location (
    location_id     VARCHAR(10) PRIMARY KEY,
    city            VARCHAR(50) NOT NULL,
    state           VARCHAR(50) NOT NULL,
    region          VARCHAR(20) NOT NULL   
);

CREATE TABLE shipping (
    shipping_id     VARCHAR(10) PRIMARY KEY,
    ship_mode       VARCHAR(20) NOT NULL,  
    payment_method  VARCHAR(20) NOT NULL,   
    order_status    VARCHAR(20) NOT NULL   
);

CREATE TABLE orders (
    order_id        VARCHAR(10)   NOT NULL,
    order_date      DATE          NOT NULL,
    customer_id     VARCHAR(10)   NOT NULL,
    product_id      VARCHAR(10)   NOT NULL,
    location_id     VARCHAR(10)   NOT NULL,
    shipping_id     VARCHAR(10)   NOT NULL,
    quantity        INT           NOT NULL,
    sales           DECIMAL(12,2) NOT NULL,
    discount        DECIMAL(4,2)  NOT NULL,  
    profit          DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (shipping_id) REFERENCES shipping(shipping_id)
);


