$PBExportHeader$w_56201_d.srw
$PBExportComments$판매형태별 매출현황
forward
global type w_56201_d from w_com010_d
end type
type dw_1 from datawindow within w_56201_d
end type
type cbx_1 from checkbox within w_56201_d
end type
type dw_2 from datawindow within w_56201_d
end type
type cbx_coupon from checkbox within w_56201_d
end type
end forward

global type w_56201_d from w_com010_d
integer width = 3685
integer height = 2284
dw_1 dw_1
cbx_1 cbx_1
dw_2 dw_2
cbx_coupon cbx_coupon
end type
global w_56201_d w_56201_d

type variables
String is_brand, is_FRM_DATE, IS_TO_DATE, is_shop_div, is_shop_cd , is_coupon, is_dotcom, is_opt, is_comm_fg
DataWindowChild idw_brand, idw_shop_div
end variables

on w_56201_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.dw_2=create dw_2
this.cbx_coupon=create cbx_coupon
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.cbx_coupon
end on

on w_56201_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.dw_2)
destroy(this.cbx_coupon)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
/*===========================================================================*/

IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_FRM_DATE, IS_TO_DATE, is_shop_div, is_shop_cd, is_coupon, is_dotcom, is_opt, is_comm_fg)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
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
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF



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


is_FRM_DATE = dw_head.GetItemsTRING(1, "FRM_DATE")
IF IsNull(is_FRM_DATE) OR is_FRM_DATE = "" THEN
   MessageBox(ls_title,"시작 년월일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("FRM_DATE")
   RETURN FALSE
END IF

is_TO_DATE = dw_head.GetItemSTRING(1, "TO_DATE")
IF IsNull(is_TO_DATE) OR is_TO_DATE = "" THEN
   MessageBox(ls_title,"시작 년월일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("TO_DATE")
   RETURN FALSE
END IF

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN 
	is_shop_cd = '%'
END IF

is_dotcom = dw_head.GetItemString(1, "dotcom")
is_opt = dw_head.GetItemString(1, "opt")
is_comm_fg = dw_head.GetItemString(1, "comm_fg")

if cbx_coupon.checked then 
	is_coupon = 'Y'
else 
	is_coupon = 'N'
end if

RETURN TRUE

end event

event ue_title();/*===========================================================================*/
/* 작성자      : 지우정보(김진백)                                            */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_shop_div

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id  + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_yymm.Text     = '" + String(is_FRM_DATE, '@@@@/@@/@@') + "'" + &
            "t_yymm1.Text    = '" + String(is_TO_DATE, '@@@@/@@/@@') + "'" + &				
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(),       "inter_display") + "'" + &
            "t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)

if is_coupon = 'Y' then
	dw_print.object.t_coupon.text = '(교환권 재매입)'
else
	dw_print.object.t_coupon.text = ''
end if


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
											 "  AND shop_seq  < '5000'"
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

event open;call super::open;/*===========================================================================*/
DateTime ld_datetime
String ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "YYYYMMDD")


dw_head.Setitem(1, "FRM_DATE", ls_datetime )
dw_head.Setitem(1, "TO_DATE", ls_datetime)
dw_head.Setitem(1, "shop_div", '%')

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56201_d","0")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

//dw_body.ShareData(dw_print)

//String  ls_shop_cd, ls_issue_date, ls_bill_no , ls_cust_cd
Long    i, ll_row, j
string  ls_shop_cd, ls_shop_nm, ls_shop_type, ls_shop_type_nm, ls_sale_type, ls_sale_type_nm
decimal ld_dc_rate, ld_sale_rate, ld_sale_qty, ld_tag_amt, ld_goods_amt, ld_sale_amt, ld_sale_collect, ld_io_amt

ll_row = dw_body.RowCount()
//dw_print.dataobject = "d_com561"
dw_print.SetTransObject(SQLCA)
dw_print.reset()
dw_print.accepttext()

