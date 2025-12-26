$PBExportHeader$w_42029_d.srw
$PBExportComments$월별창고출고현황
forward
global type w_42029_d from w_com010_d
end type
end forward

global type w_42029_d from w_com010_d
integer width = 3675
integer height = 2276
string title = "년도/시즌별창고수불현황"
end type
global w_42029_d w_42029_d

type variables
DataWindowChild idw_brand, idw_frm_year, idw_to_year,idw_house_cd
string is_brand,  is_frm_year,  is_yymm,  is_to_year, is_house_cd

end variables

on w_42029_d.create
call super::create
end on

on w_42029_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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

is_frm_year = dw_head.GetItemString(1, "frm_year")
if IsNull(is_frm_year) or Trim(is_frm_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_year")
   return false
end if

is_to_year = dw_head.GetItemString(1, "to_year")
if IsNull(is_to_year) or Trim(is_to_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_year")
   return false
end if




is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if


is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준일자 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if



return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

// exec sp_42029_d01 'n', '200205' , '2000', '2002', '010000'

il_rows = dw_body.retrieve( is_brand,is_yymm, is_frm_year,  is_to_year, is_house_cd)
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

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymm", LeftA(string(ld_datetime, "yyyymmdd"),6))

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_year

ls_year =  idw_frm_year.GetItemString(idw_frm_year.GetRow(), "inter_nm") + ' ~ ' + &
					  idw_to_year.GetItemString(idw_to_year.GetRow(), "inter_nm") 

					  
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_year.Text = '" + ls_year + "'" + &					
					"t_yymm.Text = '" + is_yymm + "'" + &										
					"t_house_cd.Text = '" + idw_house_cd.GetItemString(idw_house_cd.GetRow(), "shop_display") + "'"  
					

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42029_d","0")
end event

type cb_close from w_com010_d`cb_close within w_42029_d
end type

type cb_delete from w_com010_d`cb_delete within w_42029_d
end type

type cb_insert from w_com010_d`cb_insert within w_42029_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42029_d
end type

type cb_update from w_com010_d`cb_update within w_42029_d
end type

type cb_print from w_com010_d`cb_print within w_42029_d
end type

type cb_preview from w_com010_d`cb_preview within w_42029_d
end type

type gb_button from w_com010_d`gb_button within w_42029_d
end type

type cb_excel from w_com010_d`cb_excel within w_42029_d
end type

type dw_head from w_com010_d`dw_head within w_42029_d
integer y = 184
integer height = 220
string dataobject = "d_42029_h01"
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("frm_year", idw_frm_year )
idw_frm_year.SetTransObject(SQLCA)
idw_frm_year.Retrieve('002')

This.GetChild("to_year", idw_to_year )
idw_to_year.SetTransObject(SQLCA)
idw_to_year.Retrieve('002')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

type ln_1 from w_com010_d`ln_1 within w_42029_d
integer beginy = 412
integer endy = 412
end type

type ln_2 from w_com010_d`ln_2 within w_42029_d
integer beginy = 416
integer endy = 416
end type

type dw_body from w_com010_d`dw_body within w_42029_d
integer y = 436
integer height = 1604
string dataobject = "d_42029_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_42029_d
integer x = 2574
integer y = 1156
string dataobject = "d_42029_r01"
end type

