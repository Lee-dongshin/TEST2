$PBExportHeader$w_23005_e.srw
$PBExportComments$자재생산계산서등록
forward
global type w_23005_e from w_com020_e
end type
type dw_magam from datawindow within w_23005_e
end type
type cb_sub_make from commandbutton within w_23005_e
end type
type dw_detail from datawindow within w_23005_e
end type
type st_2 from statictext within w_23005_e
end type
end forward

global type w_23005_e from w_com020_e
integer width = 3675
integer height = 2272
event type long ue_detail ( )
event ue_detail_set ( )
event ue_magam_chk ( )
event type boolean ue_magam_check ( )
dw_magam dw_magam
cb_sub_make cb_sub_make
dw_detail dw_detail
st_2 st_2
end type
global w_23005_e w_23005_e

type variables
string is_brand, is_bill_type, is_bill_date, is_bill_no, is_cust_cd , is_mat_type,  new, is_flag
long il_list_row, il_body_row, il_magam_row
dragobject   idrg_vertical2[1]

end variables

forward prototypes
public function integer wf_resizepanels ()
end prototypes

event ue_detail;string ls_bill_yymm, ls_bill_yymmdd, ls_Flag
long i
datawindowchild ldw_unit


	
		string ls_null
		setnull(ls_null)
		/* dw_head 필수입력 column check */
		IF dw_head.AcceptText() <> 1 THEN RETURN -1
		is_brand     = dw_head.GetItemString(1, "brand")
		is_bill_type = dw_head.GetItemString(1, "bill_type")
		is_bill_date = dw_head.GetItemString(1, "bill_date")
		is_bill_no   = dw_head.GetItemString(1, "bill_no")
		is_cust_cd   = dw_head.GetItemString(1, "cust_cd")
		

		this.trigger event ue_detail_set()


		il_rows = dw_detail.retrieve(is_brand, is_bill_date, is_bill_type, is_bill_no, is_cust_cd, 'New')					
		dw_body.reset()
		IF il_rows > 0 THEN
				il_rows = dw_magam.retrieve(is_brand, is_bill_date, is_bill_type, is_bill_no, is_cust_cd, 'New')
				dw_magam.object.t_apply_amt.text = string(dw_magam.getitemnumber(1,"s_amt"),"#,##0")

				il_rows = dw_body.retrieve(is_brand, is_bill_date, is_bill_type, is_bill_no, is_cust_cd, 'New')
				if il_rows <= 0 then
					dw_detail.reset()
					dw_magam.reset()
					return -1
				end if					

		END IF
		this.cb_update.enabled= true
		This.Trigger Event ue_button(1, il_rows)
		This.Trigger Event ue_msg(1, il_rows)
	
	
end event

event ue_detail_set;datawindowchild ldw_unit, ldw_chile

		choose case is_bill_type 
			case "01"	   //자재매입계산서
				dw_detail.dataobject = "d_23005_d02"
			case "02"		//생산임가공계산서
				dw_detail.dataobject = "d_23005_d03"
			case "03"		//자재판매계산서				
				dw_detail.dataobject = "d_23005_d04"
			case "04"	   //자재재가공계산서
				dw_detail.dataobject = "d_23005_d02"				
			case "05"		//클레임계산서
				dw_detail.dataobject = "d_23005_d05"
			case "06"		//서브임가공계산서
				dw_detail.dataobject = "d_23005_d06"
		end choose


		dw_detail.SetTransObject(SQLCA)

		dw_detail.getchild("unit",ldw_unit)
		ldw_unit.settransobject(sqlca)
		ldw_unit.retrieve('004')

			dw_detail.getchild("pay_gubn",ldw_chile)
		ldw_chile.settransobject(sqlca)
		ldw_chile.retrieve('007')
		
end event

event ue_magam_check;boolean ret
ret = true

decimal t_apply_amt, s_amt
t_apply_amt = dec(dw_magam.object.t_apply_amt.text)
s_amt = dw_magam.getitemnumber(1,"s_amt")

if t_apply_amt = s_amt then ret = false

return ret

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
//
//idrg_Vertical2[1].Move (st_1.X + ii_BarThickness, idrg_Vertical2[1].Y)
//idrg_Vertical2[1].Resize (ll_Width, idrg_Vertical2[1].Height)
//

Return 1

end function

on w_23005_e.create
int iCurrent
call super::create
this.dw_magam=create dw_magam
this.cb_sub_make=create cb_sub_make
this.dw_detail=create dw_detail
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_magam
this.Control[iCurrent+2]=this.cb_sub_make
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.st_2
end on

