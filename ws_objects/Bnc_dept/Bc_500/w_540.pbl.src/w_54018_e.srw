$PBExportHeader$w_54018_e.srw
$PBExportComments$부분RT담당별
forward
global type w_54018_e from w_com010_e
end type
type tab_1 from tab within w_54018_e
end type
type tabpage_1 from userobject within tab_1
end type
type dw_0 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_0 dw_0
end type
type tabpage_2 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_3 from userobject within tab_1
end type
type dw_4 from datawindow within tabpage_3
end type
type dw_3 from datawindow within tabpage_3
end type
type dw_2 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_4 dw_4
dw_3 dw_3
dw_2 dw_2
end type
type tabpage_4 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_5 from userobject within tab_1
end type
type dw_7 from datawindow within tabpage_5
end type
type dw_6 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_7 dw_7
dw_6 dw_6
end type
type tab_1 from tab within w_54018_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type cb_1 from commandbutton within w_54018_e
end type
type cb_3 from commandbutton within w_54018_e
end type
type cbx_1 from checkbox within w_54018_e
end type
type cbx_2 from checkbox within w_54018_e
end type
type cb_4 from commandbutton within w_54018_e
end type
type cb_2 from commandbutton within w_54018_e
end type
type cb_5 from commandbutton within w_54018_e
end type
type dw_12 from datawindow within w_54018_e
end type
type dw_8 from datawindow within w_54018_e
end type
end forward

global type w_54018_e from w_com010_e
integer width = 3662
tab_1 tab_1
cb_1 cb_1
cb_3 cb_3
cbx_1 cbx_1
cbx_2 cbx_2
cb_4 cb_4
cb_2 cb_2
cb_5 cb_5
dw_12 dw_12
dw_8 dw_8
end type
global w_54018_e w_54018_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_item, idw_shop_div, idw_person_id
string is_brand,  is_year, is_season, is_frm_yymmdd, is_to_yymmdd, is_item, is_opt_between, is_opt_chno
string is_style, is_color, is_size,is_yymmdd, is_recall_no, is_shop_type, is_style_rt, is_chno_rt, is_proc_yn
string is_ord_area, is_shop_div, is_person_id, is_dep_gubn, is_own_gubn
long ii_row, il_avr_rate, il_index
end variables

forward prototypes
public subroutine wf_push_insert (string as_yymmdd, string as_brand)
end prototypes

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

on w_54018_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.cb_1=create cb_1
this.cb_3=create cb_3
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cb_4=create cb_4
this.cb_2=create cb_2
this.cb_5=create cb_5
this.dw_12=create dw_12
this.dw_8=create dw_8
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.cbx_2
this.Control[iCurrent+6]=this.cb_4
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_5
this.Control[iCurrent+9]=this.dw_12
this.Control[iCurrent+10]=this.dw_8
end on

on w_54018_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cb_4)
destroy(this.cb_2)
destroy(this.cb_5)
destroy(this.dw_12)
destroy(this.dw_8)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))



end event

