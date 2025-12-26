$PBExportHeader$w_41008_d.srw
$PBExportComments$일자별입고현황출력
forward
global type w_41008_d from w_com010_d
end type
end forward

global type w_41008_d from w_com010_d
string title = "기간별입고현황"
end type
global w_41008_d w_41008_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_jup_gubn, idw_make_type,idw_year, idw_season, idw_item, idw_sojae,idw_class
string is_brand, is_frm_date, is_to_date, is_house_cd, is_jup_gubn, is_make_type
string is_year, is_season, is_item, is_sojae, is_in_gubn, is_class

end variables

on w_41008_d.create
call super::create
end on

on w_41008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_in_date", string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_in_date",  string(ld_datetime,"yyyymmdd"))

dw_head.setitem(1, "class", "A")
dw_head.setitem(1, "in_gubn", "+")
dw_head.setitem(1, "jup_gubn", "I1")
dw_head.setitem(1, "prod_gubn", "10")
dw_head.setitem(1, "house", "010000")

end event

event ue_keycheck;/*===========================================================================*/
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

is_frm_date = dw_head.GetItemString(1, "frm_in_date")
if IsNull(is_frm_date) or Trim(is_frm_date) = "" then
   MessageBox(ls_title,"입고기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_in_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_in_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"입고기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_in_date")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_in_gubn = dw_head.GetItemString(1, "in_gubn")
if IsNull(is_in_gubn) or Trim(is_in_gubn) = "" then
   MessageBox(ls_title,"입고구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_gubn")
   return false
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" then
   MessageBox(ls_title,"전표구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

is_make_type = dw_head.GetItemString(1, "prod_gubn")
if IsNull(is_make_type) or Trim(is_make_type) = "" then
  is_make_type = '%'
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   is_year = '%'
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   is_season = '%'
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   is_item = '%'
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   is_sojae = '%'
end if

is_class = dw_head.GetItemString(1, "class")
if IsNull(is_class) or Trim(is_class) = "" then
   is_class = '%'
end if

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
	
il_rows = dw_body.retrieve(is_brand, is_frm_date, is_to_date, is_in_gubn, is_jup_gubn, is_house_cd, is_year, is_season, is_item, is_sojae, is_class)
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_year, ls_season, ls_item, ls_sojae

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if IsNull(is_year) or Trim(is_year) = "%" then
	ls_year = '% 전체 년도'
else
	ls_year = is_year
end if	

if IsNull(is_season) or Trim(is_season) = "%" then
	ls_season = '% 전체 시즌'
else
	ls_season = is_season
end if	

if IsNull(is_item) or Trim(is_item) = "%" then
	ls_item = '% 전체 복종'
else
	ls_item = is_item
end if	

if IsNull(is_sojae) or Trim(is_sojae) = "%" then
	ls_sojae = '% 전체 소재'
else
	ls_sojae = is_sojae
end if	


ls_modify =	"txtbrand.Text     = '" + is_brand + "' " + &	
            "txtfrm_date.Text  = '" + is_frm_date + "' " + &
            "txtto_date.Text   = '" + is_to_date + "' " //+ &
//            "txthouse_cd.Text  = '" + is_house_cd + "' " + &
//            "txtin_gubn.Text   = '" + is_in_gubn + "' " + &				
//            "txtjup_gubn.Text  = '" + is_jup_gubn + "' " + &				
//				"txtyear.Text      = '" + ls_year + "' " + &				
//            "txtseason.Text     = '" + ls_season + "' " + &								
//				"txtitem.Text      = '" + ls_item + "' " + &				
//            "txtsojae.Text     = '" + ls_sojae + "'" 								

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41005_d","0")
end event

type cb_close from w_com010_d`cb_close within w_41008_d
end type

type cb_delete from w_com010_d`cb_delete within w_41008_d
end type

type cb_insert from w_com010_d`cb_insert within w_41008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_41008_d
end type

type cb_update from w_com010_d`cb_update within w_41008_d
end type

type cb_print from w_com010_d`cb_print within w_41008_d
end type

type cb_preview from w_com010_d`cb_preview within w_41008_d
end type

type gb_button from w_com010_d`gb_button within w_41008_d
end type

type cb_excel from w_com010_d`cb_excel within w_41008_d
end type

type dw_head from w_com010_d`dw_head within w_41008_d
integer x = 9
integer y = 180
integer width = 3589
integer height = 320
string dataobject = "d_41008_h01"
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("jup_gubn", idw_jup_gubn )
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('024')

This.GetChild("prod_gubn", idw_make_type )
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("class", idw_class )
idw_class.SetTransObject(SQLCA)
idw_class.Retrieve('401')

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve()
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '[^C]')
idw_sojae.SetItem(1, "sojae_nm", '사입제외')







end event

event dw_head::itemchanged;call super::itemchanged;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "house" 
      IF ib_itemchanged THEN RETURN 1

      if data = "020000" then 
			dw_head.setitem(1, "class" , "B")
		else 	
   		dw_head.setitem(1, "class" , "A")
		end if	

   CASE "class" 
      IF ib_itemchanged THEN RETURN 1

      if data = "A" then 
			dw_head.setitem(1, "house" , "010000")
		else	
			dw_head.setitem(1, "house" , "020000")			
		end if	
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_41008_d
integer beginy = 500
integer endy = 500
end type

type ln_2 from w_com010_d`ln_2 within w_41008_d
integer beginy = 504
integer endy = 504
end type

type dw_body from w_com010_d`dw_body within w_41008_d
integer y = 516
integer height = 1524
string dataobject = "d_41008_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_41008_d
integer x = 1202
integer y = 1192
integer width = 1531
integer height = 440
string dataobject = "d_41008_r01"
end type

