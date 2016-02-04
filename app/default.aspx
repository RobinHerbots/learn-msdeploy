<%@ Language=C# %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <title>Simple Page</title>
</head>
<body>
  <main>  
  <header>AppSettings and ConnectionStrings from web.config</header>
  <dl>
    <dt>appSettings/add[@key="app1"]</dt>
    <dd><%= System.Configuration.ConfigurationManager.AppSettings["app1"] %></dd>
    <dt>appSettings/add[@key="app2"]</dt>
    <dd><%= System.Configuration.ConfigurationManager.AppSettings["app2"] %></dd>
    <dt>connectionStrings/add[@name="cnn1"]</dt>
    <dd><%= System.Configuration.ConfigurationManager.ConnectionStrings["cnn1"].ConnectionString %></dd>
  </dl>
  </main>
</body>
</html>