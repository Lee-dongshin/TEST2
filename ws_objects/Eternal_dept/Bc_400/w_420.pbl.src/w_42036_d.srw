$PBExportHeader$w_42036_d.srw
$PBExportComments$배분표조회
forward
global type w_42036_d from w_com010_d
end type
end forward

global type w_42036_d from w_com010_d
integer width = 3685
integer height = 2248
end type
global w_42036_d w_42036_d

type variables
DatawindowChild idw_brand, idw_deal_fg //, idw_proc_yn
string is_brand, is_out_ymd, is_deal_fg, is_proc_yn, is_yymmdd,is_action, ls_print = '1'
long ii_work_no, ii_deal_seq
end variables

on w_42036_d.create
call super::create
end on

on w_42036_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "out_ymd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))


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

is_out_ymd = dw_head.GetItemString(1, "out_ymd")
if IsNull(is_out_ymd) or Trim(is_out_ymd) = "" then
   MessageBox(ls_title,"출고 의뢰일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_ymd")
   return false
end if

is_deal_fg = dw_head.GetItemString(1, "deal_fg")
if IsNull(is_deal_fg) or Trim(is_deal_fg) = "" then
   MessageBox(ls_title,"배분 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_fg")
   return false
end if

//is_proc_yn = dw_head.GetItemString(1, "proc_yn")
//if IsNull(is_proc_yn) or Trim(is_proc_yn) = "" then
//   MessageBox(ls_title,"처리 여부를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("proc_yn")
//   return false
//end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고 지정일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

ii_work_no = dw_head.GetItemNumber(1, "work_no")
if IsNull(ii_work_no) or ii_work_no <= 0 then
   MessageBox(ls_title,"작업 번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("work_no")
   return false
end if

//ii_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
//if is_proc_yn <> "Y" then	
//	if IsNull(ii_deal_seq) or ii_deal_seq < 0 then
//		MessageBox(ls_title,"배분차수를 입력하십시요!")
//		dw_head.SetFocus()
//		dw_head.SetColumn("deal_seq")
//		return false
//	end if
//end if

return true

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


dw_print.SetTransObject(SQLCA)

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_out_ymd.Text  = '" + String(is_out_ymd, '@@@@/@@/@@') + "'" + &
            "t_yymmdd.Text   = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_deal_fg.Text  = '" + idw_deal_fg.GetItemString(idw_deal_fg.GetRow(), "inter_display") + "'" + &
            "t_work_no.Text  = '" + String(ii_work_no) + "'"

dw_print.Modify(ls_modify)

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_out_ymd, is_deal_fg, is_yymmdd, ii_work_no)
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

type cb_close from w_com010_d`cb_close within w_42036_d
end type

type cb_delete from w_com010_d`cb_delete within w_42036_d
end type

type cb_insert from w_com010_d`cb_insert within w_42036_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42036_d
end type

type cb_update from w_com010_d`cb_update within w_42036_d
end type

type cb_print from w_com010_d`cb_print within w_42036_d
end type

type cb_preview from w_com010_d`cb_preview within w_42036_d
end type

type gb_button from w_com010_d`gb_button within w_42036_d
end type

type cb_excel from w_com010_d`cb_excel within w_42036_d
end type

type dw_head from w_com010_d`dw_head within w_42036_d
integer y = 156
integer height = 200
string dataobject = "d_42036_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("deal_fg", idw_deal_fg )
idw_deal_fg.SetTransObject(SQLCA)
idw_deal_fg.Retrieve('521')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

type ln_1 from w_com010_d`ln_1 within w_42036_d
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com010_d`ln_2 within w_42036_d
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_d`dw_body within w_42036_d
integer y = 368
integer width = 3598
integer height = 1644
string dataobject = "d_42036_d01"
end type

type dw_print from w_com010_d`dw_print within w_42036_d
string dataobject = "d_42036_r01"
end type