//FOR i = 1 TO ll_row 
FOR i=ll_row to 1 step -1
    j = 0
	IF dw_body.object.check_yn[i] = 'Y' THEN 
		j = j+1
		ls_shop_cd 			= dw_body.GetitemString(i, "shop_cd")
		ls_shop_nm 			= dw_body.GetitemString(i, "shop_nm")
		ls_shop_type 		= dw_body.GetitemString(i, "shop_type")
		ls_shop_type_nm 	= dw_body.GetitemString(i, "shop_type_nm")
		ls_sale_type 		= dw_body.GetitemString(i, "sale_type")
		ls_sale_type_nm 	= dw_body.GetitemString(i, "sale_type_nm")
		ld_dc_rate 			= dw_body.Getitemnumber(i, "dc_rate")
		ld_sale_rate 		= dw_body.Getitemnumber(i, "sale_rate")
		ld_sale_qty 		= dw_body.Getitemnumber(i, "sale_qty")
		ld_tag_amt 			= dw_body.Getitemnumber(i, "tag_amt")
		ld_goods_amt 		= dw_body.Getitemnumber(i, "goods_amt")
		ld_sale_amt 		= dw_body.Getitemnumber(i, "sale_amt")
		ld_sale_collect	= dw_body.Getitemnumber(i, "sale_collect")
		ld_io_amt 			= dw_body.Getitemnumber(i, "io_amt")

		dw_print.insertrow(j)
		
		dw_print.setitem(j,'shop_cd',			ls_shop_cd)
		dw_print.setitem(j,'shop_nm',			ls_shop_nm)
		dw_print.setitem(j,'shop_type',		ls_shop_type)
		dw_print.setitem(j,'shop_type_nm',	ls_shop_type_nm)
		dw_print.setitem(j,'sale_type',		ls_sale_type)
		dw_print.setitem(j,'sale_type_nm',	ls_sale_type_nm)
		dw_print.setitem(j,'dc_rate',			ld_dc_rate)
		dw_print.setitem(j,'sale_rate',		ld_sale_rate)
		dw_print.setitem(j,'sale_qty',		ld_sale_qty)
		dw_print.setitem(j,'tag_amt',			ld_tag_amt)
		dw_print.setitem(j,'goods_amt',		ld_goods_amt)
		dw_print.setitem(j,'sale_amt',		ld_sale_amt)
		dw_print.setitem(j,'sale_collect',	ld_sale_collect)
		dw_print.setitem(j,'io_amt',			ld_io_amt)


/*
		dw_print.insertrow(i)
		dw_print.setitem(i,'shop_cd',			dw_body.GetitemString(i, "shop_cd"))
		dw_print.setitem(i,'shop_nm',			dw_body.GetitemString(i, "shop_nm"))
		dw_print.setitem(i,'shop_type',		dw_body.GetitemString(i, "shop_type"))
		dw_print.setitem(i,'shop_type_nm',	dw_body.GetitemString(i, "shop_type_nm"))
		dw_print.setitem(i,'sale_type',		dw_body.GetitemString(i, "sale_type"))
		dw_print.setitem(i,'sale_type_nm',	dw_body.GetitemString(i, "sale_type_nm"))
		dw_print.setitem(i,'dc_rate',			dw_body.Getitemnumber(i, "dc_rate"))
		dw_print.setitem(i,'sale_rate',		dw_body.Getitemnumber(i, "sale_rate"))
		dw_print.setitem(i,'sale_qty',		dw_body.Getitemnumber(i, "sale_qty"))
		dw_print.setitem(i,'tag_amt',			dw_body.Getitemnumber(i, "tag_amt"))
		dw_print.setitem(i,'goods_amt',		dw_body.Getitemnumber(i, "goods_amt"))
		dw_print.setitem(i,'sale_amt',		dw_body.Getitemnumber(i, "sale_amt"))
		dw_print.setitem(i,'sale_collect',	dw_body.Getitemnumber(i, "sale_collect"))
		dw_print.setitem(i,'io_amt',			dw_body.Getitemnumber(i, "io_amt"))
*/

		
		//messagebox("", is_yymm + "/" + ls_bill_no + "/" + ls_shop_cd + "/" + is_brand + "/" + ls_issue_date + "/" + ls_cust_cd )
