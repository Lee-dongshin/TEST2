$PBExportHeader$uo_menubar.sru
$PBExportComments$메뉴바
forward
global type uo_menubar from datawindow
end type
end forward

global type uo_menubar from datawindow
integer width = 654
integer height = 2136
string title = "none"
string dataobject = "d_eis_menu"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_mousemove pbm_mousemove
end type
global uo_menubar uo_menubar

type variables
DataStore ids_Data
Long      il_RowCnt
end variables

forward prototypes
public function integer of_outlookbar (integer ai_top)
end prototypes

event ue_mousemove;String ls_Object

ls_Object = Lower(This.GetObjectAtPointer())

//IF (Left(ls_Object, 6) = "pgm_nm") THEN
//	This.SetRow(Long(Mid(ls_Object, Pos(ls_Object, "~t") + 1)))
//	This.Object.pgm_nm.Border    = "0~tIF (CurrentRow() = GetRow(), 6, 0)"
//	This.Object.pgm_nm.Color = "0~tIF (CurrentRow() = GetRow(), rgb(0,255,255), rgb(0,0,0))"
//ELSE
//	This.Object.pgm_nm.Border = "0"
//	This.Object.pgm_nm.Color  = RGB(0, 0, 0)
//END IF

IF (LeftA(ls_Object, 6) = "pgm_nm") THEN
	This.SetRow(Long(MidA(ls_Object, PosA(ls_Object, "~t") + 1)))
	This.Object.pgm_nm.Border    = "0~tIF (CurrentRow() = GetRow(), 6, 0)"
	This.Object.pgm_nm.font.weight="0~tIF (CurrentRow() = GetRow(), 700, 400)"
ELSE
	This.Object.pgm_nm.Border = "0"
	This.Object.pgm_nm.font.weight="400"
END IF

end event

public function integer of_outlookbar (integer ai_top);CONSTANT Integer li_Bt_H = 70
CONSTANT Integer li_Bt_S = 14
String   ls_modify, ls_Error
integer  i
//
IF il_RowCnt < 1 THEN RETURN -1

FOR i = 1 TO il_RowCnt
	This.Modify("Destroy lookbar_" + String(i))
	IF i <= ai_Top THEN
      ls_modify = 'create text(band=header y="' + String(((i - 1) * li_Bt_S) + ((i - 1) * li_Bt_H) + 3) + '"'
	ELSE
      ls_modify = 'create text(band=footer y="' + String(((i - ai_Top - 1) * li_Bt_S) + (((i - ai_Top) - 1) * li_Bt_H) + 5) + '"'
	END IF
	ls_modify = ls_modify + ' alignment="2" text="' + ids_Data.GetItemString(i, "pgm_nm") + '" ' + &
	   ' tag="' + ids_Data.GetItemString(i, "pgm_id") + '" ' + &
		' border="6" color="0" x="3"' + &
		' height="' + String(li_Bt_H) + '" width="' + String(This.Width - 27) + '" ' + &
		' font.face="굴림체" font.height="-10" name=lookbar_' + String(i) + & 
		' font.weight="400"  font.family="1" font.pitch="1" font.charset="129" ' + &
		' background.mode="0" background.color="' + String(RGB(76,193,141)) + '" color="' + String(rgb(10,43,28)) + '")' 
		 
	ls_Error = This.Modify(ls_modify)
	IF (ls_Error <> "") THEN
		MessageBox("Create Group Error", ls_Error + "~n~n" + ls_modify)
	END IF
NEXT


