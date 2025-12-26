$PBExportHeader$w_42014_d.srw
$PBExportComments$품종/단가별 출고 현황 (출력)
forward
global type w_42014_d from w_com020_d
end type
end forward

global type w_42014_d from w_com020_d
end type
global w_42014_d w_42014_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_shop_type, idw_shop_div, idw_jup_gubn

String is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_house_cd, is_shop_type, is_shop_div, is_jup_gubn, is_gubun
String is_yymmdd, is_deal_ymd

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

on w_42014_d.create
call super::create
end on

on w_42014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.03.18                                                  */
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_house_cd, &
									is_shop_type, is_shop_div, is_jup_gubn, is_gubun, is_deal_ymd)
dw_body.Reset()

IF il_rows > 0 THEN
   dw_list.SetFocus()
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
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
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_yymmdd_ed = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
IF IsNull(is_yymmdd_ed) OR is_yymmdd_ed = "" THEN
   MessageBox(ls_title,"일자를 입력하십시요!")
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

is_house_cd = Trim(dw_head.GetItemString(1, "house_cd"))
IF IsNull(is_house_cd) OR is_house_cd = "" THEN
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   RETURN FALSE
END IF

is_jup_gubn = Trim(dw_head.GetItemString(1, "jup_gubn"))
IF IsNull(is_jup_gubn) OR is_jup_gubn = "" THEN
   MessageBox(ls_title,"전표 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   RETURN FALSE
END IF

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN is_shop_cd = '%'

is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
IF IsNull(is_shop_type) OR is_shop_type = "" THEN
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   RETURN FALSE
END IF

is_shop_div= Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

is_gubun = dw_head.GetItemString(1, "gubun")
IF IsNull(is_gubun) OR is_gubun = "" THEN
   MessageBox(ls_title,"조회 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
   RETURN FALSE
END IF

is_deal_ymd = dw_head.GetItemString(1, "deal_ymd")
IF IsNull(is_deal_ymd) OR is_gubun = "" THEN
  is_deal_ymd = "%"
END IF

RETURN TRUE

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_shop_div
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
			IF LeftA(as_data, 1) = is_brand and wf_shop_chk(as_data, 'S', ls_shop_nm, ls_shop_div) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				dw_head.SetItem(al_row, "shop_div", ls_shop_div)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
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
			dw_head.SetColumn("shop_type")
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

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.03.19                                                  */	
/* 수정일      : 2002.03.19                                                  */
/*===========================================================================*/
DateTime ld_datetime
Long ll_row_count, i, ll_rows
String ls_modify, ls_datetime, ls_title, ls_shop_nm, ls_print_gubn

This.Trigger Event ue_title()

ll_row_count = dw_list.RowCount()
ls_print_gubn = dw_head.getitemstring(1, "print_gubn")

if ls_print_gubn = "I" then
	dw_print.dataobject = "d_42014_r01"
else	
	dw_print.dataobject = "d_42014_r02"
end if	

dw_print.SetTransObject(SQLCA)

FOR i = 1 TO ll_row_count
	ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
	is_yymmdd    = dw_list.GetItemString(i, 'yymmdd')
	is_shop_cd   = dw_list.GetItemString(i, 'shop_cd')
	ls_shop_nm   = dw_list.GetItemString(i, 'shop_nm')

	ls_modify =	"t_yymmdd.Text    = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
					"t_shop_cd.Text   = '" + is_shop_cd   + "'" + &
					"t_shop_nm.Text   = '" + ls_shop_nm   + "'"
	
	dw_print.Modify(ls_modify)

	IF dw_list.GetItemString(i, 'check_print') = 'Y' THEN
		ll_rows = dw_print.retrieve(is_brand, is_yymmdd, is_shop_cd, is_house_cd, is_shop_type, is_shop_div, is_jup_gubn, is_gubun, is_deal_ymd)
		If ll_rows > 0 Then il_rows = dw_print.Print()
	END IF
NEXT

THIS.TRIGGER EVENT ue_msg(6, il_rows)

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.03.19                                                  */	
/* 수정일      : 2002.03.19                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_gubun = '1' then
	ls_title = '품종/단가별 출고 현황표'
else
	ls_title = '품종/단가별 반품 현황표'
end if

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_title.Text     = '" + ls_title    + "'" + &
				"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
				"t_user_id.Text   = '" + gs_user_id   + "'" + &
				"t_datetime.Text  = '" + ls_datetime  + "'" + &
				"t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42014_d","0")
end event

event open;call super::open;string ls_yymmdd

select convert(char(08), getdate(),112)
into :ls_yymmdd
from dual;

dw_head.setitem(1,  "deal_ymd", ls_yymmdd)
dw_head.setitem(1,  "jup_gubn", "O1")


end event

type cb_close from w_com020_d`cb_close within w_42014_d
end type

type cb_delete from w_com020_d`cb_delete within w_42014_d
end type

type cb_insert from w_com020_d`cb_insert within w_42014_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_42014_d
end type

type cb_update from w_com020_d`cb_update within w_42014_d
end type

type cb_print from w_com020_d`cb_print within w_42014_d
end type

type cb_preview from w_com020_d`cb_preview within w_42014_d
boolean visible = false
end type

type gb_button from w_com020_d`gb_button within w_42014_d
end type

type cb_excel from w_com020_d`cb_excel within w_42014_d
end type

type dw_head from w_com020_d`dw_head within w_42014_d
integer x = 23
integer y = 156
integer height = 304
string dataobject = "d_42014_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.03.13                                                  */
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "brand", "shop_div"
		dw_head.SetItem(1, "shop_cd", "")
		dw_head.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	      //  Popup 검색창이 존재하는 항목
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)
	CASE "print_gubn"	      //  Popup 검색창이 존재하는 항목
		IF ib_itemchanged THEN RETURN 1
		if data = "I" then 
			dw_body.dataobject = "d_42014_d02"
		else	
			dw_body.dataobject = "d_42014_d03"
		end if	
		dw_body.SetTransObject(SQLCA)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

THIS.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

THIS.GetChild("jup_gubn", idw_jup_gubn)
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')
idw_jup_gubn.InsertRow(1)
idw_jup_gubn.SetItem(1, "inter_cd", '%')
idw_jup_gubn.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

type ln_1 from w_com020_d`ln_1 within w_42014_d
integer beginy = 472
integer endy = 472
end type

type ln_2 from w_com020_d`ln_2 within w_42014_d
integer beginy = 476
integer endy = 476
end type

type dw_list from w_com020_d`dw_list within w_42014_d
integer x = 9
integer y = 484
integer width = 1390
integer height = 1556
string dataobject = "d_42014_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string  ls_print_gubn

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_yymmdd  = This.GetItemString(row, 'yymmdd')  /* DataWindow에 Key 항목을 가져온다 */
is_shop_cd = This.GetItemString(row, 'shop_cd')
is_shop_type = This.GetItemString(row, 'shop_type')
ls_print_gubn = dw_head.getitemstring(1, "print_gubn")

IF IsNull(is_yymmdd) or IsNull(is_shop_cd) or IsNull(is_shop_type) THEN RETURN

if ls_print_gubn = "I" then
	dw_body.dataobject = "d_42014_d02"
else
	dw_body.dataobject = "d_42014_d03"
end if	

dw_body.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_house_cd, is_shop_type, is_shop_div, is_jup_gubn, is_gubun, is_deal_ymd)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

end event

type dw_body from w_com020_d`dw_body within w_42014_d
integer x = 1422
integer y = 484
integer width = 2181
integer height = 1556
string dataobject = "d_42014_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from w_com020_d`st_1 within w_42014_d
integer x = 1403
integer y = 484
integer height = 1564
end type

type dw_print from w_com020_d`dw_print within w_42014_d
integer x = 2345
integer y = 1108
string dataobject = "d_42014_r02"
end type

