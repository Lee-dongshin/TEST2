$PBExportHeader$w_11110_e.srw
$PBExportComments$시즌별총괄 매출계획-중국
forward
global type w_11110_e from w_com010_e
end type
type dw_1 from datawindow within w_11110_e
end type
type dw_2 from datawindow within w_11110_e
end type
type st_1 from statictext within w_11110_e
end type
type em_seq from editmask within w_11110_e
end type
type cb_copy from commandbutton within w_11110_e
end type
type dw_3 from datawindow within w_11110_e
end type
type gb_1 from groupbox within w_11110_e
end type
end forward

global type w_11110_e from w_com010_e
dw_1 dw_1
dw_2 dw_2
st_1 st_1
em_seq em_seq
cb_copy cb_copy
dw_3 dw_3
gb_1 gb_1
end type
global w_11110_e w_11110_e

type variables
DataWindowChild idw_brand, idw_season
String  is_brand, is_year, is_season 
Long    il_plan_seq
end variables

on w_11110_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_1=create st_1
this.em_seq=create em_seq
this.cb_copy=create cb_copy
this.dw_3=create dw_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_seq
this.Control[iCurrent+5]=this.cb_copy
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.gb_1
end on

on w_11110_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_1)
destroy(this.em_seq)
destroy(this.cb_copy)
destroy(this.dw_3)
destroy(this.gb_1)
end on

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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_brand, is_year, is_season) 
IF il_rows = 0 THEN 
	dw_1.insertRow(0)
END IF
dw_1.Enabled = True

il_rows = dw_body.retrieve(is_brand, is_year, is_season)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	dw_2.Reset()
	cb_insert.Enabled = True
ELSEIF il_rows = 0 THEN
	il_rows = dw_body.insertRow(0)
	il_plan_seq = 1
	dw_body.Setitem(1, "plan_seq", il_plan_seq)
	dw_body.selectrow(0, FALSE)
	dw_body.selectrow(1, TRUE)
   dw_2.Retrieve(is_brand, is_year, is_season, il_plan_seq)
	dw_2.Enabled = True
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

inv_resize.of_Register(gb_1,    "FixedToRight")
inv_resize.of_Register(em_seq,  "FixedToRight")
inv_resize.of_Register(cb_copy, "FixedToRight")
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "FixedToRight")
//inv_resize.of_Register(dw_1, "FixedToBottom")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_1.InsertRow(0)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String   ls_brand

ll_row_count = dw_body.RowCount()

IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_1.AcceptText() <> 1 THEN RETURN -1
IF dw_2.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* tb_11070_m 처리 */
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "brand",    is_brand)
      dw_body.Setitem(i, "year",     is_year)
      dw_body.Setitem(i, "season",   is_season)
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

/* tb_11071_d 처리 */
ll_row_count = dw_2.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_2.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN	
		ls_brand = dw_2.GetitemString(i, "brand")
		IF isnull(ls_brand) OR Trim(ls_brand) = "" THEN /* 총괄 매출 신규 자료 */
         dw_2.Setitem(i, "brand",    is_brand)
         dw_2.Setitem(i, "year",     is_year)
         dw_2.Setitem(i, "season",   is_season)
         dw_2.Setitem(i, "plan_seq", il_plan_seq)
         dw_2.Setitem(i, "reg_id",   gs_user_id)
		end if
		
		dw_2.Setitem(i, "plan_amt", dw_2.GetitemDecimal(i, "c_plan_amt") * 1000)
		dw_2.Setitem(i, "tag_amt",  dw_2.GetitemDecimal(i, "c_tag_tot") * 1000)
      dw_2.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		
		ls_brand = dw_2.GetitemString(i, "brand")
		IF isnull(ls_brand) OR Trim(ls_brand) = "" THEN /* 총괄 매출 신규 자료 */
         dw_2.SetItemStatus(i, 0, Primary!, NewModified!)
         dw_2.Setitem(i, "brand",    is_brand)
         dw_2.Setitem(i, "year",     is_year)
         dw_2.Setitem(i, "season",   is_season)
         dw_2.Setitem(i, "plan_seq", il_plan_seq)
         dw_2.Setitem(i, "reg_id",   gs_user_id)
		ELSE
         dw_2.Setitem(i, "mod_id", gs_user_id)
         dw_2.Setitem(i, "mod_dt", ld_datetime)
		END IF 
		dw_2.Setitem(i, "plan_amt", dw_2.GetitemDecimal(i, "c_plan_amt") * 1000)
		dw_2.Setitem(i, "tag_amt",  dw_2.GetitemDecimal(i, "c_tag_tot") * 1000)
   END IF
