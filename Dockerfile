# FROM containers.intersystems.com/intersystems/iris:2021.1.0.215.0
FROM containers.intersystems.com/intersystems/iris:2023.2.0.201.0

USER root

COPY session.sh /

RUN mkdir /opt/demo && \
    chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/demo

USER ${ISC_PACKAGE_MGRUSER}

WORKDIR /opt/demo

ARG IRIS_MIRROR_ROLE=master

COPY Installer.cls .
COPY src src

SHELL [ "/session.sh" ]

RUN \
do $SYSTEM.OBJ.Load("Installer.cls", "ck") \
set sc = ##class(Demo.Installer).setup()

COPY init_mirror.sh /

CMD ["-a", "/init_mirror.sh"]
