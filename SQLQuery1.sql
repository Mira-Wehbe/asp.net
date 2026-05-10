DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Trips;
DROP TABLE IF EXISTS Drivers;
DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS Users;

CREATE TABLE [dbo].[Users]
(
    [UserID] INT IDENTITY(1,1) NOT NULL,
    [FullName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(100) NOT NULL,
    [PasswordHash] NVARCHAR(255) NOT NULL,
    [Role] NVARCHAR(10) NOT NULL,
    [CreatedAt] DATETIME DEFAULT (GETDATE()) NULL,

    CONSTRAINT [PK_Users]
        PRIMARY KEY CLUSTERED ([UserID] ASC),

    CONSTRAINT [UQ_Users_Email]
        UNIQUE NONCLUSTERED ([Email] ASC),

    CONSTRAINT [CHK_Users_Role]
        CHECK ([Role] IN ('Client', 'Admin'))
);

CREATE TABLE [dbo].[Cars] (
    [CarID]       INT             IDENTITY (1, 1) NOT NULL,
    [PlateNumber] NVARCHAR (20)   NOT NULL,
    [Model]       NVARCHAR (50)   NOT NULL,
    [IsActive]    BIT             DEFAULT ((1)) NULL,
    [RatePerKm]   DECIMAL (10, 2) DEFAULT ((2.50)) NOT NULL,
    [CarType]     NVARCHAR (50)   NULL,
    [Seats]       INT             NULL,
    PRIMARY KEY CLUSTERED ([CarID] ASC),
    UNIQUE NONCLUSTERED ([PlateNumber] ASC)
);



CREATE TABLE [dbo].[Drivers]
(
    [DriverID] INT IDENTITY(1,1) NOT NULL,
    [FullName] NVARCHAR(100) NOT NULL,
    [Phone] NVARCHAR(20) NULL,
    [CarID] INT NULL,
    [IsAvailable] BIT DEFAULT ((1)) NULL,
    [Gender] NVARCHAR(10) NULL,

    CONSTRAINT [PK_Drivers]
        PRIMARY KEY CLUSTERED ([DriverID] ASC),

    CONSTRAINT [FK_Drivers_Cars]
        FOREIGN KEY ([CarID])
        REFERENCES [dbo].[Cars]([CarID])
);

CREATE TABLE [dbo].[Trips] (
    [TripID]          INT             IDENTITY (1, 1) NOT NULL,
    [ClientID]        INT             NULL,
    [DriverID]        INT             NULL,
    [CarID]           INT             NULL,
    [PickupLocation]  NVARCHAR (255)  NOT NULL,
    [DropoffLocation] NVARCHAR (255)  NOT NULL,
    [PickupTime]      DATETIME        NOT NULL,
    [Status]          NVARCHAR (20)   DEFAULT ('Pending') NULL,
    [Price]           DECIMAL (10, 2) NULL,
    [CreatedAt]       DATETIME        DEFAULT (getdate()) NULL,
    [DistanceKm]      DECIMAL (10, 2) NULL,
    CONSTRAINT [PK_Trips] PRIMARY KEY CLUSTERED ([TripID] ASC),
    CONSTRAINT [FK_Trips_Users] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Trips_Drivers] FOREIGN KEY ([DriverID]) REFERENCES [dbo].[Drivers] ([DriverID]),
    CONSTRAINT [FK_Trips_Cars] FOREIGN KEY ([CarID]) REFERENCES [dbo].[Cars] ([CarID]),
    CONSTRAINT [CHK_Trips_Status] CHECK ([Status]='Cancelled' OR [Status]='Completed' OR [Status]='Active' OR [Status]='Pending')
);



CREATE TABLE [dbo].[Feedback]
(
    [FeedbackID] INT IDENTITY(1,1) NOT NULL,
    [TripID] INT NULL,
    [ClientID] INT NULL,
    [Rating] INT NULL,
    [Comment] NVARCHAR(500) NULL,
    [SubmittedAt] DATETIME DEFAULT (GETDATE()) NULL,

    CONSTRAINT [PK_Feedback]
        PRIMARY KEY CLUSTERED ([FeedbackID] ASC),

    CONSTRAINT [FK_Feedback_Trips]
        FOREIGN KEY ([TripID])
        REFERENCES [dbo].[Trips]([TripID]),

    CONSTRAINT [FK_Feedback_Users]
        FOREIGN KEY ([ClientID])
        REFERENCES [dbo].[Users]([UserID]),

    CONSTRAINT [CHK_Feedback_Rating]
        CHECK ([Rating] >= 1 AND [Rating] <= 5)
);

INSERT INTO Users (1, FullName, Email, PasswordHash, Role)
VALUES ('Admin', 'admin@taxi.com', 'admin123', 'Admin');