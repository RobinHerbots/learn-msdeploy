msdeploy.cmd ^
   -verb:sync ^
   -source:iisApp=Default/app ^
   -dest:package=param_from_file.zip ^
   -declareParamFile=parameters.xml