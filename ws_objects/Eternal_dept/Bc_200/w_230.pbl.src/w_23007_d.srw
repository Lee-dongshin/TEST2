$PBExportHeader$w_23007_d.srw
$PBExportComments$원부자재 지불마감현황
forward
global type w_23007_d from w_com010_d
end type
end forward

global type w_23007_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_23007_d w_23007_d

type variables
string is_brand, is_mat_gubn, is_st_ymd, is_ed_ymd, is_cust_cd
datawindowchild idw_brand, idw_color
end variables

on w_23007_d.create
call super::create
end on

on w_23007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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
is_mat_gubn = dw_head.GetItemString(1, "mat_gubn")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")

is_st_ymd = dw_head.GetItemString(1, "st_ymd")
is_ed_ymd = dw_head.GetItemString(1, "ed_ymd")


if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("is_brand",is_brand)
//messagebox("is_mat_gubn",is_mat_gubn)
//messagebox("is_cust_cd",is_cust_cd)
//
//messagebox("is_st_ymd",is_st_ymd)
//messagebox("is_ed_ymd",is_ed_ymd)


il_rows = dw_body.retrieve(is_brand, is_mat_gubn, is_cust_cd, is_st_ymd, is_ed_ymd)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
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
			
			gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' AND  CUST_CODE  > '5000' and cust_code < '8999'  "
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

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"st_ymd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"ed_ymd",string(ld_datetime,"yyyymmdd"))
end IF

dw_head.setitem(1,"mat_gubn","1")
end event

event ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime
string ls_fr_ymd, ls_to_ymd, ls_brand, ls_mat_gubn, ls_cust_cd

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_fr_ymd = is_st_ymd
ls_to_ymd = is_ed_ymd
ls_brand  = idw_brand.getitemstring(idw_brand.getrow(),"brand")
if is_mat_gubn = "1" then
	ls_mat_gubn = "원자재"
elseif is_mat_gubn = "2" then
	ls_mat_gubn = "부자재"
else
	ls_mat_gubn = "전체"	
end if

if isnull(ls_fr_ymd) then ls_fr_ymd = " "
if isnull(ls_to_ymd) then ls_to_ymd = " "
if isnull(ls_brand)  then ls_brand = " "
if isnull(ls_mat_gubn) then ls_mat_gubn = " "
if isnull(ls_cust_cd) then ls_cust_cd = " " 


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + ls_datetime + "'" + &
				"t_mat_gubn.Text = '" + ls_mat_gubn + "'" + &
				"t_cust_cd.Text = '" + ls_cust_cd + "'" + &
				"t_fr_ymd.Text = '" + ls_fr_ymd + "'" + &
				"t_to_ymd.Text = '" + ls_to_ymd + "'"

													
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23007_d","0")
end event

type cb_close from w_com010_d`cb_close within w_23007_d
end type

type cb_delete from w_com010_d`cb_delete within w_23007_d
end type

type cb_insert from w_com010_d`cb_insert within w_23007_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23007_d
end type

type cb_update from w_com010_d`cb_update within w_23007_d
end type

type cb_print from w_com010_d`cb_print within w_23007_d
end type

type cb_preview from w_com010_d`cb_preview within w_23007_d
end type

type gb_button from w_com010_d`gb_button within w_23007_d
end type

type cb_excel from w_com010_d`cb_excel within w_23007_d
end type

type dw_head from w_com010_d`dw_head within w_23007_d
string dataobject = "d_23007_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')




end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : itemchanged(dw_head)                                        */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_23007_d
end type

type ln_2 from w_com010_d`ln_2 within w_23007_d
end type

type dw_body from w_com010_d`dw_body within w_23007_d
string dataobject = "d_23007_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;this.getchild("color",idw_color)
idw_color.settransobject(sqlca)
idw_color.retrieve()

end event

type dw_print from w_com010_d`dw_print within w_23007_d
integer x = 114
integer y = 500
string dataobject = "d_23007_r01"
end type

