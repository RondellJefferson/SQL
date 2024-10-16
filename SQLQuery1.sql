Create Table api_keys(
insertDate Date DEFAULT (getdate()),
apiKey NVARCHAR(64) NOT NULL,
apiName NVARCHAR(32)
)
DROP table market

Insert INTO api_keys (apiKey,apiName)
values ('f86c78d276mshdb6f81a5f21254bp165162jsne79e7ba66f28','RapidAPI.com')

Create Table market(
	house_id int IDENTITY(1,1),
	listed_date date,
	price int,
	county NVARCHAR(100),
	property_type NVARCHAR(100),
	home_address NVARCHAR(150),
	city NVARCHAR(100),
	state NVARCHAR(10),
	zipCode int,
	bathrooms NVARCHAR(10),
	bedrooms NVARCHAR(10),
	status NVARCHAR(100),
	days_on_market int,
	year_built int,
	lot_size int
)

exec housing_market @statename = 'IL'

select * from market
where property_type = 'Single Family'
and city = 'Grantsburg'

exec sp_configure 'show advanced options' 1
reconfigure
go

exec sp_configure 'Ole Automation Procedures', 1
reconfigure
go


