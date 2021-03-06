USE [GISLicenseTrack]
GO
/****** Object:  StoredProcedure [dbo].[spRetrieveMachineId]    Script Date: 06/10/2015 11:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jeff Mitzelfelt
-- Create date: June 22, 2011
-- Description:	Retrieval and Addtion of User Machines
-- =============================================
CREATE PROCEDURE [dbo].[spRetrieveMachineId]
	-- Parameters
	@MachineName nvarchar(50),
	@MachineId int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @MachineId = ID
	FROM tblMachine
	WHERE MachineName = @MachineName

	IF @@rowcount = 0
	BEGIN
		INSERT tblMachine (
			MachineName
			)
		VALUES (
			@MachineName
			)
		SELECT @MachineId = @@IDENTITY
	END
END
GO
