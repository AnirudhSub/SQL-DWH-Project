--exec sp_help '[Landing].[L_CDW_SAPP_CUSTOMER]';

---------------------------------------------------------------------------------------------------------------------------------------------

/*DROP TABLE  [Landing].[U_CDW_SAPP_D_CUSTOMER]
SELECT * FROM [Landing].[U_CDW_SAPP_D_CUSTOMER]*/

--------------------------------------------------------UPDATING CUSTOMER TABLE-------------------------------------------------------
	IF OBJECT_ID(N'[Landing].[U_CDW_SAPP_D_CUSTOMER]' , N'U') IS NULL
	BEGIN
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
	END

	MERGE INTO [Landing].[U_CDW_SAPP_D_CUSTOMER] AS Target
USING (
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
       [CUST_EMAIL],
       GETDATE() AS LOADING_DATE,
       'CDW_SAPP_CUSTOMER' AS SOURCE_DATA
   FROM [dbo].[CDW_SAPP_CUSTOMER]
) AS Source
ON Target.CUST_ID = Source.CUST_ID
WHEN MATCHED THEN
   UPDATE SET
       CUST_F_NAME = Source.CUST_F_NAME,
       CUST_M_NAME = Source.CUST_M_NAME,
       CUST_L_NAME = Source.CUST_L_NAME,
       CUST_SSN = Source.CUST_SSN,
       CUST_STREET = Source.CUST_STREET,
       CUST_CITY = Source.CUST_CITY,
       CUST_STATE = Source.CUST_STATE,
       CUST_COUNTRY = Source.CUST_COUNTRY,
       CUST_ZIP = Source.CUST_ZIP,
       CUST_PHONE = Source.CUST_PHONE,
       CUST_EMAIL = Source.CUST_EMAIL,
       LOADING_DATE = Source.LOADING_DATE,
       SOURCE_DATA = Source.SOURCE_DATA
