$PBExportHeader$w_56122_d.srw
$PBExportComments$대리점 입금계획
forward
global type w_56122_d from w_com010_d
end type
end forward

global type w_56122_d from w_com010_d
integer width = 3685
integer height = 2248
end type
global w_56122_d w_56122_d

type variables
DataWindowChild idw_brand, idw_shop_div
String is_brand, is_fr_yymmdd, is_to_yymmdd
string is_shop_div, is_shop_cd

end variables

on w_56122_d.create
call super::create
end on

on w_56122_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;DateTime ld_datetime
String ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "YYYYMMDD")


dw_head.Setitem(1, "FR_yymmdd", ls_datetime )
dw_head.Setitem(1, "TO_yymmdd", ls_datetime)
dw_head.Setitem(1, "shop_div", 'K')

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title,"입금일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"입금일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if


is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
  is_shop_cd = '%'
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec  SP_56122_D01 'n', '20030109','20030109', 'k', '%'

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_shop_div, is_shop_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'"  + &
            "t_fr_yymmdd.Text = '" + is_fr_yymmdd + "'" + &
            "t_to_yymmdd.Text = '" + is_to_yymmdd + "'" 			

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56122_d","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"							// 매장 코드
		
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
		
				IF gf_shop_nm(as_data, 'S', ls_part_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 매장코드입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "shop_nm", ls_part_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "매장 코드 검색" 
				gst_cd.datawindow_nm   = "d_com912" 
				gst_cd.default_where   = " WHERE SHOP_CD LIKE '" + is_brand + "%' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " SHOP_CD LIKE '" + as_data + "%' "
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
					dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
					dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
END CHOOSE

RETURN 0

end event

type cb_close from w_com010_d`cb_close within w_56122_d
end type

type cb_delete from w_com010_d`cb_delete within w_56122_d
end type

type cb_insert from w_com010_d`cb_insert within w_56122_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56122_d
end type

type cb_update from w_com010_d`cb_update within w_56122_d
end type

type cb_print from w_com010_d`cb_print within w_56122_d
end type

type cb_preview from w_com010_d`cb_preview within w_56122_d
end type

type gb_button from w_com010_d`gb_button within w_56122_d
end type

type cb_excel from w_com010_d`cb_excel within w_56122_d
end type

type dw_head from w_com010_d`dw_head within w_56122_d
integer y = 176
integer height = 240
string dataobject = "d_56122_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		
		if LenA(data) <> 0 then 
		  return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   	else 
		  return -1
	   end if   
	  
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56122_d
end type

type ln_2 from w_com010_d`ln_2 within w_56122_d
end type

type dw_body from w_com010_d`dw_body within w_56122_d
integer x = 9
integer height = 1544
string dataobject = "d_56122_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_56122_d
string dataobject = "d_56122_r01"
end type

