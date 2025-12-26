$PBExportHeader$w_62012_d.srw
$PBExportComments$코디판매 인기순위
forward
global type w_62012_d from w_com020_d
end type
type p_1 from picture within w_62012_d
end type
type p_2 from picture within w_62012_d
end type
type cbx_1 from checkbox within w_62012_d
end type
type cbx_2 from checkbox within w_62012_d
end type
end forward

global type w_62012_d from w_com020_d
integer width = 3648
integer height = 2228
p_1 p_1
p_2 p_2
cbx_1 cbx_1
cbx_2 cbx_2
end type
global w_62012_d w_62012_d

type variables
string is_brand, is_year, is_season, is_style, is_srt_yymmdd, is_end_yymmdd, is_sojae, is_item
decimal is_buy_pcs
datawindowchild idw_season, idw_brand, idw_sojae, idw_item



end variables

on w_62012_d.create
int iCurrent
call super::create
this.p_1=create p_1
this.p_2=create p_2
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.cbx_2
end on

on w_62012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.cbx_1)
destroy(this.cbx_2)
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

is_brand      = dw_head.GetItemString(1, "brand")
is_year       = dw_head.GetItemString(1, "year")
is_season     = dw_head.GetItemString(1, "season")
is_sojae      = dw_head.GetItemString(1, "sojae")
is_item      = dw_head.GetItemString(1, "item")
is_style      = dw_head.GetItemString(1, "style")
is_srt_yymmdd = dw_head.GetItemString(1, "srt_yymmdd")
is_end_yymmdd = dw_head.GetItemString(1, "end_yymmdd")
is_buy_pcs    = dw_head.GetItemnumber(1, "buy_pcs")



if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
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

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_style, is_srt_yymmdd, is_end_yymmdd, is_buy_pcs, is_sojae, is_item)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm ,ls_mat_nm
Boolean    lb_check 
DataStore  lds_Source


is_brand = dw_head.getitemstring(1,"brand")

CHOOSE CASE as_column
	case "style"
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				END IF 
			END IF	
	
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "제품 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "Where brand     = '" + is_brand + "' " 
	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " style like '%" + as_data +"%'"
			ELSE
				gst_cd.Item_where = ""
			END IF
	
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)
	
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
//				dw_head.SetItem(al_row, "chno" , lds_Source.GetItemString(1,"chno"))
	
				/* 다음컬럼으로 이동 */
				dw_head.scrolltorow(1)
				dw_head.SetColumn("buy_pcs")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source	
						
	
	END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0




end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime
inv_resize.of_Register(p_1, "FixedToRight")
inv_resize.of_Register(p_2, "FixedToRight")

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"srt_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"end_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

if gs_dept_cd = '9000' or gs_dept_cd = 'I100' then 
	cbx_1.visible = true
	cbx_2.visible = true
else 
	cbx_1.visible = false
	cbx_2.visible = false
end if
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62012_d","0")
end event

event ue_excel();/*===========================================================================*/
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
li_ret = dw_list.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
string ls_style_up, ls_style_dn

ls_style_up = dw_body.getitemstring(1,"style_up")
ls_style_dn = dw_body.getitemstring(1,"style_dn")

This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_style, is_srt_yymmdd, is_end_yymmdd, is_buy_pcs, is_sojae, is_item, ls_style_up, ls_style_dn)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
string ls_style_up, ls_style_dn
This.Trigger Event ue_title()



ls_style_up = dw_body.getitemstring(1,"style_up")
ls_style_dn = dw_body.getitemstring(1,"style_dn")

il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_style, is_srt_yymmdd, is_end_yymmdd, is_buy_pcs, is_sojae, is_item, ls_style_up, ls_style_dn)


IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF



This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

//datetime ld_datetime
//string ls_modify, ls_datetime
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//             "t_user_id.Text = '" + gs_user_id + "'" + &
//             "t_datetime.Text = '" + ls_datetime + "'"
//
//dw_print.Modify(ls_modify)
//


