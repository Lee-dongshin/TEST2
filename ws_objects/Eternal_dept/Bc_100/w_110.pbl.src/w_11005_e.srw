$PBExportHeader$w_11005_e.srw
$PBExportComments$매장별 년 매출계획
forward
global type w_11005_e from w_com020_e
end type
type dw_master from datawindow within w_11005_e
end type
type dw_job from datawindow within w_11005_e
end type
type st_2 from statictext within w_11005_e
end type
end forward

global type w_11005_e from w_com020_e
dw_master dw_master
dw_job dw_job
st_2 st_2
end type
global w_11005_e w_11005_e

type variables
String is_brand, is_yyyy, is_empno, is_shop_cd 
Long   il_plan_seq
end variables

forward prototypes
public function boolean wf_retrieve ()
end prototypes

public function boolean wf_retrieve ();Long ll_row

ll_row      = dw_list.GetSelectedRow(0) 
IF ll_row   < 1 THEN RETURN False
is_shop_cd  = dw_list.GetItemString(ll_row, 'shop_cd') 

ll_row      = dw_master.GetSelectedRow(0) 
IF ll_row   < 1 THEN RETURN False
il_plan_seq = dw_master.GetItemNumber(ll_row, 'plan_seq') 

IF IsNull(is_shop_cd) OR IsNull(il_plan_seq) THEN Return False
il_rows = dw_body.retrieve(is_brand, is_yyyy, is_shop_cd, il_plan_seq)
dw_job.retrieve(is_brand, is_yyyy, is_shop_cd, il_plan_seq)

Return TRUE

end function

on w_11005_e.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.dw_job=create dw_job
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.dw_job
this.Control[iCurrent+3]=this.st_2
end on

on w_11005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.dw_job)
destroy(this.st_2)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
String     ls_emp_nm, ls_brand, ls_dept  
Boolean    lb_check 
DataStore  lds_Source 

