$PBExportHeader$w_56007_e.srw
$PBExportComments$매출형태별 마진등록(일괄)
forward
global type w_56007_e from w_com010_e
end type
type em_up from editmask within w_56007_e
end type
type cb_up from commandbutton within w_56007_e
end type
end forward

global type w_56007_e from w_com010_e
integer width = 3694
integer height = 2296
em_up em_up
cb_up cb_up
end type
global w_56007_e w_56007_e

type variables
String  is_brand,  is_shop_div,  is_shop_type,  is_shop_grp
String  is_yymmdd, is_sale_type
Decimal idc_dc_rate
end variables

on w_56007_e.create
int iCurrent
call super::create
this.em_up=create em_up
this.cb_up=create cb_up
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_up
this.Control[iCurrent+2]=this.cb_up
end on

on w_56007_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_up)
destroy(this.cb_up)
end on

event open;call super::open;dw_head.Setitem(1, "shop_div",  '%')
dw_head.Setitem(1, "shop_type", '1')
dw_head.Setitem(1, "shop_grp",  '%')
dw_head.Setitem(1, "sale_type", '11')

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.01                                                  */	
/* 수정일      : 2002.04.01                                                  */
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G') then
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


is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_shop_grp = dw_head.GetItemString(1, "shop_grp")
if IsNull(is_shop_grp) or Trim(is_shop_grp) = "" then
   MessageBox(ls_title,"백화점계열 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_grp")
   return false
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

is_sale_type = dw_head.GetItemString(1, "sale_type")
if IsNull(is_sale_type) or Trim(is_sale_type) = "" then
   MessageBox(ls_title,"매출형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

CHOOSE CASE is_shop_type 
	CASE '1'
		IF LeftA(is_sale_type, 1) > '2' THEN
         MessageBox(ls_title,"정상매장 매출형태가 아닙니다!")
         dw_head.SetFocus()
         dw_head.SetColumn("sale_type")
         return false
		END IF 
	CASE '3'
		IF LeftA(is_sale_type, 1) <> '3' THEN
         MessageBox(ls_title,"기획매장 매출형태가 아닙니다!")
         dw_head.SetFocus()
         dw_head.SetColumn("sale_type")
         return false
		END IF 
	CASE ELSE 
		IF LeftA(is_sale_type, 1) < '4' THEN
         MessageBox(ls_title,"행사매장 매출형태가 아닙니다!")
         dw_head.SetFocus()
         dw_head.SetColumn("sale_type")
         return false
		END IF 
END CHOOSE

idc_dc_rate = dw_head.GetItemDecimal(1, "dc_rate")
if IsNull(idc_dc_rate)  then
	idc_dc_rate = 0 
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.04.01                                                  */	
/* 수정일      : 2002.04.01                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,  is_shop_div,  is_shop_type, is_shop_grp,  & 
                           is_yymmdd, is_sale_type, idc_dc_rate)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_up.enabled = true
      end if

   CASE 5    /* 조건 */
      cb_up.enabled = false 
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.04.01                                                  */	
/* 수정일      : 2002.04.01                                                  */
/*===========================================================================*/
long  i, ll_row_count
datetime ld_datetime
String   ls_shop_cd, ls_ErrMsg 
Decimal  ldc_marjin

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

il_rows = 1 
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
	   ls_shop_cd = dw_body.GetitemString(i,  "shop_cd")
		ldc_marjin = dw_body.GetitemDecimal(i, "marjin_rate")
		DECLARE SP_56007_UPDATE PROCEDURE FOR SP_56007_UPDATE  
				  @shop_cd     = :ls_shop_cd, 
				  @brand       = :is_brand, 
				  @shop_type   = :is_shop_type, 
				  @sale_type   = :is_sale_type, 
				  @dc_rate     = :idc_dc_rate, 
				  @marjin_rate = :ldc_marjin, 
				  @yymmdd      = :is_yymmdd, 
				  @user_id     = :gs_user_id ; 

		EXECUTE SP_56007_UPDATE;
      
		IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN
			ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
			il_rows = -1
		END IF
   END IF
NEXT

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	MessageBox("저장 실패[SP]", ls_ErrMsg)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56007_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56007_e
end type

type cb_delete from w_com010_e`cb_delete within w_56007_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56007_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56007_e
end type

type cb_update from w_com010_e`cb_update within w_56007_e
end type

type cb_print from w_com010_e`cb_print within w_56007_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56007_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56007_e
end type

type cb_excel from w_com010_e`cb_excel within w_56007_e
boolean enabled = true
end type

type dw_head from w_com010_e`dw_head within w_56007_e
string dataobject = "d_56007_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", '%')
ldw_child.Setitem(1, "inter_nm", '전체')
ldw_child.SetFilter("inter_cd <> 'A' and inter_cd < 'X'")
ldw_child.Filter()

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("shop_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('912')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", '%')
ldw_child.Setitem(1, "inter_nm", '전체')

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String  ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"	
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56007_e
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_e`ln_2 within w_56007_e
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_e`dw_body within w_56007_e
integer y = 440
integer width = 3602
integer height = 1612
string dataobject = "d_56007_d01"
end type

event dw_body::constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)

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

type dw_print from w_com010_e`dw_print within w_56007_e
end type

type em_up from editmask within w_56007_e
integer x = 521
integer y = 48
integer width = 215
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##"
string minmax = "0~~99"
end type

type cb_up from commandbutton within w_56007_e
integer x = 745
integer y = 44
integer width = 466
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "변경폭 일괄적용"
end type

event clicked;Long    i 
Decimal ldc_bf_rate, ldc_up

ldc_up = dec(em_up.Text)

FOR i = 1 TO dw_body.RowCount() 
	ldc_bf_rate = dw_body.GetitemDecimal(i, "bf_marjin")
	IF isnull(ldc_bf_rate) THEN ldc_bf_rate = 0 
	dw_body.Setitem(i, "marjin_rate", ldc_bf_rate + ldc_up)
NEXT 

ib_changed = true
cb_update.enabled = true

end event

