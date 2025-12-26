$PBExportHeader$w_54005_e.srw
$PBExportComments$부진모델확정
forward
global type w_54005_e from w_com010_e
end type
type dw_2 from datawindow within w_54005_e
end type
type dw_1 from datawindow within w_54005_e
end type
type dw_3 from datawindow within w_54005_e
end type
end forward

global type w_54005_e from w_com010_e
integer width = 3698
string title = "부진모델분석"
dw_2 dw_2
dw_1 dw_1
dw_3 dw_3
end type
global w_54005_e w_54005_e

type variables
string  is_brand, is_year, is_season, is_sojae, is_item, is_out_seq,is_dep_seq,is_dep_ymd, is_rtrn_ymd, is_worK_gubn
DataWindowChild   idw_brand, idw_season, idw_sojae, idw_item, idw_out_seq

end variables

on w_54005_e.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_3
end on

on w_54005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_3)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
String   ls_title, ls_dep_seq

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




is_year = dw_head.GetitemString(1, "year")
if Isnull(is_year) or Trim(is_year) = "" then
	MessageBox(ls_title, "시즌년도를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("year")
	return false
end if

is_season = dw_head.GetitemString(1, "season")
if Isnull(is_season) or Trim(is_season) = "" then
	MessageBox(ls_title, "시즌을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("season")
	return false
end if

is_sojae = dw_head.GetitemString(1, "sojae")
if Isnull(is_sojae) or Trim(is_sojae) = "" then
	MessageBox(ls_title, "소재를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("sojae")
	return false
end if

is_item = dw_head.GetitemString(1, "item")
if Isnull(is_item) or Trim(is_item) = "" then
	MessageBox(ls_title, "품종을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("item")
	return false
end if

is_out_seq = dw_head.GetitemString(1, "out_seq")
if Isnull(is_out_seq) or Trim(is_out_seq) = "" then
	MessageBox(ls_title, "출고차수를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("out_seq")
	return false
end if

is_rtrn_ymd = dw_head.GetitemString(1, "rtrn_ymd")
if Isnull(is_rtrn_ymd) or Trim(is_rtrn_ymd) = "" then
	MessageBox(ls_title, "적용일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("rtrn_ymd")
	return false
end if

is_work_gubn = dw_head.GetitemString(1, "work_gubn")
if Isnull(is_work_gubn) or Trim(is_work_gubn) = "" then
	MessageBox(ls_title, "작업구분을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("work_gubn")
	return false
end if


 is_dep_ymd = dw_head.GetitemString(1,"dep_ymd")
 
 if is_work_gubn = "A" then 
 
	select substring(convert(varchar(3), convert(decimal(5),isnull(max(dep_seq), '0')) + 101), 2, 2)
	  into :ls_dep_seq
	  from dbo.tb_12020_m  
	 where brand  =  :is_brand
		and year   =  :is_year 
		and season =  :is_season
		and dep_ymd < :is_dep_ymd;
	
elseif is_work_gubn = "B" then 
	
	select substring(convert(varchar(3), convert(decimal(5),isnull(max(dep_seq), '0')) + 101), 2, 2)
	  into :ls_dep_seq
	  from dbo.tb_54021_h  
	 where brand  =  :is_brand
		and year   =  :is_year 
		and season =  :is_season
		and dep_ymd < :is_dep_ymd;
else
	
	select substring(convert(varchar(3), convert(decimal(5),isnull(max(dep_seq), '0')) + 101), 2, 2)
	  into :ls_dep_seq
	  from dbo.tb_54022_h  
	 where brand  =  :is_brand
		and year   =  :is_year 
		and season =  :is_season
		and dep_ymd < :is_dep_ymd;
			
	
end if	
	
 dw_head.Setitem(1,"dep_seq", ls_dep_seq)
 is_dep_seq = dw_head.GetitemString(1,"dep_seq")

 	
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


if is_work_gubn = "A" then 
	dw_1.dataobject = "d_54005_d02"
	dw_1.SetTransObject(SQLCA)
	
	dw_body.dataobject = "d_54005_d01"
	dw_body.SetTransObject(SQLCA)
		
	dw_print.dataobject = "d_54005_r01"
	dw_print.SetTransObject(SQLCA)
	
elseif is_work_gubn = "B" then 	
	dw_1.dataobject = "d_54005_d04"
	dw_1.SetTransObject(SQLCA)

	dw_body.dataobject = "d_54005_d05"
	dw_body.SetTransObject(SQLCA)
		
	dw_print.dataobject = "d_54005_r02"
	dw_print.SetTransObject(SQLCA)

else	
	dw_1.dataobject = "d_54005_d07"
	dw_1.SetTransObject(SQLCA)

	dw_body.dataobject = "d_54005_d06"
	dw_body.SetTransObject(SQLCA)
		
	dw_print.dataobject = "d_54005_r03"
	dw_print.SetTransObject(SQLCA)
end if	


dw_1.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_out_seq)  /*부진모델 file read */
dw_2.retrieve()  /* style master read */

il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_out_seq)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)



end event

event pfc_preopen();call super::pfc_preopen;string ls_dep_ymd
datetime ld_datetime
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_dep_ymd = String(ld_datetime, "yyyymmdd")
dw_head.Setitem(1,"dep_ymd", ls_dep_ymd)

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
long i, ii, ll_row_count,ll_row, ll_row2, ll_row_count2
datetime ld_datetime, t_datetime
STRING   ls_style, ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_out_seq, ls_dep_fg, ls_dotcom
string t_style, ls_style2


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN 
		ls_dep_fg  = dw_body.GetitemString(i, "dep_fg")
		
		if is_work_gubn = "A" then
			ls_dotcom = dw_body.GetitemString(i, "tb_54020_h_dotcom")
		end if
		
		ls_style   = dw_body.GetitemString(i, "style") 
		
		ll_row  = dw_1.Find("style = '" + ls_style + "'", 1, dw_1.RowCount())
		ll_row2 = dw_2.Find("style = '" + ls_style + "'", 1, dw_2.RowCount())
		IF ll_row > 0 THEN 
			IF  ls_dep_fg  = 'N'       THEN 
				 dw_1.Setitem(ll_row, "dep_fg" , ls_dep_fg) 
				 dw_1.Setitem(ll_row, "dep_seq" , '') 
				 dw_1.Setitem(ll_row, "dep_ymd" , '') 
				 dw_1.Setitem(ll_row, "rtrn_ymd" , '') 
             dw_1.Setitem(ll_row, "mod_id", gs_user_id)
             dw_1.Setitem(ll_row, "mod_dt", ld_datetime)	
				
				 if is_work_gubn = "A" then
					 dw_1.Setitem(ll_row, "dotcom" , "N") 				 
					 dw_2.Setitem(ll_row2, "dep_fg" , ls_dep_fg) 
					 dw_2.Setitem(ll_row2, "dep_seq" , '') 
					 dw_2.Setitem(ll_row2, "dep_ymd" , '') 
					 dw_2.Setitem(ll_row2, "mod_id", gs_user_id)
					 dw_2.Setitem(ll_row2, "mod_dt", ld_datetime)		
				end if	 
			ELSE
				 dw_1.Setitem(ll_row, "dep_fg" , ls_dep_fg) 
				 dw_1.Setitem(ll_row, "dep_seq" , is_dep_seq) 
				 dw_1.Setitem(ll_row, "dep_ymd" , is_dep_ymd) 
				 dw_1.Setitem(ll_row, "rtrn_ymd" , is_rtrn_ymd) 
             dw_1.Setitem(ll_row, "mod_id", gs_user_id)
             dw_1.Setitem(ll_row, "mod_dt", ld_datetime)
				 
				 //잡화전용 정상/행사구분 테이블 insert
				 dw_3.insertrow(0)
				 dw_3.Setitem(ll_row, "style", ls_style)
		 				 
				 if is_work_gubn = "A" then
					 dw_1.Setitem(ll_row, "dotcom" , ls_dotcom) 							
					 dw_2.Setitem(ll_row2, "dep_fg" , ls_dep_fg) 
					 dw_2.Setitem(ll_row2, "dep_seq" , is_dep_seq) 
					 dw_2.Setitem(ll_row2, "dep_ymd" , is_dep_ymd) 
					 dw_2.Setitem(ll_row2, "mod_id", gs_user_id)
					 dw_2.Setitem(ll_row2, "mod_dt", ld_datetime)
				end if	 
			END IF
		END IF
   END IF
NEXT


//잡화전용 정상/행사구분 테이블 tb_54060_h insert
//라빠,조이만 해당

if is_brand = 'B' or is_brand = 'L' or is_brand = 'F' then
	ll_row_count2 = dw_3.RowCount()
	if ll_row_count2 > 0 then
		for ii = 1 to ll_row_count2
			ls_style2   = dw_3.GetitemString(ii, "style")
			
			 DECLARE sp_54060_d01 PROCEDURE FOR sp_54060_d01  
							@style   = :ls_style2,
							@reg_id  = :gs_user_id;
				execute sp_54060_d01;	
		next
	end if
end if


il_rows = dw_1.Update()
 if is_work_gubn = "A" then
	il_rows = dw_2.Update()
 end if	 	

if il_rows = 1 then
	dw_body.ResetUpdate()
	dw_3.reset()
   commit  USING SQLCA;

else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows




end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.Retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_out_seq,is_dep_seq)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.02.02                                                  */	
/* 수정일      : 2002.02.02                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =  "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_sojae.Text = '" + idw_sojae.GetItemString(idw_Sojae.GetRow(), "sojae_display") + "'"   + &
				 "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'"   + &
				 "t_out_seq.Text = '" +  is_out_seq + "'"  + &
				 "t_dep_seq.Text = '" + is_dep_seq + "'" + &
				 "t_dep_ymd.Text = '" + is_dep_ymd + "'"
dw_print.Modify(ls_modify)



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54005_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54005_e
end type

type cb_delete from w_com010_e`cb_delete within w_54005_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_54005_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54005_e
end type

type cb_update from w_com010_e`cb_update within w_54005_e
end type

type cb_print from w_com010_e`cb_print within w_54005_e
end type

type cb_preview from w_com010_e`cb_preview within w_54005_e
end type

type gb_button from w_com010_e`gb_button within w_54005_e
end type

type cb_excel from w_com010_e`cb_excel within w_54005_e
end type

type dw_head from w_com010_e`dw_head within w_54005_e
integer height = 192
string dataobject = "d_54005_h01"
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("item", idw_item)
idw_item.SetTRansObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.insertrow(1)
idw_sojae.Setitem(1, "sojae", "%")
idw_sojae.Setitem(1, "sojae_nm", "전체")

This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('010')
idw_out_seq.Insertrow(1)
idw_out_seq.Setitem(1,"inter_cd", "%")
idw_out_seq.Setitem(1,"inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;//int li_ret
//
//CHOOSE CASE dwo.name
//	case "work_GUBN"
//		
//		messagebox("DATA", DATA)
//		
//		if DATA = "A" THEN
//			dw_head.object.t_dep_ymd.text = "부진일자"
//			dw_head.object.t_dep_seq.text = "부진차수"			
//		else	
//			dw_head.object.t_dep_ymd.text = "선정일자"
//			dw_head.object.t_dep_seq.text = "선정차수"						
//		end if
//		
//
//END CHOOSE
////

String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name


		
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
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

type ln_1 from w_com010_e`ln_1 within w_54005_e
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_e`ln_2 within w_54005_e
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_e`dw_body within w_54005_e
integer x = 0
integer y = 416
integer width = 3602
integer height = 1644
string dataobject = "d_54005_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_e`dw_print within w_54005_e
integer x = 1792
integer y = 892
string dataobject = "d_54005_r02"
end type

type dw_2 from datawindow within w_54005_e
boolean visible = false
integer x = 55
integer y = 1356
integer width = 1445
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54005_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_54005_e
boolean visible = false
integer x = 41
integer y = 892
integer width = 1454
integer height = 424
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54005_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_54005_e
boolean visible = false
integer x = 1531
integer y = 1356
integer width = 1445
integer height = 432
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_54005_d08"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

