ECHO ON

rmdir /S /Q c:\inetpub\wwwroot\temp_app 
mkdir c:\inetpub\wwwroot\temp_app

CALL ^
 msdeploy.cmd ^
  -verb:sync ^
  -source:contentPath=%~dp0app ^
  -dest:contentPath=c:\inetpub\wwwroot\temp_app
  
REM Alternate 1

REM CALL ^
REM  msdeploy.cmd ^
REM   -verb:sync ^
REM   -source:iisApp=Default\temp_app ^
REM   -dest:package=app_copy.zip
  
REM Alternate 2
CALL ^
 msdeploy.cmd ^
  -verb:sync ^
  -source:iisApp=c:\inetpub\wwwroot\temp_app ^
  -dest:package=app_copy.zip

rmdir /S /Q c:\inetpub\wwwroot\temp_app

REM Just for the sake of it, deploy using the package

CALL ^
 msdeploy.cmd ^
  -verb:sync ^
  -source:package=app_copy.zip ^
  -dest:iisApp=Default\app_copy,skipAppCreation=false