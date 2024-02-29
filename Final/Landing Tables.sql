
exec sp_help '[Landing].[L_CDW_SAPP_CUSTOMER]';

---------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE  [Landing].[U_CDW_SAPP_D_CUSTOMER]
SELECT * FROM [Landing].[U_CDW_SAPP_D_CUSTOMER]

--------------------------------------------------------UPDATING CUSTOMER TABLE-------------------------------------------------------
DROP PROCEDURE IF EXISTS CUSTOMER_LANDING
CREATE PROCEDURE CUSTOMER_LANDING
AS BEGIN
	DROP TABLE IF EXISTS [Landing].[U_CDW_SAPP_D_CUSTOMER]
	CREATE TABLE [Landing].[U_CDW_SAPP_D_CUSTOMER]  (
	   CUST_ID NUMERIC(9) PRIMARY KEY,
	   CUST_F_NAME VARCHAR(255),
	   CUST_M_NAME VARCHAR(255),
	   CUST_L_NAME VARCHAR(255),
	   CUST_SSN NUMERIC(9),
	   CUST_STREET VARCHAR(255),
	   CUST_CITY VARCHAR(255),
	   CUST_STATE VARCHAR(255),
	   CUST_COUNTRY VARCHAR(255),
	   CUST_ZIP NUMERIC(7),
	   CUST_PHONE VARCHAR(15),
	   CUST_EMAIL VARCHAR(255),
	   LOADING_DATE DATETIME,
	   SOURCE_DATA VARCHAR(MAX)
	);
	INSERT INTO [Landing].[U_CDW_SAPP_D_CUSTOMER] 
	(
	   CUST_ID,
	   CUST_F_NAME,
	   CUST_M_NAME,
	   CUST_L_NAME,
	   CUST_SSN,
	   CUST_STREET,
	   CUST_CITY,
	   CUST_STATE,
	   CUST_COUNTRY,
	   CUST_ZIP,
	   CUST_PHONE,
	   CUST_EMAIL,
	   LOADING_DATE, 
	   SOURCE_DATA
	)
	SELECT  
	   ROW_NUMBER() OVER (ORDER BY SSN) AS CUST_ID,
	   UPPER(LEFT(FIRST_NAME, 1)) + LOWER(SUBSTRING(FIRST_NAME, 2, LEN(FIRST_NAME))) AS CUST_F_NAME,
	   LOWER(MIDDLE_NAME) AS CUST_M_NAME,
	   UPPER(LEFT(LAST_NAME, 1)) + LOWER(SUBSTRING(LAST_NAME, 2, LEN(LAST_NAME))) AS CUST_L_NAME,
	   TRY_CAST(REPLACE(LTRIM(RTRIM(SSN)), ' ', '') AS BIGINT) AS CUST_SSN,
	   CONCAT(DOOR_NO, ', ', STREET_NAME) AS CUST_STREET,
	   CUST_CITY,
	   CUST_STATE,
	   CUST_COUNTRY,
	   TRY_CAST(ISNULL(NULLIF(LTRIM(RTRIM([CUST_ZIP])), ''), '0') AS INT) AS CUST_ZIP,
	   SUBSTRING(CUST_PHONE, 1, 3) + '-' + SUBSTRING(CUST_PHONE, 4, 3) + '-' + SUBSTRING(CUST_PHONE, 7, 4) AS CUST_PHONE,
	   [CUST_EMAIL ], 
	   GETDATE() AS LOADING_DATE,
	   'CDW_SAPP_CUSTOMER' AS SOURCE_DATA
	FROM [dbo].[CDW_SAPP_CUSTOMER]; 
END;
EXEC CUSTOMER_LANDING

SELECT * FROM [dbo].[CDW_SAPP_CUSTOMER]


------------------------------------------------------------------------------------------------------------------------
SELECT * FROM [Landing].[U_CDW_SAPP_D_SUPPLIER];
DROP TABLE [Landing].[U_CDW_SAPP_D_SUPPLIER]
--------------------------------------------------------SUPPLIER UPDATED TABLE--------------------------------------------------------

