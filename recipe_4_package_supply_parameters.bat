set this_cnn1=Data Source=(LocalDb)\MSSQLLocalDb;Initial Catalog={Params_Catalog};Integrated Security=SSPI;

msdeploy.cmd ^
   -verb:sync ^
   -source:package=param.zip ^
   -dest:iisApp=Default/app_params ^
   -setParam:name="Site Path Name",value=Default/app_params ^
   -setParam:name="Application setting 1",value="app1 value (params)" ^
   -setParam:name="Application setting 2",value="app2 value (params)" ^
   -setParam:name="Connection string 1",value="%this_cnn1%"