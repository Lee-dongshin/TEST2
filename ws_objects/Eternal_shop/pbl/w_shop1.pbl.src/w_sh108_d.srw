$PBExportHeader$w_sh108_d.srw
$PBExportComments$판매 현황 조회
forward
global type w_sh108_d from w_com010_d
end type
type rb_1 from radiobutton within w_sh108_d
end type
type rb_2 from radiobutton within w_sh108_d
end type
type rb_3 from radiobutton within w_sh108_d
end type
type rb_4 from radiobutton within w_sh108_d
end type
type cb_excel from commandbutton within w_sh108_d
end type
type rb_5 from radiobutton within w_sh108_d
end type
type gb_1 from groupbox within w_sh108_d
end type
end forward

global type w_sh108_d from w_com010_d
long backcolor = 16777215
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
cb_excel cb_excel
rb_5 rb_5
gb_1 gb_1
end type
global w_sh108_d w_sh108_d

type variables
String is_fr_ymd, is_to_ymd, is_style_no, is_sale_grp, is_year, is_season, is_brand, is_dotcom
datawindowchild  idw_year, idw_season, idw_sale_grp, idw_brand

end variables

on w_sh108_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.cb_excel=create cb_excel
this.rb_5=create rb_5
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.cb_excel
this.Control[iCurrent+6]=this.rb_5
this.Control[iCurrent+7]=this.gb_1
end on

on w_sh108_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.cb_excel)
destroy(this.rb_5)
destroy(this.gb_1)
end on

event open;call super::open;string ls_modify

dw_head.Setitem(1, "sale_grp", "%")


dw_head.setitem(1, "brand", upper(MidA(gs_shop_cd,1,1)))
if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.setitem(1, "brand", 'B')
end if

if MidA(gs_shop_cd,3,4) <> '2000' then 
	if MidA(gs_shop_cd_1,1,2) <> 'XX' then
		ls_modify =	'brand.protect = 1'
		dw_head.Modify(ls_modify)
	end if
end if

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/
string   ls_title
integer li_date_diff

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

//is_fr_ymd   = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
//is_to_ymd   = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")

is_fr_ymd   = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd   = dw_head.GetItemString(1, "to_ymd") 


select datediff(day, :is_fr_ymd, :is_to_ymd)
into :li_date_diff
from dual;



if is_fr_ymd > is_to_ymd then
	MessageBox(ls_title,"마지막일자가 시작일자보다 작습니다.")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if li_date_diff > 31 then
	MessageBox(ls_title,"1개월 이상은 조회할수 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


//
//
//IF DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 31 THEN
//   MessageBox(ls_title,"1개월 이상은 조회할수 없습니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_ymd")
//   return false
//end if

if gs_brand_1 = 'X' then
	is_brand = dw_head.GetItemString(1, "brand")
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
else
	is_brand = dw_head.GetItemString(1, "brand")
	gs_brand = dw_head.GetItemString(1, "brand")
end if


is_style_no = dw_head.GetItemString(1, "style_no")
is_sale_grp = dw_head.GetItemString(1, "sale_grp")
is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_brand = dw_head.GetItemString(1, "brand")
is_dotcom = dw_head.GetItemString(1, "dotcom")

return true
end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/
string ls_shop_cd
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd,3,4) = '2000' then
	ls_shop_cd = is_brand  + MidA(gs_shop_cd,3,4)
elseif MidA(gs_brand_1,1,2) = 'XX' then
	ls_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
else 	
	ls_shop_cd = gs_shop_cd
end if	


il_rows = dw_body.retrieve(ls_shop_cd, is_fr_ymd, is_to_ymd, is_sale_grp,is_year,is_season, is_style_no, is_dotcom)

THIS.TRIGGER EVENT ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size  
Boolean    lb_check 
DataStore  lds_Source 

//마감하는 년도시즌 가져오는 펑션
if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

CHOOSE CASE as_column
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				RETURN 0 
			END IF
			ls_style = LeftA(as_data, 8)  
			ls_chno  = MidA(as_data,  9, 1)  
			ls_color = MidA(as_data, 10, 2)  
			ls_size  = MidA(as_data, 12, 2)  
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno  + "%'"  + &
				                " and color LIKE '" + ls_color + "%'"  + &
				                " and size  LIKE '" + ls_size  + "%'"  
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
			   /* 다음컬럼으로 이동 */
			   cb_retrieve.SetFocus()
		      lb_check = TRUE 
				ib_itemchanged = FALSE
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_shop_cd.Text = '" + gs_shop_cd + "'" + &
             "t_shop_nm.Text = '" + gs_shop_nm + "'" + &
             "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
             "t_to_ymd.Text = '" + is_to_ymd + "'" 

