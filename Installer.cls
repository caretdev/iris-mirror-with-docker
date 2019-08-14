Class Demo.Installer
{

XData MyInstall [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <Default Name="SourceDir" Value="#{$system.Process.CurrentDirectory()}"/>

  <Default Name="NAMESPACE" Value="DEMO"/>
  <Default Name="DBNAME" Value="DEMO"/>
  <Default Name="APPPATH" Dir="${SourceDir}" />
  <Default Name="CSPAPPPATH" Dir="/csp/demo/" />
  <Default Name="CSPAPPDIR" Dir="${CSPDIR}/demo/" />
  <Default Name="SOURCESPATH" Dir="${APPPATH}src" />
  <Default Name="RESOURCE" Value="%DB_${DBNAME}" /> 

  <Namespace Name="${NAMESPACE}" Code="${DBNAME}-CODE" Data="${DBNAME}-DATA" Create="yes" Ensemble="0">
    <Configuration>
      <Database Name="${DBNAME}-CODE" Dir="${APPPATH}code" Create="yes" Resource="${RESOURCE}" MountRequired="1" />
      <Database Name="${DBNAME}-DATA" Dir="${APPPATH}data" Create="yes" Resource="${RESOURCE}" MountRequired="1" />
    </Configuration>
    
    <CSPApplication Url="${CSPAPPPATH}" Directory="${CSPAPPDIR}" Grant="${RESOURCE}" CookiePath="${CSPAPPPATH}" AuthenticationMethods="64" />

    <Import File="${SOURCESPATH}" Recurse="1"/>
  </Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "MyInstall")
}

}
