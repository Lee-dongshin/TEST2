$PBExportHeader$w_42023_d.srw
$PBExportComments$물류부자재 수불집계표
forward
global type w_42023_d from w_com010_d
end type
end forward

global type w_42023_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_42023_d w_42023_d

type variables
String is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_shop_div, is_opt_gubn
DataWindowChild idw_brand, idw_shop_div
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

on w_42023_d.create
call super::create
end on

on w_42023_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

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
            "t_shop_cd.Text   = '" + is_shop_cd   + "'" + &
            "t_shop_nm.Text   = '" + ls_shop_nm   + "'"

dw_print.Modify(ls_modify)

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_shop_div)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
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
//				dw_head.SetItem(al_row, "shop_div", ls_shop_div)
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우정보 (김진백)                                           */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
String ls_title

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
   MessageBox(ls_title,"브랜드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE 
END IF

is_yymmdd_st = Trim(String(dw_head.GetItemDate(1, "fr_ymd"),'yyyymmdd'))
IF IsNull(is_yymmdd_st) OR is_yymmdd_st = "" THEN
   MessageBox(ls_title,"시작 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE 
END IF

is_yymmdd_ed = Trim(String(dw_head.GetItemDate(1, "to_ymd"),'yyyymmdd'))
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

//IF DaysAfter(Date(String(is_yymmdd_st, '@@@@/@@/@@')), Date(String(is_yymmdd_ed, '@@@@/@@/@@'))) >= 180 then
//	MessageBox("오류","기간이 180일을 넘었습니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_ymd")
//	RETURN FALSE 
//END IF

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN is_shop_cd = '%'

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR Trim(is_shop_div) = "" THEN
   MessageBox(ls_title,"유통망을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

is_opt_gubn = Trim(dw_head.GetItemString(1, "opt_view"))
IF IsNull(is_opt_gubn) OR is_opt_gubn = "" THEN
   MessageBox(ls_title,"조회구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_view")
   RETURN FALSE 
END IF


RETURN TRUE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42023_d","0")
end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

if is_opt_gubn = "C" or is_opt_gubn = "D" or is_opt_gubn = "E" or is_opt_gubn = "F"  or is_opt_gubn = "G"  or is_opt_gubn = "H" then
	dw_print.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_shop_div)
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

event ue_preview();
This.Trigger Event ue_title ()

if is_opt_gubn = "C" or is_opt_gubn = "D" or is_opt_gubn = "E" or is_opt_gubn = "F"  or is_opt_gubn = "G"  or is_opt_gubn = "H" then
	dw_print.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_shop_div)
else
   dw_body.ShareData(dw_print)
end if	

dw_print.inv_printpreview.of_SetZoom()
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_42023_d
end type

type cb_delete from w_com010_d`cb_delete within w_42023_d
end type

type cb_insert from w_com010_d`cb_insert within w_42023_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42023_d
end type

type cb_update from w_com010_d`cb_update within w_42023_d
end type

type cb_print from w_com010_d`cb_print within w_42023_d
end type

type cb_preview from w_com010_d`cb_preview within w_42023_d
end type

type gb_button from w_com010_d`gb_button within w_42023_d
end type

type cb_excel from w_com010_d`cb_excel within w_42023_d
end type

type dw_head from w_com010_d`dw_head within w_42023_d
integer height = 300
string dataobject = "d_42023_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('919')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')
idw_shop_div.InsertRow(0)
idw_shop_div.SetItem(5, "inter_cd", '4')
idw_shop_div.SetItem(5, "inter_nm", '대리점')

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
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand" //, "shop_div"
		dw_head.SetItem(1, "shop_cd", "")
		dw_head.SetItem(1, "shop_nm", "")
	CASE "shop_cd"                     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)
	CASE "opt_view"                     //  Popup 검색창이 존재하는 항목 
		if data = "A" then
			dw_body.dataobject = "d_42023_d01" 
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_42023_r01" 
			dw_print.SetTransObject(SQLCA)			
		elseif data = "B" then
			dw_body.dataobject = "d_42023_d02" 
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_42023_r02" 
			dw_print.SetTransObject(SQLCA)						
		elseif data = "C" then
			dw_body.dataobject = "d_42023_d03" 
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_42023_r03" 
			dw_print.SetTransObject(SQLCA)		
		elseif data = "D" then
			dw_body.dataobject = "d_42023_d04" 
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_42023_r04" 
			dw_print.SetTransObject(SQLCA)			
		elseif data = "E" then
			dw_body.dataobject = "d_42023_d05" 
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_42023_r05" 
			dw_print.SetTransObject(SQLCA)			
		elseif data = "F" then
			dw_body.dataobject = "d_42023_d06" 
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_42023_r06" 
			dw_print.SetTransObject(SQLCA)						
		elseif data = "G" then
			dw_body.dataobject = "d_42023_d13" 
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_42023_r13" 
			dw_print.SetTransObject(SQLCA)						

		elseif data = "H" then
			dw_body.dataobject = "d_42023_d23" 
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_42023_r23" 
			dw_print.SetTransObject(SQLCA)						
			
			
			
		end if	
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_42023_d
integer beginy = 480
integer endy = 480
end type

type ln_2 from w_com010_d`ln_2 within w_42023_d
integer beginy = 484
integer endy = 484
end type

type dw_body from w_com010_d`dw_body within w_42023_d
integer y = 500
integer height = 1540
string dataobject = "d_42023_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_42023_d
string dataobject = "d_42023_r01"
end type

