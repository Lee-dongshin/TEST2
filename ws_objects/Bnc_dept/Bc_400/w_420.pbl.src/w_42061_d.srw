$PBExportHeader$w_42061_d.srw
$PBExportComments$행낭사용내역조회
forward
global type w_42061_d from w_com010_d
end type
type dw_1 from datawindow within w_42061_d
end type
end forward

global type w_42061_d from w_com010_d
integer width = 3643
dw_1 dw_1
end type
global w_42061_d w_42061_d

type variables
string is_brand, is_fr_ymd, is_to_ymd, is_tran_cust, is_shop_cd
DataWindowChild idw_brand, idw_tran_cust

end variables

on w_42061_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_42061_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_tran_cust = dw_head.GetItemString(1, "tran_cust")
if IsNull(is_tran_cust) or Trim(is_tran_cust) = "" then
   MessageBox(ls_title,"운송업체를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("tran_cust")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_tran_cust = "M08" then 
	dw_body.dataobject = "d_42061_d01"
	dw_print.dataobject = "d_42061_r01"	
elseif 	is_tran_cust = "M02" then 
	dw_body.dataobject = "d_42061_d02"
	dw_print.dataobject = "d_42061_r02"
else	
	dw_body.dataobject = "d_42061_d03"
	dw_print.dataobject = "d_42061_r03"	
end if 
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_brand, is_tran_cust, is_shop_cd, is_fr_ymd, is_to_ymd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42061_d","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn, ls_SHOP_TYPE,ls_work_gubn
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
					
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K') " + &
											 "  AND BRAND = '" + ls_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_shop_nm, ls_datetime

					  
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_shop_nm = is_shop_cd + ' ' + dw_head.getitemstring(1, "shop_cd")

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_tran_cust.Text = '" + idw_tran_cust.GetItemString(idw_tran_cust.GetRow(), "inter_display") + "'" + &			
					"t_fr_ymd.Text = '" + is_fr_ymd + "'" + &										
					"t_to_ymd.Text = '" + is_to_ymd + "'" + &										
					"t_shop_nm.Text = '" + ls_shop_nm + "'"  + &
					"t_pg_id.Text = '" + is_pgm_id + "'" + &
					"t_user_id.Text = '" + gs_user_id + "'" + &
					"t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_42061_d
end type

type cb_delete from w_com010_d`cb_delete within w_42061_d
end type

type cb_insert from w_com010_d`cb_insert within w_42061_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42061_d
end type

type cb_update from w_com010_d`cb_update within w_42061_d
end type

type cb_print from w_com010_d`cb_print within w_42061_d
end type

type cb_preview from w_com010_d`cb_preview within w_42061_d
end type

type gb_button from w_com010_d`gb_button within w_42061_d
end type

type cb_excel from w_com010_d`cb_excel within w_42061_d
end type

type dw_head from w_com010_d`dw_head within w_42061_d
integer height = 212
string dataobject = "d_42061_h01"
end type

event dw_head::constructor;call super::constructor;String   ls_filter_str = ''	

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("tran_cust", idw_tran_cust)
idw_tran_cust.SetTransObject(SQLCA)
idw_tran_cust.Retrieve('404')


ls_filter_str = "inter_cd in ('M02','M07','M08') " 
idw_tran_cust.SetFilter(ls_filter_str)
idw_tran_cust.Filter( )


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_42061_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_42061_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_42061_d
integer y = 396
integer height = 1644
string dataobject = "d_42061_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;long ll_row
string ls_yymmdd

ls_yymmdd = dw_body.getitemstring(row, "yymmdd")

ll_row = dw_1.retrieve(ls_yymmdd, is_tran_cust, is_brand)

if ll_row > 0 then 
	dw_1.visible = true
else 	
	dw_1.visible = false
end if	
end event

type dw_print from w_com010_d`dw_print within w_42061_d
string dataobject = "d_42061_r01"
end type

type dw_1 from datawindow within w_42061_d
boolean visible = false
integer x = 320
integer y = 424
integer width = 3013
integer height = 1536
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "상세조회"
string dataobject = "d_42061_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;	dw_1.visible = false
end event

