$PBExportHeader$w_81119_d.srw
$PBExportComments$개인평가표조회
forward
global type w_81119_d from w_com010_d
end type
type dw_1 from datawindow within w_81119_d
end type
type dw_2 from datawindow within w_81119_d
end type
type pb_1 from picturebutton within w_81119_d
end type
type pb_2 from picturebutton within w_81119_d
end type
type pb_3 from picturebutton within w_81119_d
end type
type pb_4 from picturebutton within w_81119_d
end type
end forward

global type w_81119_d from w_com010_d
integer width = 3666
integer height = 2304
dw_1 dw_1
dw_2 dw_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
end type
global w_81119_d w_81119_d

type variables
string is_yyyy, is_empno,is_gubun, is_jikgun_type, is_first_staff, is_second_staff 
long   il_ok_empno
datawindowchild idw_first, idw_second, idw_jikgun_type
end variables

event open;call super::open;string is_first_staff_nm, is_second_staff_nm  
long   ll_person_cnt

dw_head.setitem(1,"empno",gs_user_id)
dw_head.setitem(1,"kname",gs_user_nm)
//Trigger Event ue_Popup("empno", 1, gs_user_id, 1)

is_yyyy = dw_head.getitemstring(1,"yyyy")

select jikgun_type, gubun, first_staff,  second_staff, dbo.sf_emp_nm(first_staff)  as first_staff_nm, dbo.sf_emp_nm(second_staff) as second_staff_nm 
	into :is_jikgun_type,:is_gubun, :is_first_staff, :is_second_staff, :is_first_staff_nm, :is_second_staff_nm
from tb_81104_c (nolock)
where yyyy = :is_yyyy 
and   empno = :gs_user_id;


select count(empno) 
into	:ll_person_cnt
from  tb_81101_m (nolock) 
where  :gs_user_id  in (first_staff, second_staff);


select count(person_id) 
into	:il_ok_empno
from  tb_93040_h (nolock)
where pgm_id = 'w_81115_e'
and   person_id = :gs_user_id;


if   ( ll_person_cnt > 0  or il_ok_empno > 0 ) then
		pb_1.visible = true
		pb_2.visible = true
		pb_3.visible = true
		pb_4.visible = true
//elseif il_ok_empno > 0    then
//		pb_1.visible = true
//		pb_2.visible = true
//		pb_3.visible = true
//		pb_4.visible = true
else
     	pb_1.visible = false
		pb_2.visible = false
		pb_3.visible = false
		pb_4.visible = false
end if



dw_head.setitem(1,"jikgun_type",is_jikgun_type)
dw_head.setitem(1,"first_staff",is_first_staff)
dw_head.setitem(1,"second_staff",is_second_staff)

dw_head.setitem(1,"first_staff_nm",is_first_staff_nm)
dw_head.setitem(1,"second_staff_nm",is_second_staff_nm)


dw_1.insertrow(1)
dw_body.insertrow(1)
dw_2.insertrow(1)
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

//if is_yyyy = "2013" then
//   MessageBox(ls_title,"2013년도는 3월 이후에 조회가 가능합니다!")
//   return false
//end if

is_empno = dw_head.GetItemString(1, "empno")

if is_yyyy = "2012" and (is_empno = "990705" or is_empno = "A51001" or is_empno = "S10111" or is_empno = "S10121" or is_empno = "S11041" or is_empno = "S11091") then
   MessageBox(ls_title,"2012년도는 4월 이후에 조회가 가능합니다!")
   return false
end if

if is_yyyy = "2013" and (is_empno = "990705" or is_empno = "A51001" or is_empno = "B20219" or is_empno = "B20403") then
   MessageBox(ls_title,"2013년도는 4월 이후에 조회가 가능합니다!")
   return false
end if

