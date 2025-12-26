$PBExportHeader$w_81115_e.srw
$PBExportComments$인사최종평가
forward
global type w_81115_e from w_com010_e
end type
type dw_1 from datawindow within w_81115_e
end type
type cbx_1 from checkbox within w_81115_e
end type
type dw_2 from datawindow within w_81115_e
end type
end forward

global type w_81115_e from w_com010_e
integer height = 2244
dw_1 dw_1
cbx_1 cbx_1
dw_2 dw_2
end type
global w_81115_e w_81115_e

type variables
string  is_yyyy, is_head_dept
datawindowchild  idw_head_dept, idw_stat
end variables

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
end event

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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_head_dept = dw_head.GetItemString(1, "head_dept")
if IsNull(is_head_dept) or Trim(is_head_dept) = "" then
   MessageBox(ls_title,"사업본부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("head_dept")
   return false
end if
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yyyy,is_head_dept)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

il_rows = dw_1.retrieve(is_yyyy,is_head_dept)
This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      		  */	
/* 작성일      : 2001..                                                  	  */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
long i, ll_row_count, id_cnt
datetime ld_datetime

 
 if cbx_1.checked  then  
	
	id_cnt = dw_body.find("  last_grade  not in ( 'S','A','B','C','D','E') ", 1, dw_body.rowCount() ) 
	
	if id_cnt > 0 then 
		messagebox('확인', '최종평가 미완료된 직원이 있습니다 !!') 
		return -1
	end if
	
    	id_cnt = dw_body.find("status <  'C' ", 1, dw_body.rowCount() ) 
	
	if id_cnt > 0 then 
		messagebox('확인', '2차평가 미완료된 직원이 있습니다 !!') 
		return -1
	end if
	
	
   
	
	update a set status = 'D'
	from    tb_81101_m a
	where   yyyy = :is_yyyy
	and     head_dept = :is_head_dept
	and     isnull(status,'') = 'C';  
else
	messagebox('확인', '제출하기 클릭 후 저장하십시오 !!') 
	RETURN -1
end if
 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

messagebox('확인', '저장되었습니다 !!') 

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

end event

on w_81115_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.dw_2
end on

on w_81115_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.dw_2)
end on

type cb_close from w_com010_e`cb_close within w_81115_e
end type

type cb_delete from w_com010_e`cb_delete within w_81115_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_81115_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_81115_e
end type

type cb_update from w_com010_e`cb_update within w_81115_e
end type

type cb_print from w_com010_e`cb_print within w_81115_e
end type

type cb_preview from w_com010_e`cb_preview within w_81115_e
end type

type gb_button from w_com010_e`gb_button within w_81115_e
end type

type cb_excel from w_com010_e`cb_excel within w_81115_e
end type

type dw_head from w_com010_e`dw_head within w_81115_e
integer width = 2299
string dataobject = "d_81115_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("head_dept", idw_head_dept)
idw_head_dept.SetTransObject(SQLCA)
idw_head_dept.Retrieve('005')
idw_head_dept.InsertRow(1)
idw_head_dept.SetItem(1, "inter_cd", '%')
idw_head_dept.SetItem(1, "inter_nm", '전사')
end event

type ln_1 from w_com010_e`ln_1 within w_81115_e
end type

type ln_2 from w_com010_e`ln_2 within w_81115_e
end type

type dw_body from w_com010_e`dw_body within w_81115_e
string dataobject = "d_81115_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;This.GetChild("status", idw_stat)
idw_stat.SetTransObject(SQLCA)
idw_stat.Retrieve('815')
end event

event dw_body::doubleclicked;call super::doubleclicked;string is_empno , is_jikgun_type


is_empno = dw_body.getitemstring(row, "empno" )

il_rows = dw_2.retrieve(is_yyyy, is_empno)
dw_2.visible = true
end event

type dw_print from w_com010_e`dw_print within w_81115_e
string dataobject = "d_81115_d01"
end type

event dw_print::constructor;call super::constructor;This.GetChild("status", idw_stat)
idw_stat.SetTransObject(SQLCA)
idw_stat.Retrieve('815')
end event

type dw_1 from datawindow within w_81115_e
integer x = 1083
integer y = 68
integer width = 1339
integer height = 1552
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "2평가구성율표"
string dataobject = "d_81116_d01"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_81115_e
integer x = 3109
integer y = 344
integer width = 466
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 16711935
string text = "제출하기"
borderstyle borderstyle = stylelowered!
end type

event clicked;cb_update.enabled = true
end event

type dw_2 from datawindow within w_81115_e
boolean visible = false
integer x = 265
integer y = 4
integer width = 3104
integer height = 2060
integer taborder = 40
boolean titlebar = true
string title = "인사평가세부내역"
string dataobject = "d_81115_d02"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

