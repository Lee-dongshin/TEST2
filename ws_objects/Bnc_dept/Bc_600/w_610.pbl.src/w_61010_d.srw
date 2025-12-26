$PBExportHeader$w_61010_d.srw
$PBExportComments$미사용-사원조회
forward
global type w_61010_d from w_com010_d
end type
type tv_1 from treeview within w_61010_d
end type
type cb_1 from commandbutton within w_61010_d
end type
type cb_2 from commandbutton within w_61010_d
end type
end forward

global type w_61010_d from w_com010_d
integer width = 3680
integer height = 2272
tv_1 tv_1
cb_1 cb_1
cb_2 cb_2
end type
global w_61010_d w_61010_d

type variables
DataStore	 ids_Source

end variables

on w_61010_d.create
int iCurrent
call super::create
this.tv_1=create tv_1
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
end on

on w_61010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tv_1)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보 (김 영일)	   												  */	
/* 작성일      : 2002.03.21																  */	
/*===========================================================================*/
long 		ll_lev1, ll_lev2 ,ll_lev3 ,ll_lev4, li_rows
int  		index,li
String	ls_dept_nm,ls_dept_cd,ls_name,ls_empno,tmp_dept_cd=""
TreeViewItem		ltvi_New

inv_resize.of_Register(tv_1, "ScaleToBottom")

ids_Source 					= Create DataStore
ids_Source.DataObject 	= "d_61010_d01"
ids_Source.SetTransObject(SQLCA)

li_rows = ids_Source.retrieve() 

FOR li=1 TO li_rows
	
	ls_dept_nm	= ids_Source.Object.dept_nm[li]
	ls_dept_cd	= ids_Source.Object.dept_cd[li]
	ls_name		= ids_Source.Object.name[li]
	ls_empno		= ids_Source.Object.empno[li]
	
	IF tmp_dept_cd <> ls_dept_cd THEN
		ll_lev1 = tv_1.InsertItemFirst(0,ls_dept_nm,1)
		tmp_dept_cd = ls_dept_cd
		ll_lev2 = tv_1.InsertItemLast(ll_lev1, ls_name,2)
	ELSE
		ll_lev2 = tv_1.InsertItemLast(ll_lev1, ls_name,2)
	END IF
	
NEXT

tv_1.ExpandItem(ll_lev2)

DESTROY ids_Source
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
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61010_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61010_d
end type

type cb_delete from w_com010_d`cb_delete within w_61010_d
end type

type cb_insert from w_com010_d`cb_insert within w_61010_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61010_d
end type

type cb_update from w_com010_d`cb_update within w_61010_d
end type

type cb_print from w_com010_d`cb_print within w_61010_d
end type

type cb_preview from w_com010_d`cb_preview within w_61010_d
end type

type gb_button from w_com010_d`gb_button within w_61010_d
end type

type cb_excel from w_com010_d`cb_excel within w_61010_d
end type

type dw_head from w_com010_d`dw_head within w_61010_d
integer height = 160
string dataobject = "d_61010_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_61010_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_d`ln_2 within w_61010_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_d`dw_body within w_61010_d
integer x = 750
integer y = 384
integer width = 2843
integer height = 1648
string dataobject = "d_test"
end type

type dw_print from w_com010_d`dw_print within w_61010_d
end type

type tv_1 from treeview within w_61010_d
integer x = 9
integer y = 384
integer width = 727
integer height = 1648
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean disabledragdrop = false
boolean hideselection = false
string picturename[] = {"Custom050!","Picture!"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event selectionchanged;///*===========================================================================*/
///* 작성자      : 지우정보 (김 영일)    												  */	
///* 작성일      : 2002.03.21																  */	
///* 수정일      : 2002.03.21																  */	
///*===========================================================================*/
//treeviewitem l_tvinew
//tv_1.GetItem(newhandle, l_tvinew)
//
//MessageBox("",String(l_tvinew.Label))
end event

type cb_1 from commandbutton within w_61010_d
integer x = 1563
integer y = 228
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "테스트"
end type

event clicked;int li_result
OLEObject  myoleobject
myoleobject = CREATE OLEObject

li_result = myoleobject.ConnectToNewObject( "Excel.Application")
// add a chart to the workbook
myoleobject.charts.add()
// attempt to modify the chart, adding titles
myoleobject.activechart.ChartWizard("","","","","","","","Title1", &
 "Category1","ValueTitle1","")

myoleobject.Application.quit
myoleobject.DisConnectObject()
DESTROY myoleobject

end event

type cb_2 from commandbutton within w_61010_d
integer x = 2034
integer y = 228
integer width = 402
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회"
end type

event clicked;dw_body.SetTransObject(SQLCA)
dw_body.Retrieve()

end event