//if IsNull(is_empno) or Trim(is_empno) = "" then
//   MessageBox(ls_title,"사번을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("empno")
//   return false
//end if
//
//is_jikgun_type = dw_head.GetItemString(1, "jikgun_type")
//if IsNull(is_jikgun_type) or Trim(is_jikgun_type) = "" then
//   MessageBox(ls_title,"직군을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("jikgun_type")
//   return false
//end if
//
//is_first_staff  = dw_head.GetItemString(1, "first_staff")
////if IsNull(is_first_staff) or Trim(is_first_staff) = "" then
////   MessageBox(ls_title,"1차상사를 입력하십시요!")
////   dw_head.SetFocus()
////   dw_head.SetColumn("first_staff")
////   return false
////end if
//
//is_second_staff = dw_head.GetItemString(1, "second_staff")
////if IsNull(is_second_staff) or Trim(is_second_staff) = "" then
////   MessageBox(ls_title,"2차상사를 입력하십시요!")
////   dw_head.SetFocus()
////   dw_head.SetColumn("second_staff")
////   return false
////end if
//
//
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_flag
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_yyyy, is_empno, is_jikgun_type, is_first_staff, is_second_staff)

il_rows = dw_body.retrieve(is_yyyy, is_empno, is_jikgun_type)

il_rows = dw_2.retrieve(is_yyyy, is_empno, is_jikgun_type, is_first_staff, is_second_staff)


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
il_rows = dw_print.retrieve(is_yyyy, is_empno, is_jikgun_type, is_first_staff, is_second_staff, 'A')
//dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()


end event

on w_81119_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.pb_4
end on

on w_81119_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
end on

event pfc_preopen();call super::pfc_preopen;dw_head.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_2, "FixedToBottom&ScaleToRight")
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

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_title.text = is_yyyy+'년 인사평가'


end event

type cb_close from w_com010_d`cb_close within w_81119_d
end type

type cb_delete from w_com010_d`cb_delete within w_81119_d
end type

type cb_insert from w_com010_d`cb_insert within w_81119_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_81119_d
end type

type cb_update from w_com010_d`cb_update within w_81119_d
end type

type cb_print from w_com010_d`cb_print within w_81119_d
end type

type cb_preview from w_com010_d`cb_preview within w_81119_d
end type

type gb_button from w_com010_d`gb_button within w_81119_d
end type

type cb_excel from w_com010_d`cb_excel within w_81119_d
end type

type dw_head from w_com010_d`dw_head within w_81119_d
integer x = 69
integer y = 180
integer width = 1422
string dataobject = "d_81119_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("jikgun_type", idw_jikgun_type)
idw_jikgun_type.SetTransObject(SQLCA)
idw_jikgun_type.Retrieve('')
idw_jikgun_type.InsertRow(1)

//This.GetChild("first_staff", idw_first)
//idw_first.SetTransObject(SQLCA)
//idw_first.Retrieve('')
//idw_first.InsertRow(1)
//
//This.GetChild("second_staff", idw_second)
//idw_second.SetTransObject(SQLCA)
//idw_second.Retrieve('')
//idw_second.InsertRow(1)
end event

type ln_1 from w_com010_d`ln_1 within w_81119_d
end type

type ln_2 from w_com010_d`ln_2 within w_81119_d
end type

type dw_body from w_com010_d`dw_body within w_81119_d
integer x = 18
integer y = 800
integer height = 596
string dataobject = "d_81119_d01"
end type

