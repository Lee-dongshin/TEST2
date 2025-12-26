$PBExportHeader$w_56312_d.srw
$PBExportComments$중국매장 미수금조회
forward
global type w_56312_d from w_com010_d
end type
end forward

global type w_56312_d from w_com010_d
end type
global w_56312_d w_56312_d

type variables
STRING IS_SHOP_CD, IS_FRM_DATE, IS_TO_DATE
end variables

on w_56312_d.create
call super::create
end on

on w_56312_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "FRM_date" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "TO_date" ,string(ld_datetime,"yyyymmdd"))

end event

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

is_SHOP_CD = dw_head.GetItemString(1, "SHOP_CD")
if IsNull(is_SHOP_CD) or Trim(is_SHOP_CD) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("SHOP_CD")
   return false
end if




IS_FRM_DATE = dw_head.GetItemString(1, "FRM_DATE")
if IsNull(IS_FRM_DATE) or Trim(IS_FRM_DATE) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("FRM_DATE")
   return false
end if

IS_TO_DATE = dw_head.GetItemString(1, "TO_DATE")
if IsNull(IS_TO_DATE) or Trim(IS_TO_DATE) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("TO_DATE")
   return false
end if



return true

end event

event ue_retrieve;call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(IS_SHOP_CD, IS_FRM_DATE, IS_TO_DATE)
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

event ue_title;call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_string, LS_NAME

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_string = dw_head.getitemstring(1, "shop_cd")

if ls_string = 'NT3516' THEN 
	 LS_NAME = 'NT3516 중국심천'
ELSE	 
    LS_NAME = 'NT3533 중국대련'
END IF		
ls_modify =	   "t_shop_cd.Text = '" + LS_NAME + "'" + &
					"t_FRM_DATE.Text = '" + DW_HEAD.GetItemString(1, "FRM_DATE") + "'"  + &
					"t_TO_DATE.Text = '" + DW_HEAD.GetItemString(1, "TO_DATE") + "'" 					

dw_print.Modify(ls_modify)

end event

event ue_print;call super::ue_print; if is_shop_cd = "NT3516" then 
			dw_body.dataobject = "d_56312_d01"
			dw_print.dataobject = "d_56312_r01"	
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)
		else	
			dw_body.dataobject = "d_56312_d02"
			dw_print.dataobject = "d_56312_r02"		
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)			
		end if 	
end event

event ue_preview;call super::ue_preview; if is_shop_cd = "NT3516" then 
			dw_body.dataobject = "d_56312_d01"
			dw_print.dataobject = "d_56312_r01"	
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)
		else	
			dw_body.dataobject = "d_56312_d02"
			dw_print.dataobject = "d_56312_r02"		
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)			
		end if 	
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56312_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56312_d
end type

type cb_delete from w_com010_d`cb_delete within w_56312_d
end type

type cb_insert from w_com010_d`cb_insert within w_56312_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56312_d
end type

type cb_update from w_com010_d`cb_update within w_56312_d
end type

type cb_print from w_com010_d`cb_print within w_56312_d
end type

type cb_preview from w_com010_d`cb_preview within w_56312_d
end type

type gb_button from w_com010_d`gb_button within w_56312_d
end type

type cb_excel from w_com010_d`cb_excel within w_56312_d
end type

type dw_head from w_com010_d`dw_head within w_56312_d
integer y = 208
integer width = 3255
integer height = 200
string dataobject = "d_56312_h01"
end type

event dw_head::itemchanged;call super::itemchanged;	CHOOSE CASE dwo.name
	
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		 if data = "NT3516" then 
			dw_body.dataobject = "d_56312_d01"
			dw_print.dataobject = "d_56312_r01"	
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)
		else	
			dw_body.dataobject = "d_56312_d02"
			dw_print.dataobject = "d_56312_r02"		
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)			
		end if 	
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56312_d
end type

type ln_2 from w_com010_d`ln_2 within w_56312_d
end type

type dw_body from w_com010_d`dw_body within w_56312_d
string dataobject = "d_56312_d01"
end type

type dw_print from w_com010_d`dw_print within w_56312_d
string dataobject = "d_56312_r02"
end type

