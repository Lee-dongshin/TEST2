$PBExportHeader$w_56211_e.srw
$PBExportComments$매출 계산서 등록(2)
forward
global type w_56211_e from w_com010_e
end type
type dw_1 from datawindow within w_56211_e
end type
type cb_input from commandbutton within w_56211_e
end type
type dw_list from datawindow within w_56211_e
end type
end forward

global type w_56211_e from w_com010_e
integer width = 3703
integer height = 2292
event ue_input ( )
dw_1 dw_1
cb_input cb_input
dw_list dw_list
end type
global w_56211_e w_56211_e

type variables
String is_brand, is_yymm, is_shop_cd
end variables

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String ls_bill_ymd

dw_list.Visible   = False
dw_body.Visible   = True
dw_1.Visible      = True

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.Reset()
dw_1.Reset()
dw_1.insertRow(0)
il_rows = dw_body.insertRow(0)

gf_lastday(is_yymm, ls_bill_ymd)

dw_1.Setitem(1, "bill_ymd", Date(String(ls_bill_ymd, "@@@@/@@/@@")))
CHOOSE CASE RightA(is_yymm, 2)
	CASE '01', '02', '03'
      dw_1.setitem(1, "bungi", "1")
	CASE '04', '05', '06'
      dw_1.setitem(1, "bungi", "2")
	CASE '07', '08', '09'
      dw_1.setitem(1, "bungi", "3")
	CASE '10', '11', '12'
      dw_1.setitem(1, "bungi", "4")
END CHOOSE 

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(6, il_rows)

end event

on w_56211_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_input=create cb_input
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_input
this.Control[iCurrent+3]=this.dw_list
end on

on w_56211_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_input)
destroy(this.dw_list)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_input, "FixedToRight")
inv_resize.of_Register(dw_list,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1,     "ScaleToRight")

dw_list.SetTransObject(SQLCA)
dw_1.insertRow(0)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check    
DataStore  lds_Source 

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' " + & 
											 "  AND shop_div  in ('D', 'G', 'K', 'X', 'T')" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.11                                                  */	
/* 수정일      : 2002.06.11                                                  */
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


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_yymm = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			dw_body.SetFocus()
			RETURN
	END CHOOSE
END IF

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_yymm, is_shop_cd, is_brand)

IF il_rows >= 0 THEN
   dw_list.visible   = True
   dw_body.visible   = False
   dw_1.visible = False
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 6 - 입력  */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
         cb_print.enabled   = true
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_update.enabled  = false
         cb_input.Text      = "등록(&I)"
         dw_head.enabled    = true 
         ib_changed         = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled  = true
			cb_print.enabled   = false
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
			cb_print.enabled   = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_input.Text = "등록(&I)"
      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_update.enabled  = false
      ib_changed         = false
      dw_body.Enabled    = false
      dw_1.Enabled       = false
      dw_head.Enabled    = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_insert.enabled  = true
         cb_delete.enabled  = true
         cb_print.enabled   = true
         dw_head.Enabled    = false
         dw_body.Enabled    = true
         dw_1.Enabled       = true
         dw_body.SetFocus()
         ib_changed = false
         cb_update.enabled = false
         cb_input.Text = "조건(&I)"
      else
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_print.enabled   = false
      end if

END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.11                                                  */	
/* 수정일      : 2002.06.11                                                  */
/*===========================================================================*/
String   ls_seq, ls_slip_bonji, ls_issue_date, ls_bill_no, ls_rep_bungi, ls_ErrMsg
long     i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_1.AcceptText()    <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

gf_get_inter_sub('001', is_brand, '1', ls_slip_bonji)
if is_shop_cd = 'BG1813' then
	ls_slip_bonji = '81'
else
	gf_get_inter_sub('001', is_brand, '1', ls_slip_bonji)
end if



ls_issue_date = String(dw_1.GetitemDate(1, "bill_ymd"), "yyyy.mm.dd")
ls_rep_bungi  = dw_1.GetitemString(1, "bungi")
ls_bill_no    = dw_1.GetitemString(1, "bill_no")

// 순번 산출 
select isnull(max(seq), '00')
  into :ls_seq
  from dbo.tb_56050_h with (nolock)
 where yymm    = :is_yymm 
   and shop_cd = :is_shop_cd 
	and brand   = :is_brand ;
IF SQLCA.SQLCODE <> 0 THEN 
	MessageBox("채번 오류", SQLCA.SqlErrText)
	RETURN -1
END IF 

