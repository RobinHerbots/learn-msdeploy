#Getting Started with MsDeploy

##Pre-requisites
+ Windows 10 Pro x64
+ IIS 10 installed and configured

Your IIS Admin should show a default Site named __Default__

![Site Default](/resources/iis_default_site.png)

+ Your preferred shell is elevated and configured
You **should** have msdeploy in your path. If you are using cmder then you can optionally define a local path for the session:  

    alias msdeploy=C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe
otherwise alter each of the scripts used in these instructions.

###References

+ [Web Deployment Tool](https://technet.microsoft.com/en-us/library/dd568996.aspx)

and buried within but required reading really:

+ [Key Concepts and Features](https://technet.microsoft.com/en-us/library/dd722763.aspx#BKMKSourcesAndDestinations)
+ [Using Parameters To Customize Synchronizations](https://technet.microsoft.com/en-us/library/ee338472.aspx)

##Caveat-Emptor

The msdeploy tool is finicky with respect to spaces between arguments.eg. 
```
-declareParam:name="cnn1",kind="XmlFile",scope=\\web.config$
```
not
```
-declareParam:name="cnn1", kind="XmlFile", scope=\\web.config$
```
Any values with spaces must be surrounded by double quotes as normal practice. eg.
```
description="setting for app1"
```
not
```
description=setting for app1
```
It is difficult to diagnose problems especially when importing the package into IIS. Be prepared to lose days off the end of your life.

Otherwise this is a great solution for parameterised installs that I wish I had learnt about earlier, and appears to be the glue that makes webmatrix deployments awesome :)

##Installing MsDeploy

One way to install is via direct link [Web Deploy 3.6](https://www.microsoft.com/en-us/download/details.aspx?id=43717)
but the way I chose was via the web platform installer. Once Web Platform Installer it is started, search for _web deploy_:

![Select Web Deploy 3.6 (or higher)](/resources/webpi-msdeploy-select.png)

This action installed two packages for me as below:
![Result of Install](/resources/webpi-msdeploy-installed.png)

+ Web Deploy 3.6
+ Web Deploy 3.6 without bundled SQL Support (latest)

There is another module that could have been installed which is _Web Deploy 3.6 for Hosting_ but I haven't used it.

##Checking that MsDeploy is now available in IIS Admin

Open up the IIS Admin interface and check:

![IIS Admin with MSDeploy](/resources/iis-deploy-available.png)

There will be two options at the bottom right-hand side for the Default Site:

+ Import Application
+ Export Application

If these options are not available then you can check the installer from the Control Panel.

Open the Control Panel and look for the MsDeploy item.

![Change the Install](/resources/controlpanel-msdeploy.png)

Choose the __Change__ option and you should eventually see this screen:

![Select All Components](/resources/msdeploy-3.6-change.png)

Ensure that all features are installed on the hard-drive. If this doesn't resolve the issue then you will have to resort to the IIS Forums or Google.

##Pre-Deploying a simple test application into IIS

The test application will initially need to be in place at c:/inetpub/wwwroot

![Empty wwwroot](/resources/iis_wwwroot.png)

Before we can use msdeploy copy the /app folder to c:/inetput/wwwroot (you may need elevated privileges or grant yourself modify permissions in that folder first).

![Copied to wwwroot](/resources/app_copy_to_wwwroot.png)
Open IIS Admin again and refresh the Site->Default node.

![Site Default](/resources/app_configured.png)

Browse to the web application /app as in the following image:
![Site Default](/resources/app_browse.png)

###Initial Conditions
The initial conditions are that we have a small web application (single page!) with a web configuration file
that is being read by the page. There are some settings that are being rendered to make it simpler to check that
any changes we make can be verified:
+ appSettings - app1 and app2
+ connectionStrings - cnn1

![Site Default](/resources/browser_default_page.png)

This app is then what we are concentrating our packaging and deployment activities on.

##Packaging Examples 

###Package the app as-is  
    
This step is the simplest. The script will package the IIS App (app) into a zip file ready for deployment.

```
msdeploy.cmd ^
  -verb:sync ^
  -source:iisApp="c:\inetpub\wwwroot\app" ^
  -dest:package="app.zip"
```

![Package the app](/resources/cmder_recipe_1.png)

The output is _/app.zip_. Note that this isn't a normal zip: there are additional files. This package can be manually imported in IIS Admin but in the next step we will deploy as app_2 to the Site->Default.

Alternatively:

```
msdeploy.cmd ^
  -verb:sync ^
  -source:iisApp="Default\app" ^
  -dest:package="app.zip"
```

###Deploy the package to the Site->Default as app_2

In this step the script is deploying the _app.zip_ file package just created into a new application _app2_

```
msdeploy.cmd ^
  -verb:sync ^
  -source:package="app.zip" ^
  -dest:iisApp="Default/app_2",skipAppCreation=false
```
![Deploy the package to app_2](/resources/cmder_recipe_2.png)

Open IIS Admin and refresh the Site->Default node and you should see app_2 as an application:

![App 2 published](/resources/published_app_2_iis.png)

Verify that all of the settings are as they were

![App 2 in browser](/resources/published_app_2_browser.png)

###Parameterise the Package

For this step we will specify that the package should accept parameters for the two app settings keys and for the database connection string.

```
set this_cnn1=Data Source=(LocalDb)\MSSQLLocalDb;Initial Catalog={Default_Catalog};Integrated Security=SSPI;

msdeploy.cmd ^
   -verb:sync ^
   -source:iisApp=Default/app ^
   -dest:package=param.zip ^
   -declareParam:name="Site Path Name",description="Full site path",defaultValue=Default/app,tags=IisApp,kind=ProviderPath,scope=iisApp,match=Default/app ^
   -declareParam:name="Application setting 1",kind=XmlFile,scope=web.config,match=//appSettings/add[@key='app1']/@value,defaultValue="app1 value (default)",description="Enter a setting for app1" ^
   -declareParam:name="Application setting 2",kind=XmlFile,scope=web.config,match=//appSettings/add[@key='app2']/@value,defaultValue="app2 value (default)",description="Enter a setting for app2" ^
   -declareParam:name="Connection string 1",kind=XmlFile,scope=web.config,match=//connectionStrings/add[@name='cnn1']/@connectionString,defaultValue="%this_cnn1%",description="Enter the connection string for cnn1"
```

On the first line the connection string is set to a variable for easier reading but you can see the three parameters being declared with _-declareParam_, and critically the _match_ value which
is the xpath through the web.config to the values. 

![Parameterised Package](/resources/cmder_recipe_3.png)

Take note of the number of parameters reported in the console window.

**Check your work**
In the -declareParam argument, take care to not include spaces between argument value eg.
```
..kind="XmlFile",scope=\\web.config$
```
*not*
```
..kind="XmlFile", scope=\\web.config$
```

This can cause parameters to not make it into the package. Check your work with
```
msdeploy.cmd -verb:getParameters -source:package=param.zip
```

![Output from verb:getParameters](/resources/cmder_recipe_3_check.png)

###Manually Import the Parameterised Package

In a following step we will provide the parameters at the command line but here the package will be
manually imported to make it clear that the parameters are being detected.

Open IIS Admin, go to the Site->Default node and select "Import Application".

![Select the package](/resources/man_import_select.png)

![Navigate to the parameterised package](/resources/man_import_selected.png)

At this point you are shown the contents of what can be deployed and can optionally deselect items.
![What is in the box](/resources/man_import_package_contains.png)

Note that at bottom right there is an _Advanced_ button. This has a nice option to perform a WhatIf install and see the output without committing.

Progress through to the next step and the application path along with the three parameters with the defaults we set are shown. These values can be overridden here.

![Enter Application Package Information](/resources/man_import_package_entry.png)

Change some of the settings as :

![Deployed Settings](/resources/man_import_package_settings.png)_

Note that the full path for the site has to be changed to the site name:
**if you leave the default Application Path as it was then an error will be shown since that app already exists.**

If all goes well, you should see these screens

![Installation Summary](/resources/man_import_package_progress_1.png)
![Installation Details](/resources/man_import_package_progress_2.png)

and back in IIS Admin:

![IIS Admin shows new site](/resources/iis_deployed_manually.png)

Now navigate to the web application to make sure that the settings we entered
have been applied:

![Confirm Manual Deployment](/resources/manually_deployed_browser.png)

###Scripted Deployment with Parameter values
