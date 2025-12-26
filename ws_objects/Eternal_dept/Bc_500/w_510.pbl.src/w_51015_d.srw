$PBExportHeader$w_51015_d.srw
$PBExportComments$판매사원인사정보
forward
global type w_51015_d from w_com010_d
end type
end forward

global type w_51015_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_51015_d w_51015_d

type variables
DataWindowChild idw_brand, idw_empno
String is_brand, is_shop_cd, is_empno, is_goout_gubn
end variables

on w_51015_d.create
call super::create
end on

on w_51015_d.destroy
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

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
	is_empno = "%"
end if

is_goout_gubn = dw_head.GetItemString(1, "goout_gubn")
if IsNull(is_goout_gubn) or Trim(is_goout_gubn) = "" then
   MessageBox(ls_title,"근무구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("goout_gubn")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + &
											 " and brand = '" + gs_brand + "'"
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
				dw_head.SetColumn("end_ymd")
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

il_rows = dw_body.retrieve(is_brand, is_shop_cd, is_empno, is_goout_gubn)
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
string ls_modify, ls_datetime, ls_title_nm, ls_shop_nm, ls_emp, ls_goout_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_empno = "%" then 
	ls_emp = "% 전체"
else	
	ls_emp =  idw_empno.GetItemString(idw_empno.GetRow(), "inter_display")
end if	

if is_shop_cd = "%" then 
	ls_shop_nm = "전체"
else	
	ls_shop_nm =  dw_head.getitemstring(1, "shop_nm")
end if	

if is_goout_gubn = "%" then 
	ls_goout_gubn = "% 전체"
elseif is_goout_gubn = "1" then 	
	ls_goout_gubn = "1 근무"
else	
	ls_goout_gubn = "2 퇴사"	
end if	


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				 "t_emp.text = '" + ls_emp + "' " + &
				 "t_shop_cd.text  = '" + is_shop_cd + "'" + &
				 "t_shop_nm.text  = '" + ls_shop_nm + "'" + &
				 "t_emp.text  = '" + ls_emp + "'" + &				 
				 "t_goout_gubn.text  = '" + ls_goout_gubn + "'" + &				 				 
				 "t_title_nm.Text = '" + ls_title_nm + "'"  
				 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_51015_d
end type

type cb_delete from w_com010_d`cb_delete within w_51015_d
end type

type cb_insert from w_com010_d`cb_insert within w_51015_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51015_d
end type

type cb_update from w_com010_d`cb_update within w_51015_d
end type

type cb_print from w_com010_d`cb_print within w_51015_d
end type

type cb_preview from w_com010_d`cb_preview within w_51015_d
end type

type gb_button from w_com010_d`gb_button within w_51015_d
end type

type cb_excel from w_com010_d`cb_excel within w_51015_d
end type

type dw_head from w_com010_d`dw_head within w_51015_d
integer y = 176
integer height = 144
string dataobject = "d_51015_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(0)
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_work_type, ls_person_id
CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
		idw_empno.InsertRow(0)
		
CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		
	  if isnull(data) or  Trim(data) = ""  then 
			dw_head.setitem(1, "shop_nm", "")
			RETURN 0
	  else
		  return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
	end if  


			
END CHOOSE


end event

type ln_1 from w_com010_d`ln_1 within w_51015_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_51015_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_51015_d
integer y = 336
integer height = 1704
string dataobject = "D_51015_D01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_51015_d
string dataobject = "d_51015_r01"
end type

