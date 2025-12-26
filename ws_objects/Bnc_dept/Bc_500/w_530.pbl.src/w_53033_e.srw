$PBExportHeader$w_53033_e.srw
$PBExportComments$사내판매요청출고처리
forward
global type w_53033_e from w_com010_e
end type
type cb_proc from commandbutton within w_53033_e
end type
type dw_1 from datawindow within w_53033_e
end type
end forward

global type w_53033_e from w_com010_e
cb_proc cb_proc
dw_1 dw_1
end type
global w_53033_e w_53033_e

type variables
DataWindowChild idw_brand
String is_brand, is_fr_ymd, is_to_ymd, is_pay_way, is_dc_gubn, is_out_yn, is_bill_yn, is_kname
end variables

forward prototypes
public subroutine wf_amt_set (long al_row, long al_qty, decimal al_dc_rate)
end prototypes

public subroutine wf_amt_set (long al_row, long al_qty, decimal al_dc_rate);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect ,ll_sale_collect1
Decimal ldc_dc_rate

IF dw_body.AcceptText() <> 1 THEN RETURN

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 

dw_body.Setitem(al_row, "sale_amt", ll_tag_price * al_qty * ((100 - al_dc_rate)/100))


end subroutine

on w_53033_e.create
int iCurrent
call super::create
this.cb_proc=create cb_proc
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_proc
this.Control[iCurrent+2]=this.dw_1
end on

on w_53033_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_proc)
destroy(this.dw_1)
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


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_pay_way = dw_head.GetItemString(1, "pay_way")
if IsNull(is_pay_way) or Trim(is_pay_way) = "" then
   MessageBox(ls_title,"지불방식을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("pay_way")
   return false
end if

is_dc_gubn = dw_head.GetItemString(1, "dc_gubn")
if IsNull(is_dc_gubn) or Trim(is_dc_gubn) = "" then
   MessageBox(ls_title,"제품구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dc_gubn")
   return false
end if

is_out_yn = dw_head.GetItemString(1, "out_yn")
if IsNull(is_out_yn) or Trim(is_out_yn) = "" then
   MessageBox(ls_title,"출고여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_yn")
   return false
end if

is_bill_yn = dw_head.GetItemString(1, "bill_yn")
if IsNull(is_bill_yn) or Trim(is_bill_yn) = "" then
   MessageBox(ls_title,"입금여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bill_yn")
   return false
end if

is_kname = dw_head.GetItemString(1, "kname")
if IsNull(is_kname) or Trim(is_kname) = "" then
	is_kname = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;string ls_modify, ls_bill_chk_t
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_pay_way, is_dc_gubn, is_bill_yn, is_out_yn, is_kname)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

if is_pay_way = "A" then
	ls_bill_chk_t = "급여공제일"
else	
	ls_bill_chk_t = "입금확인일"
end if	

ls_modify =	"t_bill_chk_ymd.Text = '" + ls_bill_chk_t + "'" 
dw_body.Modify(ls_modify)

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
      dw_body.Setitem(i, "reg_id", gs_user_id)
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

event ue_button(integer ai_cb_div, long al_rows);//			cb_proc.enabled = true		


CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
			cb_proc.enabled = true		
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
			cb_proc.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
			cb_proc.enabled = true				
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
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
		cb_proc.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_print();dw_print.DataObject = "d_53033_r01"
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()
end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event ue_preview();
Long i, row_cnt

dw_1.reset()

row_cnt = dw_body.RowCount()
For i = row_cnt To 1 Step -1
	If dw_body.GetItemString(i, 'proc_yn') = 'Y' Then
		dw_body.Rowscopy(i, i, Primary!, dw_1, 1, Primary!)
		dw_1.SetItem(1, 'proc_yn', 'N')
	End If
Next

//This.Trigger Event ue_title ()

dw_print.DataObject = "d_53033_r02"
dw_print.SetTransObject(SQLCA)

dw_1.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()


end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_pay_way, ls_dc_gubn, ls_out_yn, ls_bill_yn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_pay_way = "%" then
	ls_pay_way = "전체"
elseif is_pay_way = "A" then
	ls_pay_way = "급여공제"
else
	ls_pay_way = "입금"	
end if	

if is_dc_gubn = "%" then
	ls_dc_gubn = "전체"
elseif is_dc_gubn = "A" then
	ls_dc_gubn = "정상제품"
else
	ls_dc_gubn = "부진제품"	
end if	

if is_out_yn = "%" then
	ls_out_yn = "전체"
elseif is_out_yn = "Y" then
	ls_out_yn = "출고완료"
else
	ls_out_yn = "미출고"	
end if	

if is_bill_yn = "%" then
	ls_bill_yn = "전체"
elseif is_bill_yn = "Y" then
	ls_bill_yn = "입금"
else
	ls_bill_yn = "미입금"	
end if	

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
			 	"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' " + &
				"t_pay_way.Text = '" +ls_pay_way + "' " +&
				"t_dc_gubn.Text = '" + ls_dc_gubn + "' "   + &
				"t_out_yn.Text = '" + ls_out_yn + "' "  + &
				"t_fr_ymd.Text = '" + is_fr_ymd + "' "  + &
				"t_to_ymd.Text = '" + is_to_ymd + "' "  + &				
				"t_bill_yn.Text = '" + ls_bill_yn + "' "  


dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"W_53033_e","0")
end event

type cb_close from w_com010_e`cb_close within w_53033_e
end type

type cb_delete from w_com010_e`cb_delete within w_53033_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_53033_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53033_e
end type

