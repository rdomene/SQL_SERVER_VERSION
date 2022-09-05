CREATE OR ALTER FUNCTION dbo.SQL_SERVER_VERSION()
RETURNS TABLE WITH SCHEMABINDING
AS
RETURN (
	--References:
	-- https://docs.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql
	-- https://docs.microsoft.com/en-us/sql/t-sql/functions/version-transact-sql-configuration-functions
	-- https://database.guide/improved-script-that-returns-all-properties-from-serverproperty-in-sql-server/
	-- https://www.brentozar.com/archive/2015/05/sql-server-version-detection/
	-- 
	WITH CTE AS (
	SELECT
		@@VERSION AS [Version],
		SERVERPROPERTY(N'ProductLevel') AS [ProductLevel],
		SERVERPROPERTY(N'ProductBuildType') AS [ProductBuildType],
		SERVERPROPERTY(N'ProductUpdateLevel') AS [ProductUpdateLevel],
		SERVERPROPERTY(N'ProductUpdateReference') AS [ProductUpdateReference],
		CONVERT(nvarchar(128), SERVERPROPERTY(N'ProductVersion')) AS [ProductVersion],
		SERVERPROPERTY(N'ProductMajorVersion') AS [ProductMajorVersion],
		SERVERPROPERTY(N'ProductMinorVersion') AS [ProductMinorVersion],
		SERVERPROPERTY(N'ProductBuild') AS [ProductBuild],
		SERVERPROPERTY(N'EditionID') AS [EditionID],
		SERVERPROPERTY(N'EngineEdition') AS [EngineEdition],
		SERVERPROPERTY(N'Edition') AS [Edition]
	)

	SELECT
		[Version],
		CONVERT(nvarchar(128), CASE [ProductMajorVersion]
			WHEN N'16' THEN N'Microsoft SQL Server 2022'
			WHEN N'15' THEN N'Microsoft SQL Server 2019'
			WHEN N'14' THEN N'Microsoft SQL Server 2017'
			WHEN N'13' THEN N'Microsoft SQL Server 2016'
			WHEN N'12' THEN N'Microsoft SQL Server 2014'
			WHEN N'11' THEN N'Microsoft SQL Server 2012'
			WHEN N'10' THEN
				IIF ([ProductMinorVersion] = N'50', N'Microsoft SQL Server 2008 R2', N'Microsoft SQL Server 2008')
			WHEN N'9' THEN N'Microsoft SQL Server 2005'
			WHEN N'8' THEN N'Microsoft SQL Server 2000'
			WHEN N'7' THEN N'Microsoft SQL Server 7.0'
			WHEN N'6' THEN
				IIF ([ProductMinorVersion] = N'50', N'Microsoft SQL Server 6.5', N'Microsoft SQL Server 6.0')
			ELSE N'Undetermined'
		END) AS [Product],
		[ProductLevel],
		[ProductBuildType],
		[ProductUpdateLevel],
		[ProductUpdateReference],
		[ProductVersion],
		[ProductMajorVersion],
		[ProductMinorVersion],
		[ProductBuild],
		PARSENAME([ProductVersion], 1) AS [Revision],
		CONVERT(nvarchar(128), CASE [EditionID]
			WHEN 1804890536 THEN N'Enterprise'
			WHEN 1872460670 THEN N'Enterprise Edition: Core-based Licensing'
			WHEN 610778273 THEN N'Enterprise Evaluation'
			WHEN 284895786 THEN N'Business Intelligence'
			WHEN -2117995310 THEN N'Developer'
			WHEN -1592396055 THEN N'Express'
			WHEN -133711905 THEN N'Express with Advanced Services'
			WHEN -1534726760 THEN N'Standard'
			WHEN 1674378470 THEN N'SQL Database or Azure Synapse Analytics'
			WHEN -1461570097 THEN N'Azure SQL Edge Developer'
			WHEN 1994083197 THEN N'Azure SQL Edge'
			ELSE N'Undetermined'
		END) AS [ProductEdition],
		CONVERT(nvarchar(128), CASE [EngineEdition]
			WHEN 1 THEN N'Personal or Desktop Engine'
			WHEN 2 THEN N'Standard'
			WHEN 3 THEN N'Enterprise'
			WHEN 4 THEN N'Express'
			WHEN 5 THEN N'SQL Database'
			WHEN 6 THEN N'Microsoft Azure Synapse Analytics'
			WHEN 8 THEN N'Azure SQL Managed Instance'
			WHEN 9 THEN N'Azure SQL Edge'
			WHEN 11 THEN N'Azure Synapse serverless SQL pool'
			ELSE N'Undetermined'
		END) AS [DatabaseEngine],
		[Edition]
	FROM CTE
);
GO
