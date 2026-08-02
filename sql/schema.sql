
CREATE TABLE Dim_Customer (
    customer_id     VARCHAR(10) PRIMARY KEY,
    customer_name   VARCHAR(100) NOT NULL,
    segment         VARCHAR(20) NOT NULL  
);

CREATE TABLE Dim_Product (
    product_id      VARCHAR(10) PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(30) NOT NULL,  
    sub_category    VARCHAR(30) NOT NULL
);

CREATE TABLE Dim_Location (
    location_id     VARCHAR(10) PRIMARY KEY,
    city            VARCHAR(50) NOT NULL,
    state           VARCHAR(50) NOT NULL,
    region          VARCHAR(20) NOT NULL
);

CREATE TABLE Dim_Shipping (
    shipping_id     VARCHAR(10) PRIMARY KEY,
    ship_mode       VARCHAR(20) NOT NULL,   
    payment_method  VARCHAR(20) NOT NULL,
    order_status    VARCHAR(20) NOT NULL
);

CREATE TABLE Fact_Orders (
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
    FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id),
    FOREIGN KEY (product_id)  REFERENCES Dim_Product(product_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id),
    FOREIGN KEY (shipping_id) REFERENCES Dim_Shipping(shipping_id)
);

CREATE INDEX idx_fact_customer ON Fact_Orders(customer_id);
CREATE INDEX idx_fact_product  ON Fact_Orders(product_id);
CREATE INDEX idx_fact_location ON Fact_Orders(location_id);
CREATE INDEX idx_fact_shipping ON Fact_Orders(shipping_id);
CREATE INDEX idx_fact_date     ON Fact_Orders(order_date);


-- Dim_Customer -> Dim_Product -> Dim_Location -> Dim_Shipping -> Fact_Orders
-- LOAD DATA INFILE 'Dim_Customer.csv' INTO TABLE Dim_Customer
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- (repeat for each table, in the order above)
