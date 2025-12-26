$PBExportHeader$w_cu122_d.srw
$PBExportComments$생산계획대비실적
forward
global type w_cu122_d from w_com010_d
end type
type dw_graph from datawindow within w_cu122_d
end type
end forward

global type w_cu122_d from w_com010_d
integer width = 3653
integer height = 2236
dw_graph dw_graph
end type
global w_cu122_d w_cu122_d

type variables
string  is_brand, is_yymmdd
datawindowchild idw_brand
end variables

on w_cu122_d.create
int iCurrent
call super::create
this.dw_graph=create dw_graph
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_graph
end on

on w_cu122_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_graph)
end on

event pfc_preopen();call super::pfc_preopen;dw_graph.SetTransObject(SQLCA)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                              */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, gs_shop_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

dw_graph.retrieve(is_brand, is_yymmdd, gs_shop_cd)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      :                                              */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE as_column
	CASE "graph"
		dw_graph.Visible = true
		/* dw_head 필수입력 column check */
		IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0
	   dw_graph.retrieve(is_brand,is_yymmdd,gs_shop_cd)
	CASE "close"
		dw_graph.Visible = false
	CASE "bar"
		dw_graph.Object.gr_1.GraphType = 9
	CASE "line"
		dw_graph.Object.gr_1.GraphType = 12
					
END CHOOSE

RETURN 0

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

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_shop_cd + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetitemString(idw_brand.GetRow(),"inter_display") + "'" + &
				 "t_yymmdd.Text = '" + is_yymmdd + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_cu122_d
end type

type cb_delete from w_com010_d`cb_delete within w_cu122_d
end type

type cb_insert from w_com010_d`cb_insert within w_cu122_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_cu122_d
end type

type cb_update from w_com010_d`cb_update within w_cu122_d
end type

type cb_print from w_com010_d`cb_print within w_cu122_d
end type

type cb_preview from w_com010_d`cb_preview within w_cu122_d
end type

type gb_button from w_com010_d`gb_button within w_cu122_d
integer width = 3607
end type

type dw_head from w_com010_d`dw_head within w_cu122_d
integer width = 3570
integer height = 132
string dataobject = "d_cu122_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand",idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

event dw_head::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report 

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)


end event

type ln_1 from w_com010_d`ln_1 within w_cu122_d
integer beginy = 304
integer endx = 3598
integer endy = 304
end type

type ln_2 from w_com010_d`ln_2 within w_cu122_d
integer beginy = 308
integer endx = 3598
integer endy = 308
end type

type dw_body from w_com010_d`dw_body within w_cu122_d
integer y = 328
integer width = 3598
integer height = 1720
string dataobject = "d_cu122_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_cu122_d
string dataobject = "d_cu122_r01"
end type

type dw_graph from datawindow within w_cu122_d
boolean visible = false
integer width = 2889
integer height = 1804
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "그래프보기"
string dataobject = "d_cu122_d02"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report 

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)


end event

