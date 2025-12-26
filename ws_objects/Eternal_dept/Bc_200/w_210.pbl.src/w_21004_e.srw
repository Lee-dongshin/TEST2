$PBExportHeader$w_21004_e.srw
$PBExportComments$부자재 발주등록
forward
global type w_21004_e from w_com020_e
end type
type dw_mast from datawindow within w_21004_e
end type
type dw_asst from datawindow within w_21004_e
end type
type dw_body2 from datawindow within w_21004_e
end type
type sle_over_rate from singlelineedit within w_21004_e
end type
type st_2 from statictext within w_21004_e
end type
type cb_1 from commandbutton within w_21004_e
end type
type dw_1 from datawindow within w_21004_e
end type
type dw_copy_ord from datawindow within w_21004_e
end type
type cb_copy_ord from commandbutton within w_21004_e
end type
type cb_invoice from commandbutton within w_21004_e
end type
type dw_2 from datawindow within w_21004_e
end type
type dw_3 from datawindow within w_21004_e
end type
type dw_4 from datawindow within w_21004_e
end type
type cb_2 from commandbutton within w_21004_e
end type
type cb_3 from commandbutton within w_21004_e
end type
end forward

global type w_21004_e from w_com020_e
boolean visible = false
integer width = 3694
integer height = 2308
event ue_default ( )
dw_mast dw_mast
dw_asst dw_asst
dw_body2 dw_body2
sle_over_rate sle_over_rate
st_2 st_2
cb_1 cb_1
dw_1 dw_1
dw_copy_ord dw_copy_ord
cb_copy_ord cb_copy_ord
cb_invoice cb_invoice
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
cb_2 cb_2
cb_3 cb_3
end type
global w_21004_e w_21004_e

type variables
dragobject   idrg_vertical2[2]
string is_brand = 'N' , is_ord_ymd, is_ord_no, is_ord_origin, new, Flag, is_ord_emp
long il_list_row, il_body_row, il_over_rate
datawindowchild idw_color

end variables

forward prototypes
public function integer wf_resizepanels ()
public function integer uf_expert_yn (string as_ord_origin, string as_mat_cd, string as_color)
end prototypes

event ue_default;string ls_null

		dw_mast.setitem(1,"brand",is_brand)
		dw_mast.setitem(1,"ord_ymd",is_ord_ymd)
		dw_mast.setitem(1,"ord_origin",is_ord_origin)
		dw_mast.setitem(1,"ord_no",ls_null)

		dw_mast.setitem(1,"local_gubn","1")
		dw_mast.setitem(1,"pay_gubn","08")
		if LenA(is_ord_origin) = 10 then
			dw_mast.setitem(1,"ord_type","2")
		else
			dw_mast.setitem(1,"ord_type","1")
		end if
		
		dw_mast.setitem(1,"cust_cd",ls_null)
		dw_mast.setitem(1,"cust_nm",ls_null)
		
		dw_mast.SetItemStatus(1, 0, Primary!, New!)
		dw_mast.setfocus()
		dw_mast.setcolumn("cust_cd")
end event

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Vertical[2].X + idrg_Vertical[2].Width - st_1.X - ii_BarThickness

idrg_Vertical[1].Resize (st_1.X - idrg_Vertical[1].X, idrg_Vertical[1].Height)

idrg_Vertical[2].Move (st_1.X + ii_BarThickness, idrg_Vertical[2].Y)
idrg_Vertical[2].Resize (ll_Width, idrg_Vertical[2].Height)


//ll_Width = idrg_Vertical2[1].X + idrg_Vertical2[1].Width - st_1.X - ii_BarThickness
//ll_Width = idrg_Vertical2[2].X - idrg_Vertical2[1].X - ii_BarThickness

//idrg_Vertical2[1].Move (st_1.X + ii_BarThickness, idrg_Vertical2[1].Y)
//idrg_Vertical2[1].Resize (ll_Width, idrg_Vertical2[1].Height)
//idrg_Vertical2[2].Move (idrg_Vertical2[1].X + idrg_Vertical2[1].Width + ii_BarThickness, idrg_Vertical2[1].Y)
Return 1

end function

public function integer uf_expert_yn (string as_ord_origin, string as_mat_cd, string as_color);long li_ret
	li_ret = 0
	
	select 1
		into :li_ret
	from vi_21020_1 a(nolock)
	where ord_origin = :as_ord_origin
	and   mat_cd     = :as_mat_cd
	and   color      = :as_color
	and   expert_yn  = 'Y';
	
	
	return li_ret
	
end function

on w_21004_e.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
this.dw_asst=create dw_asst
this.dw_body2=create dw_body2
this.sle_over_rate=create sle_over_rate
this.st_2=create st_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.dw_copy_ord=create dw_copy_ord
this.cb_copy_ord=create cb_copy_ord
this.cb_invoice=create cb_invoice
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
this.Control[iCurrent+2]=this.dw_asst
this.Control[iCurrent+3]=this.dw_body2
this.Control[iCurrent+4]=this.sle_over_rate
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.dw_copy_ord
this.Control[iCurrent+9]=this.cb_copy_ord
this.Control[iCurrent+10]=this.cb_invoice
this.Control[iCurrent+11]=this.dw_2
this.Control[iCurrent+12]=this.dw_3
this.Control[iCurrent+13]=this.dw_4
this.Control[iCurrent+14]=this.cb_2
this.Control[iCurrent+15]=this.cb_3
end on

