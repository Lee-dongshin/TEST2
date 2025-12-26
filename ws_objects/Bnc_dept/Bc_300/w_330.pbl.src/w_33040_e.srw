$PBExportHeader$w_33040_e.srw
$PBExportComments$생산업체 평가등록
forward
global type w_33040_e from w_com020_e
end type
end forward

global type w_33040_e from w_com020_e
integer width = 3643
event type boolean uf_get_value_score ( string as_value_level,  string as_value_grade,  ref integer as_value_score )
end type
global w_33040_e w_33040_e

type variables
string is_brand, is_year, is_season, is_value_cd, is_cust_cd, is_cust_nm, is_sojae

datawindowchild idw_brand, idw_season, idw_grade, idw_sojae


end variables

event type boolean uf_get_value_score(string as_value_level, string as_value_grade, ref integer as_value_score);
select value_score 
	into :as_value_score
from tb_33041_c (nolock)
where value_level = :as_value_level 
and   value_grade = :as_value_grade; 

if isnull(as_value_score) then
	return false
else 
	return true
end if

end event

on w_33040_e.create
call super::create
end on

on w_33040_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_reg_id

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_value_cd, is_cust_cd, is_sojae)
dw_body.Reset()
IF il_rows > 0 THEN	
   dw_list.SetFocus()
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
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_value_cd = dw_head.GetItemString(1, "value_cd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_sojae = dw_head.GetItemString(1, "sojae")

return true

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;string ls_value_cd

select 
	case when dept_nm like '%자재%' then '1'
	     when dept_nm like '%소비%' then '2'
	     when dept_nm like '%생산%' then '3'
	     when dept_nm like '%기획%' then '4'
	     when dept_nm like '%니트%' then '4'
		  when dept_nm like '%악세%' then '34'  /* 생산.기획 모두 적용 */ 
	end
	into :ls_value_cd
from VI_91101_1 a(nolock), mis.dbo.thb01 b(nolock)
where b.goout_gubn = '1'
and   a.dept_cd = b.dept_code
and   a.DEPT_NM not like '%경영기획%'
and  (DEPT_NM like '%자재%'
or    DEPT_NM like '%소비%'
or    DEPT_NM like '%생산%'
or    DEPT_NM like '%기획%'
or    DEPT_NM like '%니트%'
or    DEPT_NM like '%악세%')
and   b.empno = :gs_user_id;


dw_head.setitem(1,"value_cd",ls_value_cd)


end event

type cb_close from w_com020_e`cb_close within w_33040_e
end type

type cb_delete from w_com020_e`cb_delete within w_33040_e
end type

type cb_insert from w_com020_e`cb_insert within w_33040_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_33040_e
end type

type cb_update from w_com020_e`cb_update within w_33040_e
end type

type cb_print from w_com020_e`cb_print within w_33040_e
end type

type cb_preview from w_com020_e`cb_preview within w_33040_e
end type

type gb_button from w_com020_e`gb_button within w_33040_e
end type

type cb_excel from w_com020_e`cb_excel within w_33040_e
end type

type dw_head from w_com020_e`dw_head within w_33040_e
integer height = 204
string dataobject = "d_33040_h01"
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

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTRansObject(SQLCA)
idw_sojae.Retrieve('%',is_brand)
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"sojae","%")
idw_sojae.setitem(1,"sojae_nm","전체")
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
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
			idw_sojae.Retrieve('%',is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.setitem(1,"sojae","%")
			idw_sojae.setitem(1,"sojae_nm","전체")
			
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_33040_e
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com020_e`ln_2 within w_33040_e
integer beginy = 392
integer endy = 392
end type

type dw_list from w_com020_e`dw_list within w_33040_e
integer y = 408
integer width = 974
integer height = 1636
string dataobject = "d_33040_l01"
end type

event dw_list::clicked;call super::clicked;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_cust_cd, ls_reg_id
long i

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_cust_cd = This.GetItemString(row, 'cust_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(ls_cust_cd) THEN return

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_value_cd, ls_cust_cd, is_sojae)
if il_rows > 0 then
	for i = 1 to dw_body.rowcount()
		ls_reg_id = dw_body.GetItemString(i,"reg_id")
		if isnull(ls_reg_id) then	
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)	
			
		end if
	next 	
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_33040_e
integer x = 1015
integer y = 408
integer width = 2578
integer height = 1636
string dataobject = "d_33040_d01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("value_grade_2", idw_grade)
idw_grade.SetTRansObject(SQLCA)
idw_grade.insertrow(0)

end event

event dw_body::buttonclicked;call super::buttonclicked;//long i, li_visible, il_row
//string ls_value_code
//
//if row < 0 then return 1
//
//choose case dwo.name
//	case "cb_grade"
//		il_row = dw_body.rowcount()
//		for i = 1 to il_row
//			this.Setitem(i,"visible", 0)
//		next 
//		
//		
//		li_visible = this.getitemdecimal(row,"visible")
//		if li_visible  = 1 then
//			this.Setitem(row,"visible", 0)
//		else
//			this.Setitem(row,"visible", 1)
//			ls_value_code = this.getitemstring(row,"value_code")	
//			idw_grade.retrieve(ls_value_code)
//			this.setcolumn("value_grade_2")
//		end if
//		
//		
//		
//end choose
//	
//
end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_value_level, ls_value_grade
int li_value_score

CHOOSE CASE dwo.name
	CASE "value_grade_2" 
		this.setitem(row,"grade_nm",idw_grade.getitemstring(idw_grade.getrow(),"value_name"))
		ls_value_grade = idw_grade.getitemstring(idw_grade.getrow(),"value_grade")
		ls_value_level = this.getitemstring(row,"value_level")
		
		this.setitem(row,"value_grade",ls_value_grade)
		if parent.trigger event uf_get_value_score(ls_value_level, ls_value_grade, li_value_score) then
			if li_value_score = 0 then setnull(li_value_score)
			this.setitem(row, "value_score", li_value_score)
		end if
		
END CHOOSE

end event

event dw_body::clicked;call super::clicked;long i, li_visible, il_row
string ls_value_code

if row < 0 then return 1

choose case dwo.name
	case "grade_nm"
		il_row = dw_body.rowcount()
		for i = 1 to il_row
			this.Setitem(i,"visible", 0)
		next 
		
		
		li_visible = this.getitemdecimal(row,"visible")
		if li_visible  = 1 then
			this.Setitem(row,"visible", 0)
		else
			this.Setitem(row,"visible", 1)
			ls_value_code = this.getitemstring(row,"value_code")	
			idw_grade.retrieve(ls_value_code)
			this.setcolumn("value_grade_2")

		end if
		
		
		
end choose
	
end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
//   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0
end event

event dw_body::dberror;//
end event

type st_1 from w_com020_e`st_1 within w_33040_e
integer x = 1001
integer y = 408
integer height = 1636
end type

type dw_print from w_com020_e`dw_print within w_33040_e
integer x = 14
integer y = 684
end type

