$PBExportHeader$w_32005_d.srw
$PBExportComments$업체별 미입고 현황
forward
global type w_32005_d from w_com010_d
end type
end forward

global type w_32005_d from w_com010_d
end type
global w_32005_d w_32005_d

type variables
DataWindowChild idw_brand, idw_season, idw_make_type, idw_out_seq

String is_brand, is_year, is_season, is_cust_cd, is_make_type, is_out_seq
String is_ch_fg
end variables

on w_32005_d.create
call super::create
end on

on w_32005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_cust_cd, is_make_type, is_out_seq, is_ch_fg)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
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
is_ch_fg = dw_head.GetItemString(1, "ch_fg")

is_cust_cd = Trim(dw_head.GetItemString(1, "cust_cd"))
if IsNull(is_cust_cd) or is_cust_cd = "" then
	is_cust_cd = '%'
end if

is_make_type = Trim(dw_head.GetItemString(1, "make_type"))
if IsNull(is_make_type) or is_make_type = "" then
   MessageBox(ls_title,"생산 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("make_type")
   return false
end if

is_out_seq = Trim(dw_head.GetItemString(1, "out_seq"))
if IsNull(is_out_seq) or is_out_seq = "" then
   MessageBox(ls_title,"출고 차순을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_seq")
   return false
end if

return true
end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.07                                                  */	
/* 수정일      : 2001.12.07                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 생산처 코드
	   is_brand = Trim(dw_head.GetItemString(1, "brand"))
			
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				End If
				
				Choose Case is_brand
					Case 'J'
						IF (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case 'Y'
						IF (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case Else
						IF LeftA(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
				End Choose
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911" 
			Choose Case is_brand
				Case 'J'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case 'Y'
					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case Else
					gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
			End Choose
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("make_type")
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

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_cust_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_cust_nm = dw_head.GetItemString(1, "cust_nm")
If IsNull(ls_cust_nm) or Trim(ls_cust_nm) = "" Then ls_cust_nm = " "

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
             "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
             "t_cust_cd.Text = '" + is_cust_cd + "'" + &
             "t_cust_nm.Text = '" + ls_cust_nm + "'" + &
             "t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'" + &
             "t_out_seq.Text = '" + idw_out_seq.GetItemString(idw_out_seq.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32005_d","0")
end event

type cb_close from w_com010_d`cb_close within w_32005_d
end type

type cb_delete from w_com010_d`cb_delete within w_32005_d
end type

type cb_insert from w_com010_d`cb_insert within w_32005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_32005_d
end type

type cb_update from w_com010_d`cb_update within w_32005_d
end type

type cb_print from w_com010_d`cb_print within w_32005_d
end type

type cb_preview from w_com010_d`cb_preview within w_32005_d
end type

type gb_button from w_com010_d`gb_button within w_32005_d
end type

type cb_excel from w_com010_d`cb_excel within w_32005_d
end type

type dw_head from w_com010_d`dw_head within w_32005_d
integer height = 220
string dataobject = "d_32005_h01"
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


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('010')
idw_out_seq.InsertRow(1)
idw_out_seq.SetItem(1, "inter_cd", '%')
idw_out_seq.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "cust_cd", "")
		This.SetItem(row, "cust_nm", "")
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
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

type ln_1 from w_com010_d`ln_1 within w_32005_d
integer beginy = 420
integer endy = 420
end type

type ln_2 from w_com010_d`ln_2 within w_32005_d
integer beginy = 424
integer endy = 424
end type

type dw_body from w_com010_d`dw_body within w_32005_d
integer y = 440
integer height = 1600
string dataobject = "d_32005_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_32005_d
string dataobject = "d_32005_r01"
end type

