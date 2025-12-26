$PBExportHeader$w_22008_d.srw
$PBExportComments$원자재 입고/반품현황
forward
global type w_22008_d from w_com010_d
end type
type rb_mat_cd from radiobutton within w_22008_d
end type
type rb_ymd from radiobutton within w_22008_d
end type
type rb_detail from radiobutton within w_22008_d
end type
type cbx_prt from checkbox within w_22008_d
end type
type dw_1 from datawindow within w_22008_d
end type
type rb_cust_sum from radiobutton within w_22008_d
end type
end forward

global type w_22008_d from w_com010_d
integer width = 4114
rb_mat_cd rb_mat_cd
rb_ymd rb_ymd
rb_detail rb_detail
cbx_prt cbx_prt
dw_1 dw_1
rb_cust_sum rb_cust_sum
end type
global w_22008_d w_22008_d

type variables
string is_brand, is_year, is_season, is_item, is_st_ymd, is_ed_ymd, is_cust_cd, is_mat_cd, is_in_gubn, is_sijang_gubn

datawindowchild idw_brand, idw_year, idw_season, idw_item
end variables

on w_22008_d.create
int iCurrent
call super::create
this.rb_mat_cd=create rb_mat_cd
this.rb_ymd=create rb_ymd
this.rb_detail=create rb_detail
this.cbx_prt=create cbx_prt
this.dw_1=create dw_1
this.rb_cust_sum=create rb_cust_sum
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_mat_cd
this.Control[iCurrent+2]=this.rb_ymd
this.Control[iCurrent+3]=this.rb_detail
this.Control[iCurrent+4]=this.cbx_prt
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.rb_cust_sum
end on

on w_22008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_mat_cd)
destroy(this.rb_ymd)
destroy(this.rb_detail)
destroy(this.cbx_prt)
destroy(this.dw_1)
destroy(this.rb_cust_sum)
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
is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item = dw_head.GetItemString(1, "item")
is_st_ymd = dw_head.GetItemString(1, "st_ymd")
is_ed_ymd = dw_head.GetItemString(1, "ed_ymd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_in_gubn = dw_head.GetItemString(1, "in_gubn")
is_sijang_gubn = dw_head.GetItemString(1, "sijang")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
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

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("is_st_ymd",is_st_ymd)
//messagebox("is_ed_ymd",is_ed_ymd)


il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_st_ymd, is_ed_ymd, is_cust_cd, is_mat_cd, is_in_gubn, is_sijang_gubn)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm ,ls_mat_nm, ls_brand
Boolean    lb_check 
DataStore  lds_Source


is_brand = dw_head.getitemstring(1,"brand")
is_year = dw_head.getitemstring(1,"year")
is_season = dw_head.getitemstring(1,"season")
is_item = dw_head.getitemstring(1,"item")
CHOOSE CASE as_column
	CASE "cust_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				END IF
				
				IF LeftA(as_data, 1) = is_brand and gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
		
			if is_brand = 'O' or is_brand = 'Y' then 
				ls_brand = 'O'
			elseif is_brand = 'A' then 
				ls_brand = 'O'				
			else 
				ls_brand = 'N'
			end if
			
			gst_cd.default_where   = " WHERE BRAND = '" + ls_brand + "' AND  CUST_CODE  > '5000' and cust_code < '8999'  "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(CUSTCODE LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("smat_cd")
				ib_itemchanged = False
				lb_check = TRUE
			END IF
			Destroy  lds_Source
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or as_data = "" then
						RETURN 0			
				ELSEIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
						RETURN 0		
				end if
				return 0
			END IF
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 

			
			gst_cd.default_where   = "where brand = '" + is_brand + "' and mat_year like '" + is_year + "%' and mat_season like '" + is_season + "%' and mat_sojae like '" + is_item + "%'"
		
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "year", lds_Source.GetItemString(1,"mat_year"))
				dw_head.SetItem(al_row, "season", lds_Source.GetItemString(1,"mat_season"))
				dw_head.SetItem(al_row, "item", lds_Source.GetItemString(1,"mat_sojae"))

				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_title, ls_in_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_in_gubn  =  dw_head.getitemstring(1,"in_gubn")  
