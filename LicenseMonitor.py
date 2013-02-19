# ---------------------------------------------------------------------------
# LicenseMonitor.py
# Created on: Thu Jun 27 2011
# Author: Jeff Mitzelfelt
# Purpose: Monitor ArcGIS Licenses using the lmutil lmstat -a command and load
#   information into a SQL Server Database
# Modified on: Feb 13, 2013
#   Modified the code to allow for system to interrogate multiple license
#   managers by IP address. Command can be run on a machine with the license
#   manager installed but not hosting any licenses.
# Command Line: LicenseMonitor.py 10.10.10.99 10.10.20.100 ...
# ---------------------------------------------------------------------------

# Import system modules
import os, re, datetime, pyodbc, sys, getopt

# Regular Expressions
regLicenseType = re.compile(r"(Users of)(.+):")
regUserRecord = re.compile(r"^\s+(\S+) (\S+) x.+\(v(\d{1,2}[\.\d+]*)\) .+, start \w+ (\d+)/(\d+) (\d+):(\d+)")
regQuoteCheck = re.compile(r"'")

# Copied from http://answers.oreilly.com/topic/318-how-to-match-ipv4-addresses-with-regular-expressions/
regIpAddress = re.compile(r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$")

# Local Variables

currTime = datetime.datetime.now().replace(microsecond=0)
LicenseManagerDirectory = 'C:/Program Files (x86)/ArcGIS/License10.1/bin/'

def getLmutilOutput(lmutilDirectory, licenseManagerAddress):
    currentDirectory = os.getcwd()
    command = 'lmutil lmstat -a'
    commandTail = ' -c @' + licenseManagerAddress
    # Change to lmutilDirectory
    os.chdir(lmutilDirectory)
    # Execute lmutil command
    commandOut = os.popen(command + commandTail,'r').readlines()
    # Change to currentDirectory
    os.chdir(currentDirectory)
    return commandOut

def parseLmutilData(inString):
    #Parse lmutil output
    outputArray = []
    for line in inString:
        line = regQuoteCheck.sub("''",line)
        # Get Line that shows License Type
        testText = regLicenseType.match(line)
        if testText:
            productName = testText.group(2).strip()

        # Get Line that contains User Information
        testText = regUserRecord.search(line)
        if testText:


            # Extract User Information into variables
            userCredential = testText.group(1)
            machineName =  testText.group(2)
            softwareVersion = testText.group(3)
            startTime = datetime.datetime( \
                currTime.year - (1 if (currTime.month > int(testText.group(4))) else 0) , \
                int(testText.group(4)), \
                int(testText.group(5)), \
                int(testText.group(6)), \
                int(testText.group(7)))
            sessionInfo = [productName, userCredential, machineName, softwareVersion, startTime]
            outputArray += [sessionInfo]
    return outputArray

def storeLmutilData(inArray):
    # Database Connection Setup
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=ServerNameOrIP;DATABASE=DatabaseName;UID=UserId;PWD=Password')
    cursor = cnxn.cursor()

                         
    for record in inArray:
        # Stored Procedure SQL Command Setup and Execution
        storedProcedure = 'EXEC spSessionUpdateWithVersion ' + \
            '@ProductName = \'' + record[0] + '\', ' + \
            '@ScriptTime = \'' + str(currTime) + '\', ' + \
            '@UserCredential = \'' + record[1] + '\', ' + \
            '@MachineName = \'' + record[2] + '\', ' + \
            '@StartTime	= \'' + str(record[4]) + '\', ' + \
            '@SoftwareVersion = \'' + record[3] + '\''
        cursor.execute(storedProcedure)

    # Commit record changes and close database connection
    cnxn.commit()
    cursor.close()
    cnxn.close()

# Load Options and Arguments from command line
opts, args = getopt.getopt(sys.argv[1:],0)

for element in args:

    # test that command line argument is a valid IP address
    testIp = regIpAddress.search(element)

    # IP address is valid
    if testIp:
        output = getLmutilOutput(LicenseManagerDirectory, element)
        userArray = parseLmutilData(output)
        # Test that licenses are used
        if len(userArray)>0:
            # Store license use data
            storeLmutilData(userArray)

    # IP address is invalid
    else:
        print element + ' is an invalid IP address'
