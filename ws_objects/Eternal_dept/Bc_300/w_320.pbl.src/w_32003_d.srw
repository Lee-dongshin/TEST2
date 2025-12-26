$PBExportHeader$w_32003_d.srw
$PBExportComments$기획년도별 원가 현황
forward
global type w_32003_d from w_com010_d
end type
type rb_style from radiobutton within w_32003_d
end type
type rb_item from radiobutton within w_32003_d
end type
type cbx_balju from checkbox within w_32003_d
end type
type gb_1 from groupbox within w_32003_d
end type
end forward

global type w_32003_d from w_com010_d
integer width = 3671
integer height = 2276
rb_style rb_style
rb_item rb_item
cbx_balju cbx_balju
gb_1 gb_1
end type
global w_32003_d w_32003_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_make_type, idw_country_cd

String is_brand, is_year, is_season, is_sojae, is_item, is_make_type, is_country_cd, is_cust_cd
String is_yymmdd, is_area_fg, is_level_fg, is_balju = 'N' , is_opt_chn = 'A', is_expt_fg = 'N'

end variables

on w_32003_d.create
int iCurrent
call super::create
this.rb_style=create rb_style
this.rb_item=create rb_item
this.cbx_balju=create cbx_balju
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_style
this.Control[iCurrent+2]=this.rb_item
this.Control[iCurrent+3]=this.cbx_balju
this.Control[iCurrent+4]=this.gb_1
end on

on w_32003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_style)
destroy(this.rb_item)
destroy(this.cbx_balju)
destroy(this.gb_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.02                                                  */	
/* 수정일      : 2002.02.02                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("dw_body",string(dw_body.dataobject))
il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_make_type, &
									is_yymmdd, is_area_fg, is_level_fg, is_balju, is_opt_chn, is_country_cd, is_cust_cd, is_expt_fg)
									
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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.02                                                  */	
/* 수정일      : 2002.02.02                                                  */
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

is_expt_fg = dw_head.GetItemString(1, "expt_fg")

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
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

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재 유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"복종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_make_type = dw_head.GetItemString(1, "make_type")
if IsNull(is_make_type) or Trim(is_make_type) = "" then
   MessageBox(ls_title,"생산 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("make_type")
   return false
end if

is_yymmdd = String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd')
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_area_fg = dw_head.GetItemString(1, "area_fg")
if IsNull(is_area_fg) or Trim(is_area_fg) = "" then
   MessageBox(ls_title,"생산 지역을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("area_fg")
   return false
end if

is_level_fg = dw_head.GetItemString(1, "level_fg")
if IsNull(is_level_fg) or Trim(is_level_fg) = "" then
   MessageBox(ls_title,"등급 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("level_fg_fg")
   return false
end if

is_opt_chn = dw_head.GetItemString(1, "opt_chn")

is_country_cd = dw_head.GetItemString(1, "country_cd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")



return true

end event

event open;call super::open;dw_head.SetColumn("sojae")

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
			cbx_balju.enabled = false
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
			rb_style.Enabled = false
			rb_item.Enabled = false
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
		cbx_balju.enabled = true
		rb_style.Enabled = true
		rb_item.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_area_fg_nm, ls_level_fg_nm, ls_opt_chn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_area_fg = '00' Then
	ls_area_fg_nm = '국내'
ElseIf is_area_fg = '01' Then
	ls_area_fg_nm = '해외'
Else
	ls_area_fg_nm = '전체'
End IF

If is_level_fg = 'A' Then
	ls_level_fg_nm = '정상'
ElseIf is_level_fg = 'B' Then
	ls_level_fg_nm = '불량'
Else
	ls_level_fg_nm = '전체'
End IF

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text = '" + is_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
            "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
            "t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_area_fg.Text = '" + ls_area_fg_nm + "'" + &
            "t_level_fg.Text = '" + ls_level_fg_nm + "'" + & 
            "t_balju.Text = '" + upper(is_balju) + "'" 
dw_print.Modify(ls_modify)

ls_opt_chn = dw_head.getitemstring(1,"opt_chn")
choose case ls_opt_chn
	case "A"  
			ls_opt_chn = "(전체)"
	case "K"  
			ls_opt_chn = "(국내)"		
	case "C"  
			ls_opt_chn = "(중국)"		
	case "X"	 
			ls_opt_chn = "(해외)"		
end choose
dw_print.object.t_opt_chn.text = ls_opt_chn
dw_print.object.t_country_cd.text = is_country_cd
dw_print.object.t_cust_cd.text = is_cust_cd

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32003_d","0")
end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.07                                                  */	
/* 수정일      : 2001.12.07                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 생산처 코드
	   is_brand = Trim(dw_head.GetItemString(1, "brand"))
			
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				End If
				
				Choose Case is_brand
					Case 'J'
						IF (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case 'Y'
						IF (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case Else
						IF LeftA(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
				End Choose
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911" 

			gst_cd.default_where   = " WHERE CUST_CODE BETWEEN '5000' and '8999' " 

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("make_type")
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

type cb_close from w_com010_d`cb_close within w_32003_d
end type

type cb_delete from w_com010_d`cb_delete within w_32003_d
end type

type cb_insert from w_com010_d`cb_insert within w_32003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_32003_d
end type

type cb_update from w_com010_d`cb_update within w_32003_d
end type

type cb_print from w_com010_d`cb_print within w_32003_d
end type

type cb_preview from w_com010_d`cb_preview within w_32003_d
end type

type gb_button from w_com010_d`gb_button within w_32003_d
end type

type cb_excel from w_com010_d`cb_excel within w_32003_d
end type

type dw_head from w_com010_d`dw_head within w_32003_d
integer x = 416
integer width = 3141
integer height = 220
string dataobject = "d_32003_h01"
end type

event dw_head::constructor;call super::constructor;Long ll_rows

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
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

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '[^Z]')
idw_item.SetItem(1, "item_nm", '기획제외')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.InsertRow(1)
idw_country_cd.SetItem(1, "inter_cd", '%')
idw_country_cd.SetItem(1, "inter_nm", '전체')


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')
ll_rows = idw_make_type.InsertRow(0)
idw_make_type.SetItem(ll_rows, "inter_cd", '90')
idw_make_type.SetItem(ll_rows, "inter_nm", '기획')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		

   CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

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
		
			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_32003_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_32003_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_32003_d
integer y = 444
integer height = 1596
string dataobject = "d_32003_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_32003_d
string dataobject = "d_32003_r01"
end type

type rb_style from radiobutton within w_32003_d
integer x = 18
integer y = 264
integer width = 302
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
string text = "STYLE별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_item.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_32003_d01'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_32003_r01'
dw_print.SetTransObject(SQLCA)

dw_head.SetFocus()

end event

type rb_item from radiobutton within w_32003_d
integer x = 18
integer y = 332
integer width = 302
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
string text = "복종별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor = RGB(0, 0, 0)
This.TextColor     = RGB(0, 0, 255)

dw_body.DataObject = 'd_32003_d02'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_32003_r02'
dw_print.SetTransObject(SQLCA)

dw_head.SetFocus()

end event

type cbx_balju from checkbox within w_32003_d
integer x = 18
integer y = 164
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "원가미확정포함"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	is_balju = 'Y'
else
	is_balju = 'N'
end if

end event

type gb_1 from groupbox within w_32003_d
integer x = 5
integer y = 212
integer width = 398
integer height = 204
integer taborder = 110
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

