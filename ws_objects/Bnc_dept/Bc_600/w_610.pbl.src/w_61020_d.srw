$PBExportHeader$w_61020_d.srw
$PBExportComments$미사용-쇼핑몰판매현황
forward
global type w_61020_d from w_com010_d
end type
type rb_1 from radiobutton within w_61020_d
end type
type rb_2 from radiobutton within w_61020_d
end type
type rb_3 from radiobutton within w_61020_d
end type
type dw_1 from datawindow within w_61020_d
end type
type dw_2 from datawindow within w_61020_d
end type
end forward

global type w_61020_d from w_com010_d
integer width = 3675
integer height = 2276
string title = "일자별매출추이"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
dw_1 dw_1
dw_2 dw_2
end type
global w_61020_d w_61020_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
DataWindowChild	idw_brand
String 				is_brand, is_base_yymm, is_gubun , is_sw
Boolean lb_ret_chk1 = False, lb_ret_chk2 = False, lb_ret_chk3 = False

end variables

on w_61020_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_2
end on

on w_61020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "base_yymm", ld_datetime)
 
is_base_yymm = Trim(String(dw_head.GetItemDatetime(1, "base_yymm"), 'yyyymmdd'))

is_sw  = '1'

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
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


is_gubun	= Trim(dw_head.GetItemString(1, "gubun"))
if IsNull(is_gubun) OR is_gubun = "" then
   MessageBox(ls_title,"조회 기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
   return false
end if

is_base_yymm = Trim(String(dw_head.GetItemDatetime(1, "base_yymm"), 'yyyymmdd'))
if IsNull(is_base_yymm) OR is_base_yymm = "" then
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("base_yymm")
   return false
end if



return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



		DECLARE  SP_61020_D11 PROCEDURE FOR SP_61020_D11;
		EXECUTE SP_61020_D11;
	   il_rows  = dw_body.retrieve()
		

		DECLARE SP_61020_D13 PROCEDURE FOR SP_61020_D13 
				  @ps_yymm  = is_base_yymm ;
		EXECUTE SP_61020_D13;
		 il_rows  =  dw_1.retrieve(is_base_yymm)
		

		DECLARE SP_61020_D05 PROCEDURE FOR SP_61020_D05 
					@ps_gubun = is_gubun,
					@ps_yymm  = is_base_yymm ;
		EXECUTE SP_61020_D05 ;	
		 il_rows  =  dw_2.retrieve(is_gubun,is_base_yymm)

		 
// Choose Case is_sw
//	Case '1'	
//		DECLARE  SP_61020_D11 PROCEDURE FOR SP_61020_D11;
//		EXECUTE SP_61020_D11;
//	   dw_body.retrieve()
//		
//	Case '2'
//		DECLARE SP_61020_D13 PROCEDURE FOR SP_61020_D13 
//				  @ps_yymm  = is_base_yymm ;
//		EXECUTE SP_61020_D13;
//		dw_1.retrieve(is_base_yymm)
//		
//	Case '3'
//		DECLARE SP_61020_D05 PROCEDURE FOR SP_61020_D05 
//					@ps_gubun = is_gubun,
//					@ps_yymm  = is_base_yymm ;
//		EXECUTE SP_61020_D05 ;	
//		dw_2.retrieve(is_gubun,is_base_yymm)
//END Choose

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
//         dw_head.Enabled = false
//         dw_body.Enabled = true
//         tab_1.Enabled = true
//         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
//		dw_body.Enabled = false
//		tab_1.Enabled = false
//		lb_ret_chk1 = False
//		lb_ret_chk2 = False
//		lb_ret_chk3 = False
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_gubun

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_modify =	"t_pg_id.Text     = '" + is_pgm_id + "'" + &
//            "t_user_id.Text   = '" + gs_user_id + "'" + &
//            "t_datetime.Text  = '" + ls_datetime + "'" + &
//            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
//            "t_base_yymm.Text = '" + String(is_base_yymm, '@@@@/@@')+ "'" + &
//            "t_gubun.Text     = '" + ls_gubun + "'" + &
//            ls_modify
				
dw_print.Modify(ls_modify)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()


 Choose Case is_sw
	Case '1'	
		 dw_print.DataObject = 'd_61020_d01'
	    dw_print.SetTransObject(SQLCA)		 
		 dw_body.ShareData(dw_print)
	    dw_print.inv_printpreview.of_SetZoom()
		
	Case '2'
		 dw_print.DataObject = 'd_61020_d02'
	    dw_print.SetTransObject(SQLCA)		
		 dw_1.ShareData(dw_print)
		 dw_print.inv_printpreview.of_SetZoom()
		
	Case '3'
		 dw_print.DataObject = 'd_61020_d03'
	    dw_print.SetTransObject(SQLCA)		
		 dw_2.ShareData(dw_print)
		 dw_print.inv_printpreview.of_SetZoom()
END Choose

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()


 Choose Case is_sw
	Case '1'	
		 dw_print.DataObject = 'd_61020_d01'
	    dw_print.SetTransObject(SQLCA)		 
		 dw_body.ShareData(dw_print)
	   
		
	Case '2'
		 dw_print.DataObject = 'd_61020_d02'
	    dw_print.SetTransObject(SQLCA)		
		 dw_1.ShareData(dw_print)
		 
		
	Case '3'
		 dw_print.DataObject = 'd_61020_d03'
	    dw_print.SetTransObject(SQLCA)		
		 dw_2.ShareData(dw_print)
		 
END Choose


IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_body.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61020_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
end event

event ue_excel();string ls_doc_nm, ls_nm

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

if dw_body.visible = true then
	li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
elseif dw_1.visible = true then	
	li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)	
