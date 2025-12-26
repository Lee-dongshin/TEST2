$PBExportHeader$w_62016_d.srw
$PBExportComments$매장 LIFE CYCLE
forward
global type w_62016_d from w_com010_d
end type
type dw_m from datawindow within w_62016_d
end type
type dw_d from datawindow within w_62016_d
end type
end forward

global type w_62016_d from w_com010_d
integer height = 2240
dw_m dw_m
dw_d dw_d
end type
global w_62016_d w_62016_d

type variables
string is_brand, is_year, is_season, is_item, is_shop_div, is_shop_grp, is_person_id, is_shop_cd, is_fr_yymmdd, is_to_yymmdd, is_amt_gubn 

end variables

on w_62016_d.create
int iCurrent
call super::create
this.dw_m=create dw_m
this.dw_d=create dw_d
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_m
this.Control[iCurrent+2]=this.dw_d
end on

on w_62016_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_m)
destroy(this.dw_d)
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

is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item   = dw_head.GetItemString(1, "item")

is_shop_div  = dw_head.GetItemString(1, "shop_div")
is_shop_grp  = dw_head.GetItemString(1, "shop_grp")
is_person_id = dw_head.GetItemString(1, "person_id")
is_shop_cd   = dw_head.GetItemString(1, "shop_cd")
is_fr_yymmdd   = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd   = dw_head.GetItemString(1, "to_yymmdd")

is_amt_gubn   = dw_head.GetItemString(1, "amt_gubn")
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

string labels


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_d.reset()
dw_d.insertrow(1)
il_rows = dw_m.retrieve(is_brand, is_year, is_season, is_item, is_shop_div, is_shop_grp, is_person_id, is_fr_yymmdd, is_to_yymmdd, is_amt_gubn, '0',-1)

dw_body.SetRedraw(FALSE)
il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_shop_div, is_shop_grp, is_person_id, is_shop_cd, is_amt_gubn, is_fr_yymmdd, is_to_yymmdd)
IF il_rows > 0 THEN
	labels = string(dw_body.getitemnumber(1,"labels"))
	dw_body.object.gr_1.category.displayeverynlabels= labels
	
	dw_body.object.gr_1.title = "LIFE_CYCLE"
	
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

dw_body.SetRedraw(TRUE)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.08                                                  */	
/* 수정일      : 2002.02.08                                                  */
/*===========================================================================*/
String     ls_emp_nm, ls_dept_cd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "person_id"				
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
		
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data)  = "" THEN
				   dw_head.SetItem(al_row, "emp_nm", "")
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "영업부 사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 

			If gf_get_inter_sub('991', is_brand + '50', '1', ls_dept_cd) = False Then
				dw_head.SetItem(al_row, "emp_no", "")
				dw_head.SetItem(al_row, "emp_nm", "")
				Return 2
			END IF 
			gst_cd.default_where   = " WHERE DEPT_CODE = '" + ls_dept_cd + "' " + &
			                         "   AND GOOUT_GUBN = '1' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "person_id", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "person_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
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
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"		
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE


end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(dw_m, "ScaleToBottom")
inv_resize.of_Register(dw_d, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_m.SetTransObject(SQLCA)
dw_d.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end IF
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62016_d","0")
end event

type cb_close from w_com010_d`cb_close within w_62016_d
end type

type cb_delete from w_com010_d`cb_delete within w_62016_d
end type

type cb_insert from w_com010_d`cb_insert within w_62016_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62016_d
end type

type cb_update from w_com010_d`cb_update within w_62016_d
end type

type cb_print from w_com010_d`cb_print within w_62016_d
end type

type cb_preview from w_com010_d`cb_preview within w_62016_d
end type

type gb_button from w_com010_d`gb_button within w_62016_d
end type

type cb_excel from w_com010_d`cb_excel within w_62016_d
end type

type dw_head from w_com010_d`dw_head within w_62016_d
integer width = 3749
integer height = 208
string dataobject = "d_62016_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild	idw_child

this.getchild("brand",idw_child)
idw_child.SetTransObject(SQLCA) 
idw_child.retrieve('001')

this.getchild("season",idw_child)
idw_child.SetTransObject(SQLCA) 
idw_child.retrieve('003', gs_brand, '%')
idw_child.insertrow(1)
idw_child.setitem(1,"inter_cd","")
idw_child.setitem(1,"inter_nm","전체")

This.GetChild("item", idw_child)
idw_child.SetTRansObject(SQLCA)
idw_child.Retrieve(gs_brand)
idw_child.insertrow(1)
idw_child.Setitem(1, "item", "")
idw_child.Setitem(1, "item_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "person_id"	     //  Popup 검색창이 존재하는 항목 
		this.setitem(1,"person_nm","")
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "amt_gubn"
		is_amt_gubn = data
		
	CASE "brand"
		
//		This.GetChild("sojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%', data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "sojae", "%")
//		ldw_child.Setitem(1, "sojae_nm", "전체")
		
	
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")		
				
		
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

event dw_head::editchanged;call super::editchanged;choose case dwo.name
	case "style"
		if LenA(data) = 1 then this.setitem(1,"brand",upper(data))
		if LenA(data) = 4 then this.setitem(1,"brand",RightA(upper(data),1))
		if LenA(data) = 5 then this.setitem(1,"brand",RightA(upper(data),1))
end choose
end event

type ln_1 from w_com010_d`ln_1 within w_62016_d
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_d`ln_2 within w_62016_d
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_d`dw_body within w_62016_d
integer x = 1975
integer y = 400
integer width = 1637
integer height = 1268
string dataobject = "d_62016_d01"
boolean vscrollbar = false
end type

type dw_print from w_com010_d`dw_print within w_62016_d
integer x = 32
integer y = 776
end type

type dw_m from datawindow within w_62016_d
integer x = 9
integer y = 404
integer width = 1975
integer height = 1612
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_62016_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;long ll_s_rate
string ls_shop_cd, ls_shop_nm


ll_s_rate = dw_m.getitemnumber(row,"s_rate")
if row > 0 and not isnull(ll_s_rate) then	
	il_rows = dw_d.retrieve(is_brand, is_year, is_season, is_item, is_shop_div, is_shop_grp, is_person_id, is_fr_yymmdd, is_to_yymmdd, is_amt_gubn, '1',ll_s_rate)
	
	
	ls_shop_cd = this.getitemstring(row,string(dwo.name))
	il_rows = gf_shop_nm(ls_shop_cd,'s', ls_shop_nm )
	
	this.object.t_shop_nm.text = ls_shop_nm
	dw_d.object.t_shop_nm.text = ""
end if

end event

type dw_d from datawindow within w_62016_d
integer x = 1975
integer y = 1664
integer width = 1627
integer height = 348
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_62016_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_shop_cd, ls_shop_nm


	
ls_shop_cd = dw_d.getitemstring(row,string(dwo.name))
if row > 0 and LenA(ls_shop_cd) <> 0 and not isnull(ls_shop_cd) then	
	dw_body.SetRedraw(FALSE)
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_shop_div, is_shop_grp, is_person_id, ls_shop_cd, is_amt_gubn, is_fr_yymmdd, is_to_yymmdd)
	
	
	il_rows = gf_shop_nm(ls_shop_cd,'s', ls_shop_nm )
	this.object.t_shop_nm.text = ls_shop_nm
	
	
	ls_shop_nm = ls_shop_nm + '(' + ls_shop_cd + ') - LIFE CYCLE'
	dw_body.object.gr_1.title = ls_shop_nm
	
	dw_body.SetRedraw(TRUE)
end if

end event

