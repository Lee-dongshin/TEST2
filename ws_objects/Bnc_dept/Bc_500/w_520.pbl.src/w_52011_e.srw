$PBExportHeader$w_52011_e.srw
$PBExportComments$코디 배분
forward
global type w_52011_e from w_com010_e
end type
type rb_1 from radiobutton within w_52011_e
end type
type rb_2 from radiobutton within w_52011_e
end type
type dw_assort from datawindow within w_52011_e
end type
type dw_temp from datawindow within w_52011_e
end type
type dw_db from datawindow within w_52011_e
end type
type st_remark from statictext within w_52011_e
end type
type gb_1 from groupbox within w_52011_e
end type
end forward

global type w_52011_e from w_com010_e
rb_1 rb_1
rb_2 rb_2
dw_assort dw_assort
dw_temp dw_temp
dw_db dw_db
st_remark st_remark
gb_1 gb_1
end type
global w_52011_e w_52011_e

type variables
DataWindowChild idw_fr_color, idw_to_color, idw_house_cd, idw_shop_brand

String  is_flag, is_house_cd
String  is_fr_style, is_fr_chno, is_fr_color, is_fr_ymd , is_shop_brand
String  is_to_style, is_to_chno, is_to_color, is_to_ymd 
Long    il_deal_seq
Boolean ib_NewDeal
end variables

forward prototypes
public function boolean wf_temp_set ()
public function boolean wf_deal ()
public subroutine wf_retrieve_set ()
public subroutine wf_add_stock ()
public function boolean wf_body_set ()
end prototypes

public function boolean wf_temp_set ();/* 기준품번 배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt, ll_assort_cnt 
Long   i, k,   ll_deal_qty  
Boolean lb_Chk

ll_row_cnt    = dw_temp.RowCount()
IF ll_row_cnt < 1 THEN RETURN FALSE

ll_assort_cnt = dw_assort.RowCount()

dw_body.SetRedraw(False) 
dw_body.Reset()
lb_Chk = False 
FOR i = 1 TO ll_row_cnt 
	IF ls_shop_cd <> dw_temp.object.shop_cd[i] THEN 
      ls_shop_cd =  dw_temp.object.shop_cd[i] 
		ll_row     =  dw_body.insertRow(0)
      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm",   dw_temp.object.shop_nm[i])
      dw_body.Setitem(ll_row, "shop_stat", dw_temp.object.shop_stat[i])
	END IF 
	ls_find = "size = '" + dw_temp.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		ll_deal_qty = dw_temp.GetitemNumber(i, "deal_qty")
		dw_body.Setitem(ll_row, "deal_bf_"  + String(k), ll_deal_qty)
      lb_Chk = True
	END IF
NEXT

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return lb_chk
end function

public function boolean wf_deal ();Long i, k, ll_row_cnt, ll_assort_cnt 
Long ll_deal_qty, ll_chk_qty, ll_tot_qty

ll_row_cnt    = dw_body.RowCount() 
ll_assort_cnt = dw_assort.RowCount() 

IF ll_row_Cnt < 1 THEN Return False
 
dw_body.SetRedraw(False) 

FOR i = 1 TO ll_row_cnt 
	/* 배분잔량 체크 */
	ll_tot_qty = Long(dw_assort.Describe("evaluate('sum(chk_qty)',0)"))
	IF isnull(ll_tot_qty) OR ll_tot_qty = 0 THEN CONTINUE 
	FOR k = 1 TO ll_assort_cnt 
		ll_chk_qty  = dw_assort.Object.chk_qty[k]
		ll_deal_qty = dw_body.GetitemNumber(i, "deal_bf_" + String(k)) 
		IF ll_chk_qty = 0 OR ll_deal_qty = 0 THEN CONTINUE 
		/* 배분 잔량이 기준배분량 보다 작을경우 배분잔량으로 처리 */
		ll_deal_qty = Min(ll_deal_qty, ll_chk_qty)
		dw_body.Setitem(i, "deal_qty_"  + String(k), ll_deal_qty) 
		/* 배분 잔량 차감 */
		dw_assort.Setitem(k, "chk_qty", ll_chk_qty - ll_deal_qty)
	NEXT 
