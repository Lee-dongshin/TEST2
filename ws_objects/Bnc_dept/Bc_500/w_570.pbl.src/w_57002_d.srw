$PBExportHeader$w_57002_d.srw
$PBExportComments$등록자검색
forward
global type w_57002_d from w_com010_d
end type
end forward

global type w_57002_d from w_com010_d
integer width = 3675
integer height = 2248
end type
global w_57002_d w_57002_d

type variables
string   is_brand, is_gubun, is_bill_no, is_style, is_fr_yymmdd, is_to_yymmdd, is_shop_cd
datawindowchild idw_brand
end variables

on w_57002_d.create
call super::create
end on

on w_57002_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
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
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_gubun =  dw_head.GetItemstring(1, "gubun")
if IsNull(is_gubun) or is_gubun = "" then
   MessageBox(ls_title,"작업구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
   return false
end if

is_fr_yymmdd = dw_head.GetItemstring(1, "fr_yymmdd") 
if IsNull(is_fr_yymmdd) or is_fr_yymmdd = "" then
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemstring(1, "to_yymmdd") 
if IsNull(is_to_yymmdd) or is_to_yymmdd = "" then
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if



is_bill_no = Trim(dw_head.GetItemString(1, "bill_no"))


is_style = Trim(dw_head.GetItemString(1, "style"))
//if IsNull(is_bill_no) or is_bill_no = "" then
//   MessageBox(ls_title,"전표번호를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("bill_no")
//   return false
//end if


is_shop_cd = dw_head.GetItemstring(1, "shop_cd") 
if IsNull(is_shop_cd) or is_shop_cd = "" then
	is_shop_cd = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종 호)                             */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_gubun, is_fr_yymmdd, is_to_yymmdd, is_bill_no, is_style, is_shop_cd) 

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_57002_d","0")
end event

event open;call super::open;String ld_datetime


select convert(varchar(8), getdate(),112)
  into :ld_datetime
  from dual;




dw_head.setitem(1,"fr_yymmdd",ld_datetime)
dw_head.setitem(1,"to_yymmdd",ld_datetime)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
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
//			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" 
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

type cb_close from w_com010_d`cb_close within w_57002_d
end type

type cb_delete from w_com010_d`cb_delete within w_57002_d
end type

type cb_insert from w_com010_d`cb_insert within w_57002_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_57002_d
end type

type cb_update from w_com010_d`cb_update within w_57002_d
end type

type cb_print from w_com010_d`cb_print within w_57002_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_57002_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_57002_d
end type

type cb_excel from w_com010_d`cb_excel within w_57002_d
end type

type dw_head from w_com010_d`dw_head within w_57002_d
integer y = 148
integer height = 236
string dataobject = "d_57002_h01"
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001') 


end event

event dw_head::itemchanged;call super::itemchanged;String ls_yymmdd

CHOOSE CASE dwo.name

	CASE "shop_cd"	
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_57002_d
integer beginx = 23
integer beginy = 384
integer endx = 3657
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_57002_d
integer beginx = 32
integer beginy = 392
integer endx = 3694
integer endy = 392
end type

type dw_body from w_com010_d`dw_body within w_57002_d
integer y = 404
integer height = 1608
string dataobject = "d_57002_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_57002_d
end type