on w_21004_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast)
destroy(this.dw_asst)
destroy(this.dw_body2)
destroy(this.sle_over_rate)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.dw_copy_ord)
destroy(this.cb_copy_ord)
destroy(this.cb_invoice)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.cb_2)
destroy(this.cb_3)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
String ls_style_no
of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_4, "FixedToRight")
inv_resize.of_Register(dw_asst, "ScaleToRight")
inv_resize.of_Register(dw_1, "FixedToRight&ScaleToBottom")


idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_mast.SetTransObject(SQLCA)
dw_asst.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_asst.reset()
//dw_1.InsertRow(0)

new = 'New'
datetime ld_datetime



//idrg_Vertical2[1] = dw_mast
//idrg_Vertical2[2] = dw_asst

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"ord_ymd",string(ld_datetime,"yyyymmdd"))

end if

ls_style_no = gsv_cd.gs_cd10

if isnull(ls_style_no) = false then 
	dw_head.setitem(1,"ord_origin",gsv_cd.gs_cd10)
	dw_head.setitem(1,"brand",MidA(ls_style_no,1,1))
end if	



il_rows = dw_4.retrieve()






end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin)
dw_mast.reset()
dw_asst.reset()
dw_body.reset()
cb_3.visible = False

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


if as_cb_div = '9' then
	IF dw_mast.AcceptText() <> 1 THEN RETURN FALSE
	is_brand      = dw_mast.GetItemString(1, "brand")
	is_ord_ymd    = dw_mast.GetItemString(1, "ord_ymd")
	is_ord_no     = dw_mast.GetItemString(1, "ord_no")
	is_ord_origin = dw_mast.GetItemString(1, "ord_origin")
	Flag          = dw_mast.GetItemString(1, "Flag")  
	is_ord_emp    = dw_mast.GetItemString(1, "ord_emp") 
		
else
	IF dw_head.AcceptText() <> 1 THEN RETURN FALSE
	is_brand      = dw_head.GetItemString(1, "brand")
	is_ord_ymd    = dw_head.GetItemString(1, "ord_ymd")
	is_ord_no     = dw_head.GetItemString(1, "ord_no")
	is_ord_origin = dw_head.GetItemString(1, "ord_origin")	
	Flag          = dw_mast.GetItemString(1, "Flag")  
end if
	
//if IsNull(is_brand) or Trim(is_brand) = "" then
//   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//end if
//if IsNull(is_ord_ymd) or Trim(is_ord_ymd) = "" then
//   MessageBox(ls_title,"발주일자를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("ord_ymd")
//   return false
//end if



return true

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/
long prot


CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
			cb_insert.enabled = false
         dw_mast.Enabled = false
         dw_asst.Enabled = false
         dw_body.Enabled = false
			cb_delete.enabled = false
			cb_copy_ord.enabled = false
		else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			cb_copy_ord.enabled = false
//			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_mast.Enabled = true
	         dw_asst.Enabled = true				
	         dw_body.Enabled = true
				cb_delete.enabled = false //true
			end if
//		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
			cb_insert.enabled = true //
			cb_copy_ord.enabled = false
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> Newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
			cb_copy_ord.enabled = false
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
      dw_mast.Enabled = false
      dw_asst.Enabled = false
      dw_body.Enabled = false		
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
		cb_copy_ord.enabled = false
   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
			cb_copy_ord.enabled = true
		else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
			cb_copy_ord.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
		
		prot = dw_mast.getitemnumber(1,"prot")

		dw_mast.enabled = true
		
		if prot = 1 then
			cb_update.enabled = false
			cb_delete.enabled = true
         dw_asst.Enabled = false
         dw_body.Enabled = true
		else
			cb_delete.enabled = true
         dw_asst.Enabled = true
         dw_body.Enabled = true			
		end if
	
END CHOOSE

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_no, ll_ret
string Selt, ls_null, empty_chk = '1', ls_in_yn, ls_ord_ymd, ls_ord_no, ls_no, ls_flag
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN -1
IF dw_mast.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 마스터 */
idw_status = dw_mast.GetItemStatus(1, 0, Primary!)
if idw_status = NewModified! then
		select 
		right('0000'+ rtrim(convert(char(4),convert(int,
		isnull((select max(ord_no) from tb_21020_m where brand = :is_brand and ord_ymd = :is_ord_ymd and ord_no < '2000'),'0000')
		) +1)),4)
			into :is_ord_no
		from dual;
		
		dw_mast.Setitem(1, "ord_no", is_ord_no)
		dw_mast.Setitem(1, "reg_id", gs_user_id)
elseif idw_status = DataModified! then		
		dw_mast.Setitem(1, "mod_id", gs_user_id)
		dw_mast.Setitem(1, "mod_dt", ld_datetime)	
end if


select 
convert(int,
isnull((select max(no) from tb_21021_d where brand = :is_brand and ord_ymd = :is_ord_ymd and ord_no = :is_ord_no),'0000')
) +1
	into :ll_no
from dual;


FOR i=1 TO dw_body.rowcount()
		idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		Selt = dw_body.getitemstring(i,"selt")

		
		IF idw_status = NewModified! THEN				/* New Record */		
				if selt = 'Y' then 
					dw_body.Setitem(i, "ord_no", is_ord_no)
					dw_body.Setitem(i, "no", string(ll_no,"0000"))
					dw_body.Setitem(i, "reg_id", gs_user_id)
					ll_no = ll_no+1
				else
					dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
				end if
				
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
				dw_body.Setitem(i, "mod_id", gs_user_id)
				dw_body.Setitem(i, "mod_dt", ld_datetime)

