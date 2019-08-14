#!/bin/bash

iris start $ISC_PACKAGE_INSTANCENAME quietly

iris session $ISC_PACKAGE_INSTANCENAME -U %SYS << END
do ##class(%SYSTEM.Process).CurrentDirectory("$PWD")
set sc = 1
$@
if '\$Get(sc) do ##class(%SYSTEM.Process).Terminate(, 1)
do ##class(SYS.Container).QuiesceForBundling()
do ##class(SYS.Container).SetMonitorStateOK("irisowner")

Do ##class(Security.Users).UnExpireUserPasswords("*")
halt
END

exit=$?

iris stop $ISC_PACKAGE_INSTANCENAME quietly

exit $exit