$PBExportHeader$w_31029_e.srw
$PBExportComments$일자별 샘플/패턴 진행등록
forward
global type w_31029_e from w_com010_e
end type
type tab_1 from tab within w_31029_e
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_31029_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_31029_e from w_com010_e
integer width = 3680
integer height = 2268
tab_1 tab_1
end type
global w_31029_e w_31029_e

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
DataWindowChild	idw_brand
String 				is_brand, is_yymm
long il_index = 1


end variables

on w_31029_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_31029_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
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

is_brand	= Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) OR is_brand= "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymm	= Trim(dw_head.GetItemString(1, "yymm"))
if IsNull(is_yymm) OR is_yymm = "" then
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
string ls_flag
long i

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if not ib_changed then 
	
			il_rows = tab_1.tabpage_1.dw_1.retrieve(is_brand, is_yymm)
			for i = 0 to il_rows
				ls_flag = tab_1.tabpage_1.dw_1.getitemstring(i,"flag")
				if ls_flag = "New" then tab_1.Tabpage_1.dw_1.SetItemStatus(i, 0, Primary!, New!)
			next 

			/////////////////
			il_rows = tab_1.tabpage_2.dw_2.retrieve(is_brand, is_yymm)
			for i = 0 to il_rows
				ls_flag = tab_1.tabpage_2.dw_2.getitemstring(i,"flag")
				if ls_flag = "New" then tab_1.Tabpage_2.dw_2.SetItemStatus(i, 0, Primary!, New!)
			next 
end if



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

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
			tab_1.enabled = true
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		


	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if


   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
		tab_1.enabled = false	
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event type long ue_update();call super::ue_update;///*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count1, ll_row_count2
datetime ld_datetime

ll_row_count1 = tab_1.Tabpage_1.dw_1.RowCount()
ll_row_count2 = tab_1.Tabpage_2.dw_2.RowCount()
IF tab_1.Tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN -1
IF tab_1.Tabpage_2.dw_2.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count1
   idw_status = tab_1.Tabpage_1.dw_1.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      tab_1.Tabpage_1.dw_1.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      tab_1.Tabpage_1.dw_1.Setitem(i, "mod_id", gs_user_id)
      tab_1.Tabpage_1.dw_1.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

FOR i=1 TO ll_row_count2
   idw_status = tab_1.Tabpage_2.dw_2.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      tab_1.Tabpage_2.dw_2.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      tab_1.Tabpage_2.dw_2.Setitem(i, "mod_id", gs_user_id)
      tab_1.Tabpage_2.dw_2.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT


il_rows = tab_1.Tabpage_1.dw_1.Update(TRUE, FALSE)
if il_rows = 1 then
	il_rows = tab_1.Tabpage_2.dw_2.Update(TRUE, FALSE)
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_preview();

/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/


	Choose Case il_index
		Case 1
			dw_print.dataobject = "d_31029_r01"
			dw_print.SetTransObject(SQLCA)
			dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로
			il_rows = tab_1.Tabpage_1.dw_1.ShareData(dw_print)
		Case 2
			dw_print.dataobject = "d_31029_r02"
			dw_print.SetTransObject(SQLCA)
			dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로
			il_rows = tab_1.Tabpage_2.dw_2.ShareData(dw_print)
	End Choose

This.Trigger Event ue_title ()
dw_print.inv_printpreview.of_SetZoom()

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

dw_print.object.t_brand.text = "브랜드: " + is_brand + " - "+ idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_yymm.text  = "기준년월: " + is_yymm


end event

type cb_close from w_com010_e`cb_close within w_31029_e
end type

type cb_delete from w_com010_e`cb_delete within w_31029_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_31029_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_31029_e
end type

type cb_update from w_com010_e`cb_update within w_31029_e
end type

type cb_print from w_com010_e`cb_print within w_31029_e
end type

type cb_preview from w_com010_e`cb_preview within w_31029_e
end type

type gb_button from w_com010_e`gb_button within w_31029_e
end type

type cb_excel from w_com010_e`cb_excel within w_31029_e
end type

type dw_head from w_com010_e`dw_head within w_31029_e
integer height = 204
string dataobject = "d_31029_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_31029_e
integer beginy = 404
integer endy = 404
end type

type ln_2 from w_com010_e`ln_2 within w_31029_e
integer beginy = 408
integer endy = 408
end type

type dw_body from w_com010_e`dw_body within w_31029_e
integer y = 428
integer height = 1612
end type

type dw_print from w_com010_e`dw_print within w_31029_e
string dataobject = "d_31029_r01"
end type

type tab_1 from tab within w_31029_e
integer y = 420
integer width = 3602
integer height = 1612
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;il_index = newindex


///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 영일)                                      */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
//If oldindex > 0 Then
//	
//	/* dw_head 필수입력 column check */
//	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//	
//
//	Choose Case newindex
//		Case 1
//			il_rows = This.Tabpage_1.dw_1.Retrieve(is_brand, is_yymm)
//		Case 2
//			il_rows = This.Tabpage_2.dw_2.Retrieve(is_brand, is_yymm)
//	End Choose
//
//End If


/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
//pointer oldpointer  // Declares a pointer variable
//
//oldpointer = SetPointer(HourGlass!)
//
//Parent.Trigger Event ue_retrieve()	//조회
//SetPointer(oldpointer)
//
//
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1500
long backcolor = 79741120
string text = "샘플진행등록"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer x = 9
integer y = 8
integer width = 3552
integer height = 1492
integer taborder = 110
string title = "none"
string dataobject = "d_31029_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1500
long backcolor = 79741120
string text = "패턴진행등록"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer x = 9
integer y = 8
integer width = 3552
integer height = 1492
integer taborder = 110
string title = "none"
string dataobject = "d_31029_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

