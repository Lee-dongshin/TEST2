$PBExportHeader$w_53017_d.srw
$PBExportComments$전국 타사월매출조회
forward
global type w_53017_d from w_com010_d
end type
end forward

global type w_53017_d from w_com010_d
end type
global w_53017_d w_53017_d

type variables
DataWindowChild idw_brand
String is_brand, is_yymm
end variables

on w_53017_d.create
call super::create
end on

on w_53017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymm" ,MidA(string(ld_datetime,"yyyymmdd"),1,6))
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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


is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, "%", "%")
IF il_rows > 0 THEN
  
	ls_modify =	"t_pg_id.Text 		= '" + is_pgm_id 	 + "'" + &
					 "t_user_id.Text 	= '" + gs_user_id  + "'" + &
					 "t_datetime.Text = '" + ls_datetime + "'" + &
					 "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					 "t_yymm.Text 		= '" + is_yymm +  "'" 
	
	dw_body.Modify(ls_modify)
	
	dw_body.SetFocus()
	
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53017_d","0")
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text 		= '" + is_pgm_id 	 + "'" + &
             "t_user_id.Text 	= '" + gs_user_id  + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_yymm.Text 		= '" + is_yymm +  "'" 

dw_print.Modify(ls_modify)


end event

event ue_preview();This.Trigger Event ue_title ()

dw_print.retrieve(is_brand, is_yymm, "%", "%")
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_print.retrieve(is_brand, is_yymm, "%", "%")

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_53017_d
end type

type cb_delete from w_com010_d`cb_delete within w_53017_d
end type

type cb_insert from w_com010_d`cb_insert within w_53017_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53017_d
end type

type cb_update from w_com010_d`cb_update within w_53017_d
end type

type cb_print from w_com010_d`cb_print within w_53017_d
end type

type cb_preview from w_com010_d`cb_preview within w_53017_d
end type

type gb_button from w_com010_d`gb_button within w_53017_d
end type

type cb_excel from w_com010_d`cb_excel within w_53017_d
end type

type dw_head from w_com010_d`dw_head within w_53017_d
integer y = 152
integer height = 148
string dataobject = "d_53017_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_53017_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_53017_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_53017_d
integer y = 332
integer height = 1668
string dataobject = "d_53017_d07"
end type

type dw_print from w_com010_d`dw_print within w_53017_d
string dataobject = "d_53017_d07"
end type

