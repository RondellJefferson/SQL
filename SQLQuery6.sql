USE [testdb]
GO
/****** Object:  StoredProcedure [dbo].[housing_market]    Script Date: 10/16/2024 2:34:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[housing_market] @statename NVARCHAR(10)
AS
--Variable declaration related to the object
Declare @token INT;
Declare @returnV INT;

--Variable table declaration related to the JSON string
Declare @JSON AS TABLE (json_col NVARCHAR(MAX));

--Variable declaration related to the Request
Declare @URL NVARCHAR(MAX);
Declare @json2 NVARCHAR(MAX);
Declare @apiKey NVARCHAR(100);

--Set the API key from another table called apiKeys
SET @apiKey = (select apiKey from api_keys where apiName = 'RapidAPI.com');

-- Define the URL
SET @URL = (select concat('https://realty-mole-property-api.p.rapidapi.com/saleListings?state=',@statename,'&limit=100'));

--Create a new object
Exec @returnV = sp_OACreate 'MSXML2.XMLHTTP', @token OUT;
IF @returnV <> 0 RAISERROR('Unable to open new HTTP Connection.', 10, 1);

--Calling the new instance of the OLE object
EXEC @returnV = sp_OAMethod @token, 'open', NULL, 'GET', @URL, 'false';
EXEC @returnV = sp_OAMethod @token, 'setRequestHeader', NULL, 'x-rapidapi-key', @apiKey;
Exec @returnV = sp_OAMethod @token, 'send';

--Insert the JSON into the 
Insert Into @JSON(json_col) exec sp_OAGetProperty @token, 'responseText';

set @json2 = (select json_col from @json);

WITH single_family as (
	 select house_id from market
	 where property_type = 'Single Family')
select 
	city,
	county,
	state,
	ROUND(AVG(price),2) as avg_price,
	AVG(days_on_market) as avg_days_on_market
From 
	market
Where 
	house_id IN (select house_id from single_family)
Group BY city, county, state

GO