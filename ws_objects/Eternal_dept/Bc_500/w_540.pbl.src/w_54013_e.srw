$PBExportHeader$w_54013_e.srw
$PBExportComments$부분RT작업
forward
global type w_54013_e from w_com010_e
end type
type tab_1 from tab within w_54013_e
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tab_1 from tab within w_54013_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type cb_2 from commandbutton within w_54013_e
end type
type cb_4 from commandbutton within w_54013_e
end type
type cb_1 from commandbutton within w_54013_e
end type
type cb_3 from commandbutton within w_54013_e
end type
type dw_1 from datawindow within w_54013_e
end type
type dw_5 from datawindow within w_54013_e
end type
type dw_2 from datawindow within w_54013_e
end type
type dw_3 from datawindow within w_54013_e
end type
type dw_4 from datawindow within w_54013_e
end type
type cbx_1 from checkbox within w_54013_e
end type
type cbx_2 from checkbox within w_54013_e
end type
type cbx_3 from checkbox within w_54013_e
end type
type dw_6 from datawindow within w_54013_e
end type
type dw_7 from datawindow within w_54013_e
end type
type dw_8 from datawindow within w_54013_e
end type
type dw_9 from datawindow within w_54013_e
end type
type dw_10 from datawindow within w_54013_e
end type
type dw_11 from datawindow within w_54013_e
end type
type dw_12 from datawindow within w_54013_e
end type
type cb_5 from commandbutton within w_54013_e
end type
type dw_13 from datawindow within w_54013_e
end type
end forward

global type w_54013_e from w_com010_e
integer width = 3689
integer height = 2252
event ue_delete2 ( )
tab_1 tab_1
cb_2 cb_2
cb_4 cb_4
cb_1 cb_1
cb_3 cb_3
dw_1 dw_1
dw_5 dw_5
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
dw_6 dw_6
dw_7 dw_7
dw_8 dw_8
dw_9 dw_9
dw_10 dw_10
dw_11 dw_11
dw_12 dw_12
cb_5 cb_5
dw_13 dw_13
end type
global w_54013_e w_54013_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_item, idw_shop_div
string is_brand,  is_year, is_season, is_frm_yymmdd, is_to_yymmdd, is_item, is_opt_between, is_opt_chno
string is_style, is_color, is_size,is_yymmdd, is_recall_no, is_shop_type, is_style_rt, is_chno_rt, is_proc_yn
string is_ord_area, is_shop_div, is_sort, is_size1, is_size2, is_dep_gubn
long ii_row, il_avr_rate
end variables

forward prototypes
public subroutine wf_push_insert (string as_yymmdd, string as_brand)
end prototypes

event ue_delete2();/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row
string ls_item



if dw_10.visible = true then
	ll_cur_row = dw_10.GetRow()

	if ll_cur_row <= 0 then return
	idw_status = dw_10.GetItemStatus (ll_cur_row, 0, primary!)	

	il_rows = dw_10.DeleteRow (ll_cur_row)
	dw_10.SetFocus()
	
elseif dw_5.visible = true then
	ll_cur_row = dw_5.GetRow()

	if ll_cur_row <= 0 then return
	idw_status = dw_5.GetItemStatus (ll_cur_row, 0, primary!)	

	il_rows = dw_5.DeleteRow (ll_cur_row)
	dw_5.SetFocus()
	
end if


This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

public subroutine wf_push_insert (string as_yymmdd, string as_brand);//푸쉬보내기
long i, ll_cnt
string ls_fr_shop
string ls_title, ls_content, ls_url, ls_to_id

dw_12.retrieve(as_yymmdd, as_brand)

for i = 1 to dw_12.rowcount()
	ls_fr_shop = dw_12.getitemstring(i, 'fr_shop_cd')
	
	ls_title = MidA(is_yymmdd,1,4) + '/'+ MidA(is_yymmdd,5,2) + '/'+ MidA(is_yymmdd,7,2) + ' 본사 지시 RT'
	ls_content = MidA(is_yymmdd,1,4) + '/'+ MidA(is_yymmdd,5,2) + '/'+ MidA(is_yymmdd,7,2) + ' 본사 지시 RT가 등록 되었습니다.'
	ls_url = 'RTSTORE||'+ls_fr_shop+'||'
	ls_to_id	= ls_fr_shop

	gf_push(ls_title, ls_content, ls_url, ls_to_id)

	update tb_54013_h set push_yn = 'Y'
	from tb_54013_h
	where yymmdd 	= :as_yymmdd
			and brand 	= :as_brand
			and FR_SHOP_CD = :ls_fr_shop
			and proc_yn = 'Y'
			and isnull(push_yn,'N') = 'N';

	commit  USING SQLCA;

next

dw_12.reset()
end subroutine

on w_54013_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.cb_2=create cb_2
this.cb_4=create cb_4
this.cb_1=create cb_1
this.cb_3=create cb_3
this.dw_1=create dw_1
this.dw_5=create dw_5
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.dw_6=create dw_6
this.dw_7=create dw_7
this.dw_8=create dw_8
this.dw_9=create dw_9
this.dw_10=create dw_10
this.dw_11=create dw_11
this.dw_12=create dw_12
this.cb_5=create cb_5
this.dw_13=create dw_13
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_4
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.dw_5
this.Control[iCurrent+8]=this.dw_2
this.Control[iCurrent+9]=this.dw_3
this.Control[iCurrent+10]=this.dw_4
this.Control[iCurrent+11]=this.cbx_1
this.Control[iCurrent+12]=this.cbx_2
this.Control[iCurrent+13]=this.cbx_3
this.Control[iCurrent+14]=this.dw_6
this.Control[iCurrent+15]=this.dw_7
this.Control[iCurrent+16]=this.dw_8
this.Control[iCurrent+17]=this.dw_9
this.Control[iCurrent+18]=this.dw_10
this.Control[iCurrent+19]=this.dw_11
this.Control[iCurrent+20]=this.dw_12
this.Control[iCurrent+21]=this.cb_5
this.Control[iCurrent+22]=this.dw_13
end on

on w_54013_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.cb_2)
destroy(this.cb_4)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.dw_1)
destroy(this.dw_5)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.dw_6)
destroy(this.dw_7)
destroy(this.dw_8)
destroy(this.dw_9)
destroy(this.dw_10)
destroy(this.dw_11)
destroy(this.dw_12)
destroy(this.cb_5)
destroy(this.dw_13)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))



end event

event pfc_preopen();call super::pfc_preopen;

inv_resize.of_Register(dw_1, "ScaleToright&Bottom")
inv_resize.of_Register(dw_4, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_5, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_6, "ScaleToRight")
inv_resize.of_Register(dw_7, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)
dw_7.SetTransObject(SQLCA)
dw_8.SetTransObject(SQLCA)
dw_9.SetTransObject(SQLCA)
dw_10.SetTransObject(SQLCA)
dw_11.SetTransObject(SQLCA)
dw_12.SetTransObject(SQLCA)
dw_13.SetTransObject(SQLCA)

dw_6.InsertRow(0)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title
datetime ld_datetime

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


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ii_row = 0