/*** 일마감 배치처리로 대체 ***/
//				idw_status = dw_body.GetItemStatus(i, "in_yn", Primary!)
//				if idw_status = DataModified! then
//						ls_ord_ymd = dw_body.getitemstring(i,"ord_ymd")
//						ls_ord_no  = dw_body.getitemstring(i,"ord_no")
//						ls_in_yn   = dw_body.getitemstring(i,"in_yn")
//						ls_no      = dw_body.getitemstring(i,"no")											
//					 	DECLARE sp_auto_smat_ipgo PROCEDURE FOR sp_auto_smat_ipgo  
//								@brand 		= :is_brand,
//								@ord_ymd		= :ls_ord_ymd,
//								@ord_no		= :ls_ord_no,
//								@no		   = :ls_no,
//								@inout_gbn	= :ls_in_yn;
//									
//						 execute sp_auto_smat_ipgo;	
//						 
//				end if

		END IF

 	   
		if Selt = 'Y' then 
				empty_chk = '0'
		end if	
NEXT


il_rows = dw_mast.Update(TRUE, FALSE)	
if il_rows = 1 then	
		il_rows = dw_body.Update(TRUE, FALSE)
end if



//if dw_mast.rowcount() = 0 then
//	il_rows = dw_body.Update(TRUE, FALSE)
//	if il_rows = 1 then	
//			il_rows = dw_mast.Update(TRUE, FALSE)
//	end if
//else
//	il_rows = dw_mast.Update(TRUE, FALSE)	
//	if il_rows = 1 then	
//			il_rows = dw_body.Update(TRUE, FALSE)
//	end if
//
//end if

if il_rows = 1 then				
		commit  USING SQLCA;	
				
		ls_flag = dw_body.getitemstring(1,"flag")	
		if ls_flag = 'New' then
			for i = 1 to dw_body.rowcount()			
				dw_body.setitem(i,"selt","N")
				
			next
		end if		
		
		dw_body.ResetUpdate()

else
   	rollback  USING SQLCA;
end if



for i = 1 to dw_body.rowcount()
	ls_flag = dw_body.getitemstring(i,"flag")	
	if ls_flag = "New" then		
		dw_body.SetItemStatus(i, 0, Primary!, New!)
	else
		dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
	end if
next 
		

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)


il_rows = dw_list.retrieve(dw_head.Getitemstring(1, "brand"), dw_head.Getitemstring(1, "ord_ymd"), '', dw_head.Getitemstring(1, "ord_origin"))


return il_rows




end event

event ue_insert();long i

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(this.title)
		CASE 1
			IF this.Trigger Event ue_update() < 1 THEN

			END IF		
		CASE 3

	END CHOOSE
END IF
ib_changed = false


IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN	
if LenA(is_ord_ymd) <> 8 then 
	MessageBox("확인","발주일자를 입력하십시요!")
	dw_head.setcolumn("ord_ymd")
	return 
end if


il_rows = dw_mast.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin, 'New', gs_user_id)
if il_rows > 0 then	
	dw_mast.SetItemStatus(1, 0, Primary!, New!)

	IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN
	if isnull(is_ord_emp) or is_ord_emp = "" then dw_mast.Setitem(1, "ord_emp", gs_user_id)
	
	il_rows = dw_asst.retrieve(is_ord_origin)
	il_rows = dw_body.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin, 'New', il_over_rate)
	if il_rows <= 0 then
		messagebox("확인","검색된 데이타가 없습니다..")
	else
		
		for i = 1 to il_rows
			dw_body.SetItemStatus(i, 0, Primary!, New!)
		next 
		
		dw_mast.setfocus()
		dw_mast.setcolumn("cust_cd")

	end if	
end if
	


this.Trigger Event ue_button(2, il_rows)
this.Trigger Event ue_msg(2, il_rows)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_claim_cust_nm ,ls_ord_emp, ls_mat_cd, ls_style ,ls_chno, ls_smat_confirm
Boolean    lb_check 
Decimal chk_code
DataStore  lds_Source

is_brand = dw_head.getitemstring(1,'brand')
CHOOSE CASE as_column
	CASE "cust_cd"				

			
			IF ai_div = 1 THEN
				if not isnull(as_data) then
					select count(custcode)
					into :chk_code
					from VI_91102_1
					where custcode like '%' + :as_data 
						   or cust_name like '%' + :as_data + '%';
					
					if chk_code = 0 then
						messagebox('확인','발주업체 코드를 확인해주세요.')
						dw_mast.SetItem(al_row, "cust_cd", '')
						return 2
					end if
				end if
				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_mast.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 

				gst_cd.default_where   = "Where change_gubn = '00'"      + &
												 "  and cust_code between '5000' and '9999'"

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_mast.SetRow(al_row)
				dw_mast.SetColumn(as_column)
				dw_mast.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_mast.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
				/* 다음컬럼으로 이동 */
				dw_mast.scrolltorow(1)
				dw_mast.SetColumn("cust_cd")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source


	CASE "ord_origin"
		dw_head.setitem(1,"smat_confirm","0")
		if MidA(as_data,2,1) <> '2' then		
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				END IF 
			END IF	

			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "제품 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "Where brand     = '" + is_brand + "' " 

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " style like '" + LeftA(as_data,8) +"%'"
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
				dw_head.SetItem(al_row, "ord_origin", lds_Source.GetItemString(1,"style")+lds_Source.GetItemString(1,"chno"))



