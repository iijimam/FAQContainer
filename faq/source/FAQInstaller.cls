Class ZFAQSetup.Installer
{

XData setup
{
<Manifest>
  <Var Name="SourceDir" Value="/usr/FAQsetup/Global/FAQ/"/>
  <Var Name="DURABLESYS" Value='#{$SYSTEM.Util.GetEnviron("ISC_DATA_DIRECTORY")}'/>

  <Namespace Name="FAQ" Code="FAQ" Data="FAQ" Create="overwrite" Ensemble="no">

    <!-- FAQデータベースがない＝初期設定の場合にIFを通る -->
    <If Condition='##class(%File).Exists("${DURABLESYS}/mgr/faq/IRIS.DAT")=0'>
      <Configuration>
        <Database Name="FAQ" Dir="${DURABLESYS}/mgr/faq/" Create="yes" Resource="%DB_FAQ"/>
      </Configuration>

      <Import File="${SourceDir}FAQ/Installer.cls" Flags="ck"/>
      <Import File="${SourceDir}KB/UsersVoice.cls" Flags="ck"/>
      <Import File="${SourceDir}KB/Utility.cls" Flags="ck"/>
      <Import File="${SourceDir}KB/Setup.cls" Flags="ck"/>
      <Import File="${SourceDir}KB/Config.cls" Flags="ck"/>

    </If>

    <CSPApplication Url="/csp/faq"
	           Directory="${DURABLESYS}/csp/faq/"
	           Recurse="true"
	           AuthenticationMethods="64"
	           AutoCompile="0"
	           IsNamespaceDefault="true"
             Grant="%All"
    />

  </Namespace>

 <!-- 監査のユーザイベント作成--> 
 <Namespace Name="%SYS" Create="no">
  <If Condition='##class(Security.Events).Exists("FAQ","Create","Topic")=0'>
    <Invoke Class="Security.Events" Method="Create" CheckStatus="true">
      <Arg Value="FAQ"/>
      <Arg Value="Create"/>
      <Arg Value="Topic"/>
    </Invoke>
  </If>
  <If Condition='##class(Security.Events).Exists("FAQ","Update","Topic")=0'>
    <Invoke Class="Security.Events" Method="Create" CheckStatus="true">
      <Arg Value="FAQ"/>
      <Arg Value="Update"/>
      <Arg Value="Topic"/>
    </Invoke>
  </If>
  <Invoke Class="ZFAQSetup.Installer" Method="UpdatePassword" CheckStatus="true"/>
  <Invoke Class="ZFAQSetup.Installer" Method="DisabledURL" CheckStatus="true"/>
 </Namespace>

<!-- データベースキャッシュサイズの設定-->
<SystemSetting Name="Config.config.globals8kb" Value="512"/> 
<!--シャットダウン時SYSLOGをコンソールログに出力する設定-->
<SystemSetting Name="Config.Miscellaneous.ShutDownLogErrors" Value="1"/>
<!--SYSLOGのエントリ数の設定-->
<SystemSetting Name="Config.config.errlog" Value="1000"/>
</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod UpdatePassword() As %Status
{
  set st=$$$OK
  Try {
    // _system
    set p("Enabled")=1
    set p("PasswordNeverExpires")=1
    set p("Password")="ISC-Japan-SYS"
    $$$THROWONERROR(ex,##class(Security.Users).Modify("_SYSTEM",.p))
    $$$THROWONERROR(ex,##class(Security.Users).Modify("SuperUser",.p))
    $$$THROWONERROR(ex,##class(Security.Users).Modify("Admin",.p))
    $$$THROWONERROR(ex,##class(Security.Users).Modify("irisowner",.p))
    $$$THROWONERROR(ex,##class(Security.Users).Modify("CSPSystem",.p))
  } Catch ex {
    set st=ex.AsStatus()
  }
    quit st
}

/// 不必要なパスを無効化
ClassMethod DisabledURL() As %Status
{
	#dim ex As %Exception.AbstractException
	set status=$$$OK
	try {
		// /csp/userの無効化
		write $namespace,!
		$$$THROWONERROR(ex,##class(Security.Applications).Get("/csp/user",.pro))
		set pro("Enabled")=0
		$$$THROWONERROR(ex,##class(Security.Applications).Modify("/csp/user",.pro))
		
		// /csp/documaticの無効化
		kill pro
		$$$THROWONERROR(ex,##class(Security.Applications).Get("/csp/documatic",.pro))
		set pro("Enabled")=0
		$$$THROWONERROR(ex,##class(Security.Applications).Modify("/csp/documatic",.pro))
	}
	catch ex {
		set status=ex.AsStatus()
	}
	quit status
}

}
