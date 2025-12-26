$PBExportHeader$w_54026_d.srw
$PBExportComments$주간리포트조회
forward
global type w_54026_d from w_com010_d
end type
end forward

global type w_54026_d from w_com010_d
integer width = 3689
integer height = 2252
end type
global w_54026_d w_54026_d

type variables
DataWindowChild idw_cnts_gubn, idw_brand, idw_empno
String is_cnts_gubn, is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_empno, is_rpt_opt
String is_style, is_chno
end variables

on w_54026_d.create
call super::create
end on

on w_54026_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_cnts_gubn = dw_head.GetItemString(1, "cnts_gubn")
if IsNull(is_cnts_gubn) or Trim(is_cnts_gubn) = "" then
   MessageBox(ls_title,"조회방법을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cnts_gubn")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_Cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if


is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
   MessageBox(ls_title,"담당사번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if

is_rpt_opt = dw_head.GetItemString(1, "rpt_opt")
if IsNull(is_rpt_opt) or Trim(is_rpt_opt) = "" then
   MessageBox(ls_title,"출력양식을 선택하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rpt_opt")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	 is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	 is_style = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_rpt_opt = "A" then
	dw_body.DataObject = "d_54026_d02"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_54026_r02"
	dw_print.SetTransObject(SQLCA)	
elseif is_rpt_opt = "B" then	
	dw_body.DataObject = "d_54026_d04"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_54026_r04"
	dw_print.SetTransObject(SQLCA)	
elseif is_rpt_opt = "C" then		
	dw_body.DataObject = "d_54026_d01"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_54026_r01"
	dw_print.SetTransObject(SQLCA)	
else	
	dw_body.DataObject = "d_54026_d05"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_54026_r05"
	dw_print.SetTransObject(SQLCA)		
end if	

if is_rpt_opt = "A" then
	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_cnts_gubn, is_empno)
elseif is_rpt_opt = "B" then	
	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_empno, is_style, is_chno)
else	
	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_cnts_gubn, is_empno)
end if	


IF il_rows > 0 THEN
	dw_body.Modify("contents.Height.AutoSize=Yes")
   dw_body.Modify("DataWindow.Detail.Height.AutoSize=Yes")
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String     ls_style2
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K') " + &
											 "  AND BRAND = '" + ls_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			

		CASE "style"							
			
				ls_brand = dw_head.getitemstring(1, "brand")
			
			   // 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + ls_brand + "%' and chno in ( '0','S') "	
				else 	
					gst_cd.default_where   = " WHERE  tag_price <> 0 "
				end if
				
				if gs_brand <> "K" then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
					ELSE
						gst_cd.Item_where = ""
					END IF
				else
					gst_cd.Item_where = ""
				end if
				
				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
								
  
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
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

event ue_title();call super::ue_title;

datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_shop_nm = dw_head.getitemstring(1, "shop_nm")
if IsNull(ls_shop_nm) or Trim(ls_shop_nm) = "" then
	ls_shop_nm = "전체"
end if



ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
					"t_to_ymd.Text = '" + is_to_ymd + "'" + &					
					"t_emp_nm.Text = '" + idw_empno.GetItemString(idw_empno.GetRow(), "person_nm") + "'" + &
					"t_shop_cd.Text = '" + is_shop_cd + "'" + &
					"t_shop_nm.Text = '" + ls_shop_nm + "'" 


dw_print.Modify(ls_modify)

dw_print.Modify("contents.Height.AutoSize=Yes")
dw_print.Modify("DataWindow.Detail.Height.AutoSize=Yes")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54026_d","0")
end event

event ue_preview();call super::ue_preview;	dw_print.Modify("contents.Height.AutoSize=Yes")
   dw_print.Modify("DataWindow.Detail.Height.AutoSize=Yes")
end event

event ue_print();call super::ue_print;	dw_print.Modify("contents.Height.AutoSize=Yes")
   dw_print.Modify("DataWindow.Detail.Height.AutoSize=Yes")
end event

type cb_close from w_com010_d`cb_close within w_54026_d
end type

type cb_delete from w_com010_d`cb_delete within w_54026_d
end type

type cb_insert from w_com010_d`cb_insert within w_54026_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_54026_d
end type

type cb_update from w_com010_d`cb_update within w_54026_d
end type

type cb_print from w_com010_d`cb_print within w_54026_d
end type

type cb_preview from w_com010_d`cb_preview within w_54026_d
end type

type gb_button from w_com010_d`gb_button within w_54026_d
end type

type cb_excel from w_com010_d`cb_excel within w_54026_d
end type

type dw_head from w_com010_d`dw_head within w_54026_d
integer y = 156
integer width = 3589
integer height = 280
string title = "d_54026_d01"
string dataobject = "d_54026_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(1)
idw_empno.SetItem(1, "person_id", '%')
idw_empno.SetItem(1, "person_nm", '전체')


This.GetChild("cnts_gubn", idw_cnts_gubn)
idw_cnts_gubn.SetTransObject(SQLCA)
idw_cnts_gubn.Retrieve('542')
idw_cnts_gubn.InsertRow(1)
idw_cnts_gubn.SetItem(1, "inter_cd", '%')
idw_cnts_gubn.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_work_type, ls_person_id
CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
//		idw_empno.InsertRow(0)
		idw_empno.InsertRow(1)
		idw_empno.SetItem(1, "person_id", '%')
		idw_empno.SetItem(1, "person_nm", '전체')
		
  CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
 CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
 CASE "rpt_opt"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		
		if data = "B" then
			dw_head.object.style.visible = true
			dw_head.object.chno.visible = true
			dw_head.object.cb_style.visible = true			
			dw_head.object.t_2.visible = true						
		else	
			dw_head.object.style.visible = false
			dw_head.object.chno.visible = false
			dw_head.object.cb_style.visible = false			
			dw_head.object.t_2.visible = false
		end if	
			
END CHOOSE



end event

type ln_1 from w_com010_d`ln_1 within w_54026_d
end type

type ln_2 from w_com010_d`ln_2 within w_54026_d
end type

type dw_body from w_com010_d`dw_body within w_54026_d
integer width = 3607
integer height = 1548
string dataobject = "d_54026_d02"
end type

type dw_print from w_com010_d`dw_print within w_54026_d
string dataobject = "d_54026_r02"
end type