dw_print.Modify(ls_modify)
end event

type cb_close from w_com010_d`cb_close within w_sh108_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh108_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_sh108_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh108_d
integer taborder = 30
end type

type cb_update from w_com010_d`cb_update within w_sh108_d
end type

type cb_print from w_com010_d`cb_print within w_sh108_d
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_sh108_d
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_sh108_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh108_d
integer x = 613
integer width = 2373
integer height = 216
integer taborder = 20
string dataobject = "d_sh108_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/
long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "style_no"	 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand", "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			gs_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
			if gs_brand = '%' then
				if rb_1.checked = true then
					dw_body.DataObject = "d_sh108_d11"
					dw_body.SetTransObject(SQLCA)
					dw_print.DataObject = "d_sh108_r11"
					dw_print.SetTransObject(SQLCA)
				elseif rb_2.checked = true then
					dw_body.DataObject = "d_sh108_d12"
					dw_body.SetTransObject(SQLCA)
					dw_print.DataObject = "d_sh108_r12"
					dw_print.SetTransObject(SQLCA)				
				elseif rb_3.checked = true then
					dw_body.DataObject = "d_sh108_d13"
					dw_body.SetTransObject(SQLCA)
					dw_print.DataObject = "d_sh108_r13"
					dw_print.SetTransObject(SQLCA)		
				elseif rb_4.checked = true then
					dw_body.DataObject = "d_sh108_d14"
					dw_body.SetTransObject(SQLCA)
					dw_print.DataObject = "d_sh108_r14"
					dw_print.SetTransObject(SQLCA)		
				end if
			else
				select isnull(count(brand),0)
				into	:ll_b_cnt
				from tb_91100_m  with (nolock) 
				where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
						and brand = :gs_brand;	
						
				if ll_b_cnt = 0 then 
					messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
					dw_body.reset()
					return 0
				end if				
			end if
			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			
			
			Trigger Event ue_retrieve()			
			
END CHOOSE

end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 
string ls_year
datetime ld_datetime


This.GetChild("sale_grp", idw_sale_grp)
idw_sale_grp.SetTransObject(SQLCA)
idw_sale_grp.Retrieve('009')
idw_sale_grp.insertRow(1)
idw_sale_grp.Setitem(1, "inter_cd", "%")
idw_sale_grp.Setitem(1, "inter_nm", "전체")
idw_sale_grp.SetFilter("inter_cd <> '4'")
idw_sale_grp.Filter()
/*
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
*/
if MidA(gs_shop_cd_1,1,2) = 'XX' then	
	This.GetChild("brand", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve('001')
	ldw_child.InsertRow(1)
	ldw_child.SetItem(1, "inter_cd", '%')
	ldw_child.SetItem(1, "inter_nm", '전체')
else
	This.GetChild("brand", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve('001')
end if

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertRow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_nm", "전체")

//라빠레트 시즌적용
SELECT GetDate()
  INTO :ld_datetime
  FROM DUAL ;

GF_CURR_YEAR(ld_datetime, ls_year)

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
//idw_season.retrieve('003', gs_brand, is_year)
idw_season.retrieve('003', gs_brand, ls_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


end event

type ln_1 from w_com010_d`ln_1 within w_sh108_d
integer beginy = 544
integer endy = 544
end type

type ln_2 from w_com010_d`ln_2 within w_sh108_d
integer beginy = 548
integer endy = 548
end type

type dw_body from w_com010_d`dw_body within w_sh108_d
integer y = 560
integer width = 2857
integer height = 1228
integer taborder = 40
string dataobject = "d_sh108_d05"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_sh108_d
integer x = 219
integer y = 564
string dataobject = "d_sh108_r01"
end type

type rb_1 from radiobutton within w_sh108_d
event ue_keydown pbm_keydown
integer x = 46
integer y = 184
integer width = 288
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "일자별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0)) 
	RETURN 1
END IF

end event

event clicked;This.TextColor = Rgb(0, 0, 255)
rb_2.TextColor = Rgb(0, 0, 0)
rb_3.TextColor = Rgb(0, 0, 0)
rb_4.TextColor = Rgb(0, 0, 0)

