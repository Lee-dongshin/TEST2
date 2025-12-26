$PBExportHeader$w_33021_d.srw
$PBExportComments$입고종결현황
forward
global type w_33021_d from w_com010_d
end type
type cbx_cust from checkbox within w_33021_d
end type
end forward

global type w_33021_d from w_com010_d
cbx_cust cbx_cust
end type
global w_33021_d w_33021_d

type variables
string  is_brand, is_year, is_season, is_cust_cd, is_make_type,is_sojae, is_flag, is_check1 = 'N'
datawindowchild idw_brand, idw_season, idw_make_type, idw_sojae
end variables

on w_33021_d.create
int iCurrent
call super::create
this.cbx_cust=create cbx_cust
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_cust
end on

on w_33021_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_cust)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
   is_cust_cd = '%'
end if

is_make_type = dw_head.GetItemString(1, "make_type")
if IsNull(is_make_type) or Trim(is_make_type) = "" then
   MessageBox(ls_title,"생산형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("make_type")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_flag = dw_head.GetItemString(1, "flag")
if IsNull(is_flag) or Trim(is_flag) = "" then
   is_flag = 'N'
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_cust_cd, is_make_type,is_sojae, is_flag)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_preview;if cbx_cust.checked then 
	dw_print.dataobject = 'd_33020_r02'
else
	dw_print.dataobject = 'd_33020_r01'
end if
dw_print.SetTRansObject(SQLCA)


This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand,is_year,is_season,is_cust_cd, is_make_type,is_sojae, is_flag)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
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
					Case 'J','W','T'
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
				Case 'J','W','T'
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

event pfc_close;call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_33021_d","0")
end event

type cb_close from w_com010_d`cb_close within w_33021_d
end type

type cb_delete from w_com010_d`cb_delete within w_33021_d
end type

type cb_insert from w_com010_d`cb_insert within w_33021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_33021_d
end type

type cb_update from w_com010_d`cb_update within w_33021_d
end type

type cb_print from w_com010_d`cb_print within w_33021_d
end type

type cb_preview from w_com010_d`cb_preview within w_33021_d
end type

type gb_button from w_com010_d`gb_button within w_33021_d
end type

type cb_excel from w_com010_d`cb_excel within w_33021_d
end type

type dw_head from w_com010_d`dw_head within w_33021_d
string dataobject = "d_33020_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTRansObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.insertrow(1)
idw_make_type.setitem(1,"inter_cd","%")
idw_make_type.setitem(1,"inter_nm","전체")

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTRansObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"sojae","%")
idw_sojae.setitem(1,"sojae_nm","전체")

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

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

			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTRansObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.setitem(1,"sojae","%")
			idw_sojae.setitem(1,"sojae_nm","전체")

END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_33021_d
end type

type ln_2 from w_com010_d`ln_2 within w_33021_d
end type

type dw_body from w_com010_d`dw_body within w_33021_d
string dataobject = "d_33020_d01"
end type

type dw_print from w_com010_d`dw_print within w_33021_d
string dataobject = "d_33020_r01"
end type

type cbx_cust from checkbox within w_33021_d
integer x = 2597
integer y = 296
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "업체별출력"
borderstyle borderstyle = stylelowered!
end type