CHOOSE CASE as_column
	CASE "empno"				
			IF ai_div = 1 THEN 	
				IF gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_head.Setitem(al_row, "empnm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
			ls_brand = dw_head.Object.brand[1]
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 
			gf_get_inter_sub ('991', ls_brand + '50', '1', ls_dept)
		   gst_cd.default_where   = "where goout_gubn = '1' and dept_code = '" + ls_dept + "'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "empno LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "empnm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_head.TriggerEvent(Editchanged!)
				cb_retrieve.SetFocus()
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

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */ 
/* 작성일      : 2002.01.16                                                  */
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_master.retrieve(is_brand, is_yyyy)
IF il_rows = 0 THEN
	dw_master.InsertRow(0)
	dw_master.Setitem(1, "plan_seq", 1)
	dw_master.selectrow(0, FALSE)
	dw_master.selectrow(1, TRUE)
ELSE
	cb_insert.Enabled = True
END IF

il_rows = dw_list.retrieve(is_brand, is_empno)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")
inv_resize.of_Register(dw_master, "ScaleToRight")

dw_master.SetTransObject(SQLCA)
dw_job.SetTransObject(SQLCA)

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_master.AcceptText() <> 1 then return
if dw_body.AcceptText() <> 1 then return

il_rows = dw_master.InsertRow(0)

if il_rows > 0 then 
	if il_rows = 1 then
		il_plan_seq = 1
	else
	   il_plan_seq = dw_master.object.plan_seq[il_rows - 1] + 1
	end if
   dw_master.Setitem(il_rows, "plan_seq", il_plan_seq)
   /* 추가된 Row선택 */
	dw_master.SelectRow(0, FALSE)
   dw_master.SelectRow(il_rows, TRUE)
	wf_retrieve()
   cb_insert.enabled = false
   /* 추가된 Row의 항목으로 이동 */
	dw_master.ScrollToRow(il_rows)
	dw_master.SetColumn("remark")
	dw_master.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
long i, ll_row_count, k, ll_row
Decimal  ldc_plan_amt
datetime ld_datetime
String   ls_Find, ls_yymm

IF dw_master.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1

ll_row_count = dw_body.RowCount()

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		      /* Modify Record */
	   ls_yymm = dw_body.GetitemString(i, "yymm")
	   FOR k = 1 TO 2 
         idw_status = dw_body.GetItemStatus(i, "plan_amt_" + String(k), Primary!)
         IF idw_status = DataModified! THEN		/* Modify Column */
			   ldc_plan_amt = dw_body.GetitemDecimal(i, "plan_amt_" + String(k)) * 1000
			   ls_find = "yymm = '" + ls_yymm + "' and sale_div = '" + String(k) + "'"
	         ll_row = dw_job.find(ls_Find, 1, dw_job.RowCount())
				IF ll_row > 0 THEN
               dw_job.Setitem(ll_row, "plan_amt", ldc_plan_amt)
               dw_job.Setitem(ll_row, "mod_id", gs_user_id)
               dw_job.Setitem(ll_row, "mod_dt", ld_datetime)
				ELSE
					ll_row = dw_job.insertRow(0)
               dw_job.Setitem(ll_row, "plan_yy",  is_yyyy)
               dw_job.Setitem(ll_row, "brand",    is_brand)
               dw_job.Setitem(ll_row, "plan_seq", il_plan_seq)
               dw_job.Setitem(ll_row, "yymm",     ls_yymm)
               dw_job.Setitem(ll_row, "shop_cd",  is_shop_cd)
               dw_job.Setitem(ll_row, "sale_div", String(k))
               dw_job.Setitem(ll_row, "plan_amt", ldc_plan_amt)
               dw_job.Setitem(i, "reg_id", gs_user_id)
				END IF
		   END IF
		NEXT 
   END IF
NEXT

ll_row_count = dw_master.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_master.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_master.Setitem(i, "plan_yy", is_yyyy)
      dw_master.Setitem(i, "brand",   is_brand)
      dw_master.Setitem(i, "reg_id",  gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_master.Setitem(i, "mod_id", gs_user_id)
      dw_master.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_master.Update(TRUE, FALSE)
if il_rows = 1 then
   il_rows = dw_job.Update(TRUE, FALSE)
end if

if il_rows = 1 then
   dw_master.ResetUpdate()
   dw_job.ResetUpdate()
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
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
         dw_body.Enabled = true
         dw_master.Enabled = True
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
            dw_master.Enabled = True
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_insert.enabled = true
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
      dw_body.Enabled = false
      dw_master.Enabled = false
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
      end if
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11005_e","0")
end event

type cb_close from w_com020_e`cb_close within w_11005_e
end type

type cb_delete from w_com020_e`cb_delete within w_11005_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_11005_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_11005_e
end type

type cb_update from w_com020_e`cb_update within w_11005_e
end type

type cb_print from w_com020_e`cb_print within w_11005_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_11005_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_11005_e
end type

type cb_excel from w_com020_e`cb_excel within w_11005_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_11005_e
integer height = 172
string dataobject = "d_11005_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('001')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_11005_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_11005_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_11005_e
integer x = 5
integer y = 372
integer width = 878
integer height = 1672
string dataobject = "d_11005_d02"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
Long  ll_row

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

IF wf_retrieve() = FALSE THEN RETURN 

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_11005_e
integer x = 887
integer y = 744
integer width = 2720
integer height = 1300
string dataobject = "d_11005_d03"
boolean hscrollbar = true
end type

type st_1 from w_com020_e`st_1 within w_11005_e
boolean visible = false
integer x = 878
integer y = 740
integer height = 1308
end type

type dw_print from w_com020_e`dw_print within w_11005_e
end type

type dw_master from datawindow within w_11005_e
event ue_keydown pbm_dwnkey
integer x = 887
integer y = 372
integer width = 2720
integer height = 368
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_11005_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
END CHOOSE

end event

event clicked;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
Long ll_row

IF row <= 0 THEN Return
IF row = This.GetSelectedRow(0) THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 2 
			dw_master.Retrieve(is_brand, is_yyyy)
			cb_insert.Enabled = TRUE
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

IF wf_retrieve() = FALSE THEN RETURN

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_insert.enabled = false
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
Long i, ll_row

ib_changed = true
cb_update.enabled = true
cb_insert.enabled = false

CHOOSE CASE dwo.name 
	CASE "last_yn" 
		IF data <> 'Y' THEN RETURN 0
		ll_row = This.RowCount()
		FOR i = 1 TO ll_row 
			IF row <> i THEN 
				This.Setitem(i, "last_yn", "N")
			END IF
		NEXT
END CHOOSE

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

type dw_job from datawindow within w_11005_e
boolean visible = false
integer x = 2674
integer y = 260
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_11005_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

MessageBox(parent.title, ls_message_string)
return 1
end event

type st_2 from statictext within w_11005_e
integer x = 3168
integer y = 280
integer width = 425
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "( 단위 : 천원 )"
boolean focusrectangle = false
end type

