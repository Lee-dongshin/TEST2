$PBExportHeader$w_sh310_e.srw
$PBExportComments$부자재 주문등록
forward
global type w_sh310_e from w_com010_e
end type
type st_1 from statictext within w_sh310_e
end type
type st_2 from statictext within w_sh310_e
end type
type st_3 from statictext within w_sh310_e
end type
type st_4 from statictext within w_sh310_e
end type
type st_5 from statictext within w_sh310_e
end type
end forward

global type w_sh310_e from w_com010_e
integer width = 2976
integer height = 2072
long backcolor = 16777215
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
end type
global w_sh310_e w_sh310_e

type variables
String is_yymmdd
long idc_month_limit, idc_month_out, idc_plan_amt
end variables

forward prototypes
public function boolean wf_qty_update (ref string as_errmsg)
end prototypes

public function boolean wf_qty_update (ref string as_errmsg);/* 매장, 자재별 의뢰량 처리 tb_42030_m */
Long    i 
Decimal ldc_qty, ldc_old_qty, ldc_New_qty
String  ls_mat_cd 

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = dw_head.getitemstring(1, 'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

/* 변경된 수량만큼 차감 */
FOR i = 1 TO dw_body.RowCount()
   ldc_qty = 0 
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record */
		ldc_New_qty = dw_body.GetitemDecimal(i, "qty")
		IF isnull(ldc_New_qty) THEN ldc_qty = 0 
		ldc_qty = ldc_New_qty 
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ldc_old_qty = dw_body.GetitemDecimal(i, "qty", Primary!, TRUE)
		IF isnull(ldc_old_qty) THEN ldc_old_qty = 0 
		ldc_New_qty = dw_body.GetitemDecimal(i, "qty")
		IF isnull(ldc_New_qty) THEN ldc_New_qty = 0 
		ldc_qty = ldc_New_qty - ldc_old_qty 
	END IF 
   IF ldc_qty <> 0 THEN 
		ls_mat_cd = dw_body.GetitemString(i, "mat_cd") 
      DECLARE SP_42030_UPDATE1 PROCEDURE FOR SP_42030_M_UPDATE 
         @shop_cd  = :gs_shop_cd,   
         @mat_cd   = :ls_mat_cd, 
			@qty      = :ldc_qty;
      EXECUTE SP_42030_UPDATE1;
		IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN 
			as_errmsg = SQLCA.SqlErrText
			Return False 
		END IF 
	END IF
NEXT

Return True
end function

on w_sh310_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
end on

on w_sh310_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

select sum(isnull(plan_amt,0))
into :idc_plan_amt
from tb_51010_h (nolock)
where yymm = left(convert(varchar(8), GetDate(), 112),6)
and shop_cd = :gs_shop_cd;


select  round(((select sum(plan_amt)
		          from tb_51010_h (nolock)
		          where yymm = left(convert(varchar(8), GetDate(), 112),6)
		          and shop_cd = :gs_shop_cd	) / (sum(sale_amt) / sum(sale_qty))) /1.7 ,-2) +

	case when  sum(sale_amt) /
		(select sum(plan_amt)
			from tb_51010_h (nolock)
			where yymm = left(convert(varchar(8), DATEADD(MONTH,-1, GETDATE()), 112),6)
			and shop_cd = :gs_shop_cd	) >= 1 then 100 
		else 0
//		 when  sum(sale_amt) /
//		(select sum(plan_amt)
//			from tb_51010_h (nolock)
//			where yymm = left(convert(varchar(8), DATEADD(MONTH,-1, GETDATE()), 112),6)
//			and shop_cd = :gs_shop_cd	) < 0.8 then  -100  
		end 
into :idc_month_limit	
from tb_55011_s a (nolock) 
where a.YYMM = CONVERT(CHAR(06), DATEADD(MONTH,-1, GETDATE()),112)
AND  a.shop_cd = :gs_shop_cd
and   a.shop_type < '4';


select sum(isnull(qty,0))
into :idc_month_out
from tb_42032_H (nolock)
where  mat_cd  IN (select mat_cd
							from tb_21000_m (nolock)
							where  mat_cd  like '%2XXZ%'
							and mat_nm like '%쇼핑백%' )
AND  shop_cd = :gs_shop_cd
AND  YYMMDD LIKE CONVERT(CHAR(06), DATEADD(MONTH,0, GETDATE()),112) + '%';


//if IsNull(idc_month_out) or
if ( isnull(idc_plan_amt) or idc_plan_amt = 0 ) then
	idc_month_limit = 0
end if


//if gs_brand = 'W' then 
	st_5.text = "☞ 당월 쇼핑백 출고 제한 수량: " + string(idc_month_limit, "0000") + "장, 현시점 누계출고수량: " + string(idc_month_out,"0000") + "장 입니다!"
//end if

il_rows = dw_body.retrieve(gs_shop_cd, gs_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if	

This.Trigger Event ue_retrieve()
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_rqst_qty, ll_out_qty,ll_rqst_qty1,ll_out_qty1
datetime ld_datetime
String   ls_shop_cd, ls_ErrMsg , ls_time, ls_mat_cd, ls_mat_nm, ls_day_ok, ls_yymmdd




ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return -1
end if	

select convert(char(30), getdate(),108)
into :ls_time
from dual;

select convert(char(8), getdate(),112)
into :ls_yymmdd
from dual;


if ls_yymmdd < '20110314' then

	select case when datepart(weekday, getdate()) = 1 then 'Y' 
					when datepart(weekday, getdate()) = 3 then 'Y' 
					when datepart(weekday, getdate()) = 1 then 'C' 				
			 else 'N' end			
	into :ls_day_ok
	from dual;
	
	if ls_day_ok = 'C' then 
		messagebox("주의!", '일요일은 모든 부자재 요청이 불가합니다!')
		return -1
	end if	
	
	if ls_time >= '16:00:00' or ls_time <= '10:00:00' then
		messagebox("주의!", '오전 10시부터 오후 4시 사이에만 저장하실 수 없습니다!')
		return -1
	end if		

else


	select case when datepart(weekday, getdate()) = 2 then 'Y' 
					when datepart(weekday, getdate()) = 4 then 'Y' 
					when datepart(weekday, getdate()) = 1 then 'C' 				
			 else 'N' end			
	into :ls_day_ok
	from dual;
	
	if ls_day_ok = 'C' then 
		messagebox("주의!", '일요일은 모든 부자재 요청이 불가합니다!')
		return -1
	end if	
end if	




/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


ll_rqst_qty1 = 0
FOR i=1 TO ll_row_count
	ls_mat_nm = dw_body.getitemstring(i, "mat_nm")
	ll_out_qty = dw_body.getitemNumber(i,"qty")
	
	if LeftA(ls_mat_nm,6) <> "쇼핑백" then	
	 ll_rqst_qty1 = ll_rqst_qty1 + ll_out_qty1
	end if 	
NEXT


ll_rqst_qty = 0
FOR i=1 TO ll_row_count
	ls_mat_nm = dw_body.getitemstring(i, "mat_nm")
	ll_out_qty = dw_body.getitemNumber(i,"qty")
	
	if LeftA(ls_mat_nm,6) = "쇼핑백" then	
	 ll_rqst_qty = ll_rqst_qty + ll_out_qty
	end if 	
NEXT

//messagebox("idc_month_limit", idc_month_limit)
//messagebox("idc_month_out", idc_month_out)
//messagebox("ll_rqst_qty", ll_rqst_qty)
//messagebox("총수량", idc_month_out + ll_rqst_qty)
//

//if ll_rqst_qty > 0 and idc_month_limit < idc_month_out + ll_rqst_qty and gs_shop_div <> "K" and gs_brand <> "B" then 
//	messagebox("주의!", '당월 쇼핑백 출고제한 수량을 초과 되었습니다!')
////	return -1
//end if	

if is_yymmdd >= '20110307' then
	if ll_rqst_qty1 > 0 and ls_day_ok <> 'Y' then 
		messagebox("주의!", '쇼핑백을 제외한 모든 주문은 월,수요일에만 가능합니다!')
		return -1
	end if	
end if	



FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
		IF isnull(ls_shop_cd) or Trim(ls_shop_cd) = "" THEN 
         dw_body.Setitem(i, "shop_cd", gs_shop_cd)
         dw_body.Setitem(i, "reg_id", gs_user_id)
			dw_body.SetitemStatus(i, 0, Primary!, NewModified!)
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF 
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)
IF il_rows = 1 THEN
	ls_ErrMsg = ""
	IF wf_qty_update(ls_ErrMsg) = FALSE THEN 
		il_rows = -1
	END IF
END IF

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	st_1.visible = False
else
   rollback  USING SQLCA;
	IF isnull(ls_ErrMsg) = FALSE and ls_ErrMsg <> "" THEN 
		MessageBox("SQL 오류", ls_ErrMsg) 
	END IF
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;long i, ll_row_count
datetime ld_datetime
String ls_time, ls_yymmdd  


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_time = string(ld_datetime, "hh:mm:ss")

//	if ls_time > "17:00:00" then
//       select convert(varchar(08), dateadd(day, 1,  GetDate()), 112)
//		 into :ls_yymmdd
//		 from dual;      
//   else
		 select convert(varchar(8), GetDate(), 112)
		 into :ls_yymmdd
		 from dual;
//	end if
	
dw_head.Setitem(1, "yymmdd", ls_yymmdd)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox("주의!","브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true
end event

type cb_close from w_com010_e`cb_close within w_sh310_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh310_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh310_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh310_e
boolean visible = false
end type

type cb_update from w_com010_e`cb_update within w_sh310_e
end type

type cb_print from w_com010_e`cb_print within w_sh310_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh310_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh310_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh310_e
integer height = 192
string dataobject = "d_sh310_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

type ln_1 from w_com010_e`ln_1 within w_sh310_e
integer beginy = 452
integer endy = 452
end type

type ln_2 from w_com010_e`ln_2 within w_sh310_e
integer beginy = 456
integer endy = 456
end type

type dw_body from w_com010_e`dw_body within w_sh310_e
integer y = 464
integer height = 1368
string dataobject = "d_sh310_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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
/* 작성자      :                                                       */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
Long   ll_limit
String ls_mat_cd

st_1.visible = true

CHOOSE CASE dwo.name
	CASE "qty" 
		ll_limit = This.GetitemNumber(row, "limit_qty")
		ls_mat_cd = This.GetitemString(row, "mat_cd")
	   IF ll_limit <> 0 THEN 
			
			if MidA(ls_mat_cd ,2,6) = "2XXZ20" then
				IF Long(data) > ll_limit THEN 
				MessageBox("오류", "단위수량 만큼 제한 입력하십시오 !")
				Return 1
				END IF 
			else
			
				IF Long(data) < ll_limit THEN 
					MessageBox("오류", "단위이상으로 입력하십시오 !")
					Return 1
				END IF 
				
			end if	
			
				IF mod( Long(data), ll_limit) <> 0 THEN 
					MessageBox("오류", "요청은 단위의 배수로 입력하십시오 !")
					Return 1
				END IF 
			
			
		END IF 
END CHOOSE

end event

event dw_body::editchanged;call super::editchanged;st_1.visible = true
end event

type dw_print from w_com010_e`dw_print within w_sh310_e
end type

type st_1 from statictext within w_sh310_e
boolean visible = false
integer x = 411
integer y = 60
integer width = 1851
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "<- 입력후 반드시 저장버튼을 누르세요 (단축키 Alt+S)"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh310_e
integer x = 1088
integer y = 164
integer width = 1938
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ 잔량이 남아 있는 물품은 등록 하실 수 없습니다! "
boolean focusrectangle = false
end type

type st_3 from statictext within w_sh310_e
integer x = 1083
integer y = 288
integer width = 1755
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ 당일 오후4시 이전에 등록 완료바랍니다."
boolean focusrectangle = false
end type

type st_4 from statictext within w_sh310_e
integer x = 1083
integer y = 224
integer width = 1097
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ 단위 수량 이상만 등록 가능합니다."
boolean focusrectangle = false
end type

type st_5 from statictext within w_sh310_e
integer x = 41
integer y = 364
integer width = 2821
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