WHEN NOT MATCHED THEN
   INSERT (
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
   VALUES (
       Source.CUST_ID,
       Source.CUST_F_NAME,
       Source.CUST_M_NAME,
       Source.CUST_L_NAME,
       Source.CUST_SSN,
       Source.CUST_STREET,
       Source.CUST_CITY,
       Source.CUST_STATE,
       Source.CUST_COUNTRY,
       Source.CUST_ZIP,
       Source.CUST_PHONE,
       Source.CUST_EMAIL,
       Source.LOADING_DATE,
       Source.SOURCE_DATA
   );


------------------------------------------------------------------------------------------------------------------------
/*SELECT * FROM [Landing].[U_CDW_SAPP_D_SUPPLIER];
DROP TABLE [Landing].[U_CDW_SAPP_D_SUPPLIER]*/
--------------------------------------------------------SUPPLIER UPDATED TABLE--------------------------------------------------------
	IF OBJECT_ID(N'[Landing].[U_CDW_SAPP_D_SUPPLIER]' , N'U') IS NULL
	BEGIN
	CREATE TABLE [Landing].[U_CDW_SAPP_D_SUPPLIER] (
	   SUPPLIER_ID NUMERIC(10) PRIMARY KEY,
	   SUPPLIER_NAME VARCHAR(255),
	   SUPPLIER_SSN NUMERIC(9),
	   SUPPLIER_PHONE VARCHAR(15),
	   SUPPLIER_LOC VARCHAR(255),
	   LOADING_DATE DATETIME,
	   SOURCE_DATA VARCHAR(MAX)
	);
	END

	MERGE INTO [Landing].[U_CDW_SAPP_D_SUPPLIER] AS Target
USING (
   SELECT
       ROW_NUMBER() OVER (ORDER BY SUPPLIER_SSN) AS SUPPLIER_ID,
       REPLACE(SUPPLIER_NAME, '%', '') AS SUPPLIER_NAME,
       CAST(SUPPLIER_SSN AS BIGINT) AS SUPPLIER_SSN,
       SUBSTRING(SUPPLIER_PHONE, 1, 3) + '-' + SUBSTRING(SUPPLIER_PHONE, 4, 3) + '-' + SUBSTRING(SUPPLIER_PHONE, 7, 4) AS SUPPLIER_PHONE,
       SUPPLIER_LOC,
       GETDATE() AS LOADING_DATE,
       'CDW_SAPP_SUPPLIER' AS SOURCE_DATA
   FROM [dbo].[CDW_SAPP_SUPPLIER]
) AS Source
ON Target.SUPPLIER_ID = Source.SUPPLIER_ID
WHEN MATCHED THEN
   UPDATE SET
       SUPPLIER_NAME = Source.SUPPLIER_NAME,
       SUPPLIER_SSN = Source.SUPPLIER_SSN,
       SUPPLIER_PHONE = Source.SUPPLIER_PHONE,
       SUPPLIER_LOC = Source.SUPPLIER_LOC,
       LOADING_DATE = Source.LOADING_DATE,
       SOURCE_DATA = Source.SOURCE_DATA
WHEN NOT MATCHED THEN
   INSERT (
       SUPPLIER_ID,
       SUPPLIER_NAME,
       SUPPLIER_SSN,
       SUPPLIER_PHONE,
       SUPPLIER_LOC,
       LOADING_DATE,
       SOURCE_DATA
   )
   VALUES (
       Source.SUPPLIER_ID,
       Source.SUPPLIER_NAME,
       Source.SUPPLIER_SSN,
       Source.SUPPLIER_PHONE,
       Source.SUPPLIER_LOC,
       Source.LOADING_DATE,
       Source.SOURCE_DATA
   );


--------------------------------------------------------------------------------------------------------------------------------------
/*SELECT * FROM [Landing].[U_CDW_SAPP_D_PRODUCT]
DROP TABLE [Landing].[U_CDW_SAPP_D_PRODUCT]*/

-----------------------------------------------------PRODUCT UPDATED TABLE------------------------------------------------------------
	IF OBJECT_ID(N'[Landing].[U_CDW_SAPP_D_PRODUCT]' , N'U') IS NULL
	BEGIN
	CREATE TABLE [Landing].[U_CDW_SAPP_D_PRODUCT] (
	   PRODUCT_CODE NUMERIC(11) PRIMARY KEY,
	   PRODUCT_NAME VARCHAR(255),
	   SUPPLIER_ID NUMERIC(10) FOREIGN KEY REFERENCES [Landing].[U_CDW_SAPP_D_SUPPLIER](SUPPLIER_ID),
	   PRODUCT_PRICE VARCHAR(9),
	   LOADING_DATE DATETIME,
	   SOURCE_DATA VARCHAR(MAX)
	);
	END

	MERGE INTO [Landing].[U_CDW_SAPP_D_PRODUCT] AS Target
USING (
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
       ON P.SUPPLIER_SSN = S.SUPPLIER_SSN
) AS Source
ON Target.PRODUCT_CODE = Source.PRODUCT_CODE
WHEN MATCHED THEN
   UPDATE SET
       PRODUCT_NAME = Source.PRODUCT_NAME,
       SUPPLIER_ID = Source.SUPPLIER_ID,
       PRODUCT_PRICE = Source.PRODUCT_PRICE,
       LOADING_DATE = Source.LOADING_DATE,
       SOURCE_DATA = Source.SOURCE_DATA
WHEN NOT MATCHED THEN
   INSERT (
       PRODUCT_CODE,
       PRODUCT_NAME,
       SUPPLIER_ID,
       PRODUCT_PRICE,
       LOADING_DATE,
       SOURCE_DATA
   )
   VALUES (
       Source.PRODUCT_CODE,
       Source.PRODUCT_NAME,
       Source.SUPPLIER_ID,
       Source.PRODUCT_PRICE,
       Source.LOADING_DATE,
       Source.SOURCE_DATA
   );


----------------------------------------------------------------------------------------------------------------------------------------------------
/*DROP TABLE [Landing].[U_CDW_SAPP_D_BRANCH]
SELECT * FROM [Landing].[U_CDW_SAPP_D_BRANCH]*/

----------------------------------------------------------BRANCH UPDATED TABLE------------------------------------------------------------
	IF OBJECT_ID(N'[Landing].[U_CDW_SAPP_D_BRANCH]' , N'U') IS NULL
	BEGIN
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
	END
	MERGE INTO [Landing].[U_CDW_SAPP_D_BRANCH] AS Target
USING (
   SELECT
       BRANCH_CODE,
       BRANCH_NAME,
       BRANCH_STREET,
       BRANCH_CITY,
       BRANCH_STATE,
       COALESCE(BRANCH_ZIP, 'default_value') AS BRANCH_ZIP,
       CONCAT('(', SUBSTRING(BRANCH_PHONE, 1, 3), ')', SUBSTRING(BRANCH_PHONE, 4, 3), '-', SUBSTRING(BRANCH_PHONE, 7, 4)) AS BRANCH_PHONE,
       GETDATE() AS LOADING_DATE,
       'CDW_SAPP_BRANCH' AS SOURCE_DATA
   FROM dbo.CDW_SAPP_BRANCH
) AS Source
ON Target.BRANCH_CODE = Source.BRANCH_CODE
WHEN MATCHED THEN
   UPDATE SET
       BRANCH_NAME = Source.BRANCH_NAME,
       BRANCH_STREET = Source.BRANCH_STREET,
       BRANCH_CITY = Source.BRANCH_CITY,
       BRANCH_STATE = Source.BRANCH_STATE,
       BRANCH_ZIP = Source.BRANCH_ZIP,
       BRANCH_PHONE = Source.BRANCH_PHONE,
       LOADING_DATE = Source.LOADING_DATE,
       SOURCE_DATA = Source.SOURCE_DATA
WHEN NOT MATCHED THEN
   INSERT (
       BRANCH_CODE,
       BRANCH_NAME,
       BRANCH_STREET,
       BRANCH_CITY,
       BRANCH_STATE,
       BRANCH_ZIP,
       BRANCH_PHONE,
       LOADING_DATE,
       SOURCE_DATA
   )
   VALUES (
       Source.BRANCH_CODE,
       Source.BRANCH_NAME,
       Source.BRANCH_STREET,
       Source.BRANCH_CITY,
       Source.BRANCH_STATE,
       Source.BRANCH_ZIP,
       Source.BRANCH_PHONE,
       Source.LOADING_DATE,
       Source.SOURCE_DATA
   );

---------------------------------------------------------------------------------------------------------------------------------------------
/*DROP TABLE [Landing].[U_CDW_SAPP_D_TIME]
SELECT * FROM [Landing].[U_CDW_SAPP_D_TIME]*/

--------------------------------------------------------TIME UPDATED TABLE------------------------------------------------------------
	IF OBJECT_ID(N'[Landing].[U_CDW_SAPP_D_BRANCH]' , N'U') IS NULL
	CREATE TABLE [Landing].[U_CDW_SAPP_D_TIME] (
	  TIMEID VARCHAR(MAX),
	  DAY NUMERIC(2),
	  MONTH NUMERIC(2),
	  QUARTER VARCHAR(8),
	  YEAR NUMERIC(4),
	   LOADING_DATE DATETIME,
	   SOURCE_DATA VARCHAR(MAX)
	);
	MERGE INTO [Landing].[U_CDW_SAPP_D_TIME] AS Target
USING (
   SELECT
       TIME_KEY AS TIMEID,
       CAST(SUBSTRING(TIME_KEY, 3, 2) AS NUMERIC(2)) AS DAY,
       CAST(SUBSTRING(TIME_KEY, 1, 2) AS NUMERIC(2)) AS MONTH,
       CEILING(CAST(SUBSTRING(TIME_KEY, 1, 2) AS NUMERIC(2)) / 3.0) AS QUARTER,
       CAST(SUBSTRING(TIME_KEY, 5, 4) AS NUMERIC(4)) AS YEAR,
       GETDATE() AS LOADING_DATE,
       'CDW_SAPP_D_CALENDAR' AS SOURCE_DATA
   FROM dbo.[CDW_SAPP_D_CALENDAR]
) AS Source
ON Target.TIMEID = Source.TIMEID
WHEN MATCHED THEN
   UPDATE SET
       DAY = Source.DAY,
       MONTH = Source.MONTH,
       QUARTER = Source.QUARTER,
       YEAR = Source.YEAR,
       LOADING_DATE = Source.LOADING_DATE,
       SOURCE_DATA = Source.SOURCE_DATA
WHEN NOT MATCHED THEN
   INSERT (
       TIMEID,
       DAY,
       MONTH,
       QUARTER,
       YEAR,
       LOADING_DATE,
       SOURCE_DATA
   )
   VALUES (
       Source.TIMEID,
       Source.DAY,
       Source.MONTH,
       Source.QUARTER,
       Source.YEAR,
       Source.LOADING_DATE,
       Source.SOURCE_DATA
   );
   
--------------------------------------------------------------SALES TABLE UPDATION-------------------------------------------------------------------------------

/*ALTER TABLE dbo.CDW_SAPP_F_SALES_BR_4382  ADD LOADING_DATE DATETIME;
ALTER TABLE dbo.CDW_SAPP_F_SALES_BR_4382  ADD SOURCE_DATA VARCHAR(MAX) ;*/

UPDATE dbo.CDW_SAPP_F_SALES_BR_4382  SET LOADING_DATE = GETDATE();
UPDATE dbo.CDW_SAPP_F_SALES_BR_4382  SET SOURCE_DATA = 'CDW_SAPP_F_SALES_BR_4382';

/*ALTER TABLE dbo.CDW_SAPP_F_SALES_BR_4383  ADD LOADING_DATE DATETIME;
ALTER TABLE dbo.CDW_SAPP_F_SALES_BR_4383  ADD SOURCE_DATA VARCHAR(MAX) ;*/

UPDATE dbo.CDW_SAPP_F_SALES_BR_4383  SET LOADING_DATE = GETDATE();
UPDATE dbo.CDW_SAPP_F_SALES_BR_4383  SET SOURCE_DATA = 'CDW_SAPP_F_SALES_BR_4383';


DROP TABLE IF EXISTS [Landing].[U_CDW_SAPP_F_SALES]
SELECT * INTO [Landing].[U_CDW_SAPP_F_SALES]
FROM (SELECT * FROM dbo.CDW_SAPP_F_SALES_BR_4382  UNION SELECT * FROM dbo.CDW_SAPP_F_SALES_BR_4383)
AS Combined;

/*SELECT * FROM [Landing].[U_CDW_SAPP_F_SALES]*/