$PBExportHeader$w_58025_e.srw
$PBExportComments$제품수출 팩킹리스트
forward
global type w_58025_e from w_com020_e
end type
type dw_1 from u_dw within w_58025_e
end type
type sle_style from singlelineedit within w_58025_e
end type
type dw_2 from datawindow within w_58025_e
end type
end forward

global type w_58025_e from w_com020_e
integer height = 2476
dw_1 dw_1
sle_style sle_style
dw_2 dw_2
end type
global w_58025_e w_58025_e

type variables
String is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_pac_ymd, is_box_no


end variables

on w_58025_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.sle_style=create sle_style
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.sle_style
this.Control[iCurrent+3]=this.dw_2
end on

on w_58025_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.sle_style)
destroy(this.dw_2)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/* 작성일      : 2001.05.29																  */	
/* 수정일      : 2001.05.29																  */
/*===========================================================================*/
datetime id_datetime

IF gf_cdate(id_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(id_datetime,"yyyymmdd"))
	dw_head.setitem(1,"to_yymmdd",string(id_datetime,"yyyymmdd"))
end if


inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

this.Trigger Event ue_init(dw_1)




end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : 지우정보 (권진택)  													  */	
/* 작성일      : 2000.09.06																  */	
/* 수정일      : 2000.09.06																  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_pac_ymd)
dw_1.Reset()
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.07                                                  */	
/* 수성일      : 2000.09.07                                                  */
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_pac_ymd = dw_head.GetItemString(1, "pac_ymd")

if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd   = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or LenA(Trim(is_shop_cd)) <> 6 then
   MessageBox(ls_title,"거래처를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

return true	
end event

event ue_insert();/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.06                                                  */	
/* 수성일      : 2000.09.06                                                  */
/*===========================================================================*/
long	ll_cur_row, ll_row, i
datetime ld_datetime
string ls_flag

if dw_1.AcceptText() <> 1 then return
if dw_body.AcceptText() <> 1 then return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(title)
		CASE 1
			IF Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

	
ll_cur_row = dw_1.GetRow()

if ll_cur_row < 0 then return

if ll_cur_row = 0 then
   il_rows = dw_1.InsertRow(0)
else	 
	dw_1.Reset()
	il_rows = dw_1.InsertRow(0)
end if	 

IF gf_cdate(ld_datetime,0)  THEN  
	dw_1.setitem(1,"pac_ymd",string(ld_datetime,"yyyymmdd"))
end if
dw_1.setitem(1,"box_no","")

is_pac_ymd = dw_1.getitemstring(1,"pac_ymd")
is_box_no  = dw_1.getitemstring(1,"box_no")


ll_row =dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_pac_ymd, is_box_no)
for i = 0 to ll_row
	ls_flag = dw_body.getitemstring(i,"flag")
	if ls_flag = 'New' then 
		dw_body.SetItemStatus(i, 0, Primary!,New!)
	end if
next 


/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_1.Enabled = true
	dw_body.Enabled = true
	dw_1.ScrollToRow(il_rows)
	dw_1.SetColumn("box_no")
	dw_1.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수성일      : 1999.11.09																  */
/*===========================================================================*/
Long	 ll_cur_row, ll_rowcnt
Integer li_yn

ll_cur_row = dw_1.GetRow()

if ll_cur_row <= 0 then return

ll_rowcnt = dw_body.RowCount()

If ll_rowcnt > 0 Then 
	li_yn = MessageBox("경고!!!", "내부코드가 전부 삭제됩니다!!!", Exclamation!, OKCancel!, 2)
	IF li_yn = 1 THEN
		idw_status = dw_1.GetItemStatus (ll_cur_row, 0, primary!)	//ue_button에서 cb_update.Enabled 여부 결정
		il_rows = dw_1.DeleteRow(ll_cur_row)
		dw_body.RowsMove(1, dw_body.RowCount(), primary!, dw_body, 1, Delete!)	//dw_body의 모든 Row 삭제
		This.Trigger Event ue_button(4, il_rows)
		This.Trigger Event ue_msg(4, il_rows)
	ELSE
		return
	END IF
