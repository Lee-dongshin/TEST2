$PBExportHeader$w_75002_e.srw
$PBExportComments$고객행사등록
forward
global type w_75002_e from w_com020_e
end type
type dw_1 from datawindow within w_75002_e
end type
type dw_2 from datawindow within w_75002_e
end type
type dw_member from datawindow within w_75002_e
end type
end forward

global type w_75002_e from w_com020_e
dw_1 dw_1
dw_2 dw_2
dw_member dw_member
end type
global w_75002_e w_75002_e

type variables
string is_yymmdd, is_event_no, is_event_nm
Datawindowchild  idw_area, idw_sale_type
end variables

forward prototypes
public function integer wf_resizepanels ()
end prototypes

public function integer wf_resizepanels ();Long		ll_Width

ll_Width = idrg_Vertical[2].X + idrg_Vertical[2].Width - st_1.X - ii_BarThickness


idrg_Vertical[1].Resize (st_1.X - idrg_Vertical[1].X, idrg_Vertical[1].Height)

idrg_Vertical[2].Move (st_1.X + ii_BarThickness, idrg_Vertical[2].Y)
idrg_Vertical[2].Resize (ll_Width, idrg_Vertical[2].Height)


dw_1.Move (st_1.X + ii_BarThickness, dw_1.Y)
dw_1.Resize (ll_Width, dw_1.Height)

return 1
end function

on w_75002_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_member=create dw_member
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_member
end on

on w_75002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_member)
end on

event pfc_preopen();call super::pfc_preopen;datetime id_datetime

IF gf_cdate(id_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(id_datetime,"yyyymmdd"))

end if


inv_resize.of_Register(dw_1, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_member.SetTransObject(SQLCA)
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_event_nm = dw_head.GetItemString(1, "event_nm")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_yymmdd, is_event_nm)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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

event ue_insert();/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.06                                                  */	
/* 수성일      : 2000.09.06                                                  */
/*===========================================================================*/
long	ll_cur_row
datetime id_datetime

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
	
ll_cur_row = dw_1.GetRow()

if ll_cur_row < 0 then return

if ll_cur_row = 0 then
   il_rows = dw_1.InsertRow(0)
else	 
	dw_1.Reset()
	il_rows = dw_1.InsertRow(0)
end if	 



IF gf_cdate(id_datetime,0)  THEN  
	dw_1.setitem(1,"yymmdd",string(id_datetime,"yyyymmdd"))

end if


dw_body.reset()

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_1.Enabled = true
	dw_body.Enabled = false
	dw_1.ScrollToRow(il_rows)
	dw_1.SetColumn(ii_min_column_id)
	dw_1.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.07                                                  */	
/* 수성일      : 2001.10.04                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_found
datetime ld_datetime
String ls_inter_grp

ll_row_count = dw_body.RowCount()

IF dw_1.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


idw_status = dw_1.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
	dw_1.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN	      /* Modify Record */
	dw_1.Setitem(1, "mod_id", gs_user_id)
	dw_1.Setitem(1, "mod_dt", ld_datetime)
END IF


il_rows = dw_1.Update(TRUE, FALSE)

if il_rows = 1 then
	il_rows = dw_body.Update(TRUE, FALSE)
	if il_rows = 1 then
   	dw_1.ResetUpdate()
   	dw_body.ResetUpdate()
		commit  USING SQLCA;
      dw_list.SetRedraw(FALSE)
		dw_list.Retrieve(is_yymmdd, is_event_nm)
	   ll_found = dw_list.Find("event_nm = '" + is_event_nm + "'", 1, dw_list.RowCount())
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

type cb_close from w_com020_e`cb_close within w_75002_e
end type

type cb_delete from w_com020_e`cb_delete within w_75002_e
end type

event cb_delete::clicked;call super::clicked;IF MessageBox("확인", "해당하는 행사내역을 정말 삭제하시겠습니까 ?", Question!, YesNo!) = 2 THEN 
	RETURN
else
	
	delete a from tb_75020_m a(nolock) where yymmdd = :is_yymmdd and event_no = :is_event_no; 
	delete a from tb_75021_h a(nolock) where yymmdd = :is_yymmdd and event_no = :is_event_no; 
	
	commit  USING SQLCA;
	
	il_rows = dw_list.retrieve(is_yymmdd, is_event_nm)
	dw_1.Reset()
	dw_body.Reset()
	
	ib_changed = false	
	cb_update.enabled = false
end if

	

end event

type cb_insert from w_com020_e`cb_insert within w_75002_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_75002_e
end type

type cb_update from w_com020_e`cb_update within w_75002_e
end type

type cb_print from w_com020_e`cb_print within w_75002_e
end type

type cb_preview from w_com020_e`cb_preview within w_75002_e
end type

type gb_button from w_com020_e`gb_button within w_75002_e
end type

type cb_excel from w_com020_e`cb_excel within w_75002_e
end type

type dw_head from w_com020_e`dw_head within w_75002_e
integer height = 132
string dataobject = "d_75002_h01"
end type

type ln_1 from w_com020_e`ln_1 within w_75002_e
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com020_e`ln_2 within w_75002_e
integer beginy = 336
integer endy = 336
end type

type dw_list from w_com020_e`dw_list within w_75002_e
integer x = 18
integer y = 352
integer width = 891
integer height = 1656
string dataobject = "d_75002_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_yymmdd

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