elseif dw_2.visible = true then	
	li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)		
end if	
	
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)
end event

type cb_close from w_com010_d`cb_close within w_61020_d
end type

type cb_delete from w_com010_d`cb_delete within w_61020_d
end type

type cb_insert from w_com010_d`cb_insert within w_61020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61020_d
end type

type cb_update from w_com010_d`cb_update within w_61020_d
end type

type cb_print from w_com010_d`cb_print within w_61020_d
end type

type cb_preview from w_com010_d`cb_preview within w_61020_d
end type

type gb_button from w_com010_d`gb_button within w_61020_d
end type

type cb_excel from w_com010_d`cb_excel within w_61020_d
end type

type dw_head from w_com010_d`dw_head within w_61020_d
integer y = 160
integer width = 1723
integer height = 176
string dataobject = "d_61020_h01"
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
//This.GetChild("brand", idw_brand)
//idw_brand.SetTransObject(SQLCA)
//idw_brand.Retrieve('001')
//
end event

event dw_head::itemchanged;call super::itemchanged;lb_ret_chk1 = False
lb_ret_chk2 = False
lb_ret_chk3 = False

end event

type ln_1 from w_com010_d`ln_1 within w_61020_d
integer beginx = 14
integer beginy = 352
integer endx = 3634
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_61020_d
integer beginx = 14
integer beginy = 356
integer endx = 3634
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_61020_d
integer y = 376
integer height = 1664
string dataobject = "d_61020_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_61020_d
string dataobject = "d_61020_d01"
end type

type rb_1 from radiobutton within w_61020_d
integer x = 1829
integer y = 232
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "요일별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_2.TextColor     = 0
rb_3.TextColor     = 0

is_sw = '1'

 dw_body.visible  = true
 dw_1.visible  = false
 dw_2.visible  = false
//
//dw_body.DataObject  = 'd_61020_d01'
//dw_print.DataObject = 'd_61020_d01'
//dw_body.SetTransObject(SQLCA)
//dw_print.SetTransObject(SQLCA)
//
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//
//DECLARE SP_61020_D11 PROCEDURE FOR SP_61020_D11 ;
//EXECUTE SP_61020_D11 ;
//dw_body.retrieve()
 
end event

type rb_2 from radiobutton within w_61020_d
integer x = 2263
integer y = 232
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "일/월/년계"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_3.TextColor     = 0

is_sw = '2'

 dw_body.visible  = false
 dw_1.visible  = true
 dw_2.visible  = false
dw_1.Modify("DataWindow.detail.Height=0")

//dw_body.DataObject  = 'd_61020_d02'
//dw_print.DataObject = 'd_61020_d02'
//dw_body.SetTransObject(SQLCA)
//dw_print.SetTransObject(SQLCA)


end event

type rb_3 from radiobutton within w_61020_d
integer x = 2725
integer y = 232
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "그래프(꺽은선)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0

is_sw = '3'

 dw_body.visible  = false
 dw_1.visible  = false
 dw_2.visible  = true

//dw_body.DataObject  = 'd_61020_d03'
//dw_print.DataObject = 'd_61020_d03'
//dw_body.SetTransObject(SQLCA)
//dw_print.SetTransObject(SQLCA)
//
//
//
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//DECLARE SP_61020_D05 PROCEDURE FOR SP_61020_D05 
//			@ps_gubun = is_gubun,
//			@ps_yymm  = is_base_yymm ;
//EXECUTE SP_61020_D05 ;
//
//dw_body.retrieve(is_gubun,is_base_yymm)
// 
end event

type dw_1 from datawindow within w_61020_d
integer x = 5
integer y = 376
integer width = 3589
integer height = 1664
integer taborder = 40
string title = "none"
string dataobject = "d_61020_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;integer li_height

li_height = dw_1.Object.DataWindow.Detail.Height

//messagebox("row", string(row,"0000"))

if row = 0 then
	dw_1.Modify("DataWindow.detail.Height=60")
else	
	dw_1.Modify("DataWindow.detail.Height=0")
end if	
end event

type dw_2 from datawindow within w_61020_d
integer x = 5
integer y = 376
integer width = 3589
integer height = 1664
integer taborder = 40
string title = "none"
string dataobject = "d_61020_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