if ls_in_gubn = "%" then
	ls_in_gubn = "발주구분 : 전체"
elseif ls_in_gubn = "01" then
	ls_in_gubn = "발주구분 : 정상발주"
else
	ls_in_gubn = "발주구분 : 이체발주"
end if


ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "mat_sojae_display") + "'"   + &
				 "t_st_ymd.Text = '" + String(is_st_ymd, '@@@@/@@/@@') + "'" + &
				 "t_in_gubn.Text = '" + ls_in_gubn + "'" + &
				 "t_ed_ymd.Text = '" + String(is_ed_ymd, '@@@@/@@/@@') + "'" 
dw_print.Modify(ls_modify)



end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"st_ymd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"ed_ymd",string(ld_datetime,"yyyymmdd"))
end IF

inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22008_d","0")
end event

event ue_preview();
This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로
il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_item, is_st_ymd, is_ed_ymd, is_cust_cd, is_mat_cd, is_in_gubn, is_sijang_gubn)
dw_print.inv_printpreview.of_SetZoom()


end event

type cb_close from w_com010_d`cb_close within w_22008_d
end type

type cb_delete from w_com010_d`cb_delete within w_22008_d
end type

type cb_insert from w_com010_d`cb_insert within w_22008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22008_d
end type

type cb_update from w_com010_d`cb_update within w_22008_d
end type

type cb_print from w_com010_d`cb_print within w_22008_d
end type

type cb_preview from w_com010_d`cb_preview within w_22008_d
end type

type gb_button from w_com010_d`gb_button within w_22008_d
end type

type cb_excel from w_com010_d`cb_excel within w_22008_d
end type

type dw_head from w_com010_d`dw_head within w_22008_d
integer width = 3959
integer height = 260
string dataobject = "d_22008_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

this.getchild("year",idw_year)
idw_year.settransobject(sqlca)
idw_year.retrieve('002')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

this.getchild("item",idw_item)
idw_item.settransobject(sqlca)
idw_item.retrieve('1', is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1,"mat_sojae", '%')
idw_item.SetItem(1,"mat_sojae_nm",'전체')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : itemchanged(dw_head)                                        */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "cust_cd","mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
		
	CASE "brand", "year"		
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
		//idw_season.retrieve('003')
		idw_season.insertrow(1)
		idw_season.Setitem(1, "inter_cd", "%")
		idw_season.Setitem(1, "inter_nm", "전체")
		
		this.getchild("item",idw_item)
		idw_item.settransobject(sqlca)
		idw_item.retrieve('1', is_brand)
		idw_item.InsertRow(1)
		idw_item.SetItem(1,"mat_sojae", '%')
		idw_item.SetItem(1,"mat_sojae_nm",'전체')

END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_22008_d
end type

type ln_2 from w_com010_d`ln_2 within w_22008_d
end type

type dw_body from w_com010_d`dw_body within w_22008_d
string dataobject = "d_22008_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_mat_cd ,ls_search

///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/

if row > 0 then 
	choose case dwo.name
		case 'mat_cd'
			ls_mat_cd = dw_body.getitemstring(row,"mat_cd")
			if not isnull(ls_mat_cd)  then
				dw_1.retrieve(ls_mat_cd)
				dw_1.title = '자재코드 : ' + ls_mat_cd
				dw_1.visible = true			
			end if		
	end choose	
end if



end event

type dw_print from w_com010_d`dw_print within w_22008_d
string dataobject = "d_22008_r01"
end type

event dw_print::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')
end event

