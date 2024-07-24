# Powershell Script for Epicor ERP
First created for 10.2.600

Based on the Epicor DMT powershell script examples.

## Description
Used to run all imports of data into a particular Epicor environment from scratch.  

This will extract data from Prostix based on SQL scripts created.
Requires the use of a csv file with the following columns
      
      OutFile,SQL,DMTTemplate,Enabled,Type,Options
           
Eg. 03_Customers_DMT_SP,EXEC [03_Customers_DMT_SP] 'Pilot',Customer,N,G,-NoUi -Add -Update

 * OutFile = The name of the output file generated from the executed sql statement (default .csv extension)
 * SQL = SQL command used to generate the data
 * DMTTemplate = name of the DMT template to use for example Customer
 * Enabled = execute this statment or not. values Y,N
 * Type = What type of statement is this? Values G (Generate Data Only) X (Generate and Import)
 * Options = DMT Exceution Options. Use string values based on DMT options Eg.-NoUi -Add -Update

## Notes
As expected due to the specific nature of each environment the list of tables to populate will be unique, in particular if you are migrating from one system to another.

### Warranty
This is provided with no warranty.

### Resources
https://www.epiusers.help/t/dmt-powershell-help/42438/6
https://devblogs.microsoft.com/scripting/weekend-scripter-understanding-quotation-marks-in-powershell/