Else
	idw_status = dw_1.GetItemStatus (ll_cur_row, 0, primary!)	//ue_button에서 cb_update.Enabled 여부 결정
	il_rows = dw_1.DeleteRow(ll_cur_row)
	dw_body.RowsMove(1, dw_body.RowCount(), primary!, dw_body, 1, Delete!)	//dw_body의 모든 Row 삭제
	This.Trigger Event ue_button(4, il_rows)
	This.Trigger Event ue_msg(4, il_rows)
End If


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.07                                                  */	
/* 수성일      : 2001.10.04                                                  */
/*===========================================================================*/
long i, k, ll_row_count, ll_found,ll_row_count1, ll_found1
datetime ld_datetime
String ls_box_no, ls_pac_ymd, ls_find, ls_flag
decimal ldc_weight_g, ldc_weight_n

ll_row_count = dw_body.RowCount()

IF dw_1.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



ls_pac_ymd  = dw_1.GetItemString(1, "pac_ymd")
ls_box_no = dw_1.GetItemString(1, "box_no")

ll_row_count1 = dw_2.Retrieve(ls_pac_ymd, ls_box_no) //dw_2.RowCount()

FOR k = 1 TO ll_row_count1 
		ldc_weight_g = dw_1.GetItemNumber(1, "weight_g")
		ldc_weight_n =dw_1.GetItemNumber(1, "weight_n")
		ls_find  = "pac_ymd = '" + ls_pac_ymd + "' and box_no = '" + ls_box_no + "'"
		ll_found = dw_2.find(ls_find, 1, dw_2.RowCount())
		IF ll_found > 0 THEN
			dw_2.Setitem(ll_found, "weight_g",   ldc_weight_g)
			dw_2.Setitem(ll_found, "weight_n",   ldc_weight_n)
		ELSE
			ll_found = dw_2.insertRow(0)
			dw_2.Setitem(ll_found, "pac_ymd",  ls_pac_ymd)
			dw_2.Setitem(ll_found, "box_no",   ls_box_no)
			dw_2.Setitem(ll_found, "weight_g",   ldc_weight_g)
			dw_2.Setitem(ll_found, "weight_n",   ldc_weight_n)
		END IF

NEXT

il_rows = dw_2.Update(TRUE, FALSE)

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_flag = dw_body.GetItemString(i,"flag")
   IF idw_status = NewModified!  THEN            /* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified!  THEN	      /* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT


if il_rows = 1 then
	il_rows = dw_body.Update(TRUE, FALSE)
	if il_rows = 1 then
   	dw_1.ResetUpdate()
   	dw_2.ResetUpdate()		
   	dw_body.ResetUpdate()
		commit  USING SQLCA;
      dw_list.SetRedraw(FALSE)
		dw_list.Retrieve(is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_pac_ymd)
	   ll_found = dw_list.Find("box_no = '" + ls_box_no + "'", 1, dw_list.RowCount())
		IF ll_found > 0 THEN
		   dw_list.ScrollToRow(ll_found)
 	      dw_list.SelectRow(0, FALSE)
         dw_list.SelectRow(ll_found, TRUE) 
		END IF
      dw_list.SetRedraw(TRUE)
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

event ue_button;/*===========================================================================*/
/* 작성자      : 지우정보 (권 진택)                                          */	
/* 작성일      : 2000.09.07                                                  */	
/* 수성일      : 2000.09.07                                                  */
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
         dw_1.Enabled = false
         dw_body.Enabled = false
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
			if dw_1.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
			dw_1.Enabled = false
			dw_body.Enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = true
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
			dw_1.enabled = true
			dw_body.enabled = true
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_yymmdd.text = '기간: ' +is_fr_yymmdd + ' - ' + is_to_yymmdd
dw_print.object.t_cust_cd.text = '거래처: ' +is_shop_cd

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
il_rows = dw_print.retrieve(is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_pac_ymd)
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com020_e`cb_close within w_58025_e
integer taborder = 130
end type

type cb_delete from w_com020_e`cb_delete within w_58025_e
integer taborder = 80
end type