type rb_mat_cd from radiobutton within w_22008_d
integer x = 2843
integer y = 188
integer width = 398
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "자재코드별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_child

This.textcolor = Rgb(0, 0, 255) 
rb_ymd.textcolor = Rgb(0, 0, 0)
rb_detail.textcolor = Rgb(0, 0, 0)
rb_cust_sum.textcolor = Rgb(0, 0, 0) 


dw_body.dataobject = "d_22008_d01"
dw_body.SetTransObject(SQLCA)

dw_body.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_body.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

if cbx_prt.enabled then 
	dw_print.dataobject = "d_22008_s01"
else
	dw_print.dataobject = "d_22008_r01"	
end if
dw_print.SetTransObject(SQLCA)

dw_print.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_print.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')


end event

type rb_ymd from radiobutton within w_22008_d
integer x = 2843
integer y = 244
integer width = 398
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "기간별"
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_child

This.textcolor = Rgb(0, 0, 255) 
rb_mat_cd.textcolor = Rgb(0, 0, 0)
rb_detail.textcolor = Rgb(0, 0, 0)
rb_cust_sum.textcolor = Rgb(0, 0, 0) 

dw_body.dataobject = "d_22008_d02"
dw_body.SetTransObject(SQLCA)

dw_body.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_body.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

if cbx_prt.enabled then 
	dw_print.dataobject = "d_22008_s02"
else
	dw_print.dataobject = "d_22008_r02"	
end if

dw_print.SetTransObject(SQLCA)

dw_print.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_print.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')
end event

type rb_detail from radiobutton within w_22008_d
integer x = 2843
integer y = 300
integer width = 398
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "입고상세"
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_child

rb_mat_cd.textcolor = Rgb(0, 0, 0)
rb_mat_cd.textcolor = Rgb(0, 0, 0)
this.textcolor = Rgb(0, 0, 255)
rb_cust_sum.textcolor = Rgb(0, 0, 0) 

dw_body.dataobject = "d_22008_d03"
dw_body.SetTransObject(SQLCA)

dw_body.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()


if cbx_prt.enabled then 
	dw_print.dataobject = "d_22008_s03"
else
	dw_print.dataobject = "d_22008_r03"	
end if
dw_print.SetTransObject(SQLCA)

dw_print.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()


end event

type cbx_prt from checkbox within w_22008_d
integer x = 3333
integer y = 192
integer width = 357
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "업체별출력"
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_child


if cbx_prt.checked then 
	if rb_mat_cd.checked then dw_print.dataobject = 'd_22008_s01'
	if rb_ymd.checked    then dw_print.dataobject = 'd_22008_s02'	
	if rb_detail.checked then dw_print.dataobject = 'd_22008_s03'
	
else
	if rb_mat_cd.checked then dw_print.dataobject = 'd_22008_r01'
	if rb_ymd.checked    then dw_print.dataobject = 'd_22008_r02'	
	if rb_detail.checked then dw_print.dataobject = 'd_22008_r03'	
end if

dw_print.SetTransObject(SQLCA)



dw_print.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_print.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')
end event

type dw_1 from datawindow within w_22008_d
boolean visible = false
integer x = 105
integer y = 700
integer width = 3296
integer height = 1160
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "전개 스타일 정보"
string dataobject = "d_22008_d04"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			
	end choose	
end if

end event

type rb_cust_sum from radiobutton within w_22008_d
integer x = 2843
integer y = 352
integer width = 398
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "업체별합계"
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_child

rb_mat_cd.textcolor = Rgb(0, 0, 0)
rb_ymd.textcolor = Rgb(0, 0, 0)
rb_detail.textcolor = Rgb(0, 0, 0)
This.textcolor = Rgb(0, 0, 255) 

dw_body.dataobject = "d_22008_d05"
dw_body.SetTransObject(SQLCA)

dw_print.dataobject = "d_22008_r05"	
dw_print.SetTransObject(SQLCA)

end event

