$PBExportHeader$w_79001_p.srw
$PBExportComments$A/S 등록
forward
global type w_79001_p from w_com030_e
end type
type cb_1 from commandbutton within w_79001_p
end type
type dw_1 from datawindow within w_79001_p
end type
end forward

global type w_79001_p from w_com030_e
integer x = 402
integer y = 400
integer width = 4512
integer height = 2740
string title = "고객과의 약속 선택 인쇄"
cb_1 cb_1
dw_1 dw_1
end type
global w_79001_p w_79001_p

type variables
DataWindowChild idw_brand, idw_color, idw_size, idw_judg_fg, idw_judg_s, idw_cust_fg_s
DataWindowChild idw_decision_a, idw_decision_b, idw_decision_c, idw_decision_d 
dragobject   idrg_ver[4]

String is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_card_no, is_jumin, is_custom_nm, is_rct_fr_ymd, is_rct_to_ymd
String is_yymmdd, is_seq_no

end variables

forward prototypes
public function integer wf_resizepanels ()
end prototypes

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Ver[2].X + idrg_Ver[2].Width - st_1.X - ii_BarThickness

idrg_Ver[1].Resize (st_1.X - idrg_Ver[1].X, idrg_Ver[1].Height)

idrg_Ver[2].Move (st_1.X + ii_BarThickness, idrg_Ver[2].Y)
idrg_Ver[2].Resize (ll_Width, idrg_Ver[2].Height)
idrg_Ver[3].Move (st_1.X + ii_BarThickness, idrg_Ver[3].Y)
idrg_Ver[3].Resize (ll_Width, idrg_Ver[3].Height)
idrg_Ver[4].Move (st_1.X + ii_BarThickness, idrg_Ver[4].Y)
idrg_Ver[4].Resize (ll_Width, idrg_Ver[4].Height)

Return 1

end function

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd_h"))
if IsNull(is_shop_cd) or is_shop_cd = "" then
	is_shop_cd = '%'
end if

is_card_no = Trim(dw_head.GetItemString(1, "card_no_h"))
if IsNull(is_card_no) or is_card_no = "" then
	is_card_no = '%'
end if

is_jumin = Trim(dw_head.GetItemString(1, "jumin_h"))
if IsNull(is_jumin) or is_jumin = "" then
	is_jumin = '%'
end if

is_custom_nm = Trim(dw_head.GetItemString(1, "custom_nm_h"))
if IsNull(is_custom_nm) or is_custom_nm = "" then
	is_custom_nm = '%'
end if

is_rct_fr_ymd = Trim(dw_head.GetItemString(1, "rct_fr_ymd"))
is_rct_to_ymd = Trim(dw_head.GetItemString(1, "rct_to_ymd"))

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
integer li_yet

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_card_no, is_jumin, is_custom_nm, is_rct_fr_ymd, is_rct_to_ymd)

dw_body.Reset()
dw_body.InsertRow(0)

IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

on w_79001_p.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_79001_p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택) 												  */	
/* 작성일      : 2002.03.21																  */	
/* 수정일      : 2002.03.21																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert,   "FixedToRight")
inv_resize.of_Register(cb_delete,   "FixedToRight")
inv_resize.of_Register(cb_print,    "FixedToRight")
inv_resize.of_Register(cb_preview,  "FixedToRight")
inv_resize.of_Register(cb_excel,    "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close,    "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list,   "ScaleToBottom")
inv_resize.of_Register(dw_body,   "ScaleToRight")

inv_resize.of_Register(st_1,      "ScaleToBottom")
inv_resize.of_Register(ln_1,      "ScaleToRight")
inv_resize.of_Register(ln_2,      "ScaleToRight")

inv_resize.of_Register(dw_head,      "ScaleToRight")

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.  SetTransObject(SQLCA)
dw_body.  SetTransObject(SQLCA)
dw_print. SetTransObject(SQLCA)
//dw_1.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)
//dw_tel.InsertRow(0)

/* DataWindow 사이 이동 */
idrg_Ver[1] = dw_list
idrg_Ver[2] = dw_body
//idrg_Ver[5] = dw_tel

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
	CASE 1		/* 조회 */
		cb_retrieve.Text = "조건(&Q)"
		dw_head.Enabled = false
		dw_list.Enabled = true
		If al_rows <= 0 Then
			dw_body.Enabled = true
		End If
	CASE 2   /* 추가 */
		if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