//////////////////2006/06/24 부터 폐기 김도균 (발주서단위로 관리)/////////////////////
//
//						
//							
//				ls_style = lds_Source.GetItemString(1,"style")
//				ls_chno = lds_Source.GetItemString(1,"chno")
//	
//				select isnull(smat_confirm,'0') into :ls_smat_confirm from tb_12021_d (nolock) where style = :ls_style and chno = :ls_chno;
//		
//				dw_head.object.smat_confirm.visible = true
//				if ls_smat_confirm <> '0' then
//						dw_head.object.smat_confirm.visible = false
//				end if
//
///////////////////////////////////////

				
				


				/* 다음컬럼으로 이동 */
				dw_head.scrolltorow(1)
				dw_head.SetColumn("ord_origin")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source	
				
		else
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
//				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
//				   dw_master.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
//					RETURN 0
				END IF 
			END IF

			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com913" 
			gst_cd.default_where   = "Where brand     = '" + is_brand + "'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " mat_cd like '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "ord_origin", lds_Source.GetItemString(1,"mat_cd"))
//				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))

				/* 다음컬럼으로 이동 */
//				dw_head.post event ue_addnew(as_data,al_row)
//				dw_head.SetColumn("color")					
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
		end if
	CASE "ord_emp"				
			IF ai_div = 1 THEN 
				if isnull(as_data) or as_data = "" then
					return 0	
				elseIF gf_emp_nm(as_data,  ls_ord_emp) = 0 THEN
				   dw_mast.SetItem(al_row, "ord_emp_nm", ls_ord_emp)
					RETURN 0
				END IF 
			END IF		
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "where goout_gubn = '1'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (empno LIKE '%" + as_data + "%' or kname like '%" + as_data + "%')"
			ELSE
				gst_cd.Item_where = ""
			END IF
			
			

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_mast.SetRow(al_row)
				dw_mast.SetColumn(as_column)
				dw_mast.SetItem(1, "ord_emp", lds_Source.GetItemString(1,"empno"))
				dw_mast.SetItem(1, "ord_emp_nm", lds_Source.GetItemString(1,"kname"))

				/* 다음컬럼으로 이동 */
//				dw_mast.setcolumn("bigo")
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

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result

If li_result = 3 Then Return

is_brand   = dw_mast.getitemstring(1, "brand")
is_ord_ymd = dw_mast.GetItemstring(1, "ord_ymd")
is_ord_no  = dw_mast.getitemstring(1, "ord_no")

if isnull(is_ord_no)  then return

This.Trigger Event ue_title()



dw_print.Retrieve(is_brand, is_ord_ymd, is_ord_no)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
	dw_print.Object.DataWindow.Print.Orientation	 = 2
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result


If li_result = 3 Then Return
is_brand   = dw_mast.getitemstring(1,"brand")
is_ord_ymd = dw_mast.GetItemstring(1, "ord_ymd")
is_ord_no   = dw_mast.getitemstring(1,"ord_no")

if isnull(is_ord_no) then return

This.Trigger Event ue_title ()
//dw_print.object.t_house.text =t_house.text
dw_print.Object.DataWindow.Print.Orientation	 = 2
dw_print.Retrieve(is_brand, is_ord_ymd, is_ord_no)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_delete();call super::ue_delete;if dw_body.rowcount() = 0 then 
	dw_mast.deleterow(1)
	cb_update.enabled = true
end if
end event

event pfc_postopen();call super::pfc_postopen;String ls_style_no

ls_style_no = gsv_cd.gs_cd10

if isnull(ls_style_no) = false then 
	dw_head.setitem(1,"ord_origin",gsv_cd.gs_cd10)

	if gs_brand = "K"  then
	   dw_head.setitem(1, "brand", 'K') 
	else
		dw_head.setitem(1,"brand",MidA(ls_style_no,1,1))	
	end if
	This.Trigger Event ue_retrieve()
end if	
end event

type cb_close from w_com020_e`cb_close within w_21004_e
integer taborder = 150
end type

type cb_delete from w_com020_e`cb_delete within w_21004_e
integer taborder = 90
end type

type cb_insert from w_com020_e`cb_insert within w_21004_e
integer taborder = 60
boolean enabled = true
end type

event cb_insert::clicked;IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN

			END IF		
		CASE 3

	END CHOOSE
END IF

ib_changed = false
Parent.Trigger Event ue_insert()
dw_mast.setitem(1,"brand",is_brand)
dw_mast.setitem(1,"ord_ymd",is_ord_ymd)
//dw_mast.setitem(1,"ord_origin",is_ord_origin)
dw_mast.setfocus()
dw_mast.setcolumn("ord_origin")

end event

type cb_retrieve from w_com020_e`cb_retrieve within w_21004_e
end type

type cb_update from w_com020_e`cb_update within w_21004_e
integer taborder = 140
end type

type cb_print from w_com020_e`cb_print within w_21004_e
integer taborder = 110
end type

type cb_preview from w_com020_e`cb_preview within w_21004_e
integer taborder = 120
end type

type gb_button from w_com020_e`gb_button within w_21004_e
integer x = 9
end type

type cb_excel from w_com020_e`cb_excel within w_21004_e
integer taborder = 130
end type

type dw_head from w_com020_e`dw_head within w_21004_e
integer x = 23
integer width = 3602
integer height = 184
string dataobject = "d_21004_h02"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

