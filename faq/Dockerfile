#ARG IMAGE=intersystems/iris:2020.3.0.221.0
#ARG IMAGE=intersystems/iris:2021.1.0.215.0
ARG IMAGE=intersystems/iris:2021.1.0.215.0
#ARG IMAGE=intersystems/iris:2023.1.0.229.0
FROM $IMAGE

USER ${ISC_PACKAGE_MGRUSER}
ENV SRCDIR=src
COPY source/ $SRCDIR/

### FAQ file copy
USER root
RUN mkdir -p /usr/FAQsetup/Global \
 && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/FAQsetup/Global \
 && mkdir -p /usr/FAQsetup/Global/FAQ \
 && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/FAQsetup/Global/FAQ \
 && cp $SRCDIR/iris.key $ISC_PACKAGE_INSTALLDIR/mgr/iris.key\
 && cp $SRCDIR/FAQInstaller.cls /usr/FAQsetup/Global/FAQ

## set up iris
USER ${ISC_PACKAGE_MGRUSER}
RUN iris start IRIS \
 && iris session IRIS < $SRCDIR/iris.script \
 && iris stop IRIS quietly