if dw_5.visible = true then	
	is_style_rt = dw_head.GetItemString(1, "style")
	if IsNull(is_style_rt) or Trim(is_style_rt) = "" then
      is_style_rt = "%"
	end if
	
	is_chno_rt = dw_head.GetItemString(1, "chno")
	if IsNull(is_chno_rt) or Trim(is_chno_rt) = "" then
		is_chno_rt = "%"
	end if
	
	is_proc_yn = dw_head.GetItemString(1, "proc_yn")
	if IsNull(is_proc_yn) or Trim(is_proc_yn) = "" then
		MessageBox(ls_title,"제품차수를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("proc_yn")
		return false
	end if
	
	is_item = dw_head.GetItemString(1, "item")
	if IsNull(is_item) or Trim(is_item) = "" then
   	is_item = '%'
	end if
else
	is_item = dw_head.GetItemString(1, "item")
	if IsNull(is_item) or Trim(is_item) = "" then
		MessageBox(ls_title,"복종을 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("item")
		return false
	end if

end if


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if



is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_opt_between = dw_head.GetItemString(1, "opt_between")
if IsNull(is_opt_between) or Trim(is_opt_between) = "" then
is_opt_between = "A"
end if


if is_opt_between <> "A" then
		is_frm_yymmdd = dw_head.GetItemString(1, "frm_yymmdd")
		if IsNull(is_frm_yymmdd) or Trim(is_frm_yymmdd) = "" then
			MessageBox(ls_title,"기준일자 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("frm_yymmdd")
			return false
		end if
		
		is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
		if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
			MessageBox(ls_title,"기준일자 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("to_yymmdd")
			return false
		end if
end if



// is_opt_between, is_opt_chno

is_opt_chno = dw_head.GetItemString(1, "style_opt")
if IsNull(is_opt_chno) or Trim(is_opt_chno) = "" then
is_opt_chno = "C"
end if


is_ord_area = dw_head.GetItemString(1, "ord_area")
if IsNull(is_ord_area) or Trim(is_ord_area) = "" then
	MessageBox(ls_title,"정렬방식을 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("ord_area")
			return false
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
	MessageBox(ls_title,"유통망 구분을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("shop_div")
	return false
end if


il_avr_rate = dw_head.GetItemNumber(1, "basic_rate")
if IsNull(il_avr_rate) or il_avr_rate < 0 then
	il_avr_rate = 0 
end if

is_dep_gubn = dw_head.GetItemString(1, "dep_gubn")


if is_dep_gubn = 'N' then 
	 is_shop_type = '1'
elseif is_dep_gubn = 'Y' then 	 
	 is_shop_type = '4'
else
	 is_shop_type = '3'
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if dw_body.visible = true then
	//exec sp_54013_d01 'n', '2001' ,'w', 'h',  'a','s'
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_opt_between, is_opt_chno, is_shop_div,is_dep_gubn)
	IF il_rows > 0 THEN
		dw_body.visible = true
		dw_1.visible = false
		dw_2.visible = false
		dw_3.visible = false
		dw_4.visible = false
		dw_5.visible = false		
		dw_body.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF
elseif dw_5.visible = true then	

	il_rows = dw_5.retrieve(is_yymmdd, is_brand, is_style_rt, is_proc_yn, is_shop_div,is_dep_gubn)
	IF il_rows > 0 THEN
		dw_body.visible = false
		dw_1.visible = false
		dw_2.visible = false
		dw_3.visible = false
		dw_4.visible = false
		dw_5.visible = true		
		dw_body.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF
end if	
	This.Trigger Event ue_button(1, il_rows)
	This.Trigger Event ue_msg(1, il_rows)


end event

event resize;call super::resize;decimal ld_increase , ld_increase1
ld_increase1 = dw_BODY.width / 2
ld_increase = dw_BODY.height / 3

dw_2.resize(ld_increase1 - 5, ld_increase -5 )
dw_3.y = dw_2.y + ld_increase + 5
dw_3.resize(ld_increase1 - 5, ld_increase -5 )
dw_4.y = dw_3.y + ld_increase + 5
dw_4.resize(ld_increase1 - 5, ld_increase -5 )

dw_8.X = 18 + dw_2.width + 5
dw_9.X = 18 + dw_2.width + 5
dw_10.X = 18 + dw_2.width + 5

dw_8.resize(ld_increase1 - 5, ld_increase -5 )
dw_9.y = dw_8.y + ld_increase + 5
dw_9.resize(ld_increase1 - 5, ld_increase -5 )
dw_10.y = dw_9.y + ld_increase + 5
dw_10.resize(ld_increase1 - 5, ld_increase -5 )
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
long i, ll_row_count,ll_row_count1,ll_row_count2, ll_cnt
datetime ld_datetime
string ls_Save_yn, ls_rt_no, ls_fr_shop
integer jj,kk, li_rows

ll_row_count = dw_4.RowCount()
ll_row_count2 = dw_5.RowCount()
ll_row_count1 = dw_10.RowCount()
IF dw_4.AcceptText() <> 1 THEN RETURN -1


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

if dw_4.visible = true then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(rt_no), '0000')) + 10001), 2, 4) 
		into :ls_rt_no
		from tb_54013_h
		where yymmdd = :is_yymmdd;
		
		FOR i=1 TO ll_row_count
			idw_status = dw_4.GetItemStatus(i, 0, Primary!)
			
			IF idw_status = NewModified! or idw_status = DataModified!  THEN				/* New Record */
				jj = jj +1
				dw_4.setitem(i, "yymmdd", is_yymmdd)
				dw_4.setitem(i, "rt_no", ls_rt_no)		
				dw_4.setitem(i, "no", string(jj,"0000"))
				dw_4.setitem(i, "fr_shop_type", is_shop_type)		
				dw_4.setitem(i, "to_shop_type", is_shop_type)				
				dw_4.setitem(i, "brand", is_brand)				
				dw_4.setitem(i, "style", MidA(is_style,1,8))				
				dw_4.setitem(i, "chno",  MidA(is_style,10,1))						
				dw_4.setitem(i, "color", is_color)				
				dw_4.setitem(i, "size",  is_size1)						
				dw_4.setitem(i, "proc_yn", "N")						
				dw_4.setitem(i, "shop_yn", "N")								
				dw_4.Setitem(i, "reg_id", gs_user_id)
			ELSEIF idw_status = DataModified! THEN		/* Modify Record */
				dw_4.Setitem(i, "mod_id", gs_user_id)
				dw_4.Setitem(i, "mod_dt", ld_datetime)
		
			END IF
		NEXT
		
		FOR i=1 TO ll_row_count1
			idw_status = dw_10.GetItemStatus(i, 0, Primary!)
			
			IF idw_status = NewModified! or idw_status = DataModified!  THEN				/* New Record */
				jj = jj +1
				dw_10.setitem(i, "yymmdd", is_yymmdd)
				dw_10.setitem(i, "rt_no", ls_rt_no)		
				dw_10.setitem(i, "no", string(jj,"0000"))
				dw_10.setitem(i, "fr_shop_type", is_shop_type)		
				dw_10.setitem(i, "to_shop_type", is_shop_type)				
				dw_10.setitem(i, "brand", is_brand)				
				dw_10.setitem(i, "style", MidA(is_style,1,8))				
				dw_10.setitem(i, "chno",  MidA(is_style,10,1))						
				dw_10.setitem(i, "color", is_color)				
				dw_10.setitem(i, "size",  is_size2)						
				dw_10.setitem(i, "proc_yn", "N")						
				dw_10.setitem(i, "shop_yn", "N")								
				dw_10.Setitem(i, "reg_id", gs_user_id)
			ELSEIF idw_status = DataModified! THEN		/* Modify Record */
				dw_10.Setitem(i, "mod_id", gs_user_id)
				dw_10.Setitem(i, "mod_dt", ld_datetime)
		
			END IF
		NEXT		
		
	
		il_rows = dw_4.Update(TRUE, FALSE)
		li_rows = dw_10.Update(TRUE, FALSE)	
		
		if il_rows = 1 then
			dw_4.ResetUpdate()
			commit  USING SQLCA;
			dw_4.Reset()	
			ii_row = 0
		else
			rollback  USING SQLCA;
		end if
		
		if li_rows = 1 then
			dw_10.ResetUpdate()
			commit  USING SQLCA;
			dw_10.Reset()	
			ii_row = 0
		else
			rollback  USING SQLCA;
		end if
		
elseif dw_5.visible = true then
	
IF dw_5.AcceptText() <> 1 THEN RETURN -1

	FOR i=1 TO ll_row_count2
			idw_status = dw_5.GetItemStatus(i, 0, Primary!)
			IF idw_status = DataModified! or idw_status = DataModified! THEN		/* Modify Record */
				dw_5.Setitem(i, "mod_id", gs_user_id)
				dw_5.Setitem(i, "mod_dt", ld_datetime)
			END IF
		NEXT
		
		il_rows = dw_5.Update(TRUE, FALSE)

		if il_rows = 1 then
			dw_5.ResetUpdate()
			commit  USING SQLCA;
			dw_5.Reset()	
			ii_row = 0
			wf_push_insert(is_yymmdd, is_brand)
		else
			rollback  USING SQLCA;
		end if		
end if		

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"	
		
		   IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "ls_style", "")
					RETURN 0
				END IF     
			END IF
			
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = ""		

				if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
					ELSE
						gst_cd.Item_where = ""
					END IF
				else 
					gst_cd.Item_where = ""
				end if

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				ls_style = lds_Source.GetItemString(1,"style")
				ls_chno  = lds_Source.GetItemString(1,"chno")				

				dw_head.SetItem(al_row, "style", ls_style)
				dw_head.SetItem(al_row, "chno",  ls_chno)				
				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("proc_yn")
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

