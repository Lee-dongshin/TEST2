$PBExportHeader$w_cu119_d.srw
$PBExportComments$계산서 정산현황
forward
global type w_cu119_d from w_com010_d
end type
end forward

global type w_cu119_d from w_com010_d
integer width = 3653
integer height = 2236
end type
global w_cu119_d w_cu119_d

type variables
string  is_from_date, is_to_date
end variables

on w_cu119_d.create
call super::create
end on

on w_cu119_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime
string ls_modify, ls_to_yymmdd, ls_fr_yymmdd

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_to_yymmdd  = string(ld_datetime, 'yyyymmdd')
ls_fr_yymmdd  = LeftA(ls_to_yymmdd,6) +  '01'

dw_head.Setitem(1,"from_date",ls_fr_yymmdd)
dw_head.Setitem(1,"to_date",ls_to_yymmdd)



end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/* event       : ue_keycheck                                                 */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

is_from_date = dw_head.GetItemstring(1,"from_date")
if IsNull(is_from_date) Or Trim(is_from_date) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("from_date")
	return false
end if

is_to_date =  dw_head.GetItemString(1,"to_date")
if IsNull(is_to_date) Or Trim(is_to_date) = "" then
   MessageBox(ls_title,"To일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("to_date")
	return false
end if

if is_to_date < is_from_date  then
	MessageBox(ls_title, "마지막 일자가 처음 일자보다 작습니다!")
   dw_head.SetFocus()
	dw_head.SetColumn("to_date")
	return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_from_date,is_to_date,gs_shop_cd)
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
             "t_from_date.Text = '" + string(is_from_date,'@@@@/@@/@@') + "'" + &
				 "t_to_date.Text = '" + string(is_to_date,'@@@@/@@/@@') + "'"
dw_print.Modify(ls_modify)



end event

type cb_close from w_com010_d`cb_close within w_cu119_d
end type

type cb_delete from w_com010_d`cb_delete within w_cu119_d
end type

type cb_insert from w_com010_d`cb_insert within w_cu119_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_cu119_d
end type

type cb_update from w_com010_d`cb_update within w_cu119_d
end type

type cb_print from w_com010_d`cb_print within w_cu119_d
end type

type cb_preview from w_com010_d`cb_preview within w_cu119_d
end type

type gb_button from w_com010_d`gb_button within w_cu119_d
integer width = 3598
end type

type dw_head from w_com010_d`dw_head within w_cu119_d
integer width = 3579
integer height = 124
string dataobject = "d_cu119_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/



CHOOSE CASE dwo.name
	CASE "from_date" 
     IF not gf_datechk(data)  THEN 
		  messagebox("경고", '날자 형식이 잘못 되었습니다 !')
		  return 1
	  end if
	  
	CASE "to_date" 
     IF not gf_datechk(data)  THEN 
		  messagebox("경고", '날자 형식이 잘못 되었습니다 !')
		  return 1
	  end if
	  
          
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_cu119_d
integer beginy = 300
integer endx = 3607
integer endy = 300
end type

type ln_2 from w_com010_d`ln_2 within w_cu119_d
integer beginy = 304
integer endx = 3607
integer endy = 304
end type

type dw_body from w_com010_d`dw_body within w_cu119_d
integer y = 316
integer width = 3602
integer height = 1732
string dataobject = "d_cu119_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_cu119_d
string dataobject = "d_cu119_r01"
end type

