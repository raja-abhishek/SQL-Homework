/******************************************************************
Merge card_holder,merchant, merchant category and transaction table
*******************************************************************/
CREATE VIEW customer_transaction AS
	SELECT 
		t.*,
		ch.customer_id,
		m.merchant_name,
		mc.category_name
	FROM transactions AS t 
	LEFT JOIN credit_card AS ch ON t.card = ch.card
	LEFT JOIN merchant AS m ON t.merchant_id  = m.merchant_id
	LEFT JOIN merchant_category AS mc ON m.id_merchant_category  = mc.id_merchant_category
	ORDER BY
		ch.customer_id,
		t.transaction_date;
		
SELECT * FROM customer_transaction 

/*********************************************************
Identify <$2 transactions
**********************************************************/
CREATE VIEW lt2_transactions AS
	SELECT 
		A.*,
		B.lt2_trans_cnt,
		B.lt2_trans_cnt*100/A.all_trans_cnt AS percent_lt2_all_tran
	FROM
		(SELECT 
			customer_id,
			COUNT(*) AS all_trans_cnt
		FROM
			customer_transaction 
		GROUP BY customer_id) AS A
	LEFT JOIN
		(SELECT 
			customer_id,
			COUNT(*) AS lt2_trans_cnt
		FROM
			customer_transaction 
		WHERE transaction_amt < 2
		GROUP BY customer_id) AS B
	ON 
		A.customer_id = B.customer_id;
		
SELECT * FROM lt2_transactions;

/*********************************************************
make your investigation a step futher by considering the 
time period in which potentially fraudulent transactions 
are made.
**********************************************************/

-- What are the top 100 highest transactions made between 7:00 am and 9:00 am?

CREATE VIEW top100_transactions_7to9  AS
		SELECT 
			*,
			extract(HOUR from transaction_date) as HR
		FROM
			customer_transaction 
		WHERE 
			extract(HOUR from transaction_date) >=7 and 
			extract(HOUR from transaction_date) < 9
		order by transaction_amt DESC;
			
select * from top100_transactions_7to9
LIMIT 100;

-- What are the top 100 highest transactions made outside 7:00 am and 9:00 am?

CREATE VIEW top100_transactions_outside7to9  AS
		SELECT 
			*,
			extract(HOUR from transaction_date) as HR
		FROM
			customer_transaction 
		WHERE 
			extract(HOUR from transaction_date) < 7 or 
			extract(HOUR from transaction_date) >= 9
		order by transaction_amt DESC;
			
select * from top100_transactions_outside7to9
LIMIT 100;

-- What are the top 5 merchants prone to being hacked using small transactions?
DROP VIEW merchant_hack_prone;
CREATE VIEW merchant_hack_prone  AS
	SELECT 
		merchant_name,
		COUNT(*) AS transaction_cnt
	FROM 
		customer_transaction 
	WHERE 
		transaction_amt < 2
	GROUP BY 1
	ORDER BY transaction_cnt DESC;

SELECT * FROM merchant_hack_prone;
