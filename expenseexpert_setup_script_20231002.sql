USE [expenseexpert]
GO
/****** Object:  User [expe]    Script Date: 2023. 10. 02. 19:39:24 ******/
CREATE USER [expe] FOR LOGIN [expe] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [expe]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [expe]
GO
/****** Object:  Table [dbo].[financialrecords]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[financialrecords](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CREATED_DATE] [smalldatetime] NOT NULL,
	[ISEXPENSE] [bit] NULL,
	[AMOUNT] [numeric](18, 3) NULL,
	[TYPE] [int] NULL,
	[SUBTYPE] [int] NULL,
	[REALIZED_DATE] [smalldatetime] NULL,
	[COMMENT] [varchar](400) NULL,
 CONSTRAINT [PK_financialrecords] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[finsubtypes]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[finsubtypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CREATED_DATE] [smalldatetime] NULL,
	[TYPE_DESC] [varchar](200) NULL,
	[PARENT_ID] [int] NULL,
	[IS_DEL] [bit] NULL,
	[TARGET_VAL] [numeric](18, 3) NULL,
	[TARGET_PER] [numeric](7, 3) NULL,
 CONSTRAINT [PK_finsubtypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fintypes]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fintypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CREATED_DATE] [smalldatetime] NULL,
	[TYPE_DESC] [varchar](200) NULL,
	[IS_DEL] [bit] NULL,
	[TARGET_VAL] [numeric](18, 3) NULL,
	[TARGET_PER] [numeric](7, 3) NULL,
 CONSTRAINT [PK_fintypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[financialrecords]  WITH NOCHECK ADD  CONSTRAINT [FK_financialrecords_subtypes] FOREIGN KEY([SUBTYPE])
REFERENCES [dbo].[finsubtypes] ([ID])
GO
ALTER TABLE [dbo].[financialrecords] CHECK CONSTRAINT [FK_financialrecords_subtypes]
GO
ALTER TABLE [dbo].[financialrecords]  WITH NOCHECK ADD  CONSTRAINT [FK_financialrecords_types] FOREIGN KEY([TYPE])
REFERENCES [dbo].[fintypes] ([ID])
GO
ALTER TABLE [dbo].[financialrecords] CHECK CONSTRAINT [FK_financialrecords_types]
GO
ALTER TABLE [dbo].[finsubtypes]  WITH CHECK ADD  CONSTRAINT [FK_TYPE_PARENT_ID] FOREIGN KEY([PARENT_ID])
REFERENCES [dbo].[fintypes] ([ID])
GO
ALTER TABLE [dbo].[finsubtypes] CHECK CONSTRAINT [FK_TYPE_PARENT_ID]
GO
/****** Object:  StoredProcedure [dbo].[P_DELETE_CAT]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_DELETE_CAT] 
	-- Add the parameters for the stored procedure here
	@id int 
	,@rows int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE expenseexpert.dbo.fintypes
	SET IS_DEL = 1
	WHERE ID = @id

	UPDATE expenseexpert.dbo.finsubtypes
	SET IS_DEL = 1
	WHERE PARENT_ID = @id

	SELECT @rows=@@ROWCOUNT 
	RETURN @rows
END
GO
/****** Object:  StoredProcedure [dbo].[P_DELETE_FR]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_DELETE_FR] 
	-- Add the parameters for the stored procedure here
	@id int 
	,@rows int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM expenseexpert.dbo.financialrecords
	WHERE id = @id

	SELECT @rows=@@ROWCOUNT 
	RETURN @rows

END
GO
/****** Object:  StoredProcedure [dbo].[P_DELETE_SUBCAT]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_DELETE_SUBCAT] 
	-- Add the parameters for the stored procedure here
	@id int 
	,@rows int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE expenseexpert.dbo.finsubtypes
	SET IS_DEL = 1
	WHERE ID = @id
	SELECT @rows=@@ROWCOUNT 
	RETURN @rows
END
GO
/****** Object:  StoredProcedure [dbo].[P_INSERT_CAT]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anthorra>
-- Create date: <2023-07-27 22:49>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_INSERT_CAT] 
	-- Add the parameters for the stored procedure here
	
	@desc varchar(200)
	,@rows int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[fintypes]
		VALUES (CURRENT_TIMESTAMP, @desc, 0, null, null)
	--SELECT @rows=ID FROM [dbo].[fintypes] WHERE TYPE_DESC = @desc
	SELECT @rows=@@IDENTITY
	RETURN @rows
END
GO
/****** Object:  StoredProcedure [dbo].[P_INSERT_FR]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anthorra>
-- Create date: <2023-07-21>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_INSERT_FR] 
	-- Add the parameters for the stored procedure here
	@IsExpense bit, 
	@Amount numeric(18,3),
	@Type int,
	@SubType int,
	@RDate date,
	@Comment varchar(400),
	@rows int = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[financialrecords]
		VALUES (CURRENT_TIMESTAMP, @IsExpense, @Amount, @Type, @SubType, @RDate, @Comment)
	SELECT @rows=@@IDENTITY
	RETURN @rows

END
GO
/****** Object:  StoredProcedure [dbo].[P_INSERT_SUBCAT]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_INSERT_SUBCAT] 
	-- Add the parameters for the stored procedure here
	@desc varchar(200)
	,@parent int
	,@rows int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[finsubtypes]
		VALUES (CURRENT_TIMESTAMP, @desc, @parent, 0, null, null)
	--SELECT @rows=ID FROM [dbo].[fintypes] WHERE TYPE_DESC = @desc
	SELECT @rows=@@IDENTITY
	RETURN @rows
END
GO
/****** Object:  StoredProcedure [dbo].[P_UPDATE_CAT]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_UPDATE_CAT] 
	-- Add the parameters for the stored procedure here
	@id int 
	,@rename varchar(200)
	,@rows int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE expenseexpert.dbo.fintypes
	SET TYPE_DESC = @rename
	WHERE ID = @id
	SELECT @rows=@@ROWCOUNT 
	RETURN @rows
END
GO
/****** Object:  StoredProcedure [dbo].[P_UPDATE_FR]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_UPDATE_FR] 
	-- Add the parameters for the stored procedure here
	@id int,
	@IsExpense bit, 
	@Amount numeric(18,3),
	@Type int,
	@SubType int,
	@RDate date,
	@Comment varchar(400),
	@rows int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE expenseexpert.[dbo].[financialrecords]
		SET ISEXPENSE = @IsExpense,
			AMOUNT = @Amount,
			[TYPE] = @Type,
			[SUBTYPE] = @SubType,
			REALIZED_DATE = @RDate,
			COMMENT = @Comment
		
		WHERE ID = @id
		
	SELECT @rows=@@ROWCOUNT
	RETURN @rows
END
GO
/****** Object:  StoredProcedure [dbo].[P_UPDATE_SUBCAT]    Script Date: 2023. 10. 02. 19:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_UPDATE_SUBCAT] 
	-- Add the parameters for the stored procedure here
	@id int 
	,@rename varchar(200)
	,@rows int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE expenseexpert.dbo.finsubtypes
	SET TYPE_DESC = @rename
	WHERE ID = @id
	SELECT @rows=@@ROWCOUNT 
	RETURN @rows
END
GO
