$PBExportHeader$w_21001_e.srw
$PBExportComments$자재코드등록
forward
global type w_21001_e from w_com010_e
end type
end forward

global type w_21001_e from w_com010_e
integer height = 2268
windowstate windowstate = maximized!
end type
global w_21001_e w_21001_e

type variables
string	is_brand, is_mat_year, is_mat_season, is_mat_item
end variables

on w_21001_e.create
call super::create
end on

on w_21001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_mat_cd

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("is_brand",is_brand)
//messagebox("is_mat_year",is_mat_year)
//messagebox("is_mat_season",is_mat_season)
//messagebox("is_mat_item",is_mat_item)
//messagebox("ls_mat_cd",ls_mat_cd)

il_rows = dw_body.retrieve(is_brand,is_mat_year,is_mat_season,is_mat_item,ls_mat_cd, 'D')
IF il_rows > 0 THEN
   dw_body.SetFocus()
elseif il_rows = 0 then
	dw_body.insertrow(0)	
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
//IF dw_head.Enabled THEN
////	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
//	dw_body.Reset()
//END IF
//
il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_mat_cd,ls_brand, ls_mat_year, ls_mat_season, ls_mat_item, ls_mat_chno, ls_mat_gubn

ll_row_count = dw_body.RowCount()
ls_mat_gubn = '2'


IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count


	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */	
		ls_mat_cd = dw_body.getitemstring(i,"mat_cd")	
		
		
		SELECT INTER_CD1
		INTO :ls_mat_year
		FROM tb_91011_c
		WHERE INTER_GRP = '002'
		 AND  INTER_CD =  SUBSTRING(:ls_mat_cd,3,1);

				MESSAGEBOX("", ls_mat_year)
		
		ls_brand      = LeftA(ls_mat_cd,1)
		ls_mat_season = MidA(ls_mat_cd,4,1)
		ls_mat_item   = MidA(ls_mat_cd,5,1)
		ls_mat_chno   = RightA(ls_mat_cd,1)
	
		dw_body.setitem(i,"brand",ls_brand)
		dw_body.setitem(i,"mat_year",ls_mat_year)
		dw_body.setitem(i,"mat_season",ls_mat_season)		
		dw_body.setitem(i,"mat_item",ls_mat_item)		
		dw_body.setitem(i,"mat_chno",ls_mat_chno)		
		dw_body.setitem(i,"mat_gubn",ls_mat_gubn)		
	
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ls_mat_cd = dw_body.getitemstring(i,"mat_cd")	
		
		
		SELECT INTER_CD1
		INTO :ls_mat_year
		FROM tb_91011_c
		WHERE INTER_GRP = '002'
		 AND  INTER_CD =  SUBSTRING(:ls_mat_cd,3,1);
		 
		MESSAGEBOX("", ls_mat_year)

		ls_brand      = LeftA(ls_mat_cd,1)
		ls_mat_season = MidA(ls_mat_cd,4,1)
		ls_mat_item   = MidA(ls_mat_cd,5,1)
		ls_mat_chno   = RightA(ls_mat_cd,1)

		dw_body.setitem(i,"brand",ls_brand)
		dw_body.setitem(i,"mat_year",ls_mat_year)
		dw_body.setitem(i,"mat_season",ls_mat_season)		
		dw_body.setitem(i,"mat_item",ls_mat_item)		
		dw_body.setitem(i,"mat_chno",ls_mat_chno)		
		dw_body.setitem(i,"mat_gubn",ls_mat_gubn)		
	
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
	

NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event ue_delete;call super::ue_delete;if dw_body.rowcount() = 0 then
	dw_body.insertrow(0)
end if
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
is_mat_year = dw_head.GetItemString(1, "mat_year")
is_mat_season = dw_head.GetItemString(1, "mat_season")
is_mat_item = dw_head.GetItemString(1, "mat_item")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if




if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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



if IsNull(is_mat_year) or Trim(is_mat_year) = "" then
   MessageBox(ls_title,"년도 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_year")
   return false
end if
if IsNull(is_mat_season) or Trim(is_mat_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_mat_season")
   return false
end if
//if IsNull(is_mat_item) or Trim(is_mat_item) = "" then
//   MessageBox(ls_title,"품종 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("is_mat_item")
//   return false
//end if
//return true

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_mat_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
				   dw_body.SetItem(al_row, "mat_nm", ls_mat_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com913" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_body.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("mat_nm")
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

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21001_e","0")
end event

type cb_close from w_com010_e`cb_close within w_21001_e
end type

type cb_delete from w_com010_e`cb_delete within w_21001_e
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_21001_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21001_e
end type

type cb_update from w_com010_e`cb_update within w_21001_e
integer taborder = 30
end type

type cb_print from w_com010_e`cb_print within w_21001_e
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_21001_e
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_21001_e
end type

type cb_excel from w_com010_e`cb_excel within w_21001_e
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_21001_e
integer x = 9
integer y = 168
integer width = 3589
integer height = 208
string dataobject = "d_21001_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
datawindowchild ldw_child

CHOOSE CASE dwo.name

	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"mat_nm","")
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	case "brand", "mat_year"
		//라빠레트 시즌적용
		dw_head.accepttext()
		
		is_brand = dw_head.getitemstring(1,'brand')
		is_mat_year = dw_head.getitemstring(1,'mat_year')
		
		this.getchild("mat_season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', is_brand, is_mat_year)

END CHOOSE

end event

event dw_head::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("mat_year",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('002')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_mat_year = dw_head.getitemstring(1,'mat_year')

this.getchild("mat_season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, is_mat_year)
//idw_season.retrieve('003')

this.getchild("mat_item",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('006')


end event

type ln_1 from w_com010_e`ln_1 within w_21001_e
integer beginy = 392
integer endy = 392
end type

type ln_2 from w_com010_e`ln_2 within w_21001_e
integer beginy = 396
integer endy = 396
end type

type dw_body from w_com010_e`dw_body within w_21001_e
integer x = 18
integer y = 416
integer height = 1636
string dataobject = "d_21001_d01"
boolean hscrollbar = true
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
	CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

this.getchild("mat_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('123')

this.getchild("hs_nm",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('034')
ldw_child.InsertRow(1)
//ldw_child.SetItem(1, "inter_cd", '%')
//ldw_child.SetItem(1, "inter_nm", '전체')
end event

type dw_print from w_com010_e`dw_print within w_21001_e
integer x = 32
integer y = 344
end type

