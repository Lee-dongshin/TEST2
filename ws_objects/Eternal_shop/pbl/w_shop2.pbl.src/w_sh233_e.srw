$PBExportHeader$w_sh233_e.srw
$PBExportComments$주간리포트
forward
global type w_sh233_e from w_com010_e
end type
end forward

global type w_sh233_e from w_com010_e
integer width = 2971
integer height = 2080
long backcolor = 16777215
end type
global w_sh233_e w_sh233_e

type variables
String is_emp_gubn, is_yymmdd
DataWindowChild	idw_emp_gubn
end variables

on w_sh233_e.create
call super::create
end on

on w_sh233_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
string   ls_title, ls_max_ymd, ls_yymmdd
integer	li_week_no, li_week_no1
datetime ld_datetime

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_yymmdd = string(ld_datetime,"yyyymmdd")

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

if ls_yymmdd >= "20071118" then
	if gs_brand = "N" then
		messagebox("알림!", '온앤온 매장은 스타일반응도조사를 이용하세요!')
		return false
	end if	
end if	

is_emp_gubn = dw_head.GetItemString(1, "emp_gubn")
if IsNull(is_emp_gubn) or Trim(is_emp_gubn) = "" then
   MessageBox(ls_title,"작성자구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("emp_gubn")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"작성일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


select max(yymmdd), isnull(datepart(wk, max(yymmdd)),0), datepart(wk, :is_yymmdd)
into :ls_max_ymd, :li_week_no, :li_week_no1
from TB_54035_H (nolock)
where shop_cd 		= :gs_shoP_cd
  and emp_gubn 	= :is_emp_gubn
  and brand  		= :gs_brand;
  
if li_week_no = li_week_no1 then
   messagebox("경고!", "금주" + '"' + ls_max_ymd + '"' + "일에 입력 하셨습니다!")
	dw_head.setitem(1, "yymmdd", ls_max_ymd)	
	is_yymmdd = ls_max_ymd	
end if	
  
  



return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
integer ii
String ls_flag

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_brand, gs_shop_cd, is_yymmdd, is_emp_gubn)
IF il_rows > 0 THEN
	for ii = 1 to il_rows
		ls_flag = dw_body.getitemstring(ii, "flag")
			if ls_flag = "new" then
			dw_body.SetItemStatus(ii, 0, Primary!, NewModified!)		
		end if	
	next
   dw_body.SetFocus()	
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
end event

event type long ue_update();call super::ue_update;long i, ll_row_count
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
      dw_body.Setitem(i, "yymmdd"   , is_yymmdd)	
      dw_body.Setitem(i, "shop_cd"  , gs_shop_cd)
      dw_body.Setitem(i, "emp_gubn" , is_emp_gubn)		
      dw_body.Setitem(i, "brand"    , gs_brand)				
      dw_body.Setitem(i, "reg_id"   , gs_user_id)
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
String ls_yymmdd

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) THEN
	ls_yymmdd = string(ld_datetime, "YYYYMMDD")
END IF


dw_head.setitem(1, "yymmdd", ls_yymmdd)
end event

type cb_close from w_com010_e`cb_close within w_sh233_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh233_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh233_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh233_e
end type

type cb_update from w_com010_e`cb_update within w_sh233_e
end type

type cb_print from w_com010_e`cb_print within w_sh233_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh233_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh233_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh233_e
integer y = 168
integer width = 2665
integer height = 132
string dataobject = "d_sh233_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("emp_gubn", idw_emp_gubn )
idw_emp_gubn.SetTransObject(SQLCA)
idw_emp_gubn.Retrieve('510')

end event

type ln_1 from w_com010_e`ln_1 within w_sh233_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_sh233_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_sh233_e
integer y = 332
integer height = 1508
string dataobject = "d_sh233_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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
	If ls_column_name <> 'contents' Then
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
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

type dw_print from w_com010_e`dw_print within w_sh233_e
end type

