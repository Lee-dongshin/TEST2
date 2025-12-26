$PBExportHeader$w_sm100_e.srw
$PBExportComments$부자재 발주확인
forward
global type w_sm100_e from w_com010_e
end type
type cb_excel from commandbutton within w_sm100_e
end type
type dw_1 from datawindow within w_sm100_e
end type
end forward

global type w_sm100_e from w_com010_e
integer width = 3323
event ue_songjang ( )
cb_excel cb_excel
dw_1 dw_1
end type
global w_sm100_e w_sm100_e

type variables
string is_fr_yymmdd, is_to_yymmdd, is_brand
datawindowchild idw_brand

end variables

event ue_songjang();string ls_songjang

dw_print.dataobject = "d_sm100_r04"
dw_print.SetTransObject(SQLCA)

/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

//This.Trigger Event ue_title ()
IF dw_1.AcceptText() <> 1 THEN RETURN

ls_songjang = dw_1.getitemstring(1,"in_ymd")
if isnull(ls_songjang) or LenA(ls_songjang) <> 8 then 
	messagebox("확인","입고일자를 입력하세요..")
	dw_1.setfocus()
	dw_1.setcolumn("in_ymd")
end if

//messagebox("",gs_user_id)
//messagebox("", ls_songjang)

dw_print.retrieve(is_brand,gs_user_id, ls_songjang)
dw_print.inv_printpreview.of_SetZoom()


end event

on w_sm100_e.create
int iCurrent
call super::create
this.cb_excel=create cb_excel
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_excel
this.Control[iCurrent+2]=this.dw_1
end on

on w_sm100_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_excel)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


inv_resize.of_Register(cb_excel, "FixedToRight")

dw_1.insertrow(0)
dw_1.setitem(1,"in_ymd",string(ld_datetime,"yyyymmdd"))

//post event ue_retrieve()


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
is_brand     = dw_head.GetItemString(1, "brand")

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
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_cust_dlvy, ls_dlvy_ymd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */		
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ls_cust_dlvy = dw_body.getitemstring(i,"cust_dlvy")
		ls_dlvy_ymd = dw_body.getitemstring(i,"dlvy_ymd")
//		if len(ls_cust_dlvy) = 8 then 
//			if isnull(ls_dlvy_ymd) or len(ls_dlvy_ymd) <> 8 then
//				dw_body.setitem(i,"dlvy_ymd",ls_cust_dlvy)
//			end if
//		end if
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_print();string ls_brand, ls_ord_ymd, ls_ord_no
dw_print.dataobject = "d_sm100_r02"
dw_print.SetTransObject(SQLCA)


This.Trigger Event ue_title ()
ls_brand   = dw_body.getitemstring(dw_body.getrow(),"brand")
ls_ord_ymd = dw_body.GetItemstring(dw_body.getrow(), "ord_ymd")
ls_ord_no   = dw_body.getitemstring(dw_body.getrow(),"ord_no")

dw_print.retrieve(ls_brand, ls_ord_ymd, ls_ord_no)
dw_print.inv_printpreview.of_SetZoom()
end event

event ue_preview();dw_print.dataobject = "d_sm100_r01"
dw_print.SetTransObject(SQLCA)

/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
			cb_excel.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
			cb_excel.enabled = false
         cb_preview.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = false
			cb_print.enabled = false
			cb_excel.enabled = false
			cb_preview.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_excel.enabled = true
			cb_delete.enabled = true
			cb_preview.enabled = true
		end if



   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
		cb_excel.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_sm100_e
integer taborder = 90
end type

type cb_delete from w_com010_e`cb_delete within w_sm100_e
integer x = 955
string text = "송장출력"
end type

event cb_delete::clicked;
dw_1.visible = true
dw_1.setfocus()
dw_1.setcolumn("in_ymd")

end event

type cb_insert from w_com010_e`cb_insert within w_sm100_e
boolean visible = false
integer x = 613
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sm100_e
end type

type cb_update from w_com010_e`cb_update within w_sm100_e
integer taborder = 80
end type

type cb_print from w_com010_e`cb_print within w_sm100_e
integer x = 1307
integer width = 466
string text = "발주서 인쇄(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_sm100_e
end type

type gb_button from w_com010_e`gb_button within w_sm100_e
integer width = 3269
end type

type dw_head from w_com010_e`dw_head within w_sm100_e
integer width = 3223
integer height = 156
string dataobject = "d_sm100_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_e`ln_1 within w_sm100_e
integer beginy = 356
integer endx = 3241
integer endy = 356
end type

type ln_2 from w_com010_e`ln_2 within w_sm100_e
integer beginy = 360
integer endx = 3241
integer endy = 360
end type

type dw_body from w_com010_e`dw_body within w_sm100_e
integer y = 400
integer width = 3264
integer height = 1464
string dataobject = "d_sm100_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)
end event

type dw_print from w_com010_e`dw_print within w_sm100_e
string dataobject = "d_sm100_r02"
end type

type cb_excel from commandbutton within w_sm100_e
integer x = 2926
integer y = 44
integer width = 311
integer height = 88
integer taborder = 100
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

type dw_1 from datawindow within w_sm100_e
boolean visible = false
integer x = 1211
integer y = 152
integer width = 1111
integer height = 456
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "송장출력"
string dataobject = "d_sm100_r05"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;Parent.Trigger Event ue_songjang()	//조회
end event

