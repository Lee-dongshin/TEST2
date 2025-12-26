$PBExportHeader$bnc_masterfile.sra
$PBExportComments$Generated Application Object
forward
global type bnc_masterfile from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
string gs_user_id, gs_pass_wd, gs_saup_gubn

end variables

global type bnc_masterfile from application
string appname = "bnc_masterfile"
integer highdpimode = 0
string appruntimeversion = "25.0.0.3726"
end type
global bnc_masterfile bnc_masterfile

on bnc_masterfile.create
appname="bnc_masterfile"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on bnc_masterfile.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
open(W_logon)
end event

