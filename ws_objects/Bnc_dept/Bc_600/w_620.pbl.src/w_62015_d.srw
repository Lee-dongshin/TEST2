$PBExportHeader$w_62015_d.srw
$PBExportComments$STYLE  LIFE CYCLE
forward
global type w_62015_d from w_com010_d
end type
type dw_m from datawindow within w_62015_d
end type
type dw_d from datawindow within w_62015_d
end type
end forward

global type w_62015_d from w_com010_d
integer width = 3694
integer height = 2268
dw_m dw_m
dw_d dw_d
end type
global w_62015_d w_62015_d

type variables
string is_brand, is_year, is_season, is_item, is_style, is_chno, is_amt_gubn , is_style_no

long il_p_rate

end variables

on w_62015_d.create
int iCurrent
call super::create
this.dw_m=create dw_m
this.dw_d=create dw_d
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_m
this.Control[iCurrent+2]=this.dw_d
end on

on w_62015_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_m)
destroy(this.dw_d)
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

is_year   = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도 를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if


is_item   = dw_head.GetItemString(1, "item")
//if IsNull(is_brand) or Trim(is_brand) = "" then
//   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//end if


is_style  = dw_head.GetItemString(1, "style")
is_chno   = dw_head.GetItemString(1, "chno")
is_amt_gubn   = dw_head.GetItemString(1, "amt_gubn")
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

string labels


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_d.reset()
dw_d.insertrow(1)
il_rows = dw_m.retrieve(is_brand, is_year, is_season, is_item, is_amt_gubn, '0',-1, is_style)

//dw_body.SetRedraw(FALSE)
//il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_style, is_chno, is_amt_gubn)
IF il_rows > 0 THEN
	labels = string(dw_body.getitemnumber(1,"labels"))
//	dw_body.object.gr_1.category.displayeverynlabels= labels
	
//	dw_body.object.gr_1.title = "LIFE_CYCLE"
	
//   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF
dw_body.SetRedraw(TRUE)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0

CHOOSE CASE as_column
	CASE "style"				
			IF ai_div = 1 THEN
				if LenA(as_data) = 0 or isnull(as_data) then 
					return 0
				elseIF gf_style_chk(LeftA(as_data, 8), MidA(as_data, 9, 1)) = True THEN
					RETURN 0
				END IF 
			END IF
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = "where brand = '" + is_brand + "' and year = '" + is_year + "' and season like '" + is_season + "%'"  		//WHERE TB_11010_M.PART_FG IN ('1', '2', '3') 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
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
				dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("flag")
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


/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
//Boolean    lb_check 
//DataStore  lds_Source
//
//CHOOSE CASE as_column
//	
//			CASE "style"							// 거래처 코드
//				gst_cd.window_title    = "스타일 코드 검색" 
//				gst_cd.datawindow_nm   = "d_com010" 
//				gst_cd.default_where   = " WHERE 1 = 1 "
//				IF Trim(as_data) <> "" THEN
//					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
//				ELSE
//					gst_cd.Item_where = ""
//				END IF
//
//				lds_Source = Create DataStore
//				OpenWithParm(W_COM200, lds_Source)
//
//				IF Isvalid(Message.PowerObjectParm) THEN
//					ib_itemchanged = True
//					lds_Source = Message.PowerObjectParm
//
//					dw_head.SetRow(al_row)
//					dw_head.SetColumn(as_column)
//
//					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
//					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
//								
//					/* 다음컬럼으로 이동 */
////					dw_head.SetColumn("year")
//					ib_itemchanged = False
//				END IF
//				Destroy  lds_Source
//
//END CHOOSE
//
//IF ai_div = 1 THEN 
//	IF lb_check THEN
//      RETURN 2 
//	ELSE
//		RETURN 1
//	END IF
//END IF
//
//RETURN 0
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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
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
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"		
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE


end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(dw_m, "ScaleToBottom")
inv_resize.of_Register(dw_d, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_m.SetTransObject(SQLCA)
dw_d.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62015_d","0")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_item, is_style, is_chno, is_amt_gubn, '0', il_p_rate)
dw_print.inv_printpreview.of_SetZoom()

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

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text  = is_brand
dw_print.object.t_year.text   = is_year
dw_print.object.t_season.text = is_season
dw_print.object.t_item.text   = is_item
dw_print.object.t_style.text  = is_style

choose case  is_amt_gubn
	case '1' 
		is_amt_gubn = "정상.세일"
	case '2' 
		is_amt_gubn = "전체"
end choose

dw_print.object.t_amt_gubn.text = is_amt_gubn

end event

type cb_close from w_com010_d`cb_close within w_62015_d
end type

type cb_delete from w_com010_d`cb_delete within w_62015_d
end type

type cb_insert from w_com010_d`cb_insert within w_62015_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62015_d
end type

type cb_update from w_com010_d`cb_update within w_62015_d
end type

type cb_print from w_com010_d`cb_print within w_62015_d
end type

type cb_preview from w_com010_d`cb_preview within w_62015_d
end type

type gb_button from w_com010_d`gb_button within w_62015_d
end type

type cb_excel from w_com010_d`cb_excel within w_62015_d
end type

type dw_head from w_com010_d`dw_head within w_62015_d
integer width = 3749
integer height = 208
string dataobject = "d_62015_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild	idw_child

this.getchild("brand",idw_child)
idw_child.SetTransObject(SQLCA) 
idw_child.retrieve('001')

this.getchild("season",idw_child)
idw_child.SetTransObject(SQLCA) 
idw_child.retrieve('003', gs_brand, '%')
idw_child.insertrow(1)
idw_child.setitem(1,"inter_cd","%")
idw_child.setitem(1,"inter_nm","전체")

This.GetChild("item", idw_child)
idw_child.SetTRansObject(SQLCA)
idw_child.Retrieve(gs_brand)
idw_child.insertrow(1)
idw_child.Setitem(1, "item", "%")
idw_child.Setitem(1, "item_nm", "전체")
end event

event dw_head::itemchanged;call super::itemchanged;///*===========================================================================*/
///* 작성자      : (주)지우정보 ()                                      */	
///* 작성일      : 2001..                                                  */	
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//
//CHOOSE CASE dwo.name
//	CASE "style"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
//

string ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
		
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")		
				
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		 		
		
END CHOOSE
end event

event dw_head::editchanged;call super::editchanged;choose case dwo.name
	case "style"
		if LenA(data) = 1 then this.setitem(1,"brand",upper(data))
		if LenA(data) = 4 then this.setitem(1,"season",RightA(upper(data),1))
		if LenA(data) = 5 then this.setitem(1,"item",RightA(upper(data),1))
end choose
end event

type ln_1 from w_com010_d`ln_1 within w_62015_d
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_d`ln_2 within w_62015_d
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_d`dw_body within w_62015_d
integer x = 1975
integer y = 400
integer width = 1637
integer height = 1384
string dataobject = "d_62015_d01"
boolean vscrollbar = false
end type

type dw_print from w_com010_d`dw_print within w_62015_d
integer x = 32
integer y = 776
string dataobject = "d_62015_r00"
end type

type dw_m from datawindow within w_62015_d
integer x = 9
integer y = 404
integer width = 1975
integer height = 1612
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_62015_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
if row > 0 then	
	il_p_rate = dw_m.getitemnumber(row,"s_rate")
	is_amt_gubn = '1'
	il_rows = dw_d.retrieve(is_brand, is_year, is_season, is_item, is_amt_gubn, is_amt_gubn, il_p_rate, '%')
end if

end event

event doubleclicked;string ls_style

if row > 0 then
	ls_style = dw_m.getitemstring(row,string(dwo.name))
	gf_style_pic(ls_style,'%')	
end if

///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
//String 	ls_search
//if row > 0 then 
//	choose case mid(dwo.name,5)
//		case 'style'
//			ls_search 	= this.GetItemString(row,string(dwo.name))
//			if len(ls_search) >= 4 then gf_style_color_pic(ls_search, '%','%')			
//	end choose	
//end if

	
end event

type dw_d from datawindow within w_62015_d
integer x = 1984
integer y = 1780
integer width = 1627
integer height = 236
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_62015_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_style

if row > 0 then
	ls_style = dw_d.getitemstring(row,string(dwo.name))
	gf_style_pic(ls_style,'%')	
end if
	
end event

event clicked;


is_style = dw_d.getitemstring(row,string(dwo.name))

if row > 0 and LenA(is_style) > 0  and not isnull(is_style) then	

	dw_body.SetRedraw(FALSE)
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_style, '%', is_amt_gubn)
	
	
	is_style = is_style + ' - LIFE CYCLE'
	dw_body.object.gr_1.title = is_style
	
	dw_body.SetRedraw(TRUE)
end if

end event

