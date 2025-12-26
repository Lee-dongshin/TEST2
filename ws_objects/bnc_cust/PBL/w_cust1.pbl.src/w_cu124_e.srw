$PBExportHeader$w_cu124_e.srw
$PBExportComments$생산일보등록
forward
global type w_cu124_e from w_com010_e
end type
type dw_master from datawindow within w_cu124_e
end type
end forward

global type w_cu124_e from w_com010_e
integer width = 3653
integer height = 2236
dw_master dw_master
end type
global w_cu124_e w_cu124_e

type variables
string is_work_dt
end variables

on w_cu124_e.create
int iCurrent
call super::create
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_cu124_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event pfc_preopen();call super::pfc_preopen;
inv_resize.of_Register(dw_master, "ScaleToRight")
dw_master.SetTransObject(SQLCA)
dw_master.InsertRow(0)
dw_master.Enabled = false


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

is_work_dt = dw_head.GetItemString(1, "work_dt")

if IsNull(is_work_dt) or Trim(is_work_dt) = ""  or not gf_datechk(is_work_dt) then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("work_dt")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_date, ls_flag
long i

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_master.retrieve(is_work_dt, gs_shop_cd,gs_country_cd)
dw_body.reset()
if il_rows > 0 then
	ls_flag = dw_master.getitemstring(1,"flag")
	if ls_flag = "N" then
		dw_master.SetItemStatus(1, 0, Primary!,NewModified!)
	end if
	
	
	il_rows = dw_body.retrieve(is_work_dt, gs_shop_cd, gs_country_cd)	
	IF il_rows > 0 THEN
		for i = 1 to il_rows
			ls_flag = dw_body.getitemstring(i,"flag")
			if ls_flag = "N" then
				dw_body.SetItemStatus(i, 0, Primary!,New!)
			end if			
		next 
		dw_body.SetFocus()
	END IF
else
	dw_master.insertrow(1)	
	
	dw_head.setitem(1,"cust_cd",gs_shop_cd)
	dw_head.setitem(1,"cust_nm",gs_shop_nm)
	
	
	IF gf_cdate(ld_datetime,0)  THEN  
		ls_date = string(ld_datetime,"yyyymmdd")
		dw_head.setitem(1,"work_dt",ls_date)
		if gf_date_nm(ls_date) then
			dw_head.setitem(1,"date_nm",ls_date)
		end if
		
	end if	
	
end if
	
This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.05                                                  */	
/* 수정일      : 2001.12.05                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_rows
datetime ld_datetime
String ls_style, ls_chno, ls_qc_dt, ls_bigo

ll_row_count = dw_body.RowCount()
IF dw_master.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText()   <> 1 THEN RETURN -1


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_master.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN	/* New Record */
   dw_master.Setitem(1, "work_dt", is_work_dt)
   dw_master.Setitem(1, "cust_cd", gs_shop_cd)
   dw_master.Setitem(1, "reg_id", gs_shop_cd)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
   dw_master.Setitem(1, "mod_id", gs_shop_cd)
   dw_master.Setitem(1, "mod_dt", ld_datetime)
END IF

ll_rows = dw_master.Update(TRUE, FALSE)
if ll_rows = 1 then
   dw_master.ResetUpdate()
   commit  USING SQLCA;
end if


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = DataModified! THEN		/* Modify Record */
		If dw_body.GetItemString(i, "flag") = 'N' Then
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
			dw_body.Setitem(i, "reg_id", gs_shop_cd)
		Else
			dw_body.Setitem(i, "mod_id", gs_shop_cd)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
		End If
		
//		//작업지시서(TB_12021_D)에 비고  저장
//		ls_style   = dw_body.GetItemString(i, "style")
//		ls_chno    = dw_body.GetItemString(i, "chno")
//		ls_qc_dt   = dw_body.GetItemString(i, "qc_dt")
//		ls_bigo    = dw_body.GetitemString(i, "bigo")
//
//		update  tb_12021_d
//		set     bigo = :ls_bigo
//		where   style = :ls_style
//		and     chno  = :ls_chno;
		

   END IF
   /* 품번 디테일(tb_12021_d)에 비고 저장 */
	ls_style = dw_body.GetitemString(i,"style")
	ls_chno  = dw_body.GetitemString(i,"chno")
	ls_bigo  = dw_body.GetitemString(i,"bigo")
	update tb_12021_d
	set    bigo  =  :ls_bigo
	where  style =  :ls_style
	and    chno  =  :ls_chno;
	
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if ll_rows = 1 and il_rows = 1 then
   dw_master.ResetUpdate()
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_body.retrieve(is_work_dt, gs_shop_cd, gs_country_cd)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_master.Enabled = true
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
        
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
		
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_master.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> New! and idw_status <> Newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
        
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
   
      cb_update.enabled = false
      ib_changed = false
      dw_master.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE
end event

event open;call super::open;datetime ld_datetime
string 	ls_date


IF gf_cdate(ld_datetime,0)  THEN  
	ls_date = string(ld_datetime,"yyyymmdd")
	dw_head.setitem(1,"work_dt",ls_date)
	if gf_date_nm(ls_date) then
		dw_head.setitem(1,"date_nm",ls_date)
	end if
	
end if

dw_body.Object.DataWindow.HorizontalScrollSplit  = 1165
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.Retrieve(is_work_dt,gs_shop_cd,gs_country_cd)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_print.Retrieve(is_work_dt,gs_shop_cd,gs_country_cd)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_cu124_e
end type

type cb_delete from w_com010_e`cb_delete within w_cu124_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_cu124_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_cu124_e
end type

type cb_update from w_com010_e`cb_update within w_cu124_e
end type

type cb_print from w_com010_e`cb_print within w_cu124_e
end type

type cb_preview from w_com010_e`cb_preview within w_cu124_e
end type

type gb_button from w_com010_e`gb_button within w_cu124_e
integer width = 3593
end type

type dw_head from w_com010_e`dw_head within w_cu124_e
integer x = 0
integer y = 168
integer width = 1115
integer height = 84
string dataobject = "d_cu124_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_date

CHOOSE CASE dwo.name
	
	CASE "work_dt"
	   	ls_date = data	
        IF not gf_datechk(data)  THEN 
		 	   messagebox("경고", '날자 형식이 잘못 되었습니다 !')
		      return 1
	     end if
		
		  if gf_date_nm(ls_date) then
				dw_head.setitem(1,"date_nm",ls_date)
		  end if
	
	END CHOOSE

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false



end event

type ln_1 from w_com010_e`ln_1 within w_cu124_e
integer beginy = 664
integer endx = 3625
integer endy = 664
end type

type ln_2 from w_com010_e`ln_2 within w_cu124_e
integer beginy = 668
integer endx = 3625
integer endy = 668
end type

type dw_body from w_com010_e`dw_body within w_cu124_e
event type long ue_date ( long as_row,  string as_field_nm,  string as_date )
integer y = 676
integer width = 3598
integer height = 1368
string dataobject = "d_cu124_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event type long dw_body::ue_date(long as_row, string as_field_nm, string as_date);this.setitem(as_row,as_field_nm,RightA(as_date,4))
return 1
end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemchanged;call super::itemchanged;//string ls_date
//
//CHOOSE CASE dwo.name
//	
//	CASE "qc_dt" 
//     IF not gf_datechk(data)  THEN 
//		  messagebox("경고", '날자 형식이 잘못 되었습니다 !')
//		  return 1
//	  end if
//END CHOOSE

datetime ld_datetime
string 	ls_date, ls_year

choose case dwo.name
	case "cut_dte", "sew_dte", "fin_dte", "madome_dte", "siyage_dte", "self_qc_dte", "qc_dt"
		IF gf_cdate(ld_datetime,0)  THEN  
			ls_date = string(ld_datetime,"yyyymmdd")
			ls_year = LeftA(ls_date,4)

			if LenA(data) = 4 and dec(data) < 2000 then
				ls_date = ls_year + data			
				post event ue_date(row,dwo.name,ls_date)

			else 
				ls_date = data
			end if
		else
			return 1
		end if

		if not gf_datechk(ls_date) then
			messagebox("주의","일자를 올바로 입력하세요")
			return 1
		end if
end choose


end event

type dw_print from w_com010_e`dw_print within w_cu124_e
integer x = 64
integer y = 340
string dataobject = "d_cu124_r00"
end type

type dw_master from datawindow within w_cu124_e
integer x = 5
integer y = 160
integer width = 3579
integer height = 484
integer taborder = 20
string title = "none"
string dataobject = "d_cu124_d01"
boolean border = false
boolean livescroll = true
end type

event editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

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

end event

