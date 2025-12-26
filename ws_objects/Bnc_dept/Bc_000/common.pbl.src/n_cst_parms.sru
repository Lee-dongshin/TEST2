$PBExportHeader$n_cst_parms.sru
$PBExportComments$Menu 탐색기 Open parm
forward
global type n_cst_parms from nonvisualobject
end type
end forward

global type n_cst_parms from nonvisualobject autoinstantiate
end type

type variables
Boolean   ib_Check = False
Integer	 ii_OpenPos
String    is_select, is_parentid, is_winid
String	 is_Filter, is_DataObject, is_Label, is_Gubun
Window	 iw_Parent, iw_Frame

end variables

on n_cst_parms.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_parms.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

