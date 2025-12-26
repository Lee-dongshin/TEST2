$PBExportHeader$w_79002_t.srw
$PBExportComments$A/S 판정 등록
forward
global type w_79002_t from w_com020_e
end type
type dw_mast from u_dw within w_79002_t
end type
end forward

global type w_79002_t from w_com020_e
dw_mast dw_mast
end type
global w_79002_t w_79002_t

type variables
DataWindowChild idw_brand, idw_judg_fg, idw_judg_s
dragobject   idrg_ver[3]

String is_brand, is_fr_ymd, is_to_ymd, is_judg_fg, is_card_no, is_jumin, is_custom_nm
String is_yymmdd, is_seq_no, is_no

end variables

forward prototypes
public function integer wf_resizepanels ()
public function boolean wf_data_chk ()
end prototypes

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Ver[2].X + idrg_Ver[2].Width - st_1.X - ii_BarThickness

idrg_Ver[1].Resize (st_1.X - idrg_Ver[1].X, idrg_Ver[1].Height)

idrg_Ver[2].Move (st_1.X + ii_BarThickness, idrg_Ver[2].Y)
idrg_Ver[2].Resize (ll_Width, idrg_Ver[2].Height)
idrg_Ver[3].Move (st_1.X + ii_BarThickness, idrg_Ver[3].Y)
idrg_Ver[3].Resize (ll_Width, idrg_Ver[3].Height)

Return 1

end function

public function boolean wf_data_chk ();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
String ls_temp

/* dw_body 체크*/

// 판정 일자
ls_temp = Trim(dw_body.GetItemString(1, "judg_ymd"))
if IsNull(ls_temp) or ls_temp = "" then
	MessageBox("저장오류", "판정 일자를 입력하십시요!")
	dw_body.SetFocus()
	dw_body.SetColumn("judg_ymd")
	return false
end if