//		IF dw_print.Retrieve(is_yymm, ls_bill_no, ls_shop_cd, is_brand, ls_issue_date, ls_cust_cd) > 0 THEN
//		dw_print.retrieve(is_brand, is_FRM_DATE, IS_TO_DATE, is_shop_div, is_shop_cd, is_coupon, is_dotcom, is_opt, is_comm_fg)
//			dw_print.Print()
//		END IF 
	end if
NEXT 

dw_print.inv_printpreview.of_SetZoom()
end event

type cb_close from w_com010_d`cb_close within w_56201_d
end type

type cb_delete from w_com010_d`cb_delete within w_56201_d
end type

type cb_insert from w_com010_d`cb_insert within w_56201_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56201_d
end type

type cb_update from w_com010_d`cb_update within w_56201_d
end type

type cb_print from w_com010_d`cb_print within w_56201_d
end type

type cb_preview from w_com010_d`cb_preview within w_56201_d
end type

type gb_button from w_com010_d`gb_button within w_56201_d
end type

type cb_excel from w_com010_d`cb_excel within w_56201_d
end type

type dw_head from w_com010_d`dw_head within w_56201_d
integer y = 148
integer width = 2935
integer height = 200
string dataobject = "d_56201_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')


This.GetChild("comm_fg", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('919')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.03                                                  */	
/* 수정일      : 2002.06.03                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56201_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_56201_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_56201_d
integer x = 9
integer y = 376
integer width = 3593
integer height = 1668
string dataobject = "d_56201_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;String  ls_shop_cd, ls_shop_nm, ls_shop_type, ls_shop_type_nm, ls_sale_type, ls_sale_type_nm 
String  ls_modify
Decimal ldc_dc_rate, ldc_sale_rate 

ls_shop_cd      = This.GetitemString(row, "shop_cd")
ls_shop_nm      = This.GetitemString(row, "shop_nm")
ls_shop_type    = This.GetitemString(row, "shop_type")
ls_shop_type_nm = This.GetitemString(row, "shop_type_nm")
ls_sale_type    = This.GetitemString(row, "sale_type")
ls_sale_type_nm = This.GetitemString(row, "sale_type_nm")
ldc_dc_rate     = This.GetitemDecimal(row, "dc_rate")
ldc_sale_rate   = This.GetitemDecimal(row, "sale_rate")

This.SelectRow(0,   False)
This.SelectRow(row, True)

dw_1.Retrieve(is_brand, is_FRM_DATE, IS_TO_DATE, ls_shop_cd, ls_shop_type, ls_sale_type, ldc_dc_rate, ldc_sale_rate, is_coupon, is_dotcom, is_comm_fg)

ls_modify = "t_shop_nm.Text = '" + ls_shop_nm + "' "  + &
            "t_shop_type.Text = '" + ls_shop_type_nm + "' " + &
            "t_sale_type.Text = '" + ls_sale_type_nm + "' " + &
            "t_dc_rate.Text = '" + String(ldc_dc_rate, "##0.00") + "' " + &
				"t_sale_rate.Text = '" + String(ldc_sale_rate, "##0.00") + "' " 
dw_1.Modify(ls_modify)				
dw_1.Visible = True

				
end event

event dw_body::buttonclicked;call super::buttonclicked;Long    i, ll_row_cnt  

this.accepttext()
if dwo.name = 'b_check' then
	ll_row_cnt = This.RowCount()
	if this.object.b_check.text = '전체선택' then		
		this.scrolltorow(0)
		IF ll_row_cnt < 1 THEN RETURN 
		FOR i = 1 TO ll_row_cnt 
			this.setitem(i,'check_yn','Y')
		NEXT
		this.modify("b_check.text = '전체해제'")
	else
		IF ll_row_cnt < 1 THEN RETURN 
		this.scrolltorow(0)
		FOR i = 1 TO ll_row_cnt 
			this.setitem(i,'check_yn','N')
		NEXT
		this.modify("b_check.text = '전체선택'")
	end if
end if
end event

event dw_body::itemchanged;call super::itemchanged;String  ls_check_yn
Long    i, ll_c_getrow, ll_c_rowcount

this.accepttext()
ls_check_yn   = This.GetitemString(row, "check_yn")
ll_c_getrow   = This.Getitemnumber(row, "c_getrow")
ll_c_rowcount = This.Getitemnumber(row, "c_rowcount")


if ls_check_yn = 'N' then
	FOR i = ll_c_getrow TO ll_c_getrow + ll_c_rowcount -1
		this.setitem(i,'check_yn','Y')
	NEXT
else
	FOR i = ll_c_getrow TO ll_c_getrow + ll_c_rowcount -1
		this.setitem(i,'check_yn','N')
	NEXT
end if

end event

type dw_print from w_com010_d`dw_print within w_56201_d
integer x = 453
integer y = 384
integer width = 2427
integer height = 804
string dataobject = "d_56201_r01"
end type

