$PBExportHeader$w_41002_d.srw
$PBExportComments$스타일별 입고 현황 조회
forward
global type w_41002_d from w_com020_d
end type
end forward

global type w_41002_d from w_com020_d
string title = "스타일별 입고현황조회"
end type
global w_41002_d w_41002_d

type variables
DataWindowChild idw_year, idw_season, idw_class,idw_brand
string  is_frm_date, is_to_date, is_style, is_year, is_season
string  is_class, is_brand, is_chno, is_chno_gubn
 
end variables

on w_41002_d.create
call super::create
end on

on w_41002_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_date",string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_date",string(ld_datetime,"yyyymmdd"))
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
				else 	
					if gs_brand <> "K" then
						gst_cd.default_where   = " WHERE  tag_price <> 0 "
					else
						gst_cd.default_where   = " WHERE  tag_price <> 0 and style like 'K%' "
					end if 	
				end if


				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
					dw_head.SetItem(al_row, "year", lds_Source.GetItemString(1,"year"))
					dw_head.SetItem(al_row, "season", lds_Source.GetItemString(1,"season"))
//													
								
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("class")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_chno_gubn = "Y" then 
	is_chno = "%"
end if 	

il_rows = dw_list.retrieve(is_frm_date, is_to_date, is_brand, is_style, is_chno, &
                           is_year, is_season, is_class)


dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
	il_rows = dw_body.retrieve(is_brand, is_style, is_chno, is_frm_date, is_to_date, &
                           is_year, is_season)

//exec SP_41002_d01 'n' , 'nw1wj204' ,'0','20010810', '20010829' , '2001', 'w'
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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


is_frm_date = dw_head.GetItemString(1,"frm_date")
if IsNull(is_frm_date) or Trim(is_frm_date) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_date")
   return false
end if

is_to_date = dw_head.GetItemString(1,"to_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_date")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
   MessageBox(ls_title,"스타일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style")
   return false
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
   MessageBox(ls_title,"스타일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chno")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   is_year = "%"
   dw_head.SetFocus()
   dw_head.SetColumn("year")
  
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   is_season = "%"
   dw_head.SetFocus()
   dw_head.SetColumn("class")
 
end if

is_class = dw_head.GetItemString(1, "class")
if IsNull(is_class) or Trim(is_class) = "" then
   is_class = "%"
   
end if

is_chno_gubn = dw_head.GetItemString(1, "chno_gubn")
if IsNull(is_chno_gubn) or Trim(is_chno_gubn) = "" then
   MessageBox(ls_title,"차무무시여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chno_gubn")
 
end if

return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41002_d","0")
end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
		   cb_excel.enabled = true			
      else
         dw_head.SetFocus()
      end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if
END CHOOSE

end event

type cb_close from w_com020_d`cb_close within w_41002_d
end type

type cb_delete from w_com020_d`cb_delete within w_41002_d
end type

type cb_insert from w_com020_d`cb_insert within w_41002_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_41002_d
end type

type cb_update from w_com020_d`cb_update within w_41002_d
end type

type cb_print from w_com020_d`cb_print within w_41002_d
end type

type cb_preview from w_com020_d`cb_preview within w_41002_d
end type

type gb_button from w_com020_d`gb_button within w_41002_d
end type

type cb_excel from w_com020_d`cb_excel within w_41002_d
end type

type dw_head from w_com020_d`dw_head within w_41002_d
integer x = 9
integer y = 164
integer height = 204
string dataobject = "d_41002_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')


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



This.GetChild("class", idw_class )
idw_class.SetTransObject(SQLCA)
idw_class.Retrieve('922')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style" 
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
			
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_41002_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com020_d`ln_2 within w_41002_d
integer beginy = 388
integer endy = 388
end type

type dw_list from w_com020_d`dw_list within w_41002_d
integer x = 14
integer y = 408
integer width = 759
integer height = 1624
string dataobject = "d_41002_d02"
end type

event dw_list::doubleclicked;string ls_in_date

ls_in_date = dw_list.GetitemString(row, "yymmdd") 

dw_head.setitem(1, "frm_date", ls_in_date)
dw_head.setitem(1, "to_date", ls_in_date)

il_rows = dw_body.retrieve(is_brand, is_style, is_chno, ls_in_date, ls_in_date, &
                           is_year, is_season)
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

end event

type dw_body from w_com020_d`dw_body within w_41002_d
integer x = 800
integer y = 408
integer width = 2802
integer height = 1624
string dataobject = "d_41002_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;//string ls_style, ls_color
//choose case dwo.name
//	case "style"
//		ls_style = this.getitemstring(row, "style")
//		ls_color = this.getitemstring(row, "color")		
//		gf_style_color_pic(ls_style,"%",mid(ls_color,1,2))
//end choose

String 	ls_search,ls_style, ls_color, ls_chno
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			ls_chno = this.getitemstring(row, "chno")					
			ls_color = this.getitemstring(row, "color")								
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, ls_chno,ls_color)
	end choose	
end if

end event

type st_1 from w_com020_d`st_1 within w_41002_d
integer x = 782
integer y = 408
integer height = 1620
end type

type dw_print from w_com020_d`dw_print within w_41002_d
integer x = 1769
integer y = 1256
end type