If dw_body.GetItemString(1, "judg_fg") <> '3' Then
	// 판정 대분류
	ls_temp = Trim(dw_body.GetItemString(1, "judg_l"))
	if IsNull(ls_temp) or ls_temp = "" then
		MessageBox("저장오류", "판정 대분류를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("judg_l")
		return false
	end if
	
	// 판정 소분류
	ls_temp = Trim(dw_body.GetItemString(1, "judg_s"))
	if IsNull(ls_temp) or ls_temp = "" then
		MessageBox("저장오류", "판정 소분류를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("judg_s")
		return false
	end if
	
	// 담당 부서
	ls_temp = Trim(dw_body.GetItemString(1, "dept_cd"))
	if IsNull(ls_temp) or ls_temp = "" then
		MessageBox("저장오류", "담당 부서를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("dept_cd")
		return false
	end if
	
	// 처리 구분
	ls_temp = Trim(dw_body.GetItemString(1, "deal_fg"))
	if IsNull(ls_temp) or ls_temp = "" then
		MessageBox("저장오류", "처리 구분을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("deal_fg")
		return false
	end if
End IF

return true

end function

on w_79002_t.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
end on

on w_79002_t.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast)
end on

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_no1, ls_tel_no2, ls_tel_no3
Integer    li_sex, li_return
Boolean    lb_check
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "card_no_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
//				   dw_head.SetItem(al_row, "jumin_h",     "")
//				   dw_head.SetItem(al_row, "custom_nm_h", "")
					RETURN 0
				END IF 
				IF gf_cust_card_chk(as_data, ls_jumin, ls_custom_nm) = TRUE THEN
				   dw_head.SetItem(al_row, "jumin_h",     ls_jumin    )
				   dw_head.SetItem(al_row, "custom_nm_h", ls_custom_nm)
					RETURN 0
				END IF 
			END IF
	CASE "jumin_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
//				   dw_head.SetItem(al_row, "card_no_h",   "")
//				   dw_head.SetItem(al_row, "custom_nm_h", "")
					RETURN 0
				END IF 
				IF gf_cust_jumin_chk(as_data, ls_custom_nm, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "card_no_h",   ls_card_no  )
				   dw_head.SetItem(al_row, "custom_nm_h", ls_custom_nm)
					RETURN 0
				ElseIf LenA(as_data) = 13 Then
					dw_head.SetItem(al_row, "card_no_h", "")
					RETURN 0
				END IF 
			END IF
	CASE "custom_nm_h"
			IF ai_div = 1 THEN 	
//				IF IsNull(as_data) or Trim(as_data) = "" THEN
//				   dw_head.SetItem(al_row, "card_no_h", "")
//				   dw_head.SetItem(al_row, "jumin_h",   "")
//					RETURN 0
//				END IF 
				IF gf_cust_name_chk(as_data, ls_custom_nm, ls_jumin, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "card_no_h", ls_card_no)
				   dw_head.SetItem(al_row, "jumin_h",   ls_jumin  )
					RETURN 0
				Else
					dw_head.SetItem(al_row, "card_no_h", "")
					RETURN 0
				END IF 
			END IF
	CASE "custom_h"
			If dw_head.AcceptText() <> 1 Then Return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			ls_card_no   = dw_head.GetItemString(al_row, "card_no_h"  )
			ls_jumin     = dw_head.GetItemString(al_row, "jumin_h"    )
			ls_custom_nm = dw_head.GetItemString(al_row, "custom_nm_h")
			IF IsNull(ls_card_no) = False and Trim(ls_card_no) <> "" THEN
				gst_cd.Item_where = " CARD_NO LIKE '" + Trim(ls_card_no) + "%' AND "
			ELSE
				gst_cd.Item_where = ""
			END IF
			IF IsNull(ls_jumin) = False and Trim(ls_jumin) <> "" THEN
				gst_cd.Item_where = gst_cd.Item_where + " JUMIN LIKE '" + Trim(ls_jumin) + "%' AND "
			END IF
			IF IsNull(ls_custom_nm) = False and Trim(ls_custom_nm) <> "" THEN
				gst_cd.Item_where = gst_cd.Item_where + " USER_NAME LIKE '" + Trim(ls_custom_nm) + "%' "
			ELSE
				gst_cd.Item_where = LeftA(gst_cd.Item_where, LenA(gst_cd.Item_where) - 4)
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
				dw_head.SetItem(al_row, "card_no_h",   lds_Source.GetItemString(1,"card_no")  )
				dw_head.SetItem(al_row, "jumin_h",     lds_Source.GetItemString(1,"jumin")    )
				dw_head.SetItem(al_row, "custom_nm_h", lds_Source.GetItemString(1,"user_name"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source

	CASE "han_mark_bmp"
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "취급주의사항 검색" 
			gst_cd.datawindow_nm   = "d_com702" 
			gst_cd.default_where   = ""
			gst_cd.Item_where      = dw_mast.GetItemString(al_row, "han_mark")
	
			lds_Source = Create DataStore
			OpenWithParm(W_COM701, lds_Source)
	
			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN
					dw_mast.SetRow(al_row)
					dw_mast.SetColumn(as_column)
				END IF
				dw_mast.SetItem(al_row, "han_mark", lds_Source.GetItemString(1,"han_mark"))
				/* 다음컬럼으로 이동 */
//				dw_detail.SetColumn("color")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
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

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
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
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_judg_fg = Trim(dw_head.GetItemString(1, "judg_fg"))
if IsNull(is_judg_fg) or is_judg_fg = "" then
   MessageBox(ls_title,"조회 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("judg_fg")
   return false
end if

is_card_no = Trim(dw_head.GetItemString(1, "card_no_h"))
if IsNull(is_card_no) or is_card_no = "" then
	is_card_no = '%'
end if

is_jumin = Trim(dw_head.GetItemString(1, "jumin_h"))
if IsNull(is_jumin) or is_jumin = "" then
	is_jumin = '%'
end if

is_custom_nm = Trim(dw_head.GetItemString(1, "custom_nm_h"))
if IsNull(is_custom_nm) or is_custom_nm = "" then
	is_custom_nm = '%'
end if

return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */ 
/* 작성일      : 2002.03.26                                                  */
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_judg_fg, &
									is_card_no, is_jumin, is_custom_nm)

dw_mast.Reset()
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

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_mast, "ScaleToRight")
dw_mast.SetTransObject(SQLCA)
idrg_Ver[1] = dw_list
idrg_Ver[2] = dw_body
idrg_Ver[3] = dw_mast

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_mast.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
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
				dw_list.Enabled = true
				dw_mast.Enabled = true
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
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_mast.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
Long ll_rows
datetime ld_datetime

IF dw_mast.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
	If wf_data_chk() = False Then Return -1
	dw_body.Setitem(1, "yymmdd", is_yymmdd )
	dw_body.Setitem(1, "seq_no", is_seq_no )
	dw_body.Setitem(1, "no"    , is_no     )
	dw_body.Setitem(1, "brand" , is_brand  )
	dw_body.Setitem(1, "reg_id", gs_user_id)
	dw_mast.SetItem(1, "judg_fg",  dw_body.GetItemString(1, "judg_fg") )
	dw_mast.SetItem(1, "judg_ymd", dw_body.GetItemString(1, "judg_ymd"))
ELSEIF idw_status = DataModified! THEN			/* Modify Record */
	If wf_data_chk() = False Then Return -1
	dw_body.Setitem(1, "mod_id", gs_user_id )
	dw_body.Setitem(1, "mod_dt", ld_datetime)
	dw_mast.SetItem(1, "judg_fg",  dw_body.GetItemString(1, "judg_fg") )
	dw_mast.SetItem(1, "judg_ymd", dw_body.GetItemString(1, "judg_ymd"))
END IF

idw_status = dw_mast.GetItemStatus(1, 0, Primary!)
IF idw_status = DataModified! THEN				/* Modify Record */
	dw_mast.Setitem(1, "mod_id", gs_user_id )
	dw_mast.Setitem(1, "mod_dt", ld_datetime)
END IF

ll_rows = dw_mast.Update(TRUE, FALSE)
il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 and ll_rows = 1 then
   dw_mast.ResetUpdate()
   dw_body.ResetUpdate()
   commit  USING SQLCA;
//	dw_list.Retrieve(is_brand, is_fr_ymd, is_to_ymd, is_fr_res_ymd, is_to_res_ymd, &
//						  is_card_no, is_jumin, is_custom_nm)
else
   rollback  USING SQLCA;
	If il_rows = 1 Then il_rows = ll_rows
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg   (3, il_rows)

return il_rows

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28																  */	
/* 수정일      : 2002.03.28																  */
/*===========================================================================*/
String ls_null
SetNull(ls_null)

idw_status = dw_body.GetItemStatus (1, 0, primary!)	
il_rows = dw_body.DeleteRow(1)

dw_mast.SetItem(1, "judg_fg ", '0')
dw_mast.SetItem(1, "judg_ymd", ls_null)
il_rows = dw_body.InsertRow(0)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.03                                                  */	
/* 수정일      : 2002.03.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.Retrieve(is_yymmdd, is_seq_no, is_no)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_print.Retrieve(is_yymmdd, is_seq_no, is_no)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com020_e`cb_close within w_79002_t
integer taborder = 120
end type

type cb_delete from w_com020_e`cb_delete within w_79002_t
integer taborder = 70
end type

type cb_insert from w_com020_e`cb_insert within w_79002_t
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_79002_t
end type

type cb_update from w_com020_e`cb_update within w_79002_t
integer taborder = 110
end type

type cb_print from w_com020_e`cb_print within w_79002_t
integer taborder = 80
end type

type cb_preview from w_com020_e`cb_preview within w_79002_t
integer taborder = 90
end type

type gb_button from w_com020_e`gb_button within w_79002_t
end type

type cb_excel from w_com020_e`cb_excel within w_79002_t
boolean visible = false
integer taborder = 100
end type

type dw_head from w_com020_e`dw_head within w_79002_t
integer height = 220
string dataobject = "d_79002_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "card_no_h", "jumin_h", "custom_nm_h"	//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("judg_fg", idw_judg_fg)
idw_judg_fg.SetTransObject(SQLCA)
idw_judg_fg.Retrieve('799')
idw_judg_fg.InsertRow(1)
idw_judg_fg.SetItem(1, "inter_cd", '%')
idw_judg_fg.SetItem(1, "inter_nm", '전체')

end event

event dw_head::ue_keydown;/*===========================================================================*/
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
		return 1
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
								
		Choose Case ls_column_name
			Case "card_no_h", "jumin_h", "custom_nm_h"
				ls_column_name = "custom_h"
		End Choose
		
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

RETURN 0

end event

type ln_1 from w_com020_e`ln_1 within w_79002_t
integer beginy = 420
integer endy = 420
end type

type ln_2 from w_com020_e`ln_2 within w_79002_t
integer beginy = 424
integer endy = 424
end type

type dw_list from w_com020_e`dw_list within w_79002_t
integer y = 440
integer width = 1061
integer height = 1600
string dataobject = "d_79002_d01"
boolean hscrollbar = true
end type

event dw_list::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
Long ll_rows
//datetime ld_datetime
String ls_judg_l

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

is_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_seq_no = This.GetItemString(row, 'seq_no') /* DataWindow에 Key 항목을 가져온다 */
is_no     = This.GetItemString(row, 'no'    ) /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) or IsNull(is_seq_no) or IsNull(is_no) THEN return

il_rows = dw_mast.retrieve(is_yymmdd, is_seq_no, is_no)
ll_rows = dw_body.retrieve(is_yymmdd, is_seq_no, is_no)

If ll_rows > 0 Then
	ls_judg_l = dw_body.GetItemString(il_rows, "judg_l")
	If IsNull(ls_judg_l) = False and Trim(ls_judg_l) <> "" Then
		idw_judg_s.Retrieve('796', ls_judg_l)
	End If
Else
//	IF gf_sysdate(ld_datetime) = FALSE THEN
//		ld_datetime = DateTime(Today(), Now())
//	END IF
	
	ll_rows = dw_body.InsertRow(0)
//	dw_body.SetItem(ll_rows, "judg_ymd", String(ld_datetime, 'yyyymmdd'))
End If

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg   (1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_79002_t
integer x = 1111
integer y = 1176
integer width = 2482
integer height = 864
integer taborder = 50
string dataobject = "d_79002_d03"
boolean vscrollbar = false
boolean livescroll = false
end type

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
		If ls_column_name <> 'result' and ls_column_name <> 'remark' Then
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
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

event dw_body::constructor;DataWindowChild ldw_child

This.GetChild("judg_l", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('795')

This.GetChild("judg_s", idw_judg_s)
idw_judg_s.SetTransObject(SQLCA)
idw_judg_s.InsertRow(0)

This.GetChild("dept_cd", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("pay_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('797')

This.GetChild("deal_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('798')


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_judg_l

CHOOSE CASE dwo.name
	CASE "judg_s"
		ls_judg_l = This.GetItemString(row, "judg_l")
		idw_judg_s.Retrieve('796', ls_judg_l)
END CHOOSE

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "judg_ymd", "cn_ymd", "st_ymd", "pr_ymd", "ed_ymd", "go_ymd"
		If gf_datechk(data) = False Then Return 1
	CASE "judg_l" 
		This.SetItem(1, "judg_s", "")
	CASE "dept_cd" 
		IF data = 'A000' THEN
			This.SetItem(1, "cust_cd", dw_mast.GetItemString(1, "mat_cust_cd"))
			This.SetItem(1, "cust_nm", dw_mast.GetItemString(1, "mat_cust_nm"))
			This.SetItem(1, "mat_cd" , dw_mast.GetItemString(1, "mat_cd")     )
			This.SetItem(1, "mat_nm" , dw_mast.GetItemString(1, "mat_nm")     )
		ElseIf data = 'D100' THEN
			This.SetItem(1, "cust_cd", dw_mast.GetItemString(1, "st_cust_cd"))
			This.SetItem(1, "cust_nm", dw_mast.GetItemString(1, "st_cust_nm"))
			This.SetItem(1, "mat_cd" , "")
			This.SetItem(1, "mat_nm" , "")
		Else
			This.SetItem(1, "cust_cd", "")
			This.SetItem(1, "cust_nm", "")
			This.SetItem(1, "mat_cd" , "")
			This.SetItem(1, "mat_nm" , "")
		END IF
		This.SetItem(1, "cust_emp", "")
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_79002_t
integer x = 1093
integer y = 440
integer height = 1600
end type

type dw_print from w_com020_e`dw_print within w_79002_t
string dataobject = "d_79002_r01"
end type

type dw_mast from u_dw within w_79002_t
event ue_keydown pbm_dwnkey
integer x = 1111
integer y = 440
integer width = 2482
integer height = 728
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_79002_d02"
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_keydown;/*===========================================================================*/
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
		If ls_column_name <> 'problem' Then
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
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

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

This.GetChild("rcv_how", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('791')

This.GetChild("wash_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('792')

This.GetChild("rcv_why", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('793')

This.GetChild("rcv_req", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('794')

end event

event dberror;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1

end event

event editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
String ls_no

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "sale_ymd"
		If gf_datechk(data) = False Then Return 1
END CHOOSE

end event

event itemerror;call super::itemerror;return 1

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg, ls_judg_l

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