NEXT 
dw_body.SetRedraw(True) 

Return True
end function

public subroutine wf_retrieve_set ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt,  ll_assort_cnt 
Long   i, k,   ll_deal_qty

ll_row_cnt    = dw_db.RowCount()
IF ll_row_cnt < 1 THEN RETURN 

ll_assort_cnt = dw_assort.RowCount()

dw_body.SetRedraw(False) 
FOR i = 1 TO ll_row_cnt 
   ls_shop_cd =  dw_db.object.shop_cd[i] 
	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	IF ll_row < 1 THEN
	   ll_row     =  dw_body.insertRow(0)
      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm",   dw_db.object.shop_nm[i])
      dw_body.Setitem(ll_row, "shop_stat", dw_db.object.shop_stat[i])
	END IF 
	ls_find = "size = '" + dw_db.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		ll_deal_qty = dw_db.GetitemNumber(i, "deal_qty")
		dw_body.Setitem(ll_row, "deal_qty_"  + String(k), ll_deal_qty)
	END IF
NEXT

/* 입고배분일 경우 배분가능량에 추가로 표시 */
IF is_flag = '2' THEN 
	wf_add_stock()
END IF

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return
end subroutine

public subroutine wf_add_stock ();/* 배분내역이 존재할경우 배분가능량에 배분량만큼 추가로 처리*/
Long   k, ll_deal_qty, ll_stock_qty 
String ls_modify,      ls_Error

FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty  = dw_body.GetitemNumber(1, "c_deal_" + String(k)) 
	 ll_stock_qty = dw_assort.Object.stock_qty[k] + ll_deal_qty 
	 dw_assort.Setitem(k, "ord_qty", ll_stock_qty)
    ls_modify = 't_ord_'    + String(k) + '.text="' + String(ll_stock_qty) + '"'
    ls_Error  = dw_body.Modify(ls_modify)
    IF (ls_Error <> "") THEN 
		 MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		 Return 
	 END IF
NEXT

end subroutine

public function boolean wf_body_set ();String  ls_modify,   ls_error
String  ls_size 
Long    ll_ord_qty
integer i, k

/* assort 내역 조회 */
il_rows = dw_assort.Retrieve(is_to_style, is_to_chno, is_to_color, is_flag, is_house_cd)

/* 사이즈 셋 */

FOR i = 1 TO 20 
	IF i > il_rows THEN
      ls_modify = ' t_size_'   + String(i) + '.Visible=0' + &
                  ' t_'        + String(i) + '.Visible=0' + &
                  ' t_ord_'    + String(i) + '.Visible=0' + &
                  ' deal_bf_'  + String(i) + '.Visible=0' + &
                  ' deal_qty_' + String(i) + '.Visible=0' + &
                  ' c_bf_'     + String(i) + '.Visible=0' + &
                  ' c_deal_'   + String(i) + '.Visible=0'
   ELSE
	   ls_size     = dw_assort.object.size[i] 
	   ll_ord_qty  = dw_assort.object.ord_qty[i] 
      ls_modify = ' t_size_'   + String(i) + '.Text="' + ls_size + '"' + &
		            ' t_size_'   + String(i) + '.Visible=1' + &
                  ' t_'        + String(i) + '.Visible=1' + &
                  ' t_ord_'    + String(i) + '.text="' + String(ll_ord_qty) + '"' + &
		            ' t_ord_'    + String(i) + '.Visible=1' + & 
                  ' deal_bf_'  + String(i) + '.Visible=1' + &
                  ' deal_qty_' + String(i) + '.Visible=1' + &
                  ' c_bf_'     + String(i) + '.Visible=1' + &
                  ' c_deal_'   + String(i) + '.Visible=1'
	END IF
	ls_Error = dw_body.Modify(ls_modify)
	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		Return False
	END IF
NEXT 

Return True 
end function

on w_52011_e.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_assort=create dw_assort
this.dw_temp=create dw_temp
this.dw_db=create dw_db
this.st_remark=create st_remark
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_assort
this.Control[iCurrent+4]=this.dw_temp
this.Control[iCurrent+5]=this.dw_db
this.Control[iCurrent+6]=this.st_remark
this.Control[iCurrent+7]=this.gb_1
end on

