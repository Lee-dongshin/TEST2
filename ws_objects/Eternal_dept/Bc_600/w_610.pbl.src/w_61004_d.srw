$PBExportHeader$w_61004_d.srw
$PBExportComments$경영계획진행현황
forward
global type w_61004_d from w_com010_d
end type
type dw_2 from datawindow within w_61004_d
end type
type dw_1 from datawindow within w_61004_d
end type
end forward

global type w_61004_d from w_com010_d
integer width = 3680
integer height = 2272
dw_2 dw_2
dw_1 dw_1
end type
global w_61004_d w_61004_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_sale_div
string is_brand, is_yyyy, is_year, is_season, is_yymm, is_sale_div


end variables

on w_61004_d.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_1
end on

on w_61004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_1)
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"기준년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
  is_year = "%"
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
  is_season = "%"
end if

is_sale_div = dw_head.GetItemString(1, "sale_div")
if IsNull(is_sale_div) or Trim(is_sale_div) = "" then
  is_sale_div = "%"
end if

return true

end event

event open;call super::open;dw_head.Setitem(1, "year", "" )
dw_head.Setitem(1, "season", "" )

dw_head.SetColumn("year")
dw_head.SetColumn("season")

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yyyy, is_year, is_season, is_sale_div)
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

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

//inv_resize.of_Register(dw_1, "FixedToBottom&ScaleToRight")

end event

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_year, ls_season, ls_sale_div

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_year = '%' Then
	ls_year = '전체'
Else
	ls_year = idw_year.GetItemString(idw_year.GetRow(), "inter_display")
End If

If is_season = '%' Then
	ls_season = '전체'
Else
	ls_season = idw_season.GetItemString(idw_season.GetRow(), "inter_display")
End If

If is_sale_div = '%' Then
	ls_sale_div = '전체'
Else
	ls_sale_div = '행사제외'
End If

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yyyy.Text = '" + is_yyyy + "'" + &
            "t_year.Text = '" + ls_year + "'" + &
            "t_season.Text = '" + ls_season + "'" + &
				"t_sale_div.Text = '" + ls_sale_div + "'"

dw_print.Modify(ls_modify)

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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
CHOOSE CASE as_column
	CASE "graph"
			dw_2.Visible = True
			/* dw_head 필수입력 column check */
			IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0
			dw_2.retrieve(is_brand, is_yyyy, is_year, is_season, is_sale_div)
	CASE "close"
			dw_2.Visible = False
	CASE "bar"
			dw_2.Object.gr_1.GraphType = 9
	CASE "line"
			dw_2.Object.gr_1.GraphType = 12
END CHOOSE

RETURN 0

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61004_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61004_d
end type

type cb_delete from w_com010_d`cb_delete within w_61004_d
end type

type cb_insert from w_com010_d`cb_insert within w_61004_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61004_d
end type

type cb_update from w_com010_d`cb_update within w_61004_d
end type

type cb_print from w_com010_d`cb_print within w_61004_d
end type

type cb_preview from w_com010_d`cb_preview within w_61004_d
end type

type gb_button from w_com010_d`gb_button within w_61004_d
end type

type cb_excel from w_com010_d`cb_excel within w_61004_d
end type

type dw_head from w_com010_d`dw_head within w_61004_d
integer y = 192
integer height = 228
string dataobject = "d_61004_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

//This.GetChild("sale_div", idw_sale_div )
//idw_sale_div.SetTransObject(SQLCA)
//idw_sale_div.Retrieve('009')
//
//idw_sale_div.InsertRow(1)
//idw_sale_div.SetItem(1,'inter_cd','0')
//idw_sale_div.SetItem(1,'inter_nm','정상+세일+기획')
//
//
//idw_sale_div.InsertRow(1)
//idw_sale_div.SetItem(1,'inter_cd','')
//idw_sale_div.SetItem(1,'inter_nm','전체')
//
//
end event

event dw_head::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                   */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		 
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_61004_d
end type

type ln_2 from w_com010_d`ln_2 within w_61004_d
end type

type dw_body from w_com010_d`dw_body within w_61004_d
integer x = 9
string dataobject = "d_61004_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_yymm, ls_slip_bonji

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//t_size1
is_yymm    = this.GetitemString(row, "yymm")


