$PBExportHeader$w_21014_d.srw
$PBExportComments$시험분석조회
forward
global type w_21014_d from w_com020_e
end type
type dw_1 from datawindow within w_21014_d
end type
type dw_3 from datawindow within w_21014_d
end type
end forward

global type w_21014_d from w_com020_e
integer width = 3643
integer height = 2300
string title = "시험분석등록"
windowstate windowstate = maximized!
dw_1 dw_1
dw_3 dw_3
end type
global w_21014_d w_21014_d

type variables
string is_brand, is_mat_cd, is_color, is_special_case, is_style, is_gubn = '1', is_test_corp
datawindowchild idw_brand, idw_make_item, idw_country_cd

end variables

on w_21014_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
end on

on w_21014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
end on

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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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
	is_gubn = dw_head.GetItemString(1, "gubn")

is_style = dw_head.GetItemString(1, "style")

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_special_case = dw_head.GetItemString(1, "special_case")


is_test_corp = dw_head.GetItemString(1, "test_corp")

return true


end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_test_corp = "K" then
	if is_gubn = "1" then
		dw_body.DataObject  = 'd_kola_d02_NEW'
	else 	
		dw_body.DataObject  = 'd_fiti_d02_NEW'
	end if	
	
	dw_body.SetTransObject(SQLCA)
else

	
	if is_gubn = "1" then
		dw_body.DataObject  = 'd_kola_d02'
	else 	
		dw_body.DataObject  = 'd_fiti_d02'
	end if	

	dw_body.SetTransObject(SQLCA)
end if	
	
string ls_null
setnull(ls_null)