on w_23005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_magam)
destroy(this.cb_sub_make)
destroy(this.dw_detail)
destroy(this.st_2)
end on

event ue_retrieve;/*============================================================================*/
/* 작성자      : (주)지우정보 ()                                      			*/	
/* 작성일      : 2001..                                                  		*/	
/* 수정일      : 2001..                                                  		*/
/*============================================================================*/
string ls_null
long i
setnull(ls_null)
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_bill_date, is_bill_type, is_bill_no, is_cust_cd, is_flag)
dw_body.Reset()
dw_magam.reset()
dw_detail.reset()	
IF il_rows > 0 THEN
   dw_list.SetFocus()	
else
	return
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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
is_bill_type = dw_head.GetItemString(1, "bill_type")
is_bill_date = dw_head.GetItemString(1, "bill_date")
is_bill_no = dw_head.GetItemString(1, "bill_no")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")

//messagebox("is_bill_date", is_bill_date)


if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_sub_make, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
//inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_detail, "ScaleToRight&bottom")
inv_resize.of_Register(dw_magam, "ScaleToRight")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_detail

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_magam.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
new = 'New'
datetime ld_datetime



//idrg_Vertical2[1] = dw_detail

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"bill_date",string(ld_datetime,"yyyymmdd"))

end if


end event

event ue_insert;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable


oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	is_flag = "New"
	this.Trigger Event ue_retrieve()	//조회
	if dw_list.rowcount() > 0 then cb_insert.Enabled = False
ELSE
	this.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)


end event

event type long ue_update();/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_no, t_row, ll_pay_chk
datetime ld_datetime
string ls_bill_date, ls_sppl_date, ls_mangi_date, ls_new, ls_iwol_yn, ls_pay_gubn, t_pay_gubn
string ls_null, Flag
decimal ll_amt, ll_date_chk

setnull(ls_null)

setnull(ls_bill_date)
setnull(ls_sppl_date)
setnull(ls_mangi_date)

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText()   <> 1 THEN RETURN -1
IF dw_detail.AcceptText() <> 1 THEN RETURN -1
IF dw_magam.AcceptText()  <> 1 THEN RETURN -1

is_brand     = dw_body.GetItemString(1, "brand")
is_bill_type = dw_body.GetItemString(1, "bill_type")
is_bill_date = dw_body.GetItemString(1, "bill_date")
is_bill_no   = dw_body.GetItemString(1, "bill_no")
is_cust_cd   = dw_body.GetItemString(1, "cust_cd")
ls_pay_gubn  = dw_body.GetItemString(1, "pay_gubn")
is_cust_cd   = dw_body.GetItemString(1, "cust_cd")

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



if  IsNull(is_bill_date) = false and Trim(is_bill_date) <> "" THEN
	
	select isdate(:is_bill_date)
	into :ll_date_chk
	from dual;
	
	IF ll_date_chk = 0  then
		messagebox("경고!", "계산서 번호 일자를 다시 확인하세요!")
		Return 0
	END IF
	
end if

select convert(char(10),  dateadd(day, 0 , :is_bill_date), 102)
into :is_bill_date
from dual;

//messagebox("is_bill_date", is_bill_date)

//*********** master 
idw_status = dw_body.GetItemStatus(1, 0, Primary!)
ll_amt  = dec(dw_body.getitemnumber(1,"amt"))

if ll_amt = 0 then
	il_rows = dw_body.DeleteRow(1)
	
elseIF idw_status = NewModified! THEN	
	
	select 
	right('0000'+ rtrim(convert(char(4),convert(int,
	isnull((select max(bill_no) from tb_23021_h where brand = :is_brand and bill_date = :is_bill_date),'0000')
	) +1)),4)
		into :is_bill_no
	from dual;
	dw_body.Setitem(1, "bill_date", is_bill_date)	
	dw_body.Setitem(1, "bill_no", is_bill_no)
	dw_body.Setitem(1, "reg_id", gs_user_id)
ELSEif idw_status = DataModified! then									/* Modify Record */
	dw_body.Setitem(1, "bill_date", is_bill_date)		
	dw_body.Setitem(1, "mod_id", gs_user_id)
	dw_body.Setitem(1, "mod_dt", ld_datetime)
END IF


//************ detail

FOR i=1 TO dw_detail.rowcount()
	ls_iwol_yn = dw_detail.getitemstring(i,"iwol_yn")
