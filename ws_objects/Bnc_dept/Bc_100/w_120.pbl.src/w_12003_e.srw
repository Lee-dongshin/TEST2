$PBExportHeader$w_12003_e.srw
$PBExportComments$온라인 품평
forward
global type w_12003_e from w_com030_e
end type
type shl_1 from statichyperlink within w_12003_e
end type
end forward

global type w_12003_e from w_com030_e
shl_1 shl_1
end type
global w_12003_e w_12003_e

type variables
String is_brand, is_year, is_season, is_sample_cd
end variables

forward prototypes
public function boolean wf_sample_chk (string as_sample_cd)
end prototypes

public function boolean wf_sample_chk (string as_sample_cd);// 품번 코드 CHECK
String ls_year, ls_sojae, ls_item, ls_nm 

IF isnull(as_sample_cd) OR LenA(as_sample_cd) <> 8 THEN Return False
// 브랜드 
IF MidA(as_sample_cd, 1, 1) <> is_brand THEN Return False 
//시즌년도 
gf_get_inter_sub('002', MidA(as_sample_cd, 3, 1), '1', ls_year)
IF ls_year <> is_year THEN Return False 
// 시즌 
IF MidA(as_sample_cd, 4, 1) <> is_season THEN Return False 

// 소재
ls_sojae  = MidA(as_sample_cd, 2, 1)
IF gf_sojae_nm(ls_sojae, ls_nm) <> 0 THEN Return False 
// 품종 
ls_item = MidA(as_sample_cd, 5, 1)
IF gf_item_nm(ls_item, ls_nm) <> 0 THEN Return False 

Return True
end function

on w_12003_e.create
int iCurrent
call super::create
this.shl_1=create shl_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
end on

on w_12003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.shl_1)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

return true	
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
   dw_body.InsertRow(0)
	dw_body.Setitem(1, "brand",  is_brand)
	dw_body.Setitem(1, "year",   is_year)
	dw_body.Setitem(1, "season", is_season)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/
string     ls_dsgn_nm, ls_dept, ls_mat_nm, ls_sojae  
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "dsgn_emp"							// 사원 코드
			IF ai_div = 1 THEN 	
				if LenA(as_data) = 0 or isnull(as_data) then
					return 0			
				elseIF gf_emp_nm(as_data, ls_dsgn_nm) = 0 THEN
				   dw_body.SetItem(al_row, "dsgn_nm", ls_dsgn_nm)
					RETURN 0
				END IF
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 
			gf_get_inter_sub ('991', is_brand + '10', '1', ls_dept)
		   gst_cd.default_where   = "where goout_gubn = '1' and dept_code = '" + ls_dept + "'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "empno  LIKE  '" + as_data + "%'"
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
					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "dsgn_emp", lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "dsgn_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("mat_cd")
				ib_itemchanged = False
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				if LenA(as_data) = 0 or isnull(as_data) then
					return 0			
				elseIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN 
					dw_body.Setitem(al_row, "mat_nm", ls_mat_nm)
					RETURN 0
				END IF 
			END IF
			ls_sojae = dw_body.GetitemString(al_row, "sojae")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = "where brand      = '" + is_brand  + "'" + &
			                         "  and mat_year   = '" + is_year   + "'" + &
											 "  and mat_season = '" + is_season + "'" + &
											 "  and mat_sojae  = '" + ls_sojae  + "'" 
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
				dw_body.SetColumn("out_seq")
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

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
long ll_cur_row
datetime ld_datetime

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
   dw_body.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
   dw_body.Setitem(1, "mod_id", gs_user_id)
   dw_body.Setitem(1, "mod_dt", ld_datetime)
END IF

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

/* dw_list에 추가되거나 수정된 내용를 반영 */  
IF il_rows = 1 THEN
   IF idw_status = NewModified! THEN
      ll_cur_row = dw_list.GetSelectedRow(0)+1
      dw_list.InsertRow(ll_cur_row)
      dw_list.Setitem(ll_cur_row, "sample_cd", dw_body.GetItemString(1, "sample_cd"))
      dw_list.Setitem(ll_cur_row, "dsgn_nm",   dw_body.GetItemString(1, "dsgn_nm"))
      dw_list.Setitem(ll_cur_row, "mat_cd",    dw_body.GetItemString(1, "mat_cd"))
      dw_list.Setitem(ll_cur_row, "mat_nm",    dw_body.GetItemString(1, "mat_nm"))
      dw_list.SelectRow(0, FALSE)
      dw_list.SelectRow(ll_cur_row, TRUE)
      dw_list.SetRow(ll_cur_row)
   ELSEIF idw_status = DataModified! THEN
      ll_cur_row = dw_list.GetSelectedRow(0)
      dw_list.Setitem(ll_cur_row, "sample_cd", dw_body.GetItemString(1, "sample_cd"))
      dw_list.Setitem(ll_cur_row, "dsgn_nm",   dw_body.GetItemString(1, "dsgn_nm"))
      dw_list.Setitem(ll_cur_row, "mat_cd",    dw_body.GetItemString(1, "mat_cd"))
      dw_list.Setitem(ll_cur_row, "mat_nm",    dw_body.GetItemString(1, "mat_nm"))
   END IF