on w_52011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_assort)
destroy(this.dw_temp)
destroy(this.dw_db)
destroy(this.st_remark)
destroy(this.gb_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "fr_style_no", "to_style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_style_chk(ls_style, ls_chno) THEN 
						IF as_column = "fr_style_no" THEN
							dw_head.Setitem(1, "fr_color", ls_color)
						ELSE
							dw_head.Setitem(1, "to_color", ls_color)
						END IF
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			if gs_brand <> 'K' then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"  + &
											 " and chno like '" + ls_chno + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				gst_cd.Item_where = ""
			end if	

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				IF as_column = "fr_style_no" THEN
    				dw_head.SetItem(al_row, "fr_style_no", lds_Source.GetItemString(1,"style_no"))
					dw_head.Setitem(al_row, "fr_color", ls_color)
				   dw_head.SetColumn("fr_color")
				ELSE
    				dw_head.SetItem(al_row, "to_style_no", lds_Source.GetItemString(1,"style_no"))
					dw_head.Setitem(al_row, "to_color", ls_color)
				   dw_head.SetColumn("to_color")
				END IF
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
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.12.11                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title, ls_style_no

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

ls_style_no = dw_head.GetItemString(1, "fr_style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"기준품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false
end if
is_fr_style = MidA(ls_style_no, 1, 8)
is_fr_Chno  = MidA(ls_style_no, 9, 1)

is_fr_color = dw_head.GetItemString(1, "fr_color")
if IsNull(is_fr_color) or Trim(is_fr_color) = "" then
   MessageBox(ls_title,"기준색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_color")
   return false
end if

ls_style_no = dw_head.GetItemString(1, "to_style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"코디품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_style_no")
   return false
end if
is_to_style = MidA(ls_style_no, 1, 8)
is_to_Chno  = MidA(ls_style_no, 9, 1)

is_to_color = dw_head.GetItemString(1, "to_color")
if IsNull(is_to_color) or Trim(is_to_color) = "" then
   MessageBox(ls_title,"코디색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_color")
   return false
end if

IF is_fr_style + is_fr_chno + is_fr_color = is_to_style + is_to_chno + is_to_color THEN 
   MessageBox(ls_title,"같은 품번,색상코드 입니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_style_no")
   return false
END IF	



if gs_brand = 'N' and (MidA(is_fr_style,1,1) = 'O' or MidA(is_fr_style,1,1) = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false
elseif gs_brand = 'O' and (MidA(is_fr_style,1,1) = 'N' or MidA(is_fr_style,1,1) = 'B' or MidA(is_fr_style,1,1) = 'L' or MidA(is_fr_style,1,1) = 'F' or MidA(is_fr_style,1,1) = 'G') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false	
elseif gs_brand = 'B' and (MidA(is_fr_style,1,1) = 'O' or MidA(is_fr_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false		
elseif gs_brand = 'G' and (MidA(is_fr_style,1,1) = 'O' or MidA(is_fr_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false			
end if	




IF is_flag = '2' THEN
   il_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
   if IsNull(il_deal_seq) then
      MessageBox(ls_title,"배분차수를 입력하십시요!")
      dw_head.SetFocus()
      dw_head.SetColumn("deal_seq")
      return false
   end if 
	
   is_house_cd = dw_head.GetItemString(1, "house_cd")
   if IsNull(is_house_cd) or Trim(is_house_cd) = ""  then
      MessageBox(ls_title,"출고창고를 입력하십시요!")
      dw_head.SetFocus()
      dw_head.SetColumn("house_cd")
      return false
   end if 
	
END IF

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"기준의뢰일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if


is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"출고의뢰일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_shop_brand = dw_head.GetItemString(1, "shop_brand")
if IsNull(is_shop_brand) or Trim(is_shop_brand) = "" then
   MessageBox(ls_title,"배분매장 브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_brand")
   return false
end if

return true
end event

event open;call super::open;is_flag = '1'

datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF


dw_head.setitem(1, "fr_ymd", string(ld_datetime, "YYYYMMDD"))
dw_head.setitem(1, "to_ymd",  string(ld_datetime, "YYYYMMDD"))
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
Long ll_row

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF wf_body_set() = FALSE THEN RETURN

il_rows = dw_temp.retrieve(is_fr_style, is_fr_chno, is_fr_color, is_fr_ymd, is_flag, is_shop_brand)
IF il_rows > 0 THEN 
	IF wf_temp_set() THEN 
		IF is_flag = '1' THEN 
			dw_db.DataObject = "d_52011_d03"
			dw_db.SetTransObject(SQLCA) 
			ll_row = dw_db.Retrieve(is_to_style, is_to_chno, is_to_color)
		ELSE
			dw_db.DataObject = "d_52011_d04"
			dw_db.SetTransObject(SQLCA) 
			ll_row = dw_db.Retrieve(is_to_style, is_to_chno, is_to_color, is_to_ymd, il_deal_seq)
		END IF 
		IF ll_row > 0 THEN 
			wf_retrieve_set() 
			IF is_flag = '1' THEN
			   st_remark.Text = "이미 배분된 내역이 있습니다."
				cb_delete.enabled = true
			ELSEIF dw_db.Object.proc_yn[1] = 'Y' THEN 
			   st_remark.Text = "이미 출고된 자료 입니다."
				cb_delete.enabled = false
			ELSE
			   st_remark.Text = "이미 배분된 내역이 있습니다."
				cb_delete.enabled = true
				
			END IF
			ib_NewDeal = False
		ELSE
			st_remark.Text = "배분된 처리중......."
			ib_NewDeal     = wf_deal()
			st_remark.Text = ""
		END IF
      dw_body.SetFocus() 
	ELSE 
		MessageBox("오류", "서로 같은 사이즈가 없습니다. ")
		Return 
	END IF
ELSE
	MessageBox("확인", "기준품번,색상으로 배분된 내역이 없습니다.")
	Return 
END IF

This.Trigger Event ue_button(1, il_rows)

IF ib_NewDeal THEN 
	ib_changed = true
   cb_update.enabled = true
   cb_excel.enabled = false
ELSEIF is_flag = '2' THEN 
	IF st_remark.Text = "이미 출고된 자료 입니다." THEN 
      dw_body.Enabled = False
	END IF
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_remark, "ScaleToRight")
dw_assort.SetTransObject(SQLCA)
dw_temp.SetTransObject(SQLCA)

end event

event ue_button;call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         rb_1.Enabled = false
         rb_2.Enabled = false
      end if
   CASE 5    /* 조건 */
      rb_1.enabled = true
      rb_2.enabled = true
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty, ll_resv_qty  
datetime ld_datetime
String   ls_shop_cd, ls_size, ls_find, ls_shop_div, ls_ErrMsg 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* ORDER량 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty = dw_body.GetitemNumber(1, "c_deal_" + String(k)) 
	 IF ll_deal_qty > dw_assort.Object.ord_qty[k] THEN 
		 MessageBox("오류", "[" + dw_assort.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 
		 Return -1 
	 END IF
NEXT

ll_assort_cnt = dw_assort.RowCount()
il_rows = 1 
FOR i=1 TO ll_row_count
	IF il_rows <> 1 THEN EXIT 
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
 //  IF idw_status = NewModified! OR idw_status = DataModified! THEN	
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
		ls_shop_div = MidA(ls_shop_cd, 2, 1)
      FOR k = 1 TO ll_assort_cnt 
		//	IF dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = DataModified! OR  dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = NewModified! THEN 
				ll_deal_qty = dw_body.GetitemNumber(i, "deal_qty_" + String(k))
				ls_size  = dw_assort.GetitemString(k, "size") 
//				ls_find  = "shop_cd = '" + ls_shop_cd + "' and size = '" + ls_size + "'" 
				ls_find  = "shop_cd = '" + ls_shop_cd + "' and color = '" + is_to_color + "' and size = '" + ls_size + "'"
				ll_find = dw_db.find(ls_find, 1, dw_db.RowCount())
				IF ll_find > 0 THEN
					ll_resv_qty = dw_db.GetitemNumber(ll_find, "deal_qty", Primary!, True)
					IF isnull(ll_resv_qty) THEN 
						ll_resv_qty = ll_deal_qty 
					ELSE
						ll_resv_qty = ll_deal_qty - ll_resv_qty 
					END IF
					dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_db.Setitem(ll_find, "mod_id",   gs_user_id)
               dw_db.Setitem(ll_find, "mod_dt",   ld_datetime)
					IF is_flag = '2' THEN
                  dw_db.Setitem(ll_find, "rshop_cd", is_house_cd ) 						
					END IF 					
					
				ELSE
					ll_find = dw_db.insertRow(0)
					IF is_flag = '2' THEN
					   dw_db.Setitem(ll_find, "deal_seq", il_deal_seq)
                  dw_db.Setitem(ll_find, "deal_fg",  '1') 
                  dw_db.Setitem(ll_find, "rshop_cd", is_house_cd ) 						
					END IF 
               dw_db.Setitem(ll_find, "out_ymd",  is_to_ymd)					
               dw_db.Setitem(ll_find, "style",    is_to_style)
               dw_db.Setitem(ll_find, "chno",     is_to_chno)
               dw_db.Setitem(ll_find, "shop_cd",  ls_shop_cd)
               dw_db.Setitem(ll_find, "color",    is_to_color)
               dw_db.Setitem(ll_find, "size",     ls_size)
               dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_db.Setitem(ll_find, "reg_id",   gs_user_id)
					ll_resv_qty = ll_deal_qty
				END IF
            /* 예약 재고량 처리 */
				IF is_flag = '2' THEN
	            IF gf_stresv_update (is_to_style, is_to_chno,  is_to_color, ls_size, &
				                     ls_shop_div, ll_resv_qty, is_house_cd, ls_ErrMsg) = FALSE THEN 
		            il_rows = -1
        			   EXIT
	            END IF
				END IF
			//END IF
		NEXT
  // END IF
NEXT

il_rows = dw_db.Update()

if il_rows = 1 then
	/* 작업용 datawindow 초기화(dw_body) */
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	IF isnull(ls_ErrMsg) = FALSE AND Trim(ls_ErrMsg) <> "" THEN 
		MessageBox("SQL 오류", ls_ErrMsg)
	END IF
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_delete;/*===========================================================================*/
/* 작성자      :                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/

//is_to_style, is_to_chno, is_to_color, is_to_ymd, il_deal_seq

	IF is_flag = '1' THEN
				
		delete from tb_52030_m
		where  style = :is_to_style
		and    chno  = :is_to_chno
		and    color = :is_to_color;
			
		commit  USING SQLCA;  
		MessageBox("알림!","삭제되었습니다!")
      cb_delete.enabled = false
				
	elseif is_flag = '2' THEN
				
  	   DECLARE SP_DelResv_Update PROCEDURE FOR SP_DelResv_Update  
         @YYMMDD   = :is_to_ymd,   
			@deal_seq = :il_deal_seq,
         @style    = :is_to_style,   
         @chno     = :is_to_chno,   
         @color    = :is_to_color  ;

		EXECUTE SP_DelResv_Update;
		commit  USING SQLCA;  
		MessageBox("알림!","삭제되었습니다!")
      cb_delete.enabled = false
		
	END IF

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52011_e","0")
end event

type cb_close from w_com010_e`cb_close within w_52011_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_52011_e
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_52011_e
boolean visible = false
integer taborder = 50
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52011_e
integer taborder = 30
end type

type cb_update from w_com010_e`cb_update within w_52011_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_52011_e
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_52011_e
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_52011_e
end type

type cb_excel from w_com010_e`cb_excel within w_52011_e
integer x = 2414
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_52011_e
integer x = 489
integer y = 232
integer width = 3099
integer height = 264
integer taborder = 20
string dataobject = "d_52011_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("fr_color", idw_fr_color)
idw_fr_color.SetTransObject(SQLCA)

This.GetChild("to_color", idw_to_color)
idw_to_color.SetTransObject(SQLCA)

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

This.GetChild("shop_brand", idw_shop_brand)
idw_shop_brand.SetTransObject(SQLCA)
idw_shop_brand.Retrieve('001')


string ls_filter_str
ls_filter_str = ''	
ls_filter_str = "shop_cd < '020000' or  shop_cd = 'A10000'  "
idw_house_cd.SetFilter(ls_filter_str)
idw_house_cd.Filter( )

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
String ls_yymmdd, ls_dep_ymd

CHOOSE CASE dwo.name
	CASE "to_ymd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "fr_style_no"
		IF ib_itemchanged THEN RETURN 1		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE  "to_style_no" 	 
		IF ib_itemchanged THEN RETURN 1

//		select dep_ymd 
//			into :ls_dep_ymd
//		from tb_12020_m a(nolock)
//		where  style = :data;
//		
//		if len(ls_dep_ymd) = 8  then 
//			  MessageBox("확인",ls_dep_ymd + "일자로 부진처리된 스타일입니다.. 영업 MD에 문의하세요.")
//			  Return 1			
//		end if
		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
END CHOOSE

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno

CHOOSE CASE dwo.name
	CASE "fr_color"
		ls_style = LeftA(This.Object.fr_style_no[1], 8)
		ls_chno  = RightA(This.Object.fr_style_no[1], 1)
		idw_fr_color.Retrieve(ls_style, ls_chno)
	CASE "to_color"
		ls_style = LeftA(This.Object.to_style_no[1], 8)
		ls_chno = RightA(This.Object.to_style_no[1], 1)
		idw_to_color.Retrieve(ls_style, ls_chno)
END CHOOSE


end event

type ln_1 from w_com010_e`ln_1 within w_52011_e
integer beginy = 496
integer endy = 496
end type

type ln_2 from w_com010_e`ln_2 within w_52011_e
integer beginy = 500
integer endy = 500
end type

type dw_body from w_com010_e`dw_body within w_52011_e
integer x = 0
integer y = 508
integer width = 3616
integer height = 1544
integer taborder = 40
string dataobject = "d_52011_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.04.15                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
IF LeftA(dwo.name, 8) = "deal_qty" and Long(Data) < 0 THEN
	RETURN 1
END IF 

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

type dw_print from w_com010_e`dw_print within w_52011_e
end type

type rb_1 from radiobutton within w_52011_e
event ue_keydown pbm_keydown
integer x = 46
integer y = 296
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "Order 배분"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key =  KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_flag = '1'

This.textcolor = Rgb(0,0,255)
rb_2.textcolor = Rgb(0,0,0) 
dw_head.Object.t_fr_ymd.visible = false
dw_head.Object.fr_ymd.visible = false
dw_head.Object.t_deal_seq.visible = false
dw_head.Object.deal_seq.visible = false

dw_head.Object.t_house_cd.visible = false
dw_head.Object.house_cd.visible = false
end event

type rb_2 from radiobutton within w_52011_e
event ue_keydown pbm_keydown
integer x = 46
integer y = 380
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "입고 배분"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key =  KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_flag = '2'

This.textcolor = Rgb(0,0,255)
rb_1.textcolor = Rgb(0,0,0) 
dw_head.Object.t_fr_ymd.visible = True
dw_head.Object.fr_ymd.visible = True
dw_head.Object.t_deal_seq.visible = True
dw_head.Object.deal_seq.visible = True

dw_head.Object.t_house_cd.visible = True
dw_head.Object.house_cd.visible = True

end event

type dw_assort from datawindow within w_52011_e
boolean visible = false
integer x = 613
integer y = 224
integer width = 942
integer height = 492
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_52011_d99"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_temp from datawindow within w_52011_e
boolean visible = false
integer x = 1783
integer y = 376
integer width = 1015
integer height = 676
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "Temp"
string dataobject = "d_52011_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_db from datawindow within w_52011_e
boolean visible = false
integer x = 2875
integer y = 352
integer width = 411
integer height = 432
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "db"
string dataobject = "d_52011_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type st_remark from statictext within w_52011_e
integer x = 14
integer y = 160
integer width = 1861
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_52011_e
integer x = 14
integer y = 244
integer width = 462
integer height = 228
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

