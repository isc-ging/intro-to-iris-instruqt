#!/bin/bash

cat <<'EOF' > /tmp/Instruqt.Check.cls
Class %zInstruqt.Check
{

ClassMethod AddError(ByRef errors = 0, failureMsg As %String)
{
  set errors($Increment(errors)) = failureMsg
}

ClassMethod Failure(ByRef errors = 0, halt As %Boolean = 1)
{
  if $data(errors)=1,errors'=0 {
    set failureMsg = errors, errors = 0
    do ..AddError(.errors, failureMsg)
  }
  for i=1:1:errors {
    Write "FAIL: ", errors(i),!
  }
  if halt {
    set exit = errors > 0
    do ##class(%SYSTEM.Process).Terminate(,exit)
  }
}

ClassMethod CheckSQLPrepare(sql, failureMsg As %String, ByRef errors)
{
  Set tSC = ##class(%SQL.Statement).%New().%Prepare(sql)
  If $$$ISERR(tSC) {
    do ..AddError(.errors, failureMsg)
  }
}

ClassMethod CheckSQLExec(sql, failureMsg As %String, ByRef errors)
{
  Set tRes = ##class(%SQL.Statement).%ExecDirect(,sql)
  If tRes.%SQLCODE'=0 {
    do ..AddError(.errors, failureMsg)
  }
}

ClassMethod CachedQuery(scheme, table, sql, failureMsg, ByRef errors)
{
  set tRs = ##class(%SQL.Manager.Catalog).CachedQueryTableFunc(scheme, table)
  while tRs.%Next() {
    set query = $Piece($zstrip(tRs.Query_"/*#", "<WC"),"/*#")
    set query = $ZStrip(query, ">W", ".")
    Set tQueries(query) = ""
  }
  zwrite tQueries
  if '$Data(tQueries(sql)) {
    do ..AddError(.errors, failureMsg)
  }
}

ClassMethod HideSQLPane()
{
  new $namespace
  set $namespace = "%SYS"
  set db = ##class(SYS.Database).%OpenId($zu(12,"irislib"))

  set db.ReadOnly = 0
  do db.%Save()

#;  set p = ##class(%Dictionary.PropertyDefinition).%OpenId("%CSP.UI.Portal.SQL.Home||searchExpanded")
#;  set p.InitialExpression = 0
#;  do p.%Save()
#;
#;  do $system.OBJ.Compile("%CSP.UI.Portal.SQL.Home")

  set db.ReadOnly = 1
  do db.%Save()
}

ClassMethod DBChange(db, ByRef readOnly)
{
  new $namespace
  set $namespace = "%SYS"
  set db = ##class(SYS.Database).%OpenId($zu(12,db))
  set readOnly = db.ReadOnly
  Set db.ReadOnly = 0
  Quit db.%Save()
}

ClassMethod DBRestore(db, ByRef readOnly)
{
  new $namespace
  set $namespace = "%SYS"
  set db = ##class(SYS.Database).%OpenId($zu(12,db))
  set db.ReadOnly = readOnly
  Quit db.%Save()
}