//         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled  = false
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = false
			dw_body.enabled    = false
		else
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
//         cb_insert.enabled = true
      end if
END CHOOSE

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long	ll_cur_row

if dw_body.AcceptText() <> 1 then return

/* 추가시 수정자료가 있을때 저장여부 확인 */
if ib_changed then 
	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 2
			ib_changed = false
		CASE 3
			RETURN
	END CHOOSE
end if

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_body.  SetRedraw(False)

dw_body.  Reset()

il_rows = dw_body.InsertRow(0)


dw_body.SetColumn(ii_min_column_id)
dw_body.SetFocus()

dw_body.  SetRedraw(True)

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21																  */	
/* 수정일      : 2002.03.21																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long i, ll_row_cnt, ll_find
dwitemstatus ldw_status


idw_status = dw_body.GetItemStatus (1, 0, primary!)	
il_rows = dw_body.DeleteRow(1)


This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long i, ll_cnt, ll_row_cnt, ll_row_cnt2
String ls_yymmdd, ls_seq_no, ls_person_nm, ls_shop_cd, ls_shop_nm, ls_style, ls_problem, ls_custom_nm, ls_amt

dw_print.dataobject = "d_79001_r04"
dw_print. SetTransObject(SQLCA)
dw_1.dataobject = "d_79001_d08_imsi"
dw_1. SetTransObject(SQLCA)

//dw_1.accepttext()
ll_row_cnt = dw_list.RowCount()

IF ll_row_cnt = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
	select person_nm 
	into :ls_person_nm 
	from TB_93010_M with (nolock)
	where person_id = :gs_user_id;
	
	//dw_print.object.t_jik.text = ls_person_nm	

//동적으로 임시테이블 생성
string sql_text, sql_insert

sql_text = "CREATE TABLE ##IMSI_79011_d " & 
				+ "(yymmdd	   varchar(08) not null, " &
				+ "seq_no	   varchar(04) not null, " &
				+ "custom_nm	varchar(30) not null, " &
				+ "shop_cd     varchar(06) not null, " &
				+ "shop_nm     varchar(30) not null, " &
				+ "style       varchar(08) not null, " &
				+ "problem     varchar(1000) not null, " &
				+ "person_nm   varchar(30) not null, " &
				+ "amt         varchar(18) not null )"
EXECUTE IMMEDIATE :sql_text ;

if sqlca.sqlcode = -1 then
	rollback;
	messagebox ('오류 발생', '오류오류')
else
	commit;
end if

	ll_cnt = 0
	For i = 1 To ll_row_cnt
		If dw_list.GetItemString(i, "cbit") = 'Y' Then
			ll_cnt = ll_cnt + 1
			dw_1.insertrow(0)
			dw_1.setitem(ll_cnt, 'cbit',      dw_list.getitemstring(i, 'cbit'))
			dw_1.setitem(ll_cnt, 'yymmdd',    dw_list.getitemstring(i, 'yymmdd'))
			dw_1.setitem(ll_cnt, 'seq_no',    dw_list.getitemstring(i, 'seq_no'))
			dw_1.setitem(ll_cnt, 'custom_nm', dw_list.getitemstring(i, 'custom_nm'))
			dw_1.setitem(ll_cnt, 'shop_cd',   dw_list.getitemstring(i, 'shop_cd'))
			dw_1.setitem(ll_cnt, 'shop_nm',   dw_list.getitemstring(i, 'shop_nm'))
			dw_1.setitem(ll_cnt, 'style',     dw_list.getitemstring(i, 'style'))
			dw_1.setitem(ll_cnt, 'problem',   dw_list.getitemstring(i, 'problem'))
			dw_1.setitem(ll_cnt, 'person_nm', ls_person_nm)
			dw_1.setitem(ll_cnt, 'amt',       dw_list.getitemstring(i, 'amt'))
			
			ls_yymmdd = dw_list.getitemstring(i,'yymmdd')
			ls_seq_no = dw_list.getitemstring(i,'seq_no')
			ls_custom_nm = dw_list.getitemstring(i,'custom_nm')
			ls_shop_cd = dw_list.getitemstring(i,'shop_cd')
			ls_shop_nm = dw_list.getitemstring(i,'shop_nm')
			ls_style = dw_list.getitemstring(i,'style')
			ls_problem = dw_list.getitemstring(i,'problem')
			ls_amt = dw_list.getitemstring(i,'amt')
			
			sql_insert = "insert into ##IMSI_79011_d " &
			+"values('"+ ls_yymmdd + "'," &
			+"'" + ls_seq_no + "'," &			
			+"'" + ls_custom_nm + "'," &
			+"'" + ls_shop_cd + "'," &
			+"'" + ls_shop_nm + "'," &
			+"'" + ls_style + "'," &
			+"'" + ls_problem + "'," &
			+"'" + ls_person_nm + "'," &			
			+"'" + ls_amt + "') "
			EXECUTE IMMEDIATE :sql_insert;
				
		End If
	Next

	if sqlca.sqlcode = -1 then
		rollback;
		messagebox ('오류 발생', '오류오류')
	else
		commit;
	end if	

	dw_print.retrieve()
	IF dw_print.RowCount() > 0 Then dw_print.Print()

//	if dw_print.getitemstring(1, 'amt') = '무상' then
//		dw_print.object.t_11.visible = false
//	end if			
//	IF dw_print.RowCount() > 0 Then il_rows = dw_print.Print()
	
END IF

This.Trigger Event ue_msg(6, il_rows)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79001_e","0")
end event

type cb_close from w_com030_e`cb_close within w_79001_p
integer x = 4041
integer taborder = 120
end type

type cb_delete from w_com030_e`cb_delete within w_79001_p
integer taborder = 70
end type

type cb_insert from w_com030_e`cb_insert within w_79001_p
integer taborder = 60
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_79001_p
integer x = 3698
end type

type cb_update from w_com030_e`cb_update within w_79001_p
integer taborder = 110
end type

type cb_print from w_com030_e`cb_print within w_79001_p
integer taborder = 80
end type

type cb_preview from w_com030_e`cb_preview within w_79001_p
boolean visible = false
integer taborder = 90
end type

type gb_button from w_com030_e`gb_button within w_79001_p
integer width = 4443
end type

type cb_excel from w_com030_e`cb_excel within w_79001_p
boolean visible = false
integer taborder = 100
end type

type dw_head from w_com030_e`dw_head within w_79001_p
integer width = 4407
integer height = 220
string dataobject = "d_79001_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd_h", "card_no_h", "jumin_h", "custom_nm_h"	//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::ue_keydown;/*===========================================================================*/
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
								
		Choose Case ls_column_name
			Case "card_no_h", "jumin_h", "custom_nm_h"
				ls_column_name = "custom_h"
		End Choose
		
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type ln_1 from w_com030_e`ln_1 within w_79001_p
integer beginy = 424
integer endx = 4448
integer endy = 424
end type

type ln_2 from w_com030_e`ln_2 within w_79001_p
integer beginy = 428
integer endx = 4448
integer endy = 428
end type