// 계산서 번호 산출 
IF isnull(ls_bill_no) or Trim(ls_bill_no) = "" THEN
   select right(isnull(max(bill_no), 0) + 10001, 4)
	  into :ls_bill_no
     from mis.dbo.tat07m with (nolock)
    where slip_bonji  = :ls_slip_bonji
      and bill_io     = '2'
      and issue_date  = :ls_issue_date ;
	IF SQLCA.SQLCODE <> 0 THEN 
		MessageBox("채번 오류", SQLCA.SqlErrText)
		RETURN -1
	END IF 
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	   ls_seq = String(Long(ls_seq) + 1, '00')
      dw_body.Setitem(i, "yymm",       is_yymm)
      dw_body.Setitem(i, "shop_cd",    is_shop_cd)
      dw_body.Setitem(i, "brand",      is_brand)
      dw_body.Setitem(i, "seq",        ls_seq)
      dw_body.Setitem(i, "shop_div",   MidA(is_shop_cd, 2, 1))
      dw_body.Setitem(i, "slip_bonji", ls_slip_bonji)
      dw_body.Setitem(i, "bill_io",    '2')
      dw_body.Setitem(i, "issue_date", ls_issue_date)
      dw_body.Setitem(i, "bill_no",    ls_bill_no)
      dw_body.Setitem(i, "reg_id",     gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

IF il_rows = 1 THEN 
   DECLARE SP_56211_BILL PROCEDURE FOR SP_56211_BILL  
         @brand      = :is_brand,   
         @yymm       = :is_yymm,   
			@shop_cd    = :is_shop_cd, 
         @issue_date = :ls_issue_date,   
         @bill_no    = :ls_bill_no, 
         @rep_bungi  = :ls_rep_bungi, 
         @user_id    = :gs_user_id  ;
   EXECUTE SP_56211_BILL;
   if SQLCA.SQLCODE = 0  OR SQLCA.SQLCODE = 100 then
   	il_rows    = 1 
   else 
	   ls_ErrMsg  = SQLCA.SQLErrText 
   	il_rows    = -1 
   end if
END IF

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_1.Setitem(1, "bill_no", ls_bill_no)
	dw_1.Enabled = False
else
   rollback  USING SQLCA;
	MessageBox("SQL 오류", ls_ErrMsg) 
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_print;Long    i, ll_row 
String  ls_bill_no, ls_issue_date

IF dw_list.visible = true THEN
	ll_row = dw_list.RowCount() 
	FOR i = 1 TO ll_row
	//	IF ls_issue_date <> dw_list.object.issue_date[i] or &
	//	   ls_bill_no    <> dw_list.object.bill_no[i]  THEN
         ls_issue_date = dw_list.GetitemString(i, "issue_date")
	      ls_bill_no    = dw_list.GetitemString(i, "bill_no")
      	IF dw_print.Retrieve(is_yymm, ls_bill_no, is_shop_cd, is_brand, ls_issue_date) > 0 THEN
		      dw_print.Print()
      	END IF 
	//	END IF
	NEXT 
ELSE 
	IF dw_body.RowCount() < 1 THEN RETURN 
	ls_issue_date = dw_body.GetitemString(1, "issue_date")
	ls_bill_no    = dw_body.GetitemString(1, "bill_no")	
	IF dw_print.Retrieve(is_yymm, ls_bill_no, is_shop_cd, is_brand, ls_issue_date) > 0 THEN
		dw_print.Print()
	END IF 
END IF


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56211_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56211_e
integer taborder = 130
end type

type cb_delete from w_com010_e`cb_delete within w_56211_e
integer taborder = 80
end type

type cb_insert from w_com010_e`cb_insert within w_56211_e
integer taborder = 60
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56211_e
integer taborder = 30
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : 김 태범      															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

Parent.Trigger Event ue_retrieve()	//조회

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com010_e`cb_update within w_56211_e
integer taborder = 120
end type

type cb_print from w_com010_e`cb_print within w_56211_e
integer taborder = 90
end type

type cb_preview from w_com010_e`cb_preview within w_56211_e
boolean visible = false
integer taborder = 100
end type

type gb_button from w_com010_e`gb_button within w_56211_e
end type

type cb_excel from w_com010_e`cb_excel within w_56211_e
boolean visible = false
integer taborder = 110
end type

type dw_head from w_com010_e`dw_head within w_56211_e
integer height = 164
string dataobject = "d_56211_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.11                                                  */	
/* 수정일      : 2002.06.11                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;DatawindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')


end event

type ln_1 from w_com010_e`ln_1 within w_56211_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_56211_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_56211_e
integer x = 0
integer y = 552
integer width = 3611
integer height = 1500
integer taborder = 50
string dataobject = "d_56211_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.SetRowFocusIndicator(Hand!)

This.GetChild("sale_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('560')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", '00')
ldw_child.Setitem(1, "inter_nm", '의류')
ldw_child.Setitem(1, "inter_cd1", 'Y')
ldw_child.SetFilter("inter_cd1 = 'Y'")
ldw_child.Filter()
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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/
Long    ll_amt, ll_vat 
String  ls_sale_gubn 

CHOOSE CASE dwo.name
	CASE "amt" 
		ll_amt = Long(Data)
		IF isnull(ll_amt) THEN ll_amt = 0 
		ll_vat = This.GetitemNumber(row, "vat")
		IF isnull(ll_vat) THEN
			ll_vat = Round(ll_amt / 10, 0)
		   This.Setitem(row, "vat", ll_vat)
		END IF 
		This.Setitem(row, "tot_amt", ll_amt + ll_vat) 
		ls_sale_gubn = This.GetitemString(row, "sale_gubn")
		CHOOSE CASE ls_sale_gubn 
       	CASE '00'
			     This.Setitem(row, "remark", String(is_yymm, "@@@@.@@") + " 의류대")
	      CASE '01'
			     This.Setitem(row, "remark", String(is_yymm, "@@@@.@@") + " 행랑")
	      CASE '07'
			     This.Setitem(row, "remark", String(is_yymm, "@@@@.@@") + " 사은품")
      END CHOOSE
	CASE "vat" 
		ll_vat = Long(Data)
		IF isnull(ll_vat) THEN ll_vat = 0 
		ll_amt = This.GetitemNumber(row, "amt")
		IF isnull(ll_amt) THEN ll_amt = 0 
		This.Setitem(row, "tot_amt", ll_amt + ll_vat)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_56211_e
integer x = 215
integer y = 268
string dataobject = "d_com560"
end type

type dw_1 from datawindow within w_56211_e
event ue_keydown pbm_dwnkey
integer x = 5
integer y = 376
integer width = 3607
integer height = 168
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_56211_h02"
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
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event constructor;DataWindowChild ldw_child

This.GetChild("bungi", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('017')


end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.11                                                  */	
/* 수정일      : 2002.06.11                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "bill_ymd"	    
        CHOOSE CASE MidA(Data, 6, 2)
	         CASE '01', '02', '03'
                 This.setitem(1, "bungi", "1")
	         CASE '04', '05', '06'
                 This.setitem(1, "bungi", "2")
	         CASE '07', '08', '09'
                 This.setitem(1, "bungi", "3")
            CASE '10', '11', '12'
                 This.setitem(1, "bungi", "4")
        END CHOOSE 
END CHOOSE

end event

type cb_input from commandbutton within w_56211_e
event ue_keydown pbm_keydown
integer x = 2528
integer y = 44
integer width = 347
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "등록(&I)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event clicked;/*===========================================================================*/
/* 작성자      : 김태범        															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
IF dw_head.Enabled THEN
   Parent.Trigger Event ue_input()	//등록 
ELSE 
	Parent.Trigger Event ue_head()	//조건 
END IF

end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

type dw_list from datawindow within w_56211_e
boolean visible = false
integer x = 9
integer y = 568
integer width = 3611
integer height = 1684
integer taborder = 70
string title = "none"
string dataobject = "d_56211_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child 

This.GetChild("sale_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('560')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", '00')
ldw_child.Setitem(1, "inter_nm", '의류')

end event

event doubleclicked;String ls_issue_date, ls_bill_no, ls_slip_date, ls_slip_no 

IF row < 1 THEN RETURN

ls_issue_date = This.GetitemString(row, "issue_date")
ls_bill_no    = This.GetitemString(row, "bill_no")
ls_slip_date  = This.GetitemString(row, "slip_date")
ls_slip_no    = This.GetitemString(row, "slip_no")

dw_1.Setitem(1, "bill_ymd", Date(ls_issue_date))
CHOOSE CASE MidA(ls_issue_date, 6, 2)
   CASE '01', '02', '03'
       dw_1.setitem(1, "bungi", "1")
   CASE '04', '05', '06'
       dw_1.setitem(1, "bungi", "2")
   CASE '07', '08', '09'
       dw_1.setitem(1, "bungi", "3")
   CASE '10', '11', '12'
       dw_1.setitem(1, "bungi", "4")
END CHOOSE 
dw_1.Setitem(1, "bill_no",  ls_bill_no)
dw_1.Setitem(1, "slip_ymd", ls_slip_date)
dw_1.Setitem(1, "slip_no",  ls_slip_no)

dw_body.Retrieve(is_yymm, is_shop_cd, is_brand, ls_issue_date, ls_bill_no)

dw_1.visible    = True
dw_body.visible = True
dw_list.visible = False

dw_body.SetFocus()

Parent.Trigger Event ue_button(6, il_rows)
dw_1.Enabled   = False
IF LenA(ls_slip_date) > 8 THEN
   dw_body.Enabled   = False
	cb_insert.Enabled = False
	cb_delete.Enabled = False
END IF


end event