event pfc_preopen();call super::pfc_preopen;
inv_resize.of_Register(tab_1.tabpage_1.dw_0, "ScaleToright&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_1, "ScaleToright&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_4, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_5, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_5.dw_6, "ScaleToRight")
inv_resize.of_Register(tab_1.tabpage_5.dw_7, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")

tab_1.tabpage_1.dw_0.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_6.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_7.SetTransObject(SQLCA)
dw_12.SetTransObject(SQLCA)
dw_8.SetTransObject(SQLCA)

tab_1.tabpage_5.dw_6.InsertRow(0)



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

if tab_1.selectedtab = 4 then	
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





if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_person_id = dw_head.GetItemString(1, "person_id")
if IsNull(is_person_id) or Trim(is_person_id) = "" then
	MessageBox(ls_title,"영업담당을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("person_id")
	return false
end if

if gs_dept_cd <> '9000' then	
	if gs_dept_cd <> '5100' then
		if gs_dept_cd <> 'T410' then
			if is_person_id <> gs_user_id  then 
				 messagebox("경고", "자신의 담당 매장만 사용할 수 있습니다!")
				 return false
			end if	  
		end if	
	end if	
end if 	

il_avr_rate = dw_head.GetItemNumber(1, "avr_rate")
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

is_own_gubn = dw_head.GetItemString(1, "own_gubn")



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if tab_1.selectedtab = 1 then
	//exec sp_54013_d01 'n', '2001' ,'w', 'h',  'a','s'
	il_rows = tab_1.tabpage_1.dw_0.retrieve(is_brand, is_year, is_season, is_item, is_opt_between, is_opt_chno, is_person_id, is_dep_gubn)
	IF il_rows > 0 THEN
		tab_1.tabpage_1.dw_0.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF
elseif tab_1.selectedtab = 4 then	
//mle_1.text = is_yymmdd +', '+ is_brand +', '+ is_style_rt +', '+ is_proc_yn +', '+ is_person_id +', '+ is_own_gubn
	il_rows = tab_1.tabpage_4.dw_5.retrieve(is_yymmdd, is_brand, is_style_rt, is_proc_yn, is_person_id, is_own_gubn)
	
	IF il_rows > 0 THEN
		tab_1.tabpage_1.dw_0.SetFocus()
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
ld_increase = dw_BODY.height / 2

tab_1.tabpage_3.dw_2.resize(2103, ld_increase -5 )
tab_1.tabpage_3.dw_3.y = tab_1.tabpage_3.dw_2.y + ld_increase + 10
tab_1.tabpage_3.dw_3.resize(2103, ld_increase -5 )



end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_Save_yn, ls_rt_no
integer jj,kk

ll_row_count = tab_1.tabpage_3.dw_4.RowCount()
IF tab_1.tabpage_3.dw_4.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

if tab_1.tabpage_3.dw_4.visible = true then
//if	tab_1.selectedtab = 4 then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(rt_no), '0000')) + 10001), 2, 4) 
		into :ls_rt_no
		from tb_54013_h
		where yymmdd = :is_yymmdd;
		
		FOR i=1 TO ll_row_count
			idw_status = tab_1.tabpage_3.dw_4.GetItemStatus(i, 0, Primary!)
			
			IF idw_status = NewModified! or idw_status = DataModified!  THEN				/* New Record */
				jj = jj +1
				tab_1.tabpage_3.dw_4.setitem(i, "yymmdd", is_yymmdd)
				tab_1.tabpage_3.dw_4.setitem(i, "rt_no", ls_rt_no)		
				tab_1.tabpage_3.dw_4.setitem(i, "no", string(jj,"0000"))
				tab_1.tabpage_3.dw_4.setitem(i, "fr_shop_type", is_shop_type)		
				tab_1.tabpage_3.dw_4.setitem(i, "to_shop_type", is_shop_type)				
				tab_1.tabpage_3.dw_4.setitem(i, "brand", is_brand)				
				tab_1.tabpage_3.dw_4.setitem(i, "style", MidA(is_style,1,8))				
				tab_1.tabpage_3.dw_4.setitem(i, "chno",  MidA(is_style,10,1))						
				tab_1.tabpage_3.dw_4.setitem(i, "color", is_color)				
				tab_1.tabpage_3.dw_4.setitem(i, "size",  is_size)						
				tab_1.tabpage_3.dw_4.setitem(i, "proc_yn", "N")						
				tab_1.tabpage_3.dw_4.setitem(i, "shop_yn", "N")								
				tab_1.tabpage_3.dw_4.Setitem(i, "reg_id", gs_user_id)
			ELSEIF idw_status = DataModified! THEN		/* Modify Record */
				tab_1.tabpage_3.dw_4.Setitem(i, "mod_id", gs_user_id)
				tab_1.tabpage_3.dw_4.Setitem(i, "mod_dt", ld_datetime)
		
			END IF
		NEXT
		
		il_rows = tab_1.tabpage_3.dw_4.Update(TRUE, FALSE)
		
		if il_rows = 1 then
			tab_1.tabpage_3.dw_4.ResetUpdate()
			commit  USING SQLCA;
			tab_1.tabpage_3.dw_4.Reset()	
			ii_row = 0
		else
			rollback  USING SQLCA;
		end if
elseif tab_1.tabpage_4.dw_5.visible = true then
//elseif tab_1.selectedtab = 4	then
	FOR i=1 TO ll_row_count
			idw_status = tab_1.tabpage_4.dw_5.GetItemStatus(i, 0, Primary!)
			IF idw_status = DataModified! THEN		/* Modify Record */
				tab_1.tabpage_4.dw_5.Setitem(i, "mod_id", gs_user_id)
				tab_1.tabpage_4.dw_5.Setitem(i, "mod_dt", ld_datetime)
			END IF
		NEXT
		
		il_rows = tab_1.tabpage_4.dw_5.Update(TRUE, FALSE)
		
		if il_rows = 1 then
			tab_1.tabpage_4.dw_5.ResetUpdate()
			commit  USING SQLCA;
			tab_1.tabpage_4.dw_5.Reset()	
			ii_row = 0
			wf_push_insert(is_yymmdd, is_brand)  //PUSH 넣기
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

//if tab_1.selectedtab = 3 then
if	tab_1.tabpage_3.dw_4.visible = true then
	ll_cur_row = tab_1.tabpage_3.dw_4.GetRow()

	if ll_cur_row <= 0 then return
	idw_status = tab_1.tabpage_3.dw_4.GetItemStatus (ll_cur_row, 0, primary!)	

	il_rows = tab_1.tabpage_3.dw_4.DeleteRow (ll_cur_row)
	tab_1.tabpage_3.dw_4.SetFocus()
	
//elseif tab_1.selectedtab = 4 then
elseif tab_1.tabpage_4.dw_5.visible = true then
	ll_cur_row = tab_1.tabpage_4.dw_5.GetRow()

	if ll_cur_row <= 0 then return
	idw_status = tab_1.tabpage_4.dw_5.GetItemStatus (ll_cur_row, 0, primary!)	

	il_rows = tab_1.tabpage_4.dw_5.DeleteRow (ll_cur_row)
	tab_1.tabpage_4.dw_5.SetFocus()
	
end if
//messagebox("il_rows", string(il_rows, "0000"))

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_print();call super::ue_print;string ls_brand,ls_yymmdd,  ls_shop_cd, ls_print_opt

ls_brand = dw_head.getitemstring(1, "brand")
ls_yymmdd = dw_head.getitemstring(1, "yymmdd")
		
This.Trigger Event ue_title()

if cbx_1.checked = true then
	dw_print.dataobject = "d_54018_r01"
elseif cbx_1.checked = false then
	if cbx_2.checked = false then
	dw_print.dataobject = "d_54018_r02"
   else
	dw_print.dataobject = "d_54018_r03"
   end if
end if	


dw_print.SetTransObject(SQLCA)
dw_print.RETRIEVE( ls_brand, ls_yymmdd, "%", "%", is_person_id)


IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title();call super::ue_title;string ls_modify, ls_yymmdd, ls_print_opt


		
If cbx_1.checked = false then
	ls_modify =	"t_pgm_id.Text = 'PGM_ID : " + is_pgm_id + "'" + &
					"t_brand.Text  = '브랜드 : " + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_yymmdd.Text = '지시일자 : " + is_yymmdd + "'" 
		
	dw_print.Modify(ls_modify)
end if


end event

event ue_preview();string ls_brand,ls_yymmdd,  ls_shop_cd, ls_print_opt

ls_brand = dw_head.getitemstring(1, "brand")
ls_yymmdd = dw_head.getitemstring(1, "yymmdd")
		

if cbx_1.checked = true then
	dw_print.dataobject = "d_54018_r01"
elseif cbx_1.checked = false then
	if cbx_2.checked = false then
	dw_print.dataobject = "d_54018_r02"
   else
	dw_print.dataobject = "d_54018_r03"
   end if
end if	

This.Trigger Event ue_title()

dw_print.SetTransObject(SQLCA)
dw_print.RETRIEVE( ls_brand, ls_yymmdd, "%", "%", is_person_id)
dw_print.inv_printpreview.of_SetZoom()


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54018_e","0")
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

if tab_1.selectedtab = 1 then
	li_ret = tab_1.tabpage_1.dw_0.SaveAs(ls_doc_nm, Excel!, TRUE)
elseif tab_1.tabpage_4.dw_5.visible = true then	
	li_ret = tab_1.tabpage_4.dw_5.SaveAs(ls_doc_nm, Excel!, TRUE)	
end if	


if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
			tab_1.tabpage_1.dw_0.Enabled = true
         tab_1.tabpage_1.dw_0.SetFocus()
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
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				tab_1.tabpage_1.dw_0.Enabled = true
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
			if tab_1.tabpage_3.dw_4.RowCount() = 0 then
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
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      tab_1.tabpage_1.dw_0.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_54018_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_54018_e
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_54018_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54018_e
end type

type cb_update from w_com010_e`cb_update within w_54018_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_54018_e
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_54018_e
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_54018_e
end type

type cb_excel from w_com010_e`cb_excel within w_54018_e
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_54018_e
integer y = 164
integer height = 268
string dataobject = "d_54018_h01"
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
	
ls_Type = ls_Type + "inter_cd = 'G' or inter_cd = 'K' or inter_cd = 'O' "
idw_shop_div.SetFilter(ls_Type)
idw_shop_div.Filter()

idw_shop_div.insertrow(1)
idw_shop_div.setitem(1, "inter_cd", "%")
idw_shop_div.setitem(1, "inter_nm", "전체")

This.GetChild("person_id", idw_person_id)
idw_person_id.SetTransObject(SQLCA)
idw_person_id.Retrieve(gs_brand)
idw_person_id.InsertRow(0)

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
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"person_id","")
		This.GetChild("person_id", idw_person_id)
		idw_person_id.SetTransObject(SQLCA)
		idw_person_id.Retrieve(data)
		idw_person_id.InsertRow(0)
		
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

type ln_1 from w_com010_e`ln_1 within w_54018_e
end type

type ln_2 from w_com010_e`ln_2 within w_54018_e
end type

type dw_body from w_com010_e`dw_body within w_54018_e
boolean visible = false
integer x = 1152
integer y = 948
integer width = 1614
integer height = 856
string dataobject = "d_54018_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;//string ls_plan_yn
//
////exec sp_54010_d02 'n', '2001' ,'w', 'h', 'NF1WH803','20011201', '20011215', 'a','c'
//is_style = dw_body.GetitemString(row, "style") 
//
////select isnull(plan_yn,'N')
////into :ls_plan_yn
////from tb_12020_m
////where style = :is_style 
////and  brand = :is_brand
////and  year  = :is_year
////and  season = :is_season;
////
////if ls_plan_yn = "N" then
////   is_shop_type = "1"
////else 	
////   is_shop_type = "3"
////end if
//
//il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_item, is_style, is_opt_between, is_opt_chno, is_person_id)
//
//IF il_rows > 0 THEN
//	   tab_1.selectedtab = 2
//		dw_body.visible = false
//		dw_1.visible = true
//		dw_2.visible = false
//		dw_3.visible = false
//		dw_4.visible = false
//		dw_5.visible = false		
//		dw_1.SetFocus()
//ELSEIF il_rows = 0 THEN
//	MessageBox("조회", "조회할 자료가 없습니다.")
//ELSE
//	MessageBox("조회오류", "조회 실패 하였습니다.") 
//END IF
//
//
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

type dw_print from w_com010_e`dw_print within w_54018_e
integer x = 2505
integer y = 892
string dataobject = "d_54018_r01"
end type

type tab_1 from tab within w_54018_e
integer x = 5
integer y = 452
integer width = 3607
integer height = 1580
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
alignment alignment = center!
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
			//dw_body.visible = false
			tab_1.tabpage_1.dw_0.visible = true
			tab_1.tabpage_2.dw_1.visible = false
			tab_1.tabpage_3.dw_2.visible = false
			tab_1.tabpage_3.dw_3.visible = false
			tab_1.tabpage_3.dw_4.visible = false
			tab_1.tabpage_4.dw_5.visible = false
		CASE 2
			//dw_body.visible = false
			tab_1.tabpage_1.dw_0.visible = false
			tab_1.tabpage_2.dw_1.visible = true
			tab_1.tabpage_3.dw_2.visible = false
			tab_1.tabpage_3.dw_3.visible = false
			tab_1.tabpage_3.dw_4.visible = false
			tab_1.tabpage_4.dw_5.visible = false
      CASE 3
			//dw_body.visible = false
			tab_1.tabpage_1.dw_0.visible = false
			tab_1.tabpage_2.dw_1.visible = false
			tab_1.tabpage_3.dw_2.visible = true
			tab_1.tabpage_3.dw_3.visible = true
			tab_1.tabpage_3.dw_4.visible = true
			tab_1.tabpage_4.dw_5.visible = false			
		CASE 4			
			//dw_body.visible = false
			tab_1.tabpage_1.dw_0.visible = false
			tab_1.tabpage_2.dw_1.visible = false
			tab_1.tabpage_3.dw_2.visible = false
			tab_1.tabpage_3.dw_3.visible = false
			tab_1.tabpage_3.dw_4.visible = false
			tab_1.tabpage_4.dw_5.visible = true
			is_proc_yn = "N"
	END CHOOSE


//if tab_1.selectedtab = 4 then
//	is_proc_yn = "N"
//end if	
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1468
long backcolor = 79741120
string text = "   품번별    "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_0 dw_0
end type

on tabpage_1.create
this.dw_0=create dw_0
this.Control[]={this.dw_0}
end on

on tabpage_1.destroy
destroy(this.dw_0)
end on

event constructor;//il_index = 1
end event

type dw_0 from datawindow within tabpage_1
integer width = 3570
integer height = 1460
integer taborder = 120
string title = "none"
string dataobject = "d_54018_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

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

event doubleclicked;string ls_plan_yn

//exec sp_54010_d02 'n', '2001' ,'w', 'h', 'NF1WH803','20011201', '20011215', 'a','c'
is_style = tab_1.tabpage_1.dw_0.GetitemString(row, "style") 

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

il_rows = tab_1.tabpage_2.dw_1.retrieve(is_brand, is_year, is_season, is_item, is_style, is_opt_between, is_opt_chno, is_person_id)



IF il_rows > 0 THEN
	   tab_1.selectedtab = 2
		tab_1.tabpage_2.dw_1.visible = true
		tab_1.tabpage_2.dw_1.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF


end event

event clicked;gf_tSort(tab_1.tabpage_1.dw_0)
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1468
long backcolor = 79741120
string text = "품번칼라사이즈별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_2.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_2.destroy
destroy(this.dw_1)
end on

event dragdrop;//il_index = 2
end event

type dw_1 from datawindow within tabpage_2
integer y = 4
integer width = 3570
integer height = 1460
integer taborder = 120
string title = "none"
string dataobject = "d_54018_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_rows ,ll_row1, ll_stock_qty,ll_rows5
integer li_rtrn, li_date_diff
String ls_out_ymd, ls_person_id

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_54013_d02 'n', '2001' ,'w', 'h', 'NF1WH807-0' ,'a','s'
is_color     = tab_1.tabpage_2.dw_1.GetitemString(row, "color") 
is_size      = tab_1.tabpage_2.dw_1.GetitemString(row, "size") 
ls_out_ymd   = tab_1.tabpage_2.dw_1.GetitemString(row, "out_ymd") 
ll_stock_qty = tab_1.tabpage_2.dw_1.GetitemNumber(row, "house_stock_qty") 


ll_rows5 = dw_8.retrieve(is_brand, is_style, is_color)



select datediff(day, :ls_out_ymd, convert(char(08),getdate(),112))
into :li_date_diff 
from dual;

if li_date_diff < 7 or ll_stocK_qty >= 10 then
	messagebox("경고!", "출고일이 7일 미만이거나 창고재고가 10장 이상이라 작업할 수 없습니다!")
	return -1
end if	

if is_own_gubn = 'Y' then
	ls_person_id = '%'
else	
	ls_person_id = is_person_id
end if	

   ll_row1  = tab_1.tabpage_3.dw_4.retrieve(is_yymmdd,  is_style, is_color, is_size, ls_person_id)
if ll_row1 > 0 then
	   li_rtrn = messagebox("경고!", "이미 처리된 스타일입니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )	
		if li_rtrn = 1 then
			il_rows = tab_1.tabpage_3.dw_2.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size, is_opt_between, is_opt_chno, "b", is_ord_area, is_person_id, il_avr_rate, is_yymmdd, is_shop_type, is_own_gubn)
			ll_rows = tab_1.tabpage_3.dw_3.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size, is_opt_between, is_opt_chno, "a", is_ord_area, is_person_id, il_avr_rate, is_yymmdd, is_shop_type, is_own_gubn)
		else
			il_rows = 0
		end if