END IF

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
long	ll_cur_row

if dw_body.AcceptText() <> 1 then return

/* 추가시 수정자료가 있을때 저장여부 확인 */
if ib_changed then 
	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 2
			ib_changed = false
		CASE 3
				RETURN
	END CHOOSE
end if


/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_body.SetRedraw(False)
il_rows = dw_body.DeleteRow(1)

if il_rows > 0 then
   il_rows = dw_body.InsertRow(0)
	il_rows = dw_body.ResetUpdate()
	dw_body.Setitem(1, "brand",  is_brand)
	dw_body.Setitem(1, "year",   is_year)
	dw_body.Setitem(1, "season", is_season)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if
dw_body.SetRedraw(True)

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
il_rows = dw_body.InsertRow (0)

IF dw_body.update() < 1 THEN	RETURN

Commit;

dw_body.Setitem(1, "brand",  is_brand)
dw_body.Setitem(1, "year",   is_year)
dw_body.Setitem(1, "season", is_season)

IF idw_status = NotModified! OR idw_status = DataModified! THEN
	ll_cur_row = dw_list.GetSelectedRow(0)
	if ll_cur_row > 0 THEN dw_list.DeleteRow(ll_cur_row)  //dw_list Row 삭제
END IF

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12003_e","0")
end event

type cb_close from w_com030_e`cb_close within w_12003_e
end type

type cb_delete from w_com030_e`cb_delete within w_12003_e
boolean visible = false
end type

type cb_insert from w_com030_e`cb_insert within w_12003_e
boolean visible = false
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_12003_e
boolean visible = false
end type

type cb_update from w_com030_e`cb_update within w_12003_e
boolean visible = false
end type

type cb_print from w_com030_e`cb_print within w_12003_e
boolean visible = false
end type

type cb_preview from w_com030_e`cb_preview within w_12003_e
boolean visible = false
end type

type gb_button from w_com030_e`gb_button within w_12003_e
end type

type cb_excel from w_com030_e`cb_excel within w_12003_e
boolean visible = false
end type

type dw_head from w_com030_e`dw_head within w_12003_e
boolean visible = false
integer height = 160
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003')

end event

type ln_1 from w_com030_e`ln_1 within w_12003_e
boolean visible = false
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com030_e`ln_2 within w_12003_e
boolean visible = false
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com030_e`dw_list within w_12003_e
boolean visible = false
integer y = 380
integer width = 1861
integer height = 1660
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_sample_cd = This.GetItemString(row, 'sample_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_sample_cd) THEN return
il_rows = dw_body.retrieve(is_sample_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com030_e`dw_body within w_12003_e
boolean visible = false
integer x = 1915
integer y = 380
integer width = 1678
integer height = 1660
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003')

This.GetChild("sojae", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%')

This.GetChild("item", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%')

This.GetChild("sample_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('121')

This.GetChild("out_seq", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('010')

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "sample_cd" 
		IF wf_sample_chk(Data) = False THEN 
			MessageBox("오류", "코드 형식이 맞지 않습니다 !")
			Return 1
		END IF
	   This.Setitem(1, "sojae",   MidA(data, 2, 1))
      This.Setitem(1, "item",    MidA(data, 5, 1))
	CASE "dsgn_emp", "mat_cd"	     
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "convt_ymd" 
      IF gf_datechk(data) = FALSE THEN
	      RETURN 1
      END IF
END CHOOSE

end event

type st_1 from w_com030_e`st_1 within w_12003_e
boolean visible = false
integer x = 1897
integer y = 380
integer height = 1660
end type

type dw_print from w_com030_e`dw_print within w_12003_e
integer x = 87
integer y = 836
end type

type shl_1 from statichyperlink within w_12003_e
integer x = 576
integer y = 232
integer width = 1138
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "온라인 품평회 참여(online.ibeaucre.co.kr)"
boolean focusrectangle = false
end type

event clicked;shl_1.URL = 'online.ibeaucre.co.kr'

end event

