USE [testdb]
GO
/****** Object:  StoredProcedure [dbo].[parse_api]    Script Date: 10/16/2024 1:19:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[parse_api] @json NVARCHAR(max)
AS
    Set NOCOUNT ON;

	IF EXISTS (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Market')
	BEGIN
		truncate table market
	END

	insert into market(listed_date,price,county,property_type,home_address,city,state,zipCode,bathrooms,bedrooms,status,days_on_market,year_built,lot_size)
select 
	Cast(JSON_Value(value, '$.listedDate') as Date) as listed_date,
	JSON_Value(value, '$.price') as price,
	JSON_Value(value, '$.county') as county,
	JSON_Value(value, '$.propertyType') as property_type,
	JSON_Value(value, '$.addressLine1') as home_address,
	JSON_Value(value, '$.city') as city,
	JSON_Value(value, '$.state') as state,
	JSON_Value(value, '$.zipCode') as zipCode,
	JSON_Value(value, '$.bathrooms') as bathrooms,
	JSON_Value(value, '$.bedrooms') as bedrooms,
	JSON_Value(value, '$.status') as status,
	JSON_Value(value, '$.daysOnMarket') as days_on_market,
	JSON_Value(value, '$.yearBuilt') as year_built,
	JSON_Value(value, '$.lotSize') as lot_size
from
	openjson((select @json))