else		
			il_rows = tab_1.tabpage_3.dw_2.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size, is_opt_between, is_opt_chno, "b", is_ord_area, is_person_id, il_avr_rate, is_yymmdd, is_shop_type, is_own_gubn)
			ll_rows = tab_1.tabpage_3.dw_3.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_size, is_opt_between, is_opt_chno, "a", is_ord_area, is_person_id, il_avr_rate, is_yymmdd, is_shop_type, is_own_gubn)
end if		

IF il_rows > 0 or ll_rows > 0 THEN
	tab_1.selectedtab = 3
	tab_1.tabpage_3.dw_2.visible = true
	tab_1.tabpage_3.dw_3.visible = true
	tab_1.tabpage_3.dw_4.visible = true
	tab_1.tabpage_3.dw_2.SetFocus()
	
		
		if ll_rows5 > 0 then 
			dw_8.visible = true
		else 	
			dw_8.visible = false
		end if	
	
ELSEIF il_rows = 0 and li_rtrn = 1 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF
			

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

event clicked;gf_tSort(tab_1.tabpage_2.dw_1)

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1468
long backcolor = 79741120
string text = "   RT작업   "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_4 dw_4
dw_3 dw_3
dw_2 dw_2
end type

on tabpage_3.create
this.dw_4=create dw_4
this.dw_3=create dw_3
this.dw_2=create dw_2
this.Control[]={this.dw_4,&
this.dw_3,&
this.dw_2}
end on