//	ll_pay_chk = dw_detail.getitemnumber(i,"pay_chk")
//	if ll_pay_chk = 1 then 
//		dw_detail.setitem(i,"pay_gubn","01")
//	else
//		dw_detail.setitem(i,"pay_gubn",ls_pay_gubn)		
//	end if
		

	
	if ls_iwol_yn = "N" then
		dw_detail.setitem(i,"bill_date",is_bill_date)		
		dw_detail.setitem(i,"bill_no",is_bill_no)		
		

	else
		dw_detail.setitem(i,"bill_date",ls_null)		
		dw_detail.setitem(i,"bill_no",ls_null)				
	end if
	t_pay_gubn = dw_detail.Getitemstring(i,"pay_gubn")
	if isnull(t_pay_gubn) then t_pay_gubn = ls_pay_gubn
	dw_detail.Setitem(i,"pay_gubn","XX")
	dw_detail.Setitem(i,"pay_gubn",t_pay_gubn)

NEXT





il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then
	il_rows = dw_detail.Update(TRUE, FALSE)	
	if il_rows = 1 then
		 DECLARE sp_make_tb_23030_h PROCEDURE FOR sp_make_tb_23030_h  
					@brand     = :is_brand,   
					@bill_date = :is_bill_date,   
					@bill_type = :is_bill_type,   
					@bill_no   = :is_bill_no  ;
		execute sp_make_tb_23030_h;	
	end if
end if


if il_rows = 1 then
	dw_body.resetupdate()
	dw_detail.resetupdate()
   commit  USING SQLCA;
	This.Trigger Event ue_button(3, il_rows)
	This.Trigger Event ue_msg(3, il_rows)

	dw_list.setitem(il_list_row,"bill_no",is_bill_no)
	dw_list.setitem(il_list_row,"flag","Dat")

	is_brand     = dw_body.GetItemString(1, "brand")
	is_bill_type = dw_body.GetItemString(1, "bill_type")
	is_bill_date = dw_body.GetItemString(1, "bill_date")
	is_bill_no   = dw_body.GetItemString(1, "bill_no")
	is_cust_cd   = dw_body.GetItemString(1, "cust_cd")

	il_rows = dw_magam.retrieve(is_brand, is_bill_date, is_bill_type, is_bill_no, is_cust_cd, "Dat")
	if il_rows > 0 then
		dw_magam.object.t_apply_amt.text = string(dw_magam.getitemnumber(1,"s_amt"),"#,##0")
	else
		dw_magam.object.t_apply_amt.text = "0"
	end if
	
else
   rollback  USING SQLCA;
	This.Trigger Event ue_button(3, il_rows)
	This.Trigger Event ue_msg(3, il_rows)	
end if


return il_rows


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
String     ls_claim_cust_nm , ls_pay_gubn, ls_mangi_date, ls_mat_type, ls_bill_date
Boolean    lb_check 
DataStore  lds_Source

