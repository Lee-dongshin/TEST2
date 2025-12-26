$PBExportHeader$w_42047_d.srw
$PBExportComments$송품장출력
forward
global type w_42047_d from w_com020_d
end type
type cb_print1 from commandbutton within w_42047_d
end type
type cbx_a4 from checkbox within w_42047_d
end type
end forward

global type w_42047_d from w_com020_d
integer width = 3675
integer height = 2264
event ue_print1 ( )
cb_print1 cb_print1
cbx_a4 cbx_a4
end type
global w_42047_d w_42047_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_jup_gubn, idw_out_type

String is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_house_cd, is_jup_gubn, is_out_type, is_gubun
String is_yymmdd, is_check_print, is_shop_type, is_out_no
long   il_rqst_chno, il_work_no

end variables

on w_42047_d.create
int iCurrent
call super::create
this.cb_print1=create cb_print1
this.cbx_a4=create cbx_a4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print1
this.Control[iCurrent+2]=this.cbx_a4
end on

on w_42047_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print1)
destroy(this.cbx_a4)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, is_house_cd, is_shop_cd, is_jup_gubn, is_out_type, is_gubun)
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
IF IsNull(is_brand) OR Trim(is_brand) = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

is_yymmdd_st = String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd')
IF IsNull(is_yymmdd_st) OR Trim(is_yymmdd_st) = "" THEN
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_yymmdd_ed = String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd')
IF IsNull(is_yymmdd_ed) OR Trim(is_yymmdd_ed) = "" THEN
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

IF is_yymmdd_ed < is_yymmdd_st THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

//is_shop_cd_st = dw_head.GetItemString(1, "shop_cd_st")
//IF IsNull(is_shop_cd_st) OR Trim(is_shop_cd_st) = "" THEN is_shop_cd_st = is_brand + '00000'
//
//is_shop_cd_ed = dw_head.GetItemString(1, "shop_cd_ed")
//IF IsNull(is_shop_cd_ed) OR Trim(is_shop_cd_ed) = "" THEN is_shop_cd_ed = is_brand + 'ZZZZZ'

is_shop_cd = dw_head.GetItemString(1, "shop_cd")



is_house_cd = dw_head.GetItemString(1, "house_cd")
IF IsNull(is_house_cd) OR Trim(is_house_cd) = "" THEN
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   RETURN FALSE
END IF

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
IF IsNull(is_jup_gubn) OR Trim(is_jup_gubn) = "" THEN
   MessageBox(ls_title,"전표 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   RETURN FALSE
END IF

is_out_type = dw_head.GetItemString(1, "out_type")
IF IsNull(is_out_type) OR Trim(is_out_type) = "" THEN
   MessageBox(ls_title,"출고 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_type")
   RETURN FALSE
END IF

is_gubun = "1" 

is_gubun = dw_head.GetItemString(1, "gubun")
IF IsNull(is_gubun) OR Trim(is_gubun) = "" THEN
   MessageBox(ls_title,"조회 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
   RETURN FALSE
END IF

RETURN TRUE

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_shop_div, ls_shop_Cd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))

		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
				
			IF gf_shop_nm3(as_data, 'S', ls_shop_nm)  = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com917" 
		gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "shop_cd LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))			
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY lds_Source

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42027_p","0")
end event

event ue_button(integer ai_cb_div, long al_rows);CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
			cb_print.enabled = true
			cb_preview.enabled = true
		  cb_excel.enabled = true			
      else
         dw_head.SetFocus()
      end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_print1.enabled = false		
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
         cb_print1.enabled = true			
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_print1.enabled = false			
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if
END CHOOSE

end event

type cb_close from w_com020_d`cb_close within w_42047_d
end type

type cb_delete from w_com020_d`cb_delete within w_42047_d
end type

type cb_insert from w_com020_d`cb_insert within w_42047_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_42047_d
end type

type cb_update from w_com020_d`cb_update within w_42047_d
end type

type cb_print from w_com020_d`cb_print within w_42047_d
end type

type cb_preview from w_com020_d`cb_preview within w_42047_d
integer width = 384
string text = "송장출력(&V)"
end type

type gb_button from w_com020_d`gb_button within w_42047_d
end type

type cb_excel from w_com020_d`cb_excel within w_42047_d
integer x = 2149
end type

type dw_head from w_com020_d`dw_head within w_42047_d
integer y = 144
integer height = 372
string dataobject = "d_42047_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

THIS.GetChild("jup_gubn", idw_jup_gubn)
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')
idw_jup_gubn.InsertRow(1)
idw_jup_gubn.SetItem(1, "inter_cd", '%')
idw_jup_gubn.SetItem(1, "inter_nm", '전체')

THIS.GetChild("out_type", idw_out_type)
idw_out_type.SetTransObject(SQLCA)
idw_out_type.Retrieve('420')
idw_out_type.InsertRow(1)
idw_out_type.SetItem(1, "inter_cd", '%')
idw_out_type.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if



end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		
	CASE "brand"
		IF LeftA(dw_head.GetItemString(1, "shop_cd_st"), 1) <> data THEN
			dw_head.SetItem(1, "shop_cd_st", "")
			dw_head.SetItem(1, "shop_nm_st", "")
		END IF
		If LeftA(dw_head.GetItemString(1, "shop_cd_ed"), 1) <> data THEN
			dw_head.SetItem(1, "shop_cd_ed", "")
			dw_head.SetItem(1, "shop_nm_ed", "")
		END IF
	CASE "gubun"
		IF data = '1' THEN
			dw_head.SetItem(1, "out_type", '%')
			dw_head.Object.out_type.Protect = 0
			dw_head.Object.out_type.BackGround.Color = RGB(255, 255, 255)
		ELSE
			dw_head.SetItem(1, "out_type", '%')
			dw_head.Object.out_type.Protect = 1
			dw_head.Object.out_type.BackGround.Color = RGB(192, 192, 192)
		END IF		
	CASE "fr_dps_num", "to_dps_num"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_42047_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com020_d`ln_2 within w_42047_d
integer beginy = 524
integer endy = 524
end type

type dw_list from w_com020_d`dw_list within w_42047_d
boolean visible = false
integer x = 14
integer y = 540
integer width = 55
integer height = 1500
end type

type dw_body from w_com020_d`dw_body within w_42047_d
integer x = 5
integer y = 528
integer width = 3593
integer height = 1504
string dataobject = "d_42047_d01"
end type

event dw_body::buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_check_print"
		If is_check_print = 'N' then
			is_check_print = 'Y'
			This.Object.cb_check_print.Text = '전체제외'
		Else
			is_check_print = 'N'
			This.Object.cb_check_print.Text = '전체선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "check_print", is_check_print)
		Next
END CHOOSE

end event

type st_1 from w_com020_d`st_1 within w_42047_d
integer x = 5
integer y = 532
integer height = 1500
end type

type dw_print from w_com020_d`dw_print within w_42047_d
integer x = 1143
integer y = 896
integer width = 2281
integer height = 440
string dataobject = "d_42047_d01"
end type

type cb_print1 from commandbutton within w_42047_d
boolean visible = false
integer x = 23
integer y = 44
integer width = 347
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "명세서A4"
end type

event clicked;Parent.Trigger Event ue_print1()
end event

type cbx_a4 from checkbox within w_42047_d
boolean visible = false
integer x = 384
integer y = 60
integer width = 603
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서A4(매장용)"
borderstyle borderstyle = stylelowered!
end type