on tabpage_3.destroy
destroy(this.dw_4)
destroy(this.dw_3)
destroy(this.dw_2)
end on

event constructor;//il_index = 3
end event

type dw_4 from datawindow within tabpage_3
integer x = 2117
integer width = 1454
integer height = 1460
integer taborder = 120
string title = "none"
string dataobject = "d_54018_d05"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type dw_3 from datawindow within tabpage_3
integer y = 740
integer width = 2098
integer height = 716
integer taborder = 50
string dataobject = "d_54018_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

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

event doubleclicked;string ls_shop_cd, ls_fr_shop_cd, ls_to_shop_cd, ls_shop_nm, ls_qry, ls_force, ls_limit_yn, ls_own_gubn
long ll_row, ll_out_qty, ll_found, ll_qty, kk, ll_gijisi, ll_wanbul, ll_found_n



ls_shop_cd = MidA(tab_1.tabpage_3.dw_3.getitemstring(row, "shop_cd"),1,6)
ls_force = tab_1.tabpage_3.dw_3.getitemstring(row, "force")
ls_own_gubn = tab_1.tabpage_3.dw_3.getitemstring(row, "own_gubn")

select dbo.sf_shop_nm(:ls_shop_cd, 'a')
into :ls_shop_nm
from dual;

if ls_force = "N" then
	
	if ls_own_gubn <> "B"  and  ls_limit_yn <> "Y"  then
		select dbo.sf_shop_nm(:ls_shop_cd, 'a')
		into :ls_shop_nm
		from dual;
		
		ll_row = tab_1.tabpage_3.dw_4.rowcount()
		
		if isnull(	tab_1.tabpage_3.dw_4.getitemstring(ii_row, "to_shop_cd") )  then
			tab_1.tabpage_3.dw_4.Setitem(ll_row, "yymmdd",is_yymmdd) 	
			tab_1.tabpage_3.dw_4.Setitem(ll_row, "to_shop_cd",ls_shop_cd) 
			tab_1.tabpage_3.dw_4.Setitem(ll_row, "to_shop_nm",ls_shop_nm) 	
			cb_update.enabled = true
			ib_changed = true
		end if
	else
		if ls_own_gubn = "B"  then
			messagebox("경고!", "담당매장이 아닙니다!")
		else
			messagebox("경고!", "RT제한매장입니다!")			
		end if
	end if

