$PBExportHeader$w_56029_d.srw
$PBExportComments$품번매장 할인 현황
forward
global type w_56029_d from w_com010_d
end type
end forward

global type w_56029_d from w_com010_d
integer width = 3675
integer height = 2264
end type
global w_56029_d w_56029_d

type variables
String is_brand, is_shop_cd, is_style, is_yymmdd, is_st_brand
DataWindowChild idw_brand, idw_st_brand
end variables

on w_56029_d.create
call super::create
end on

on w_56029_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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
   MessageBox(ls_title,"매장 브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


is_st_brand = dw_head.GetItemString(1, "st_brand")
if IsNull(is_st_brand) or Trim(is_st_brand) = "" then
   MessageBox(ls_title,"품번 브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_brand")
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


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
//   MessageBox(ls_title,"품번을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("style")
//   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
  is_shop_cd = "%"
end if

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_style, is_st_brand)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56028_d","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" 


dw_print.Modify(ls_modify)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm , ls_brand
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
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
			

			CASE "style"							// 거래처 코드
				
				ls_brand =  dw_head.GetItemstring(1, "brand")
				
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + ls_brand + "%'"	
				else 	
					gst_cd.default_where   = " WHERE  tag_price <> 0 "
				end if
				
		
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
								
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("shop_cd")
					ib_itemchanged = False
				END IF

			
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

type cb_close from w_com010_d`cb_close within w_56029_d
end type

type cb_delete from w_com010_d`cb_delete within w_56029_d
end type

type cb_insert from w_com010_d`cb_insert within w_56029_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56029_d
end type

type cb_update from w_com010_d`cb_update within w_56029_d
end type

type cb_print from w_com010_d`cb_print within w_56029_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_56029_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_56029_d
end type

type cb_excel from w_com010_d`cb_excel within w_56029_d
end type

type dw_head from w_com010_d`dw_head within w_56029_d
integer y = 168
integer height = 192
string dataobject = "d_56029_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("st_brand", idw_st_brand)
idw_st_brand.SetTransObject(SQLCA)
idw_st_brand.Retrieve('001')
idw_st_brand.InsertRow(1)
idw_st_brand.SetItem(1, "inter_cd", '%')
idw_st_brand.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

	
	CASE "style" 
      IF ib_itemchanged THEN RETURN 1
		if LenA(data) >= 8 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if
	
 	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)	
		 
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_56029_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_56029_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_56029_d
integer y = 396
integer height = 1624
string dataobject = "d_56029_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_56029_d
string dataobject = "d_56021_r02"
end type