dw_body.GetChild("mat_nm1_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


dw_body.GetChild("mat_nm2_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm3_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm4_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm5_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm6_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm7_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm8_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
dw_body.GetChild("mat_nm1_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm2_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm3_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm4_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm5_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm6_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm7_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm8_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
dw_body.GetChild("mat_nm1_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm2_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm3_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm4_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm5_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm6_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm7_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm8_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


///////////////
dw_body.GetChild("mat_nm1_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm2_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm3_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


dw_body.GetChild("mat_nm4_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm5_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm6_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm7_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_body.GetChild("mat_nm8_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)



il_rows = dw_list.retrieve(is_brand, is_mat_cd, is_special_case, is_style)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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

il_rows = dw_1.Update(TRUE, FALSE)
if il_rows = 1 then
	il_rows = dw_body.Update(TRUE, FALSE)
	if il_rows = 1 then
		dw_1.ResetUpdate()
		dw_body.ResetUpdate()
		commit  USING SQLCA;		
	else
		rollback  USING SQLCA;
	end if	
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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
			dw_1.Enabled    = true
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
		dw_1.Enabled = false
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
cb_retrieve.enabled = true
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
int li_seq
//
//dw_print.dataobject = "d_kola_r00"
//dw_print.SetTransObject(SQLCA)
//
//string ls_null
//setnull(ls_null)
//
//dw_print.GetChild("mat_nm1_1", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//
//dw_print.GetChild("mat_nm2_1", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm3_1", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm4_1", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm5_1", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm6_1", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
/////////////////
//dw_print.GetChild("mat_nm1_2", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm2_2", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm3_2", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm4_2", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm5_2", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm6_2", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
/////////////////
//dw_print.GetChild("mat_nm1_3", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm2_3", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm3_3", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm4_3", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm5_3", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm6_3", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//
/////////////////
//dw_print.GetChild("mat_nm1_4", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm2_4", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm3_4", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//
//dw_print.GetChild("mat_nm4_4", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm5_4", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)
//
//dw_print.GetChild("mat_nm6_4", idw_make_item)
//idw_make_item.SetTransObject(SQLCA)
//idw_make_item.Retrieve('213')
//idw_make_item.insertrow(1)
//idw_make_item.setitem(1,'item',ls_null)



This.Trigger Event ue_title ()
li_seq = dw_1.getitemnumber(1,'seq')
il_rows = dw_print.retrieve(is_mat_cd,li_seq )
dw_print.inv_printpreview.of_SetZoom()

end event

event open;call super::open;string ls_brand, ls_year, ls_season
if gsv_cd.gs_cd8 <> ''  then
	dw_head.setitem(1,'mat_cd',gsv_cd.gs_cd8)
	select brand
		into :ls_brand
	from tb_12021_d (nolock) 
	where style + chno = :gsv_cd.gs_cd8;
	
	dw_head.setitem(1,'brand',ls_brand)
	dw_head.setitem(1,'gubn','2')	
	this.PostEvent("ue_retrieve")
	setnull(gsv_cd.gs_cd8)
	
	is_gubn = '2'
	
	if dw_1.dataobject <> 'd_fiti_d01' then 
				dw_1.dataobject    = 'd_fiti_d01'
				dw_list.dataobject = 'd_fiti_l01'
				dw_body.dataobject = 'd_fiti_d02'
				dw_print.dataobject = 'd_fiti_r00'
				
				dw_1.SetTransObject(SQLCA)
				dw_list.SetTransObject(SQLCA)
				dw_body.SetTransObject(SQLCA)
				dw_print.SetTransObject(SQLCA)
				dw_body.PostEvent(Constructor!)
				dw_print.PostEvent(Constructor!)		
	end if
	
	
	
end if
end event

type cb_close from w_com020_e`cb_close within w_21014_d
end type

type cb_delete from w_com020_e`cb_delete within w_21014_d
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_21014_d
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_21014_d
end type

type cb_update from w_com020_e`cb_update within w_21014_d
end type

type cb_print from w_com020_e`cb_print within w_21014_d
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_21014_d
end type

type gb_button from w_com020_e`gb_button within w_21014_d
end type

type cb_excel from w_com020_e`cb_excel within w_21014_d
boolean visible = false
string text = "결과보고서"
end type

event cb_excel::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
int li_seq
datetime ld_datetime
string ls_null, ls_style
setnull(ls_null)

dw_print.dataobject = "d_kola_r03"
dw_print.SetTransObject(SQLCA)


dw_print.GetChild("mat_nm1_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


dw_print.GetChild("mat_nm2_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm3_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm4_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm5_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm6_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
dw_print.GetChild("mat_nm1_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm2_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm3_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm4_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm5_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm6_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
dw_print.GetChild("mat_nm1_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm2_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm3_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm4_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm5_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm6_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


///////////////
dw_print.GetChild("mat_nm1_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm2_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm3_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


dw_print.GetChild("mat_nm4_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm5_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm6_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


select 
isnull((select top 1 left(style,4) + substring(style,5,4)
from tb_12025_d a (nolock) where mat_cd = :is_mat_cd),
(select top 1 left(mat_cd,1) + substring(mat_cd,5,1) + substring(mat_cd,3,2) 
 	+ '-' + item + '???'
 from tb_21013_d a (nolock) where mat_cd = :is_mat_cd))
 into :ls_style
from dual;

dw_print.object.t_brand.text = idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_style.text = ls_style
dw_print.object.t_mat_cd.text = is_mat_cd

IF gf_cdate(ld_datetime,0)  THEN  
	dw_print.object.t_yymmdd.text = string(ld_datetime,"yyyy-mm-dd")
end if


li_seq = dw_1.getitemnumber(1,'seq')
il_rows = dw_print.retrieve(is_mat_cd,li_seq )
dw_print.inv_printpreview.of_SetZoom()
end event

type dw_head from w_com020_e`dw_head within w_21014_d
integer x = 5
integer y = 156
integer width = 3593
integer height = 104
string dataobject = "d_kola_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')



end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "gubn"      // dddw로 작성된 항목
		is_gubn = string(data)
		if is_gubn = '1' then 
			if dw_1.dataobject <> 'd_kola_d01' then 
				dw_1.dataobject    = 'd_kola_d01'
				dw_list.dataobject = 'd_kola_l01'
				dw_body.dataobject = 'd_kola_d02_new'
				dw_print.dataobject = 'd_kola_r00'
				
				dw_1.SetTransObject(SQLCA)
				dw_list.SetTransObject(SQLCA)
				dw_body.SetTransObject(SQLCA)
				dw_print.SetTransObject(SQLCA)
				dw_body.PostEvent(Constructor!)
				dw_print.PostEvent(Constructor!)				
			end if
		elseif is_gubn = '2' then 
			if dw_1.dataobject <> 'd_fiti_d01' then 
				dw_1.dataobject    = 'd_fiti_d01'
				dw_list.dataobject = 'd_fiti_l01'
				dw_body.dataobject = 'd_fiti_d02_new'
				dw_print.dataobject = 'd_fiti_r00'
				
				dw_1.SetTransObject(SQLCA)
				dw_list.SetTransObject(SQLCA)
				dw_body.SetTransObject(SQLCA)
				dw_print.SetTransObject(SQLCA)
				dw_body.PostEvent(Constructor!)
				dw_print.PostEvent(Constructor!)		
			end if
			
		end if

END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_21014_d
integer beginy = 260
integer endy = 260
end type

type ln_2 from w_com020_e`ln_2 within w_21014_d
integer beginy = 264
integer endy = 264
end type

type dw_list from w_com020_e`dw_list within w_21014_d
integer x = 18
integer y = 576
integer width = 352
integer height = 1508
string dataobject = "d_kola_l01"
end type

event dw_list::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      :                                                       */	
///* 작성일      : 2001..                                                  */	
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//int li_seq, li_price
//string ls_date
//datetime ld_datetime
//IF row <= 0 THEN Return
//
//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN 1
//			END IF		
//		CASE 3
//			RETURN 1
//	END CHOOSE
//END IF
//	
////This.SelectRow(0, FALSE)
////This.SelectRow(row, TRUE)
//
//is_mat_cd = This.GetItemString(row, 'mat_cd') /* DataWindow에 Key 항목을 가져온다 */
////li_seq    = This.GetItemNumber(row, 'seq') /* DataWindow에 Key 항목을 가져온다 */
//select max(seq) into :li_seq 
//from tb_kola_m (nolock) where mat_cd = :is_mat_cd;
//
//IF IsNull(is_mat_cd) THEN return
//il_rows = dw_1.retrieve(is_mat_cd, li_seq)
//if il_rows > 0 then
//	ls_date = dw_1.getitemstring(1, "end_ymd")
//	if ls_date = '' or isnull(ls_date) then 
//		IF gf_cdate(ld_datetime,0)  THEN  
//			dw_1.setitem(1,"end_ymd",string(ld_datetime,"yyyymmdd"))
//		end if
//	end if
//	
//	li_price = dw_1.GetitemNumber(1, "price")
//	if li_price = 0 or isnull(li_price) then 		
//		dw_1.setitem(1,"price", 28000)
//	end if
//	
//	il_rows = dw_body.retrieve(is_mat_cd,li_seq)
//end if
//
//Parent.Trigger Event ue_button(7, il_rows)
//Parent.Trigger Event ue_msg(1, il_rows)

/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
int li_price, ii_seq, li_rows
string ls_date
datetime ld_datetime
IF row <= 0 THEN Return


//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)




is_mat_cd = This.GetItemString(row, 'mat_cd') /* DataWindow에 Key 항목을 가져온다 */
//li_seq    = This.GetItemNumber(row, 'seq') /* DataWindow에 Key 항목을 가져온다 */
dw_3.title = RightA(is_mat_cd,7)
if is_gubn = '1' then //원자재

		select max(seq) into :ii_seq 
		from tb_kola_m (nolock) where mat_cd = :is_mat_cd;
		
		IF IsNull(is_mat_cd) THEN return
		
		il_rows = dw_1.retrieve(is_mat_cd, ii_seq)
		if il_rows > 0 then	
			li_price = dw_1.GetitemNumber(1, "price")
			if li_price = 0 or isnull(li_price) then 	
				select top 1 price 
					into :li_price
				from tb_kola_d (nolock) where price <> 0 order by yymmdd desc;
		
				dw_1.setitem(1,"price", li_price)
			end if
			
			il_rows = dw_body.retrieve(is_mat_cd,ii_seq)
		end if
else
		select max(seq) into :ii_seq 
		from tb_fiti_m (nolock) where mat_cd = :is_mat_cd;
		
		IF IsNull(is_mat_cd) THEN return
		
		il_rows = dw_1.retrieve(is_mat_cd, ii_seq)
	
		if il_rows > 0 then	
			li_price = dw_1.GetitemNumber(1, "price")
			if li_price = 0 or isnull(li_price) then 	
			
				select top 1 price 
					into :li_price
				from tb_fiti_d (nolock) where price <> 0 order by yymmdd desc;
		
				dw_1.setitem(1,"price", li_price)
			end if
			
			il_rows = dw_body.retrieve(is_mat_cd,ii_seq)
		end if	
end if

li_rows = dw_3.retrieve(is_mat_cd)
if li_rows > 0 then 
	dw_3.visible = true
end if

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

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT

This.Modify(ls_modify)
end event

type dw_body from w_com020_e`dw_body within w_21014_d
integer x = 393
integer y = 576
integer width = 3214
integer height = 1508
boolean enabled = false
string dataobject = "d_kola_d02_NEW"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;string ls_null
setnull(ls_null)

This.GetChild("mat_nm1_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


This.GetChild("mat_nm2_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm7_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm8_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
This.GetChild("mat_nm1_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm7_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm8_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
This.GetChild("mat_nm1_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm7_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm8_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


///////////////
This.GetChild("mat_nm1_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


This.GetChild("mat_nm4_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm7_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm8_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

end event

event dw_body::ue_keydown;///*===========================================================================*/
///* 작성자      : 지우정보                                                    */	
///* 작성일      : 1999.11.08                                                  */	
///* 수정일      : 1999.11.08                                                  */
///*===========================================================================*/
//
//String ls_column_name, ls_tag, ls_report
//
//ls_column_name = This.GetColumnName()
//
//IF KeyDown(21) THEN
//	ls_tag = This.Describe(ls_column_name + ".Tag")
//	gf_kor_eng(Handle(Parent), ls_tag, 2)
//END IF
//
//CHOOSE CASE key
//	CASE KeyEnter!
//		Send(Handle(This), 256, 9, long(0,0))
//		Return 1
////	CASE KeyDownArrow!
////		IF This.GetRow() = This.RowCount() THEN
////		   This.InsertRow(This.GetRow() + 1)
////		END IF
//   CASE KeyF12!
//      char lc_kb[256]
//      GetKeyboardState (lc_kb)
//      lc_kb[17] = Char (128)
//      SetKeyboardState (lc_kb)
//      Send (Handle (this), 256, 9, 0)
//      GetKeyboardState (lc_kb)
//      lc_kb[17] = Char (0)
//      SetKeyboardState (lc_kb)
//	CASE KeyF1!
//		// Column.Protect = True Then Return
//		ls_report = This.Describe(ls_column_name + ".Protect")
//		IF ls_report = "1" THEN RETURN 0 
//		ls_report = Mid(ls_report, 4, Len(ls_report) - 4)
//		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
//								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
//		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
//END CHOOSE
//
//Return 0
end event

event dw_body::clicked;//
end event

event dw_body::itemchanged;//
end event

event dw_body::editchanged;//
end event

type st_1 from w_com020_e`st_1 within w_21014_d
integer x = 375
integer y = 576
integer width = 32
integer height = 1508
end type

type dw_print from w_com020_e`dw_print within w_21014_d
integer x = 82
integer y = 424
string dataobject = "d_kola_r00"
end type

event dw_print::constructor;call super::constructor;string ls_null
setnull(ls_null)

This.GetChild("mat_nm1_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


This.GetChild("mat_nm2_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
This.GetChild("mat_nm1_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
This.GetChild("mat_nm1_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm4_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


///////////////
This.GetChild("mat_nm1_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm2_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm3_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


This.GetChild("mat_nm4_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm5_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

This.GetChild("mat_nm6_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

end event

type dw_1 from datawindow within w_21014_d
event key_down pbm_dwnkey
integer x = 18
integer y = 268
integer width = 3579
integer height = 308
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_kola_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event key_down;/*===========================================================================*/
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

event itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
int li_seq, i
string ls_flag

IF row <= 0 THEN Return
li_seq = integer(data)

choose case dwo.name
	case "seq"		
		il_rows = dw_1.retrieve(is_mat_cd, li_seq)
		dw_body.clear()
		il_rows = dw_body.retrieve(is_mat_cd, li_seq)

end choose







end event

event editchanged;///*===========================================================================*/
///* 작성자      : 지우정보                                                    */	
///* 작성일      : 1999.11.08                                                  */	
///* 수정일      : 1999.11.08                                                  */
///*===========================================================================*/
//ib_changed = true
cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
//
end event

event constructor;This.GetChild("make_item1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve()

This.GetChild("make_item1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve()

This.GetChild("make_item1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve()

end event

type dw_3 from datawindow within w_21014_d
integer x = 2075
integer y = 772
integer width = 599
integer height = 784
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_fiti_style"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

