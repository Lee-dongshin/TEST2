$PBExportHeader$w_21019_e.srw
$PBExportComments$케어,택추가발행의뢰
forward
global type w_21019_e from w_com010_e
end type
end forward

global type w_21019_e from w_com010_e
integer width = 3689
integer height = 2268
end type
global w_21019_e w_21019_e

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd
datawindowchild idw_brand, idw_color, idw_why, idw_size
end variables

on w_21019_e.create
call super::create
end on

on w_21019_e.destroy
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
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

		
	CASE "style"				
		   ls_style = MidA(as_data, 1, 8)
		
//			IF ai_div = 1 THEN 	
//				IF gf_style_chk(ls_style, ls_chno) THEN
//					RETURN 0
//				END IF 
//			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_body.SetItem(al_row, "chno" , lds_Source.GetItemString(1,"chno"))
				
				ls_style= lds_Source.GetItemString(1,"style")
				ls_chno = lds_Source.GetItemString(1,"chno")
				
				idw_color.Retrieve(ls_style, ls_chno)
				idw_size.Retrieve(ls_style, ls_chno,'%')
				/* 다음컬럼으로 이동 */
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

event ue_insert();call super::ue_insert;datetime ld_datetime



//idrg_Vertical2[1] = dw_mast
//idrg_Vertical2[2] = dw_asst

IF gf_cdate(ld_datetime,0)  THEN  
	dw_body.setitem(dw_body.rowcount(),"yymmdd",string(ld_datetime,"yyyymmdd"))

end if
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ld_qty
datetime ld_datetime

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

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
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

dw_print.object.t_yymmdd.text=is_fr_yymmdd + ' - ' + is_to_yymmdd
dw_print.object.t_brand.text=idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")

end event

event ue_preview();This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd)
dw_print.inv_printpreview.of_SetZoom()
end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row
string  ls_print_yn

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
ls_print_yn = dw_body.getitemstring(ll_cur_row,"print_yn")
if ls_print_yn = 'Y' then 
	messagebox("확인", "이미 발행된 내역은 삭제 할 수 없습니다..")
	return
end if
il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_21019_e
end type

type cb_delete from w_com010_e`cb_delete within w_21019_e
end type

type cb_insert from w_com010_e`cb_insert within w_21019_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21019_e
end type

type cb_update from w_com010_e`cb_update within w_21019_e
end type

type cb_print from w_com010_e`cb_print within w_21019_e
end type

type cb_preview from w_com010_e`cb_preview within w_21019_e
end type

type gb_button from w_com010_e`gb_button within w_21019_e
end type

type cb_excel from w_com010_e`cb_excel within w_21019_e
end type

type dw_head from w_com010_e`dw_head within w_21019_e
integer height = 140
string dataobject = "d_21019_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")
end event

type ln_1 from w_com010_e`ln_1 within w_21019_e
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_e`ln_2 within w_21019_e
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_e`dw_body within w_21019_e
integer y = 348
integer width = 3602
integer height = 1676
string dataobject = "d_21019_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "color"
//		this.setitem(row, "color_nm", idw_color.getitemstring(idw_color.getrow(),"color_enm"))

END CHOOSE

end event

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

This.GetChild("why", idw_why)
idw_why.SetTransObject(SQLCA)
idw_why.Retrieve('218')

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertrow(1)

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertrow(1)


This.GetChild("gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

ldw_child.setFilter( "tl_gbn in ('1','3','8','7','9','D','E','F','2','K','L','M','N','O','P','Q') " )
ldw_child.filter();




end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;string ls_style, ls_chno
if dwo.name="color" then 
	ls_style = this.getitemstring(row,"style")
	ls_chno  = this.getitemstring(row,"chno")	
	
	idw_color.Retrieve(ls_style, ls_chno)
end if
end event

type dw_print from w_com010_e`dw_print within w_21019_e
integer x = 41
integer y = 608
string dataobject = "d_21019_r01"
end type

