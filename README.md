#ArcGISLicenseMonitor
====================

Aids in monitoring licenses managed by ESRI's ArcGIS License Manager. 
Python script checks license usage using a local ArcGIS License Manager and connects to external License managers by IP address. 
Data are stored in SQLServer database and can be retrieved with an Excel spreadsheet

##Database Setup

Run the createInstance.sql to build the database instance to hold the tables, views and stored procedures.

Run the table creation scripts.

1. dbo.tblLicenseManager.Table.sql
2. dbo.tblMachine.Table.sql
3. dbo.tblSoftware.Table.sql
4. dbo.tblUser.Table.sql
5. dbo.tblSession.Table.sql (Run Last)

Run the stored procedure creation scripts.

1. dbo.spRetrieveMachineId.StoredProcedure.sql
2. dbo.spRetrieveSoftwareId.StoredProcedure.sql
3. dbo.spRetrieveUserId.StoredProcedure.sql
4. dbo.spSessionUpdateWithVersion.StoredProcedure.sql (Run Last)

Run the view creation scripts.

1. dbo.vwUserFirstLastConnection.View.sql
2. dbo.vwUserSession.View.sql

Create a limited user (or use an existing user) on the database for loading and accessing the data.
Give the user account that will be loading the data execute rights on the `spSessionUpdateWithVersion`
stored procedure.

Give the user account that will be access the data select rights on the views.

1. vwUserFirstLastConnection
2. vwUserSession

##Monitoring Machine Setup

###Requirements

* Local installation of ArcGIS License Manager
* Python
* Python ODBC Library ([PYODBC](http://code.google.com/p/pyodbc/))

###Monitoring Command

The command for the monitoring task is `LicenseMonitor' followed by the IP addresses of 
the ArcGIS License managers.

```
C:\>LicenseMonitor 192.168.1.5 192.168.1.27
```

Where the organization has two license managers, one at 192.168.1.5 and one at 192.168.1.27. User information 
for the license managers will be parsed and stored in the database.

LicenseMonitor can be added to the task scheduler and run throughout the day. Sessions are only added or 
updated when LicenseMonitor is run. So if the task is run every 10 minutes shorter sessions may not show up.
I have not noticed any slowdown on a machine running the process every 5 minutes. The process could easily be
run on the license manager itself.

##Reporting

###Requirements

* Microsoft Excel (2010)

The ArcGISLicenseTracking.xlsx spreadsheet is used to pull the data from the database and put it in a format that 
is easy to use.

###Setup

You will need to set up data connections to the database to allow the spreadsheet to access the stored session
information.

The database Server connection information needs to be added to the connection information in the Data/Connections
dialog. Not entirely sure how well this works on a local database at this writing.