event ue_delete();call super::ue_delete;/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row
string ls_item



if dw_4.visible = true then
	ll_cur_row = dw_4.GetRow()

	if ll_cur_row <= 0 then return
	idw_status = dw_4.GetItemStatus (ll_cur_row, 0, primary!)	

	il_rows = dw_4.DeleteRow (ll_cur_row)
	dw_4.SetFocus()
	
elseif dw_5.visible = true then
	ll_cur_row = dw_5.GetRow()

	if ll_cur_row <= 0 then return
	idw_status = dw_5.GetItemStatus (ll_cur_row, 0, primary!)	

	il_rows = dw_5.DeleteRow (ll_cur_row)
	dw_5.SetFocus()
	
end if


This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_print();call super::ue_print;string ls_brand,ls_yymmdd,  ls_shop_cd, ls_print_opt

ls_brand = dw_head.getitemstring(1, "brand")
ls_yymmdd = dw_head.getitemstring(1, "yymmdd")
		
This.Trigger Event ue_title()

if cbx_3.checked = true then
	dw_print.dataobject = "d_54013_r04"	
	dw_print.SetTransObject(SQLCA)	
	This.Trigger Event ue_title ()
	dw_print.RETRIEVE(is_yymmdd, is_brand, is_style_rt, is_proc_yn, is_shop_div, is_shop_type)
else	
	
	
	if cbx_1.checked = true then
		dw_print.dataobject = "d_54013_r01"
	elseif cbx_1.checked = false then
		if cbx_2.checked = false then
		dw_print.dataobject = "d_54013_r02"
		else
		dw_print.dataobject = "d_54013_r03"
		end if
	end if	
	
	
		dw_print.SetTransObject(SQLCA)
	if cbx_1.checked = true then
		dw_print.RETRIEVE( ls_brand, ls_yymmdd, "%", "%", is_shop_div)
	elseif cbx_1.checked = false then
		is_proc_yn = dw_head.GetItemString(1, "proc_yn")
		if cbx_2.checked = false then
			dw_print.RETRIEVE( ls_brand, ls_yymmdd, "%", "%", is_shop_div, is_proc_yn)		
		else
			dw_print.RETRIEVE( ls_brand, ls_yymmdd, "%", "%", is_shop_div, is_proc_yn)		
		end if
	end if	
end if

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title();call super::ue_title;string ls_modify, ls_yymmdd, ls_print_opt, ls_proc_yn

if is_proc_yn = "Y" then
	ls_proc_yn = "확정"
elseif is_proc_yn = "N" then
	ls_proc_yn = "미확정"
else
	ls_proc_yn = "전체"
end if

If cbx_1.checked = false then
	ls_modify =	"t_pgm_id.Text  = 'PGM_ID : " + is_pgm_id + "'" + &
					"t_brand.Text   = '브랜드 : " + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_yymmdd.Text  = '지시일자 : " + is_yymmdd + "'" + &
					"t_proc_yn.Text = '" + ls_proc_yn + "'" 
		
	dw_print.Modify(ls_modify)
end if


end event

event ue_preview();string ls_brand,ls_yymmdd,  ls_shop_cd, ls_print_opt

ls_brand = dw_head.getitemstring(1, "brand")
ls_yymmdd = dw_head.getitemstring(1, "yymmdd")

if cbx_3.checked = true then
	dw_print.dataobject = "d_54013_r04"	
	dw_print.SetTransObject(SQLCA)	
	This.Trigger Event ue_title ()
	dw_print.RETRIEVE(is_yymmdd, is_brand, is_style_rt, is_proc_yn, is_shop_div,is_shop_type)

else			
		
	if cbx_1.checked = true then
		dw_print.dataobject = "d_54013_r01"
	elseif cbx_1.checked = false then
		if cbx_2.checked = false then
		dw_print.dataobject = "d_54013_r02"
		else
		dw_print.dataobject = "d_54013_r03"
		end if
	end if	
	
	This.Trigger Event ue_title()
	
	
		dw_print.SetTransObject(SQLCA)
	if cbx_1.checked = true then
		dw_print.RETRIEVE( ls_brand, ls_yymmdd, "%", "%", is_shop_div)
	elseif cbx_1.checked = false then
		is_proc_yn = dw_head.GetItemString(1, "proc_yn")
		if cbx_2.checked = false then
			dw_print.RETRIEVE( ls_brand, ls_yymmdd, "%", "%", is_shop_div, is_proc_yn, is_shop_type)		
		else
			dw_print.RETRIEVE( ls_brand, ls_yymmdd, "%", "%", is_shop_div, is_proc_yn,is_shop_type)		
	
		end if
	end if	
end if
dw_print.inv_printpreview.of_SetZoom()


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54013_e","0")
end event

event ue_excel();string ls_doc_nm, ls_nm

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

if dw_body.visible = true then
	li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
elseif dw_5.visible = true then	
	li_ret = dw_5.SaveAs(ls_doc_nm, Excel!, TRUE)	
end if	


if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_e`cb_close within w_54013_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_54013_e
integer x = 722
integer taborder = 60
string text = "삭제-L(&D)"
end type

type cb_insert from w_com010_e`cb_insert within w_54013_e
integer x = 1070
integer width = 357
string text = "삭제-R(&A)"
end type

event cb_insert::clicked;Parent.Trigger Event ue_delete2()
end event

