$PBExportHeader$w_12016_d.srw
$PBExportComments$Style Speed 조회
forward
global type w_12016_d from w_com010_d
end type
type dw_1 from datawindow within w_12016_d
end type
end forward

global type w_12016_d from w_com010_d
integer width = 3694
integer height = 2296
dw_1 dw_1
end type
global w_12016_d w_12016_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae,idw_item, idw_dep_seq, idw_disc_seq
String is_brand, is_year, is_season, is_sojae, is_item, is_style, is_chno, is_chno_gubn, is_chi_gubn
String is_color_gubn, is_dep_seq, is_disc_seq,is_style_stat

end variables

on w_12016_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_12016_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
integer ii,jj
long ll_row
String ls_file_name, ls_style, ls_color
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_color_gubn = "N" then 
	dw_body.dataobject = "d_12016_d01"
	dw_body.SetTransObject(SQLCA)
	dw_print.dataobject = "d_12016_r01"
	dw_print.SetTransObject(SQLCA)	
else
	dw_body.dataobject = "d_12016_d05"
	dw_body.SetTransObject(SQLCA)
	dw_print.dataobject = "d_12016_r05"
	dw_print.SetTransObject(SQLCA)
end if

if is_style_stat = "B" then
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item, is_chno_gubn, is_chi_gubn, is_style_stat, is_dep_seq)
elseif is_style_stat = "C" then
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item, is_chno_gubn, is_chi_gubn, is_style_stat, is_disc_seq)
else
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item, is_chno_gubn, is_chi_gubn, is_style_stat, "%")
end if

IF il_rows > 0   THEN
	
		if  is_color_gubn = "N" then
			for jj = 1 to 	il_rows
				// 사진이 없는 경우 있는 칼라를 찾아 사진 보이도록 작업
				ls_file_name = dw_body.getitemstring(jj,"style_pic")
				ls_style     = dw_body.getitemstring(jj,"style")
				
				if FileExists(ls_file_name) = false then 
					
					dw_1.retrieve(ls_style)
					ll_row = dw_1.RowCount()
					
					for ii = 1 to ll_row
						 ls_color = dw_1.getitemstring(ii, "color")
						 
						 select dbo.SF_PIC_COLOR_DIR(:ls_style +'%',:ls_color)
						 into :ls_file_name
						 from dual ;
						 
						 if FileExists(ls_file_name) then
							goto NextStep
						 end if
				
					next
					
					NextStep:
					dw_body.setitem(jj,"style_pic", ls_file_name)
					
				end if	
			next
		end if
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
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
if IsNull(is_sojae) or is_sojae = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_chno_gubn = Trim(dw_head.GetItemString(1, "chno_gubn"))
if IsNull(is_chno_gubn) or is_chno_gubn = "" then
   MessageBox(ls_title,"리오다제외여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chno_gubn")
   return false
end if

is_chi_gubn = Trim(dw_head.GetItemString(1, "chi_gubn"))
if IsNull(is_chi_gubn) or is_chi_gubn = "" then
   MessageBox(ls_title,"중국용제외여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chi_gubn")
   return false
end if


is_color_gubn = Trim(dw_head.GetItemString(1, "color_gubn"))

is_dep_seq = dw_head.GetItemString(1, "dep_seq")
is_disc_seq = dw_head.GetItemString(1, "disc_seq")
is_style_stat = dw_head.GetItemString(1, "style_stat")

return true

end event

event ue_title();call super::ue_title;///*===========================================================================*/
///* 작성자      : (주)지우정보 (권 진택)                                      */	
///* 작성일      : 2002.01.19                                                  */	
///* 수정일      : 2002.01.19                                                  */
///*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_sale_type, ls_sort_fg, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_pg_id.Text     = '" + is_pgm_id + "'" + &
            "t_user_id.Text   = '" + gs_user_id + "'" + &
            "t_datetime.Text  = '" + ls_datetime + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text      = '" + is_year + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12016_d","0")
end event

event pfc_preopen();call super::pfc_preopen;//dw_detail.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_12016_d
end type

type cb_delete from w_com010_d`cb_delete within w_12016_d
end type

type cb_insert from w_com010_d`cb_insert within w_12016_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12016_d
end type

type cb_update from w_com010_d`cb_update within w_12016_d
end type

type cb_print from w_com010_d`cb_print within w_12016_d
end type