dw_print.object.t_brand.text = '브랜드: '+is_brand
dw_print.object.t_season.text ='시즌: '+ is_year+' '+ is_season
dw_print.object.t_yymmdd.text ='판매기간: '+ is_srt_yymmdd + '-'+is_end_yymmdd


end event

type cb_close from w_com020_d`cb_close within w_62012_d
end type

type cb_delete from w_com020_d`cb_delete within w_62012_d
end type

type cb_insert from w_com020_d`cb_insert within w_62012_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_62012_d
end type

type cb_update from w_com020_d`cb_update within w_62012_d
end type

type cb_print from w_com020_d`cb_print within w_62012_d
end type

type cb_preview from w_com020_d`cb_preview within w_62012_d
end type

type gb_button from w_com020_d`gb_button within w_62012_d
end type

type cb_excel from w_com020_d`cb_excel within w_62012_d
end type

type dw_head from w_com020_d`dw_head within w_62012_d
integer y = 160
integer height = 268
string dataobject = "d_62012_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', gs_brand, '%')
ldw_child.insertrow(1)
ldw_child.setitem(1,"inter_cd","%")
ldw_child.setitem(1,"inter_nm","전체")

this.getchild("sojae",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('%', gs_brand)
ldw_child.insertrow(1)
ldw_child.setitem(1,"inter_cd","%")
ldw_child.setitem(1,"inter_nm","전체")

this.getchild("item",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve(gs_brand)
ldw_child.insertrow(1)
ldw_child.setitem(1,"inter_cd","%")
ldw_child.setitem(1,"inter_nm","전체")



end event

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")

		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
	
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		
				
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		 				


	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_62012_d
end type

type ln_2 from w_com020_d`ln_2 within w_62012_d
end type

type dw_list from w_com020_d`dw_list within w_62012_d
integer x = 9
integer width = 1216
string dataobject = "d_62012_l01"
end type

event dw_list::doubleclicked;call super::doubleclicked;//
//string ls_style, ls_style_codi, ls_pic_dir
//string ls_style_up_pic, ls_style_dn_pic
//
//IF row <= 0 THEN Return
//
//ls_style      = this.getitemstring(row,"style")
//ls_style_codi = this.getitemstring(row,"style_codi")
//
//IF IsNull(ls_style) or IsNull(ls_style_codi) THEN return
//il_rows = dw_body.retrieve(is_srt_yymmdd, is_end_yymmdd, ls_style, ls_style_codi)
//
//
//if il_rows >0 then 
//	ls_style_up_pic = dw_body.getitemstring(1,"style_up_pic")
//	ls_style_dn_pic = dw_body.getitemstring(1,"style_dn_pic")
//	parent.p_1.picturename = ls_style_up_pic
//	parent.p_1.visible = true
//	parent.p_2.picturename = ls_style_dn_pic
//	parent.p_2.visible = true
//end if
//
//
//Parent.Trigger Event ue_button(7, il_rows)
//Parent.Trigger Event ue_msg(1, il_rows)
//
//
end event

event dw_list::clicked;call super::clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)


string ls_style, ls_style_codi, ls_pic_dir
string ls_style_up_pic, ls_style_dn_pic

IF row <= 0 THEN Return

ls_style      = this.getitemstring(row,"style")
ls_style_codi = this.getitemstring(row,"style_codi")

IF IsNull(ls_style) or IsNull(ls_style_codi) THEN return
il_rows = dw_body.retrieve(is_srt_yymmdd, is_end_yymmdd, ls_style, ls_style_codi)


if il_rows >0 then 
	ls_style_up_pic = dw_body.getitemstring(1,"style_up_pic")
	ls_style_dn_pic = dw_body.getitemstring(1,"style_dn_pic")
	parent.p_1.picturename = ls_style_up_pic
	parent.p_1.visible = true
	parent.p_2.picturename = ls_style_dn_pic
	parent.p_2.visible = true
end if


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)


end event

type dw_body from w_com020_d`dw_body within w_62012_d
event ue_pic_view ( string as_style )
integer x = 1253
integer width = 2350
string dataobject = "d_62012_d01"
end type