type cb_retrieve from w_com010_e`cb_retrieve within w_54013_e
end type

type cb_update from w_com010_e`cb_update within w_54013_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_54013_e
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_54013_e
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_54013_e
end type

type cb_excel from w_com010_e`cb_excel within w_54013_e
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_54013_e
integer y = 156
integer height = 272
string dataobject = "d_54013_h01"
end type

event dw_head::constructor;call super::constructor;string ls_type

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
	
ls_Type = ls_Type + "inter_cd = 'G' or inter_cd = 'K' or inter_cd = 'M' "
idw_shop_div.SetFilter(ls_Type)
idw_shop_div.Filter()

idw_shop_div.insertrow(1)
idw_shop_div.setitem(1, "inter_cd", "%")
idw_shop_div.setitem(1, "inter_nm", "전체")
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
	  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
		
		
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_54013_e
end type

type ln_2 from w_com010_e`ln_2 within w_54013_e
end type

type dw_body from w_com010_e`dw_body within w_54013_e
integer x = 9
integer y = 564
integer width = 3584
integer height = 1432
string dataobject = "d_54013_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_plan_yn
long ll_rows
//exec sp_54010_d02 'n', '2001' ,'w', 'h', 'NF1WH803','20011201', '20011215', 'a','c'
is_style = dw_body.GetitemString(row, "style") 

//select isnull(plan_yn,'N')
//into :ls_plan_yn
//from tb_12020_m
//where style = :is_style 
//and  brand = :is_brand
//and  year  = :is_year
//and  season = :is_season;
//
//if ls_plan_yn = "N" then
//   is_shop_type = "1"
//else 	
//   is_shop_type = "3"
//end if


il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_item, is_style, is_opt_between, is_opt_chno, is_shop_div)

IF il_rows > 0 THEN
	   tab_1.selectedtab = 2
		dw_body.visible = false
		dw_1.visible = true
		dw_2.visible = false
		dw_3.visible = false
		dw_4.visible = false
		dw_5.visible = false		
		dw_1.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF


end event

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

type dw_print from w_com010_e`dw_print within w_54013_e
integer x = 2505
integer y = 892
string dataobject = "d_54013_r04"
end type

type tab_1 from tab within w_54013_e
integer x = 5
integer y = 464
integer width = 3607
integer height = 1552
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

event clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

//IF dw_head.Enabled = TRUE THEN Return 1

  	CHOOSE CASE index
		CASE 1
			dw_body.visible = true
			dw_1.visible = false
			dw_2.visible = false
			dw_3.visible = false
			dw_4.visible = false
			dw_5.visible = false
			dw_6.visible = false			
			dw_7.visible = false			

		CASE 2
			dw_body.visible = false
			dw_1.visible = true
			dw_2.visible = false
			dw_3.visible = false
			dw_4.visible = false
			dw_5.visible = false
			dw_6.visible = false			
			dw_7.visible = false						

      CASE 3
			dw_body.visible = false
			dw_1.visible = false
			dw_2.visible = true
			dw_3.visible = true
			dw_4.visible = true
			dw_5.visible = false
			dw_6.visible = false			
			dw_7.visible = false						

			
		CASE 4			
			dw_body.visible = false
			dw_1.visible = false
			dw_2.visible = false
			dw_3.visible = false
			dw_4.visible = false
			dw_5.visible = true
			dw_6.visible = false			
			dw_7.visible = false						
			is_proc_yn = "N"
			
			
		CASE 5			
			dw_body.visible = false
			dw_1.visible = false
			dw_2.visible = false
			dw_3.visible = false
			dw_4.visible = false
			dw_5.visible = false
			dw_6.visible = true			
			dw_7.visible = true				

	END CHOOSE

	
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1440
long backcolor = 79741120
string text = "   품번별    "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1440
long backcolor = 79741120
string text = "품번칼라사이즈별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1440
long backcolor = 79741120
string text = "   RT작업   "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1440
long backcolor = 79741120
string text = "승인및 당일 작업 조회"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1440
long backcolor = 79741120
string text = "제한매장"
long tabtextcolor = 255
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type cb_2 from commandbutton within w_54013_e
boolean visible = false
integer x = 1541
integer y = 464
integer width = 631
integer height = 112
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "승인및 당일 작업 조회"
end type

event clicked;dw_body.visible = false
dw_1.visible = false
dw_2.visible = false
dw_3.visible = false
dw_4.visible = false
dw_5.visible = true


is_proc_yn = "N"
end event

type cb_4 from commandbutton within w_54013_e
boolean visible = false
integer x = 1038
integer y = 464
integer width = 503
integer height = 112
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "RT작업"
end type

event clicked;dw_body.visible = false
dw_1.visible = false
dw_2.visible = true
dw_3.visible = true
dw_4.visible = true
dw_5.visible = false

end event

type cb_1 from commandbutton within w_54013_e
boolean visible = false
integer x = 530
integer y = 464
integer width = 507
integer height = 112
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "품번칼라사이즈별"
end type

event clicked;dw_body.visible = false
dw_1.visible = true
dw_2.visible = false
dw_3.visible = false
dw_4.visible = false
dw_5.visible = false
end event

type cb_3 from commandbutton within w_54013_e
boolean visible = false
integer x = 27
integer y = 464
integer width = 503
integer height = 112
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "품번별"
end type

event clicked;dw_body.visible = true
dw_1.visible = false
dw_2.visible = false
dw_3.visible = false
dw_4.visible = false
dw_5.visible = false

end event

type dw_1 from datawindow within w_54013_e
boolean visible = false
integer x = 27
integer y = 572
integer width = 3552
integer height = 1452
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_rows ,ll_row1, ll_row2,ll_row3, ll_row4,ll_rows5
integer li_rtrn, ii
string ls_size1,ls_size2

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


//exec sp_54013_d02 'n', '2001' ,'w', 'h', 'NF1WH807-0' ,'a','s'
is_color = dw_1.GetitemString(row, "color") 

dw_2.reset()
dw_3.reset()	
dw_4.reset()
dw_8.reset()
dw_9.reset()	
dw_10.reset()
dw_11.reset()



ll_rows5 = dw_13.retrieve(is_brand, is_style, is_color)
ll_row2 = dw_11.retrieve(is_style, is_color)

if ll_row2 > 2 then
	 li_rtrn =  messagebox("사이즈 확인!", "해당제품의 사이즈가 2개 이상입니다. 세번째 사이즈부터 작업하시겠습니까?" ,Question!,OKCancel!)
	   if li_rtrn = 1 then
			ii = 2
		else 
			ii = 0
		end if	
		
end if		