NEXT


il_rows = dw_body.Update(TRUE, FALSE)
IF il_rows = 1 THEN
   il_rows = dw_2.Update(TRUE, FALSE)
END IF

if il_rows = 1 then
   dw_body.ResetUpdate()
   dw_2.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_insert.enabled = false
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			cb_insert.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_insert.enabled = false
      em_seq.enabled    = false
      cb_copy.enabled   = false
   CASE 7  
      em_seq.enabled    = True
      cb_copy.enabled   = True
END CHOOSE

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_2.AcceptText() <> 1 then return
if dw_body.AcceptText() <> 1 then return

il_rows = dw_body.InsertRow(0)

if il_rows > 0 then 
	if il_rows = 1 then
		il_plan_seq = 1
	else
	   il_plan_seq = dw_body.object.plan_seq[il_rows - 1] + 1
	end if
   dw_body.Setitem(il_rows, "plan_seq", il_plan_seq)
   cb_insert.enabled = false
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11010_e","0")
end event

type cb_close from w_com010_e`cb_close within w_11110_e
integer taborder = 120
end type

type cb_delete from w_com010_e`cb_delete within w_11110_e
boolean visible = false
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_11110_e
integer taborder = 60
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_11110_e
end type

type cb_update from w_com010_e`cb_update within w_11110_e
integer taborder = 110
end type

type cb_print from w_com010_e`cb_print within w_11110_e
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_11110_e
boolean visible = false
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_11110_e
end type

type cb_excel from w_com010_e`cb_excel within w_11110_e
boolean visible = false
integer taborder = 100
end type

type dw_head from w_com010_e`dw_head within w_11110_e
integer height = 160
string dataobject = "d_11110_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003',is_brand,is_year)
//idw_season.Retrieve('003')
end event

event dw_head::itemchanged;call super::itemchanged;//라빠레트 시즌적용
dw_head.accepttext()

is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003',is_brand,is_year)
end event

type ln_1 from w_com010_e`ln_1 within w_11110_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_11110_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_11110_e
integer y = 364
integer width = 2683
integer height = 352
string dataobject = "d_11110_d03"
end type

event dw_body::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
Long i, ll_rate, ll_tag_amt, ll_plan_amt
IF row <= 0 THEN Return
IF row = This.GetSelectedRow(0) THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 2 
			dw_body.Retrieve(is_brand, is_year, is_season)
			cb_insert.Enabled = TRUE
		CASE 3
			RETURN 1
	END CHOOSE 
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

il_plan_seq = This.GetitemNumber(row, "plan_seq")
il_rows = dw_2.Retrieve(is_brand, is_year, is_season, il_plan_seq)

IF il_rows > 0 THEN 
	FOR i = 1 TO 4 
		ll_tag_amt  = dw_2.GetitemNumber(1, "tag_amt_" + String(i))
		ll_plan_amt = dw_2.GetitemNumber(1, "plan_amt_" + String(i)) 
		IF ll_tag_amt <> 0 THEN
		   ll_rate = 100 - (ll_plan_amt / ll_tag_amt * 100) 
			dw_1.Setitem(1, "rate_" + String(i), ll_rate)
		END IF
   NEXT 
   dw_2.Enabled = True
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
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
END CHOOSE

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
Long i, ll_row

CHOOSE CASE dwo.name 
	CASE "last_yn" 
		IF data <> 'Y' THEN RETURN 0
		ll_row = This.RowCount()
		FOR i = 1 TO ll_row 
			IF row <> i THEN 
				This.Setitem(i, "last_yn", "N")
			END IF
		NEXT
END CHOOSE

end event

event dw_body::dberror;//

end event

type dw_print from w_com010_e`dw_print within w_11110_e
end type

type dw_1 from datawindow within w_11110_e
event ue_keydown pbm_dwnkey
integer x = 9
integer y = 724
integer width = 2158
integer height = 212
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_11110_d01"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;/*===========================================================================*/
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

event itemchanged;Long   ll_rate, ll_job_amt, i, ll_row_cnt  
String ls_div

