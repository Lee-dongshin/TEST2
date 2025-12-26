$PBExportHeader$kola.sra
$PBExportComments$Generated Application Object
forward
global type kola from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type kola from application
string appname = "kola"
integer highdpimode = 0
string appruntimeversion = "25.0.0.3726"
end type
global kola kola

on kola.create
appname = "kola"
message = create message
sqlca = create transaction
sqlda = create dynamicdescriptionarea
sqlsa = create dynamicstagingarea
error = create error
end on

on kola.destroy
destroy( sqlca )
destroy( sqlda )
destroy( sqlsa )
destroy( error )
destroy( message )
end on

