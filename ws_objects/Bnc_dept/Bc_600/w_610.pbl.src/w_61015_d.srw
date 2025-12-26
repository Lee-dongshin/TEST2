$PBExportHeader$w_61015_d.srw
$PBExportComments$주단위판매현황
forward
global type w_61015_d from w_com010_d
end type
type dw_detail from datawindow within w_61015_d
end type
type ddlb_1 from dropdownlistbox within w_61015_d
end type
end forward

global type w_61015_d from w_com010_d
integer width = 3680
integer height = 2276
dw_detail dw_detail
ddlb_1 ddlb_1
end type
global w_61015_d w_61015_d

type variables
string is_frm_date, is_to_date, is_sale_type, is_style_opt, is_style
integer ii_graph_index
end variables

on w_61015_d.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.ddlb_1=create ddlb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.ddlb_1
end on

on w_61015_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.ddlb_1)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_date",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_date",string(ld_datetime, "yyyymmdd"))

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

 
if IsNull(gs_style_comb) or Trim(gs_style_comb) = "" then
   MessageBox(ls_title,"조회할 스타일이 없습니다!")
   dw_head.SetFocus()
   return false
end if


is_frm_date = dw_head.GetItemString(1, "frm_date")
if IsNull(is_frm_date) or Trim(is_frm_date) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_date")
   return false
end if