CHOOSE CASE dwo.name
	CASE "rate_1", "rate_2", "rate_3", "rate_4" 
		ls_div  = RightA(dwo.name, 1)
		ll_rate = 100 - Long(Data) 
		IF isnull(ll_rate) THEN ll_rate = 0 
		ll_row_cnt = dw_2.RowCount()
		IF ll_row_cnt < 1 THEN Return 0 
		FOR i = 1 TO ll_row_cnt 
			ll_job_amt = dw_2.GetitemNumber(i, "job_amt_" + ls_div)
			dw_2.Setitem(i, "tag_amt_" + ls_div, ROUND(ll_job_amt / ll_rate * 100, 0) * 1000)
		NEXT 
      ib_changed = true
      cb_update.enabled = true
      cb_insert.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
END CHOOSE

end event

event losefocus;This.AcceptText()
end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
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

type dw_2 from datawindow within w_11110_e
event ue_keydown pbm_dwnkey
integer x = 5
integer y = 716
integer width = 3607
integer height = 1336
integer taborder = 50
boolean enabled = false
string title = "none"
string dataobject = "d_11110_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

Long   ll_rate
String ls_div

CHOOSE CASE dwo.name
	CASE "job_amt_1", "job_amt_2", "job_amt_3", "job_amt_4" 
		ls_div  = RightA(dwo.name, 1)
		ll_rate = 100 - dw_1.GetitemNumber(1, "rate_" + ls_div)
		IF isnull(ll_rate) THEN ll_rate = 0 
		dw_2.Setitem(row, "plan_amt_" + ls_div, Dec(Data) * 1000)
		dw_2.Setitem(row, "tag_amt_"  + ls_div, Round(Dec(Data) / ll_rate * 100, 0) * 1000)
END CHOOSE

end event

event dberror;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 1999.11.09																  */	
///* 수정일      : 1999.11.09																  */
///*===========================================================================*/
//
//string ls_message_string
//
//CHOOSE CASE sqldbcode
//	CASE 2627
//		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
//	CASE 515
//		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
//	CASE -1
//		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
//	CASE ELSE
//		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
//		   				     "~n" + "에러메세지("+sqlerrtext+")" 
//END CHOOSE
//
//This.ScrollTorow(row)
//This.SetRow(row)
//This.SetFocus()
//
//MessageBox(parent.title, ls_message_string)
//return 1
end event

event editchanged;/*===========================================================================*/
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

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
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

type st_1 from statictext within w_11110_e
integer x = 2706
integer y = 276
integer width = 891
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
string text = "단위 : 천원 (평균단가 : 원)"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_seq from editmask within w_11110_e
integer x = 2757
integer y = 504
integer width = 288
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
string minmax = "1~~10"
end type

type cb_copy from commandbutton within w_11110_e
integer x = 3063
integer y = 500
integer width = 517
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "불러 오기"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
Long ll_plan_seq, i, ll_rate, ll_tag_amt, ll_plan_amt
string ls_brand, ls_year, ls_season, ls_plan_fg, ls_old_brand
decimal ld_plan_amt, ld_plan_amt_1, ld_plan_amt_2,ld_plan_amt_3,ld_plan_amt_4,ld_job_amt_1, ld_job_amt_2,ld_job_amt_3,ld_job_amt_4
decimal ld_tag_amt,ld_tag_amt_1,ld_tag_amt_2,ld_tag_amt_3,ld_tag_amt_4,ld_avg_price,ld_prgs_rate,ld_cost_rate
ll_plan_seq = Long(em_seq.Text)

IF isnull(ll_plan_seq) OR ll_plan_seq < 1 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 
			END IF		
		CASE 3
			RETURN 
	END CHOOSE 
END IF
	