type cb_insert from w_com020_e`cb_insert within w_58025_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_58025_e
end type

type cb_update from w_com020_e`cb_update within w_58025_e
integer taborder = 120
end type

type cb_print from w_com020_e`cb_print within w_58025_e
boolean visible = false
integer taborder = 90
end type

type cb_preview from w_com020_e`cb_preview within w_58025_e
integer taborder = 100
end type

type gb_button from w_com020_e`gb_button within w_58025_e
end type

type cb_excel from w_com020_e`cb_excel within w_58025_e
integer taborder = 110
end type

type dw_head from w_com020_e`dw_head within w_58025_e
integer y = 176
integer height = 116
string dataobject = "d_58025_h01"
end type

event dw_head::itemchanged;call super::itemchanged;string ls_shop_nm
choose case dwo.name 
	case "shop_cd"
		this.setitem(1,"shop_nm","")
		select dbo.sf_shop_nm(:data,'s') into :ls_shop_nm from dual;
		this.setitem(1,"shop_nm",ls_shop_nm)
end choose
end event

type ln_1 from w_com020_e`ln_1 within w_58025_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com020_e`ln_2 within w_58025_e
integer beginy = 332
integer endy = 332
end type

type dw_list from w_com020_e`dw_list within w_58025_e
integer y = 352
integer width = 1330
integer height = 1904
boolean enabled = false
string dataobject = "d_58025_L01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.05.29                                                  */	
/* 수성일      : 2001.05.29                                                  */
/*===========================================================================*/
String ls_inter_grp, ls_flag, ls_pac_ymd, ls_box_no
long ll_row, i

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

ls_pac_ymd = This.GetItemString(row, 'pac_ymd') /* DataWindow에 Key 항목을 가져온다 */
ls_box_no  = This.GetItemString(row, 'box_no') /* DataWindow에 Key 항목을 가져온다 */

ll_row = dw_1.retrieve(ls_pac_ymd, ls_box_no)
ll_row = dw_2.retrieve(ls_pac_ymd, ls_box_no)
ll_row =dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_shop_cd, ls_pac_ymd, ls_box_no)
for i = 0 to ll_row
	ls_flag = dw_body.getitemstring(i,"flag")
	if ls_flag = 'New' then 
		dw_body.SetItemStatus(i, 0, Primary!,New!)
	end if
next 

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_58025_e
integer x = 1385
integer y = 516
integer width = 2208
integer height = 1740
boolean enabled = false
string dataobject = "d_58025_d02"
boolean hscrollbar = true
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (권 진택)                                          */	
/* 작성일      : 2000.09.07																  */	
/* 수성일      : 2001.10.04                                                  */
/*===========================================================================*/
Integer ll_cur_row, ll_row
string ls_find
ll_cur_row = dw_body.GetRow()

If dwo.name = "cb_deleterow" Then 
	idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
	dw_body.DeleteRow(ll_cur_row)
	if idw_status <> new! and idw_status <> newmodified! then
		ib_changed = true
		cb_update.enabled = true
	end if
end if

If dwo.name = "b_1" Then 
	ls_find = "style = '"+sle_style.text+"' "

	ll_row = this.find(ls_find,1,this.rowcount())
	this.scrolltorow(ll_row)
	this.setrow(ll_row)
//	this.setcolumn("style")
	this.SelectRow(ll_row, TRUE)

	
end if

end event

event dw_body::itemchanged;call super::itemchanged;string ls_pac_ymd, ls_box_no

