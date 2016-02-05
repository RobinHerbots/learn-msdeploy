msdeploy.cmd ^
  -verb:sync ^
  -source:contentPath=%~dp0app ^
  -dest:package=app_this_pack.zip ^
  -declareParamFile=parameters.xml
  