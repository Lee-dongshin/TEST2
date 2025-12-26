$PBExportHeader$w_56124_d.srw
$PBExportComments$직영몰 매장 직배송건 수수료 내역
forward
global type w_56124_d from w_com010_d
end type
type dw_1 from u_dw within w_56124_d
end type
type dw_2 from datawindow within w_56124_d
end type
end forward

global type w_56124_d from w_com010_d
integer width = 3680
integer height = 2220
dw_1 dw_1
dw_2 dw_2
end type
global w_56124_d w_56124_d

type variables
DataWindowChild idw_brand, idw_shop_div, ldw_comm_fg
String  is_brand, is_shop_cd, is_yymm, is_shop_div, is_comm_fg

end variables

forward prototypes
public function integer wf_shop_chk (string as_shop_cd, string as_flag, ref string as_shop_nm, ref string as_shop_div)
end prototypes

public function integer wf_shop_chk (string as_shop_cd, string as_flag, ref string as_shop_nm, ref string as_shop_div);String ls_shop_nm, ls_shop_snm

SELECT SHOP_NM, SHOP_SNM, SHOP_DIV
  INTO :ls_shop_nm, :ls_shop_snm, :as_shop_div
  FROM TB_91100_M
 WHERE SHOP_CD = :as_shop_cd
;

IF ISNULL(as_shop_nm) THEN RETURN 100

If as_flag = 'S' Then
	as_shop_nm = ls_shop_snm
Else
	as_shop_nm = ls_shop_nm
End If

RETURN sqlca.sqlcode 

end function

on w_56124_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
end on

on w_56124_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김근호                                                     */	
/* 작성일      : 2018.04.06                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

String     ls_shop_nm, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
		
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) = is_brand and wf_shop_chk(as_data, 'S', ls_shop_nm, ls_shop_div) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				dw_head.SetItem(al_row, "shop_div", ls_shop_div)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd",  lds_Source.GetItemString(1,"shop_cd") )
			dw_head.SetItem(al_row, "shop_nm",  lds_Source.GetItemString(1,"shop_snm"))
			dw_head.SetItem(al_row, "shop_div", lds_Source.GetItemString(1,"shop_div"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("comm_fg")
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event open;call super::open;dw_head.Setitem(1, "shop_div", "G")
dw_head.Setitem(1, "comm_fg", "%")

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.reset()

il_rows = dw_1.retrieve(is_yymm, is_brand, is_shop_div, is_shop_cd, is_comm_fg)


IF il_rows > 0 THEN
   dw_1.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_yymm = dw_head.GetItemString(1, "yymm")

if is_yymm = ''  or isnull(is_yymm) then
	messagebox('확인','년월을 입력해주세요.')
	return false
elseif LenA(Trim(is_yymm)) <> 6 then
	messagebox('확인','년월을 확인해주세요.')
	return false
end if


is_brand = dw_head.GetItemString(1, "brand")

if is_brand = ''  or isnull(is_brand) then
	messagebox('확인','브랜드를 선택해주세요.')
	return false
end if


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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



is_shop_div = dw_head.GetItemString(1, "shop_div")

if is_shop_div = ''  or isnull(is_shop_div) then
	messagebox('확인','유통망을 선택해주세요.')
	return false
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")

if is_shop_cd = ''  or isnull(is_shop_cd) then
	is_shop_cd = '%'
end if


is_comm_fg = dw_head.GetItemString(1, "comm_fg")






end event

event resize;call super::resize;
//newwidth = this.WorkSpaceWidth() 
//newheight = this.WorkSpaceHeight()
//
//dw_body.resize(newwidth, newheight - 468)
//dw_1.resize(newwidth, newheight - 1372)
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : 김근호                                                */	
/* 작성일      : 2018.04.09                                                  */	
/* 수정일      :                                                             */
/*===========================================================================*/



//This.Trigger Event ue_title ()


//dw_print.SetRedraw(False)


dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로


This.Trigger Event ue_title()

il_rows = dw_print.retrieve(is_yymm, is_brand, is_shop_div, is_shop_cd, is_comm_fg)




//dw_print.SetRedraw(True)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();/*===========================================================================*/
/* 작성자      : 김근호                                                      */	
/* 작성일      : 2018.04.09                                                  */	
/* 수정일      :                                                             */
/*===========================================================================*/