is_brand = dw_head.getitemstring(1,'brand')
CHOOSE CASE as_column
	case "pay_gubn"
			ls_pay_gubn  = string(as_data)
			ls_mat_type  = dw_body.getitemstring(1,"mat_type")
			ls_bill_date = dw_body.getitemstring(1,"bill_date")

			select 
				case when dbo.sf_inter_cd1('007',isnull(:ls_pay_gubn,'09')) > 0 then
					case when :ls_mat_type in ('6','C') then  //임가공, CMT
						case when right(:ls_bill_date,2) <= '15' then 
							convert(char(6),dateadd(month, cast(dbo.sf_inter_cd1('007',isnull(:ls_pay_gubn,'09')) as int)+1, convert(char(6),:ls_bill_date,112)+'28'),112) + '14'
						else
							convert(char(6),dateadd(month, cast(dbo.sf_inter_cd1('007',isnull(:ls_pay_gubn,'09')) as int)+1, convert(char(6),dateadd(month,1,:ls_bill_date),112)+'14'),112) + '28'
						end
					else 
						convert(char(6),dateadd(month, cast(dbo.sf_inter_cd1('007',isnull(:ls_pay_gubn,'09')) as int)+1, convert(char(6),dateadd(month,1,:ls_bill_date),112)+'22'),112) + '06'
					end	
				end 	into :ls_mangi_date
			from dual;
			
			dw_body.Setitem(1,"mangi_date", ls_mangi_date)
			ib_itemchanged = False 
			RETURN 0

	case "mat_type"
			ls_pay_gubn  = dw_body.getitemstring(1,"pay_gubn")
			ls_mat_type  = string(as_data)
			ls_bill_date = dw_body.getitemstring(1,"bill_date")

			select 
				case when dbo.sf_inter_cd1('007',isnull(:ls_pay_gubn,'09')) > 0 then
					case when :ls_mat_type in ('6','C') then  //임가공, CMT
						case when right(:ls_bill_date,2) <= '15' then 
							convert(char(6),dateadd(month, cast(dbo.sf_inter_cd1('007',isnull(:ls_pay_gubn,'09')) as int)+1, convert(char(6),replace(:ls_bill_date,'.',''),112)+'28'),112) + '14'
						else
							convert(char(6),dateadd(month, cast(dbo.sf_inter_cd1('007',isnull(:ls_pay_gubn,'09')) as int)+1, convert(char(6),dateadd(month,1,replace(:ls_bill_date,'.','')),112)+'14'),112) + '28'
						end
					else 
						convert(char(6),dateadd(month, cast(dbo.sf_inter_cd1('007',isnull(:ls_pay_gubn,'09')) as int)+1, convert(char(6),dateadd(month,1,replace(:ls_bill_date,'.','')),112)+'22'),112) + '06'
					end	
				end 	into :ls_mangi_date
			from dual;
			
			dw_body.Setitem(1,"mangi_date", ls_mangi_date)
			ib_itemchanged = False 
			RETURN 0
			
	CASE "cust_cd"				
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
			END IF
			IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand     = case when '" + is_brand + "'  in ('J','T','W','C','S','I') then 'N' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end "      + &
			                         "  and cust_code between '5000' and '8999'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_name like '%" + as_data + "%')" 
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
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
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
         dw_body.Enabled = true
         dw_magam.Enabled = true
		else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
//			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
				dw_magam.Enabled = true				
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
//			cb_preview.enabled = true
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
//         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = true
      cb_delete.enabled = false
//      cb_print.enabled = false
//      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_magam.Enabled = false		
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */		
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
//         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
//         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = true
//         cb_insert.enabled = true
      end if
END CHOOSE

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row, ll_rows
string ls_flag
ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
il_rows = dw_body.DeleteRow (ll_cur_row)
if il_rows > 0 then 
	dw_list.Setitem(il_list_row,"flag","New")
	dw_detail.reset()
	dw_magam.reset()
end if
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23005_e","0")
end event

event ue_print();	

//is_bill_type
//is_bill_no  
//is_cust_cd  
//is_mat_type 
//is_flag     

Long    i, ll_row, j, ll_row2
String ls_bill_date
ll_row = dw_body.RowCount()

ls_bill_date = MidA(is_bill_date,1,4) + '.' + MidA(is_bill_date,5,2) + '.' + MidA(is_bill_date,7,2)

//messagebox("is_bill_date", ls_bill_date + '/' + is_bill_type + '/' + is_bill_no + '/' + is_cust_cd + '/' + is_brand)


IF dw_print.Retrieve(ls_bill_date, is_bill_type, is_bill_no, is_cust_cd, is_brand) > 0 THEN
	
	dw_print.inv_printpreview.of_SetZoom()

//		dw_print.Print()
END IF 

end event

event ue_excel();/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
//li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)

li_ret = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
	if li_ret = 1 then
		li_ret = dw_detail.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
	else 	
		li_ret = dw_detail.SaveAs(ls_doc_nm, Excel!, TRUE)
	end if	

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com020_e`cb_close within w_23005_e
end type

type cb_delete from w_com020_e`cb_delete within w_23005_e
end type

type cb_insert from w_com020_e`cb_insert within w_23005_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_23005_e
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	is_flag = "Dat"
	Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com020_e`cb_update within w_23005_e
end type

type cb_print from w_com020_e`cb_print within w_23005_e
integer x = 1449
integer width = 439
string text = "계산서인쇄(&P)"
end type

type cb_preview from w_com020_e`cb_preview within w_23005_e
boolean visible = false
integer x = 1422
end type

type gb_button from w_com020_e`gb_button within w_23005_e
end type

type cb_excel from w_com020_e`cb_excel within w_23005_e
integer x = 1888
integer width = 283
end type