is_sale_type = dw_head.GetItemString(1, "sale_type")
if IsNull(is_sale_type) or Trim(is_sale_type) = "" then
   MessageBox(ls_title,"판매형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

is_style_opt = dw_head.GetItemString(1, "style_opt")
if IsNull(is_style_opt) or Trim(is_style_opt) = "" then
   MessageBox(ls_title,"차수구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_opt")
   return false
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

il_rows = dw_body.retrieve(gs_style_comb, is_sale_type, is_style_opt, is_frm_date)
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

event pfc_preopen();call super::pfc_preopen;dw_DETAIL.SetTransObject(SQLCA)
end event

event ue_print();This.Trigger Event ue_title()


if dw_detail.visible = false then
		dw_print.dataobject = "d_61015_R01" 
      dw_print.SetTransObject(SQLCA)
  	   dw_print.retrieve(gs_style_comb, is_sale_type, is_style_opt, is_frm_date)
else 
	if is_style_opt = "D" then
		dw_print.dataobject = "d_61015_d031" 
	else
		dw_print.dataobject = "d_61015_d041"  
	end if
      dw_print.SetTransObject(SQLCA)
      dw_print.retrieve(IS_SALE_TYPE,IS_STYLE_OPT, IS_FRM_DATE,iS_TO_DATE, iS_STYLE)
		dw_print.object.graph.graphtype = ii_graph_index		
	if is_style_opt = "D" then
		dw_print.object.graph.title = iS_STYLE + "(스타일/칼라별)"
	else	
		dw_print.object.graph.title = iS_STYLE + "(스타일(차수별))"
	end if			
		
end if		
		

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()


if dw_detail.visible = false then
	dw_print.retrieve(gs_style_comb, is_sale_type, is_style_opt, is_frm_date)
else 
	if is_style_opt = "D" then
		dw_print.dataobject = "d_61015_d041" 
	else
		dw_print.dataobject = "d_61015_d031"  
	end if
      dw_print.SetTransObject(SQLCA)
      dw_print.retrieve(IS_SALE_TYPE,IS_STYLE_OPT, IS_FRM_DATE,iS_TO_DATE, iS_STYLE)
		dw_print.object.graph.graphtype = ii_graph_index
	if is_style_opt = "D" then
		dw_print.object.graph.title = iS_STYLE + "(스타일/칼라별)"
	else	
		dw_print.object.graph.title = iS_STYLE + "(스타일(차수별))"
	end if	
		
end if		
		

dw_print.inv_printpreview.of_SetZoom()
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_chno_gubun, ls_gubun

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_style_opt = 'S' Then
	ls_chno_gubun = 'STYLE'
ElseIF is_style_opt = 'C' Then
	ls_chno_gubun = 'STYLE/CHNO'
Else
	ls_chno_gubun = 'STYLE/CHNO/COLOR'	
End If

If is_SALE_TYPE = '1' Then
	ls_gubun = '정상'
ElseIf is_SALE_TYPE = '2' Then
	ls_gubun = '세일'
ElseIf is_SALE_TYPE = '3' Then
	ls_gubun = '기타'	
Else
	ls_gubun = '전체'
End If

ls_modify =	"t_yymmdd.Text     = '" + String(is_FRM_DATE, '@@@@/@@/@@') + "'" + &
            "t_chno_gubun.Text = '" + ls_chno_gubun + "'" + &
            "t_gubun.Text      = '" + ls_gubun      + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61015_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61015_d
integer taborder = 120
end type

type cb_delete from w_com010_d`cb_delete within w_61015_d
integer taborder = 70
end type

type cb_insert from w_com010_d`cb_insert within w_61015_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61015_d
end type

type cb_update from w_com010_d`cb_update within w_61015_d
integer taborder = 110
end type

type cb_print from w_com010_d`cb_print within w_61015_d
integer taborder = 80
end type

type cb_preview from w_com010_d`cb_preview within w_61015_d
integer taborder = 90
end type

type gb_button from w_com010_d`gb_button within w_61015_d
end type

type cb_excel from w_com010_d`cb_excel within w_61015_d
integer taborder = 100
end type

type dw_head from w_com010_d`dw_head within w_61015_d
integer y = 140
integer height = 288
string dataobject = "d_61015_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_61015_d
end type

type ln_2 from w_com010_d`ln_2 within w_61015_d
end type

type dw_body from w_com010_d`dw_body within w_61015_d
string dataobject = "d_61015_lee"
boolean maxbox = true
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;

//ALTER  procedure dbo.SP_55016_D02 (
//					@sale_type	varchar(01),
//					@style_opt	varchar(01),
//				   @frm_date	varchar(08),
//				   @to_date	   varchar(08),
//					@style		varchar(08)
//				   )	
iS_STYLE = DW_BODY.GETITEMSTRING(ROW, "STYLE")
iS_TO_DATE = DW_BODY.GETITEMSTRING(ROW, "TO_DATE")

IF IS_STYLE_OPT = "D" THEN
	DW_DETAIL.DATAOBJECT = "D_61015_D041"
	dw_DETAIL.SetTransObject(SQLCA)
ELSE	
	DW_DETAIL.DATAOBJECT = "D_61015_D031"
	dw_DETAIL.SetTransObject(SQLCA)
END IF

il_rows = dw_DETAIL.retrieve(IS_SALE_TYPE,IS_STYLE_OPT, IS_FRM_DATE,iS_TO_DATE, iS_STYLE)

IF il_rows > 0 THEN
   DW_DETAIL.VISIBLE = TRUE
	if is_style_opt = "D" then
		dw_detail.object.graph.title = iS_STYLE + "(스타일/칼라별)"
	else	
		dw_detail.object.graph.title = iS_STYLE + "(스타일(차수별))"
	end if	
		
ELSEIF il_rows = 0 THEN
   DW_DETAIL.VISIBLE = FALSE 
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   DW_DETAIL.VISIBLE = TRUE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF


end event

type dw_print from w_com010_d`dw_print within w_61015_d
string dataobject = "d_61015_R01"
end type

type dw_detail from datawindow within w_61015_d
boolean visible = false
integer x = 9
integer y = 112
integer width = 3355
integer height = 1868
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "그래프"
string dataobject = "d_61015_d031"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type ddlb_1 from dropdownlistbox within w_61015_d
integer x = 2885
integer y = 188
integer width = 704
integer height = 1036
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "ColStakedObj"
boolean sorted = false
string item[] = {"Area","Bar","Bar3D","Bar3DObj","BarStaked","BarStaked3DObj","Col","Col3D","Col3DObj","ColStaked","ColStaked3DObj","Line","Pie","Scatter","Area3D","Line3D","Pie3D"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;dw_detail.object.graph.graphtype = index

ii_graph_index = index
end event

