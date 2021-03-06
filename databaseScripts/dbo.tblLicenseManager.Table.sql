USE [GISLicenseTrack]
GO
/****** Object:  Table [dbo].[tblLicenseManager]    Script Date: 06/10/2015 11:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLicenseManager](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IpAddress] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblLicenseManager] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
