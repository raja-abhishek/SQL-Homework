/************************************************************
*************************************************************
Schema to pull the fraud detection data
*************************************************************
*************************************************************/

--Create card holder table
CREATE TABLE card_holder(
	customer_id INT NOT NULL PRIMARY KEY,
	customer_name VARCHAR(255)
);

SELECT * FROM card_holder;

--Create credit card table
CREATE TABLE credit_card(
	card VARCHAR(20) NOT NULL PRIMARY KEY,
	customer_id INT NOT NULL,
		FOREIGN KEY (customer_id) REFERENCES card_holder(customer_id)
);

SELECT * FROM credit_card;

--Create table merchant_category
CREATE TABLE merchant_category(
    "id_merchant_category" int   NOT NULL PRIMARY KEY,
    "category_name" varchar(255)
);

SELECT * FROM merchant_category;

--Create table merchant
CREATE TABLE merchant(
	merchant_id INT NOT NULL PRIMARY KEY,
    merchant_name varchar(255),
    id_merchant_category INT NOT NULL,
		FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id_merchant_category)
);

SELECT * FROM merchant;

--Create table transactions
CREATE TABLE transactions(
    transaction_id INT   NOT NULL PRIMARY KEY,
    transaction_date timestamp   NOT NULL,
    transaction_amt float(2)  NOT NULL,
    card varchar(20)   NOT NULL,
    merchant_id INT   NOT NULL
);

SELECT * FROM transactions;
