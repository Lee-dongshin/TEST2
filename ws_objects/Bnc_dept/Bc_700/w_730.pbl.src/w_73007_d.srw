$PBExportHeader$w_73007_d.srw
$PBExportComments$매장매출회원월비교
forward
global type w_73007_d from w_com020_d
end type
end forward

global type w_73007_d from w_com020_d
end type
global w_73007_d w_73007_d

type variables
DataWindowChild idw_brand, idw_shop_div
String is_brand, is_shop_div, is_yymm, is_shop_cd, is_check_print, is_shop_nm
end variables

on w_73007_d.create
call super::create
end on

on w_73007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_73007_d","0")
end event

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"매장유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if


is_check_print = "N"

return true
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_shop_div)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_print();Long ll_row_count1, ll_row_count2,i, ll_rows, J ,K
long ll_work_no[]
string ls_shop_cd

k = 1 
ll_row_count1 = dw_list.RowCount()
ll_row_count2 = dw_body.RowCount()


		FOR i = 1 TO ll_row_count1
			is_shop_cd   = dw_list.GetItemString(i, 'shop_cd')
			is_shop_nm   = dw_list.GetItemString(i, 'shop_snm')
			
			if dw_list.GetItemString(i, 'chk_print') = 'Y' THEN
				dw_list.ScrollToRow(i)
				dw_list.selectrow(i,TRUE)	
				ll_rows = dw_print.retrieve(is_yymm, is_brand, is_shop_cd )
				This.Trigger Event ue_title()
				If ll_rows > 0 Then il_rows = dw_print.Print()		
				dw_list.selectrow(i,false)	
				dw_body.ShareData(dw_print)
			END IF
			
 		NEXT



This.Trigger Event ue_msg(6, il_rows)
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_shop_cd.Text = '" + is_shop_cd + "'"	+ &			  
             "t_shop_nm.Text = '" + is_shop_nm + "'"	+ &				 
             "t_yymm.Text = '" + is_yymm + "'"	
				 
messagebox(	"ls_modify", ls_modify)			 

dw_print.Modify(ls_modify)

end event

type cb_close from w_com020_d`cb_close within w_73007_d
end type

type cb_delete from w_com020_d`cb_delete within w_73007_d
end type

type cb_insert from w_com020_d`cb_insert within w_73007_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_73007_d
end type

type cb_update from w_com020_d`cb_update within w_73007_d
end type

type cb_print from w_com020_d`cb_print within w_73007_d
integer x = 1385
integer width = 384
string text = "일괄인쇄(&P)"
end type

type cb_preview from w_com020_d`cb_preview within w_73007_d
end type

type gb_button from w_com020_d`gb_button within w_73007_d
end type

type cb_excel from w_com020_d`cb_excel within w_73007_d
end type

type dw_head from w_com020_d`dw_head within w_73007_d
integer height = 160
string dataobject = "d_73007_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.insertRow(1) 
idw_shop_div.Setitem(1, "inter_cd", "%")
idw_shop_div.Setitem(1, "inter_nm", "전체")


This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
	ls_filter_str = "inter_cd in ('G','K','D', '%')" 
	idw_shop_div.SetFilter(ls_filter_str)
	idw_shop_div.Filter( )


end event

type ln_1 from w_com020_d`ln_1 within w_73007_d
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com020_d`ln_2 within w_73007_d
integer beginy = 352
integer endy = 352
end type

type dw_list from w_com020_d`dw_list within w_73007_d
integer y = 368
integer width = 1061
integer height = 1672
string dataobject = "d_73007_d02"
end type

event dw_list::clicked;call super::clicked;//string ls_shop_cd
//
//IF row <= 0 THEN Return
//
//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)
//
//ls_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */
//
//IF IsNull(ls_shop_cd) THEN return
//il_rows = dw_body.retrieve(is_yymm, is_brand, ls_shop_cd)
//Parent.Trigger Event ue_button(7, il_rows)
//Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::buttonclicked;call super::buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_select"
		If is_check_print = 'N' then
			is_check_print = 'Y'
			This.Object.cb_select.Text = '해제'
		Else
			is_check_print = 'N'
			This.Object.cb_select.Text = '선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "chk_print", is_check_print)
		Next
END CHOOSE

end event

event dw_list::doubleclicked;call super::doubleclicked;string ls_shop_cd

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(ls_shop_cd) THEN return
il_rows = dw_body.retrieve(is_yymm, is_brand, ls_shop_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	
	CASE "chk_print"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if data = 'Y' then cb_print.enabled = true

END CHOOSE
end event

type dw_body from w_com020_d`dw_body within w_73007_d
integer x = 1106
integer y = 368
integer width = 2487
integer height = 1672
string dataobject = "d_73007_d01"
end type

type st_1 from w_com020_d`st_1 within w_73007_d
integer x = 1088
integer y = 372
integer height = 1668
end type

type dw_print from w_com020_d`dw_print within w_73007_d
string dataobject = "d_73007_r01"
end type

