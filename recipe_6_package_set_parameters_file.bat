msdeploy.cmd ^
   -verb:sync ^
   -source:package=param_from_file.zip ^
   -dest:iisApp=Default/app_set ^
   -setParamFile=parameter_values_set.xml