choose case dwo.name
	case "gubn"
		
		ls_pac_ymd = dw_1.GetItemString(1, "pac_ymd")
		ls_box_no  = dw_1.GetItemString(1, "box_no")
		if data = "Y" then 
			this.setitem(row,"pac_ymd", ls_pac_ymd)
			this.setitem(row,"box_no", ls_box_no)
		else
			this.setitem(row,"pac_ymd", "")
			this.setitem(row,"box_no", "")
		end if

end choose
end event

event dw_body::clicked;call super::clicked;This.SelectRow(0, FALSE)
end event

type st_1 from w_com020_e`st_1 within w_58025_e
boolean visible = false
integer x = 1362
integer y = 352
integer height = 1904
boolean enabled = false
end type

type dw_print from w_com020_e`dw_print within w_58025_e
integer x = 407
integer y = 692
string dataobject = "d_58025_r01"
end type

type dw_1 from u_dw within w_58025_e
event ue_keycheck ( )
event ue_keydown pbm_dwnkey
integer x = 1385
integer y = 352
integer width = 2208
integer height = 152
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_58025_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수성일      : 1999.11.08                                                  */
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
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수성일      : 1999.11.08                                                  */
/*===========================================================================*/
String ls_pac_ymd, ls_box_no, ls_find
integer ll_row, i

IF dw_1.AcceptText() <> 1 THEN RETURN -1


ls_pac_ymd = dw_1.GetItemString(1, "pac_ymd")
ls_box_no  = dw_1.GetItemString(1, "box_no")

choose case dwo.name 
	case "pac_ymd"
		for i = 0 to dw_body.rowcount()
			ls_find = dw_body.getitemstring(i,"pac_ymd")			
			if (ls_find<>"" or not isnull(ls_find) ) and  ls_find <> string(data) then 
					dw_body.setitem(i,"pac_ymd",string(data))
			end if				
		next 
	case "box_no"
		for i = 0 to dw_body.rowcount()
			ls_find = dw_body.getitemstring(i,"box_no")			
			if (ls_find<>"" or not isnull(ls_find) ) and  ls_find <> string(data) then 
					dw_body.setitem(i,"box_no",string(data))
			end if				
		next 
end choose


If IsNull(ls_pac_ymd) or IsNull(ls_box_no) or Trim(ls_pac_ymd) = "" or Trim(ls_box_no) = "" Then 

	dw_body.Enabled = false
else
	dw_body.Enabled = true
end if



end event

event itemerror;call super::itemerror;return 1
end event

event itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수성일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

event dberror;///*===========================================================================*/
///* 작성자      : 지우정보                                                    */	
///* 작성일      : 1999.11.09																  */	
///* 수성일      : 1999.11.09																  */
///*===========================================================================*/
//
//string ls_message_string
//
//CHOOSE CASE sqldbcode
//	CASE 1
//		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
//	CASE 1400
//		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
//	CASE -1
//		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
//	CASE ELSE
//		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
//		   				     "~n" + "에러메세지("+sqlerrtext+")" 
//END CHOOSE
//
//This.ScrollTorow(row)
//This.SetRow(row)
//This.SetFocus()
//
//MessageBox(parent.title, ls_message_string)
//return 1
end event

event editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수성일      : 1999.11.08                                                  */
/*===========================================================================*/
String ls_pac_ymd, ls_box_no

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

IF dw_1.AcceptText() <> 1 THEN RETURN -1

ls_pac_ymd = dw_1.GetItemString(1, "pac_ymd")
ls_box_no  = dw_1.GetItemString(1, "box_no")


If IsNull(ls_pac_ymd) or IsNull(ls_box_no) or Trim(ls_pac_ymd) = "" or Trim(ls_box_no) = "" Then 

	dw_body.Enabled = false
else
	dw_2.retrieve(ls_pac_ymd,ls_box_no)
	dw_body.Enabled = true
end if


end event

type sle_style from singlelineedit within w_58025_e
integer x = 2053
integer y = 524
integer width = 402
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_58025_e
boolean visible = false
integer x = 841
integer y = 1192
integer width = 1499
integer height = 828
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_58025_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

