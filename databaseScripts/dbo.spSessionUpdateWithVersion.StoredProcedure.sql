USE [GISLicenseTrack]
GO
/****** Object:  StoredProcedure [dbo].[spSessionUpdateWithVersion]    Script Date: 06/10/2015 11:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jeff Mitzelfelt
-- Create date: Feb 11, 2013
-- Description:	Session Storage and Update with Software Version
-- =============================================
CREATE PROCEDURE [dbo].[spSessionUpdateWithVersion] 
	-- Parameters
	@ProductName	nvarchar(50),
	@ScriptTime		nvarchar(50),
	@UserCredential nvarchar(50),
	@MachineName	nvarchar(50),
	@StartTime		nvarchar(50),
	@SoftwareVersion nchar(10)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @UserId int,
		@MachineId int,
		@SoftwareId int,
		@StartTimeValue datetime,
		@ScriptTimeValue datetime

	-- Calculate Update Values
	SELECT @ScriptTimeValue = CONVERT(datetime, @ScriptTime, 120)
	EXEC spRetrieveUserId @UserCredential, @UserId OUTPUT
	EXEC spRetrieveMachineId @MachineName, @MachineId OUTPUT
	EXEC spRetrieveSoftwareId @ProductName, @SoftwareId OUTPUT
	SELECT @StartTimeValue = CONVERT(datetime, @StartTime, 120)
	
    -- UPDATE Session Record
	UPDATE tblSession 
		SET LastTime = @ScriptTimeValue
		WHERE UserID = @UserId and
			SoftwareID = @SoftwareID and
			StartTime = @StartTimeValue and
			SoftwareVersion = @SoftwareVersion

	IF @@ROWCOUNT = 0
	-- INSERT Session Record
	BEGIN

		INSERT 
			INTO tblSession (
				SoftwareID,
				UserID,
				MachineID,
				StartTime,
				LastTime,
				SoftwareVersion
			)
			VALUES (
				@SoftwareId,
				@UserId,
				@MachineId,
				@StartTimeValue,
				@ScriptTimeValue,
				@SoftwareVersion
			)
		
	END
END
GO