else		
	
//if ls_force = "Y" then
	ii_row = tab_1.tabpage_3.dw_4.rowcount()
	ii_row = ii_row + 1
	
	ls_force = tab_1.tabpage_3.dw_3.getitemstring(row, "force")
	
	//messagebox("force", ls_force)
	
	ls_shop_cd = MidA(tab_1.tabpage_3.dw_3.getitemstring(row, "shop_cd"),1,6)
	
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
	
	
	ll_out_qty = tab_1.tabpage_3.dw_2.GetitemNumber(row, "shop_stock_qty")
	ll_row = tab_1.tabpage_3.dw_4.rowcount()
	
	tab_1.tabpage_3.dw_4.AcceptText() 
	
	ll_found_n = 0
	ll_found = 0
	for kk =  1 to ll_row 
	ll_found = tab_1.tabpage_3.dw_4.Find("fr_shop_cd = '" + ls_shop_cd + "'", ll_found_n + 1 , kk)
		if ll_found > 0 then
			ll_qty = ll_qty + tab_1.tabpage_3.dw_4.GetitemNumber(ll_found, "move_qty")
			ll_found_n = ll_found
		end if	
	next
	
	//messagebox( string(ll_qty), string(ll_out_qty))
	
	
	ll_out_qty = ll_out_qty - ll_qty + ll_gijisi
	
