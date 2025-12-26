$PBExportHeader$w_12a15_e.srw
$PBExportComments$완성제품치수
forward
global type w_12a15_e from w_com020_e
end type
type dw_spec from datawindow within w_12a15_e
end type
end forward

global type w_12a15_e from w_com020_e
integer width = 3694
integer height = 2244
dw_spec dw_spec
end type
global w_12a15_e w_12a15_e

type variables
string is_brand, is_style, is_chno, is_size[], is_dsgn_emp

DataWindowChild idw_brand, idw_color, idw_size, idw_empno, idw_shop_cd, idw_spec_fg, idw_spec_cd
end variables

forward prototypes
public subroutine wf_set_size ()
public subroutine wf_display_spec ()
public subroutine wf_save_spec ()
end prototypes

public subroutine wf_set_size ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 완성 제품 사이즈 정의[head] */
Long i, k, ll_rowcount
DataStore  lds_Source
String     ls_modify

ll_rowcount = dw_list.RowCount()
lds_Source  = Create DataStore 
lds_Source.DataObject = dw_list.DataObject

dw_list.RowsCopy(1, ll_rowcount, Primary!, lds_Source, 1, Primary!)

lds_Source.SetSort("size A")
lds_Source.Sort()

/* 사이즈 내역 Set */
String ls_null[]

is_size = ls_null
k = 0 
FOR i = 1 TO ll_rowcount
	IF i = 1 THEN
		k++
		is_size[k] = lds_source.object.size[i]
	ELSEIF lds_source.object.size[i] <> lds_source.object.size[i - 1] THEN
		k++
		is_size[k] = lds_source.object.size[i]
	END IF
NEXT

/* tab_1.tabpage_2.dw_2의 head 처리 */
FOR i = 1 TO 10 
	IF i > k THEN 
		ls_modify = "t_size_spec_" + String(i) + ".visible = 0 " + &
		            "size_spec_" + String(i) + ".visible = 0 "
	ELSE
		ls_modify = "t_size_spec_" + String(i) + ".text = '" + is_size[i] + "'" + &
                  "t_size_spec_" + String(i) + ".visible = 1 " + & 
						"size_spec_" + String(i) + ".visible = 1 "
	END IF
	dw_body.modify(ls_modify)
NEXT

Destroy  lds_Source


end subroutine

public subroutine wf_display_spec ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/* dw_spec에있는 내역을 tab_1.tabpage_2.dw_2 로 이관                         */
/*===========================================================================*/
String ls_spec_fg, ls_spec_cd, ls_size, ls_find 
Long   i, j, k,   ll_max      
Long   ll_RowCnt, ll_row 

ll_RowCnt = dw_spec.RowCount()
IF ll_RowCnt < 1 THEN RETURN

/* 사이즈 갯수 (wf_set_size에서 정의됨)*/
ll_max = UpperBound(is_size)    

/* display 용 datawindow 초기화 후 셋팅 */
dw_body.Reset()
FOR i = ll_RowCnt TO 1 STEP -1
	ls_spec_fg = dw_spec.GetitemString(i, "spec_fg") 
	ls_spec_cd = dw_spec.GetitemString(i, "spec_cd") 
	ls_size    = dw_spec.GetitemString(i, "size") 
	ls_find    = "spec_fg = '" + ls_spec_fg + "' and spec_cd = '" + ls_spec_cd + "'"
	ll_row = dw_body.find(ls_find, 1, dw_body.RowCount())
	IF ll_row < 0 THEN 
		RETURN 
	ELSEIF ll_row = 0 THEN
		ll_row = dw_body.insertRow(0)
		dw_body.Setitem(ll_row, "spec_fg", ls_spec_fg)
		dw_body.Setitem(ll_row, "spec_cd", ls_spec_cd)
		dw_body.Setitem(ll_row, "spec_term", dw_spec.GetitemDecimal(i, "spec_term"))
   END IF 
	/* size assort 내역 검색 */
	FOR j = 1 TO ll_max 
		IF is_size[j] = ls_size THEN EXIT
	NEXT 
   /* 해당 사이즈가 없으면 삭제 */
	IF j > ll_max THEN 
//		dw_spec.DeleteRow(i)
	ELSE 
		dw_body.Setitem(ll_row, "size_spec_" + String(j), dw_spec.GetitemDecimal(i, "size_spec"))
	END IF
NEXT

