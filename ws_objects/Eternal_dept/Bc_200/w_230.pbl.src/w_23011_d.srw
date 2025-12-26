$PBExportHeader$w_23011_d.srw
$PBExportComments$원부자재구입실적(종합)조회
forward
global type w_23011_d from w_com010_d
end type
end forward

global type w_23011_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_23011_d w_23011_d

type variables
string is_brand, is_yy, is_gubn, is_mat_type
string is_mat_type_0, is_mat_type_1, is_mat_type_2, is_mat_type_3, is_mat_type_4
string is_mat_type_5, is_mat_type_6, is_mat_type_7, is_mat_type_8, is_mat_type_9
datawindowchild idw_brand, idw_mat_type
end variables

on w_23011_d.create
call super::create
end on

on w_23011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yy",string(ld_datetime,"yyyy"))
end if


end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

is_brand    = dw_head.GetItemString(1, "brand")
is_yy       = dw_head.GetItemString(1, "yy")
is_gubn     = dw_head.GetItemString(1, "gubn")

is_mat_type_0     = dw_head.GetItemString(1, "mat_type_0")
is_mat_type_1     = dw_head.GetItemString(1, "mat_type_1")
is_mat_type_2     = dw_head.GetItemString(1, "mat_type_2")
is_mat_type_3     = dw_head.GetItemString(1, "mat_type_3")
is_mat_type_4     = dw_head.GetItemString(1, "mat_type_4")
is_mat_type_5     = dw_head.GetItemString(1, "mat_type_5")
is_mat_type_6     = dw_head.GetItemString(1, "mat_type_6")
is_mat_type_7     = dw_head.GetItemString(1, "mat_type_7")
is_mat_type_8     = dw_head.GetItemString(1, "mat_type_8")
is_mat_type_9     = dw_head.GetItemString(1, "mat_type_9")

is_mat_type = is_mat_type_0 + is_mat_type_1 + is_mat_type_2 + is_mat_type_3 + is_mat_type_4  &
				+ is_mat_type_5 + is_mat_type_6 + is_mat_type_7 + is_mat_type_8 + is_mat_type_9

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				END IF
				
				IF LeftA(as_data, 1) = is_brand and gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
			
			gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' AND  CUST_CODE  > '5000'   "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(CUSTCODE LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("smat_cd")
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yy, is_gubn, is_mat_type)
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

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_brand, ls_yyyy, ls_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_brand = idw_brand.getitemstring(idw_brand.getrow(),"inter_display")
ls_yyyy = dw_head.getitemstring(1,"yy")

ls_gubn = dw_head.getitemstring(1,"gubn")
if ls_gubn = '1' then 
	ls_gubn = '입고기준'
else
	ls_gubn = '만기기준'	
end if

if isnull(ls_brand) then ls_brand = ' '
if isnull(ls_yyyy) then ls_yyyy = ' '
if isnull(ls_gubn) then ls_gubn = ' '

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + ls_brand + "'" + &
             "t_yyyy.Text = '" + ls_yyyy + "'" + &
             "t_gubn.Text = '" + ls_gubn + "'"				 
dw_print.Modify(ls_modify)
is_mat_type = ' '
if is_mat_type_1 = '1' then	is_mat_type = is_mat_type + ',원자재'
if is_mat_type_2 = '2' then	is_mat_type = is_mat_type + ',부자재'
if is_mat_type_3 = '3' then	is_mat_type = is_mat_type + ',완사입'
if is_mat_type_4 = '4' then	is_mat_type = is_mat_type + ',수입완사입'
if is_mat_type_5 = '5' then	is_mat_type = is_mat_type + ',수입원자재'
if is_mat_type_6 = '6' then	is_mat_type = is_mat_type + ',임봉료'
if is_mat_type_8 = '8' then	is_mat_type = is_mat_type + ',시장원자재'
if is_mat_type_9 = '9' then	is_mat_type = is_mat_type + ',시장부자재'
if is_mat_type_0 = '0' then	is_mat_type = is_mat_type + ',수입부자재'

dw_print.object.t_mat_type.text = is_mat_type
//

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23011_d","0")
end event

type cb_close from w_com010_d`cb_close within w_23011_d
end type

type cb_delete from w_com010_d`cb_delete within w_23011_d
end type

type cb_insert from w_com010_d`cb_insert within w_23011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23011_d
end type

type cb_update from w_com010_d`cb_update within w_23011_d
end type

type cb_print from w_com010_d`cb_print within w_23011_d
end type

type cb_preview from w_com010_d`cb_preview within w_23011_d
end type

type gb_button from w_com010_d`gb_button within w_23011_d
end type

type cb_excel from w_com010_d`cb_excel within w_23011_d
end type

type dw_head from w_com010_d`dw_head within w_23011_d
integer width = 3566
string dataobject = "d_23011_h01"
end type

event dw_head::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')






end event

type ln_1 from w_com010_d`ln_1 within w_23011_d
end type

type ln_2 from w_com010_d`ln_2 within w_23011_d
end type

type dw_body from w_com010_d`dw_body within w_23011_d
string dataobject = "d_23011_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_23011_d
string dataobject = "d_23011_r01"
end type