DROP PROCEDURE IF EXISTS SUPPLIER_LANDING
CREATE PROCEDURE SUPPLIER_LANDING
AS BEGIN
	DROP TABLE IF EXISTS [Landing].[U_CDW_SAPP_D_SUPPLIER]
	CREATE TABLE [Landing].[U_CDW_SAPP_D_SUPPLIER] (
	   SUPPLIER_ID NUMERIC(10) PRIMARY KEY,
	   SUPPLIER_NAME VARCHAR(255),
	   SUPPLIER_SSN NUMERIC(9),
	   SUPPLIER_PHONE VARCHAR(15),
	   SUPPLIER_LOC VARCHAR(255),
	   LOADING_DATE DATETIME,
	   SOURCE_DATA VARCHAR(MAX)
	);

	INSERT INTO [Landing].[U_CDW_SAPP_D_SUPPLIER] (
	   SUPPLIER_ID,
	   SUPPLIER_NAME,
	   SUPPLIER_SSN,
	   SUPPLIER_PHONE,
	   SUPPLIER_LOC,
	   LOADING_DATE, 
	   SOURCE_DATA
	)
	SELECT
	   ROW_NUMBER() OVER (ORDER BY SUPPLIER_SSN) AS SUPPLIER_ID,
	   REPLACE(SUPPLIER_NAME, '%', '') AS SUPPLIER_NAME,
	   CAST(SUPPLIER_SSN AS BIGINT) AS SUPPLIER_SSN,
	   SUBSTRING(cast(SUPPLIER_PHONE as varchar) , 1, 3) + '-' + SUBSTRING(cast(SUPPLIER_PHONE as varchar), 4, 3) + '-' + SUBSTRING(cast(SUPPLIER_PHONE as varchar), 7, 4) 
	   AS SUPPLIER_PHONE,
	   SUPPLIER_LOC,  
	   GETDATE() AS LOADING_DATE, 
	   'CDW_SAPP_SUPPLIER' AS SOURCE_DATA
	FROM [dbo].[CDW_SAPP_SUPPLIER];
END;

EXEC SUPPLIER_LANDING

--------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM [Landing].[U_CDW_SAPP_D_PRODUCT]
DROP TABLE [Landing].[U_CDW_SAPP_D_PRODUCT]

-----------------------------------------------------PRODUCT UPDATED TABLE------------------------------------------------------------
DROP PROCEDURE IF EXISTS PRODUCT_LANDING
CREATE PROCEDURE PRODUCT_LANDING
AS BEGIN
	DROP TABLE IF EXISTS [Landing].[U_CDW_SAPP_D_PRODUCT]
	CREATE TABLE [Landing].[U_CDW_SAPP_D_PRODUCT] (
	   PRODUCT_CODE NUMERIC(11) PRIMARY KEY,
	   PRODUCT_NAME VARCHAR(255),
	   SUPPLIER_ID NUMERIC(10) FOREIGN KEY REFERENCES [Landing].[U_CDW_SAPP_D_SUPPLIER](SUPPLIER_ID),
	   PRODUCT_PRICE VARCHAR(9),
	   LOADING_DATE DATETIME,
	   SOURCE_DATA VARCHAR(MAX)
	);
	INSERT INTO [Landing].[U_CDW_SAPP_D_PRODUCT] (
	   PRODUCT_CODE,
	   PRODUCT_NAME,
	   SUPPLIER_ID,
	   PRODUCT_PRICE,
	   LOADING_DATE, 
	   SOURCE_DATA
	)
	SELECT
	   TRY_CAST(P.PRODUCT_CODE AS NUMERIC(15)) AS PRODUCT_CODE,
	   RTRIM(LTRIM(P.PRODUCT_NAME)) AS PRODUCT_NAME,
	   S.SUPPLIER_ID,
	   P.PRODUCT_PRICE,
	   GETDATE() AS LOADING_DATE, 
	   'CDW_SAPP_PRODUCT' AS SOURCE_DATA
	FROM
	   [dbo].[CDW_SAPP_PRODUCT] P
	JOIN
	   [Landing].[U_CDW_SAPP_D_SUPPLIER] S 
	   ON P.SUPPLIER_SSN = S.SUPPLIER_SSN;
END;
EXEC PRODUCT_LANDING

----------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE [Landing].[U_CDW_SAPP_D_BRANCH]
SELECT * FROM [Landing].[U_CDW_SAPP_D_BRANCH]

----------------------------------------------------------BRANCH UPDATED TABLE------------------------------------------------------------

