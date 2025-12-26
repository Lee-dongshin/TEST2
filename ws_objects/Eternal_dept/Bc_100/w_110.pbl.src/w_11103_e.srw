$PBExportHeader$w_11103_e.srw
$PBExportComments$월판매형태별매출계획_중국
forward
global type w_11103_e from w_com010_e
end type
type tab_1 from tab within w_11103_e
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tab_1 from tab within w_11103_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type dw_detail from datawindow within w_11103_e
end type
type dw_master from datawindow within w_11103_e
end type
type em_1 from editmask within w_11103_e
end type
type em_2 from editmask within w_11103_e
end type
type em_3 from editmask within w_11103_e
end type
type em_4 from editmask within w_11103_e
end type
type cb_1 from commandbutton within w_11103_e
end type
type st_1 from statictext within w_11103_e
end type
end forward

global type w_11103_e from w_com010_e
tab_1 tab_1
dw_detail dw_detail
dw_master dw_master
em_1 em_1
em_2 em_2
em_3 em_3
em_4 em_4
cb_1 cb_1
st_1 st_1
end type
global w_11103_e w_11103_e

type variables
String is_brand, is_yyyy 
String is_year,  is_season 
Long   il_plan_seq

end variables

forward prototypes
public function integer wf_tab_retrieve (integer ai_index)
public subroutine wf_detail_read (integer ai_plan_seq)
end prototypes

public function integer wf_tab_retrieve (integer ai_index);Long ll_row

Choose Case ai_index
	Case 1 
		is_year   = String(Long(is_yyyy) - 1)
		is_season = 'W'
	Case 2
		is_year   = is_yyyy
		is_season = 'S'
	Case 3
		is_year   = is_yyyy
		is_season = 'M'
	Case 4
		is_year   = is_yyyy
		is_season = 'A'
	Case 5
		is_year   = is_yyyy
		is_season = 'W'
End Choose

ll_row = dw_master.Retrieve(is_brand, is_year, is_season)
cb_insert.Enabled = True
IF ll_row = 0 THEN
   ll_row = dw_master.insertRow(0)
	dw_master.Setitem(ll_row, "plan_seq", 1)
	cb_insert.Enabled = FALSE
END IF
dw_detail.Reset()

Return ll_row
end function

public subroutine wf_detail_read (integer ai_plan_seq);Long    i, ll_row_cnt, ll_find  
Decimal ldc_plan_amt
String  ls_yymm, ls_sale_div

dw_detail.SetRedraw(FALSE)

il_rows    = dw_detail.retrieve(is_brand, is_yyyy, is_year, is_season)

IF il_rows > 0 THEN
   ll_row_cnt = dw_body.retrieve(is_brand, is_year, is_season, ai_plan_seq) 
   FOR i = 1 TO ll_row_cnt 
		ls_yymm = dw_body.GetitemString(i, "yymm")
	   ll_find = dw_detail.find("yymm = '" + ls_yymm + "'", 1, dw_detail.RowCount())
		IF ll_find > 0 THEN 
			ls_sale_div  = dw_body.GetitemString(i, "sale_div")
			ldc_plan_amt = dw_body.GetitemDecimal(i, "plan_amt") / 1000
			dw_detail.Setitem(ll_find, "plan_amt_" + ls_sale_div, ldc_plan_amt)
		END IF
   NEXT
	dw_detail.ResetUpdate()
END IF

dw_detail.SetRedraw(TRUE)

Return
end subroutine

on w_11103_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.em_1=create em_1
this.em_2=create em_2
this.em_3=create em_3
this.em_4=create em_4
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.em_1
this.Control[iCurrent+5]=this.em_2
this.Control[iCurrent+6]=this.em_3
this.Control[iCurrent+7]=this.em_4
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.st_1
end on

on w_11103_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.em_3)
destroy(this.em_4)
destroy(this.cb_1)
destroy(this.st_1)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = wf_tab_retrieve(tab_1.selectedtab)

IF il_rows > 0 THEN
   dw_master.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_detail, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_master.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
long i, ll_row_count, k, ll_row
decimal  ldc_plan_amt
datetime ld_datetime
String   ls_Find, ls_yymm

IF dw_master.AcceptText() <> 1 THEN RETURN -1
IF dw_detail.AcceptText() <> 1 THEN RETURN -1