//FOR i = 1 TO il_RowCnt
//	This.Modify("Destroy lookbar_" + String(i))
//	IF i <= ii_GroupsOnTop THEN
//      ls_modify = 'create text(band=header y="' + String(((i - 1) * li_ButtonSpacing) + ((i - 1) * li_ButtonHeight) + 3) + '"'
//	ELSE
//      ls_modify = 'create text(band=footer y="' + String(((i - ii_GroupsOnTop - 1) * li_ButtonSpacing) + (((i - ii_GroupsOnTop) - 1) * li_ButtonHeight) + 5) + '"'
//	END IF
//	ls_modify = ls_modify + ' alignment="2" text="' + ids_Data.GetItemString(i, "pgm_nm") + '" ' + &
//		' border="6" color="0" x="3"' + &
//		' height="' + String(li_ButtonHeight) + '" width="' + String(This.Width - 27) + '" ' + &
//		' font.face="굴림체" font.height="-10" name=lookbar_' + String(i) + & 
//		' font.weight="400"  font.family="1" font.pitch="1" font.charset="129" ' + &
//		' background.mode="1" background.color="79741120")'
//	ls_Error = This.Modify(ls_modify)
//	IF (ls_Error <> "") THEN
//		MessageBox("Create Group Error", ls_Error + "~n~n" + ls_modify)
//	END IF
//NEXT

//This.Object.DataWindow.Header.Height = (ii_GroupsOnTop * li_ButtonSpacing) + (ii_GroupsOnTop * li_ButtonHeight)
//This.Object.DataWindow.Footer.Height = ((li_RowCnt - ii_GroupsOnTop) * li_ButtonSpacing) + ((li_RowCnt - ii_GroupsOnTop) * li_ButtonHeight) - 3

This.Object.DataWindow.Header.Height = (ai_Top * li_Bt_S) + (ai_Top * li_Bt_H)
This.Object.DataWindow.Footer.Height = ((il_RowCnt - ai_Top) * li_Bt_S) + ((il_RowCnt - ai_Top) * li_Bt_H) - 3

Return 1


/*--------------------------------*/
//Integer li_Bt_H = 70
//Integer li_Bt_S = 14
//String  ls_modify, ls_Error
//integer i
//
//IF il_RowCnt < 1 THEN RETURN -1
//
//FOR i = 1 TO il_RowCnt
//	This.Modify("Destroy lookbar_" + String(i))
//	IF i <= ai_Top THEN
//      ls_modify = 'create text(band=header y="' + String(((i - 1) * li_Bt_S) + ((i - 1) * li_Bt_H) + 3) + '"'
//	ELSE
//      ls_modify = 'create text(band=footer y="' + String(((i - ai_Top - 1) * li_Bt_S) + (((i - ai_Top) - 1) * li_Bt_H) + 5) + '"'
//	END IF
//	ls_modify = ls_modify + ' alignment="2" text="' + ids_Data.GetItemString(i, "pgm_nm") + '" ' + &
//	   ' tag="' + ids_Data.GetItemString(i, "pgm_id") + '" ' + &
//		' border="6" color="0" x="3"' + &
//		' height="' + String(li_Bt_H) + '" width="' + String(This.Width - 27) + '" ' + &
//		' font.face="굴림체" font.height="-10" name=lookbar_' + String(i) + & 
//		' font.weight="400"  font.family="1" font.pitch="1" font.charset="129" ' + &
//		' background.mode="1" background.color="79741120")'
//	ls_Error = This.Modify(ls_modify)
//	IF (ls_Error <> "") THEN
//		MessageBox("Create Group Error", ls_Error + "~n~n" + ls_modify)
//	END IF
//NEXT
//
//This.Object.DataWindow.Header.Height = (ai_Top * li_Bt_S) + (ai_Top * li_Bt_H)
//This.Object.DataWindow.Footer.Height = ((il_RowCnt - ai_Top) * li_Bt_S) + ((il_RowCnt - ai_Top) * li_Bt_H) - 3
//
//
end function

on uo_menubar.create
end on

on uo_menubar.destroy
end on

event constructor;ids_Data = Create DataStore

ids_Data.DataObject = "d_outlookbar"
ids_Data.SetTransObject(SQLCA)

il_RowCnt = ids_Data.Retrieve()

end event

event destructor;IF (IsValid(ids_Data)) THEN Destroy ids_Data

end event

