# Install-Module -Name SqlServer
###############################################################################
# DMT import script 
# 02/07/2019
# SHALL
# Purpose:  Used to run all imports of data into a particular Epicor environment from scratch.  
#           This will extract data from Prostix based on SQL scripts created.
#           Requires the use of a csv file siththe following columns
#           OutFile,SQL,DMTTemplate,Enabled,Type,Options
#Eg. 03_Customers_DMT_SP,EXEC [03_Customers_DMT_SP] 'Pilot',Customer,N,G,-NoUi -Add -Update
# Enabled Values Y,N
# Type Values G (Generate Data Only) X (Generate and Import)
# Options Use string values based on DMT options Eg.-NoUi -Add -Update
#
#
#
#
#
#
# Notes for DMT Templates that have a space in the name you need to escape with a grave accent or backtick  E.g `"Customer AltBillTo`"
# -NoUI stops the UI running

# Resources 
# https://www.epiusers.help/t/dmt-powershell-help/42438/6
# https://devblogs.microsoft.com/scripting/weekend-scripter-understanding-quotation-marks-in-powershell/
#
# Updated: 16/07/2019: SH changed to cater for generation only 
# Updated: 16/07/2019: SH changed to cater for passing in options manually
# Updated: 20/08/2019: SH changed to cater for changed to DMT version where user and password now work correctly 4.0.46


#SQL Server info
$SQLServer = "ttasesql02\test"
$DBName = "DMTOut"

#Location of the DMT 
$DMTPath = "C:\Epicor\ERP10.2Client\102400-Demo\Client\DMT.exe"

#Working Directory
$runpath = "C:\Temp\DMTTesting\DMTSystemCopy\"

$imports = Import-Csv -Path C:\Temp\DMTTesting\DMTSystemCopy\DMTSystemCopyTest.csv

$User = "Epicor"
$Pass = "epicor"

ForEach ($item in $imports) {
    if ($item.Enabled -ne "N" ) { 
        
        
        # $Source = "C:\Temp\04_CustAltBillTo_DMT_VW_$(Get-Date -Format 'ddMMyyyy').csv"
        $Source = $runpath + $item.OutFile + "_$(Get-Date -Format 'ddMMyyyy').csv"
        $completeLog = $Source + ".CompleteLog.txt"
        $strsql = $item.SQL
        $dmttemplate = "`"$($item.DMTTemplate)`""
        $Options = $item.Options

        #`"Customer AltBillTo`"

        
        Write-Output "Extracting Data"
        Invoke-Sqlcmd -ServerInstance $SQLServer -Database $DBName -Query $strsql | Export-Csv -NoType $Source
        # Write-Output "Extracted : " Import-Csv $Source | Measure-Object | % {$_.Count}
        
        

        # LoadData
        if ($item.Type -eq "X" ) { 
            Write-Output "Loading Data " $Source     
            Start-Process -Wait -FilePath $DMTPath -ArgumentList "-User $User -Pass $Pass $Options -Import $dmttemplate  -Source $Source"
            #}
            #elseif ($item.Type -eq "Ui" ) {
            #    Start-Process -Wait -FilePath $DMTPath -ArgumentList "-User $User -Pass $Pass -Add -Update -Import $dmttemplate  -Source $Source"    
            #}
            
            #Check Results
            select-string -Path $completeLog -Pattern "Records:\D*(\d+\/\d+)" -AllMatches | ForEach-Object { $_.Matches.Groups[0].Value }
            select-string -Path $completeLog -Pattern "Errors:\D*(\d+)" -AllMatches | ForEach-Object { $_.Matches.Groups[0].Value }
        }
    }
}

#}