ll_row_count = dw_detail.RowCount()

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_detail.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		      /* Modify Record */
	   ls_yymm = dw_detail.GetitemString(i, "yymm")
	   FOR k = 1 TO 4 
         idw_status = dw_detail.GetItemStatus(i, "plan_amt_" + String(k), Primary!)
         IF idw_status = DataModified! THEN		/* Modify Column */
			   ldc_plan_amt = dw_detail.GetitemDecimal(i, "plan_amt_" + String(k)) * 1000
			   ls_find = "yymm = '" + ls_yymm + "' and sale_div = '" + String(k) + "'"
	         ll_row = dw_body.find(ls_Find, 1, dw_body.RowCount())
				IF ll_row > 0 THEN
               dw_body.Setitem(ll_row, "plan_amt", ldc_plan_amt)
               dw_body.Setitem(ll_row, "mod_id", gs_user_id)
               dw_body.Setitem(ll_row, "mod_dt", ld_datetime)
				ELSE
					ll_row = dw_body.insertRow(0)
               dw_body.Setitem(ll_row, "brand",    is_brand)
               dw_body.Setitem(ll_row, "year",     is_year)
               dw_body.Setitem(ll_row, "season",   is_season)
               dw_body.Setitem(ll_row, "plan_seq", il_plan_seq)
               dw_body.Setitem(ll_row, "yymm",     ls_yymm)
               dw_body.Setitem(ll_row, "sale_div", String(k))
               dw_body.Setitem(ll_row, "plan_amt", ldc_plan_amt)
               dw_body.Setitem(i, "reg_id", gs_user_id)
				END IF
		   END IF
		NEXT 
   END IF
NEXT

ll_row_count = dw_master.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_master.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_master.Setitem(i, "brand",  is_brand)
      dw_master.Setitem(i, "year",   is_year)
      dw_master.Setitem(i, "season", is_season)
      dw_master.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_master.Setitem(i, "mod_id", gs_user_id)
      dw_master.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_master.Update(TRUE, FALSE)
if il_rows = 1 then
   il_rows = dw_body.Update(TRUE, FALSE)
end if

if il_rows = 1 then
   dw_master.ResetUpdate()
   dw_body.ResetUpdate()
   dw_detail.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button;call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
			dw_master.enabled = true
			dw_detail.enabled = true
      end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
         cb_insert.enabled = true
		end if
   CASE 5    /* 조건 */
      cb_insert.enabled = false
		dw_master.enabled = false
		dw_detail.enabled = false
   CASE 7 /* dw_master click */
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
END CHOOSE

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_master.AcceptText() <> 1 then return
if dw_detail.AcceptText() <> 1 then return

il_rows = dw_master.InsertRow(0)

if il_rows > 0 then 
	if il_rows = 1 then
		il_plan_seq = 1
	else
	   il_plan_seq = dw_master.object.plan_seq[il_rows - 1] + 1
	end if
   dw_master.Setitem(il_rows, "plan_seq", il_plan_seq)
   /* 추가된 Row선택 */
	dw_master.SelectRow(0, FALSE)
   dw_master.SelectRow(il_rows, TRUE)
	wf_detail_read(il_plan_seq)
   ib_changed = true
   cb_update.enabled = true
   cb_insert.enabled = false
   /* 추가된 Row의 항목으로 이동 */
	dw_master.ScrollToRow(il_rows)
	dw_master.SetColumn("remark")
	dw_master.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11103_e","0")
end event

type cb_close from w_com010_e`cb_close within w_11103_e
integer taborder = 170
end type

type cb_delete from w_com010_e`cb_delete within w_11103_e
boolean visible = false
integer taborder = 120
end type

type cb_insert from w_com010_e`cb_insert within w_11103_e
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_11103_e
end type

type cb_update from w_com010_e`cb_update within w_11103_e
integer taborder = 160
end type

type cb_print from w_com010_e`cb_print within w_11103_e
boolean visible = false
integer taborder = 130
end type

type cb_preview from w_com010_e`cb_preview within w_11103_e
boolean visible = false
integer taborder = 140
end type

type gb_button from w_com010_e`gb_button within w_11103_e
end type

type cb_excel from w_com010_e`cb_excel within w_11103_e
boolean visible = false
integer taborder = 150
end type

type dw_head from w_com010_e`dw_head within w_11103_e
integer x = 27
integer width = 2107
integer height = 160
string dataobject = "d_11103_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_11103_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_11103_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_11103_e
boolean visible = false
integer x = 2171
integer y = 168
integer width = 1344
integer height = 168
string dataobject = "d_11103_d03"
end type

type dw_print from w_com010_e`dw_print within w_11103_e
end type

