set this_cnn1=Data Source=(LocalDb)\MSSQLLocalDb;Initial Catalog={Default_Catalog};Integrated Security=SSPI;

msdeploy.cmd ^
   -verb:sync ^
   -source:iisApp=Default/app ^
   -dest:package=param.zip ^
   -declareParam:name="Site Path Name",description="Full site path",defaultValue=Default/app,tags=IisApp,kind=ProviderPath,scope=iisApp,match=Default/app ^
   -declareParam:name="Application setting 1",kind=XmlFile,scope=web.config,match=//appSettings/add[@key='app1']/@value,defaultValue="app1 value (default)",description="Enter a setting for app1" ^
   -declareParam:name="Application setting 2",kind=XmlFile,scope=web.config,match=//appSettings/add[@key='app2']/@value,defaultValue="app2 value (default)",description="Enter a setting for app2" ^
   -declareParam:name="Connection string 1",kind=XmlFile,scope=web.config,match=//connectionStrings/add[@name='cnn1']/@connectionString,defaultValue="%this_cnn1%",description="Enter the connection string for cnn1"