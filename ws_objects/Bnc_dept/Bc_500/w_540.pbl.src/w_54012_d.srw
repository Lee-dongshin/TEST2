$PBExportHeader$w_54012_d.srw
$PBExportComments$완불 진행 집계
forward
global type w_54012_d from w_com010_d
end type
end forward

global type w_54012_d from w_com010_d
end type
global w_54012_d w_54012_d

type variables
DataWindowChild idw_brand, idw_empno

String is_brand, is_fr_ymd, is_to_ymd, is_empno, is_odf_ymd, is_odt_ymd

end variables

on w_54012_d.create
call super::create
end on

on w_54012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.03                                                  */	
/* 수정일      : 2002.04.03                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_empno, is_odf_ymd, is_odt_ymd)

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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.03                                                  */	
/* 수정일      : 2002.04.03                                                  */
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





if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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




is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"요청 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"요청 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_odf_ymd = Trim(String(dw_head.GetItemDate(1, "odf_ymd"), 'yyyymmdd'))
if IsNull(is_odf_ymd) or is_odf_ymd = ""  then
	is_odf_ymd = '00000000'
end if

is_odt_ymd = Trim(String(dw_head.GetItemDate(1, "odt_ymd"), 'yyyymmdd'))
if IsNull(is_odt_ymd) or is_odt_ymd = "" then
	is_odt_ymd = '99999999'
end if

//messagebox(is_odf_ymd, is_odt_ymd)


if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_empno = Trim(dw_head.GetItemString(1, "empno"))
if IsNull(is_empno) or is_empno = "" then
 is_empno = "%"
end if

return true

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.03                                                  */	
/* 수정일      : 2002.04.03                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text = '" + String(is_fr_ymd + is_to_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54012_d","0")
end event

type cb_close from w_com010_d`cb_close within w_54012_d
end type

type cb_delete from w_com010_d`cb_delete within w_54012_d
end type

type cb_insert from w_com010_d`cb_insert within w_54012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_54012_d
end type

type cb_update from w_com010_d`cb_update within w_54012_d
end type

type cb_print from w_com010_d`cb_print within w_54012_d
end type

type cb_preview from w_com010_d`cb_preview within w_54012_d
end type

type gb_button from w_com010_d`gb_button within w_54012_d
end type

type cb_excel from w_com010_d`cb_excel within w_54012_d
end type

type dw_head from w_com010_d`dw_head within w_54012_d
integer y = 160
integer height = 200
string dataobject = "d_54012_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(0)

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

	CASE "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
	//	return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
		idw_empno.InsertRow(0)		

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_54012_d
integer beginy = 368
integer endy = 368
end type

type ln_2 from w_com010_d`ln_2 within w_54012_d
integer beginy = 372
integer endy = 372
end type

type dw_body from w_com010_d`dw_body within w_54012_d
integer y = 384
integer height = 1656
string dataobject = "d_54012_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_54012_d
integer x = 2469
integer y = 856
string dataobject = "d_54012_r02"
end type

