$PBExportHeader$w_42045_e.srw
$PBExportComments$중국출고선적일등록
forward
global type w_42045_e from w_com010_e
end type
type dw_db from datawindow within w_42045_e
end type
end forward

global type w_42045_e from w_com010_e
integer width = 3689
integer height = 2284
dw_db dw_db
end type
global w_42045_e w_42045_e

type variables
string  is_brand, is_yymmdd 
DatawindowChild  idw_brand
end variables

on w_42045_e.create
int iCurrent
call super::create
this.dw_db=create dw_db
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_db
end on

on w_42045_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_db)
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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
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

dw_db.retrieve(is_brand,is_yymmdd)
il_rows = dw_body.retrieve(is_brand,is_yymmdd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_row
datetime ld_datetime
string  ls_brand, ls_yymmdd, ls_out_no, ls_shipping_date, ls_find
decimal ld_qty

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 수정된 row 체크 */
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		ls_brand  = dw_body.Object.brand[i]
		ls_yymmdd = dw_body.Object.yymmdd[i]
		ls_out_no = dw_body.Object.out_no[i]
		ld_qty    = dw_body.Object.qty[i]
		ls_shipping_date = dw_body.Object.shipping_date[i]

		ls_Find  = "brand = '" + ls_brand + "' And yymmdd = '"  + ls_yymmdd + "' And out_no = '" + ls_out_no + "'"
		ll_row = dw_db.Find(ls_Find, 1, dw_db.RowCount()) 
		IF ll_row > 0 THEN 
			dw_db.Setitem(ll_row, "ld_qty", ld_qty)
			dw_db.Setitem(ll_row, "shipping_date", ls_shipping_date)
		ELSE
			ll_row = dw_db.insertRow(0)
			dw_db.Setitem(ll_row, "brand",     ls_brand)
			dw_db.Setitem(ll_row, "yymmdd",    ls_yymmdd)
			dw_db.Setitem(ll_row, "out_no",    ls_out_no)
			dw_db.Setitem(ll_row, "qty",       ld_qty)
			dw_db.Setitem(ll_row, "shipping_date", ls_shipping_date)
		END IF

	
NEXT

il_rows = dw_db.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;dw_db.SetTransObject(SQLCA)
end event

type cb_close from w_com010_e`cb_close within w_42045_e
end type

type cb_delete from w_com010_e`cb_delete within w_42045_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_42045_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42045_e
end type

type cb_update from w_com010_e`cb_update within w_42045_e
end type

type cb_print from w_com010_e`cb_print within w_42045_e
end type

type cb_preview from w_com010_e`cb_preview within w_42045_e
end type

type gb_button from w_com010_e`gb_button within w_42045_e
end type

type cb_excel from w_com010_e`cb_excel within w_42045_e
end type

type dw_head from w_com010_e`dw_head within w_42045_e
string dataobject = "d_42045_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_42045_e
end type

type ln_2 from w_com010_e`ln_2 within w_42045_e
end type

type dw_body from w_com010_e`dw_body within w_42045_e
string dataobject = "d_42045_d01"
end type

type dw_print from w_com010_e`dw_print within w_42045_e
integer x = 658
string dataobject = "d_42045_d01"
end type

type dw_db from datawindow within w_42045_e
boolean visible = false
integer x = 1929
integer y = 492
integer width = 562
integer height = 468
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "db"
string dataobject = "d_42045_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

