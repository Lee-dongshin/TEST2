$PBExportHeader$w_61001_d.srw
$PBExportComments$판매현황조회
forward
global type w_61001_d from w_com010_d
end type
type dw_1 from datawindow within w_61001_d
end type
type dw_2 from datawindow within w_61001_d
end type
end forward

global type w_61001_d from w_com010_d
integer width = 3689
integer height = 2276
string title = "판매현황조회"
long backcolor = 80269524
dw_1 dw_1
dw_2 dw_2
end type
global w_61001_d w_61001_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String 				is_brand,is_sale_ymd,is_gubun, is_dotcom
DataWindowChild	idw_brand
end variables

on w_61001_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
end on

on w_61001_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "sale_ymd", String(ld_datetime,'yyyymmdd'))

//Timer(600)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
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

is_sale_ymd = dw_head.GetItemString(1, "sale_ymd")
if IsNull(is_sale_ymd) OR is_sale_ymd = "" then
   MessageBox(ls_title,"조회일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_ymd")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
is_gubun = dw_head.GetItemString(1, "gubun")
is_dotcom = dw_head.GetItemString(1, "dotcom")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
string ls_style
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_sale_ymd,is_gubun, is_dotcom)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

ls_style = dw_body.getitemstring(1,"shop_cd")
if LenA(ls_style) = 8 then
	dw_body.object.shop_nm.width = 247
else
	dw_body.object.shop_nm.width = 439	
end if

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일) 												  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
dw_1.SetTransObject(SQLCA)
inv_resize.of_Register(dw_1, "FixedToRight&ScaleToBottom")

dw_2.SetTransObject(SQLCA)
inv_resize.of_Register(dw_2, "FixedToRight&ScaleToBottom")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
CHOOSE CASE as_column
	CASE "close_detail"
			dw_1.Visible = False
	CASE "close_detail1"
			dw_2.Visible = False
END CHOOSE

RETURN 0

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy-mm-dd hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event timer;call super::timer;//dw_body.SetRedRaw(FALSE)
//dw_body.Retrieve(is_brand,is_sale_ymd,is_gubun)
//dw_body.SetRedRaw(True)
//
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61001_d","0")



end event

type cb_close from w_com010_d`cb_close within w_61001_d
end type

type cb_delete from w_com010_d`cb_delete within w_61001_d
end type

type cb_insert from w_com010_d`cb_insert within w_61001_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61001_d
end type

type cb_update from w_com010_d`cb_update within w_61001_d
end type

type cb_print from w_com010_d`cb_print within w_61001_d
end type

type cb_preview from w_com010_d`cb_preview within w_61001_d
end type

type gb_button from w_com010_d`gb_button within w_61001_d
end type

type cb_excel from w_com010_d`cb_excel within w_61001_d
end type

type dw_head from w_com010_d`dw_head within w_61001_d
integer x = 23
integer y = 136
integer width = 3561
integer height = 212
string dataobject = "d_61001_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.InsertRow(6)
idw_brand.SetItem(6,'inter_cd','X')
idw_brand.SetItem(6,'inter_nm','Joy-B품번')
//
end event

type ln_1 from w_com010_d`ln_1 within w_61001_d
integer beginx = 14
integer beginy = 360
integer endx = 3634
integer endy = 360
end type

type ln_2 from w_com010_d`ln_2 within w_61001_d
integer beginx = 27
integer beginy = 364
integer endx = 3648
integer endy = 364
end type

type dw_body from w_com010_d`dw_body within w_61001_d
integer x = 9
integer y = 384
integer width = 3598
integer height = 1660
string dataobject = "d_61001_d01"
boolean hsplitscroll = true
end type

event dw_body::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
//String 	ls_search
//if dwo.name = "b_3" then
//	ls_search 	= this.GetItemString(row,'shop_cd')
//	if len(ls_search) >= 8 then gf_style_color_pic(ls_search,'%', '%')
//end if
//

///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
long ll_row
if row > 0 then 
	choose case dwo.name
		case "b_3"
			ls_search 	= this.GetItemString(row,'shop_cd')
			if LenA(ls_search) >= 8 then  				gf_style_color_size_pic(ls_search, '%','%','0','K')			
		case "shop_cd" , "shop_nm"
			ls_search 	= this.GetItemString(row,'shop_cd')
			if LenA(ls_search) >= 6 and is_gubun = "1" then 
				ll_row = dw_2.retrieve(is_brand,is_sale_ymd, ls_search, is_dotcom)
				if ll_row <> 0 then dw_2.visible = true
			else 	
				dw_2.visible = false
			end if	
			
	end choose	
end if

end event

event dw_body::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String 	ls_search

IF row > 0 and is_brand <> "X" THEN
	dw_1.Visible = True
	ls_search 	= this.GetItemString(row,'shop_cd')
	dw_1.Retrieve(is_sale_ymd,ls_search,is_gubun,is_dotcom)

ELSE
	return
END IF

this.selectRow(0, false);
this.setRow(row);
this.selectRow(row, true);
end event

type dw_print from w_com010_d`dw_print within w_61001_d
integer x = 46
integer y = 188
integer width = 1152
integer height = 452
string dataobject = "d_61001_r01"
end type

type dw_1 from datawindow within w_61001_d
boolean visible = false
integer x = 1627
integer y = 568
integer width = 1915
integer height = 1408
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "상세내역"
string dataobject = "d_61001_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                   */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event clicked;String 	ls_search
if row > 0 then 
	choose case dwo.name
		case "m2"
			ls_search 	= this.GetItemString(row,'m2')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			
	end choose	
end if
end event

type dw_2 from datawindow within w_61001_d
boolean visible = false
integer x = 50
integer y = 384
integer width = 3547
integer height = 1588
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "일자별 매출"
string dataobject = "d_61001_d11"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

