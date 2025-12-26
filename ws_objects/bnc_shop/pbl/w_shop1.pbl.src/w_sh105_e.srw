$PBExportHeader$w_sh105_e.srw
$PBExportComments$타사매출등록
forward
global type w_sh105_e from w_com010_e
end type
type st_1 from statictext within w_sh105_e
end type
end forward

global type w_sh105_e from w_com010_e
integer width = 2985
integer height = 2088
st_1 st_1
end type
global w_sh105_e w_sh105_e

type variables
String	is_yymmdd, is_gubn
end variables

on w_sh105_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_sh105_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 동은아빠                                       */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.04.29 (김 태범)                                        */
/*===========================================================================*/
String   ls_title,ls_style_no

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


IF MidA(GS_SHOP_CD,3,4) = '2000' THEN 
	messagebox("참고!", "정상 매장에서 사용이 가능합니다!")
   RETURN FALSE
end if	

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

if IsNull(is_yymmdd) OR Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"판매일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_gubn = dw_head.getitemstring(1,"gubn")

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.04.30 (김 태범)                                        */
/*===========================================================================*/
long i
string ls_Flag
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.SetTransObject(SQLCA)
if is_gubn = 'D' then
	il_rows = dw_body.retrieve(is_yymmdd, gs_shop_cd, gs_brand)
else
	il_rows = dw_body.retrieve(is_yymmdd, gs_shop_cd)
end if

IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_Flag = dw_body.getitemstring(i,"Flag")
		if ls_Flag = "New" then	dw_body.SetItemStatus(i, 0, Primary!,New!)
	next 
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.04.29 (김 태범)                                        */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
String   ls_yymmdd 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_head.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

is_gubn = dw_head.getitemstring(1,"gubn")
if is_gubn = 'D' then
	FOR i=1 TO ll_row_count
		idw_status = dw_body.GetItemStatus(i, 0, Primary!) 
		IF idw_status = NewModified! THEN         /* New Record */
			dw_body.Setitem(i, "reg_id", gs_shop_cd)
		ELSEIF idw_status = DataModified! THEN	   /* Modify Record */
			ls_yymmdd = dw_body.GetitemString(i, "sale_ymd")
			IF isnull(ls_yymmdd) THEN 
				dw_body.Setitem(i, "sale_ymd", is_yymmdd)
				dw_body.Setitem(i, "reg_id",   gs_shop_cd) 
				dw_body.SetItemStatus(i, 0, Primary!, NewModified!) 
			ELSE
				dw_body.Setitem(i, "mod_id", gs_shop_cd)
				dw_body.Setitem(i, "mod_dt", ld_datetime) 
			END IF
		END IF
	NEXT
else
	FOR i=1 TO ll_row_count
		idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_body.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF
	NEXT	
end if

il_rows = dw_body.Update(True, False)

if il_rows = 1 then
   commit  USING SQLCA;
	st_1.text = ""
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
Return il_rows

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                      */	
/* 작성일      : 2002.01.22																  */	
/* 수정일      : 2002.01.22																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;This.Trigger Event ue_Retrieve() 

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

end event

type cb_close from w_com010_e`cb_close within w_sh105_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh105_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh105_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh105_e
end type

type cb_update from w_com010_e`cb_update within w_sh105_e
end type

type cb_print from w_com010_e`cb_print within w_sh105_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh105_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh105_e
end type

type dw_head from w_com010_e`dw_head within w_sh105_e
event ue_obj_set ( string as_data )
integer y = 164
integer height = 120
string dataobject = "d_sh105_h01"
end type

event dw_head::ue_obj_set(string as_data);
if as_data = "D" then 
	dw_body.dataobject = "d_sh105_d01" 
else
	dw_body.dataobject = "d_sh105_d02" 
end if

parent.trigger event ue_retrieve()
end event

event dw_head::itemchanged;call super::itemchanged;choose case dwo.name
	case "gubn"
		post event ue_obj_set(data)
end choose
end event

type ln_1 from w_com010_e`ln_1 within w_sh105_e
integer beginy = 300
integer endy = 300
end type

type ln_2 from w_com010_e`ln_2 within w_sh105_e
integer beginy = 304
integer endy = 304
end type

type dw_body from w_com010_e`dw_body within w_sh105_e
integer y = 312
integer height = 1520
string dataobject = "d_sh105_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.22                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
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

event dw_body::itemchanged;call super::itemchanged;st_1.text = "☜ 반드시 저장 버튼을 누르세요"

end event

type dw_print from w_com010_e`dw_print within w_sh105_e
integer x = 146
integer y = 616
end type

type st_1 from statictext within w_sh105_e
integer x = 411
integer y = 60
integer width = 1591
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
boolean focusrectangle = false
end type