type dw_head from w_com020_e`dw_head within w_23005_e
event type long ue_detail ( )
integer height = 144
string dataobject = "d_23005_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child, ldw_brand

this.getchild("brand",ldw_brand)
ldw_brand.settransobject(sqlca)
ldw_brand.retrieve('001')

this.getchild("bill_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('008')
ldw_child.insertrow(1)
ldw_child.setitem(1,"inter_cd","%")
ldw_child.setitem(1,"inter_nm","전체")

end event

event dw_head::buttonclicked;call super::buttonclicked;choose case dwo.name 
	case "cb_detail" 		//자재생산계산서 상세내역
		parent.trigger event ue_detail()
end choose

end event

event dw_head::itemchanged;call super::itemchanged;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_23005_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com020_e`ln_2 within w_23005_e
integer beginy = 332
integer endy = 332
end type

type dw_list from w_com020_e`dw_list within w_23005_e
integer x = 5
integer y = 888
integer width = 754
integer height = 1148
string dataobject = "d_23005_h02"
end type

event dw_list::constructor;call super::constructor;datawindowchild ldw_child


this.getchild("bill_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('008')

this.getchild("mat_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve("014")
end event

event dw_list::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
decimal s_amt
long i

IF row <= 0 THEN Return
il_list_row = row

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

is_brand     = This.GetItemString(row, 'brand') /* DataWindow에 Key 항목을 가져온다 */
is_bill_date = This.GetItemString(row, 'bill_date') /* DataWindow에 Key 항목을 가져온다 */
is_bill_type = This.GetItemString(row, 'bill_type') /* DataWindow에 Key 항목을 가져온다 */
is_bill_no   = This.GetItemString(row, 'bill_no') /* DataWindow에 Key 항목을 가져온다 */
is_cust_cd   = This.GetItemString(row, 'cust_cd') /* DataWindow에 Key 항목을 가져온다 */
is_mat_type  = This.GetItemString(row, 'mat_type') /* DataWindow에 Key 항목을 가져온다 */
is_flag      = This.GetItemString(row, 'flag') /* DataWindow에 Key 항목을 가져온다 */


il_rows = dw_magam.retrieve(is_brand, is_bill_date, is_bill_type, is_bill_no, is_cust_cd, is_flag)
il_rows = dw_body.retrieve(is_brand, is_bill_date, is_bill_type, is_bill_no, is_cust_cd, is_mat_type, is_flag)
dw_detail.reset()
if il_rows > 0 then
	if is_flag = "New" then	dw_body.SetItemStatus(1, 0, Primary!, NewModified!)	
	
	parent.trigger event ue_detail_set()
	
	dw_detail.retrieve(is_brand, is_bill_date, is_bill_type, is_bill_no, is_cust_cd, is_mat_type, is_flag)	

end if

for i =1 to dw_detail.rowcount()
		dw_detail.SetItemStatus(i, 0, Primary!, DataModified!)	
next

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_23005_e
event type long ue_detail ( )
integer x = 5
integer y = 348
integer width = 3593
integer height = 524
string dataobject = "d_23005_d01"
boolean vscrollbar = false
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("bill_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('008')

this.getchild("pay_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('007')

this.getchild("bill_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('016')

this.getchild("rpt_bungi",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('017')

this.getchild("local_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('015')

this.getchild("mat_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('014')

end event

event dw_body::itemchanged;/*===========================================================================*/
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
long i

CHOOSE CASE dwo.name
	CASE "colunm1" 
   	IF data = 'A' THEN
	      /*action*/
	   END IF
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "pay_gubn"
		for i = 1 to dw_detail.rowcount()
			dw_detail.setitem(i,"pay_gubn",data)
		next 
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "mat_type"
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
	case "bill_gubn"
		if data = "2" or data = "9" then
			this.setitem(row,"vat",0)
		end if

		
			
END CHOOSE

end event

event dw_body::dberror;//
end event

type st_1 from w_com020_e`st_1 within w_23005_e
integer x = 763
integer y = 896
integer height = 1140
end type

