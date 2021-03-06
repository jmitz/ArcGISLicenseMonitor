USE [GISLicenseTrack]
GO
/****** Object:  StoredProcedure [dbo].[spRetrieveSoftwareId]    Script Date: 06/10/2015 11:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jeff Mitzelfelt
-- Create date: June 22, 2011
-- Description:	Retrieval and Addtion of Software Products
-- =============================================
CREATE PROCEDURE [dbo].[spRetrieveSoftwareId]
	-- Parameters
	@ProductName nvarchar(50),
	@SoftwareId int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @SoftwareId = ID
	FROM tblSoftware
	WHERE ProductName = @ProductName

	IF @@rowcount = 0
	BEGIN
		INSERT tblSoftware (
			ProductName
			)
		VALUES (
			@ProductName
			)
		SELECT @SoftwareID = @@IDENTITY
	END
END
GO
