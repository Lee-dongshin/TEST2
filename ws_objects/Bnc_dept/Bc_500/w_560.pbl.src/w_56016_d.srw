$PBExportHeader$w_56016_d.srw
$PBExportComments$백화점 Key비교조회
forward
global type w_56016_d from w_com010_d
end type
end forward

global type w_56016_d from w_com010_d
integer width = 3680
integer height = 2280
end type
global w_56016_d w_56016_d

type variables
datawindowchild idw_brand

string is_brand, is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_sale_type, is_dotcom


end variables

on w_56016_d.create
call super::create
end on

on w_56016_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
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

is_sale_type = dw_head.GetItemString(1, "sale_type")
if IsNull(is_sale_type) or Trim(is_sale_type) = "" then
   MessageBox(ls_title,"판매형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_shop_cd   = dw_head.GetItemString(1, "shop_cd")
is_dotcom   = dw_head.GetItemString(1, "dotcom")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_sale_type, is_dotcom)
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text      = '" + is_pgm_id    + "'" + &
             "t_user_id.Text   = '" + gs_user_id   + "'" + &
             "t_datetime.Text  = '" + ls_datetime  + "'" + &
				 "t_brand.Text     = '" + is_brand     + "'" + &
				 "t_fr_yymmdd.Text = '" + is_fr_yymmdd + "'" + &
				 "t_to_yymmdd.Text = '" + is_to_yymmdd + "'" + &
				 "t_shop_cd.Text   = '" + is_shop_cd   + "'" 

dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_style_no
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
		IF ai_div = 1 THEN 	
			If IsNull(as_data) or Trim(as_data) = "" Then
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
				
			IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		if is_brand = 'B' then
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' " + &
			                         "  AND shop_div in ('G','B','K') and SHOP_STAT = '00' "
		else
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' " + &
		   	                      "  AND shop_div = 'G' and SHOP_STAT = '00' "
		end if
										 
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "(SHOP_CD LIKE '" + as_data + "%' or shop_nm like '%" + as_data + "%')"
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
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("style_no")
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

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",LeftA(string(ld_datetime,"yyyymmdd"),6) + '01')
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

type cb_close from w_com010_d`cb_close within w_56016_d
end type

type cb_delete from w_com010_d`cb_delete within w_56016_d
end type

type cb_insert from w_com010_d`cb_insert within w_56016_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56016_d
end type

type cb_update from w_com010_d`cb_update within w_56016_d
end type

type cb_print from w_com010_d`cb_print within w_56016_d
end type

type cb_preview from w_com010_d`cb_preview within w_56016_d
end type

type gb_button from w_com010_d`gb_button within w_56016_d
end type

type cb_excel from w_com010_d`cb_excel within w_56016_d
end type

type dw_head from w_com010_d`dw_head within w_56016_d
integer height = 188
string dataobject = "d_56016_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56016_d
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_d`ln_2 within w_56016_d
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_d`dw_body within w_56016_d
integer y = 404
integer height = 1636
string dataobject = "d_56016_d01"
end type

type dw_print from w_com010_d`dw_print within w_56016_d
string dataobject = "d_56016_r01"
end type