type dw_print from w_com020_e`dw_print within w_23005_e
integer x = 14
integer y = 896
string dataobject = "d_com560_mat"
end type

type dw_magam from datawindow within w_23005_e
integer x = 2830
integer y = 348
integer width = 754
integer height = 524
integer taborder = 50
boolean bringtotop = true
string title = "계산서 지불확정"
string dataobject = "d_23006_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_child

this.getchild("year",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('002')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003')

this.getchild("pay_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('007')


end event

event buttonclicked;long ll_cur_row
string ls_brand, ls_bill_date, ls_bill_type, ls_bill_no, ls_no
string ls_year, ls_season, ls_pay_gubn, ls_Flag
long prot, t_row

choose case dwo.name 
	case "cb_add"
		this.insertrow(this.rowcount()+1)
	case "cb_del"
		ll_cur_row = this.getrow()
		if ll_cur_row <= 0 then return
		il_rows = this.DeleteRow (ll_cur_row)
		this.SetFocus()	
		idw_status = dw_magam.GetItemStatus(ll_cur_row, 0, Primary!)
		if idw_status <> new! and idw_status <> newmodified! then
			ib_changed = true
			cb_update.enabled = true
		end if		
end choose

end event

event itemchanged;//ib_changed = true
//cb_update.enabled = true


end event

event losefocus;//decimal s_amt, t_apply_amt
//
//s_amt = dw_magam.getitemnumber(1,"s_amt")
//t_apply_amt = dec(this.object.t_apply_amt.text)
//
//
//if s_amt <> t_apply_amt then
//	messagebox("error","계산서금액과 일치하지 않습니다..")
//	return -1
//end if
//

end event

event clicked;il_magam_row = row
end event

type cb_sub_make from commandbutton within w_23005_e
integer x = 2185
integer y = 44
integer width = 631
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "임시계산서 데이타생성"
end type

event clicked;pointer oldpointer  // Declares a pointer variable
string ls_msg = space(100) ,ls_issue_date


IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN	-1
ls_issue_date = dw_head.getitemstring(1,"bill_date")

oldpointer = SetPointer(HourGlass!)

if isnull(is_bill_type) or is_bill_type = "" then is_bill_type = '99' 


DECLARE sp_make_tb_23021_w PROCEDURE FOR sp_make_tb_23021_w 
		@brand		= :is_brand,
		@issue_date	= :ls_issue_date,
		@bill_type	= :is_bill_type,
		@cust_cd	   = :is_cust_cd;
		
		
execute sp_make_tb_23021_w;
commit  USING SQLCA;
SetPointer(oldpointer)

messagebox("확인","처리완료 !!")


end event

type dw_detail from datawindow within w_23005_e
event ue_refresh ( long row,  string iwol_yn )
integer x = 782
integer y = 892
integer width = 2811
integer height = 1144
integer taborder = 50
string title = "none"
string dataobject = "d_23005_d05"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_refresh(long row, string iwol_yn);double ls_qty, ls_amt, ls_tot_qty, ls_tot_amt

ls_qty = this.getitemnumber(row,"tot_qty")
ls_amt = this.getitemnumber(row,"tot_amt")

if is_bill_type = "05" then
	dw_body.setitem(1,"qty",-1*ls_qty)
	dw_body.setitem(1,"amt",-1*ls_amt)
	dw_body.setitem(1,"vat",-1*truncate((ls_amt)*0.1,0))
else
	dw_body.setitem(1,"qty",ls_qty)
	dw_body.setitem(1,"amt",ls_amt)
	dw_body.setitem(1,"vat",truncate((ls_amt)*0.1,0))
end if

	
	
	
//if iwol_yn = "Y" then
//	dw_body.setitem(1,"qty",ls_tot_qty - ls_qty)
//	dw_body.setitem(1,"amt",ls_tot_amt - ls_amt)
//	dw_body.setitem(1,"vat",(ls_tot_amt - ls_amt)*0.1)
//else 
//	dw_body.setitem(1,"qty",ls_tot_qty + ls_qty)
//	dw_body.setitem(1,"amt",ls_tot_amt + ls_amt)	
//	dw_body.setitem(1,"vat",(ls_tot_amt + ls_amt)*0.1)
//end if

end event

event constructor;datawindowchild ldw_child ,ldw_unit

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

this.getchild("pay_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('007')
end event

event itemchanged;ib_changed = true
cb_update.enabled = true

choose case dwo.name
	case "iwol_yn"	
		post event ue_refresh(row,data)
end choose
	
end event

event buttonclicking;long i 
string iwol_yn, YN


//iwol_yn = this.getitemstring(1,"iwol_yn")
//for i = 1 to this.rowcount()
//	if iwol_yn = 'Y' then
//		yn = this.getitemstring(i,"iwol_yn")
//		if yn = 'Y' then
//			this.setitem(i,"iwol_yn","N")
//			trigger event ue_refresh(i,"N")
//		end if
//	else
//		yn = this.getitemstring(i,"iwol_yn")
//		if yn = 'N' then
//			this.setitem(i,"iwol_yn","Y")
//			trigger event ue_refresh(i,"Y")
//		end if
//	end if
//
//next


end event

type st_2 from statictext within w_23005_e
integer x = 3182
integer y = 228
integer width = 1161
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "용지설정( 사용자 2100/2540mm)"
boolean focusrectangle = false
end type

