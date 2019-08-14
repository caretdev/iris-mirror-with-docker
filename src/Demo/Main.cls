Class Demo.Main Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
  &html<<!DOCTYPE html>
<html>
<body>
Hello from IRIS
</body>
</html>>
  Quit $$$OK
}
}