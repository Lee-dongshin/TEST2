$PBExportHeader$w_11081_e.srw
$PBExportComments$판관비실적
forward
global type w_11081_e from w_com010_e
end type
type dw_1 from datawindow within w_11081_e
end type
type st_1 from statictext within w_11081_e
end type
end forward

global type w_11081_e from w_com010_e
dw_1 dw_1
st_1 st_1
end type
global w_11081_e w_11081_e

type variables
String is_brand, is_yyyy , is_country_cd
end variables

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
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
elseif  ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_country_cd = dw_head.GetItemString(1, "country_cd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_yyyy,is_country_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF


dw_1.retrieve(is_brand, is_yyyy,is_country_cd)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
long i, ll_row_count, k, ll_row
decimal  ldc_sale_acc, ldc_general_acc, ldc_stock_sale
datetime ld_datetime
String   ls_Find, ls_yymm

IF dw_body.AcceptText() <> 1 THEN RETURN -1

ll_row_count = dw_body.RowCount()

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		      /* Modify Record */
	   ls_yymm = dw_body.GetitemString(i, "yymm")

				ldc_sale_acc = dw_body.GetitemDecimal(i, "sale_acc")  
				ldc_general_acc = dw_body.GetitemDecimal(i, "general_acc" )  	
				ldc_stock_sale = dw_body.GetitemDecimal(i, "stock_sale" )  	
			   ls_find = "yymm = '" + ls_yymm  + "'"
	         ll_row = dw_1.find(ls_Find, 1, dw_1.RowCount())
				
				
				
				IF ll_row > 0 THEN
             
					dw_1.Setitem(ll_row, "sale_acc", ldc_sale_acc)
					dw_1.Setitem(ll_row, "general_acc", ldc_general_acc)
					dw_1.Setitem(ll_row, "stock_sale", ldc_stock_sale)
               dw_1.Setitem(ll_row, "mod_id", gs_user_id)
               dw_1.Setitem(ll_row, "mod_dt", ld_datetime)
				ELSE
					ll_row = dw_1.insertRow(0)
               dw_1.Setitem(ll_row, "brand",    is_brand)
               dw_1.Setitem(ll_row, "yymm",     ls_yymm)
               dw_1.Setitem(ll_row, "country", is_country_cd)
					dw_1.Setitem(ll_row, "sale_acc", ldc_sale_acc)
					dw_1.Setitem(ll_row, "general_acc", ldc_general_acc)
					dw_1.Setitem(ll_row, "stock_sale", ldc_stock_sale)
               dw_1.Setitem(ll_row, "reg_id", gs_user_id)

				END IF
	
   END IF
NEXT

il_rows = dw_1.Update(TRUE, FALSE)

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

on w_11081_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
end on

on w_11081_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
end on

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11081_e","0")
end event

type cb_close from w_com010_e`cb_close within w_11081_e
end type

type cb_delete from w_com010_e`cb_delete within w_11081_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_11081_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_11081_e
end type

type cb_update from w_com010_e`cb_update within w_11081_e
end type

type cb_print from w_com010_e`cb_print within w_11081_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_11081_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_11081_e
end type

type cb_excel from w_com010_e`cb_excel within w_11081_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_11081_e
integer x = 27
integer y = 196
integer width = 2176
integer height = 160
string dataobject = "d_11081_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('001')

This.GetChild("country_cd", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('000')

end event

type ln_1 from w_com010_e`ln_1 within w_11081_e
end type

type ln_2 from w_com010_e`ln_2 within w_11081_e
end type

type dw_body from w_com010_e`dw_body within w_11081_e
string dataobject = "d_11081_d01"
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
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
END CHOOSE

end event

event dw_body::itemerror;call super::itemerror;return 1
end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

event dw_body::editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_insert.enabled = false
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

type dw_print from w_com010_e`dw_print within w_11081_e
integer x = 1079
integer y = 828
end type

type dw_1 from datawindow within w_11081_e
boolean visible = false
integer x = 2181
integer y = 792
integer width = 1367
integer height = 164
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_11081_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_11081_e
integer x = 41
integer y = 376
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "(단위:백만원)"
boolean focusrectangle = false
end type