select inter_cd1 
into   :ls_slip_bonji
from   tb_91011_c with (nolock)
where  inter_grp = '001'
and    inter_cd = :is_brand;


CHOOSE CASE dwo.name
	CASE "panme_silkuk"      // dddw로 작성된 항목
   	dw_1.dataobject = "d_61004_d02"
   	dw_1.SetTransObject(SQLCA)
      il_rows = dw_1.retrieve(is_brand, is_yyyy,  is_year, is_season,is_yymm)
		IF il_rows > 0 THEN
			dw_1.visible = true
		   dw_1.SetFocus()
		END IF
		
	CASE "wonga_siljuk"	     //  Popup 검색창이 존재하는 항목 
	  	dw_1.dataobject = "d_61004_d06"
   	dw_1.SetTransObject(SQLCA)
      il_rows = dw_1.retrieve(is_brand, is_year, is_season,is_yymm)
		IF il_rows > 0 THEN
			dw_1.visible = true
		   dw_1.SetFocus()
		END IF
		
   CASE "acc_siljuk"      // dddw로 작성된 항목	
   	dw_1.dataobject = "d_61004_d03"
   	dw_1.SetTransObject(SQLCA)
      il_rows = dw_1.retrieve(ls_slip_bonji, is_yymm, is_yymm)
		IF il_rows > 0 THEN
			dw_1.visible = true
		   dw_1.SetFocus()
		END IF
		
		
END CHOOSE







end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_61004_d
integer x = 1531
integer y = 1144
string dataobject = "d_61004_r01"
end type

type dw_2 from datawindow within w_61004_d
boolean visible = false
integer x = 233
integer y = 912
integer width = 3323
integer height = 1752
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "그래프보기"
string dataobject = "d_61004_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                   */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

type dw_1 from datawindow within w_61004_d
boolean visible = false
integer y = 336
integer width = 3589
integer height = 1572
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "상세자료"
string dataobject = "d_61004_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;CHOOSE CASE dwo.name
	CASE "cb_close"      // dddw로 작성된 항목
   	dw_1.visible = false
		
	CASE "cb_excel"      // dddw로 작성된 항목
 
		string ls_doc_nm, ls_nm
		
		integer li_ret
		boolean lb_exist
		Pointer Old_pointer
		
		IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
			RETURN
		END IF	
		lb_exist = FileExists(ls_doc_nm)
		IF lb_exist THEN 
			SetPointer(Old_pointer)
			li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
			if li_ret = 2 then return
		end if
		
		Old_pointer = SetPointer(HourGlass!)
		li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
		if li_ret <> 1 then
			SetPointer(Old_pointer)
			MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
			return
		end if
		SetPointer(Old_pointer)
		Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

END CHOOSE
end event

event doubleclicked;string ls_yymm, ls_slip_bonji, ls_inq_type, ls_gubun, ls_seq

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//t_size1



if is_brand = "N"  then
   ls_slip_bonji = "01"
elseif is_brand = "O" then 	
	ls_slip_bonji = "02"
elseif is_brand = "W" then
	ls_slip_bonji = "11"
elseif is_brand = "T" then
	ls_slip_bonji = "21"
elseif is_brand = "B" then
	ls_slip_bonji = "41"	
elseif is_brand = "I" then
	ls_slip_bonji = "A1"	
end if	

ls_gubun = this.Getitemstring(row, "gubun")
ls_seq = this.Getitemstring(row, "seq")

//
//
//create  procedure sp_61004_d04
//			   @inq_type      char(01),    /* 조회구분 */                          
//                           @slip_bonji    char(02),    /* 사 업 장 */
//                           @yymm          varchar(06), /* 년    월 */
//                           @gubun         char(01),    /* 구    분 */                   	   
//                           @seq           char(05)     /* 순    번 */
//

CHOOSE CASE dwo.name
	CASE "siljuk"      // dddw로 작성된 항목
		ls_inq_type = 'A'
   CASE "tot_siljuk"      // dddw로 작성된 항목	
		ls_inq_type = 'B'
END CHOOSE
	
      dw_1.dataobject = "d_61004_d04"
   	dw_1.SetTransObject(SQLCA)
      il_rows = dw_1.retrieve(ls_inq_type, ls_slip_bonji, is_yymm, ls_gubun, ls_seq)


IF il_rows > 0 THEN
	dw_1.visible = true
   dw_1.SetFocus()
END IF




end event

