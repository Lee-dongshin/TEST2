$PBExportHeader$w_cu120_d.srw
$PBExportComments$선급금현황
forward
global type w_cu120_d from w_com010_d
end type
end forward

global type w_cu120_d from w_com010_d
integer width = 3653
integer height = 2236
end type
global w_cu120_d w_cu120_d

type variables
string is_brand, is_fr_yymmdd,  is_to_yymmdd
datawindowchild idw_brand
end variables

on w_cu120_d.create
call super::create
end on

on w_cu120_d.destroy
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
	ls_title =  '조회오류' 
ELSEIF as_cb_div = '2' THEN
	ls_title =  '추가오류' 
ELSEIF as_cb_div = '3' THEN
	ls_title =  '저장오류' 
ELSE
	ls_title =  '오류' 
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title, "브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title, "From기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title, "To기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

If  is_fr_yymmdd > is_to_yymmdd  then
	MessageBox('경고', "From일자가 To일자보다 큽니다 !!")
	 dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_fr_yymmdd,is_to_yymmdd,gs_shop_cd)
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
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" +  idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_fr_yymmdd.Text = '" + string(is_fr_yymmdd,'@@@@/@@/@@') + "'" + &
				 "t_to_yymmdd.Text = '" + string(is_to_yymmdd,'@@@@/@@/@@') + "'"
dw_print.Modify(ls_modify)



end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_to_yymmdd, ls_fr_yymmdd

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_to_yymmdd  = string(ld_datetime, 'yyyymmdd')
ls_fr_yymmdd  = LeftA(ls_to_yymmdd,4) +  '0101'

dw_head.Setitem(1,"fr_yymmdd",ls_fr_yymmdd)
dw_head.Setitem(1,"to_yymmdd",ls_to_yymmdd)



end event

type cb_close from w_com010_d`cb_close within w_cu120_d
end type

type cb_delete from w_com010_d`cb_delete within w_cu120_d
end type

type cb_insert from w_com010_d`cb_insert within w_cu120_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_cu120_d
end type

type cb_update from w_com010_d`cb_update within w_cu120_d
end type

type cb_print from w_com010_d`cb_print within w_cu120_d
end type

type cb_preview from w_com010_d`cb_preview within w_cu120_d
end type

type gb_button from w_com010_d`gb_button within w_cu120_d
integer width = 3602
end type

type dw_head from w_com010_d`dw_head within w_cu120_d
integer width = 3589
integer height = 152
string dataobject = "d_cu120_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/



CHOOSE CASE dwo.name
	CASE "fr_yymmdd" 
     IF not gf_datechk(data)  THEN 
		  messagebox("경고", '날자 형식이 잘못 되었습니다 !')
		  return 1
	  end if
	  
	CASE "to_yymmdd" 
     IF not gf_datechk(data)  THEN 
		  messagebox("경고", '날자 형식이 잘못 되었습니다 !')
		  return 1
	  end if
	  
          
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_cu120_d
integer beginy = 332
integer endx = 3611
integer endy = 332
end type

type ln_2 from w_com010_d`ln_2 within w_cu120_d
integer beginy = 336
integer endx = 3611
integer endy = 336
end type

type dw_body from w_com010_d`dw_body within w_cu120_d
integer y = 348
integer width = 3607
integer height = 1696
string dataobject = "d_cu120_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild idw_child
This.GetChild("brand", idw_child )
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('001')

This.GetChild("mat_type", idw_child )
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('014')

end event

type dw_print from w_com010_d`dw_print within w_cu120_d
string dataobject = "d_cu120_r01"
end type

event dw_print::constructor;call super::constructor;datawindowchild idw_child
This.GetChild("brand", idw_child )
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('001')

This.GetChild("mat_type", idw_child )
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('014')

end event

