$PBExportHeader$w_sh351_d.srw
$PBExportComments$실사비교조회
forward
global type w_sh351_d from w_com010_d
end type
type cb_excel from commandbutton within w_sh351_d
end type
end forward

global type w_sh351_d from w_com010_d
integer width = 2990
string title = "실사재고비교표"
cb_excel cb_excel
end type
global w_sh351_d w_sh351_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_shop_type
string is_brand, is_shop_cd, is_shop_type, is_style, is_chno
string is_year, is_season, is_silsa_yymmdd, is_base_yymmdd
string is_style_opt, is_wonga_enabled, is_opt_visible

end variables

on w_sh351_d.create
int iCurrent
call super::create
this.cb_excel=create cb_excel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_excel
end on

on w_sh351_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_excel)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
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






is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
is_year = "%"
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
is_season = "%"
end if

is_silsa_yymmdd = dw_head.GetItemString(1, "silsa_yymmdd")
if IsNull(is_silsa_yymmdd) or Trim(is_silsa_yymmdd) = "" then
   MessageBox(ls_title,"실사일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("silsa_yymmdd")
   return false
end if

is_base_yymmdd = dw_head.GetItemString(1, "base_yymmdd")
if IsNull(is_base_yymmdd) or Trim(is_base_yymmdd) = "" then
   MessageBox(ls_title,"재고 기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("base_yymmdd")
   return false
end if

is_style_opt = dw_head.GetItemString(1, "style_opt")
if IsNull(is_style_opt) or Trim(is_style_opt) = "" then
   MessageBox(ls_title,"조회 기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_opt")
   return false
end if

is_opt_visible = dw_head.GetItemString(1, "opt_visible")
if IsNull(is_opt_visible) or Trim(is_opt_visible) = "" then
   MessageBox(ls_title,"보기기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_visible")
   return false
end if


is_wonga_enabled = dw_head.GetItemString(1, "wonga_enabled")
if IsNull(is_wonga_enabled) or Trim(is_wonga_enabled) = "" then
   MessageBox(ls_title,"보기기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("wonga_enabled")
   return false
end if


return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;///*===========================================================================*/
///* 작성자      :                                       */	
///* 작성일      : 2001.12.17                                                  */	
///* 수정일      : 2001.12.17                                                  */
///*===========================================================================*/
//string     ls_part_cd, ls_part_nm, ls_shop_nm
//DataStore  lds_Source
//Boolean    lb_check 
//
//CHOOSE CASE as_column
//		CASE "shop_cd"				
//			IF ai_div = 1 THEN 	
//				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0
//				END IF 
//			END IF
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "매장 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com912" 
//			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' or shop_nm like  '%" + as_data + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				dw_head.SetRow(al_row)
//				dw_head.SetColumn(as_column)
//				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
//				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
//				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("cust_type")
//				ib_itemchanged = False 
//				lb_check = TRUE 
//			ELSE
//				lb_check = FALSE 
//			END IF
//			Destroy  lds_Source
//				
//			
//END CHOOSE
//
//IF ai_div = 1 THEN 
//	IF lb_check THEN
//      RETURN 2 
//	ELSE
//		RETURN 1
//	END IF
//END IF
//
//
RETURN 0
//
end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


if is_wonga_enabled = "S" then
	dw_body.DataObject = "d_sh351_d03"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_sh351_d03"
	dw_print.SetTransObject(SQLCA)	
	
	il_rows = dw_body.retrieve(is_base_yymmdd, is_silsa_yymmdd, gs_brand, gs_shop_cd, is_shop_type, is_year, is_season,  is_style_opt,is_opt_visible,'%')
	
else	
	dw_body.DataObject = "d_sh351_d01"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_sh351_d01"
	dw_print.SetTransObject(SQLCA)		
	
	il_rows = dw_body.retrieve(is_base_yymmdd, is_silsa_yymmdd, gs_brand, gs_shop_cd, is_shop_type, is_year, is_season,  is_style_opt,is_opt_visible)	
	
end if

//exec sp_43016_d01 '20011215' ,'20011215', 'n', 'ng0006', '1', '%' ,'%', 's'






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

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "shop_type", '1')
dw_head.SetItem(1, "base_yymmdd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "silsa_yymmdd",string(ld_datetime, "yyyymmdd"))

end event

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_yearseason
					  
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	   "t_pg_id.Text = '" + is_pgm_id + "'" + &
               "t_user_id.Text = '" + gs_shop_cd + "'" + &
               "t_datetime.Text = '" + ls_datetime + "'" + &
               "t_brand.Text = '" + gs_brand + "'" + &
					"t_year.Text = '" +  idw_year.GetItemString(idw_year.GetRow(), "inter_nm") + "'" + &					
					"t_season.Text = '" +  idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &										
					"t_silsa_yymmdd.Text = '" + String(is_silsa_yymmdd, '@@@@/@@/@@') + "'" + &										
					"t_yymmdd.Text = '" + String(is_base_yymmdd, '@@@@/@@/@@') + "'" + &															
					"t_shop_cd.Text = '" + gs_shop_cd + "'"  + &
					"t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" 					

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;//gf_user_connect_pgm(gs_user_id,"w_43016_d","0")
end event

event ue_button(integer ai_cb_div, long al_rows);
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

type cb_close from w_com010_d`cb_close within w_sh351_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh351_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh351_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh351_d
end type

type cb_update from w_com010_d`cb_update within w_sh351_d
end type

type cb_print from w_com010_d`cb_print within w_sh351_d
end type

type cb_preview from w_com010_d`cb_preview within w_sh351_d
end type

type gb_button from w_com010_d`gb_button within w_sh351_d
end type

type dw_head from w_com010_d`dw_head within w_sh351_d
integer y = 168
integer width = 2843
integer height = 292
string dataobject = "d_sh351_h01"
end type

event dw_head::constructor;call super::constructor;string ls_year
datetime ld_datetime

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

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



IF GS_BRAND  = 'J' THEN
This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.insertrow(1)
idw_shop_type.Setitem(1, "inter_cd", "%")
idw_shop_type.Setitem(1, "inter_nm", "전체")
	

ELSE 
This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')

END IF




// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', gs_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_sh351_d
integer beginx = 5
integer beginy = 476
integer endy = 476
end type

type ln_2 from w_com010_d`ln_2 within w_sh351_d
integer beginx = 5
integer beginy = 480
integer endy = 480
end type

type dw_body from w_com010_d`dw_body within w_sh351_d
integer y = 488
integer width = 2889
integer height = 1336
string dataobject = "d_sh351_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_sh351_d
integer x = 1394
integer y = 980
integer width = 1728
integer height = 744
string dataobject = "d_sh351_r01"
end type

type cb_excel from commandbutton within w_sh351_d
integer x = 32
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
boolean enabled = false
string text = "Excel"
end type

event clicked;string ls_doc_nm, ls_nm
integer li_ret, li_ret1
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
//li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)


   li_ret1 = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
	if li_ret1 = 1 then
		li_ret = dw_body.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
	else 	
		li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
	end if	


if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

