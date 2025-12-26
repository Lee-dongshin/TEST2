$PBExportHeader$w_sm101_d.srw
$PBExportComments$부자재 발주현황
forward
global type w_sm101_d from w_com010_e
end type
type cb_excel from commandbutton within w_sm101_d
end type
end forward

global type w_sm101_d from w_com010_e
integer width = 3301
cb_excel cb_excel
end type
global w_sm101_d w_sm101_d

type variables
string is_fr_yymmdd, is_to_yymmdd, is_brand
datawindowchild	idw_brand
end variables

on w_sm101_d.create
int iCurrent
call super::create
this.cb_excel=create cb_excel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_excel
end on

on w_sm101_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_excel)
end on

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

inv_resize.of_Register(cb_excel, "FixedToRight")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_brand = dw_head.GetItemString(1, "brand")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd, '%',is_fr_yymmdd, is_to_yymmdd, is_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	cb_excel.enabled = true
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_sm101_d
end type

type cb_delete from w_com010_e`cb_delete within w_sm101_d
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sm101_d
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sm101_d
end type

type cb_update from w_com010_e`cb_update within w_sm101_d
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_sm101_d
end type

type cb_preview from w_com010_e`cb_preview within w_sm101_d
end type

type gb_button from w_com010_e`gb_button within w_sm101_d
integer width = 3241
end type

type dw_head from w_com010_e`dw_head within w_sm101_d
integer width = 3209
integer height = 172
string dataobject = "d_sm101_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_e`ln_1 within w_sm101_d
integer beginy = 356
integer endx = 3237
integer endy = 356
end type

type ln_2 from w_com010_e`ln_2 within w_sm101_d
integer beginy = 360
integer endx = 3237
integer endy = 360
end type

type dw_body from w_com010_e`dw_body within w_sm101_d
integer y = 376
integer width = 3250
integer height = 1464
string dataobject = "d_sm101_d01"
end type

type dw_print from w_com010_e`dw_print within w_sm101_d
string dataobject = "d_sm101_r01"
end type

type cb_excel from commandbutton within w_sm101_d
integer x = 2917
integer y = 44
integer width = 265
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "엑셀"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