ls_yymmdd   = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_event_no = This.GetItemString(row, 'event_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_event_no) THEN return
il_rows = dw_1.retrieve(ls_yymmdd, is_event_no)
il_rows = dw_body.retrieve(ls_yymmdd, is_event_no,'','',0,0,'','','','','','Dat')
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_75002_e
integer x = 933
integer y = 652
integer width = 2670
integer height = 1356
string dataobject = "d_75002_d01"
boolean hscrollbar = true
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (권 진택)                                          */	
/* 작성일      : 2000.09.07																  */	
/* 수성일      : 2001.10.04                                                  */
/*===========================================================================*/
Integer ll_cur_row

ll_cur_row = dw_body.GetRow()

If dwo.name = "cb_deleterow" Then 
	idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
	dw_body.DeleteRow(ll_cur_row)
	if idw_status <> new! and idw_status <> newmodified! then
		ib_changed = true
		cb_update.enabled = true
	end if
elseIf dwo.name = "cb_insertrow" Then
	this.insertrow(1)
	this.setrow(1)
end if


end event

event dw_body::doubleclicked;call super::doubleclicked;string  ls_jumin
long    ll_rows


dw_member.Reset()
ls_jumin = this.getitemstring(row,"jumin")
ll_rows = dw_member.Retrieve(ls_jumin) 

if  ll_rows > 0 then
	dw_member.visible = true
end if

end event

type st_1 from w_com020_e`st_1 within w_75002_e
integer x = 914
integer y = 352
integer height = 1656
end type

type dw_print from w_com020_e`dw_print within w_75002_e
end type

type dw_1 from datawindow within w_75002_e
event ue_keydown pbm_dwnkey
integer x = 933
integer y = 352
integer width = 2670
integer height = 288
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_75002_m01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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

event buttonclicked;choose case dwo.name
	case "cb_member"
	dw_2.visible = true
	dw_2.reset()
	dw_2.insertrow(0)
	dw_2.setfocus()
	
end choose
end event

event itemchanged;/*===========================================================================*/
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
//
//CHOOSE CASE dwo.name
//	CASE "colunm1" 
//    IF data = 'A' THEN
//	      /*action*/
//    END IF
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
//
end event

type dw_2 from datawindow within w_75002_e
boolean visible = false
integer x = 1307
integer y = 436
integer width = 1568
integer height = 756
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "행사대상자 생성"
string dataobject = "d_75002_d02"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event buttonclicked;string ls_fr_sale_date, ls_to_sale_date, ls_jumin
string ls_frm_gbn, ls_email_yn, ls_tel_no3_yn, ls_addr_yn, ls_flag
decimal ll_fr_sale_amt, ll_to_sale_amt, i


choose case dwo.name
	case "cb_exec"
		IF dw_2.AcceptText() <> 1 THEN RETURN -1	
			is_yymmdd	= dw_1.getitemstring(1,"yymmdd")
			if isnull(is_yymmdd) or is_yymmdd = '' then 
				messagebox("확인", "등록일자를 올바로 입력하세요..")
				return -1
			end if
			
			ls_fr_sale_date = dw_2.GetItemString(1, "fr_sale_date")
			ls_to_sale_date = dw_2.GetItemString(1, "to_sale_date")
			ll_fr_sale_amt = dw_2.GetItemdecimal(1, "fr_sale_amt")
			ll_to_sale_amt = dw_2.GetItemdecimal(1, "to_sale_amt")
			ls_jumin = dw_2.GetItemString(1, "jumin")
			ls_frm_gbn = dw_2.GetItemString(1, "frm_gbn")
			
			ls_email_yn = dw_2.GetItemString(1, "email_yn")		
			ls_tel_no3_yn = dw_2.GetItemString(1, "tel_no3_yn")		
			ls_addr_yn = dw_2.GetItemString(1, "addr_yn")		

			select right('000' + convert(varchar(3), (isnull((select max(event_no) from tb_75020_m (nolock) where yymmdd = '20040915'),'0') + 1)),3) 
				into :is_event_no
			from dual;
			

			if isnull(is_event_no) or is_event_no = '' then return -1
			dw_1.setitem(1,"event_no",is_event_no)
			
			
			il_rows = dw_body.retrieve(is_yymmdd, is_event_no, ls_fr_sale_date, ls_to_sale_date, + &
											ll_fr_sale_amt, ll_to_sale_amt, ls_email_yn, ls_tel_no3_yn, ls_addr_yn, ls_jumin, ls_frm_gbn, 'New')
			if dw_body.rowcount() > 0 then
				 dw_2.visible = false
				 dw_body.enabled = true
				 ib_changed = true
				 cb_update.enabled = true
				 
				for i = 1 to dw_body.rowcount()
					 dw_body.SetItemStatus(i, 0, Primary!, Newmodified!)	
				next
			end if
			
	
	case "cb_reset"
		this.reset()
		this.insertrow(0)
end choose

end event

type dw_member from datawindow within w_75002_e
boolean visible = false
integer x = 5
integer y = 300
integer width = 4500
integer height = 2000
integer taborder = 60
boolean titlebar = true
string title = "회원정보"
string dataobject = "d_member_info"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')

This.GetChild("sale_type", idw_sale_type )
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')
end event

event doubleclicked;This.Visible = false 
end event