ClassMethod ApplyPatches()
{
  new $namespace
  Do ..DBChange("enslib", .readOnly)
  set $namespace = "user"

  set method = ##class(%Dictionary.MethodDefinition).%OpenId("EnsPortal.ProductionConfig||adjustSizes")
  if $isobject(method) {
    set newCode = ##class(%Stream.TmpCharacter).%New()
    while 'method.Implementation.AtEnd {
      set line = method.Implementation.ReadLine()
      if $locate(line, "\b1336\b") { set line = $replace(line, 1336, 900) }
      if $locate(line, "\b25\b") { set line = $replace(line, 25, 0) }
      if line["return updated;" {
        do newCode.WriteLine("dgmDiv.style.width = 'calc(100vw - ' + propDiv.offsetWidth + 'px)';")
        do newCode.WriteLine("dgmhdrDiv.style.width = 'calc(100vw - ' + propDiv.offsetWidth + 'px)';")
        do newCode.WriteLine("svgDiv.style.width = 'calc(100vw - ' + propDiv.offsetWidth + 'px)';")
        do newCode.WriteLine("svg.setProperty('width',svgDiv.offsetWidth);")
        do newCode.WriteLine("svgDiagram.setProperty('width',svgDiv.offsetWidth);")
      }
      do newCode.WriteLine(line)
    }
    set method.Implementation = newCode
    set tSC = method.%Save() 
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
    set tSC = $system.OBJ.Compile("EnsPortal.ProductionConfig")
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
  }

  set method = ##class(%Dictionary.MethodDefinition).%New("EnsPortal.MessageViewer")
  if $isobject(method) {
    set method.Name = "onloadHandler"
    set method.Language = "javascript"
    set method.ClientMethod = 1
    do method.Implementation.WriteLine("this.toggleSearch();")
    do method.Implementation.WriteLine("this.toggleDetails();")
    do method.Implementation.WriteLine("this.invokeSuper('onloadHandler',[]);    ")
    set tSC = method.%Save() 
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
    set tSC = $system.OBJ.Compile("EnsPortal.MessageViewer")
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)    
  }
  
  set method = ##class(%Dictionary.MethodDefinition).%OpenId("EnsPortal.Dialog.ProductionWizard||ondialogStart")
  if $isobject(method) {
    do method.Implementation.WriteLine("zen('pkgName').setProperty('value','interop')")
    do method.Implementation.WriteLine("zen('txtProduction').setProperty('value','Production')")
    set tSC = method.%Save() 
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
    set tSC = $system.OBJ.Compile("EnsPortal.Dialog.ProductionWizard")
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
  }

  set method = ##class(%Dictionary.MethodDefinition).%OpenId("EnsPortal.Dialog.ProductionAddService||ondialogStart")
  if $isobject(method) {
    do method.Implementation.WriteLine("zen('ServiceOTHERClassName').setProperty('value','interop.RedditService');")
    do method.Implementation.WriteLine("zen('ServiceOTHERName').setProperty('value','FromRedditNew');")
    do method.Implementation.WriteLine("zen('ServiceOTHEREnabled').setProperty('value',true);")
    set tSC = method.%Save() 
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
    set tSC = $system.OBJ.Compile("EnsPortal.Dialog.ProductionAddService")
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
  }

  set method = ##class(%Dictionary.MethodDefinition).%OpenId("EnsPortal.Dialog.ProductionAddOperation||ondialogStart")
  if $isobject(method) {
    do method.Implementation.WriteLine("zen('OperationOTHERClassName').setProperty('value','EnsLib.EDI.XML.Operation.FileOperation');")
    do method.Implementation.WriteLine("zen('OperationOTHERName').setProperty('value','ToFile');")
    do method.Implementation.WriteLine("zen('OperationOTHEREnabled').setProperty('value',true);")
    set tSC = method.%Save() 
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
    set tSC = $system.OBJ.Compile("EnsPortal.Dialog.ProductionAddOperation")
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
  }
  
  set method = ##class(%Dictionary.MethodDefinition).%OpenId("EnsPortal.Dialog.ProductionAddProcess||ondialogStart")
  if $isobject(method) {
    do method.Implementation.WriteLine("zen('ProcessOTHERClassName').setProperty('value','EnsLib.MsgRouter.VDocRoutingEngine');")
    do method.Implementation.WriteLine("zenPage.toggleRuleCheckbox();")
    do method.Implementation.WriteLine("zen('ProcessOTHERName').setProperty('value','RouteCats');")
    do method.Implementation.WriteLine("zen('ProcessOTHEREnabled').setProperty('value',true);")
    do method.Implementation.WriteLine("zen('ProcessOTHERAutoRule').setProperty('value',true);")
    do method.Implementation.WriteLine("zenPage.toggleRuleField('OTHER');")
    do method.Implementation.WriteLine("zen('ProcessOTHERRulePackage').setProperty('value','interop');")
    set tSC = method.%Save() 
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
    set tSC = $system.OBJ.Compile("EnsPortal.Dialog.ProductionAddProcess")
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
  }
  set property = ##class(%Dictionary.PropertyDefinition).%OpenId("Ens.Config.Item||LogTraceEvents")
  if $isobject(property) {
    set property.InitialExpression = 1
    set tSC = property.%Save() 
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
    set tSC = $system.OBJ.Compile("Ens.Config.Item")
    If $$$ISERR(tSC) Do $System.OBJ.DisplayError(tSC)
  }

  Do ..DBRestore("enslib", .readOnly)
}

}
EOF

