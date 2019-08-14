FROM intersystems/iris:2019.3.0.302.0

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