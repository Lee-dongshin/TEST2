$PBExportHeader$w_53054_d.srw
$PBExportComments$점간 이송 승인
forward
global type w_53054_d from w_com010_d
end type
type gb_1 from groupbox within w_53054_d
end type
type dw_out from u_dw within w_53054_d
end type
type rb_1 from radiobutton within w_53054_d
end type
type rb_2 from radiobutton within w_53054_d
end type
type dw_rtn from u_dw within w_53054_d
end type
end forward

global type w_53054_d from w_com010_d
integer width = 3685
integer height = 2280
gb_1 gb_1
dw_out dw_out
rb_1 rb_1
rb_2 rb_2
dw_rtn dw_rtn
end type
global w_53054_d w_53054_d

type variables
DataWindowChild idw_brand, idw_fr_shop_type, idw_to_shop_type, idw_fr_shop_div, idw_to_shop_div

String is_brand, is_ymd_st, is_ymd_ed, is_yymmdd, is_proc_yn, is_fr_shop_cd, is_to_shop_cd
String is_fr_shop_type, is_to_shop_type, is_fr_shop_div, is_to_shop_div, is_gubun,is_data_opt

end variables

forward prototypes
public subroutine wf_amt_set (long al_row, long al_qty)
public function boolean wf_rtrn_margin_set (long al_row, string as_style, string as_fr_shop_cd, string as_fr_shop_type)
public function boolean wf_rtrn_margin_set_color (long al_row, string as_style, string as_color, string as_fr_shop_cd, string as_fr_shop_type)
public function boolean wf_style_set_color (long al_row, string as_style, string as_color, string as_to_shop_cd, string as_to_shop_type)
public function integer wf_data_set (long al_body_row, string as_bill_no, string as_no)
public function integer wf_rtrn_set (long al_body_row, string as_bill_no, string as_no)
public function boolean wf_style_set (long al_row, string as_style, string as_to_shop_cd, string as_to_shop_type)
end prototypes

public subroutine wf_amt_set (long al_row, long al_qty);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_curr_price, ll_out_price	//ll_tag_price, 
Long ll_out_amt 
Decimal ldc_marjin


Long ll_rtn_curr_price, ll_rtn_out_price	//ll_tag_price, 
Long ll_rtn_out_amt 
Decimal ldc_rtn_marjin

//ll_tag_price  = dw_body.GetitemDecimal(al_row, "tag_price"     ) 
ll_curr_price = dw_body.GetitemNumber (al_row, "out_curr_price") 
ll_out_price  = dw_body.GetitemNumber (al_row, "out_out_price" ) 
ll_out_amt    = ll_out_price * al_qty   

//dw_body.Setitem(al_row, "tag_amt",      ll_tag_price  * al_qty)
dw_body.Setitem(al_row, "out_curr_amt", ll_curr_price * al_qty)
dw_body.Setitem(al_row, "out_collect",  ll_out_amt            ) 
dw_body.Setitem(al_row, "out_vat",      ll_out_amt - Round(ll_out_amt / 1.1, 0))


//ll_tag_price  = dw_body.GetitemDecimal(al_row, "tag_price"     ) 
ll_rtn_curr_price = dw_body.GetitemNumber (al_row, "rtn_curr_price") 
ll_rtn_out_price  = dw_body.GetitemNumber (al_row, "rtn_out_price" ) 
ll_rtn_out_amt    = ll_rtn_out_price * al_qty   

//dw_body.Setitem(al_row, "tag_amt",      ll_tag_price  * al_qty)
dw_body.Setitem(al_row, "rtn_curr_amt", ll_rtn_curr_price * al_qty)
dw_body.Setitem(al_row, "rtn_collect",  ll_rtn_out_amt            ) 
dw_body.Setitem(al_row, "rtn_vat",      ll_rtn_out_amt - Round(ll_rtn_out_amt / 1.1, 0))

end subroutine

public function boolean wf_rtrn_margin_set (long al_row, string as_style, string as_fr_shop_cd, string as_fr_shop_type);String  ls_style, ls_to_ymd, ls_sale_type_chk = space(2)
Long    ll_row, ll_dc_rate_chk, ll_curr_price_chk, ll_out_price_chk
Decimal ldc_margin_chk

