USE [GISLicenseTrack]
GO
/****** Object:  StoredProcedure [dbo].[spRetrieveUserId]    Script Date: 06/10/2015 11:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jeff Mitzelfelt
-- Create date: June 22, 2011
-- Description:	Retrieval and Addtion of License Users
-- =============================================
CREATE PROCEDURE [dbo].[spRetrieveUserId]
	-- Parameters
	@UserCredential nvarchar(50),
	@UserId int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @UserId = ID
	FROM tblUser
	WHERE UserCredential = @UserCredential

	IF @@rowcount = 0
	BEGIN
		INSERT tblUser (
			UserCredential
			)
		VALUES (
			@UserCredential
			)
		SELECT @UserId = @@IDENTITY
	END
END
GO