# only one terminal session at once allow
cat <<'EOF' > /tmp/zstart.mac
ROUTINE %ZSTART
#include %syPidtab
LOGIN
  Set pids = ""
  &sql(SELECT %DLIST(id) INTO :pids FROM %SYS.ProcessQuery WHERE Routine = 'shell')
  If SQLCODE=0 {
    For i=1:1:$Listlength(pids) {
      Set pid = $Listget(pids, i)
      Continue:pid=$Job
      Do $System.Process.Terminate(pid, 1)
    }
  }
  Quit
EOF

# some changes in css, so, it fits the smaller place
cat <<'EOF' > /usr/irissys/csp/broker/instruqtProduction.css
#serverRow {
  padding-left: 20px;
  left: 0px;
  box-sizing: border-box;
}
.page > * > tr:nth-child(2) #toolRibbon,
.page > * > tr:nth-child(2) #toolRibbon>.toolRibbon {
  width: 100% !important;
}
.page > * > tr:nth-child(2) .ribbonTitle {
  font-size: 24px;
}
.page > * > tr:nth-child(2) td:nth-child(4) {
  padding-left: 5px;
}
.page > * > tr:nth-child(2) td:nth-child(2),
.page > * > tr:nth-child(2) td:nth-child(5),
.page > * > tr:nth-child(2) td:nth-child(6),
.page > * > tr:nth-child(2) td:nth-child(6),
#command_cmdUpdate, #command_cmdRecover,
#id_spanChoose, #id_spanChoose+td {
  display: none;
}
.modalGroupIframe {
  background: white !important;
}
.modalGroupTitle td {
  color: white !important;
}
EOF

cat <<'EOF' > /tmp/ZAUTHENTICATE.mac
ROUTINE ZAUTHENTICATE
ZAUTHENTICATE(ServiceName, Namespace, Username, Password, Credentials, Properties) PUBLIC {
  set Properties("Username") = Username
  set Properties("Password") = Password
  set Properties("Roles") = "%All"
  quit $system.Status.OK()
}
GetCredentials(ServiceName,Namespace,Username,Password,Credentials) Public {
  set (Username, Password) = "instruqt"
  quit $system.Status.OK()
}
EOF

# patch zenutils, do not show native confirm dialog, just return true always
cat <<'EOF' >> /usr/irissys/csp/broker/zenutils.js
window.confirm = function(msg) { console.log("confirm", msg);return true; }
window.alert = function(msg) { console.log("alert", msg);return true; }
window.open = function(link) { console.log("open", link);zenLaunchPopupWindow(zenLink(link),'','status,scrollbars,resizable=yes');return true; }
if (document.location.pathname.includes("EnsPortal.ProductionConfig")) { 
  zenLoadCSS("instruqtProduction.css") 
}
if (document.location.pathname.includes("EnsPortal.MessageViewer")) { 
  zenLoadCSS("instruqtProduction.css") 
}
EOF

su - irisowner <<EOSU
/usr/irissys/dev/Cloud/ICM/waitISC.sh
cat <<'EOF' | iris session iris -U%SYS
do ##class(%SYSTEM.OBJ).Load("/tmp/ZAUTHENTICATE.mac","ck")
do ##class(Security.Users).UnExpireUserPasswords("*")
do ##class(Security.Users).Create("tech","%ALL","demo")
do ##class(Security.Users).AddRoles("UnknownUser","%ALL")
set p("AutheEnabled")=50341887
do ##class(Security.System).Modify(,.p)
set rs= ##class(Security.Applications).ListFunc("/csp/*")
set p("AutheEnabled")=8288, p("UseCookies") = 1
while rs.%Next() { do ##class(Security.Applications).Modify(rs.Name,.p) } kill p 
set p("AutheEnabled")=8288
do ##class(Security.Applications).Modify("/api/interop-editors",.p)
do ##class(%SYSTEM.OBJ).Load("/tmp/Instruqt.Check.cls","ck")
do ##class(%SYSTEM.OBJ).Load("/tmp/zstart.mac","ck")
do ##class(Security.SSLConfigs).Create("https")
do ##class(%zInstruqt.Check).HideSQLPane()
do ##class(%zInstruqt.Check).ApplyPatches()
halt
EOF
EOSU