end event

event dw_head::buttonclicked;//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//
//			END IF		
//		CASE 3
//
//	END CHOOSE
//END IF
//ib_changed = false
//
//if dwo.name = 'cb_ord_info' then
//	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN	
//	il_rows = dw_list.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin)
//	il_rows = dw_mast.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin, 'New')
//
//	if il_rows > 0 then
//		IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN
//		il_rows = dw_asst.retrieve(is_ord_origin)
//		il_rows = dw_body.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin, 'New')
//		if il_rows <= 0 then
//			messagebox("확인","검색된 데이타가 없습니다..")
//		else
//			dw_mast.setfocus()
//			dw_mast.setcolumn("cust_cd")
//		end if	
//	end if
//		
//end if
//
//parent.Trigger Event ue_button(2, il_rows)
//parent.Trigger Event ue_msg(2, il_rows)
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_ord_origin, ls_style ,ls_chno, ls_smat_confirm

CHOOSE CASE dwo.name
	CASE "ord_origin"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

// 2006/06/24부터 폐기(김도균)--발주서단위로 관리						
//	case "smat_confirm"
//
//		ls_ord_origin = this.getitemstring(1,"ord_origin")
//			
//			
//		ls_style = left(ls_ord_origin,8)
//		ls_chno = mid(ls_ord_origin,9,1)
//
//		
//		update tb_12021_d set smat_confirm = 'A' 
//		where style = :ls_style 
//		and   chno  = :ls_chno 
//		and   isnull(smat_confirm,'0') = '0';			
//
//		commit  USING SQLCA;
	
			
END CHOOSE

end event

event dw_head::editchanged;call super::editchanged;choose case dwo.name
	case "ord_origin"
		if LenA(data) = 1 then this.setitem(1,"brand",data)			

			
end choose
end event

type ln_1 from w_com020_e`ln_1 within w_21004_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_21004_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_21004_e
integer y = 1000
integer height = 1072
string dataobject = "d_21004_l01"
end type

event dw_list::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_rows
string ls_flag

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

is_brand      = This.GetItemString(row, 'brand') /* DataWindow에 Key 항목을 가져온다 */
is_ord_ymd    = This.GetItemString(row, 'ord_ymd')
is_ord_no     = This.GetItemString(row, 'ord_no')
is_ord_origin = This.GetItemString(row, 'ord_origin')

//messagebox("is_brand",is_brand)
//messagebox("is_ord_ymd",is_ord_ymd)
//messagebox("is_ord_no",is_ord_no)
//messagebox("is_ord_origin",is_ord_origin)

IF IsNull(is_brand) or IsNull(is_ord_ymd) or IsNull(is_ord_no) THEN return
il_rows = dw_asst.retrieve(is_ord_origin)
il_rows = dw_mast.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin, 'Dat', gs_user_id)
if il_rows > 0 then
	cb_3.visible = True //일일입고마감 버튼 활성화
	
	ll_rows = dw_body.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin, 'Dat', il_over_rate)
	if is_ord_origin <> dw_1.getitemstring(1,"ord_origin") then
		il_rows = dw_1.retrieve(is_ord_origin)

		for i = 1 to il_rows
			ls_flag = dw_1.getitemstring(i,"flag")
			if ls_flag = "New" then
				dw_1.SetItemStatus(i, 0, Primary!, New!)
			end if
		next
	end if
	
end if

Parent.Trigger Event ue_button(7, ll_rows)
Parent.Trigger Event ue_msg(1, ll_rows)
end event

type dw_body from w_com020_e`dw_body within w_21004_e
event ue_zero_check ( long row )
event ue_addnew ( string ord_origin,  long row )
integer y = 1004
integer width = 2802
integer height = 1072
string dataobject = "d_21004_d01"
boolean hscrollbar = true
end type

event dw_body::ue_zero_check(long row);decimal ll_amt
string ls_bigo, ls_mat_cd, ls_color, ls_bigo_in,ls_space

ll_amt = this.getitemnumber(row,"amt")
if isnull(ll_amt) or ll_amt <=0 then 
	
	messagebox("Data Err", "발주량이나 발주단가를 올바로 입력하세요..")
	this.setitem(row,"selt",'N')
	this.setcolumn("qty")	
		
end if
	
//------------------
ls_mat_cd  = this.getitemstring(row,"mat_cd")
ls_color   = this.getitemstring(row,"color")
ls_bigo_in = dw_mast.getitemstring(1,"bigo")

if isnull(ls_bigo_in) or ls_bigo_in = '' then ls_bigo_in = ''

if isnull(ls_bigo_in) or ls_bigo_in = '' then  
	ls_space = 'N'
else 
	ls_space = 'Y'
end if	

//messagebox("ls_space", ls_space)

// 펑션에도 부자재 코드 적용필요


if upper(is_brand) = "I" then
	
	select isnull(dbo.SF_label_info_color(:is_ord_origin,:ls_color),'')
	into :ls_bigo
	from dual where :ls_mat_cd like '%L00040' ;
	
