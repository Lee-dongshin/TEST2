$PBExportHeader$w_12006_d.srw
$PBExportComments$제품 목록 현황
forward
global type w_12006_d from w_com010_d
end type
end forward

global type w_12006_d from w_com010_d
end type
global w_12006_d w_12006_d

type variables
String is_brand, is_year, is_season, is_sojae, is_item, is_style, is_opt, is_main_gbn, is_color_size, is_opt_chn
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item

end variables

on w_12006_d.create
call super::create
end on

on w_12006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_sojae = dw_head.GetItemString(1, "sojae")

is_item = dw_head.GetItemString(1, "item")

is_opt = dw_head.GetItemString(1, "opt")
if IsNull(is_opt) or Trim(is_opt) = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt")
   return false
end if


is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
   dw_head.SetItem(1, "style", '%')
end if


is_main_gbn = dw_head.GetItemString(1, "main_gbn")
is_color_size = dw_head.GetItemString(1, "color_size")
is_opt_chn = dw_head.GetItemString(1, "opt_chn")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.14                                                  */	
/* 수정일      : 2001.12.14                                                  */
/*===========================================================================*/
string ls_color_size

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt = "S" then
	dw_body.DataObject = "d_12006_d01"
	dw_body.SetTransObject(SQLCA)
	ls_color_size = is_color_size
//	if rb_1.checked then  
//		dw_body.DataObject = "d_12006_d01"
//		dw_body.SetTransObject(SQLCA)
//		dw_print.DataObject = 'd_12006_r01'
//		dw_print.SetTransObject(SQLCA)
//	else	
//		dw_body.DataObject  = 'd_12006_d04'
//		dw_body.SetTransObject(SQLCA)
//		dw_print.DataObject = 'd_12006_r04'
//		dw_print.SetTransObject(SQLCA)
//	end if
else
	if is_color_size = '1' then
		dw_body.DataObject = "d_12006_d03"
		ls_color_size = is_color_size
	else
		dw_body.DataObject = "d_12006_d02"
		ls_color_size = '0'
	end if
		dw_body.SetTransObject(SQLCA)
end if

if is_opt = "S" then
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_style, is_main_gbn, ls_color_size, is_opt_chn)
else
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_style, is_main_gbn, ls_color_size)	
end if

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

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.14                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
datetime ld_datetime
String ls_modify, ls_datetime
String ls_brand,  ls_season,  ls_sojae, ls_item, ls_main_gbn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_brand    =  "브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") 
ls_season   =  "시  즌 : " + is_year + "년도 " + &
               idw_season.GetitemString(idw_season.GetRow(), "inter_display")  
ls_sojae    =  "소  재 : " + idw_sojae.GetitemString(idw_sojae.GetRow(), "sojae_display")  
ls_item     =  "품  종 : " + idw_item.GetitemString(idw_item.GetRow(), "item_display") 

CHOOSE CASE is_main_gbn
	CASE "M"      // 메인
		ls_main_gbn = "메인구분: 메인"
	CASE "S"
		ls_main_gbn = "메인구분: 스팟"		
	CASE "R"
		ls_main_gbn = "메인구분: 리오더"		
	case else 
		ls_main_gbn = "메인구분: 전체"		
END CHOOSE

ls_modify =	"t_pg_id.Text = '"    + is_pgm_id + "'" + &
            "t_user_id.Text = '"  + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '"    + ls_brand + "'" + &
            "t_season.Text = '"   + ls_season + "'" + &
            "t_sojae.Text = '"    + ls_sojae + "'" + &
            "t_item.Text = '"     + ls_item + "'" + &
				"t_main_gbn.Text = '" + ls_main_gbn + "'"

dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			IF ai_div = 1 THEN 	
//				IF gf_style_chk(ls_style, ls_chno) THEN
//					RETURN 0
//				END IF 

			IF gf_style_chk(ls_style, ls_chno) THEN
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
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF

		if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if	

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
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

event ue_print;if is_opt = "S" then
	dw_print.DataObject = "d_12006_r01"
	dw_print.SetTransObject(SQLCA)
else
	dw_print.DataObject = "d_12006_r02"
	dw_print.SetTransObject(SQLCA)
end if

This.Trigger Event ue_title()

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();if is_opt = "S" then
	dw_print.DataObject = "d_12006_r01"
	dw_print.SetTransObject(SQLCA)
else
	dw_print.DataObject = "d_12006_r02"
	dw_print.SetTransObject(SQLCA)
end if


This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12006_d","0")
end event

type cb_close from w_com010_d`cb_close within w_12006_d
end type

type cb_delete from w_com010_d`cb_delete within w_12006_d
end type

type cb_insert from w_com010_d`cb_insert within w_12006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12006_d
end type

type cb_update from w_com010_d`cb_update within w_12006_d
end type

type cb_print from w_com010_d`cb_print within w_12006_d
end type

type cb_preview from w_com010_d`cb_preview within w_12006_d
end type

type gb_button from w_com010_d`gb_button within w_12006_d
end type

type cb_excel from w_com010_d`cb_excel within w_12006_d
end type

type dw_head from w_com010_d`dw_head within w_12006_d
integer x = 9
integer y = 156
integer width = 3584
integer height = 216
string dataobject = "d_12006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
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
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.insertrow(1)
idw_sojae.Setitem(1, "sojae", "%")
idw_sojae.Setitem(1, "sojae_nm", "전체")

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")

end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

		//라빠레트 시즌적용
		dw_head.accepttext()
		
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
	
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_12006_d
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_d`ln_2 within w_12006_d
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_d`dw_body within w_12006_d
integer y = 404
integer height = 1632
string dataobject = "d_12006_d01"
boolean hscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_12006_d
string dataobject = "d_12006_r01"
end type

