$PBExportHeader$w_22206_d.srw
$PBExportComments$원/부자재 수불장
forward
global type w_22206_d from w_com010_d
end type
type rb_1 from radiobutton within w_22206_d
end type
type rb_2 from radiobutton within w_22206_d
end type
type gb_1 from groupbox within w_22206_d
end type
end forward

global type w_22206_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_22206_d w_22206_d

type variables
string  is_brand,  is_year,  is_season,  is_mat_gubn, is_mat_sojae, is_mat_cd, is_fr_bill_dt,is_to_bill_dt
DataWindowChild  idw_brand,  idw_season, idw_mat_sojae
end variables

on w_22206_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
end on

on w_22206_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      14                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season,is_mat_sojae,is_mat_cd,is_mat_gubn,is_fr_bill_dt,is_to_bill_dt)
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
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source 

is_brand = dw_head.getitemstring(1,"brand")
is_year = dw_head.getitemstring(1,"year")
is_season = dw_head.getitemstring(1,"season")
is_mat_sojae = dw_head.getitemstring(1,"mat_sojae")
CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or as_data = "" then
						RETURN 0			
				ELSEIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
					//	RETURN 0		
					 if gs_brand <> "K" then	
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								RETURN 0
							end if	
					 end if								
				end if
					
			END IF
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 

			
			gst_cd.default_where   = "where brand = '" + is_brand + "' and mat_year like '" + is_year + "%' and mat_season like '" + is_season + "%' and mat_sojae like '" + is_mat_sojae + "%'"
		
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
				dw_head.SetItem(al_row, "mat_sojae", lds_Source.GetItemString(1,"mat_sojae"))
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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/* event       : ue_keycheck                                                 */
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

is_brand = dw_head.GetItemString(1, "brand")
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
elseif ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_mat_sojae = dw_head.GetItemString(1, "mat_sojae")
if IsNull(is_mat_sojae) or Trim(is_mat_sojae) = "" then
	MessageBox(ls_title,"소재품종을 선택 하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("mat_sojae")
	return false
end if

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
if IsNull(is_mat_cd) or Trim(is_mat_cd) = ""  then
	is_mat_cd  =  '%'
end if

is_fr_bill_dt = String(dw_head.GetItemDateTime(1,"fr_bill_dt"), 'yyyymmdd')
if IsNull(is_fr_bill_dt) Or Trim(is_fr_bill_dt) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("fr_bill_dt")
	return false
end if

is_to_bill_dt = String(dw_head.GetItemDateTime(1,"to_bill_dt"), 'yyyymmdd')
if IsNull(is_to_bill_dt) Or Trim(is_to_bill_dt) = "" then
   MessageBox(ls_title,"To일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("to_bill_dt")
	return false
end if

if is_to_bill_dt < is_fr_bill_dt  then
	MessageBox(ls_title, "마지막 일자가 처음 일자보다 작습니다!")
   dw_head.SetFocus()
	dw_head.SetColumn("to_bill_dt")
	return false
end if

return true
end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

If is_mat_gubn = '1' Then
	ls_title = '원자재 수불장'
Else
	ls_title = '부자재 수불장'
End If

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_title.Text = '" + ls_title + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_mat_sojae.Text = '" + idw_mat_sojae.GetItemString(idw_mat_sojae.GetRow(), "mat_sojae_display") + "'" + &
				 "t_fr_bill_dt.Text = '" + String(is_fr_bill_dt, '@@@@/@@/@@') + "'" + &
				 "t_to_bill_dt.Text = '" + String(is_to_bill_dt, '@@@@/@@/@@') + "'" 
dw_print.Modify(ls_modify)


end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_bill_dt", ld_datetime)
dw_head.SetItem(1, "to_bill_dt", ld_datetime)

is_mat_gubn = '1'

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22206_d","0")
end event

type cb_close from w_com010_d`cb_close within w_22206_d
integer taborder = 110
end type

type cb_delete from w_com010_d`cb_delete within w_22206_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_22206_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22206_d
end type

type cb_update from w_com010_d`cb_update within w_22206_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_22206_d
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_22206_d
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_22206_d
end type

type cb_excel from w_com010_d`cb_excel within w_22206_d
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_22206_d
integer x = 453
integer y = 168
integer width = 3127
integer height = 224
string dataobject = "d_22206_h01"
boolean livescroll = false
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

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

This.GetChild("mat_sojae", idw_mat_sojae)
idw_mat_sojae.SetTRansObject(SQLCA)
idw_mat_sojae.Retrieve("1", is_brand)
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

 

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/* event       : itemchanged(dw_head)                                        */
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
		
		This.GetChild("mat_sojae", idw_mat_sojae)
		idw_mat_sojae.SetTRansObject(SQLCA)
		if rb_1.checked = true then
			idw_mat_sojae.Retrieve("1", is_brand)
		else
			idw_mat_sojae.Retrieve("2", is_brand)
		end if
		idw_mat_sojae.insertrow(1)
		idw_mat_sojae.Setitem(1, "mat_sojae", "%")
		idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_22206_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_22206_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_22206_d
integer y = 444
integer width = 3566
integer height = 1556
integer taborder = 40
string dataobject = "d_22206_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;This.inv_sort.of_SetColumnHeader(false)
end event

type dw_print from w_com010_d`dw_print within w_22206_d
string dataobject = "d_22206_r01"
end type

type rb_1 from radiobutton within w_22206_d
event ue_keydown pbm_keydown
integer x = 73
integer y = 204
integer width = 297
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
string text = "원자재"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
END IF

end event

event clicked;This.textcolor = Rgb(0, 0, 255) 
rb_2.textcolor = Rgb(0, 0, 0)
is_mat_gubn = '1' 

dw_head.SetItem(1, "mat_sojae", "")
dw_head.SetItem(1, "mat_cd", "")
dw_head.SetItem(1, "mat_nm", "")
is_brand = dw_head.getitemstring(1,'brand')

idw_mat_sojae.Retrieve('1', is_brand)
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)


end event

type rb_2 from radiobutton within w_22206_d
event ue_keydown pbm_keydown
integer x = 73
integer y = 296
integer width = 293
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
string text = "부자재"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
END IF

end event

event clicked;This.textcolor = Rgb(0, 0, 255) 
rb_1.textcolor = Rgb(0, 0, 0)
is_mat_gubn = '2' 

dw_head.SetItem(1, "mat_sojae", "")
dw_head.SetItem(1, "mat_cd", "")
dw_head.SetItem(1, "mat_nm", "")
is_brand = dw_head.getitemstring(1,'brand')

idw_mat_sojae.Retrieve('2',is_brand)
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
end event

type gb_1 from groupbox within w_22206_d
integer x = 14
integer y = 156
integer width = 411
integer height = 236
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