//	messagebox("경고!","가용재고를 초과 하였습니다!")
		
	if  isnull(	tab_1.tabpage_3.dw_4.getitemstring(ll_row, "to_shop_cd") ) = false then
		tab_1.tabpage_3.dw_4.insertrow(0)
		ll_row = tab_1.tabpage_3.dw_4.rowcount()
		tab_1.tabpage_3.dw_4.Setitem(ll_row, "fr_shop_cd",ls_shop_cd) 
		tab_1.tabpage_3.dw_4.Setitem(ll_row, "fr_shop_nm",ls_shop_nm) 	
		tab_1.tabpage_3.dw_4.Setitem(ll_row, "move_qty",  ll_out_qty ) 	
		tab_1.tabpage_3.dw_4.Setitem(ll_row, "gijisi",    ll_gijisi ) 	
		tab_1.tabpage_3.dw_4.Setitem(ll_row, "wanbul",    ll_wanbul ) 			
	else	
		ii_row = ii_row - 1		
	end if

end if


end event

type dw_2 from datawindow within tabpage_3
integer width = 2098
integer height = 728
integer taborder = 20
string dataobject = "d_54018_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_shop_cd, ls_fr_shop_cd, ls_to_shop_cd, ls_shop_nm, ls_qry, ls_own_gubn,ls_force, ls_limit_yn
long ll_row, ll_out_qty, ll_found, ll_qty, kk, ll_gijisi, ll_wanbul


ll_qty = 0

ii_row = tab_1.tabpage_3.dw_4.rowcount()
ii_row = ii_row + 1

ls_shop_cd = MidA(tab_1.tabpage_3.dw_2.getitemstring(row, "shop_cd"),1,6)
ls_own_gubn = tab_1.tabpage_3.dw_2.getitemstring(row, "own_gubn")
ls_force = tab_1.tabpage_3.dw_2.getitemstring(row, "force")
ls_limit_yn = tab_1.tabpage_3.dw_2.getitemstring(row, "limit_yn")


	if ls_own_gubn <> "B" then
	
		select dbo.sf_shop_nm(:ls_shop_cd, 'a')
		into :ls_shop_nm
		from dual;
		
		select sum(isnull(rqst_qty,0))	
		into :ll_wanbul 
		 from tb_54031_d with (nolock) 
		where style     = :is_style
		  and color     = :is_color 
		  and size      = :is_size 
		  and rt_shop   = :ls_shop_cd
		  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;  
		
		
		select sum(isnull(move_qty,0))	
		 into :ll_gijisi 
		 from tb_54013_h with (nolock) 
		where style       = :is_style
		  and color       = :is_color 
		  and size        = :is_size 
		  and fr_shop_cd  = :ls_shop_cd
		  and yymmdd    between   convert(char(08), dateadd(day, -6, :is_yymmdd),112)   and  convert(char(08), dateadd(day, 7,:is_yymmdd) ,112) ;
		
		
		ll_out_qty = tab_1.tabpage_3.dw_2.GetitemNumber(row, "shop_stock_qty")
		ll_row = tab_1.tabpage_3.dw_4.rowcount()
		
		dw_4.AcceptText() 
		for kk =  1 to ll_row 
		ll_found = tab_1.tabpage_3.dw_4.Find("fr_shop_cd = '" + ls_shop_cd + "'", ll_found, kk  )
			if ll_found > 0 then
				ll_qty = ll_qty + tab_1.tabpage_3.dw_4.GetitemNumber(ll_found, "move_qty")
			end if	
		next
		
		ll_out_qty = ll_out_qty - ll_qty
		
		//messagebox("1", string(ll_out_qty))
		//messagebox("2", string(ll_qty))
		
		if ll_out_qty <= 0 then //ll_qty > ll_out_qty then
			messagebox("경고!","가용재고를 초과 하였습니다!")
				ii_row = ii_row - 1		
		else		
			
			if ll_row = ii_row - 1  and isnull(	tab_1.tabpage_3.dw_4.getitemstring(ll_row, "to_shop_cd") ) = false then
				tab_1.tabpage_3.dw_4.insertrow(0)
				ll_row = tab_1.tabpage_3.dw_4.rowcount()
				tab_1.tabpage_3.dw_4.Setitem(ll_row, "fr_shop_cd",ls_shop_cd) 
				tab_1.tabpage_3.dw_4.Setitem(ll_row, "fr_shop_nm",ls_shop_nm) 	
				tab_1.tabpage_3.dw_4.Setitem(ll_row, "move_qty",  ll_out_qty ) 	
				tab_1.tabpage_3.dw_4.Setitem(ll_row, "gijisi",    ll_gijisi ) 	
				tab_1.tabpage_3.dw_4.Setitem(ll_row, "wanbul",    ll_wanbul ) 			
			else	
				ii_row = ii_row - 1		
			end if
		end if	
