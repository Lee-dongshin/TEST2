$PBExportHeader$w_12007_e.srw
$PBExportComments$품번가격등록
forward
global type w_12007_e from w_com010_e
end type
type dw_db from datawindow within w_12007_e
end type
end forward

global type w_12007_e from w_com010_e
dw_db dw_db
end type
global w_12007_e w_12007_e

type variables
DataWindowChild idw_brand
String is_brand
end variables

on w_12007_e.create
int iCurrent
call super::create
this.dw_db=create dw_db
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_db
end on

on w_12007_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_db)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
long i, ll_row_count, ll_row, ll_tag_price, ll_curr_price, ll_find
datetime ld_datetime
string ls_find, ls_find1

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	
		ls_find  = dw_body.GetitemString(i,"style")
		ls_find1 = dw_body.GetitemString(i,"chno")		
		
		ll_tag_price  = dw_body.Getitemdecimal(i, "Tag_price") 
		ll_curr_price = dw_body.Getitemdecimal(i, "curr_price") 
		
		if ll_tag_price > 0 and ll_curr_price > 0 then			
	   	if ll_tag_price < ll_curr_price  then			
			 goto NextStep	
			end if		
		else
    		 goto NextStep	
	   end if
	
			ll_find = dw_db.retrieve(ls_find, ls_find1)
			IF ll_find > 0 THEN	
				dw_db.Setitem(ll_find, "style", 		dw_body.GetitemString(i, "style"))
				dw_db.Setitem(ll_find, "chno", 		dw_body.GetitemString(i, "chno"))				
				dw_db.Setitem(ll_find, "Tag_price", dw_body.Getitemdecimal(i, "Tag_price"))
				dw_db.Setitem(ll_find, "curr_price",dw_body.Getitemdecimal(i, "curr_price"))
				dw_db.Setitem(ll_find, "mod_id", gs_user_id)
				dw_db.Setitem(ll_find, "mod_dt", ld_datetime)
			ELSE
				 if ll_tag_price > 0 and ll_curr_price > 0 then	
					ll_find = dw_db.InsertRow(0)
					dw_db.Setitem(ll_find, "style", 		dw_body.GetitemString(i, "style"))
					dw_db.Setitem(ll_find, "chno", 		dw_body.GetitemString(i, "chno"))					
					dw_db.Setitem(ll_find, "Tag_price", dw_body.Getitemdecimal(i, "Tag_price"))
					dw_db.Setitem(ll_find, "curr_price",dw_body.Getitemdecimal(i, "curr_price"))	
					dw_db.Setitem(ll_find, "reg_id", gs_user_id)		
				 end if	
			END IF
			
			il_rows = dw_db.Update(TRUE, FALSE)
			if il_rows = 1 then
				dw_db.ResetUpdate()
				commit  USING SQLCA;
			else
				rollback  USING SQLCA;
			end if
			NextStep:
NEXT

dw_body.Update(TRUE, FALSE)
dw_body.ResetUpdate()

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;dw_db.SetTransObject(SQLCA)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif  ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


return true
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12007_e","0")
end event

type cb_close from w_com010_e`cb_close within w_12007_e
end type

type cb_delete from w_com010_e`cb_delete within w_12007_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_12007_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_12007_e
end type

type cb_update from w_com010_e`cb_update within w_12007_e
end type

type cb_print from w_com010_e`cb_print within w_12007_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_12007_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_12007_e
end type

type cb_excel from w_com010_e`cb_excel within w_12007_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_12007_e
integer y = 164
integer width = 1486
integer height = 128
string dataobject = "d_12007_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001', gs_lang)
end event

type ln_1 from w_com010_e`ln_1 within w_12007_e
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_e`ln_2 within w_12007_e
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_e`dw_body within w_12007_e
integer y = 320
integer height = 1724
string dataobject = "d_12007_d01"
end type

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

type dw_print from w_com010_e`dw_print within w_12007_e
integer x = 1810
integer y = 520
end type

type dw_db from datawindow within w_12007_e
boolean visible = false
integer x = 3063
integer y = 556
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12007_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