elseif upper(is_brand) = "S" then
	
	select isnull(dbo.SF_label_info_color(:is_ord_origin, :ls_color),'')
	into :ls_bigo
	from dual 
	where :ls_mat_cd like '%[A]0000[1-9]';
	
	
	if ls_bigo = '' then
		select isnull(dbo.SF_label_info_color(:is_ord_origin, :ls_color),'')
		into :ls_bigo
		from dual where ( :ls_mat_cd like '%L09010' or :ls_mat_cd like '%B00010'  or :ls_mat_cd like '%L00080' or :ls_mat_cd like '%L00008' or :ls_mat_cd like '%L00040' or :ls_mat_cd like '%L00100'  or :ls_mat_cd like '%L00101' or :ls_mat_cd like '%L00005' or :ls_mat_cd like '%L00013' or :ls_mat_cd like '%L00010' or :ls_mat_cd like '%L00040') ;	
	end if
	

else 
	
select isnull(dbo.SF_label_info_color(:is_ord_origin, :ls_color),'')
into :ls_bigo
from dual where ( :ls_mat_cd like '%L09010' or :ls_mat_cd like '%B00010'  or :ls_mat_cd like '%L00080' or :ls_mat_cd like '%L00008' or :ls_mat_cd like '%L00040' or :ls_mat_cd like '%L00100'  or :ls_mat_cd like '%L00101' or :ls_mat_cd like '%L00005' or :ls_mat_cd like '%L00013' or :ls_mat_cd like '%L00010' or :ls_mat_cd like '%L00040') ;	

end if

//-------------------
if ls_bigo <> '' then 
	if ls_space = 'Y' then
//		ls_bigo = ls_bigo_in + '~n:' + ls_bigo
		ls_bigo = ls_bigo_in + ':' + ls_bigo
	else 	
		ls_bigo = ls_bigo_in + ':' + ls_bigo
	end if	
	dw_mast.setitem(1,"bigo",ls_bigo)
end if
end event

event dw_body::ue_addnew;string ls_brand , ls_ord_ymd, ls_ord_no, ls_ord_origin

long i

IF dw_body.AcceptText() <> 1 THEN RETURN
ls_brand = dw_mast.getitemstring(1,"brand")
ls_ord_ymd = dw_mast.getitemstring(1,"ord_ymd")
ls_ord_no = dw_mast.getitemstring(1,"ord_no")
ord_origin = dw_body.getitemstring(row,"mat_cd")

// 새로운 로에 추가

il_rows = dw_body2.retrieve(ls_brand, ls_ord_ymd, ls_ord_no, ord_origin, 'N')
if il_rows > 0 then	
	dw_body2.rowscopy(1,1,Primary!,dw_body,row,Primary!)
	dw_body.deleterow(row+1)
end if

end event

event dw_body::constructor;datawindowchild ldw_child

this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()
end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
datetime ld_datetime
string ls_null, ls_ord_origin, ls_mat_cd, ls_mat_nm, ls_color, ls_expert_yn
long li_ret

choose case  dwo.name 
	case "selt" 
				ls_expert_yn = dw_mast.getitemstring(1,"expert_yn")
				if ls_expert_yn = 'Y' and data = 'Y' then
					ls_ord_origin = dw_mast.getitemstring(1,"ord_origin")
					ls_mat_cd = dw_body.getitemstring(row,"mat_cd")
					ls_mat_nm = dw_body.getitemstring(row,"mat_nm")				
					ls_color = dw_body.getitemstring(row,"color")				
	
					li_ret = uf_expert_yn(ls_ord_origin, ls_mat_cd, ls_color)
					if li_ret = 1 then 					
						messagebox("주의", "이전에 이미 수출처리된 내역이 존재합니다.."+ls_mat_cd+"("+ls_mat_nm+")")
						return 0
					end if
				end if
				
		post event ue_zero_check(row)
	case "mat_cd"

     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "dlvy_ymd"
		if data <> '' then
			if not gf_datechk(data) then return 1
		end if
	case "cf_yn"
		IF not gf_cdate(ld_datetime,0)  THEN  	return 1
		if string(data) = '1' then
			this.setitem(row,"cf_ymd",string(ld_datetime,"yyyymmdd"))
		else
			this.setitem(row,"cf_ymd",ls_null)
		end if
end choose

	
end event

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

event dw_body::clicked;call super::clicked;il_body_row = row
end event

event dw_body::dberror;//
end event

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
string ls_modify, ls_gubn
long i, ll_gubn
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

CHOOSE CASE dwo.name
	CASE "cb_fin_yn"  
			ls_gubn = this.getitemstring(1,"fin_yn")
			if ls_gubn = "Y" then 
				ls_gubn = "N"
			else 
				ls_gubn = "Y"
			end if
			
			for i= 1 to this.rowcount()
				this.setitem(i,"fin_yn",ls_gubn)			
			next 

CASE "cb_prot"			
			ll_gubn = this.getitemnumber(1,"prot")
			if ll_gubn = 1 then 
				ll_gubn = 0
			else 
				ll_gubn = 1
			end if
			
			for i= 1 to this.rowcount()
				this.setitem(i,"prot",ll_gubn)			
			next 

	CASE "cb_in_yn"
			ls_gubn = this.getitemstring(1,"in_yn")
			if ls_gubn = "Y" then 
				ls_gubn = "N"
			else 
				ls_gubn = "Y"
			end if
			
			for i= 1 to this.rowcount()
				this.setitem(i,"in_yn",ls_gubn)			
			next 

	CASE "cb_price_ok" 
			ls_gubn = this.getitemstring(1,"price_ok")
			if ls_gubn = "Y" then 
				ls_gubn = "N"
			else 
				ls_gubn = "Y"
			end if
			
			for i= 1 to this.rowcount()
				this.setitem(i,"price_ok",ls_gubn)			
			next 
						
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_21004_e
integer y = 1004
integer height = 1064
end type

