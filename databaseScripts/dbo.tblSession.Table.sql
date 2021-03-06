USE [GISLicenseTrack]
GO
/****** Object:  Table [dbo].[tblSession]    Script Date: 06/10/2015 11:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSession](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SoftwareID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[MachineID] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[LastTime] [datetime] NOT NULL,
	[SoftwareVersion] [nvarchar](10) NULL,
	[LicenceManagerID] [int] NULL,
 CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblSession]  WITH CHECK ADD  CONSTRAINT [FK_Session_Machine] FOREIGN KEY([MachineID])
REFERENCES [dbo].[tblMachine] ([ID])
GO
ALTER TABLE [dbo].[tblSession] CHECK CONSTRAINT [FK_Session_Machine]
GO
ALTER TABLE [dbo].[tblSession]  WITH CHECK ADD  CONSTRAINT [FK_Session_Software] FOREIGN KEY([SoftwareID])
REFERENCES [dbo].[tblSoftware] ([ID])
GO
ALTER TABLE [dbo].[tblSession] CHECK CONSTRAINT [FK_Session_Software]
GO
ALTER TABLE [dbo].[tblSession]  WITH CHECK ADD  CONSTRAINT [FK_Session_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([ID])
GO
ALTER TABLE [dbo].[tblSession] CHECK CONSTRAINT [FK_Session_User]
GO