String ls_modify, ls_shop_nm, brand_nm

ls_shop_nm = dw_head.GetItemString(1,"shop_nm")

if trim(ls_shop_nm) = '' or isnull(ls_shop_nm) then
	ls_shop_nm = '전 체'
end if


//브랜드명 가져오기
select inter_nm
  into :brand_nm
  from tb_91011_c(nolock)
 where inter_grp = '001'
   and inter_cd = :is_brand 
	using sqlca;
	
	

ls_modify =	"t_yymm.Text    = '" + String(is_yymm, '@@@@/@@') + "'" + &
            "t_brand.Text  = '" + brand_nm    + "'" + &
            "t_shop_nm.Text = '" + ls_shop_nm   + "'"


dw_print.Modify(ls_modify)
end event

event ue_print();

dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로


This.Trigger Event ue_title()

dw_print.retrieve(is_yymm, is_brand, is_shop_div, is_shop_cd, is_comm_fg)


IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)
end event

event ue_excel();string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer


dw_2.SetTransObject(sqlca)

dw_2.retrieve(is_yymm, is_brand, is_shop_div, is_shop_cd, is_comm_fg)


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
//li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)

   li_ret = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
	if li_ret = 1 then
		li_ret = dw_2.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
	else 	
		li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
	end if	

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)



end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_56124_d
end type

type cb_delete from w_com010_d`cb_delete within w_56124_d
end type

type cb_insert from w_com010_d`cb_insert within w_56124_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56124_d
end type

type cb_update from w_com010_d`cb_update within w_56124_d
end type

type cb_print from w_com010_d`cb_print within w_56124_d
end type

type cb_preview from w_com010_d`cb_preview within w_56124_d
end type

type gb_button from w_com010_d`gb_button within w_56124_d
end type

type cb_excel from w_com010_d`cb_excel within w_56124_d
end type

type dw_head from w_com010_d`dw_head within w_56124_d
integer width = 3525
integer height = 248
string dataobject = "d_56124_h01"
end type

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

This.GetChild("comm_fg", ldw_comm_fg) 
ldw_comm_fg.SetTransObject(SQLCA)
ldw_comm_fg.Retrieve('919')
ldw_comm_fg.insertRow(1)
ldw_comm_fg.Setitem(1, "inter_cd", "%")
ldw_comm_fg.Setitem(1, "inter_nm", "전체")
end event

type ln_1 from w_com010_d`ln_1 within w_56124_d
end type

type ln_2 from w_com010_d`ln_2 within w_56124_d
end type

type dw_body from w_com010_d`dw_body within w_56124_d
integer x = 9
integer y = 1096
integer height = 884
string dataobject = "d_56124_d02"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_56124_d
integer x = 2213
integer y = 748
string dataobject = "d_56124_r01"
end type

type dw_1 from u_dw within w_56124_d
integer x = 14
integer y = 468
integer width = 3589
integer height = 620
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_56124_d01"
boolean hscrollbar = true
end type

event clicked;call super::clicked;String  ls_brand, ls_shop_cd, ls_yymm, ls_shop_div, ls_comm_fg, ls_sale_emp

setrow(row)


dw_body.SetTransObject(sqlca)


dw_body.reset()

dw_body.SetRedraw(False)


ls_yymm = dw_head.GetItemString(1, "yymm")
ls_brand = dw_head.GetItemString(1, "brand")
ls_shop_div = dw_1.getitemstring(getrow(),"shop_div")
ls_shop_cd = dw_1.getitemstring(getrow(),"shop_cd")
ls_comm_fg = dw_1.getitemstring(getrow(),"comm_fg")
ls_sale_emp = dw_1.getitemstring(getrow(),"sale_emp")


//messagebox('1',ls_shop_cd)
//messagebox('2',ls_comm_fg)
//messagebox('3',ls_shop_div)

il_rows = dw_body.retrieve(ls_yymm, ls_brand, ls_shop_div, ls_shop_cd, ls_comm_fg, ls_sale_emp)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

dw_body.SetRedraw(True)

end event

type dw_2 from datawindow within w_56124_d
boolean visible = false
integer x = 2039
integer y = 952
integer width = 891
integer height = 592
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_56124_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