/* 제품 치수내역 정렬 */
dw_body.SetSort("spec_fg A, spec_cd A")
dw_body.Sort()
dw_body.ResetUpdate()

end subroutine

public subroutine wf_save_spec ();/*-------------------------------------------------*/
/* tab_1.tabpage_2.dw_2 내용을 dw_spec로 이관 처리 */
/*-------------------------------------------------*/

String  ls_spec_fg,    ls_spec_cd, ls_size, ls_find, ls_flag
Long    ll_RowCnt,     ll_row, i, j  
Decimal ldc_spec_term, ldc_size_spec
DwItemStatus ldw_status

IF dw_body.modifiedcount() = 0 AND dw_body.deletedcount() = 0 THEN
	Return 
END IF

/* db처리용 datawindow clear */
FOR i = 1 TO dw_spec.RowCount()
   dw_spec.Setitem(ll_row, "size_spec", 0)
NEXT

/* display용 datawindow 에서 db용 datawindow로 자료 이관 */
ll_RowCnt = dw_body.RowCount()
FOR i = 1 TO ll_RowCnt 
	ls_spec_fg    = dw_body.GetitemString(i,  "spec_fg")  
	ls_spec_cd    = dw_body.GetitemString(i,  "spec_cd") 
	IF isnull(ls_spec_fg) or isnull(ls_spec_cd) THEN CONTINUE
   ldc_spec_term = dw_body.GetitemDecimal(i, "spec_term")
	FOR j = 1 TO UpperBound(is_size) 
	   ls_size       = dw_body.describe("t_size_spec_" + String(j) + ".Text")
		ldc_size_spec = dw_body.GetitemDecimal(i, "size_spec_" + String(j))

 		IF isnull(ldc_size_spec)   THEN CONTINUE

		ls_find = "spec_fg = '" + ls_spec_fg + "' and spec_cd = '" + & 
		          ls_spec_cd + "' and size = '" + ls_size + "'"
		ll_row  = dw_spec.find(ls_find, 1, dw_spec.RowCount()) 
		IF ll_row < 1 THEN
			ll_row = dw_spec.insertRow(0)
	      dw_spec.Setitem(ll_row, "spec_fg", ls_spec_fg)
	      dw_spec.Setitem(ll_row, "spec_cd", ls_spec_cd)
	      dw_spec.Setitem(ll_row, "size",    ls_size)
		END IF
		ls_flag = dw_spec.Getitemstring(ll_row,"update_flag")
		if  ls_flag = 'N' then 
			dw_spec.SetItemStatus(ll_row, 0, Primary!, NewModified!)
		end if
      dw_spec.Setitem(ll_row, "spec_term", ldc_spec_term)
      dw_spec.Setitem(ll_row, "size_spec", ldc_size_spec)
	NEXT 
NEXT

///* 제품 치수가 없는자료는 삭제 */

//FOR i = 1 to   dw_spec.RowCount() 
//	ldc_size_spec = dw_spec.GetitemDecimal(i, "size_spec")
//   IF isnull(ldc_size_spec) OR ldc_size_spec = 0 THEN 
//		dw_spec.DeleteRow(i)
//	END IF
//NEXT
//
end subroutine

on w_12a15_e.create
int iCurrent
call super::create
this.dw_spec=create dw_spec
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_spec
end on

on w_12a15_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_spec)
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
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = ""then
	is_style = '%'
//   MessageBox(ls_title,"Style를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("style")
//	return false
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = ""then
	is_chno = '%'
//   MessageBox(ls_title,"Style를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("style")
//	return false
end if

is_dsgn_emp = Trim(dw_head.GetItemString(1, "dsgn_emp"))
if IsNull(is_dsgn_emp) or is_dsgn_emp = "" then
	is_dsgn_emp = '%'
end if

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);string     ls_emp_nm, ls_null, ls_style_no, ls_style, ls_chno
long       ll_qty, ll_cnt, ll_cnt_1
Boolean    lb_check
DataStore  lds_Source

dw_head.AcceptText() 
is_brand = dw_head.GetItemString(1, "brand")

SetNull(ls_null)
CHOOSE CASE as_column

	CASE "style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
						
			IF ai_div = 1 THEN 	
				IF gf_style_chk(ls_style, ls_chno) THEN
						if gs_brand <> "K" then						
							RETURN 0
						else 
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								RETURN 0
							end if	
						end if	
				end if				
				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if	
			
//			
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))