type cb_preview from w_com010_d`cb_preview within w_12016_d
end type

type gb_button from w_com010_d`gb_button within w_12016_d
end type

type cb_excel from w_com010_d`cb_excel within w_12016_d
end type

type dw_head from w_com010_d`dw_head within w_12016_d
integer x = 23
integer y = 160
integer width = 3593
integer height = 296
string dataobject = "d_12016_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTRansObject(SQLCA)
idw_dep_seq.InsertRow(1)
idw_dep_seq.Setitem(1, "inter_cd", "%")
idw_dep_seq.Setitem(1, "inter_nm", "전체")


This.GetChild("disc_seq", idw_disc_seq)
idw_disc_seq.SetTRansObject(SQLCA)
idw_disc_seq.InsertRow(1)
idw_disc_seq.Setitem(1, "inter_cd", "%")
idw_disc_seq.Setitem(1, "inter_nm", "전체")





end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
//	CASE "brand"
//		This.SetItem(1, "shop_cd", "")
//		This.SetItem(1, "shop_nm", "")
//	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "brand", "year"
		dw_head.accepttext()
		This.SetItem(1, "dep_seq", "")
		is_brand = data
		is_year = this.getitemstring(1, "year")
		is_season = this.getitemstring(1, "season")		
		
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)		
			
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
			
		
//		idw_except_seq.Retrieve(is_brand, is_year, is_season)
//		idw_except_seq.InsertRow(1)
//		idw_except_seq.SetItem(1, "dep_seq", '%')
//		idw_except_seq.SetItem(1, "dep_ymd", '전체')		
//		
		
	CASE "year"
		This.SetItem(1, "dep_seq", "")
		is_year = data
		is_brand = this.getitemstring(1, "brand")
		is_season = this.getitemstring(1, "season")			
		
		
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
//		idw_except_seq.Retrieve(is_brand, is_year, is_season)
//		idw_except_seq.InsertRow(1)
//		idw_except_seq.SetItem(1, "dep_seq", '%')
//		idw_except_seq.SetItem(1, "dep_ymd", '전체')		
//				
		
	CASE "season"
		This.SetItem(1, "dep_seq", "")
		is_season = data
		is_year = this.getitemstring(1, "year")
		is_brand = this.getitemstring(1, "brand")

		
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
//		idw_except_seq.Retrieve(is_brand, is_year, is_season)
//		idw_except_seq.InsertRow(1)
//		idw_except_seq.SetItem(1, "dep_seq", '%')
//		idw_except_seq.SetItem(1, "dep_ymd", '전체')		
				
		
	CASE "style_stat"
		if data = "B" then 
			dw_head.object.t_4.visible = true			
			dw_head.object.t_5.visible = false
		elseif data = "C" then 
			dw_head.object.t_4.visible = false
			dw_head.object.t_5.visible = true
		else	
			dw_head.object.t_4.visible = false
			dw_head.object.t_5.visible = false
		end if
		is_season = this.getitemstring(1, "season")
		is_year = this.getitemstring(1, "year")
		is_brand = this.getitemstring(1, "brand")



		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
//		idw_except_seq.Retrieve(is_brand, is_year, is_season)
//		idw_except_seq.InsertRow(1)
//		idw_except_seq.SetItem(1, "dep_seq", '%')
//		idw_except_seq.SetItem(1, "dep_ymd", '전체')					
					
		
		
		
END CHOOSE


end event

type ln_1 from w_com010_d`ln_1 within w_12016_d
integer beginy = 468
integer endy = 468
end type

type ln_2 from w_com010_d`ln_2 within w_12016_d
integer beginy = 472
integer endy = 472
end type

type dw_body from w_com010_d`dw_body within w_12016_d
integer x = 14
integer y = 476
integer width = 3598
integer height = 1580
string dataobject = "d_12016_d05"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::doubleclicked;call super::doubleclicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
if row > 0 then 
	choose case LeftA(dwo.name,5)
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(LeftA(dwo.name,6)+RightA(dwo.name,1)))
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			
	end choose	
end if

end event

type dw_print from w_com010_d`dw_print within w_12016_d
integer x = 658
integer y = 596
string dataobject = "d_12016_r05"
end type

type dw_1 from datawindow within w_12016_d
boolean visible = false
integer x = 2862
integer y = 740
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_55021_color"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