type dw_list from w_com030_e`dw_list within w_79001_p
integer y = 444
integer width = 4425
integer height = 2068
string dataobject = "d_79001_d08"
boolean hscrollbar = true
end type

event dw_list::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
string ls_receipt_ymd, ls_cbit
long ll_rows, ll_cnt
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

type dw_body from w_com030_e`dw_body within w_79001_p
boolean visible = false
integer x = 3003
integer y = 1000
integer width = 3561
integer height = 404
boolean enabled = false
string dataobject = "d_79001_d02"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("rcv_how", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('791')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')
end event

type st_1 from w_com030_e`st_1 within w_79001_p
boolean visible = false
integer x = 3141
integer y = 484
integer height = 2060
end type

type dw_print from w_com030_e`dw_print within w_79001_p
integer x = 2011
integer y = 468
integer width = 2213
integer height = 1904
string dataobject = "d_79001_r04"
end type

type cb_1 from commandbutton within w_79001_p
integer x = 37
integer y = 452
integer width = 256
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전체선택"
end type

event clicked;long ll_cnt
dw_list.scrolltorow(0)
//전체선택
if cb_1.text = '전체선택' then
	for ll_cnt = 1 to dw_list.rowcount()
		 dw_list.setitem(ll_cnt,'cbit','Y')
	next 
	cb_1.text = '전체해제'
else
//전체해지		
	for ll_cnt = 1 to dw_list.rowcount()
		 dw_list.setitem(ll_cnt,'cbit','N')
	next 
	cb_1.text = '전체선택'
end if

dw_list.ScrollNextRow()
SetPointer(HourGlass!)
end event

type dw_1 from datawindow within w_79001_p
boolean visible = false
integer x = 329
integer y = 816
integer width = 2875
integer height = 700
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_79001_d08_imsi"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