//				cb_2.enabled = true				 				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

	CASE "dsgn_emp"		
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_head.Setitem(al_row, "dsgn_emp", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 		
			if MidA(is_style, 1, 1) = 'O' then 
		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('O000')" 
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "dsgn_emp",    lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "dsgn_emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event ue_retrieve();/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows =dw_list.retrieve(is_brand, is_style, is_chno, is_dsgn_emp)

IF il_rows < 1 THEN
	This.Trigger Event ue_insert()
else		
	dw_body.Reset()	
	This.Trigger Event ue_retrieve()
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_seq_NO, ll_row_count_1, ll_cnt
sTRING LS_SEQ_NO, ls_yymmdd, ls_cbit, ls_abit, ls_bbit
datetime ld_datetime

ll_row_count = dw_body.RowCount()
//ll_row_count_1 = dw_1.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */

		If SQLCA.SQLCODE <> 0 Then 
			MessageBox("저장오류", "저장에 실패 하였습니다!")
			Return -1
		End If

      dw_body.Setitem(1, "reg_id", gs_user_id)
		dw_body.Setitem(1, "reg_dt", ld_datetime)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(1, "mod_id", gs_user_id)
      dw_body.Setitem(1, "mod_dt", ld_datetime)
   END IF

il_rows = dw_body.Update(TRUE, FALSE) 
if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12a13_e","0")
end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 				   									  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
//inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_body, "ScaleToRight")
//inv_resize.of_Register(dw_1, "ScaleToBottom")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_spec.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
//dw_head.InsertRow(0)
dw_list.InsertRow(0)
dw_body.InsertRow(0)
dw_spec.InsertRow(0)


end event

event open;call super::open;datetime ld_datetime
String ls_yymmdd

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//ls_yymmdd = string(ld_datetime, "YYYYMM")

//dw_head.setitem(1, "empno", gs_user_id)
//dw_head.InsertRow(0)
dw_head.setitem(1, "brand", 'O')


end event

event ue_insert();datetime ld_datetime
String ls_yymmdd, ls_spec_fg, ls_spec_cd
long ll_cnt, ll_row_1, i

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */

IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_list.reset()
dw_body.reset()
il_rows = dw_body.InsertRow(0)
//dw_1.Insertrow(0)


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF

	select count(inter_cd)
	into   :ll_row_1
	from   tb_91011_c
	where  inter_grp = '128';
		


/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()	
end if


This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com020_e`cb_close within w_12a15_e
end type

type cb_delete from w_com020_e`cb_delete within w_12a15_e
end type

type cb_insert from w_com020_e`cb_insert within w_12a15_e
boolean visible = false
boolean enabled = true
string text = "신규(&A)"
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_12a15_e
end type

type cb_update from w_com020_e`cb_update within w_12a15_e
end type

type cb_print from w_com020_e`cb_print within w_12a15_e
end type

type cb_preview from w_com020_e`cb_preview within w_12a15_e
end type

type gb_button from w_com020_e`gb_button within w_12a15_e
end type

type cb_excel from w_com020_e`cb_excel within w_12a15_e
end type

type dw_head from w_com020_e`dw_head within w_12a15_e
integer x = 14
integer y = 152
integer width = 3584
integer height = 108
string dataobject = "d_12a15_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



end event

event dw_head::itemchanged;CHOOSE CASE dwo.name	
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE


end event

event dw_head::ue_keydown;call super::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
								
//		Choose Case ls_column_name
//			Case "person_nm_h"
//				ls_column_name = "custom_h"
//		End Choose
		ls_column_name = "person_nm_h"
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_12a15_e
integer beginy = 260
integer endy = 260
end type

type ln_2 from w_com020_e`ln_2 within w_12a15_e
integer beginy = 264
integer endy = 264
end type

type dw_list from w_com020_e`dw_list within w_12a15_e
integer x = 5
integer y = 280
integer width = 859
integer height = 1720
string dataobject = "D_12a15_D01"
end type

event dw_list::clicked;call super::clicked;

IF row <= 0 THEN Return
/*
IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
*/
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_chno  = This.GetItemString(row, 'chno') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_style) or IsNull(is_chno)  THEN return


il_rows = dw_spec.Retrieve(is_style, is_chno)
//il_rows = dw_body.retrieve(is_style, is_chno)

IF il_rows <= 0 THEN
//	dw_body.Reset()
//	dw_body.Insertrow(0)
	wf_save_spec()
	wf_set_size() 
	wf_display_spec()	
//	dw_body.Setitem(1,'style', is_style)
//	dw_body.setitem(1,'chno', is_chno)
END IF
		
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_12a15_e
integer x = 901
integer y = 268
integer width = 3241
integer height = 1940
string dataobject = "D_12a15_D02"
boolean vscrollbar = false
end type

event dw_body::itemchanged;call super::itemchanged;string ls_column_nm, ls_style_no, ls_color
dw_body.accepttext()
ls_column_nm = This.GetColumnName()
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE ls_column_nm
	CASE "yymmdd"
    IF gf_datechk(data) = False THEN Return 1
	CASE "empno_d","empno_p","empno_t", "style_no"     //  Popup 검색창이 존재하는 항목 		
//	CASE "person_nm", "style_no", "shop_cd"     //  Popup 검색창이 존재하는 항목 		
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	case "color"
			dw_body.setitem(1,'size','')
			ls_style_no = dw_body.getitemstring(1,"style_no")
			ls_color = dw_body.getitemstring(1,"color")
			
			dw_body.GetChild("size", idw_size)
			idw_size.SetTransObject(SQLCA)
			idw_size.Retrieve(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1),ls_color)

			
END CHOOSE

end event

event dw_body::ue_keydown;String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		If dw_body.GetColumnName() = 'first_counsel' OR dw_body.GetColumnName() = 'first_result' OR dw_body.GetColumnName() = 'second_counsel' OR dw_body.GetColumnName() = 'second_result' Then
			RETURN 0
		else  
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
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
								
//		Choose Case ls_column_name
//			Case "card_no", "jumin_NO", "PERSON_nm"
//				ls_column_name = "custom"
//		End Choose
		ls_column_name = 'PERSON_nm'
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemfocuschanged;string ls_column_nm, ls_style_no, ls_color, ls_datetime, ls_first, ls_second, ls_third, ls_abit, ls_bbit
String ls_tag, ls_helpMsg
datetime ld_datetime

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)
this.accepttext()
This.SelectText(1, 3000)

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF
ls_datetime = string(ld_datetime, "YYYYMMDDHHMMSS")

CHOOSE CASE ls_column_nm
//	CASE "color"
//		ls_style_no = This.GetItemString(row, "style_no")
//		idw_color.Retrieve(Left(ls_style_no, 8), Mid(ls_style_no, 9, 1))
//		idw_color.InsertRow(1)
//		idw_color.SetItem(1, "color", '')
//		idw_color.SetItem(1, "color_enm", '')
//		
//	CASE "size"		
//		ls_style_no = This.GetItemString(row, "style_no")
//		ls_color    = This.GetItemString(row, "color"   )
//		idw_size.Retrieve(Left(ls_style_no, 8), Mid(ls_style_no, 9, 1), ls_color)
//		idw_size.InsertRow(1)
//		idw_size.SetItem(1, "size", '')
//		idw_size.SetItem(1, "size_nm", '')

	case "first_counsel"
		ls_first = dw_body.getitemstring(1,'first_counsel')
		if isnull(ls_first) or trim(ls_first) = '' then
			dw_body.setitem(1, "first_time", ld_datetime)
		end if

	case "second_counsel"
		ls_second = dw_body.getitemstring(1,'second_counsel')
		if isnull(ls_second) or trim(ls_second) = '' then
			dw_body.setitem(1, "second_time", ld_datetime)
		end if
		
	case "third_counsel"
		ls_third = dw_body.getitemstring(1,'third_counsel')
		if isnull(ls_third) or trim(ls_third) = '' then
			dw_body.setitem(1, "third_time", ld_datetime)
		end if
	
END CHOOSE

end event

event dw_body::dberror;//
end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child
 
This.GetChild("spec_fg", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('124') 

This.GetChild("spec_cd", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('125') 

end event

type st_1 from w_com020_e`st_1 within w_12a15_e
integer x = 873
integer y = 276
integer height = 1752
end type

type dw_print from w_com020_e`dw_print within w_12a15_e
integer x = 3031
integer y = 248
string dataobject = "D_12a12_l01"
end type

type dw_spec from datawindow within w_12a15_e
integer x = 1838
integer y = 632
integer width = 1390
integer height = 840
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12a15_spec"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

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

MessageBox(parent.title + "[TB_12023_D]", ls_message_string)
return 1
end event

