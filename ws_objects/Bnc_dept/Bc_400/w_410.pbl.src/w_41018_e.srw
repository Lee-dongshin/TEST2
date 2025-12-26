$PBExportHeader$w_41018_e.srw
$PBExportComments$부자재입고등록
forward
global type w_41018_e from w_com010_e
end type
type dw_1 from datawindow within w_41018_e
end type
end forward

global type w_41018_e from w_com010_e
dw_1 dw_1
end type
global w_41018_e w_41018_e

type variables
DataWindowChild idw_brand
String is_brand, is_yymmdd, is_in_no
end variables

on w_41018_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_41018_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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
   MessageBox(ls_title,"입고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_in_no = dw_head.GetItemString(1, "in_no")

return true


end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
string ls_data, ls_in_no
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if isnull(is_in_no) or LenA(is_in_no) <> 4 then
	ls_data = "new"
	ls_in_no = "0000"
else	
	ls_data = "mod"	
	ls_in_no = is_in_no
end if


il_rows = dw_body.retrieve(is_yymmdd, is_brand, ls_in_no, ls_data)
IF il_rows > 0 THEN	
   dw_body.SetFocus()
	dw_1.retrieve(is_yymmdd, is_brand)
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
String ls_in_no

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


if isnull(is_in_no) or LenA(is_in_no) <> 4 then 
	select right(isnull(max(in_NO), 0) + 10001, 4)
	  into :is_in_no 
	  from tb_41020_h (nolock)
	 where yymmdd    = :is_yymmdd ;
end if	 

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! or idw_status = New! THEN		/* Modify Record */
		ls_in_no = dw_body.GetitemString(i, "in_no")
		IF isnull(ls_in_no) or Trim(ls_in_no) = "" THEN 
         dw_body.Setitem(i, "in_no", is_in_no)
         dw_body.Setitem(i, "reg_id", gs_user_id)
         dw_body.Setitem(i, "reg_dt", ld_datetime)			
			dw_body.SetitemStatus(i, 0, Primary!, NewModified!)
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF 
	end if
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_head.setitem(1, "in_no", is_in_no)
	dw_1.retrieve(is_yymmdd, is_brand)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41018_e","0")
end event

type cb_close from w_com010_e`cb_close within w_41018_e
end type

type cb_delete from w_com010_e`cb_delete within w_41018_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_41018_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_41018_e
end type

type cb_update from w_com010_e`cb_update within w_41018_e
end type

type cb_print from w_com010_e`cb_print within w_41018_e
end type

type cb_preview from w_com010_e`cb_preview within w_41018_e
end type

type gb_button from w_com010_e`gb_button within w_41018_e
end type

type cb_excel from w_com010_e`cb_excel within w_41018_e
end type

type dw_head from w_com010_e`dw_head within w_41018_e
integer height = 140
string dataobject = "d_41018_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_41018_e
integer beginy = 312
integer endy = 312
end type

type ln_2 from w_com010_e`ln_2 within w_41018_e
integer beginy = 316
integer endy = 316
end type

type dw_body from w_com010_e`dw_body within w_41018_e
integer y = 332
integer height = 1708
string dataobject = "d_41018_d01"
end type

type dw_print from w_com010_e`dw_print within w_41018_e
end type

type dw_1 from datawindow within w_41018_e
integer x = 1984
integer y = 336
integer width = 1595
integer height = 1080
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "금일 입고내역"
string dataobject = "d_41018_d02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