String  ls_null,        ls_sale_type = space(2)
Long    ll_curr_price,  ll_out_price
decimal ldc_margin, ldc_dc_rate

SetNull(ls_null) 

/*  마진율 체크 */
IF gf_out_marjin (is_yymmdd,    as_fr_shop_cd, as_fr_shop_type, as_style, & 
						ls_sale_type, ldc_margin,    ldc_dc_rate,      ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

/* 단가 및 율 등록 */
dw_body.Setitem(al_row, "rtn_sale_type",   ls_sale_type )
dw_body.Setitem(al_row, "rtn_margin_rate", ldc_margin   )
dw_body.Setitem(al_row, "rtn_disc_rate",   ldc_dc_rate   )
dw_body.Setitem(al_row, "rtn_curr_price",  ll_curr_price)
dw_body.Setitem(al_row, "rtn_out_price",   ll_out_price )

/* 금액 처리 */
wf_amt_set(al_row, dw_body.GetItemDecimal(al_row, "move_qty"))

RETURN True

end function

public function boolean wf_rtrn_margin_set_color (long al_row, string as_style, string as_color, string as_fr_shop_cd, string as_fr_shop_type);String  ls_style, ls_to_ymd, ls_sale_type_chk = space(2)
Long    ll_row, ll_dc_rate_chk, ll_curr_price_chk, ll_out_price_chk
Decimal ldc_margin_chk

String  ls_null,        ls_sale_type = space(2)
Long    ll_curr_price,  ll_out_price
decimal ldc_margin, ldc_dc_rate

SetNull(ls_null) 

/*  마진율 체크 */
IF gf_outmarjin_color (is_yymmdd,    as_fr_shop_cd, as_fr_shop_type, as_style, as_color, & 
						ls_sale_type, ldc_margin,    ldc_dc_rate,      ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

/* 단가 및 율 등록 */
dw_body.Setitem(al_row, "rtn_sale_type",   ls_sale_type )
dw_body.Setitem(al_row, "rtn_margin_rate", ldc_margin   )
dw_body.Setitem(al_row, "rtn_disc_rate",   ldc_dc_rate   )
dw_body.Setitem(al_row, "rtn_curr_price",  ll_curr_price)
dw_body.Setitem(al_row, "rtn_out_price",   ll_out_price )

/* 금액 처리 */
wf_amt_set(al_row, dw_body.GetItemDecimal(al_row, "move_qty"))

RETURN True

end function

public function boolean wf_style_set_color (long al_row, string as_style, string as_color, string as_to_shop_cd, string as_to_shop_type);String  ls_style, ls_to_ymd, ls_sale_type_chk = space(2)
Long    ll_row, ll_dc_rate_chk, ll_curr_price_chk, ll_out_price_chk
Decimal ldc_margin_chk

String  ls_null,        ls_sale_type = space(2)
Long    ll_curr_price,  ll_out_price
decimal ldc_margin, ldc_dc_rate

SetNull(ls_null) 

/* 인수(출고)시 마진율 체크 */
IF gf_outmarjin_color (is_yymmdd,    as_to_shop_cd, as_to_shop_type, as_style, as_color, & 
						ls_sale_type, ldc_margin,    ldc_dc_rate,      ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

/* 단가 및 율 등록 */
dw_body.Setitem(al_row, "out_sale_type",   ls_sale_type )
dw_body.Setitem(al_row, "out_margin_rate", ldc_margin   )
dw_body.Setitem(al_row, "out_disc_rate",   ldc_dc_rate   )
dw_body.Setitem(al_row, "out_curr_price",  ll_curr_price)
dw_body.Setitem(al_row, "out_out_price",   ll_out_price )

/* 금액 처리 */
wf_amt_set(al_row, dw_body.GetItemDecimal(al_row, "move_qty"))

RETURN True

end function

public function integer wf_data_set (long al_body_row, string as_bill_no, string as_no);Long ll_row

ll_row = dw_out.InsertRow(0)

dw_out.SetItem(ll_row, "yymmdd",        is_yymmdd      )
dw_out.SetItem(ll_row, "shop_cd",       dw_body.GetItemString (al_body_row, "to_shop_cd")  )
dw_out.SetItem(ll_row, "shop_type",     dw_body.GetItemString (al_body_row, "to_shop_type"))
dw_out.SetItem(ll_row, "out_no",        as_bill_no     )
dw_out.SetItem(ll_row, "house_cd",      '990000'       )
dw_out.SetItem(ll_row, "jup_gubn",      'O2'           )
dw_out.SetItem(ll_row, "out_type",      'A'            )
dw_out.SetItem(ll_row, "sale_type",     dw_body.GetItemString (al_body_row, "out_sale_type")  )
dw_out.SetItem(ll_row, "margin_rate",   dw_body.GetItemDecimal(al_body_row, "out_margin_rate"))
dw_out.SetItem(ll_row, "disc_rate",     dw_body.GetItemDecimal(al_body_row, "out_disc_rate")  )
dw_out.SetItem(ll_row, "no",            as_no          )
dw_out.SetItem(ll_row, "style",         dw_body.GetItemString (al_body_row, "style"))
dw_out.SetItem(ll_row, "chno",          dw_body.GetItemString (al_body_row, "chno") )
dw_out.SetItem(ll_row, "color",         dw_body.GetItemString (al_body_row, "color"))
dw_out.SetItem(ll_row, "size",          dw_body.GetItemString (al_body_row, "size") )
dw_out.SetItem(ll_row, "class",         'A'            )
dw_out.SetItem(ll_row, "tag_price",     dw_body.GetItemDecimal(al_body_row, "tag_price")     )
dw_out.SetItem(ll_row, "curr_price",    dw_body.GetItemNumber (al_body_row, "out_curr_price"))
dw_out.SetItem(ll_row, "out_price",     dw_body.GetItemNumber (al_body_row, "out_out_price") )
dw_out.SetItem(ll_row, "qty",           dw_body.GetItemDecimal(al_body_row, "move_qty")      )
dw_out.SetItem(ll_row, "tag_amt",       dw_body.GetItemDecimal(al_body_row, "tag_amt")       )
dw_out.SetItem(ll_row, "curr_amt",      dw_body.GetItemDecimal(al_body_row, "out_curr_amt")  )
dw_out.SetItem(ll_row, "out_collect",   dw_body.GetItemDecimal(al_body_row, "out_collect")   )
dw_out.SetItem(ll_row, "vat",           dw_body.GetItemDecimal(al_body_row, "out_vat")       )
dw_out.SetItem(ll_row, "rot_shop",      dw_body.GetItemString (al_body_row, "fr_shop_cd")    )
dw_out.SetItem(ll_row, "rot_shop_type", dw_body.GetItemString (al_body_row, "fr_shop_type")  )
dw_out.SetItem(ll_row, "brand",         is_brand       )
dw_out.SetItem(ll_row, "year",          dw_body.GetItemString (al_body_row, "year")  )
dw_out.SetItem(ll_row, "season",        dw_body.GetItemString (al_body_row, "season"))
dw_out.SetItem(ll_row, "item",          dw_body.GetItemString (al_body_row, "item")  )
dw_out.SetItem(ll_row, "sojae",         dw_body.GetItemString (al_body_row, "sojae") )
dw_out.SetItem(ll_row, "reg_id",        gs_user_id     )

Return 0

end function

public function integer wf_rtrn_set (long al_body_row, string as_bill_no, string as_no);Long ll_row

ll_row = dw_rtn.InsertRow(0)
	
	dw_rtn.SetItem(ll_row, "yymmdd",        is_yymmdd      )
	
	dw_rtn.SetItem(ll_row, "shop_cd",       dw_body.GetItemString (al_body_row, "fr_shop_cd")  )
	dw_rtn.SetItem(ll_row, "shop_type",     dw_body.GetItemString (al_body_row, "fr_shop_type"))
	
	dw_rtn.SetItem(ll_row, "out_no",        as_bill_no     )
	dw_rtn.SetItem(ll_row, "house_cd",      '990000'       )
	dw_rtn.SetItem(ll_row, "jup_gubn",      'O2'           )
	dw_rtn.SetItem(ll_row, "sale_type",     dw_body.GetItemString (al_body_row, "rtn_sale_type")  )
	dw_rtn.SetItem(ll_row, "margin_rate",   dw_body.GetItemDecimal(al_body_row, "rtn_margin_rate"))
	dw_rtn.SetItem(ll_row, "disc_rate",     dw_body.GetItemDecimal(al_body_row, "rtn_disc_rate")  )
	dw_rtn.SetItem(ll_row, "no",            as_no          )
	dw_rtn.SetItem(ll_row, "style",         dw_body.GetItemString (al_body_row, "style"))
	dw_rtn.SetItem(ll_row, "chno",          dw_body.GetItemString (al_body_row, "chno") )
	dw_rtn.SetItem(ll_row, "color",      	 dw_body.GetItemString (al_body_row, "color"))
	dw_rtn.SetItem(ll_row, "size",       	 dw_body.GetItemString (al_body_row, "size") )
	dw_rtn.SetItem(ll_row, "class",         'A'            )
	dw_rtn.SetItem(ll_row, "tag_price",     dw_body.GetItemDecimal(al_body_row, "tag_price")     )
	dw_rtn.SetItem(ll_row, "curr_price",    dw_body.GetItemNumber (al_body_row, "rtn_curr_price"))
	dw_rtn.SetItem(ll_row, "out_price",     dw_body.GetItemNumber (al_body_row, "rtn_out_price") )
	dw_rtn.SetItem(ll_row, "qty",           dw_body.GetItemDecimal(al_body_row, "move_qty")      )
	dw_rtn.SetItem(ll_row, "tag_amt",       dw_body.GetItemDecimal(al_body_row, "tag_amt")       )
	dw_rtn.SetItem(ll_row, "curr_amt",      dw_body.GetItemDecimal(al_body_row, "rtn_curr_amt")  )
	dw_rtn.SetItem(ll_row, "rtrn_collect",  dw_body.GetItemDecimal(al_body_row, "rtn_collect")  )
	dw_rtn.SetItem(ll_row, "vat",           dw_body.GetItemDecimal(al_body_row, "rtn_vat")       )
	dw_rtn.SetItem(ll_row, "rot_shop",      dw_body.GetItemString (al_body_row, "to_shop_cd")  )
	dw_rtn.SetItem(ll_row, "rot_shop_type", dw_body.GetItemString (al_body_row, "to_shop_type")   )
	dw_rtn.SetItem(ll_row, "brand",         is_brand       )
	dw_rtn.SetItem(ll_row, "year",          dw_body.GetItemString (al_body_row, "year")  )
	dw_rtn.SetItem(ll_row, "season",        dw_body.GetItemString (al_body_row, "season"))
	dw_rtn.SetItem(ll_row, "item",          dw_body.GetItemString (al_body_row, "item")  )
	dw_rtn.SetItem(ll_row, "sojae",         dw_body.GetItemString (al_body_row, "sojae") )
	dw_rtn.SetItem(ll_row, "reg_id",        gs_user_id     )
	
Return 0

end function

public function boolean wf_style_set (long al_row, string as_style, string as_to_shop_cd, string as_to_shop_type);String  ls_style, ls_to_ymd, ls_sale_type_chk = space(2)
Long    ll_row, ll_dc_rate_chk, ll_curr_price_chk, ll_out_price_chk
Decimal ldc_margin_chk

String  ls_null,        ls_sale_type = space(2)
Long    ll_curr_price,  ll_out_price
decimal ldc_margin, ldc_dc_rate

SetNull(ls_null) 

/* 인수(출고)시 마진율 체크 */
IF gf_out_marjin (is_yymmdd,    as_to_shop_cd, as_to_shop_type, as_style, & 
						ls_sale_type, ldc_margin,    ldc_dc_rate,      ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

/* 단가 및 율 등록 */
dw_body.Setitem(al_row, "out_sale_type",   ls_sale_type )
dw_body.Setitem(al_row, "out_margin_rate", ldc_margin   )
dw_body.Setitem(al_row, "out_disc_rate",   ldc_dc_rate   )
dw_body.Setitem(al_row, "out_curr_price",  ll_curr_price)
dw_body.Setitem(al_row, "out_out_price",   ll_out_price )

/* 금액 처리 */
wf_amt_set(al_row, dw_body.GetItemDecimal(al_row, "move_qty"))

RETURN True

end function

on w_53054_d.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.dw_out=create dw_out
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_rtn=create dw_rtn
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_out
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.dw_rtn
end on

on w_53054_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.dw_out)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_rtn)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.06                                                  */	
/* 수정일      : 2002.03.06                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_ymd_st, is_ymd_ed, is_proc_yn, &
									is_fr_shop_cd, is_to_shop_cd, is_fr_shop_type, is_to_shop_type, &
									is_fr_shop_div, is_to_shop_div)

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

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

is_ymd_st = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
IF IsNull(is_ymd_st) OR is_ymd_st = "" THEN
   MessageBox(ls_title,"시작 일자를  입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_ymd_ed = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
IF IsNull(is_ymd_ed) OR is_ymd_ed = "" THEN
   MessageBox(ls_title,"종료 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

IF is_ymd_st > is_ymd_ed THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE 
END IF

IF DaysAfter(Date(String(is_ymd_st, '@@@@/@@/@@')), Date(String(is_ymd_ed, '@@@@/@@/@@'))) > 60 then
	MessageBox("오류","기간이 60일을 넘었습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
	RETURN FALSE 
END IF

is_proc_yn = Trim(dw_head.GetItemString(1, "proc_yn"))
IF IsNull(is_proc_yn) OR is_proc_yn = "" THEN
   MessageBox(ls_title,"승인 유무를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_yn")
   RETURN FALSE
END IF

is_yymmdd = Trim(String(dw_head.GetItemDate(1, "yymmdd"), 'yyyymmdd'))
IF IsNull(is_yymmdd) OR is_yymmdd = "" THEN
   MessageBox(ls_title,"승인 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   RETURN FALSE
END IF

is_fr_shop_cd = Trim(dw_head.GetItemString(1, "fr_shop_cd"))
IF IsNull(is_fr_shop_cd) OR is_fr_shop_cd = "" THEN is_fr_shop_cd = '%'

is_fr_shop_type = Trim(dw_head.GetItemString(1, "fr_shop_type"))
IF IsNull(is_fr_shop_type) OR is_fr_shop_type = "" THEN
   MessageBox(ls_title,"발송매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_shop_type")
   RETURN FALSE
END IF

is_fr_shop_div = Trim(dw_head.GetItemString(1, "fr_shop_div"))
IF IsNull(is_fr_shop_div) OR is_fr_shop_div = "" THEN
   MessageBox(ls_title,"발송매장 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_shop_div")
   RETURN FALSE
END IF

is_to_shop_cd = Trim(dw_head.GetItemString(1, "to_shop_cd"))
IF IsNull(is_to_shop_cd) OR is_to_shop_cd = "" THEN is_to_shop_cd = '%'

is_to_shop_type = Trim(dw_head.GetItemString(1, "to_shop_type"))
IF IsNull(is_to_shop_type) OR is_to_shop_type = "" THEN
   MessageBox(ls_title,"인수매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_type")
   RETURN FALSE
END IF

is_to_shop_div = Trim(dw_head.GetItemString(1, "to_shop_div"))
IF IsNull(is_to_shop_div) OR is_to_shop_div = "" THEN
   MessageBox(ls_title,"인수매장 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_div")
   RETURN FALSE
END IF

RETURN TRUE

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/

String     ls_shop_nm, ls_brand, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "fr_shop_cd"
		ls_brand = Trim(dw_head.GetItemString(1, "brand"))
		IF IsNull(ls_brand) OR ls_brand = "" THEN
			MessageBox("입력오류", "브랜드 코드를 먼저 입력하십시요!")
			dw_head.SetItem(al_row, "fr_shop_cd", "")
			dw_head.SetItem(al_row, "fr_shop_nm", "")
			dw_head.SetColumn("brand")
			RETURN 1
		END IF
		
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "fr_shop_nm", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) <> ls_brand THEN
				MessageBox("입력오류", "브랜드가 다릅니다!")
				dw_head.SetItem(al_row, "fr_shop_cd", "")
				dw_head.SetItem(al_row, "fr_shop_nm", "")
				RETURN 1
			END IF
				
			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "fr_shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' AND SHOP_STAT = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "fr_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "fr_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("fr_shop_type")
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY  lds_Source
	CASE "to_shop_cd"
		ls_brand = Trim(dw_head.GetItemString(1, "brand"))
		IF IsNull(ls_brand) OR ls_brand = "" THEN
			MessageBox("입력오류", "브랜드 코드를 먼저 입력하십시요!")
			dw_head.SetItem(al_row, "to_shop_cd", "")
			dw_head.SetItem(al_row, "to_shop_nm", "")
			dw_head.SetColumn("brand")
			RETURN 1
		END IF

		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "to_shop_nm", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) <> ls_brand THEN
				MessageBox("입력오류", "브랜드가 다릅니다!")
				dw_head.SetItem(al_row, "to_shop_cd", "")
				dw_head.SetItem(al_row, "to_shop_nm", "")
				RETURN 1
			END IF

			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' AND SHOP_STAT = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("to_shop_type")
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY  lds_Source
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.06                                                  */	
/* 수정일      : 2002.03.06                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime
String ls_proc_yn, ls_fr_shop_nm, ls_to_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

IF is_proc_yn = 'Y' THEN
	ls_proc_yn = '승인'
ELSEIF is_proc_yn = 'N' THEN
	ls_proc_yn = '미승인'
ELSE
	ls_proc_yn = '전체'
END IF

IF is_fr_shop_cd = '%' THEN
	ls_fr_shop_nm = '전체'
ELSE
	ls_fr_shop_nm = dw_head.GetItemString(1, "fr_shop_nm")
END IF

IF is_to_shop_cd = '%' THEN
	ls_to_shop_nm = '전체'
ELSE
	ls_to_shop_nm = dw_head.GetItemString(1, "to_shop_nm")
END IF

ls_modify =	"t_pg_id.Text        = '" + is_pgm_id     + "'" + &
            "t_user_id.Text      = '" + gs_user_id    + "'" + &
            "t_datetime.Text     = '" + ls_datetime   + "'" + &
            "t_brand.Text        = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_ymd_st.Text       = '" + String(is_ymd_st, '@@@@/@@/@@') + "'" + &
            "t_ymd_ed.Text       = '" + String(is_ymd_ed, '@@@@/@@/@@') + "'" + &
            "t_proc_yn.Text      = '" + ls_proc_yn    + "'" + &
            "t_yymmdd.Text       = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_fr_shop_cd.Text   = '" + is_fr_shop_cd + " " + ls_fr_shop_nm + "'" + &
            "t_fr_shop_type.Text = '" + idw_fr_shop_type.GetItemString(idw_fr_shop_type.GetRow(), "inter_display") + "'" + &
            "t_fr_shop_div.Text  = '" + idw_fr_shop_div.GetItemString(idw_fr_shop_div.GetRow(), "inter_display") + "'" + &
            "t_to_shop_cd.Text   = '" + is_to_shop_cd + " " + ls_to_shop_nm + "'" + &
            "t_to_shop_type.Text = '" + idw_to_shop_type.GetItemString(idw_to_shop_type.GetRow(), "inter_display") + "'" + &
            "t_to_shop_div.Text  = '" + idw_to_shop_div.GetItemString(idw_to_shop_div.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         rb_1.Enabled = false
         rb_2.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
		rb_1.Enabled = true
		rb_2.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.05.28                                                  */	
/* 수정일      : 2002.05.28                                                  */
/*===========================================================================*/
Long i, ll_row_count, ll_out_rows,ll_rtrn_rows	//ll_out_row = 0, 
String ls_out_no, ls_style, ls_color, ls_to_shop_cd, ls_to_shop_type	//ls_out_row, 
String ls_rtn_out_no, ls_fr_shop_cd, ls_fr_shop_type	//ls_out_row, 
Decimal ldc_move_qty
Datetime ld_datetime

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF is_data_opt = "V" THEN
	MessageBox("경고", "저장권한이 없습니다 !") 
	Return 0
END IF

dw_out.Reset()
dw_rtn.Reset()

ll_row_count = dw_body.RowCount()

FOR i = 1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, "proc_yn", Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
		If dw_body.GetItemString(i, "proc_yn") = 'Y' Then
			ls_style = dw_body.GetItemString(i, "style")
			ls_color = dw_body.GetItemString(i, "color")
			
			ls_to_shop_cd   = dw_body.GetItemString(i, "to_shop_cd")
			ls_to_shop_type = dw_body.GetItemString(i, "to_shop_type")
			
			ls_fr_shop_cd   = dw_body.GetItemString(i, "fr_shop_cd")
			ls_fr_shop_type = dw_body.GetItemString(i, "fr_shop_type")
			

			// 마진율 계산
			If wf_style_set_color(i, ls_style, ls_color, ls_to_shop_cd, ls_to_shop_type) = False Then
				MessageBox("저장오류", "마진율 계산에 실패하였습니다!")
				Return -1

			// 출고번호 채번
			End If
			If gf_style_outno(is_yymmdd, is_brand, ls_out_no) = False Then
				MessageBox("저장오류", "출고번호 채번에 실패하였습니다!")
				Return -1
			End IF

//			ll_out_row++
//			ls_out_row = String(ll_out_row, '0000')
			wf_data_set(i, ls_out_no, '0001')
			
			dw_body.Setitem(i, "to_ymd",    is_yymmdd  )
			dw_body.Setitem(i, "to_out_no", ls_out_no  )
			dw_body.Setitem(i, "to_no",     '0001' )


			// 마진율 계산
			If wf_rtrn_margin_set_color(i, ls_style, ls_color, ls_fr_shop_cd, ls_fr_shop_type) = False Then
				MessageBox("저장오류", "마진율 계산에 실패하였습니다!")
				Return -1
			End If

			// 출고번호 채번
			If gf_style_outno(is_yymmdd, is_brand, ls_rtn_out_no) = False Then
				MessageBox("저장오류", "출고번호 채번에 실패하였습니다!")
				Return -1
			End IF

			wf_rtrn_set(i, ls_rtn_out_no, '0001')
			
			dw_body.Setitem(i, "rtrn_ymd",    is_yymmdd  )
			dw_body.Setitem(i, "rtrn_outno",  ls_rtn_out_no  )
			dw_body.Setitem(i, "rtrn_no",     '0001' )
			
			
			dw_body.Setitem(i, "mod_id",    gs_user_id )
			dw_body.Setitem(i, "mod_dt",    ld_datetime)
		Else
			dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
		End If
   END IF
NEXT

il_rows      = dw_body.Update(TRUE, FALSE)
ll_out_rows  = dw_out. Update(TRUE, FALSE)
ll_rtrn_rows = dw_rtn. Update(TRUE, FALSE)

if il_rows = 1 and ll_out_rows = 1 then
   dw_body.ResetUpdate()
   dw_out. ResetUpdate()
   dw_rtn. ResetUpdate()	
   commit USING SQLCA;
	dw_body.retrieve(is_brand, is_ymd_st, is_ymd_ed, is_proc_yn, &
						  is_fr_shop_cd, is_to_shop_cd, is_fr_shop_type, is_to_shop_type, &
						  is_fr_shop_div, is_to_shop_div)
else
   rollback USING SQLCA;
	il_rows = -1
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_preopen();call super::pfc_preopen;dw_out.SetTransObject(SQLCA)
dw_rtn.SetTransObject(SQLCA)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53054_d","0")
end event

event open;call super::open;select data_level
into :is_data_opt
from tb_93010_m
where person_id = :gs_user_id;


end event

type cb_close from w_com010_d`cb_close within w_53054_d
end type

type cb_delete from w_com010_d`cb_delete within w_53054_d
end type

type cb_insert from w_com010_d`cb_insert within w_53054_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53054_d
end type

type cb_update from w_com010_d`cb_update within w_53054_d
boolean visible = true
end type

type cb_print from w_com010_d`cb_print within w_53054_d
end type

type cb_preview from w_com010_d`cb_preview within w_53054_d
end type

type gb_button from w_com010_d`gb_button within w_53054_d
end type

type cb_excel from w_com010_d`cb_excel within w_53054_d
end type

type dw_head from w_com010_d`dw_head within w_53054_d
integer x = 311
integer y = 156
integer width = 3255
integer height = 312
string dataobject = "d_53054_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("fr_shop_type", idw_fr_shop_type)
idw_fr_shop_type.SetTransObject(SQLCA)
idw_fr_shop_type.Retrieve('911')
idw_fr_shop_type.InsertRow(1)
idw_fr_shop_type.SetItem(1, "inter_cd", '%')
idw_fr_shop_type.SetItem(1, "inter_nm", '전체')

This.GetChild("to_shop_type", idw_to_shop_type)
idw_to_shop_type.SetTransObject(SQLCA)
idw_to_shop_type.Retrieve('911')
idw_to_shop_type.InsertRow(1)
idw_to_shop_type.SetItem(1, "inter_cd", '%')
idw_to_shop_type.SetItem(1, "inter_nm", '전체')

This.GetChild("fr_shop_div", idw_fr_shop_div)
idw_fr_shop_div.SetTransObject(SQLCA)
idw_fr_shop_div.Retrieve('910')
idw_fr_shop_div.InsertRow(1)
idw_fr_shop_div.SetItem(1, "inter_cd", '%')
idw_fr_shop_div.SetItem(1, "inter_nm", '전체')

This.GetChild("to_shop_div", idw_to_shop_div)
idw_to_shop_div.SetTransObject(SQLCA)
idw_to_shop_div.Retrieve('910')
idw_to_shop_div.InsertRow(1)
idw_to_shop_div.SetItem(1, "inter_cd", '%')
idw_to_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.06                                                  */	
/* 수정일      : 2002.03.06                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		dw_head.SetItem(1, "fr_shop_cd", "")
		dw_head.SetItem(1, "fr_shop_nm", "")
		dw_head.SetItem(1, "to_shop_cd", "")
		dw_head.SetItem(1, "to_shop_nm", "")
	CASE "fr_shop_cd", "to_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2) ) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End If		
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_53054_d
integer beginy = 476
integer endy = 476
end type

type ln_2 from w_com010_d`ln_2 within w_53054_d
integer beginy = 480
integer endy = 480
end type

type dw_body from w_com010_d`dw_body within w_53054_d
integer x = 14
integer y = 496
integer height = 1544
string dataobject = "d_53054_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event dw_body::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
Long i, ll_cnt = 0

If dwo.name = "cb_proc_yn" Then
	If dwo.Text = '전체제외' Then
		For i = 1 To dw_body.RowCount()
			If dw_body.GetItemString(i, "proc_chk") <> 'Y' Then
				dw_body.SetItem(i, "proc_yn", 'N')
				ll_cnt++
			End If
		Next
		dwo.Text = '전체선택'
	Else
		For i = 1 To dw_body.RowCount()
			If dw_body.GetItemString(i, "proc_chk") <> 'Y' Then
				dw_body.SetItem(i, "proc_yn", 'Y')
				ll_cnt++
			End If
		Next
		dwo.Text = '전체제외'
	End If

	If ll_cnt > 0 Then
		ib_changed = true
		cb_update.enabled = true
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
	End If
End If

end event

type dw_print from w_com010_d`dw_print within w_53054_d
integer x = 2789
integer y = 692
string dataobject = "d_53054_r01"
end type

type gb_1 from groupbox within w_53054_d
integer y = 136
integer width = 297
integer height = 336
integer taborder = 20
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

type dw_out from u_dw within w_53054_d
boolean visible = false
integer x = 2185
integer y = 804
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_53054_d03"
end type

type rb_1 from radiobutton within w_53054_d
integer x = 32
integer y = 236
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 79741120
string text = "발송"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
is_gubun = '1'

THIS.TextColor = RGB(0,0,255)
rb_2.TextColor = 0

dw_head.Object.ymd_t.Text = '발송일'

dw_body.DataObject = "d_53054_d01"
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = "d_53054_r01"
dw_print.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_53054_d
integer x = 32
integer y = 340
integer width = 215
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
string text = "인수"
borderstyle borderstyle = stylelowered!
end type

event clicked;
is_gubun = '2'

rb_1.TextColor = 0
This.TextColor = RGB(0,0,255)

dw_head.Object.ymd_t.Text = '인수일'

dw_body.DataObject = "d_53054_d02"
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = "d_53054_r02"
dw_print.SetTransObject(SQLCA)

end event

type dw_rtn from u_dw within w_53054_d
boolean visible = false
integer x = 283
integer y = 968
integer width = 3401
integer height = 824
integer taborder = 21
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_53053_d02"
boolean hscrollbar = true
end type

event dberror;//
end event