DROP PROCEDURE IF EXISTS BRANCH_LANDING
CREATE PROCEDURE BRANCH_LANDING
AS BEGIN
	DROP TABLE IF EXISTS [Landing].[U_CDW_SAPP_D_BRANCH]
	CREATE TABLE [Landing].[U_CDW_SAPP_D_BRANCH] (
	   BRANCH_CODE NUMERIC(9),
	   BRANCH_NAME VARCHAR(255),
	   BRANCH_STREET VARCHAR(255),
	   BRANCH_CITY VARCHAR(255),
	   BRANCH_STATE VARCHAR(255),
	   BRANCH_ZIP NUMERIC(7),
	   BRANCH_PHONE VARCHAR(15),
	   LOADING_DATE DATETIME,
	   SOURCE_DATA VARCHAR(MAX)
	);

	INSERT INTO [Landing].[U_CDW_SAPP_D_BRANCH] (BRANCH_CODE, BRANCH_NAME,BRANCH_STREET, BRANCH_CITY, BRANCH_STATE, BRANCH_ZIP, BRANCH_PHONE
	,LOADING_DATE, SOURCE_DATA)
	SELECT
	   BRANCH_CODE,
	   BRANCH_NAME,
	   BRANCH_STREET,
	   BRANCH_CITY,
	   BRANCH_STATE,
	   COALESCE(BRANCH_ZIP, 'default_value'),
	   CONCAT('(', SUBSTRING(BRANCH_PHONE, 1, 3), ')', SUBSTRING(BRANCH_PHONE, 4, 3), '-', SUBSTRING(BRANCH_PHONE, 7, 4)),
	   GETDATE() AS LOADING_DATE, 
	   'CDW_SAPP_BRANCH' AS SOURCE_DATA
	FROM dbo.CDW_SAPP_BRANCH;
END;
EXEC BRANCH_LANDING

---------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE [Landing].[U_CDW_SAPP_D_TIME]
SELECT * FROM [Landing].[U_CDW_SAPP_D_TIME]

--------------------------------------------------------TIME UPDATED TABLE------------------------------------------------------------
DROP PROCEDURE IF EXISTS TIME_LANDING
CREATE PROCEDURE TIME_LANDING
AS 
BEGIN
	DROP TABLE IF EXISTS [Landing].[U_CDW_SAPP_D_TIME]
	CREATE TABLE [Landing].[U_CDW_SAPP_D_TIME] (
	  TIMEID VARCHAR(MAX),
	  DAY NUMERIC(2),
	  MONTH NUMERIC(2),
	  QUARTER VARCHAR(8),
	  YEAR NUMERIC(4),
	   LOADING_DATE DATETIME,
	   SOURCE_DATA VARCHAR(MAX)
	);
	INSERT INTO [Landing].[U_CDW_SAPP_D_TIME] (TIMEID, DAY, MONTH, QUARTER, YEAR,LOADING_DATE, 
	   SOURCE_DATA)
	SELECT
	  TIME_KEY AS TIMEID,
	  CAST(SUBSTRING(TIME_KEY, 3, 2) AS NUMERIC(2)) AS DAY,
	  CAST(SUBSTRING(TIME_KEY, 1, 2) AS NUMERIC(2)) AS MONTH,
	  CEILING(CAST(SUBSTRING(TIME_KEY, 1, 2) AS NUMERIC(2)) / 3.0) AS QUARTER,
	  CAST(SUBSTRING(TIME_KEY, 5, 4) AS NUMERIC(4)) AS YEAR,
	  GETDATE() AS LOADING_DATE, 
	  'CDW_SAPP_D_CALENDAR' AS SOURCE_DATA
	FROM dbo.[CDW_SAPP_D_CALENDAR];
END;
exec TIME_LANDING
SELECT * FROM [Landing].[L_CDW_SAPP_D_CALENDAR]

exec sp_help '[Landing].[L_CDW_SAPP_D_CALENDAR]';
   
--------------------------------------------------------------SALES TABLE UPDATION-------------------------------------------------------------------------------

ALTER TABLE dbo.CDW_SAPP_F_SALES_BR_4382  ADD LOADING_DATE DATETIME;
ALTER TABLE dbo.CDW_SAPP_F_SALES_BR_4382  ADD SOURCE_DATA VARCHAR(MAX) ;

UPDATE dbo.CDW_SAPP_F_SALES_BR_4382  SET LOADING_DATE = GETDATE();
UPDATE dbo.CDW_SAPP_F_SALES_BR_4382  SET SOURCE_DATA = 'CDW_SAPP_F_SALES_BR_4382';

ALTER TABLE dbo.CDW_SAPP_F_SALES_BR_4383  ADD LOADING_DATE DATETIME;
ALTER TABLE dbo.CDW_SAPP_F_SALES_BR_4383  ADD SOURCE_DATA VARCHAR(MAX) ;

UPDATE dbo.CDW_SAPP_F_SALES_BR_4383  SET LOADING_DATE = GETDATE();
UPDATE dbo.CDW_SAPP_F_SALES_BR_4383  SET SOURCE_DATA = 'CDW_SAPP_F_SALES_BR_4383';


SELECT * INTO [Landing].[U_CDW_SAPP_F_SALES]
FROM (SELECT * FROM dbo.CDW_SAPP_F_SALES_BR_4382  UNION SELECT * FROM dbo.CDW_SAPP_F_SALES_BR_4383)
AS Combined;

SELECT * FROM [Landing].[U_CDW_SAPP_F_SALES]