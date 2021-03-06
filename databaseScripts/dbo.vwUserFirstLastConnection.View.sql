USE [GISLicenseTrack]
GO
/****** Object:  View [dbo].[vwUserFirstLastConnection]    Script Date: 06/10/2015 11:48:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwUserFirstLastConnection] as
select 
	tblUser.UserCredential as UserCredential, 
	min(tblSession.StartTime) as FirstConnect, 
	max(tblSession.LastTime) as LastConnect
from 
	tblUser, 
	tblSession 
where 
	tblUser.ID = tblSession.UserID
group by 
	UserCredential;
GO
