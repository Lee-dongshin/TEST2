$PBExportHeader$w_55011_d.srw
$PBExportComments$매장형태별 판매집계
forward
global type w_55011_d from w_com010_d
end type
type st_1 from statictext within w_55011_d
end type
end forward

global type w_55011_d from w_com010_d
integer width = 3671
integer height = 2280
st_1 st_1
end type
global w_55011_d w_55011_d

type variables
DataWindowChild idw_brand, idw_shop_div, idw_comm_fg

String is_yyyy, is_brand, is_shop_div, is_comm_fg, is_shop_cd_st, is_shop_cd_ed

end variables

on w_55011_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_55011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yyyy, is_comm_fg, is_shop_cd_st, is_shop_cd_ed, is_shop_div)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF


//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	




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





is_yyyy = Trim(String(dw_head.GetItemDateTime(1, "yyyy"), 'yyyy'))
IF IsNull(is_yyyy) OR is_yyyy = "" THEN
   MessageBox(ls_title,"기준 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   RETURN FALSE
END IF

is_comm_fg = Trim(dw_head.GetItemString(1, "comm_fg"))
IF IsNull(is_comm_fg) OR is_comm_fg = "" THEN
   MessageBox(ls_title,"수수료 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("comm_fg")
   RETURN FALSE
END IF

is_shop_cd_st = Trim(dw_head.GetItemString(1, "shop_cd_st"))
IF IsNull(is_shop_cd_st) OR is_shop_cd_st = "" THEN is_shop_cd_st = is_brand + '00000'

is_shop_cd_ed = Trim(dw_head.GetItemString(1, "shop_cd_ed"))
IF IsNull(is_shop_cd_ed) OR is_shop_cd_ed = "" THEN is_shop_cd_ed = is_brand + 'ZZZZZ'

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

RETURN TRUE

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd_st"
		ls_brand = Trim(dw_head.GetItemString(1, "brand"))
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm_st", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) <> ls_brand THEN
				MessageBox("입력오류", "브랜드가 다릅니다!")
				dw_head.SetItem(al_row, "shop_cd_st", "")
				dw_head.SetItem(al_row, "shop_nm_st", "")
				RETURN 1
			END IF
				
			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm_st", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
			dw_head.SetItem(al_row, "shop_cd_st", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm_st", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("shop_cd_ed")
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY lds_Source
	CASE "shop_cd_ed"
		ls_brand = Trim(dw_head.GetItemString(1, "brand"))
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm_ed", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) <> ls_brand THEN
				MessageBox("입력오류", "브랜드가 다릅니다!")
				dw_head.SetItem(al_row, "shop_cd_ed", "")
				dw_head.SetItem(al_row, "shop_nm_ed", "")
				Return 1
			END IF
			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm_ed", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
			dw_head.SetItem(al_row, "shop_cd_ed", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm_ed", lds_Source.GetItemString(1,"shop_snm"))
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55011_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55011_d
end type

type cb_delete from w_com010_d`cb_delete within w_55011_d
end type

type cb_insert from w_com010_d`cb_insert within w_55011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55011_d
end type

type cb_update from w_com010_d`cb_update within w_55011_d
end type

type cb_print from w_com010_d`cb_print within w_55011_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_55011_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_55011_d
end type

type cb_excel from w_com010_d`cb_excel within w_55011_d
end type

type dw_head from w_com010_d`dw_head within w_55011_d
integer height = 220
string dataobject = "d_55011_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("comm_fg", idw_comm_fg)
idw_comm_fg.SetTransObject(SQLCA)
idw_comm_fg.Retrieve('919')
idw_comm_fg.InsertRow(1)
idw_comm_fg.SetItem(1, "inter_cd", '%')
idw_comm_fg.SetItem(1, "inter_nm", '전체')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		dw_head.SetItem(1, "shop_cd_st", "")
		dw_head.SetItem(1, "shop_nm_st", "")
		dw_head.SetItem(1, "shop_cd_ed", "")
		dw_head.SetItem(1, "shop_nm_ed", "")
	CASE "shop_cd_st", "shop_cd_ed"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_55011_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_55011_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_55011_d
integer y = 444
integer height = 1596
string dataobject = "d_55011_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55011_d
integer x = 411
integer y = 256
end type

type st_1 from statictext within w_55011_d
integer x = 27
integer y = 64
integer width = 480
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "(금액단위 : 천원)"
boolean focusrectangle = false
end type