type dw_print from w_com010_d`dw_print within w_81119_d
integer x = 1810
integer y = 848
string dataobject = "d_81119_r00"
end type

type dw_1 from datawindow within w_81119_d
integer x = 18
integer y = 460
integer width = 3589
integer height = 348
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_81119_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_81119_d
integer x = 23
integer y = 1388
integer width = 3579
integer height = 716
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_81119_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_81119_d
boolean visible = false
integer x = 2853
integer y = 228
integer width = 169
integer height = 148
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "previous.bmp"
alignment htextalign = left!
end type

event clicked;string   ls_empno, ls_kname


IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
if  il_ok_empno > 0 then 
	select top 1 empno , dbo.sf_emp_nm(empno) as kname,
			  jikgun_type, first_staff, second_staff
	 into	 :ls_empno, :ls_kname, :is_jikgun_type, :is_first_staff, :is_second_staff
	from tb_81101_m 
	where yyyy = :is_yyyy
	and   empno <  :is_empno 
	order by empno desc; 
else
	select top 1 empno , dbo.sf_emp_nm(empno) as kname,
			  jikgun_type, first_staff, second_staff
	 into	 :ls_empno, :ls_kname, :is_jikgun_type, :is_first_staff, :is_second_staff
	from tb_81101_m 
	where yyyy = :is_yyyy
	and   :gs_user_id   in (first_staff, second_staff)
	and   empno <  :is_empno 
	order by empno desc; 
end if

dw_head.Setitem(1,"empno", ls_empno)
dw_head.Setitem(1,"kname", ls_kname)


if IsNull(ls_empno) or Trim(ls_empno) = ""  then 
else
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
	Trigger Event ue_retrieve()
end if


end event

type pb_2 from picturebutton within w_81119_d
boolean visible = false
integer x = 3026
integer y = 228
integer width = 169
integer height = 148
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "next.bmp"
alignment htextalign = left!
end type

event clicked;string   ls_empno, ls_kname

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	

if  il_ok_empno > 0 then 
	select top 1 empno , dbo.sf_emp_nm(empno) as kname,
			  jikgun_type, first_staff, second_staff
	 into	 :ls_empno, :ls_kname, :is_jikgun_type, :is_first_staff, :is_second_staff
	from tb_81101_m 
	where yyyy = :is_yyyy
	and   empno >  :is_empno 
	order by empno; 
else
	select top 1 empno , dbo.sf_emp_nm(empno) as kname,
			  jikgun_type, first_staff, second_staff
	 into	 :ls_empno, :ls_kname, :is_jikgun_type, :is_first_staff, :is_second_staff
	from tb_81101_m 
	where yyyy = :is_yyyy
	and   :gs_user_id   in (first_staff, second_staff)
	and   empno >  :is_empno 
	order by empno; 
end if




dw_head.Setitem(1,"empno", ls_empno)
dw_head.Setitem(1,"kname", ls_kname)

if IsNull(ls_empno) or Trim(ls_empno) = ""  then 
else	
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
	Trigger Event ue_retrieve()
end if
 
end event

type pb_3 from picturebutton within w_81119_d
boolean visible = false
integer x = 2679
integer y = 228
integer width = 169
integer height = 148
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "first_previous.bmp"
alignment htextalign = left!
end type

event clicked;string   ls_empno, ls_kname

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
if  il_ok_empno > 0 then 
		select top 1 empno , dbo.sf_emp_nm(empno) as kname,jikgun_type, first_staff, second_staff
		 into	 :ls_empno, :ls_kname, :is_jikgun_type, :is_first_staff, :is_second_staff
		from tb_81101_m 
		where yyyy = :is_yyyy
		order by empno; 
else								
		select top 1 empno , dbo.sf_emp_nm(empno) as kname,jikgun_type, first_staff, second_staff
		 into	 :ls_empno, :ls_kname, :is_jikgun_type, :is_first_staff, :is_second_staff
		from tb_81101_m 
		where yyyy = :is_yyyy
		and   :gs_user_id   in (first_staff, second_staff)
		order by empno; 
end if

dw_head.Setitem(1,"empno", ls_empno)
dw_head.Setitem(1,"kname", ls_kname)


IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

Trigger Event ue_retrieve()

end event

type pb_4 from picturebutton within w_81119_d
boolean visible = false
integer x = 3200
integer y = 228
integer width = 169
integer height = 148
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "last_next.bmp"
alignment htextalign = left!
end type

event clicked;string   ls_empno, ls_kname


IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	

if  il_ok_empno > 0 then 
		select top 1 empno , dbo.sf_emp_nm(empno) as kname,
			  jikgun_type, first_staff, second_staff
		into	 :ls_empno, :ls_kname, :is_jikgun_type, :is_first_staff, :is_second_staff
		from tb_81101_m  
		where yyyy = :is_yyyy
		order by empno desc; 
else
		select top 1 empno , dbo.sf_emp_nm(empno) as kname,
			  jikgun_type, first_staff, second_staff
		into	 :ls_empno, :ls_kname, :is_jikgun_type, :is_first_staff, :is_second_staff
		from tb_81101_m  
		where yyyy = :is_yyyy
		and   :gs_user_id   in (first_staff, second_staff)
		order by empno desc; 
end if
	


dw_head.Setitem(1,"empno", ls_empno)
dw_head.Setitem(1,"kname", ls_kname)

 

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
Trigger Event ue_retrieve()


end event