else	
	messagebox("경고!","담당매장이 아닙니다!")
end if


if ls_force = "Y" then
	
	if ls_limit_yn <> "Y" then

		ll_row = tab_1.tabpage_3.dw_4.rowcount()
		tab_1.tabpage_3.dw_4.AcceptText() 
		if isnull(tab_1.tabpage_3.dw_4.getitemstring(ii_row, "to_shop_cd") )  then
			tab_1.tabpage_3.dw_4.Setitem(ll_row, "yymmdd",is_yymmdd) 	
			tab_1.tabpage_3.dw_4.Setitem(ll_row, "to_shop_cd",ls_shop_cd) 
			tab_1.tabpage_3.dw_4.Setitem(ll_row, "to_shop_nm",ls_shop_nm) 	
			cb_update.enabled = true
			ib_changed = true
		end if
	else
		messagebox("알림!", "RT제한 매장입니다!")
	end if	
end if	

//if ls_force = "Y" then
//	
//		ll_row = dw_4.rowcount()
//		dw_4.AcceptText() 
//		if isnull(	dw_4.getitemstring(ii_row, "to_shop_cd") )  then
//			dw_4.Setitem(ll_row, "yymmdd",is_yymmdd) 	
//			dw_4.Setitem(ll_row, "to_shop_cd",ls_shop_cd) 
//			dw_4.Setitem(ll_row, "to_shop_nm",ls_shop_nm) 	
//			cb_update.enabled = true
//			ib_changed = true
//		end if
//
//end if	

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

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1468
long backcolor = 79741120
string text = "승인및 당일 작업 조회"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_4.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_4.destroy
destroy(this.dw_5)
end on

event constructor;//il_index = 4
end event

type dw_5 from datawindow within tabpage_4
integer width = 3570
integer height = 1460
integer taborder = 120
string dataobject = "d_54018_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;Long	ll_row_count, i

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
		Next
END CHOOSE

end event

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

event clicked;gf_tSort(tab_1.tabpage_4.dw_5)
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3570
integer height = 1468
long backcolor = 79741120
string text = "제한매장"
long tabtextcolor = 255
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_7 dw_7
dw_6 dw_6
end type

event constructor;//il_index = 5
end event

on tabpage_5.create
this.dw_7=create dw_7
this.dw_6=create dw_6
this.Control[]={this.dw_7,&
this.dw_6}
end on

on tabpage_5.destroy
destroy(this.dw_7)
destroy(this.dw_6)
end on

type dw_7 from datawindow within tabpage_5
integer y = 176
integer width = 3561
integer height = 1264
integer taborder = 20
string title = "none"
string dataobject = "d_54018_d08"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;gf_tSort(tab_1.tabpage_5.dw_7)
end event