if gs_brand = '%' then
	dw_body.DataObject = "d_sh108_d11"
	dw_body.SetTransObject(SQLCA)	
	dw_print.DataObject = "d_sh108_r11"
	dw_print.SetTransObject(SQLCA)
else
	dw_body.DataObject = "d_sh108_d01"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_sh108_r01"
	dw_print.SetTransObject(SQLCA)
end if

Parent.Post Event ue_retrieve()
end event

type rb_2 from radiobutton within w_sh108_d
event ue_keydown pbm_keydown
integer x = 46
integer y = 256
integer width = 288
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "품종별"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0)) 
	RETURN 1
END IF

end event

event clicked;This.TextColor = Rgb(0, 0, 255)
rb_1.TextColor = Rgb(0, 0, 0)
rb_3.TextColor = Rgb(0, 0, 0)
rb_4.TextColor = Rgb(0, 0, 0)
rb_5.TextColor = Rgb(0, 0, 0)

if gs_brand = '%' then
	dw_body.DataObject = "d_sh108_d12"
	dw_body.SetTransObject(SQLCA)	
	dw_print.DataObject = "d_sh108_r12"
	dw_print.SetTransObject(SQLCA)
else
	dw_body.DataObject = "d_sh108_d02"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_sh108_r02"
	dw_print.SetTransObject(SQLCA)
end if

Parent.Post Event ue_retrieve()
end event

type rb_3 from radiobutton within w_sh108_d
event ue_keydown pbm_keydown
integer x = 46
integer y = 328
integer width = 411
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "인기스타일별"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0)) 
	RETURN 1
END IF

end event

event clicked;This.TextColor = Rgb(0, 0, 255)
rb_1.TextColor = Rgb(0, 0, 0)
rb_2.TextColor = Rgb(0, 0, 0)
rb_4.TextColor = Rgb(0, 0, 0)
rb_5.TextColor = Rgb(0, 0, 0)

if gs_brand = '%' then
	dw_body.DataObject = "d_sh108_d13"
	dw_body.SetTransObject(SQLCA)	
	dw_print.DataObject = "d_sh108_r13"
	dw_print.SetTransObject(SQLCA)
else
	dw_body.DataObject = "d_sh108_d03"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_sh108_r03"
	dw_print.SetTransObject(SQLCA)
end if

Parent.Post Event ue_retrieve()
end event

type rb_4 from radiobutton within w_sh108_d
integer x = 46
integer y = 400
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "상세내역"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = Rgb(0, 0, 255)
rb_1.TextColor = Rgb(0, 0, 0)
rb_2.TextColor = Rgb(0, 0, 0)
rb_3.TextColor = Rgb(0, 0, 0)
rb_5.TextColor = Rgb(0, 0, 0)

if gs_brand = '%' then
	dw_body.DataObject = "d_sh108_d14"
	dw_body.SetTransObject(SQLCA)	
	dw_print.DataObject = "d_sh108_r14"
	dw_print.SetTransObject(SQLCA)
else
	dw_body.DataObject = "d_sh108_d04"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_sh108_r04"
	dw_print.SetTransObject(SQLCA)
end if

Parent.Post Event ue_retrieve()
end event

type cb_excel from commandbutton within w_sh108_d
integer x = 105
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel"
end type

event clicked;string ls_doc_nm, ls_nm

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
li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type rb_5 from radiobutton within w_sh108_d
event ue_keydown pbm_keydown
integer x = 46
integer y = 468
integer width = 553
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "일자별(닷컴체크)"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0)) 
	RETURN 1
END IF

end event

event clicked;This.TextColor = Rgb(0, 0, 255)
rb_1.TextColor = Rgb(0, 0, 0)
rb_2.TextColor = Rgb(0, 0, 0)
rb_3.TextColor = Rgb(0, 0, 0)
rb_4.TextColor = Rgb(0, 0, 0)

if gs_brand = '%' then
	dw_body.DataObject = "d_sh108_d11"
	dw_body.SetTransObject(SQLCA)	
	dw_print.DataObject = "d_sh108_r11"
	dw_print.SetTransObject(SQLCA)
else
	dw_body.DataObject = "d_sh108_d05"
	dw_body.SetTransObject(SQLCA)
end if

Parent.Post Event ue_retrieve()
end event

type gb_1 from groupbox within w_sh108_d
integer x = 18
integer y = 136
integer width = 594
integer height = 404
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