type tab_1 from tab within w_11103_e
integer y = 380
integer width = 3602
integer height = 1800
integer taborder = 180
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

event selectionchanging;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
IF oldindex < 1 THEN Return
IF dw_head.Enabled = TRUE THEN Return 1

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 2
         ib_changed = false
         cb_update.enabled = false
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
end event

event selectionchanged;IF oldindex < 1 THEN return 

wf_tab_retrieve(newindex)
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1688
long backcolor = 79741120
string text = "전년겨울"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1688
long backcolor = 79741120
string text = "봄"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1688
long backcolor = 79741120
string text = "여름"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1688
long backcolor = 79741120
string text = "가을"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1688
long backcolor = 79741120
string text = "겨울"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_detail from datawindow within w_11103_e
event ue_keydown pbm_dwnkey
integer x = 18
integer y = 876
integer width = 3566
integer height = 1164
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_11103_d01"
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

event itemchanged;/*===========================================================================*/
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

event itemerror;return 1
end event

type dw_master from datawindow within w_11103_e
event ue_keydown pbm_dwnkey
integer x = 18
integer y = 480
integer width = 1682
integer height = 384
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_11103_d02"
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

event clicked;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return
IF row = This.GetSelectedRow(0) THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 2 
			dw_master.Retrieve(is_brand, is_year, is_season)
//			ll_row     = This.GetSelectedRow(0)
//			idw_status = This.GetitemStatus(ll_row, 0, Primary!)
//			IF idw_status = NewModified! THEN 
//				dw_master.DeleteRow(ll_row)
//			END IF
			cb_insert.Enabled = TRUE
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

il_plan_seq = This.GetItemNumber(row, 'plan_seq') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(il_plan_seq) THEN return

wf_detail_read(il_plan_seq)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
Long i, ll_row

ib_changed = true
cb_update.enabled = true
cb_insert.enabled = false

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

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
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

event itemerror;return 1
end event

type em_1 from editmask within w_11103_e
event ue_keydown pbm_keydown
integer x = 1801
integer y = 784
integer width = 151
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
	Return 1
END IF

end event

type em_2 from editmask within w_11103_e
event ue_keydown pbm_keydown
integer x = 2089
integer y = 784
integer width = 151
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
	Return 1
END IF

end event

type em_3 from editmask within w_11103_e
event ue_keydown pbm_keydown
integer x = 2368
integer y = 784
integer width = 151
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
	Return 1
END IF

end event

type em_4 from editmask within w_11103_e
event ue_keydown pbm_keydown
integer x = 2633
integer y = 784
integer width = 151
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
	Return 1
END IF

end event

type cb_1 from commandbutton within w_11103_e
event ue_keydown pbm_keydown
integer x = 2793
integer y = 780
integer width = 466
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "신장율 일괄적용"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event getfocus;This.Weight = 700

end event

event losefocus;This.Weight = 400

end event

event clicked;/*===========================================================================*/
/* 작성자      : 김 태범      															  */	
/* 작성일      : 2002.01.16																  */	
/* 수정일      : 2002.01.16																  */
/*===========================================================================*/
pointer oldpointer  
Long    ll_row, i, k
Long    ll_rate[] 
Long    ll_sale_amt

IF dw_head.Enabled THEN RETURN

ll_row = dw_detail.RowCount()
IF ll_row < 1 THEN Return

ll_rate[1] = Long(em_1.text)
ll_rate[2] = Long(em_2.text)
ll_rate[3] = Long(em_3.text)
ll_rate[4] = Long(em_4.text)

This.Enabled = False 
oldpointer = SetPointer(HourGlass!)

FOR i = 1 TO ll_row 
	FOR k = 1 TO 4 
		ll_sale_amt = dw_detail.GetitemNumber(i, "sale_amt_" + String(k))
		dw_detail.Setitem(i, "plan_amt_" + String(k), ll_sale_amt * ll_rate[k] / 100)
   NEXT
NEXT
ib_changed = true
cb_update.enabled = true
cb_insert.enabled = false

SetPointer(oldpointer)
This.Enabled = True

end event

type st_1 from statictext within w_11103_e
integer x = 3168
integer y = 260
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
string text = "(단위 : 천원)"
boolean focusrectangle = false
end type

