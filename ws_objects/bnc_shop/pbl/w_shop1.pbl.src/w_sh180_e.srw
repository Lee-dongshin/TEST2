$PBExportHeader$w_sh180_e.srw
$PBExportComments$EDI/닷컴 마감입력
forward
global type w_sh180_e from w_com010_e
end type
end forward

global type w_sh180_e from w_com010_e
integer width = 2985
integer height = 2080
end type
global w_sh180_e w_sh180_e

type variables
String	is_s_yymm
end variables

on w_sh180_e.create
call super::create
end on

on w_sh180_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 동은아빠                                       */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.04.29 (김 태범)                                        */
/*===========================================================================*/
String   ls_title,ls_style_no

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


is_s_yymm = dw_head.getitemstring(1, "s_yymm")

// MessageBox(ls_title,gs_shop_cd)
if IsNull(is_s_yymm) OR Trim(is_s_yymm) = "" then
   MessageBox(ls_title,"등록 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("s_yymm")
   return false
end if

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.04.30 (김 태범)                                        */
/*===========================================================================*/
long i
string ls_Flag
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//dw_body.SetTransObject(SQLCA)
if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

	il_rows = dw_body.retrieve(is_s_yymm, gs_shop_cd, gs_brand)

IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_Flag = dw_body.getitemstring(i,"Flag")
		if ls_Flag = "New" then	dw_body.SetItemStatus(i, 0, Primary!,New!)
	next 
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.04.29 (김 태범)                                        */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
String   ls_yymmdd 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_head.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

	FOR i=1 TO ll_row_count
		idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_body.Setitem(i, "shop_cd",  gs_shop_cd)
			dw_body.Setitem(i, "brand",  gs_brand)
			dw_body.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_body.Setitem(i, "brand",  gs_brand)
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_ymd", ld_datetime)
		END IF
	NEXT	


il_rows = dw_body.Update(True, False)

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
Return il_rows

end event

event open;call super::open;String ls_yymm

//초기날짜 구하기
select convert(char(6), dateadd(m,-1,getdate()), 112)
into :ls_yymm
from dual;

dw_head.SetItem(1, "s_yymm", ls_yymm)

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

Trigger Event ue_retrieve()

end event

type cb_close from w_com010_e`cb_close within w_sh180_e
integer taborder = 90
end type

type cb_delete from w_com010_e`cb_delete within w_sh180_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh180_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh180_e
end type

type cb_update from w_com010_e`cb_update within w_sh180_e
integer taborder = 80
end type

type cb_print from w_com010_e`cb_print within w_sh180_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh180_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh180_e
end type

type dw_head from w_com010_e`dw_head within w_sh180_e
integer height = 112
string dataobject = "d_sh180_h01"
end type

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

type ln_1 from w_com010_e`ln_1 within w_sh180_e
integer beginx = 5
integer beginy = 308
integer endx = 2885
integer endy = 308
end type

type ln_2 from w_com010_e`ln_2 within w_sh180_e
integer beginy = 292
integer endy = 292
end type

type dw_body from w_com010_e`dw_body within w_sh180_e
integer y = 312
integer width = 2903
integer height = 1520
string dataobject = "d_sh180_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
Long ll_shop_sale_amt, ll_shop_sale_mileage, ll_edi_amt, ll_yeso_amt,ll_shop_dotc_amt

CHOOSE CASE dwo.name
	CASE "edi_amt" 
		ll_shop_sale_amt = This.GetItemDecimal(row, "shop_sale_amt")
		ll_shop_sale_mileage = This.GetItemDecimal(row, "shop_sale_mileage")

		This.SetItem(row, "m_amt1", ll_shop_sale_amt + ll_shop_sale_mileage - Long(data))


	CASE "dotc_amt"
		ll_shop_dotc_amt = This.GetItemDecimal(row, "shop_dotc_amt")

		This.SetItem(row, "m_amt2", ll_shop_dotc_amt - Long(data))

/*
	CASE "yeso_amt"
		ll_shop_sale_amt = This.GetItemDecimal(row, "shop_sale_amt")
		ll_shop_sale_mileage = This.GetItemDecimal(row, "shop_sale_mileage")
		ll_edi_amt = This.GetItemDecimal(row, "edi_amt")		

		This.SetItem(row, "m_amt1", ll_shop_sale_amt + ll_shop_sale_mileage - ll_edi_amt + Long(data))
*/

//		ll_sale_minus = This.GetItemDecimal(row, "sale_minus")
//		If IsNull(ll_sale_minus) Then ll_sale_minus = 0
//		This.SetItem(row, "sale_sum", ll_sale_minus + Long(data))
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_sh180_e
end type

