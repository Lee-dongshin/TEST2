$PBExportHeader$w_91030_e.srw
$PBExportComments$입점몰 매장코드 관리
forward
global type w_91030_e from w_com010_e
end type
end forward

global type w_91030_e from w_com010_e
string title = "입점몰 매장코드 관리"
end type
global w_91030_e w_91030_e

type variables
String is_cust_nm, is_shop_cd

end variables

on w_91030_e.create
call super::create
end on

on w_91030_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김근호                                      */	
/* 작성일      : 2018.03.19                                                  */	
/* 수정일      : 2018..                                                  */
/*===========================================================================*/


IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_cust_nm, is_shop_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김근호                                      */	
/* 작성일      : 2018.03.19                                                  */	
/* 수정일      : 2018..                                                  */
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

is_cust_nm = dw_head.GetItemString(1,"cust_nm")

if trim(is_cust_nm) = '' or isnull(trim(is_cust_nm)) then
	is_cust_nm = '%'
else
	is_cust_nm = is_cust_nm + '%' 
end if

is_shop_cd = dw_head.GetItemString(1,"shop_cd")

if trim(is_shop_cd) = '' or isnull(trim(is_shop_cd)) then
	is_shop_cd = '%'
else
	is_shop_cd = is_shop_cd + '%' 
end if


return true

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김근호                                     */	
/* 작성일      : 2018.03.19                                                  */	
/* 수정일      : 2018..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_row
datetime ld_datetime
String ls_shop_cd, ls_cust_nm

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      ls_shop_cd = dw_body.GetitemString(i,'shop_cd')
		ls_cust_nm = dw_body.GetitemString(i,'cust_nm')
		
		
		IF Trim(ls_shop_cd) = '' or isnull(trim(ls_shop_cd)) then
			messagebox('확인','매장코드를 입력해주세요.')
			return 1
		end if
		
		IF LenA(Trim(ls_shop_cd)) <> 6 then
			messagebox('확인','매장코드를 확인해주세요.')
			return 1
		end if
		
		IF Trim(ls_cust_nm) = '' or isnull(trim(ls_cust_nm)) then
			messagebox('확인','입점몰 명을 입력해주세요.')
			return 1
		end if
		
		ll_row = dw_body.find(" getrow() <> currentrow() and shop_cd = '"+ls_shop_cd+"'", 1 , dw_body.rowcount())
		if ll_row > 0 then
		 messagebox('알림', '이미 등록된 매장코드입니다.')
		 dw_body.post setfocus()
		 dw_body.post setitem(i, 'shop_cd', '')
		 dw_body.post setcolumn('shop_cd')
		 return 1
		end if	

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

type cb_close from w_com010_e`cb_close within w_91030_e
end type

type cb_delete from w_com010_e`cb_delete within w_91030_e
end type

type cb_insert from w_com010_e`cb_insert within w_91030_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91030_e
end type

type cb_update from w_com010_e`cb_update within w_91030_e
end type

type cb_print from w_com010_e`cb_print within w_91030_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_91030_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_91030_e
end type

type cb_excel from w_com010_e`cb_excel within w_91030_e
end type

type dw_head from w_com010_e`dw_head within w_91030_e
integer y = 164
integer height = 148
string dataobject = "d_91030_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_91030_e
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_e`ln_2 within w_91030_e
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_e`dw_body within w_91030_e
integer y = 348
integer height = 1692
string dataobject = "d_91030_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;setrow(row)

end event

type dw_print from w_com010_e`dw_print within w_91030_e
integer x = 2016
integer y = 416
end type