type dw_6 from datawindow within tabpage_5
integer width = 3566
integer height = 172
integer taborder = 20
string title = "none"
string dataobject = "d_54018_d09"
boolean resizable = true
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

		ls_sort = tab_1.tabpage_5.dw_6.GetItemString(1, "sort_opt")

		IF tab_1.tabpage_5.dw_6.AcceptText() <> 1 THEN RETURN 0
		is_brand = dw_head.GetItemString(1, "brand")
		if IsNull(is_brand) or Trim(is_brand) = "" then
			MessageBox("경고!","브랜드를 입력하십시요!")
			tab_1.tabpage_5.dw_6.SetFocus()
			tab_1.tabpage_5.dw_6.SetColumn("brand")
			return 0
		end if		

		ls_yymmdd = tab_1.tabpage_5.dw_6.GetItemString(1, "rt_ymd")
		if IsNull(ls_yymmdd) or Trim(ls_yymmdd) = "" then
			MessageBox("경고!","기준일을 입력하십시요!")
			tab_1.tabpage_5.dw_6.SetFocus()
			tab_1.tabpage_5.dw_6.SetColumn("shop_div")
			return 0
		end if
		
		ld_rt_rate = tab_1.tabpage_5.dw_6.GetItemNumber(1, "rt_rate")
		if IsNull(ld_rt_rate) then
			MessageBox("경고!","기준RT율을 입력하십시요!")
			tab_1.tabpage_5.dw_6.SetFocus()
			tab_1.tabpage_5.dw_6.SetColumn("rt_rate")
			return 0
		end if		
		
		if ls_sort = "1" then 
				tab_1.tabpage_5.dw_7.SetSort("move_rate D")
			elseif ls_sort = "2" then 	
				tab_1.tabpage_5.dw_7.SetSort("move_rate A")
			elseif ls_sort = "3" then 	
				tab_1.tabpage_5.dw_7.SetSort("move_qty D")				
			elseif ls_sort = "4" then 	
				tab_1.tabpage_5.dw_7.SetSort("proc_qty D")		
			else	
				tab_1.tabpage_5.dw_7.SetSort("fr_shop_nm A")		
			end if	

		ll_row = tab_1.tabpage_5.dw_7.retrieve(ls_yymmdd, is_brand,ld_rt_rate)
		IF ll_row > 0 THEN
			tab_1.tabpage_5.dw_7.SetFocus()
		ELSEIF ll_row = 0 THEN
			MessageBox("조회", "조회할 자료가 없습니다.")
		ELSE
			MessageBox("조회오류", "조회 실패 하였습니다.")
		END IF
			
		
	case "cb_update"	
		
		IF tab_1.tabpage_5.dw_7.AcceptText() <> 1 THEN RETURN 0
		
		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF
		
		ll_row_count = tab_1.tabpage_5.dw_7.RowCount()
		
	FOR i=1 TO ll_row_count
			idw_status = tab_1.tabpage_5.dw_7.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified!  THEN				/* New Record    */
			tab_1.tabpage_5.dw_7.Setitem(i, "brand", is_brand)
			tab_1.tabpage_5.dw_7.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		   /* Modify Record */ 
			ls_reg_id = tab_1.tabpage_5.dw_7.GetitemString(i, "reg_id") 
			IF isnull(ls_reg_id) or Trim(ls_reg_id) = "" THEN 
				tab_1.tabpage_5.dw_7.SetItemStatus(i, 0, Primary!, NewModified!)
				tab_1.tabpage_5.dw_7.Setitem(i, "reg_id", gs_user_id)
			ELSE
				tab_1.tabpage_5.dw_7.Setitem(i, "mod_id", gs_user_id)
				tab_1.tabpage_5.dw_7.Setitem(i, "mod_dt", ld_datetime)
			END IF
		END IF
	NEXT
	
		il_rows = dw_7.Update(TRUE, FALSE)
	
		
		if il_rows = 1 then
			tab_1.tabpage_5.dw_7.ResetUpdate()
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

type cb_1 from commandbutton within w_54018_e
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

event clicked;tab_1.tabpage_1.dw_0.visible = false
tab_1.tabpage_2.dw_1.visible = true
tab_1.tabpage_3.dw_2.visible = false
tab_1.tabpage_3.dw_3.visible = false
tab_1.tabpage_3.dw_4.visible = false
tab_1.tabpage_4.dw_5.visible = false
end event

type cb_3 from commandbutton within w_54018_e
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

event clicked;tab_1.tabpage_1.dw_0.visible = true
tab_1.tabpage_2.dw_1.visible = false
tab_1.tabpage_3.dw_2.visible = false
tab_1.tabpage_3.dw_3.visible = false
tab_1.tabpage_3.dw_4.visible = false
tab_1.tabpage_4.dw_5.visible = false

end event

type cbx_1 from checkbox within w_54018_e
integer x = 3017
integer y = 476
integer width = 402
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

type cbx_2 from checkbox within w_54018_e
integer x = 2322
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

type cb_4 from commandbutton within w_54018_e
boolean visible = false
integer x = 1047
integer y = 468
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

event clicked;tab_1.tabpage_1.dw_0.visible = false
tab_1.tabpage_2.dw_1.visible = false
tab_1.tabpage_3.dw_2.visible = true
tab_1.tabpage_3.dw_3.visible = true
tab_1.tabpage_3.dw_4.visible = true
tab_1.tabpage_4.dw_5.visible = false

end event

type cb_2 from commandbutton within w_54018_e
boolean visible = false
integer x = 1545
integer y = 472
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

event clicked;tab_1.tabpage_1.dw_0.visible = false
tab_1.tabpage_2.dw_1.visible = false
tab_1.tabpage_3.dw_2.visible = false
tab_1.tabpage_3.dw_3.visible = false
tab_1.tabpage_3.dw_4.visible = false
tab_1.tabpage_4.dw_5.visible = true


is_proc_yn = "N"
end event

type cb_5 from commandbutton within w_54018_e
boolean visible = false
integer x = 2208
integer width = 402
integer height = 84
integer taborder = 130
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

type dw_12 from datawindow within w_54018_e
boolean visible = false
integer x = 2807
integer y = 196
integer width = 663
integer height = 328
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_54013_d10"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_8 from datawindow within w_54018_e
boolean visible = false
integer x = 64
integer y = 568
integer width = 2798
integer height = 916
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "예약재고"
string dataobject = "d_54018_d11"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

