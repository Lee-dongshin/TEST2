$PBExportHeader$w_22112_d.srw
$PBExportComments$원자재출고/반품현황
forward
global type w_22112_d from w_com010_d
end type
type rb_1 from radiobutton within w_22112_d
end type
type rb_2 from radiobutton within w_22112_d
end type
type rb_3 from radiobutton within w_22112_d
end type
end forward

global type w_22112_d from w_com010_d
integer width = 3680
integer height = 2276
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
end type
global w_22112_d w_22112_d

type variables
datawindowchild idw_brand, idw_year, idw_season, idw_sojae, idw_out_gubn

string is_brand, is_year, is_season, is_sojae, is_out_gubn, is_st_ymd, is_ed_ymd, is_mat_cd

end variables

on w_22112_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
end on

on w_22112_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
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
is_sojae = dw_head.GetItemString(1, "sojae")
is_out_gubn = dw_head.GetItemString(1, "out_gubn")
is_st_ymd	= dw_head.GetItemString(1, "st_ymd")
is_ed_ymd	= dw_head.GetItemString(1, "ed_ymd")
is_mat_cd	= dw_head.GetItemString(1, "mat_cd")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


if IsNull(is_st_ymd) or Trim(is_st_ymd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_ymd")
   return false
end if

if IsNull(is_ed_ymd) or Trim(is_ed_ymd) = "" then
   MessageBox(ls_title,"종료일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ed_ymd")
   return false
end if

if is_st_ymd > is_ed_ymd  then
	MessageBox(ls_title,"시작일이 종료일보다 클수는 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_ymd")
	  return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;
/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("is_brand",is_brand)
//messagebox("is_year",is_year)
//messagebox("is_season",is_season)
//messagebox("is_sojae",is_sojae)
//messagebox("is_out_gubn",is_out_gubn)

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_out_gubn, is_st_ymd, is_ed_ymd, is_mat_cd)

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

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"st_ymd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"ed_ymd",string(ld_datetime,"yyyymmdd"))
end if
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_item.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "mat_sojae_display") + "'"   + &
				 "t_st_ymd.Text = '" + String(is_st_ymd, '@@@@/@@/@@') + "'" + &
				 "t_ed_ymd.Text = '" + String(is_ed_ymd, '@@@@/@@/@@') + "'" 
dw_print.Modify(ls_modify)



end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         rb_1.Enabled = false
         rb_2.Enabled = false
         rb_3.Enabled = false
      end if
   CASE 5    /* 조건 */
      rb_1.Enabled = true
      rb_2.Enabled = true
      rb_3.Enabled = true
	
END CHOOSE

end event

event ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm ,ls_mat_nm
Boolean    lb_check 
DataStore  lds_Source


is_brand = dw_head.getitemstring(1,"brand")
is_year = dw_head.getitemstring(1,"year")
is_season = dw_head.getitemstring(1,"season")
is_sojae = dw_head.getitemstring(1,"sojae")

CHOOSE CASE as_column

	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or as_data = "" then
						RETURN 0			
				ELSEIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
						RETURN 0		
				end if
					
			END IF
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 

			
			gst_cd.default_where   = "where brand = '" + is_brand + "' and mat_year like '" + is_year + "%' and mat_season like '" + is_season + "%'" // and mat_sojae like '" + is_sojae + "%'"
		
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
				dw_head.SetItem(al_row, "sojae", lds_Source.GetItemString(1,"mat_sojae"))
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22112_d","0")
end event

type cb_close from w_com010_d`cb_close within w_22112_d
end type

type cb_delete from w_com010_d`cb_delete within w_22112_d
end type

type cb_insert from w_com010_d`cb_insert within w_22112_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22112_d
end type

type cb_update from w_com010_d`cb_update within w_22112_d
end type

type cb_print from w_com010_d`cb_print within w_22112_d
end type

type cb_preview from w_com010_d`cb_preview within w_22112_d
end type

type gb_button from w_com010_d`gb_button within w_22112_d
end type

type cb_excel from w_com010_d`cb_excel within w_22112_d
end type

type dw_head from w_com010_d`dw_head within w_22112_d
integer width = 3456
integer height = 252
string dataobject = "d_22112_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
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


this.getchild("sojae",idw_sojae)
idw_sojae.settransobject(sqlca)
idw_sojae.retrieve('1', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1,"mat_sojae", '%')
idw_sojae.SetItem(1,"mat_sojae_nm",'전체')


this.getchild("out_gubn",idw_out_gubn)
idw_out_gubn.settransobject(sqlca)
idw_out_gubn.retrieve('023')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
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
		
		
		this.getchild("sojae",idw_sojae)
		idw_sojae.settransobject(sqlca)
		idw_sojae.retrieve('1', is_brand)
		idw_sojae.InsertRow(1)
		idw_sojae.SetItem(1,"mat_sojae", '%')
		idw_sojae.SetItem(1,"mat_sojae_nm",'전체')
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_22112_d
end type

type ln_2 from w_com010_d`ln_2 within w_22112_d
end type

type dw_body from w_com010_d`dw_body within w_22112_d
string dataobject = "d_22112_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

this.getchild("out_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('023')

end event

type dw_print from w_com010_d`dw_print within w_22112_d
string dataobject = "d_22112_r01"
end type

event dw_print::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()


this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

this.getchild("out_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('023')

end event

type rb_1 from radiobutton within w_22112_d
integer x = 2880
integer y = 204
integer width = 402
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
rb_2.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)

dw_body.dataobject = "d_22112_d01"
dw_body.SetTransObject(SQLCA)

dw_body.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_body.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

dw_body.getchild("out_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('023')

dw_print.dataobject = "d_22112_r01"
dw_print.SetTransObject(SQLCA)

dw_print.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_print.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

dw_print.getchild("out_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('023')


end event

type rb_2 from radiobutton within w_22112_d
integer x = 2880
integer y = 276
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "협력업체별"
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_child

This.textcolor = Rgb(0, 0, 255) 
rb_1.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)

dw_body.dataobject = "d_22112_d02"
dw_body.SetTransObject(SQLCA)

dw_body.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_body.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

dw_body.getchild("out_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('023')

dw_print.dataobject = "d_22112_r02"
dw_print.SetTransObject(SQLCA)

dw_print.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_print.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

dw_print.getchild("out_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('023')


end event

type rb_3 from radiobutton within w_22112_d
integer x = 2880
integer y = 344
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "기간별"
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_child

This.textcolor = Rgb(0, 0, 255) 
rb_1.textcolor = Rgb(0, 0, 0)
rb_2.textcolor = Rgb(0, 0, 0)

dw_body.dataobject = "d_22112_d03"
dw_body.SetTransObject(SQLCA)

dw_body.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_body.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

dw_body.getchild("out_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('023')

dw_print.dataobject = "d_22112_r03"
dw_print.SetTransObject(SQLCA)

dw_print.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

dw_print.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

dw_print.getchild("out_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('023')


end event