il_rows = dw_3.Retrieve(is_brand, is_year, is_season, ll_plan_seq)
FOR i = 1 TO il_rows
			ls_brand    	= dw_3.GetitemString(i, "brand")
			ls_year     	= dw_3.GetitemString(i, "year")
			ls_season   	= dw_3.GetitemString(i, "season")		
			ls_plan_fg     = dw_3.GetitemString(i, "plan_fg")
			ld_plan_amt    = dw_3.GetitemDecimal(i, "plan_amt")
			ld_plan_amt_1	= dw_3.GetitemDecimal(i, "plan_amt_1")	
			ld_plan_amt_2	= dw_3.GetitemDecimal(i, "plan_amt_2")	
			ld_plan_amt_3	= dw_3.GetitemDecimal(i, "plan_amt_3")	
			ld_plan_amt_4	= dw_3.GetitemDecimal(i, "plan_amt_4")	
			ld_job_amt_1	= dw_3.GetitemDecimal(i, "job_amt_1")	
			ld_job_amt_2	= dw_3.GetitemDecimal(i, "job_amt_2")	
			ld_job_amt_3	= dw_3.GetitemDecimal(i, "job_amt_3")	
			ld_job_amt_4	= dw_3.GetitemDecimal(i, "job_amt_4")	
			ld_tag_amt		= dw_3.GetitemDecimal(i, "tag_amt")	
			ld_tag_amt_1	= dw_3.GetitemDecimal(i, "tag_amt_1")	
			ld_tag_amt_2	= dw_3.GetitemDecimal(i, "tag_amt_2")	
			ld_tag_amt_3	= dw_3.GetitemDecimal(i, "tag_amt_3")	
			ld_tag_amt_4	= dw_3.GetitemDecimal(i, "tag_amt_4")	
			ld_avg_price	= dw_3.GetitemDecimal(i, "avg_price")	
			ld_prgs_rate	= dw_3.GetitemDecimal(i, "prgs_rate")	
			ld_cost_rate	= dw_3.GetitemDecimal(i, "cost_rate")	
		
			ls_old_brand =  dw_2.GetitemString(i, "brand")
		   IF isnull(ls_old_brand) OR ls_old_brand = ''  THEN     
				dw_2.SetItemStatus(i, 0, Primary!, NewModified!)
			END IF 
		
			dw_2.Setitem(i, "brand", ls_brand)
			dw_2.Setitem(i, "year", ls_year)
			dw_2.Setitem(i, "season", ls_season)
			dw_2.Setitem(i, "plan_fg", ls_plan_fg)			
		   dw_2.Setitem(i, "plan_seq", il_plan_seq)
			dw_2.Setitem(i, "plan_amt", ld_plan_amt)
			dw_2.Setitem(i, "plan_amt_1", ld_plan_amt_1)
			dw_2.Setitem(i, "plan_amt_2", ld_plan_amt_2)
			dw_2.Setitem(i, "plan_amt_3", ld_plan_amt_3)
			dw_2.Setitem(i, "plan_amt_4", ld_plan_amt_4)
			dw_2.Setitem(i, "job_amt_1", ld_job_amt_1)
			dw_2.Setitem(i, "job_amt_2", ld_job_amt_2)
			dw_2.Setitem(i, "job_amt_3", ld_job_amt_3)
			dw_2.Setitem(i, "job_amt_4", ld_job_amt_4)
			dw_2.Setitem(i, "tag_amt", ld_tag_amt)
			dw_2.Setitem(i, "tag_amt_1", ld_tag_amt_1)
			dw_2.Setitem(i, "tag_amt_2", ld_tag_amt_2)
			dw_2.Setitem(i, "tag_amt_3", ld_tag_amt_3)
			dw_2.Setitem(i, "tag_amt_4", ld_tag_amt_4)
			dw_2.Setitem(i, "avg_price", ld_avg_price)
			dw_2.Setitem(i, "prgs_rate", ld_prgs_rate)
			dw_2.Setitem(i, "cost_rate", ld_cost_rate)

				
NEXT

IF il_rows > 0 THEN 
	FOR i = 1 TO 4 
		ll_tag_amt  = dw_2.GetitemNumber(1, "tag_amt_" + String(i))
		ll_plan_amt = dw_2.GetitemNumber(1, "plan_amt_" + String(i)) 
		IF ll_tag_amt <> 0 THEN
		   ll_rate = 100 - (ll_plan_amt / ll_tag_amt * 100) 
			dw_1.Setitem(1, "rate_" + String(i), ll_rate)
		END IF
   NEXT 
   dw_2.Enabled = True
END IF

Parent.Trigger Event ue_msg(1, il_rows)

cb_update.Enabled =true
end event

type dw_3 from datawindow within w_11110_e
boolean visible = false
integer x = 1979
integer y = 368
integer width = 411
integer height = 432
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_11110_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_11110_e
integer x = 2720
integer y = 384
integer width = 882
integer height = 300
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "복사"
borderstyle borderstyle = stylelowered!
end type

