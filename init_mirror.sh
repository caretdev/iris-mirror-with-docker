#!/bin/bash

nohup $IRISSYS/ISCAgentUser start &>/dev/null &
sleep 1

MIRROR_NAME=Demo
DATABASE=/opt/demo/data
BACKUP_FOLDER=/opt/backup

make_backup() {
iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(SYS.Database).DismountDatabase(\"${DATABASE}\")"
# iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(Backup.General).ExternalFreeze()"
md5sum ${DATABASE}/IRIS.DAT
cp ${DATABASE}/IRIS.DAT ${BACKUP_FOLDER}/IRIS.DAT
# iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(Backup.General).ExternalThaw()"
iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(SYS.Database).MountDatabase(\"${DATABASE}\")"
return 0
}

# Enable Mirroring
iris session $ISC_PACKAGE_INSTANCENAME -U %SYS <<- END
do ##class(Security.Services).Get("%Service_Mirror", .svcProps)
set svcProps("Enabled") = 1
do ##class(Security.Services).Modify("%Service_Mirror", .svcProps)
halt
END
exit=$?

if [ $exit -ne 0 ]; 
then
  exit $exit;
fi

master() {
rm -rf $BACKUP_FOLDER/IRIS.DAT
iris session $ISC_PACKAGE_INSTANCENAME -U %SYS <<- END
set mirror("UseSSL") = 0
set sc = ##class(SYS.Mirror).CreateNewMirrorSet("${MIRROR_NAME}", "master", .mirror)
if 'sc do \$system.OBJ.DisplayError(sc) quit
hang 2
set sc = ##class(SYS.Mirror).AddDatabase("${DATABASE}", "DEMO-DATA")
if 'sc do \$system.OBJ.DisplayError(sc)
hang 2
halt
END
}

restore_backup() {
while [ ! -f $BACKUP_FOLDER/IRIS.DAT ]
do
  sleep 2
done
iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(SYS.Database).DismountDatabase(\"${DATABASE}\")"
cp $BACKUP_FOLDER/IRIS.DAT $DATABASE/IRIS.DAT
md5sum $DATABASE/IRIS.DAT
iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(SYS.Database).MountDatabase(\"${DATABASE}\")"
}

backup() {
iris session $ISC_PACKAGE_INSTANCENAME -U %SYS <<- END
set sc = ##class(SYS.Mirror).JoinMirrorAsFailoverMember("${MIRROR_NAME}", "backup", "${ISC_PACKAGE_INSTANCENAME}", "$1")
if 'sc do \$system.OBJ.DisplayError(sc)
hang 2
set sc = ##class(SYS.Mirror).ActivateMirroredDatabase("${DATABASE}")
if 'sc do \$system.OBJ.DisplayError(sc)
halt
END
}

if [ "$IRIS_MIRROR_ROLE" == "master" ]; then 
  master
  make_backup
else 
  restore_backup
  backup $IRIS_MIRROR_AGENT
fi

