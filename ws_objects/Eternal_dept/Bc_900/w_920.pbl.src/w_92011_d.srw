$PBExportHeader$w_92011_d.srw
$PBExportComments$결산원가자료현황
forward
global type w_92011_d from w_com010_d
end type
type dw_2 from u_dw within w_92011_d
end type
type dw_3 from u_dw within w_92011_d
end type
type dw_4 from u_dw within w_92011_d
end type
end forward

global type w_92011_d from w_com010_d
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
end type
global w_92011_d w_92011_d

type variables
string is_brand, is_yymm, is_year, is_season
datawindowchild	idw_brand, idw_year, idw_season
end variables

on w_92011_d.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.dw_4
end on

on w_92011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
end on

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_4, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)

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

is_yymm = dw_head.GetItemString(1, "yymm")

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if


is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or (is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
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

		il_rows = dw_body.retrieve(MidA(is_yymm,1,4), is_brand, is_year, is_season)		


//messagebox("", is_brand + '/' + mid(is_yymm,1,4) + '/' + is_year+ '/' +is_season )

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

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
   //      dw_head.Enabled = false
//         dw_body.Enabled = true
//         dw_body.SetFocus()
      else
         cb_print.enabled = false
      //   cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
 //     dw_body.Enabled = false
 //     dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_excel();
/*===========================================================================*/
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

event ue_preview();

This.Trigger Event ue_title ()

dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_d`cb_close within w_92011_d
end type

type cb_delete from w_com010_d`cb_delete within w_92011_d
end type

type cb_insert from w_com010_d`cb_insert within w_92011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_92011_d
end type

type cb_update from w_com010_d`cb_update within w_92011_d
end type

type cb_print from w_com010_d`cb_print within w_92011_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_92011_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_92011_d
end type

type cb_excel from w_com010_d`cb_excel within w_92011_d
end type

type dw_head from w_com010_d`dw_head within w_92011_d
integer width = 3863
integer height = 140
string dataobject = "d_92011_h01"
end type

event dw_head::constructor;call super::constructor;


This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.Setitem(1, "inter_cd", "%")
idw_brand.Setitem(1, "inter_cd1", "%")
idw_brand.Setitem(1, "inter_nm", "전체")



This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertrow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_cd1", "%")
idw_year.Setitem(1, "inter_nm", "전체")

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")
end event

type ln_1 from w_com010_d`ln_1 within w_92011_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_92011_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_92011_d
integer y = 348
integer width = 3566
integer height = 1652
string dataobject = "d_92011_d01"
end type

type dw_print from w_com010_d`dw_print within w_92011_d
string dataobject = "d_92007_r01"
end type

type dw_2 from u_dw within w_92011_d
integer x = 5
integer y = 348
integer width = 3589
integer height = 1692
integer taborder = 40
string dataobject = "d_92007_d02"
end type

type dw_3 from u_dw within w_92011_d
integer x = 5
integer y = 348
integer width = 3589
integer height = 1692
integer taborder = 40
string dataobject = "d_92007_d03"
end type

type dw_4 from u_dw within w_92011_d
integer x = 5
integer y = 348
integer width = 3589
integer height = 1692
integer taborder = 40
string dataobject = "d_92007_d04"
end type

