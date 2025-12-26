$PBExportHeader$w_cu132_d.srw
$PBExportComments$시험분석조회
forward
global type w_cu132_d from w_com020_d
end type
type dw_1 from datawindow within w_cu132_d
end type
end forward

global type w_cu132_d from w_com020_d
integer width = 3653
integer height = 2236
dw_1 dw_1
end type
global w_cu132_d w_cu132_d

type variables
string is_brand, is_mat_cd, is_color
datawindowchild idw_brand, idw_make_item, idw_country_cd

end variables

on w_cu132_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_cu132_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
int li_seq
This.Trigger Event ue_title ()

li_seq = dw_1.getitemnumber(1,'seq')
il_rows = dw_print.retrieve(is_mat_cd,li_seq )
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_mat_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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

is_mat_cd = dw_head.GetItemString(1, "mat_cd")

return true

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
			dw_1.Enabled    = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
		dw_1.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE
cb_retrieve.enabled = true
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com020_d`cb_close within w_cu132_d
end type

type cb_delete from w_com020_d`cb_delete within w_cu132_d
end type

type cb_insert from w_com020_d`cb_insert within w_cu132_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_cu132_d
end type

type cb_update from w_com020_d`cb_update within w_cu132_d
end type

type cb_print from w_com020_d`cb_print within w_cu132_d
end type

type cb_preview from w_com020_d`cb_preview within w_cu132_d
end type

type gb_button from w_com020_d`gb_button within w_cu132_d
integer width = 3598
end type

type dw_head from w_com020_d`dw_head within w_cu132_d
integer y = 160
integer width = 3598
integer height = 80
string dataobject = "d_kola_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')



end event

type ln_1 from w_com020_d`ln_1 within w_cu132_d
integer beginy = 252
integer endx = 3598
integer endy = 252
end type

type ln_2 from w_com020_d`ln_2 within w_cu132_d
integer beginy = 256
integer endx = 3598
integer endy = 256
end type

type dw_list from w_com020_d`dw_list within w_cu132_d
integer y = 628
integer width = 347
integer height = 1416
string dataobject = "d_kola_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
int li_seq, li_price
string ls_date
datetime ld_datetime
IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)

is_mat_cd = This.GetItemString(row, 'mat_cd') /* DataWindow에 Key 항목을 가져온다 */
//li_seq    = This.GetItemNumber(row, 'seq') /* DataWindow에 Key 항목을 가져온다 */
select max(seq) into :li_seq 
from tb_kola_m (nolock) where mat_cd = :is_mat_cd;

IF IsNull(is_mat_cd) THEN return
il_rows = dw_1.retrieve(is_mat_cd, li_seq)
if il_rows > 0 then
	ls_date = dw_1.getitemstring(1, "end_ymd")
	if ls_date = '' or isnull(ls_date) then 
		IF gf_cdate(ld_datetime,0)  THEN  
			dw_1.setitem(1,"end_ymd",string(ld_datetime,"yyyymmdd"))
		end if
	end if
	
	li_price = dw_1.GetitemNumber(1, "price")
	if li_price = 0 or isnull(li_price) then 		
		dw_1.setitem(1,"price", 28000)
	end if
	
	il_rows = dw_body.retrieve(is_mat_cd,li_seq)
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_cu132_d
integer x = 370
integer y = 628
integer width = 3232
integer height = 1416
string dataobject = "d_kola_d02"
end type

event dw_body::constructor;call super::constructor;string ls_null
setnull(ls_null)

This.GetChild("mat_nm1_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


This.GetChild("mat_nm2_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm7_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm8_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
This.GetChild("mat_nm1_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm7_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm8_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
This.GetChild("mat_nm1_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


This.GetChild("mat_nm7_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


This.GetChild("mat_nm8_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
This.GetChild("mat_nm1_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


This.GetChild("mat_nm4_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm7_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm8_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

end event

type st_1 from w_com020_d`st_1 within w_cu132_d
integer x = 352
integer y = 632
integer height = 1428
end type

type dw_print from w_com020_d`dw_print within w_cu132_d
integer x = 238
integer y = 704
string dataobject = "d_kola_r00"
end type

type dw_1 from datawindow within w_cu132_d
event type long key_down ( keycode key,  unsignedlong keyflags )
integer y = 260
integer width = 3598
integer height = 372
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_kola_d01"
boolean controlmenu = true
boolean hscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event type long key_down(keycode key, unsignedlong keyflags);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0
end event

event constructor;This.GetChild("make_item1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve()

This.GetChild("make_item1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve()

This.GetChild("make_item1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve()

end event

