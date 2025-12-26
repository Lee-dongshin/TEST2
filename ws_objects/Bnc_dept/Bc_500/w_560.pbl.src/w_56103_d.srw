$PBExportHeader$w_56103_d.srw
$PBExportComments$수금 현황
forward
global type w_56103_d from w_com020_d
end type
type cbx_print from checkbox within w_56103_d
end type
end forward

global type w_56103_d from w_com020_d
integer width = 3694
integer height = 2280
cbx_print cbx_print
end type
global w_56103_d w_56103_d

type variables
DataWindowChild idw_brand, idw_comm_fg, idw_shop_div

String is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_shop_div, is_comm_fg
string is_shop_cd1, is_shop_nm

end variables

forward prototypes
public function integer wf_shop_chk (string as_shop_cd, string as_flag, ref string as_shop_nm, ref string as_shop_div)
end prototypes

public function integer wf_shop_chk (string as_shop_cd, string as_flag, ref string as_shop_nm, ref string as_shop_div);String ls_shop_nm, ls_shop_snm

SELECT SHOP_NM, SHOP_SNM, SHOP_DIV
  INTO :ls_shop_nm, :ls_shop_snm, :as_shop_div
  FROM TB_91100_M
 WHERE SHOP_CD = :as_shop_cd
;

IF ISNULL(as_shop_nm) THEN RETURN 100

If as_flag = 'S' Then
	as_shop_nm = ls_shop_snm
Else
	as_shop_nm = ls_shop_nm
End If

RETURN sqlca.sqlcode 

end function

on w_56103_d.create
int iCurrent
call super::create
this.cbx_print=create cbx_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_print
end on

on w_56103_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_print)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.02.07                                                  */
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_shop_div, is_comm_fg)

dw_body.Reset()

IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : 지우정보 (김진백)                                           */	
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
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
   MessageBox(ls_title,"브랜드 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF


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


is_yymmdd_st = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
IF IsNull(is_yymmdd_st) OR is_yymmdd_st = "" THEN
   MessageBox(ls_title,"시작 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_yymmdd_ed = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
IF IsNull(is_yymmdd_ed) OR is_yymmdd_ed = "" THEN
   MessageBox(ls_title,"마지막 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

IF is_yymmdd_st > is_yymmdd_ed THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF
	
is_comm_fg = Trim(dw_head.GetItemString(1, "comm_fg"))
IF IsNull(is_comm_fg) OR is_comm_fg = "" THEN
   MessageBox(ls_title,"수수료 구분를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("comm_fg")
   RETURN FALSE
END IF

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN is_shop_cd = '%'

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

RETURN TRUE

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		ls_brand    = Trim(dw_head.GetItemString(1, "brand"))
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) <> ls_brand THEN
				MessageBox("입력오류", "브랜드가 다릅니다!")
				dw_head.SetItem(al_row, "shop_cd", "")
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 1
			END IF
				
			IF wf_shop_chk(as_data, 'S', ls_shop_nm, ls_shop_div) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				dw_head.SetItem(al_row, "shop_div", ls_shop_div)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' AND SHOP_STAT = '00' "
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
			dw_head.SetItem(al_row, "shop_cd",  lds_Source.GetItemString(1,"shop_cd") )
			dw_head.SetItem(al_row, "shop_nm",  lds_Source.GetItemString(1,"shop_snm"))
			dw_head.SetItem(al_row, "shop_div", lds_Source.GetItemString(1,"shop_div"))
			/* 다음컬럼으로 이동 */
			cb_retrieve.SetFocus()
//			dw_head.SetColumn("shop_div")
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

event pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백) 												  */	
/* 작성일      : 2002.02.07																  */	
/* 수정일      : 2002.02.07																  */
/*===========================================================================*/

of_SetResize(TRUE)

THIS.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
THIS.TRIGGER EVENT ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

IF is_shop_cd = '%' THEN
	ls_shop_nm = '전체'
ELSE
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
END IF

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
            "t_datetime.Text  = '" + ls_datetime  + "'" + &
            "t_yymmdd_st.Text = '" + String(is_yymmdd_st, '@@@@/@@/@@') + "'" + &
            "t_yymmdd_ed.Text = '" + String(is_yymmdd_ed, '@@@@/@@/@@') + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(),       "inter_display") + "'" + &
            "t_shop_div.Text  = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'" + &
            "t_comm_fg.Text   = '" + idw_comm_fg.GetItemString(idw_comm_fg.GetRow(),   "inter_display") + "'" 

if cbx_print.checked = false then
	ls_modify = ls_modify + "t_shop_cd.Text   = '" + is_shop_cd   + "'" + &
		                  "t_shop_nm.Text   = '" + is_shop_nm   + "'"
else								
	ls_modify = ls_modify + "t_shop_cd.Text   = '" + is_shop_cd1   + "'" + &
		                  "t_shop_nm.Text   = '" + is_shop_nm   + "'"
end if								

dw_print.Modify(ls_modify)

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      IF al_rows > 0 THEN
         cb_retrieve.Text   = "조건(&Q)"
	      cb_print.Enabled   = TRUE
   	   cb_preview.Enabled = TRUE
         dw_head.Enabled    = FALSE
         dw_list.Enabled    = TRUE
         dw_body.Enabled    = TRUE
      ELSE
         dw_head.SetFocus()
      END IF

   CASE 5    /* 조건 */
      cb_retrieve.Text   = "조회(&Q)"
      cb_print.enabled   = FALSE
      cb_preview.enabled = FALSE
      cb_excel.enabled   = FALSE
      dw_list.Enabled    = FALSE
      dw_body.Enabled    = FALSE
      dw_head.Enabled    = TRUE
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      IF al_rows > 0 then
         cb_print.enabled   = TRUE
         cb_preview.Enabled = TRUE
         cb_excel.enabled   = TRUE
		ELSE
         cb_print.enabled   = FALSE
         cb_preview.enabled = FALSE
         cb_excel.enabled   = FALSE
      END IF
END CHOOSE

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/

if cbx_print.checked = false then
	dw_print.Dataobject = "d_56103_r01"
else								
	dw_print.Dataobject = "d_56103_r02"
end if		

dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title()

if cbx_print.checked = false then
	dw_list.ShareData(dw_print)
else								
	dw_body.ShareData(dw_print)
end if		


dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

if cbx_print.checked = false then
	dw_print.Dataobject = "d_56103_r01"
else								
	dw_print.Dataobject = "d_56103_r02"
end if		

dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title()

if cbx_print.checked = false then
	dw_list.ShareData(dw_print)
else								
	dw_body.ShareData(dw_print)
end if		



IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56103_d","0")
end event

type cb_close from w_com020_d`cb_close within w_56103_d
end type

type cb_delete from w_com020_d`cb_delete within w_56103_d
end type

type cb_insert from w_com020_d`cb_insert within w_56103_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_56103_d
end type

type cb_update from w_com020_d`cb_update within w_56103_d
end type

type cb_print from w_com020_d`cb_print within w_56103_d
end type

type cb_preview from w_com020_d`cb_preview within w_56103_d
end type

type gb_button from w_com020_d`gb_button within w_56103_d
end type

type cb_excel from w_com020_d`cb_excel within w_56103_d
end type

type dw_head from w_com020_d`dw_head within w_56103_d
integer y = 156
integer height = 228
string dataobject = "d_56103_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

THIS.GetChild("comm_fg", idw_comm_fg)
idw_comm_fg.SetTransObject(SQLCA)
idw_comm_fg.Retrieve('919')
idw_comm_fg.InsertRow(1)
idw_comm_fg.SetItem(1, "inter_cd", '%')
idw_comm_fg.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.02.07                                                  */
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "brand", "shop_div"
		dw_head.SetItem(1, "shop_cd", "")
		dw_head.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	      //  Popup 검색창이 존재하는 항목
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_56103_d
integer beginy = 392
integer endy = 392
end type

type ln_2 from w_com020_d`ln_2 within w_56103_d
integer beginy = 396
integer endy = 396
end type

type dw_list from w_com020_d`dw_list within w_56103_d
integer x = 14
integer y = 412
integer width = 3593
integer height = 836
string dataobject = "d_56103_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김진백)                                           */	
/* 작성일      : 2002.02.08                                                  */	
/* 수정일      : 2002.02.08                                                  */
/*===========================================================================*/
String ls_shop_cd

IF row <= 0 THEN RETURN

THIS.SelectRow(0,  FALSE)
THIS.SelectRow(row, TRUE)

is_shop_cd1 = THIS.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */
is_shop_nm = THIS.GetItemString(row, 'shop_nm') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_shop_cd1) THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd1, is_comm_fg)

PARENT.TRIGGER EVENT ue_button(7, il_rows)
PARENT.TRIGGER EVENT ue_msg(1, il_rows)

end event

type dw_body from w_com020_d`dw_body within w_56103_d
integer x = 14
integer y = 1256
integer width = 3593
integer height = 788
string dataobject = "d_56103_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from w_com020_d`st_1 within w_56103_d
boolean visible = false
end type

type dw_print from w_com020_d`dw_print within w_56103_d
integer x = 576
integer y = 200
string dataobject = "d_56103_r01"
end type

type cbx_print from checkbox within w_56103_d
integer x = 3099
integer y = 196
integer width = 494
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
string text = "상세내역출력"
borderstyle borderstyle = stylelowered!
end type