type cb_update from w_com010_e`cb_update within w_53033_e
end type

type cb_print from w_com010_e`cb_print within w_53033_e
integer x = 1376
integer width = 393
string text = "리스트출력(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_53033_e
integer width = 343
string text = "출고내역(&V)"
end type

type gb_button from w_com010_e`gb_button within w_53033_e
end type

type cb_excel from w_com010_e`cb_excel within w_53033_e
end type

type dw_head from w_com010_e`dw_head within w_53033_e
integer height = 188
string dataobject = "d_53033_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_53033_e
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_53033_e
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_53033_e
integer x = 0
integer y = 376
integer height = 1660
string dataobject = "d_53033_d01"
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;Long    ll_ret, ll_qty  
Decimal ldc_rate
String ls_null
Setnull(ls_null) 

CHOOSE CASE dwo.name
	
	CASE "out_qty" 
		ll_qty   = Long(Data) 
//		IF isnull(ll_qty) or ll_qty = 0 THEN RETURN 1 
		ldc_rate = This.GetitemNumber(row, "dc_rate")
      /* 금액 처리           */
		wf_amt_set(row, ll_qty, ldc_rate) 
	CASE "dc_rate" 
		ldc_rate   = dec(Data) 
		IF isnull(ldc_rate) or ldc_rate = 0 THEN RETURN 1 
		ll_qty = This.GetitemNumber(row, "out_qty")
      /* 금액 처리           */
		wf_amt_set(row, ll_qty, ldc_rate) 		

	CASE "proc_yn" 
		ib_changed = false
		cb_update.enabled = false
		cb_print.enabled = true
		cb_preview.enabled = true
		cb_excel.enabled = true
		cb_proc.enabled = true

END CHOOSE





end event

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn

If dwo.Name = 'cb_select' Then
	If dwo.Text = '선택' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	Else
		ls_yn = 'N'
		dwo.Text = '선택'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "proc_yn", ls_yn)		
	Next	
End If

end event

type dw_print from w_com010_e`dw_print within w_53033_e
string dataobject = "d_53033_r02"
end type

type cb_proc from commandbutton within w_53033_e
integer x = 379
integer y = 44
integer width = 347
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "전송"
end type

event clicked;String ls_yymmdd, ls_rqst_no, ls_no, ls_empno, ls_style, ls_chno, ls_color, ls_size,ls_out_no,ls_out_ymd,ls_out_yn
String ls_out_no_chk, ls_proc_yn
integer li_qty, i
long ll_row_count
Decimal ldc_dc_rate
datetime ld_datetime

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count

	dw_body.ScrollToRow(i)
	dw_body.selectrow(i,TRUE)	
	ls_proc_yn = dw_body.GetItemString(i, "proc_yn")
	ls_out_yn  = dw_body.GetItemString(i, "out_yn")
	ls_yymmdd  = dw_body.GetItemString(i, "yymmdd")	
	ls_rqst_no = dw_body.GetItemString(i, "rqst_no")		
	ls_no      = dw_body.GetItemString(i, "no")		
	ls_empno   = dw_body.GetItemString(i, "empno")			
	ls_style   = dw_body.GetItemString(i, "style")
	ls_chno    = dw_body.GetItemString(i, "chno")
	ls_color   = dw_body.GetItemString(i, "color")	
	ls_size    = dw_body.GetItemString(i, "size")		
	li_qty     = dw_body.GetItemNumber(i, "out_qty")		
//	ldc_dc_rate	= 100 - dw_body.GetItemNumber(i, "dc_rate")	
	ldc_dc_rate	= dw_body.GetItemNumber(i, "dc_rate")	
	ls_out_no_chk = dw_body.GetItemString(i, "out_no")	
	
	if isnull(ls_proc_yn) or ls_proc_yn = "" then
		ls_proc_yn = "N"
	end if	
	
	if isnull(ls_out_no_chk) or ls_out_no_chk = "" then
		ls_out_no_chk = "XXXX"
	end if		

	if ls_proc_yn = "Y" and li_qty <> 0 and ls_out_yn <> "Y"  then	
		
	 DECLARE sp_53033_d04 PROCEDURE FOR sp_53033_d04  
         @brand 	= :is_brand,   
         @yymmdd  = :ls_yymmdd,   
         @rqst_no = :ls_rqst_no,   
         @no      = :ls_no,   
         @empno   = :ls_empno,   
         @style   = :ls_style,   
         @chno    = :ls_chno,   
         @color   = :ls_color,   
         @size    = :ls_size,   
         @qty     = :li_qty,   
         @dc_rate = :ldc_dc_rate,   
         @reg_id  = :gs_user_id,   
         @out_ymd = :ls_out_ymd output,   
         @out_no  = :ls_out_no  output;

	
		 EXECUTE sp_53033_d04 ;
 		 fetch   sp_53033_d04  into :ls_out_ymd, :ls_out_no;
		 CLOSE   sp_53033_d04 ;
		
		end if		
			
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;				
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;
					dw_body.setitem(i, "out_ymd",ls_out_ymd)	
					dw_body.setitem(i, "out_no",ls_out_no)	
					 il_rows = 1 
				END IF 		
	
	dw_body.selectrow(i,false)	
NEXT

			

CB_proc.ENABLED = FALSE
parent.Trigger Event ue_button(3, il_rows)
parent.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

type dw_1 from datawindow within w_53033_e
boolean visible = false
integer x = 923
integer y = 616
integer width = 2263
integer height = 600
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_53033_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