//dw_11.visible = true

	if ll_row2 > 0 then
	   is_size1 = dw_11.getitemstring(1 + ii, "size")
	end if	
	
		ll_row1  = dw_4.retrieve(is_yymmdd,  is_style, is_color, is_size1,is_shop_div)
	if ll_row1 > 0 then
			li_rtrn = messagebox("경고!", "이미 처리된 스타일입니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )	
			if li_rtrn = 1 then
//				dw_2.reset()
//				dw_3.reset()				
				dw_2.title = "사이즈-" + is_size1
				il_rows = dw_2.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size1, is_opt_between, is_opt_chno, "B", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
				ll_rows = dw_3.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size1, is_opt_between, is_opt_chno, "A", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
			else
				il_rows = 0
			end if
	else		
//				dw_2.reset()
//				dw_3.reset()			
				dw_2.title = "사이즈-" + is_size1
				il_rows = dw_2.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size1, is_opt_between, is_opt_chno, "B", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
				ll_rows = dw_3.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size1, is_opt_between, is_opt_chno, "A", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
	end if		
	
	if ll_row2 > 1 then 
	  is_size2 = dw_11.getitemstring(2 + ii, "size")
//   	dw_8.reset()
//		dw_9.reset()	
//		dw_10.reset()
	
			ll_row1  = dw_10.retrieve(is_yymmdd,  is_style, is_color, is_size2,is_shop_div)
		if ll_row1 > 0 then
				li_rtrn = messagebox("경고!", "이미 처리된 스타일입니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )	
				if li_rtrn = 1 then
//					dw_8.reset()
//					dw_9.reset()		
					dw_8.title = "사이즈-" + is_size2							
					ll_row3 = dw_8.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size2, is_opt_between, is_opt_chno, "B", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
					ll_row4 = dw_9.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size2, is_opt_between, is_opt_chno, "A", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
				else
					il_rows = 0
				end if
		else		
//					dw_8.reset()
//					dw_9.reset()			
					dw_8.title = "사이즈-" + is_size2								
					ll_row3 = dw_8.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size2, is_opt_between, is_opt_chno, "B", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
					ll_row4 = dw_9.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size2, is_opt_between, is_opt_chno, "A", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
		end if		
	end if	

IF il_rows > 0 or ll_rows > 0 THEN
	  tab_1.selectedtab = 3
		dw_body.visible = false
		dw_1.visible = false
		dw_2.visible = true
		dw_3.visible = true
		dw_4.visible = true
		
		dw_8.visible = true
		dw_9.visible = true
		dw_10.visible = true
		
		dw_5.visible = false		
		dw_2.SetFocus()
		
		
		if ll_rows5 > 0 then 
			dw_13.visible = true
		else 	
			dw_13.visible = false
		end if	
ELSEIF il_rows = 0 and li_rtrn = 1 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF
			



//long ll_rows ,ll_row1, ll_row2,ll_row3, ll_row4,ll_rows5
//integer li_rtrn
//string ls_size1,ls_size2
//
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//
//
////exec sp_54013_d02 'n', '2001' ,'w', 'h', 'NF1WH807-0' ,'a','s'
//is_color = dw_1.GetitemString(row, "color") 
//
//dw_2.reset()
//dw_3.reset()	
//dw_4.reset()
//dw_8.reset()
//dw_9.reset()	
//dw_10.reset()
//dw_11.reset()
//
//
//
//ll_rows5 = dw_13.retrieve(is_brand, is_style, is_color)
//
//
//
//
//ll_row2 = dw_11.retrieve(is_style, is_color)
//
//	if ll_row2 > 0 then
//	   is_size1 = dw_11.getitemstring(1, "size")
//	end if	
//	
//		ll_row1  = dw_4.retrieve(is_yymmdd,  is_style, is_color, is_size1,is_shop_div)
//	if ll_row1 > 0 then
//			li_rtrn = messagebox("경고!", "이미 처리된 스타일입니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )	
//			if li_rtrn = 1 then
//				dw_2.reset()
//				dw_3.reset()							
//				il_rows = dw_2.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size1, is_opt_between, is_opt_chno, "b", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
//				ll_rows = dw_3.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size1, is_opt_between, is_opt_chno, "a", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
//			else
//				il_rows = 0
//			end if
//	else		
//				dw_2.reset()
//				dw_3.reset()			
//				il_rows = dw_2.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size1, is_opt_between, is_opt_chno, "b", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
//				ll_rows = dw_3.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size1, is_opt_between, is_opt_chno, "a", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
//	end if		
//	
//	if ll_row2 > 1 then 
//	  is_size2 = dw_11.getitemstring(2, "size")
//   	dw_8.reset()
//		dw_9.reset()	
//		dw_10.reset()
//	
//			ll_row1  = dw_10.retrieve(is_yymmdd,  is_style, is_color, is_size2,is_shop_div)
//		if ll_row1 > 0 then
//				li_rtrn = messagebox("경고!", "이미 처리된 스타일입니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )	
//				if li_rtrn = 1 then
//					dw_8.reset()
//					dw_9.reset()		
//							
//					ll_row3 = dw_8.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size2, is_opt_between, is_opt_chno, "b", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
//					ll_row4 = dw_9.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size2, is_opt_between, is_opt_chno, "a", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
//				else
//					il_rows = 0
//				end if
//		else		
//					dw_8.reset()
//					dw_9.reset()			
//					
//					ll_row3 = dw_8.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size2, is_opt_between, is_opt_chno, "b", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
//					ll_row4 = dw_9.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size2, is_opt_between, is_opt_chno, "a", is_ord_area, is_shop_div, il_avr_rate, is_yymmdd, is_shop_type)
//		end if		
//	end if	
//
//IF il_rows > 0 or ll_rows > 0 THEN
//	  tab_1.selectedtab = 3
//		dw_body.visible = false
//		dw_1.visible = false
//		dw_2.visible = true
//		dw_3.visible = true
//		dw_4.visible = true
//		
//		dw_8.visible = true
//		dw_9.visible = true
//		dw_10.visible = true
//		
//		dw_5.visible = false		
//		dw_2.SetFocus()
//		
//		
//		if ll_rows5 > 0 then 
//			dw_13.visible = true
//		else 	
//			dw_13.visible = false
//		end if	
//ELSEIF il_rows = 0 and li_rtrn = 1 THEN
//	MessageBox("조회", "조회할 자료가 없습니다.")
//ELSE
//	MessageBox("조회오류", "조회 실패 하였습니다.") 
//END IF
//			

end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event clicked;//gf_tSort(dw_1)
end event

type dw_5 from datawindow within w_54013_e
boolean visible = false
integer x = 32
integer y = 576
integer width = 3566
integer height = 1440
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false


Long	ll_row_count, i
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


CHOOSE CASE dwo.name
	CASE "proc_yn"
		If data = 'Y' then
			This.Setitem(row, "mod_id", gs_user_id)
			This.Setitem(row, "mod_dt", ld_datetime)
		End If
		
END CHOOSE

end event

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event buttonclicked;Long	ll_row_count, i
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


CHOOSE CASE dwo.name
	CASE "cb_all"
		If is_proc_yn = 'N' then
			is_proc_yn = 'Y'
			This.Object.cb_all.Text = '전체제외'
		Else
			is_proc_yn = 'N'
			This.Object.cb_all.Text = '전체선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "proc_yn", is_proc_yn)
			This.Setitem(i, "mod_id", gs_user_id)
			This.Setitem(i, "mod_dt", ld_datetime)
		Next
END CHOOSE

end event

type dw_2 from datawindow within w_54013_e
boolean visible = false
integer x = 18
integer y = 572
integer width = 1723
integer height = 568
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_54013_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_shop_cd, ls_fr_shop_cd, ls_to_shop_cd, ls_shop_nm, ls_qry, ls_force,ls_limit_yn
long ll_row, ll_out_qty, ll_found, ll_qty, kk, ll_gijisi, ll_wanbul, ll_found_n

ll_qty = 0

ii_row = dw_4.rowcount()
ii_row = ii_row + 1

ls_force = dw_2.getitemstring(row, "force")
ls_limit_yn = dw_2.getitemstring(row, "limit_yn")

ls_shop_cd = MidA(dw_2.getitemstring(row, "shop_cd"),1,6)

select dbo.sf_shop_nm(:ls_shop_cd, 'a')
into :ls_shop_nm
from dual;

//messagebox("force", ls_force)
//if ls_force = "N" then

		
		select isnull(sum(isnull(rqst_qty,0)), 0)	
		into :ll_wanbul 
		 from tb_54031_d with (nolock) 
		where style     = :is_style
		  and color     = :is_color 
		  and size      = :is_size 
		  and rt_shop   = :ls_shop_cd
		  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;  
		
		select isnull(sum(isnull(move_qty,0)),0)	
		 into :ll_gijisi 
		 from tb_54013_h with (nolock) 
		where style       = :is_style
		  and color       = :is_color 
		  and size        = :is_size 
		  and fr_shop_cd  = :ls_shop_cd
		  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;
		
		
		ll_out_qty = dw_2.GetitemNumber(row, "shop_stock_qty")
		ll_row = dw_4.rowcount()
		
		dw_4.AcceptText() 
		
		ll_found_n = 0
		ll_found = 0
		for kk =  1 to ll_row 
		ll_found = dw_4.Find("fr_shop_cd = '" + ls_shop_cd + "'", ll_found_n + 1 , kk)
			if ll_found > 0 then
				ll_qty = ll_qty + dw_4.GetitemNumber(ll_found, "move_qty")
				ll_found_n = ll_found
			end if	
		next
		
		//messagebox( string(ll_qty), string(ll_out_qty))
		
		
		ll_out_qty = ll_out_qty - ll_qty + ll_gijisi
		
		
		if ll_out_qty <= 0 then 
				if ls_force = "N" then
				   messagebox("경고!","가용재고를 초과 하였습니다!")
				end if	
				ii_row = ii_row - 1		
		else		
			
			if ll_row = ii_row - 1  and isnull(	dw_4.getitemstring(ll_row, "to_shop_cd") ) = false then
				dw_4.insertrow(0)
				ll_row = dw_4.rowcount()
				dw_4.Setitem(ll_row, "fr_shop_cd",ls_shop_cd) 
				dw_4.Setitem(ll_row, "fr_shop_nm",ls_shop_nm) 	
				dw_4.Setitem(ll_row, "move_qty",  ll_out_qty ) 	
				dw_4.Setitem(ll_row, "gijisi",    ll_gijisi ) 	
				dw_4.Setitem(ll_row, "wanbul",    ll_wanbul ) 			
			else	
				ii_row = ii_row - 1		
			end if
		end if	
//else		
if ls_force = "Y" then
	
	if ls_limit_yn <> "Y" then

		ll_row = dw_4.rowcount()
		dw_4.AcceptText() 
		if isnull(	dw_4.getitemstring(ii_row, "to_shop_cd") )  then
			dw_4.Setitem(ll_row, "yymmdd",is_yymmdd) 	
			dw_4.Setitem(ll_row, "to_shop_cd",ls_shop_cd) 
			dw_4.Setitem(ll_row, "to_shop_nm",ls_shop_nm) 	
			cb_update.enabled = true
			ib_changed = true
		end if
	else
		messagebox("알림!", "RT제한 매장입니다!")
	end if	
end if	

end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/


end event

event buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_sort"
		If is_sort = "move_qty A" then
			is_sort = "move_qty D"
			this.setsort(is_sort)
			this.sort()
		Else
			is_sort = "move_qty A"
			this.setsort(is_sort)
			this.sort()			
		End If

END CHOOSE

end event

event clicked;//// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)


gf_tSort(dw_2)
end event

type dw_3 from datawindow within w_54013_e
boolean visible = false
integer x = 18
integer y = 1156
integer width = 1723
integer height = 404
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;
string ls_shop_cd, ls_fr_shop_cd, ls_to_shop_cd, ls_shop_nm, ls_qry, ls_force, ls_limit_yn
long ll_row, ll_out_qty, ll_found, ll_qty, kk, ll_gijisi, ll_wanbul, ll_found_n



ls_shop_cd = MidA(dw_3.getitemstring(row, "shop_cd"),1,6)
ls_force = dw_3.getitemstring(row, "force")
ls_limit_yn = dw_3.getitemstring(row, "limit_yn")

select dbo.sf_shop_nm(:ls_shop_cd, 'a')
into :ls_shop_nm
from dual;

if ls_force = "N" then
	
	if ls_limit_yn <> "Y" then
		ll_row = dw_4.rowcount()
		
		if isnull(	dw_4.getitemstring(ii_row, "to_shop_cd") )  then
			dw_4.Setitem(ll_row, "yymmdd",is_yymmdd) 	
			dw_4.Setitem(ll_row, "to_shop_cd",ls_shop_cd) 
			dw_4.Setitem(ll_row, "to_shop_nm",ls_shop_nm) 	
			cb_update.enabled = true
			ib_changed = true
		end if
	else
		messagebox("알림!", "RT제한 매장입니다!")
	end if	
else		
	
//if ls_force = "Y" then
	ii_row = dw_4.rowcount()
	ii_row = ii_row + 1
	
	ls_force = dw_3.getitemstring(row, "force")
	
	//messagebox("force", ls_force)
	
	ls_shop_cd = MidA(dw_3.getitemstring(row, "shop_cd"),1,6)
	
	select dbo.sf_shop_nm(:ls_shop_cd, 'a')
	into :ls_shop_nm
	from dual;
	
	select isnull(sum(isnull(rqst_qty,0)), 0)	
	into :ll_wanbul 
	 from tb_54031_d with (nolock) 
	where style     = :is_style
	  and color     = :is_color 
	  and size      = :is_size 
	  and rt_shop   = :ls_shop_cd
	  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;  
	
	select isnull(sum(isnull(move_qty,0)),0)	
	 into :ll_gijisi 
	 from tb_54013_h with (nolock) 
	where style       = :is_style
	  and color       = :is_color 
	  and size        = :is_size 
	  and fr_shop_cd  = :ls_shop_cd
	  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;
	
	
	ll_out_qty = dw_2.GetitemNumber(row, "shop_stock_qty")
	ll_row = dw_4.rowcount()
	
	dw_4.AcceptText() 
	
	ll_found_n = 0
	ll_found = 0
	for kk =  1 to ll_row 
	ll_found = dw_4.Find("fr_shop_cd = '" + ls_shop_cd + "'", ll_found_n + 1 , kk)
		if ll_found > 0 then
			ll_qty = ll_qty + dw_4.GetitemNumber(ll_found, "move_qty")
			ll_found_n = ll_found
		end if	
	next
	
	//messagebox( string(ll_qty), string(ll_out_qty))
	
	
	ll_out_qty = ll_out_qty - ll_qty + ll_gijisi
	
//	messagebox("경고!","가용재고를 초과 하였습니다!")
		
	if  isnull(	dw_4.getitemstring(ll_row, "to_shop_cd") ) = false then
		dw_4.insertrow(0)
		ll_row = dw_4.rowcount()
		dw_4.Setitem(ll_row, "fr_shop_cd",ls_shop_cd) 
		dw_4.Setitem(ll_row, "fr_shop_nm",ls_shop_nm) 	
		dw_4.Setitem(ll_row, "move_qty",  ll_out_qty ) 	
		dw_4.Setitem(ll_row, "gijisi",    ll_gijisi ) 	
		dw_4.Setitem(ll_row, "wanbul",    ll_wanbul ) 			
	else	
		ii_row = ii_row - 1		
	end if

end if

end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

end event

event buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_sort"
		If is_sort = "move_qty A" then
			is_sort = "move_qty D"
			this.setsort(is_sort)
			this.sort()
		Else
			is_sort = "move_qty A"
			this.setsort(is_sort)
			this.sort()			
		End If

END CHOOSE

end event

event clicked;
//// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
//
//
gf_tSort(dw_3)
end event

type dw_4 from datawindow within w_54013_e
boolean visible = false
integer x = 18
integer y = 1560
integer width = 1723
integer height = 444
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d05"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event clicked;//gf_tSort(dw_4)
end event

type cbx_1 from checkbox within w_54013_e
integer x = 2894
integer y = 476
integer width = 343
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "공문출력"
borderstyle borderstyle = stylelowered!
end type

type cbx_2 from checkbox within w_54013_e
integer x = 2245
integer y = 476
integer width = 645
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "집계표(받는매장기준)"
borderstyle borderstyle = stylelowered!
end type

type cbx_3 from checkbox within w_54013_e
integer x = 3218
integer y = 476
integer width = 375
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "내역출력"
borderstyle borderstyle = stylelowered!
end type

type dw_6 from datawindow within w_54013_e
boolean visible = false
integer x = 27
integer y = 568
integer width = 3561
integer height = 172
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d09"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event clicked;
string ls_yymmdd, ls_reg_id, ls_sort
DEcimal ld_rt_rate
long ll_row, ll_row_count
int i
datetime ld_datetime

CHOOSE CASE dwo.name
	CASE "cb_view"	     //  Popup 검색창이 존재하는 항목 

		ls_sort = dw_6.GetItemString(1, "sort_opt")

		IF dw_6.AcceptText() <> 1 THEN RETURN 0
		is_brand = dw_head.GetItemString(1, "brand")
		if IsNull(is_brand) or Trim(is_brand) = "" then
			MessageBox("경고!","브랜드를 입력하십시요!")
			dw_6.SetFocus()
			dw_6.SetColumn("brand")
			return 0
		end if		

		ls_yymmdd = dw_6.GetItemString(1, "rt_ymd")
		if IsNull(ls_yymmdd) or Trim(ls_yymmdd) = "" then
			MessageBox("경고!","기준일을 입력하십시요!")
			dw_6.SetFocus()
			dw_6.SetColumn("shop_div")
			return 0
		end if
		
		ld_rt_rate = dw_6.GetItemNumber(1, "rt_rate")
		if IsNull(ld_rt_rate) then
			MessageBox("경고!","기준RT율을 입력하십시요!")
			dw_6.SetFocus()
			dw_6.SetColumn("rt_rate")
			return 0
		end if		
		
		if ls_sort = "1" then 
				dw_7.SetSort("move_rate D")
			elseif ls_sort = "2" then 	
				dw_7.SetSort("move_rate A")
			elseif ls_sort = "3" then 	
				dw_7.SetSort("move_qty D")				
			elseif ls_sort = "4" then 	
				dw_7.SetSort("proc_qty D")		
			else	
				dw_7.SetSort("fr_shop_nm A")		
			end if	

		ll_row = dw_7.retrieve(ls_yymmdd, is_brand,ld_rt_rate)
		IF ll_row > 0 THEN
			dw_7.SetFocus()
		ELSEIF ll_row = 0 THEN
			MessageBox("조회", "조회할 자료가 없습니다.")
		ELSE
			MessageBox("조회오류", "조회 실패 하였습니다.")
		END IF
			
		
	case "cb_update"	
		
		IF dw_7.AcceptText() <> 1 THEN RETURN 0
		
		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF
		
		ll_row_count = dw_7.RowCount()
		
	FOR i=1 TO ll_row_count
			idw_status = dw_7.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified!  THEN				/* New Record    */
			dw_7.Setitem(i, "brand", is_brand)
			dw_7.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		   /* Modify Record */ 
			ls_reg_id = dw_7.GetitemString(i, "reg_id") 
			IF isnull(ls_reg_id) or Trim(ls_reg_id) = "" THEN 
				dw_7.SetItemStatus(i, 0, Primary!, NewModified!)
				dw_7.Setitem(i, "reg_id", gs_user_id)
			ELSE
				dw_7.Setitem(i, "mod_id", gs_user_id)
				dw_7.Setitem(i, "mod_dt", ld_datetime)
			END IF
		END IF
	NEXT
	
		il_rows = dw_7.Update(TRUE, FALSE)
	
		
		if il_rows = 1 then
			dw_7.ResetUpdate()
			commit  USING SQLCA;
			messagebox("알림!","저장되었습니다!")
		//	dw_7.Reset()	
		//	ii_row = 0
		else
			rollback  USING SQLCA;
			messagebox("알림!","저장에 실패하였습니다!")			
		end if		
		
		
END CHOOSE



end event

type dw_7 from datawindow within w_54013_e
boolean visible = false
integer x = 23
integer y = 744
integer width = 3561
integer height = 1264
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d08"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//gf_tSort(dw_7)
end event

type dw_8 from datawindow within w_54013_e
boolean visible = false
integer x = 1783
integer y = 572
integer width = 1723
integer height = 568
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_54013_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_sort"
		If is_sort = "move_qty A" then
			is_sort = "move_qty D"
			this.setsort(is_sort)
			this.sort()
		Else
			is_sort = "move_qty A"
			this.setsort(is_sort)
			this.sort()			
		End If

END CHOOSE

end event

event clicked;//// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
gf_tSort(dw_8)
end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/


end event

event doubleclicked;string ls_shop_cd, ls_fr_shop_cd, ls_to_shop_cd, ls_shop_nm, ls_qry, ls_force,ls_limit_yn
long ll_row, ll_out_qty, ll_found, ll_qty, kk, ll_gijisi, ll_wanbul, ll_found_n

ll_qty = 0

ii_row = dw_10.rowcount()
ii_row = ii_row + 1

ls_force = dw_8.getitemstring(row, "force")
ls_limit_yn = dw_8.getitemstring(row, "limit_yn")

ls_shop_cd = MidA(dw_8.getitemstring(row, "shop_cd"),1,6)

select dbo.sf_shop_nm(:ls_shop_cd, 'a')
into :ls_shop_nm
from dual;

//messagebox("force", ls_force)
//if ls_force = "N" then

		
		select isnull(sum(isnull(rqst_qty,0)), 0)	
		into :ll_wanbul 
		 from tb_54031_d with (nolock) 
		where style     = :is_style
		  and color     = :is_color 
		  and size      = :is_size 
		  and rt_shop   = :ls_shop_cd
		  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;  
		
		select isnull(sum(isnull(move_qty,0)),0)	
		 into :ll_gijisi 
		 from tb_54013_h with (nolock) 
		where style       = :is_style
		  and color       = :is_color 
		  and size        = :is_size 
		  and fr_shop_cd  = :ls_shop_cd
		  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;
		
		
		ll_out_qty = dw_8.GetitemNumber(row, "shop_stock_qty")
		ll_row = dw_10.rowcount()
		
		dw_10.AcceptText() 
		
		ll_found_n = 0
		ll_found = 0
		for kk =  1 to ll_row 
		ll_found = dw_10.Find("fr_shop_cd = '" + ls_shop_cd + "'", ll_found_n + 1 , kk)
			if ll_found > 0 then
				ll_qty = ll_qty + dw_10.GetitemNumber(ll_found, "move_qty")
				ll_found_n = ll_found
			end if	
		next
		
		//messagebox( string(ll_qty), string(ll_out_qty))
		
		
		ll_out_qty = ll_out_qty - ll_qty + ll_gijisi
		
		
		if ll_out_qty <= 0 then 
				if ls_force = "N" then
				   messagebox("경고!","가용재고를 초과 하였습니다!")
				end if	
				ii_row = ii_row - 1		
		else		
			
			if ll_row = ii_row - 1  and isnull(	dw_10.getitemstring(ll_row, "to_shop_cd") ) = false then
				dw_10.insertrow(0)
				ll_row = dw_10.rowcount()
				dw_10.Setitem(ll_row, "fr_shop_cd",ls_shop_cd) 
				dw_10.Setitem(ll_row, "fr_shop_nm",ls_shop_nm) 	
				dw_10.Setitem(ll_row, "move_qty",  ll_out_qty ) 	
				dw_10.Setitem(ll_row, "gijisi",    ll_gijisi ) 	
				dw_10.Setitem(ll_row, "wanbul",    ll_wanbul ) 			
			else	
				ii_row = ii_row - 1		
			end if
		end if	
//else		
if ls_force = "Y" then
	
	if ls_limit_yn <> "Y" then

		ll_row = dw_10.rowcount()
		dw_10.AcceptText() 
		if isnull(	dw_10.getitemstring(ii_row, "to_shop_cd") )  then
			dw_10.Setitem(ll_row, "yymmdd",is_yymmdd) 	
			dw_10.Setitem(ll_row, "to_shop_cd",ls_shop_cd) 
			dw_10.Setitem(ll_row, "to_shop_nm",ls_shop_nm) 	
			cb_update.enabled = true
			ib_changed = true
		end if
	else
		messagebox("알림!", "RT제한 매장입니다!")
	end if	
end if	

end event

type dw_9 from datawindow within w_54013_e
boolean visible = false
integer x = 1783
integer y = 1156
integer width = 1723
integer height = 404
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_sort"
		If is_sort = "move_qty A" then
			is_sort = "move_qty D"
			this.setsort(is_sort)
			this.sort()
		Else
			is_sort = "move_qty A"
			this.setsort(is_sort)
			this.sort()			
		End If

END CHOOSE

end event

event clicked;
//// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
//
//

gf_tSort(dw_9)
end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

end event

event doubleclicked;
string ls_shop_cd, ls_fr_shop_cd, ls_to_shop_cd, ls_shop_nm, ls_qry, ls_force, ls_limit_yn
long ll_row, ll_out_qty, ll_found, ll_qty, kk, ll_gijisi, ll_wanbul, ll_found_n



ls_shop_cd = MidA(dw_9.getitemstring(row, "shop_cd"),1,6)
ls_force = dw_9.getitemstring(row, "force")
ls_limit_yn = dw_9.getitemstring(row, "limit_yn")

select dbo.sf_shop_nm(:ls_shop_cd, 'a')
into :ls_shop_nm
from dual;

if ls_force = "N" then
	
	if ls_limit_yn <> "Y" then
		ll_row = dw_10.rowcount()
		
		if isnull(	dw_10.getitemstring(ii_row, "to_shop_cd") )  then
			dw_10.Setitem(ll_row, "yymmdd",is_yymmdd) 	
			dw_10.Setitem(ll_row, "to_shop_cd",ls_shop_cd) 
			dw_10.Setitem(ll_row, "to_shop_nm",ls_shop_nm) 	
			cb_update.enabled = true
			ib_changed = true
		end if
	else
		messagebox("알림!", "RT제한 매장입니다!")
	end if	
else		
	
//if ls_force = "Y" then
	ii_row = dw_10.rowcount()
	ii_row = ii_row + 1
	
	ls_force = dw_9.getitemstring(row, "force")
	
	//messagebox("force", ls_force)
	
	ls_shop_cd = MidA(dw_9.getitemstring(row, "shop_cd"),1,6)
	
	select dbo.sf_shop_nm(:ls_shop_cd, 'a')
	into :ls_shop_nm
	from dual;
	
	select isnull(sum(isnull(rqst_qty,0)), 0)	
	into :ll_wanbul 
	 from tb_54031_d with (nolock) 
	where style     = :is_style
	  and color     = :is_color 
	  and size      = :is_size 
	  and rt_shop   = :ls_shop_cd
	  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;  
	
	select isnull(sum(isnull(move_qty,0)),0)	
	 into :ll_gijisi 
	 from tb_54013_h with (nolock) 
	where style       = :is_style
	  and color       = :is_color 
	  and size        = :is_size 
	  and fr_shop_cd  = :ls_shop_cd
	  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;
	
	
	ll_out_qty = dw_2.GetitemNumber(row, "shop_stock_qty")
	ll_row = dw_10.rowcount()
	
	dw_10.AcceptText() 
	
	ll_found_n = 0
	ll_found = 0
	for kk =  1 to ll_row 
	ll_found = dw_10.Find("fr_shop_cd = '" + ls_shop_cd + "'", ll_found_n + 1 , kk)
		if ll_found > 0 then
			ll_qty = ll_qty + dw_10.GetitemNumber(ll_found, "move_qty")
			ll_found_n = ll_found
		end if	
	next
	
	//messagebox( string(ll_qty), string(ll_out_qty))
	
	
	ll_out_qty = ll_out_qty - ll_qty + ll_gijisi
	
//	messagebox("경고!","가용재고를 초과 하였습니다!")
		
	if  isnull(	dw_10.getitemstring(ll_row, "to_shop_cd") ) = false then
		dw_10.insertrow(0)
		ll_row = dw_10.rowcount()
		dw_10.Setitem(ll_row, "fr_shop_cd",ls_shop_cd) 
		dw_10.Setitem(ll_row, "fr_shop_nm",ls_shop_nm) 	
		dw_10.Setitem(ll_row, "move_qty",  ll_out_qty ) 	
		dw_10.Setitem(ll_row, "gijisi",    ll_gijisi ) 	
		dw_10.Setitem(ll_row, "wanbul",    ll_wanbul ) 			
	else	
		ii_row = ii_row - 1		
	end if

end if

end event

type dw_10 from datawindow within w_54013_e
boolean visible = false
integer x = 1783
integer y = 1560
integer width = 1723
integer height = 444
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d05"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event clicked;//gf_tSort(dw_10)
end event

type dw_11 from datawindow within w_54013_e
boolean visible = false
integer x = 2917
integer y = 228
integer width = 571
integer height = 600
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_54013_color"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_12 from datawindow within w_54013_e
boolean visible = false
integer x = 2807
integer y = 196
integer width = 663
integer height = 328
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d10"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_5 from commandbutton within w_54013_e
boolean visible = false
integer x = 2208
integer width = 402
integer height = 84
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "push 테스트"
end type

event clicked;dw_head.accepttext()
is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_brand = dw_head.GetItemString(1, "brand")

//messagebox('is_yymmdd', is_yymmdd)
//messagebox('is_brand', is_brand)

//dw_12.retrieve(is_yymmdd, is_brand)

wf_push_insert(is_yymmdd, is_brand)
end event

type dw_13 from datawindow within w_54013_e
boolean visible = false
integer x = 791
integer y = 944
integer width = 2784
integer height = 1032
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "예약판매현황"
string dataobject = "d_54013_d11"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

