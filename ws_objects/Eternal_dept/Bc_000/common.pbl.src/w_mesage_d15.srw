$PBExportHeader$w_mesage_d15.srw
$PBExportComments$당일 작지 등록내역
forward
global type w_mesage_d15 from w_com010_d
end type
type dw_rpt from u_dw within w_mesage_d15
end type
end forward

global type w_mesage_d15 from w_com010_d
boolean visible = false
integer width = 3278
integer height = 1464
string title = "품번별 원자재 출고확인※ F5 : 새로고침"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
event type long ue_refresh ( string as_brand,  string as_person_id )
event ue_first_open ( )
dw_rpt dw_rpt
end type
global w_mesage_d15 w_mesage_d15

type variables
long il_body_row
end variables

event type long ue_refresh(string as_brand, string as_person_id);long ll_rows

ll_rows = dw_body.retrieve(as_person_id)

if ll_rows > 0 then
	this.visible = true
else
	this.visible = false
end if

return ll_rows

end event

event pfc_preopen();call super::pfc_preopen;this.x = 2055
this.y = 500

trigger event ue_refresh(gs_brand, gs_user_id)
dw_rpt.SetTransObject(SQLCA)


end event

on w_mesage_d15.create
int iCurrent
call super::create
this.dw_rpt=create dw_rpt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rpt
end on

on w_mesage_d15.destroy
call super::destroy
destroy(this.dw_rpt)
end on

event timer;call super::timer;//il_rows = dw_body.retrieve(gs_brand, gs_user_id)
//
//if il_rows > 0 then
//	this.visible = true
//else
//	this.visible = false
//end if
//
end event

type cb_close from w_com010_d`cb_close within w_mesage_d15
boolean visible = false
end type

type cb_delete from w_com010_d`cb_delete within w_mesage_d15
integer x = 3337
integer y = 484
end type

type cb_insert from w_com010_d`cb_insert within w_mesage_d15
integer x = 3072
integer y = 484
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_mesage_d15
boolean visible = false
integer x = 3483
end type

type cb_update from w_com010_d`cb_update within w_mesage_d15
integer x = 3113
integer y = 480
end type

type cb_print from w_com010_d`cb_print within w_mesage_d15
boolean visible = false
integer x = 3072
integer y = 484
end type

type cb_preview from w_com010_d`cb_preview within w_mesage_d15
boolean visible = false
integer x = 3415
integer y = 484
end type

type gb_button from w_com010_d`gb_button within w_mesage_d15
boolean visible = false
integer x = 3611
integer y = 264
integer width = 713
end type

type cb_excel from w_com010_d`cb_excel within w_mesage_d15
boolean visible = false
integer x = 3758
integer y = 484
end type

type dw_head from w_com010_d`dw_head within w_mesage_d15
boolean visible = false
integer x = 2981
integer y = 196
integer width = 2811
end type

type ln_1 from w_com010_d`ln_1 within w_mesage_d15
boolean visible = false
integer beginx = 2912
integer beginy = 916
integer endx = 6533
integer endy = 916
end type

type ln_2 from w_com010_d`ln_2 within w_mesage_d15
boolean visible = false
integer beginx = 2907
integer beginy = 920
integer endx = 6528
integer endy = 920
end type

type dw_body from w_com010_d`dw_body within w_mesage_d15
event type long ue_insert ( )
event ue_update ( string as_ignore_yn )
event ue_kedown pbm_dwnkey
integer x = 9
integer y = 0
integer width = 3246
integer height = 1348
string title = "F5 : 새로고침"
string dataobject = "d_message_015"
boolean minbox = true
boolean hscrollbar = true
boolean ib_rmbmenu = false
end type

event dw_body::ue_kedown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyF5!	// refresh
		parent.trigger event ue_refresh(gs_brand, gs_user_id)
		
	CASE KeyF9!	// print
		parent.trigger event ue_preview()

	CASE KeyF12!	// print
		parent.trigger event ue_print()
		
END CHOOSE

end event

event dw_body::clicked;integer li_rc
boolean lb_disablelinkage


// Check arguments
if IsNull(xpos) or IsNull(ypos) or IsNull(row) or IsNull(dwo) then return

// Is Querymode enabled?
if IsValid(inv_QueryMode) then lb_disablelinkage = inv_QueryMode.of_GetEnabled()

if not lb_disablelinkage then
	if IsValid (inv_Linkage) then
		if inv_Linkage.Event pfc_clicked ( xpos, ypos, row, dwo ) = &
			inv_Linkage.PREVENT_ACTION then
			// The user or a service action prevents from going to the clicked row.
			return 1
		end if
	end if
end if
	
if IsValid (inv_RowSelect) then inv_RowSelect.Event pfc_clicked ( xpos, ypos, row, dwo )

if IsValid (inv_Sort) then inv_Sort.Event pfc_clicked ( xpos, ypos, row, dwo ) 

end event

event dw_body::itemchanged;call super::itemchanged;string ls_insert, ls_delete, ls_style, ls_chno, ls_mat_cd, ls_mat_color
integer Net
ls_insert = "제외처리 하시겠습니까?"
ls_delete = "제외취소 하시겠습니까?"

choose case dwo.name
	case 'ignore_yn'
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_mat_cd = This.GetitemString(row, "mat_cd")
		ls_mat_color  = MidA(This.GetitemString(row, "color_nm"),1,2)


		Net = MessageBox("확인", "제외처리 하시겠습니까?" , Exclamation!, OKCancel!, 2)
		
		IF Net = 1 THEN
			update tb_12025_d set ignore_yn = 'Y'
			where style  = :ls_style
			  and chno   = :ls_chno
			  and mat_cd = :ls_mat_cd
			  and mat_color = :ls_mat_color
	
			commit  USING SQLCA;
		end if			
				
			trigger event ue_refresh(gs_brand, gs_user_id)



end choose

end event

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_style, ls_level, ls_gubn, ls_chno

if row > 0 then
	ls_style = this.getitemstring(row,"style")
	ls_chno = this.getitemstring(row,"chno")
	ls_gubn  = this.getitemstring(row,"gubn")
	
	gsv_cd.gs_cd10 = ls_style + ls_chno

	open(w_31001_e)	//원가 계산서(타스타스용)
end if

end event

type dw_print from w_com010_d`dw_print within w_mesage_d15
integer x = 2958
integer y = 596
end type

type dw_rpt from u_dw within w_mesage_d15
boolean visible = false
integer x = 2926
integer y = 656
integer width = 1038
integer height = 380
integer taborder = 60
boolean bringtotop = true
boolean hscrollbar = true
end type

event constructor;call super::constructor;This.of_SetPrintPreview(TRUE)
end event

