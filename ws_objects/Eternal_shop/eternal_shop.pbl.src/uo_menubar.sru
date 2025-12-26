$PBExportHeader$uo_menubar.sru
$PBExportComments$메뉴 바
forward
global type uo_menubar from datawindow
end type
end forward

global type uo_menubar from datawindow
integer width = 571
integer height = 2152
string title = "none"
string dataobject = "d_shop_menu"
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
public subroutine of_settrans ()
public function integer of_outlookbar (integer ai_top)
end prototypes

event ue_mousemove;String ls_Object

ls_Object = Lower(This.GetObjectAtPointer())

IF (LeftA(ls_Object, 6) = "pgm_nm") THEN
	This.SetRow(Long(MidA(ls_Object, PosA(ls_Object, "~t") + 1)))
	This.Object.pgm_nm.Border    = "0~tIF (CurrentRow() = GetRow(), 6, 0)"
	This.Object.pgm_nm.font.weight="0~tIF (CurrentRow() = GetRow(), 700, 400)"
ELSE
	This.Object.pgm_nm.Border = "0"
	This.Object.pgm_nm.font.weight="400"
END IF

end event

public subroutine of_settrans ();This.SetTransObject(SQLCA)
ids_Data.SetTransObject(SQLCA)

il_RowCnt = ids_Data.Retrieve()

end subroutine

public function integer of_outlookbar (integer ai_top);Integer li_Bt_H = 70
Integer li_Bt_S = 14
String  ls_modify, ls_Error
integer i

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
		' background.mode="1" background.color="79741120")'
	ls_Error = This.Modify(ls_modify)
	IF (ls_Error <> "") THEN
		MessageBox("Create Group Error", ls_Error + "~n~n" + ls_modify)
	END IF
NEXT

This.Object.DataWindow.Header.Height = (ai_Top * li_Bt_S) + (ai_Top * li_Bt_H)
This.Object.DataWindow.Footer.Height = ((il_RowCnt - ai_Top) * li_Bt_S) + ((il_RowCnt - ai_Top) * li_Bt_H) - 3

Return 1

end function

on uo_menubar.create
end on

on uo_menubar.destroy
end on

event constructor;ids_Data = Create DataStore

ids_Data.DataObject = "d_menu_grp"

end event

event destructor;IF (IsValid(ids_Data)) THEN Destroy ids_Data

end event

event clicked;String ls_win_id, ls_win_nm, ls_pgm_stat, ls_pgm_id
Window lw_window
Long   ll_Top 

CHOOSE CASE dwo.name 
	CASE "pgm_nm" 
	   ls_pgm_stat = This.GetitemString(row, "pgm_stat")
	   ls_win_nm = This.GetitemString(row, "pgm_nm")
		IF gl_user_level = 999 OR ls_pgm_stat = 'B' THEN
		   ls_win_id = This.GetitemString(row, "pgm_id")
			
//			IF ls_win_id = "W_SH101_E" AND gs_brand = 'W' then
//				ls_win_id = "W_SH130_E"
//			END IF
//			IF ls_win_id = "W_SH202_E" AND gs_brand = 'W' then
//				ls_win_id = "W_SH231_E"
//			END IF
//
			//정상판매
			IF ls_win_id = "W_SH101_E" AND gs_brand_1 = 'X' then
					if MidA(gs_shop_cd_1,3,4) = '1890' then
						ls_win_id = "W_SH143_E" // 본사 1층 매장만 적용
					else					
						ls_win_id = "W_SH141_E" // 라운지비 오프라인 매장만 적용
					end if


			//행사판매
			elseif ls_win_id = "W_SH133_E" AND gs_brand_1 = 'X' then
					if MidA(gs_shop_cd_1,3,4) = '1890' then
						ls_win_id = "W_SH144_E" // 본사 1층 매장만 적용
					else
						ls_win_id = "W_SH142_E"// 라운지비 오프라인 매장만 적용
					end if
					
			elseif ls_win_id = "W_SH101_E" AND ( GS_shop_cd = 'LG2988' OR GS_shop_cd = 'KG2988') then
					ls_win_id = "W_SH141_E" 

			elseif ls_win_id = "W_SH101_E" AND MidA(gs_shop_cd,1,2) = 'NI' then
					ls_win_id = "W_SH133_E" 
			END IF

			//복합매장때문에 권한 만듬.
			//TB_93031_H에 없는 메뉴는 사용할 수 없음.
			if gs_brand_1 = 'X' then
				select isnull(pgm_id,'')
				into :ls_pgm_id
				from TB_93031_H
				where substring(menu_id,3,4) like substring(:gs_shop_cd,3,4)
						and pgm_id = :ls_win_id;
				
				if ls_pgm_id = '' then
				   MessageBox(ls_win_nm, "복합매장에서는 사용할수 없는 프로그램 입니다.") 
					return
				end if
			end if
		   lw_window = Parent
		   gf_open_sheet(lw_window, ls_win_id, ls_win_nm)
		ELSE
		   MessageBox(ls_win_nm, "사용할수 없는 프로그램 입니다.") 
		END IF
	CASE ELSE
		IF MidA(dwo.name, 1, 7) = "lookbar" THEN 
			ll_Top = Long(MidA(dwo.name, 9))
			of_outlookbar(ll_Top)
			gs_menu_id = This.Describe(dwo.name + ".Tag")
//			This.Retrieve(gs_menu_id)			
			if gs_shop_div <> 'M' then
				This.Retrieve(gs_menu_id)					
				
			else
//				This.Retrieve(gs_menu_id)
			end if
		END IF
END CHOOSE
end event

