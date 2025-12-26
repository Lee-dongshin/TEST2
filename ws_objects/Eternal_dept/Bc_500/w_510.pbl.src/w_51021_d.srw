$PBExportHeader$w_51021_d.srw
$PBExportComments$담당매장별 고객매출현황
forward
global type w_51021_d from w_com010_d
end type
end forward

global type w_51021_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_51021_d w_51021_d

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_empno, is_sale_type
datawindowchild idw_brand, idw_empno

end variables

on w_51021_d.create
call super::create
end on

on w_51021_d.destroy
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_sale_type = dw_head.GetItemString(1, "sale_type")
is_empno = dw_head.GetItemString(1, "empno")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_sale_type, is_empno)
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

event ue_title;call super::ue_title;/*===========================================================================*/
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

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = '브랜드:'+ is_brand + '-'+idw_brand.getitemstring(idw_brand.getrow(),'inter_nm')
dw_print.object.t_yymmdd.text = '조회기간:'+ is_fr_yymmdd + '-' + is_to_yymmdd
choose case is_sale_type 
	case '%'
			dw_print.object.t_sale_type.text = '판매형태:전체'
	case '1'
			dw_print.object.t_sale_type.text = '판매형태:정상'		
	case '12'
			dw_print.object.t_sale_type.text = '판매형태:정상+세일'		
	case '^9'
			dw_print.object.t_sale_type.text = '판매형태:기타제외'		
end choose
dw_print.object.t_empno.text = '담당:'+ is_empno + '-'+idw_empno.getitemstring(idw_empno.getrow(),'person_nm')


end event

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymm")+"01")
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

end event

type cb_close from w_com010_d`cb_close within w_51021_d
end type

type cb_delete from w_com010_d`cb_delete within w_51021_d
end type

type cb_insert from w_com010_d`cb_insert within w_51021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51021_d
end type

type cb_update from w_com010_d`cb_update within w_51021_d
end type

type cb_print from w_com010_d`cb_print within w_51021_d
end type

type cb_preview from w_com010_d`cb_preview within w_51021_d
end type

type gb_button from w_com010_d`gb_button within w_51021_d
end type

type cb_excel from w_com010_d`cb_excel within w_51021_d
end type

type dw_head from w_com010_d`dw_head within w_51021_d
string dataobject = "d_51021_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(0)



end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.08                                                  */	
/* 수정일      : 2002.02.08                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
	//	return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
		idw_empno.InsertRow(0)
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_51021_d
end type

type ln_2 from w_com010_d`ln_2 within w_51021_d
end type

type dw_body from w_com010_d`dw_body within w_51021_d
string dataobject = "d_51021_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_51021_d
string dataobject = "d_51021_r01"
end type