type dw_1 from datawindow within w_56201_d
boolean visible = false
integer x = 151
integer y = 384
integer width = 3291
integer height = 1636
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "일자별 내역"
string dataobject = "d_56201_d02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;IF dwo.name = 'b_close' THEN 
	This.Visible = FALSE
END IF
end event

event doubleclicked;String  ls_shop_cd, ls_shop_nm, ls_shop_type, ls_shop_type_nm, ls_sale_type, ls_sale_type_nm 
String  ls_modify, ls_yymmdd
Decimal ldc_dc_rate, ldc_sale_rate 

ls_yymmdd       = This.GetitemString(row, "yymmdd")
ls_shop_cd      = This.GetitemString(row, "shop_cd")
ls_shop_type    = This.GetitemString(row, "shop_type")
ls_sale_type    = This.GetitemString(row, "sale_type")
ldc_dc_rate     = This.GetitemDecimal(row, "dc_rate")
ldc_sale_rate   = This.GetitemDecimal(row, "sale_rate")

ls_shop_nm      = this.object.t_shop_nm.Text
ls_shop_type_nm = this.object.t_shop_type.Text
ls_sale_type_nm = this.object.t_sale_type.Text

This.SelectRow(0,   False)
This.SelectRow(row, True)


dw_2.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_sale_type, ldc_dc_rate, ldc_sale_rate, is_coupon, is_dotcom)

ls_modify = "t_shop_nm.Text = '" + ls_shop_nm + "' "  + &
            "t_shop_type.Text = '" + ls_shop_type_nm + "' " + &
            "t_sale_type.Text = '" + ls_sale_type_nm + "' " + &
            "t_dc_rate.Text = '" + String(ldc_dc_rate, "##0.00") + "' " + &
				"t_sale_rate.Text = '" + String(ldc_sale_rate, "##0.00") + "' " 
dw_2.Modify(ls_modify)		


dw_2.Visible = True

end event

type cbx_1 from checkbox within w_56201_d
integer x = 3054
integer y = 168
integer width = 544
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "쇼핑몰 실입금액"
borderstyle borderstyle = stylelowered!
end type

event clicked;if cbx_1.checked  then
	dw_1.DataObject  = 'd_56201_d04'
	dw_body.DataObject  = 'd_56201_d03'
	dw_print.DataObject = 'd_56201_r03'
	
	dw_1.SetTransObject(SQLCA)
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
else 
	dw_1.DataObject  = 'd_56201_d02'
	dw_body.DataObject  = 'd_56201_d01'
	dw_print.DataObject = 'd_56201_r01'
	
	dw_1.SetTransObject(SQLCA)
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
end if
end event

type dw_2 from datawindow within w_56201_d
boolean visible = false
integer x = 466
integer y = 572
integer width = 3291
integer height = 1636
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "일자별상세"
string dataobject = "d_56201_d12"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;This.Visible = FALSE
end event

type cbx_coupon from checkbox within w_56201_d
integer x = 3054
integer y = 228
integer width = 530
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "교환권재매입"
borderstyle borderstyle = stylelowered!
end type

