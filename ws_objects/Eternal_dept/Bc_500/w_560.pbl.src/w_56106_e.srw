$PBExportHeader$w_56106_e.srw
$PBExportComments$수수료 공제 관리
forward
global type w_56106_e from w_com010_e
end type
type st_1 from statictext within w_56106_e
end type
end forward

global type w_56106_e from w_com010_e
integer width = 3675
integer height = 2284
event ue_bill_chk ( )
st_1 st_1
end type
global w_56106_e w_56106_e

type variables
String is_brand, is_shop_div, is_comm_fg, is_yymm, is_ded_fg
DatawindowChild idw_comm_fg, idw_ded_fg
end variables

event ue_bill_chk();Long ll_cnt 

//Select count(bill_no)
//  into :ll_cnt 
//  from tb_56030_m 
// where yymm  = :is_yymm 
//   and brand = :is_brand 
//	and bill_no is not null;
//	
//IF ll_cnt > 0 THEN 
//	dw_body.Enabled = False
//	st_1.Text = "세금계산서가 발행 되여 수정할 수 없습니다."
//ELSE
//	dw_body.Enabled = True
//	st_1.Text = ""
//END IF
end event

on w_56106_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_56106_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event open;call super::open;dw_head.Setitem(1, "shop_div", "G")
dw_head.Setitem(1, "comm_fg", "%")

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.09                                                  */	
/* 수정일      : 2002.03.09                                                  */
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

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_comm_fg = dw_head.GetItemString(1, "comm_fg")
if IsNull(is_comm_fg) or Trim(is_comm_fg) = "" then
   MessageBox(ls_title,"수수료구분 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("comm_fg")
   return false
end if

is_ded_fg = dw_head.GetItemString(1, "ded_fg")
if IsNull(is_ded_fg) or Trim(is_ded_fg) = "" then
   MessageBox(ls_title,"공제구분 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ded_fg")
   return false
end if

is_yymm = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.09                                                  */	
/* 수정일      : 2002.03.09                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF is_ded_fg = '%' THEN
	dw_body.DataObject = "D_56106_D02"
ELSE
	dw_body.DataObject = "D_56106_D01"
END IF 
dw_body.SetTransObject(SQLCA)
dw_body.TriggerEvent(CONSTRUCTOR!)

il_rows = dw_body.retrieve(is_brand, is_shop_div, is_comm_fg, is_ded_fg, is_yymm)
IF il_rows > 0 THEN
	This.Post Event ue_bill_chk()
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.11                                                  */	
/* 수정일      : 2002.03.11                                                  */
/*===========================================================================*/
long  i, ll_row_count, ll_ded_amt
datetime ld_datetime 
String   ls_yymm

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	ll_ded_amt = dw_body.GetitemNumber(i, "ded_amt") 
	if ll_ded_amt <> 0 then
	   dw_body.SetItemStatus(i, 0, Primary!, DataModified!)
	end if	

   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record    */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		   /* Modify Record */ 
		ls_yymm = dw_body.GetitemString(i, "yymm") 
		IF isnull(ls_yymm) or Trim(ls_yymm) = "" THEN 
         dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
         dw_body.Setitem(i, "yymm",   is_yymm)
         dw_body.Setitem(i, "reg_id", gs_user_id)
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56106_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56106_e
end type

type cb_delete from w_com010_e`cb_delete within w_56106_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56106_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56106_e
integer x = 2871
end type

type cb_update from w_com010_e`cb_update within w_56106_e
end type

type cb_print from w_com010_e`cb_print within w_56106_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56106_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56106_e
end type

type cb_excel from w_com010_e`cb_excel within w_56106_e
end type

type dw_head from w_com010_e`dw_head within w_56106_e
string dataobject = "d_56106_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("shop_div", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")
//
This.GetChild("comm_fg", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('919')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")

This.GetChild("ded_fg", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('560')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")


end event

type ln_1 from w_com010_e`ln_1 within w_56106_e
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_e`ln_2 within w_56106_e
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_e`dw_body within w_56106_e
integer y = 440
integer height = 1608
string dataobject = "d_56106_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("comm_fg", idw_comm_fg) 
idw_comm_fg.SetTransObject(SQLCA)
idw_comm_fg.Retrieve('919')

This.GetChild("ded_fg", idw_ded_fg) 
idw_ded_fg.SetTransObject(SQLCA)
idw_ded_fg.Retrieve('560')


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

type dw_print from w_com010_e`dw_print within w_56106_e
end type

type st_1 from statictext within w_56106_e
integer x = 1975
integer y = 304
integer width = 1609
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

