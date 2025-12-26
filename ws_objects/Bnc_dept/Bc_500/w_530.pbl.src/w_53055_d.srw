$PBExportHeader$w_53055_d.srw
$PBExportComments$점간이송 내역조회
forward
global type w_53055_d from w_com020_d
end type
end forward

global type w_53055_d from w_com020_d
end type
global w_53055_d w_53055_d

type variables
DataWindowChild idw_brand, idw_shop_div

String is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_shop_cd, is_shop_type, is_flag, is_opt

end variables

on w_53055_d.create
call super::create
end on

on w_53055_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.SetItem(1,"shop_div","%")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_530555_d","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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
is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF


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


is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
IF IsNull(is_fr_ymd) OR is_fr_ymd = "" THEN
   MessageBox(ls_title,"기준 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
IF IsNull(is_to_ymd) OR is_to_ymd = "" THEN
   MessageBox(ls_title,"기준 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

IF is_to_ymd < is_fr_ymd THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

is_flag = Trim(dw_head.GetItemString(1, "flag"))
IF IsNull(is_flag) OR is_flag = "" THEN
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("flag")
   RETURN FALSE
END IF

is_opt = Trim(dw_head.GetItemString(1, "opt"))
IF IsNull(is_opt) OR is_opt = "" THEN
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt")
   RETURN FALSE
END IF

RETURN TRUE

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
dw_body.reset()
il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_flag, is_opt)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

type cb_close from w_com020_d`cb_close within w_53055_d
end type

type cb_delete from w_com020_d`cb_delete within w_53055_d
end type

type cb_insert from w_com020_d`cb_insert within w_53055_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_53055_d
end type

type cb_update from w_com020_d`cb_update within w_53055_d
end type

type cb_print from w_com020_d`cb_print within w_53055_d
boolean visible = false
end type

type cb_preview from w_com020_d`cb_preview within w_53055_d
boolean visible = false
end type

type gb_button from w_com020_d`gb_button within w_53055_d
end type

type cb_excel from w_com020_d`cb_excel within w_53055_d
end type

type dw_head from w_com020_d`dw_head within w_53055_d
integer height = 156
string dataobject = "d_42028_h01"
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

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com020_d`ln_1 within w_53055_d
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com020_d`ln_2 within w_53055_d
integer beginy = 340
integer endy = 340
end type

type dw_list from w_com020_d`dw_list within w_53055_d
integer x = 9
integer y = 352
integer width = 1106
integer height = 1648
string dataobject = "d_53055_d01"
end type

event dw_list::clicked;call super::clicked;string ls_shop_cd

ls_shop_cd    = this.GetItemString(row, "shop_cd")
		
il_rows = dw_body.Retrieve(is_brand, is_fr_ymd, is_to_ymd, ls_shop_cd, is_flag, is_opt)
	

Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_53055_d
integer x = 1147
integer y = 352
integer width = 2427
integer height = 1648
string dataobject = "d_53055_d02"
end type

type st_1 from w_com020_d`st_1 within w_53055_d
integer x = 1120
integer y = 352
integer height = 1648
end type

type dw_print from w_com020_d`dw_print within w_53055_d
end type

