$PBExportHeader$w_62029_d.srw
$PBExportComments$매장별 인기스타일판매분포
forward
global type w_62029_d from w_com010_d
end type
end forward

global type w_62029_d from w_com010_d
end type
global w_62029_d w_62029_d

type variables
datawindowchild idw_brand, idw_empno
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_empno
long il_rowcount

end variables

on w_62029_d.create
call super::create
end on

on w_62029_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_empno = dw_head.GetItemString(1, "empno")
il_rowcount = dw_head.GetItemNumber(1, "rowcount")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_empno, il_rowcount)
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

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

event ue_preview();il_rows = dw_print.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_empno, il_rowcount)
end event

type cb_close from w_com010_d`cb_close within w_62029_d
end type

type cb_delete from w_com010_d`cb_delete within w_62029_d
end type

type cb_insert from w_com010_d`cb_insert within w_62029_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62029_d
end type

type cb_update from w_com010_d`cb_update within w_62029_d
end type

type cb_print from w_com010_d`cb_print within w_62029_d
end type

type cb_preview from w_com010_d`cb_preview within w_62029_d
end type

type gb_button from w_com010_d`gb_button within w_62029_d
end type

type cb_excel from w_com010_d`cb_excel within w_62029_d
end type

type dw_head from w_com010_d`dw_head within w_62029_d
string dataobject = "d_62029_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(1)

//idw_empno.SetItem(1, "person_cd", '%')
//idw_empno.SetItem(1, "person_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_work_type, ls_person_id
CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
		idw_empno.InsertRow(0)


			
END CHOOSE


end event

type ln_1 from w_com010_d`ln_1 within w_62029_d
end type

type ln_2 from w_com010_d`ln_2 within w_62029_d
end type

type dw_body from w_com010_d`dw_body within w_62029_d
string dataobject = "d_62029_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_62029_d
string dataobject = "d_62029_d01"
end type

