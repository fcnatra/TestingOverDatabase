
-- Schema could be created once
--		and later just create new/alter stored procedures on that schema
--		when needed
-- That way, running tests would not bring associated
--		the creation of the schema and all tables
--		would be just running the tests with EXEC tSQLt.Run

EXEC tSQLt.NewTestClass 'fakeSchemaCustomerTest';
GO

CREATE PROCEDURE fakeSchemaCustomerTest.[test Assert test 1 is equal to 1]
AS
BEGIN
	EXEC tSQLt.AssertEquals 1,1;
END;
GO

CREATE PROCEDURE fakeSchemaCustomerTest.[test A customer can created with Sales.upsNewCustomer]
AS
BEGIN
	--- AAA (Arrange, Act, Assert)

	-- ARRANGE
	DECLARE @id INT;
	DECLARE @expectedId INT; SET @expectedId = 1;

	-- Fake table
	EXEC tSQLt.FakeTable @TableName='Sales.Customer';
	
	INSERT INTO Sales.Customer
		(CustomerID, CustomerName, YTDOrders, YTDSales)
		VALUES
		(@expectedId,'Test Name', 0, 0);

	-- ACT
	SELECT @id = CustomerId FROM Sales.Customer

	-- ASSERT
	EXEC tSQLt.AssertEquals @expectedId, @id;
END;
GO

EXEC tSQLt.Run 'fakeSchemaCustomerTest';
GO

--EXEC tSQLt.Run 'fakeSchemaCustomerTest.[test Assert test 1 is equal to 1]';
--GO

EXEC tSQLt.DropClass 'fakeSchemaCustomerTest'