event dw_body::ue_pic_view(string as_style);//if len(as_style) >= 8 then gf_style_pic(as_style,'%')

select dbo.SF_PIC_DIR('0',:as_style) 
	into :as_style
from dual;
parent.p_2.picturename = as_style
parent.p_2.visible = true


end event

event dw_body::buttonclicked;call super::buttonclicked;//string ls_pic_dir
//
//if dwo.name = "b_pic" then
//	ls_pic_dir = this.getitemstring(1,"style_pic")
//	if isnull(ls_pic_dir) then
//		p_1.visible = false
//	else 
//		p_1.visible = true
//		p_1.picturename = ls_pic_dir
//	end if
//end if
//
end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event dw_body::clicked;String 	ls_style_up_pic, ls_style_dn_pic

if row >0 then 
	ls_style_up_pic = dw_body.getitemstring(row,"style_up_pic")
	ls_style_dn_pic = dw_body.getitemstring(row,"style_dn_pic")
	parent.p_1.picturename = ls_style_up_pic
	parent.p_1.visible = true
	parent.p_2.picturename = ls_style_dn_pic
	parent.p_2.visible = true
end if

//ls_style 	= this.GetItemString(row,'style_codi')
//post event ue_pic_view(ls_style)
end event

event dw_body::doubleclicked;call super::doubleclicked;//String 	ls_search, ls_name
//if row > 0 then 
//	ls_name=dwo.name
//	choose case ls_name
//		case 'color_up','color_up_nm'
//			ls_search 	= this.GetItemString(row,"style_up")
//			if len(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')
//		case 'color_dn','color_dn_nm'
//			ls_search 	= this.GetItemString(row,"style_dn")
//			if len(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')
//
//	end choose	
//end if
end event

type st_1 from w_com020_d`st_1 within w_62012_d
integer x = 1234
end type

type dw_print from w_com020_d`dw_print within w_62012_d
string dataobject = "d_62012_r01"
end type

type p_1 from picture within w_62012_d
integer x = 2482
integer y = 484
integer width = 1111
integer height = 976
boolean bringtotop = true
boolean focusrectangle = false
end type

event doubleclicked;String 	ls_search, ls_name

		ls_search 	= dw_body.GetItemString(1,"style_up")
		if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')

end event

type p_2 from picture within w_62012_d
integer x = 2487
integer y = 1480
integer width = 1111
integer height = 976
boolean bringtotop = true
boolean focusrectangle = false
end type

event doubleclicked;String 	ls_search, ls_name

		ls_search 	= dw_body.GetItemString(1,"style_dn")
		if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')
end event

type cbx_1 from checkbox within w_62012_d
boolean visible = false
integer x = 2629
integer y = 316
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
string text = "한국"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if cbx_1.checked = true then
	cbx_2.checked = false
	dw_list.dataobject = 'd_62012_l01'
	dw_body.dataobject = 'd_62012_d01'
	dw_print.dataobject = 'd_62012_r00'
   dw_list.SetTransObject(SQLCA)
   dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
end if
	

end event

type cbx_2 from checkbox within w_62012_d
boolean visible = false
integer x = 2875
integer y = 316
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
string text = "중국"
borderstyle borderstyle = stylelowered!
end type

event clicked;if cbx_2.checked = true then
	cbx_1.checked = false
	dw_list.dataobject = 'd_62012_l02'
	dw_body.dataobject = 'd_62012_d02'
	dw_print.dataobject = 'd_62012_r01'
	dw_list.SetTransObject(SQLCA)	
	dw_body.SetTransObject(SQLCA)	
	dw_print.SetTransObject(SQLCA)
end if
	

end event