type dw_print from w_com020_e`dw_print within w_21004_e
integer x = 0
integer y = 296
integer width = 1115
integer height = 316
string dataobject = "d_21004_r01"
end type

type dw_mast from datawindow within w_21004_e
event ue_keydown pbm_dwnkey
integer x = 27
integer y = 368
integer width = 2857
integer height = 536
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_21004_h01"
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
		IF this.GetColumnName() <> "bigo" THEN
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
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
END CHOOSE

Return 0
end event

event constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("pay_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('007')

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

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


//if dwo.name = 'cb_bom_info' then
//	IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN
//	il_rows = dw_body.retrieve(is_brand, is_ord_ymd, is_ord_no, is_ord_origin, Flag)
//	if il_rows <= 0 then
//		messagebox("확인","검색된 데이타가 없습니다..")
//	end if	
//end if


end event

event editchanged;string ls_null
choose case dwo.name
	case "cust_cd"
		this.setitem(1,"cust_nm",ls_null)
	case "ord_emp"
		this.setitem(1,"ord_emp_nm",ls_null)
end choose

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
long i, li_ret
string ls_selt, ls_ord_origin, ls_mat_cd, ls_mat_nm, ls_color, ls_expert_yn

CHOOSE CASE dwo.name

	CASE "cust_cd","ord_emp"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "expert_yn"		// 부자재 중복수출 방지 확인창
		IF dw_mast.AcceptText() <> 1 THEN RETURN -1
		if data = 'Y' then 

		
			for i = 1 to dw_body.rowcount()
				ls_selt = dw_body.getitemstring(i,"selt")
	
				if ls_selt = 'Y' then
					ls_ord_origin = dw_mast.getitemstring(1,"ord_origin")
					ls_mat_cd = dw_body.getitemstring(i,"mat_cd")
					ls_mat_nm = dw_body.getitemstring(i,"mat_nm")				
					ls_color = dw_body.getitemstring(i,"color")				
	
					li_ret = uf_expert_yn(ls_ord_origin, ls_mat_cd, ls_color)
					if li_ret = 1 then 					
						messagebox("주의", "이전에 이미 수출처리된 내역이 존재합니다.."+ls_mat_cd+"("+ls_mat_nm+")")
						return 0
					end if
				end if
			next 
		end if		
END CHOOSE

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

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event dberror;
/*===========================================================================*/
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




end event

type dw_asst from datawindow within w_21004_e
event type long apply_qty_set ( )
integer x = 2889
integer y = 368
integer width = 722
integer height = 408
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_21004_d02"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event type long apply_qty_set();long i,j, ll_prot, ll_body_rows, ll_asst_rows
string ls_asst_color, ls_body_color
decimal ll_req_qty, ll_apply_qty, ll_qty, ll_price, ll_amt 

IF this.AcceptText() <> 1 THEN RETURN -1

ll_prot = dw_mast.getitemnumber(1,"Prot")
if ll_prot = 1 then 
	messagebox("확인","입고된 발주서는 수정할수 없습니다..")
	return -1
end if

ll_asst_rows = dw_asst.rowcount()		
if ll_asst_rows <= 0 then return -1

ll_body_rows = dw_body.rowcount()		
if ll_body_rows <= 0 then return -1

for i = 1 to ll_asst_rows
	ls_asst_color = dw_asst.getitemstring(i,"color")
	ll_apply_qty  = dw_asst.getitemnumber(i,"apply_qty")
	for j = 1 to ll_body_rows
		ls_body_color = dw_body.getitemstring(j,"color")
		if ls_asst_color = ls_body_color then
			ll_req_qty = dw_body.getitemnumber(j,"req_qty")
			dw_body.setitem(j,"qty",round(ll_apply_qty * ll_req_qty* ( 1 + il_over_rate*0.01),0) )					
		end if
	next						
next 



	
end event

event constructor;datawindowchild ldw_child


this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

end event

event buttonclicked;long i,j, ll_prot, ll_body_rows, ll_asst_rows
string ls_asst_color, ls_body_color
decimal ll_req_qty, ll_apply_qty, ll_qty, ll_price, ll_amt 

choose case dwo.name
	case "cb_apply"
		post event apply_qty_set()
		
end choose

	
end event

type dw_body2 from datawindow within w_21004_e
boolean visible = false
integer x = 951
integer y = 1088
integer width = 2002
integer height = 340
integer taborder = 80
string title = "none"
string dataobject = "d_21004_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_over_rate from singlelineedit within w_21004_e
integer x = 2062
integer y = 920
integer width = 142
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

event modified;il_over_rate = long(this.text)
end event

type st_2 from statictext within w_21004_e
integer x = 1737
integer y = 936
integer width = 567
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "추가발주율:       %"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_21004_e
boolean visible = false
integer x = 3493
integer y = 212
integer width = 434
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "부자재 출고관리"
end type

event clicked;dw_1.visible = true
end event

type dw_1 from datawindow within w_21004_e
boolean visible = false
integer x = 1330
integer y = 780
integer width = 2290
integer height = 1268
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "부자재 출고내역"
string dataobject = "d_21004_d04"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
//ib_changed = true
//cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

choose case  dwo.name 
	case "out_ymd"
		if data <> '' then
			if not gf_datechk(data) then return 1
		end if
end choose

	
end event

event buttonclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_1.RowCount()
IF dw_1.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//FOR i=1 TO ll_row_count
//   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */
//      dw_1.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_1.Setitem(i, "mod_id", gs_user_id)
//      dw_1.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT
//

il_rows = dw_1.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_1.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if



end event

type dw_copy_ord from datawindow within w_21004_e
boolean visible = false
integer x = 891
integer y = 1104
integer width = 1481
integer height = 448
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "부자재 발주서 복사"
string dataobject = "d_21004_d10"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
end type

event buttonclicked;string ls_fr_ord_origin, ls_to_ord_origin, ls_ord_ymd


choose case dwo.name
	case "cb_copy_ord"
			IF dw_copy_ord.AcceptText() <> 1 THEN RETURN -1
			
			ls_fr_ord_origin = dw_copy_ord.getitemstring(1,"fr_ord_origin")
			ls_to_ord_origin = dw_copy_ord.getitemstring(1,"to_ord_origin")
			ls_ord_ymd       = dw_body.getitemstring(1,"ord_ymd")
			
//			messagebox("ord_ymd",ls_ord_ymd)
			
			
			if LenA(ls_fr_ord_origin) < 9 then 
				 messagebox("확인","스타일번호를 다시 확인 하세요...")
				return -1
			end if

			
			if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return			
			
			DECLARE sp_copy_ord PROCEDURE FOR sp_copy_ord  
					@ord_ymd       = :ls_ord_ymd,
					@fr_ord_origin	= :ls_fr_ord_origin,
					@to_ord_origin	= :ls_to_ord_origin,
					@mod_id		   = :gs_user_id;
						
			execute sp_copy_ord;		
			 
//			commit  USING SQLCA;
			messagebox("확인","정상처리되었슴니다...")
			dw_copy_ord.visible = false
			dw_copy_ord.reset()
			 
end choose

end event

type cb_copy_ord from commandbutton within w_21004_e
integer x = 2569
integer y = 920
integer width = 571
integer height = 80
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "부자재 발주서 복사"
end type

event clicked;
		dw_copy_ord.reset()
		dw_copy_ord.insertrow(0)
		dw_copy_ord.setitem(1,"fr_ord_origin", is_ord_origin)
		dw_copy_ord.visible = true
		dw_copy_ord.setcolumn("to_ord_origin")
		dw_copy_ord.setfocus()
end event

type cb_invoice from commandbutton within w_21004_e
integer x = 3250
integer y = 220
integer width = 658
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "인보이스 미등록 리스트"
end type

event clicked;string ls_brand
ls_brand = dw_head.getitemstring(1,"brand")

il_rows = dw_2.retrieve(ls_brand, is_ord_ymd, '')
dw_2.visible = true
end event

type dw_2 from datawindow within w_21004_e
boolean visible = false
integer x = 3255
integer y = 312
integer width = 713
integer height = 1732
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_21004_d05"
boolean controlmenu = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;string ls_ord_origin, ls_style, ls_chno
ls_style = dw_2.getitemstring(row,"style")
ls_chno = dw_2.getitemstring(row,"chno")

ls_ord_origin = ls_style + ls_chno

dw_3.retrieve(ls_ord_origin)
dw_3.visible=true


end event

type dw_3 from datawindow within w_21004_e
boolean visible = false
integer x = 2619
integer y = 556
integer width = 3049
integer height = 1516
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_21004_d06"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;CHOOSE CASE dwo.name
	CASE "cb_save"		
			il_rows = dw_3.Update(TRUE, FALSE)
			commit  USING SQLCA;	

end choose

end event

type dw_4 from datawindow within w_21004_e
integer x = 2245
integer y = 1012
integer width = 1280
integer height = 1108
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "소요량변경 작지"
string dataobject = "d_21004_d07"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;
this.retrieve()

	
end event

type cb_2 from commandbutton within w_21004_e
integer x = 3200
integer y = 916
integer width = 466
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "납기일 전체적용"
end type

event clicked;string ls_dlvy_ymd
long i

ls_dlvy_ymd = dw_body.getitemstring(1,"dlvy_ymd")

for i = 2 to dw_body.rowcount()
	dw_body.setitem(i,"dlvy_ymd",ls_dlvy_ymd)
next

end event

type cb_3 from commandbutton within w_21004_e
boolean visible = false
integer x = 2834
integer y = 220
integer width = 411
integer height = 84
integer taborder = 160
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일일 입고마감"
end type

event clicked;string is_in_ymd, is_in_yn

//
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0

is_in_ymd = dw_body.GetItemString(1,'dlvy_ymd')
If isnull(is_in_ymd) or LenA(is_in_ymd) <> 8 or Trim(is_in_ymd) = '' then
	messagebox('확인','입고일자를 제대로 입력해주세요.')
	return 0
end if

is_in_yn = dw_body.GetItemString(1,'in_yn')
If isnull(is_in_yn) or Trim(is_in_yn) = 'N' then
	messagebox('확인','입고를 체크해주세요.')
	return 0
end if


if isnull(is_brand) or is_brand = '' then 
		messagebox("주의", "브랜드를 올바로 입력해주세요..") 
		return 0
end if


if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return 0

		 DECLARE sp_in_smat_daily PROCEDURE FOR sp_in_smat_daily  
					@brand     = :is_brand,  
					@yymmdd	  = :is_in_ymd;
					
		 execute sp_in_smat_daily;	
	commit  USING SQLCA;
	
messagebox("확인","정상처리되었슴니다...")
end event

