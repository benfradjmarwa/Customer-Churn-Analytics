CREATE TABLE DimCustomer (

    CustomerID NVARCHAR(50) PRIMARY KEY,

    Gender NVARCHAR(20),

    SeniorCitizen INT,

    Partner NVARCHAR(10),

    Dependents NVARCHAR(10)

)
CREATE TABLE DimContract (

    ContractID INT IDENTITY(1,1) PRIMARY KEY,

    CustomerID NVARCHAR(50),

    Contract NVARCHAR(50),

    PaperlessBilling NVARCHAR(10),

    PaymentMethod NVARCHAR(100),

    CONSTRAINT FK_DimContract_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES DimCustomer(CustomerID)

)
CREATE TABLE DimService (

    ServiceID INT IDENTITY(1,1) PRIMARY KEY,

    CustomerID NVARCHAR(50),

    PhoneService NVARCHAR(10),

    MultipleLines NVARCHAR(30),

    InternetService NVARCHAR(30),

    OnlineSecurity NVARCHAR(30),

    OnlineBackup NVARCHAR(30),

    DeviceProtection NVARCHAR(30),

    TechSupport NVARCHAR(30),

    StreamingTV NVARCHAR(30),

    StreamingMovies NVARCHAR(30),

	CONSTRAINT FK_DimService_Customer
	FOREIGN KEY (CustomerID)
	REFERENCES DimCustomer(CustomerID)

)
CREATE TABLE FactSubscription (

    SubscriptionID INT IDENTITY(1,1) PRIMARY KEY,

    CustomerID NVARCHAR(50),

    Tenure INT,

    MonthlyCharges FLOAT,

    TotalCharges FLOAT,

    ChurnFlag INT,

	CONSTRAINT FK_FactSubscription_Customer
FOREIGN KEY (CustomerID)
REFERENCES DimCustomer(CustomerID)

)