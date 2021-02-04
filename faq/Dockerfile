ARG IMAGE=intersystems/iris:2020.3.0.221.0
FROM $IMAGE

USER irisowner

ENV SRCDIR=src
COPY source/ $SRCDIR/

## set up iris
RUN  iris start $ISC_PACKAGE_INSTANCENAME \
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") Do ##class(Security.Users).UnExpireUserPasswords("*") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

# clean up
RUN iris start $ISC_PACKAGE_INSTANCENAME nostu quietly \
 && printf "kill ^%%SYS(\"JOURNAL\") kill ^SYS(\"NODE\") h\n" | iris session $ISC_PACKAGE_INSTANCENAME -B | cat \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly bypass \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log \
 && cp $SRCDIR/iris.key $ISC_PACKAGE_INSTALLDIR/mgr/iris.key


### FAQ file copy
USER root
RUN mkdir -p /usr/FAQsetup/Global \
 && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/FAQsetup/Global \
 && mkdir -p /usr/FAQsetup/Global/FAQ \
 && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/FAQsetup/Global/FAQ \
 && cp $SRCDIR/TopicD.xml /usr/FAQsetup/Global \
 && cp $SRCDIR/FAQInstaller.cls /usr/FAQsetup/Global/FAQ


### FAQ initial setup
USER irisowner
RUN  iris start $ISC_PACKAGE_INSTANCENAME \
 && printf 'Set tSC=$system.OBJ.Load("/usr/FAQsetup/Global/FAQ/FAQInstaller.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly
