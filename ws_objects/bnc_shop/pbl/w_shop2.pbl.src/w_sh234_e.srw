$PBExportHeader$w_sh234_e.srw
$PBExportComments$주간리포트(스타일반응)
forward
global type w_sh234_e from w_com010_e
end type
type tab_1 from tab within w_sh234_e
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tab_1 from tab within w_sh234_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_2 from datawindow within w_sh234_e
end type
type cb_retrieve1 from commandbutton within w_sh234_e
end type
type st_1 from statictext within w_sh234_e
end type
type dw_1 from datawindow within w_sh234_e
end type
end forward

global type w_sh234_e from w_com010_e
integer width = 2981
integer height = 2048
tab_1 tab_1
dw_2 dw_2
cb_retrieve1 cb_retrieve1
st_1 st_1
dw_1 dw_1
end type
global w_sh234_e w_sh234_e

type variables
DataWindowChild idw_year, idw_season
String is_shop_cd, is_style, is_year, is_season, is_fr_ymd, is_to_ymd, is_yymmdd, is_chno, is_emp_gubn
integer ii_week_no
end variables

forward prototypes
public subroutine wf_head_init ()
end prototypes

public subroutine wf_head_init ();datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF


is_yymmdd = string(ld_datetime,"yyyymmdd")

//  select min(t_date) 	as fr_ymd, 
//			max(t_date)		as to_ymd, 
//			min(week_cd)	as week_no
//	into :is_fr_ymd, :is_to_ymd, :ii_week_no		
//	 from tb_date
//	where week_cd = datediff(week, dateadd(week, -1, :is_yymmdd))
//     and t_date like left(convert(char(08), dateadd(day, -7,:is_yymmdd),112),4) + '%' ;
//	  

if is_yymmdd = '20080107' then
  select '20071231' 	as fr_ymd, 
			max(t_date)		as to_ymd, 
			min(datepart(week, dateadd(week, 0, t_date)))	as week_no
	into :is_fr_ymd, :is_to_ymd, :ii_week_no					
   from tb_date
	where datepart(week,  t_date) = datepart(week, dateadd(week, -1, '20080108'))
     and t_date like left(convert(char(08), dateadd(day, -7, '20080108'),112),4) + '%' ;	  
else	  
  select min(t_date) 	as fr_ymd, 
			max(t_date)		as to_ymd, 
			min(datepart(week, dateadd(week, 0, t_date)))	as week_no
	into :is_fr_ymd, :is_to_ymd, :ii_week_no					
   from tb_date
	where datepart(week,  t_date) = datepart(week, dateadd(week, -1, :is_yymmdd))
     and t_date like left(convert(char(08), dateadd(day, -7, :is_yymmdd),112),4) + '%' ;	  
end if	  	  
	  
	  
dw_head.setitem(1, "fr_ymd", is_fr_ymd)	  
//dw_head.setitem(1, "to_ymd", is_to_ymd)
dw_head.setitem(1, "to_ymd", is_yymmdd)
dw_head.setitem(1, "week_no", ii_week_no)
dw_head.setitem(1, "yymmdd", is_yymmdd)
end subroutine

on w_sh234_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_2=create dw_2
this.cb_retrieve1=create cb_retrieve1
this.st_1=create st_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.cb_retrieve1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_1
end on

on w_sh234_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_2)
destroy(this.cb_retrieve1)
destroy(this.st_1)
destroy(this.dw_1)
end on

event open;call super::open;string ls_shop_nm

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

wf_head_init()
dw_head.setitem(1, "shop_cd", gs_shop_cd)
IF gf_shop_nm(gs_shop_cd, 'S', ls_shop_nm) = 0 THEN
  dw_head.SetItem(1, "shop_nm", ls_shop_nm)
END IF 

dw_head.setitem(1, "year", "%")
dw_head.setitem(1, "season", "%")
end event

event ue_retrieve();call super::ue_retrieve;integer ii
string ls_flag
long ll_rows

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

//messagebox("BRAND", 	gs_brand + ' ' + is_shop_cd + ' ' + is_yymmdd + ' ' + is_fr_ymd + ' ' + is_to_ymd + ' ' +	string(ii_week_no,"0000") + ' ' + is_style + ' ' + is_chno + ' ' + is_year + ' ' + is_year)
	il_rows = dw_body.retrieve(gs_brand, is_shop_cd, is_yymmdd, is_fr_ymd, is_to_ymd, ii_week_no, is_style, is_chno, is_year, is_year)

   ll_rows = dw_1.retrieve(gs_brand, is_shop_cd, is_yymmdd, is_emp_gubn)
	
	IF ll_rows > 0 THEN
	for ii = 1 to ll_rows
		ls_flag = dw_1.getitemstring(ii, "flag")
			if ls_flag = "new" then
			dw_1.SetItemStatus(ii, 0, Primary!, NewModified!)		
		   end if	
	next
	END IF
	

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF


if is_shop_cd <> gs_shoP_cd then
	dw_body.object.contents_1.protect = 1
	dw_body.object.contents_2.protect = 1
	dw_1.object.contents.protect = 1	
else	
	dw_body.object.contents_1.protect = 0
	dw_body.object.contents_2.protect = 0
	dw_1.object.contents.protect = 0
end if	


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(TAB_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(cb_retrieve1, "FixedToRight")
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
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
				dw_body.enabled = true				

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
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

   CASE 5    /* 조건 */
    		
	   cb_retrieve.Text = "신상품등록(&Q)"
		wf_head_init()		
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
		
END CHOOSE

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;//BRAND	SHOP_CD  YYMMDD  fr_ymd  to_ymd	week_no	style	 chno year season

string   ls_title,ls_max_ymd, ls_yymmdd
long li_week_no, li_week_no1
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

ls_yymmdd = string(ld_datetime,"yyyymmdd")

//(NG0006),롯데부산(NG1024)
//롯데전주(ng1117),롯데잠실(ng0009)
//수원애경(ng1111),현대천호(ng0019)


//if gs_brand = "O" then
//		messagebox("알림!", "현재 온앤온과 W. 매장만 시범운영중입니다!")
//  	   return false
//elseif gs_brand = "N" then
////	if gs_shop_cd  = "NG0030" then
////	elseif gs_shop_cd  = "NK2075" then
////	elseif gs_shop_cd  = "NG0008"  then
////	elseif gs_shop_cd  = "NG1115"  then 
////	elseif gs_shop_cd  = "NX4994"  then 	
////	elseif gs_shop_cd  = "NG0006"  then 
////	elseif gs_shop_cd  = "NG1024"  then 	
////	elseif gs_shop_cd  = "NG1117"  then 	
////	elseif gs_shop_cd  = "NG0009"  then 	
////	elseif gs_shop_cd  = "NG1111"  then 	
////	elseif gs_shop_cd  = "NG0019"  then 	
////	elseif gs_shop_cd  = "NG1078"  then 			
////	elseif gs_shop_cd  = "NG0037"  then 			
////	
////	else	
////		MessageBox(ls_title,"테스트대상 매장만 사용가능합니다!")
////  	   return false
////	end if
//end if

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"등록일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"출고기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"출고기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	 is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	 is_chno = "%"
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
	 is_year = "%"
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
	 is_season = "%"
end if

ii_week_no = dw_head.GetItemNumber(1, "week_no")
is_emp_gubn = "SHM"

if dw_body.visible = true then

	select max(yymmdd), isnull(datepart(wk, max(yymmdd)),0), datepart(wk, :is_yymmdd)
	into :ls_max_ymd, :li_week_no, :li_week_no1
	from TB_54036_H (nolock)
	where shop_cd 		= :is_shoP_cd
	  and brand  		= :gs_brand;
	  
	if li_week_no = li_week_no1 then
		messagebox("경고!", "스타일 반응은 금주" + '"' + ls_max_ymd + '"' + "일에 입력 하셨습니다!")		
		//dw_head.setitem(1, "yymmdd", ls_max_ymd)	
		//is_yymmdd = ls_max_ymd		
	end if	


else
	select max(yymmdd), isnull(datepart(wk, max(yymmdd)),0), datepart(wk, :is_yymmdd)
	into :ls_max_ymd, :li_week_no, :li_week_no1
	from TB_54035_H (nolock)
	where shop_cd 		= :is_shoP_cd
	  and brand  		= :gs_brand;
	  
	if li_week_no = li_week_no1 then
		messagebox("경고!", "주간리포트는 금주" + '"' + ls_max_ymd + '"' + "일에 입력 하셨습니다!")
		dw_head.setitem(1, "yymmdd", ls_max_ymd)	
		is_yymmdd = ls_max_ymd		
	end if	
	

end if  


return true
end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_cnt
datetime ld_datetime
String ls_reg_id
		
if dw_body.visible = true then
		
		ll_row_count = dw_body.RowCount()
		IF dw_body.AcceptText() <> 1 THEN RETURN -1
		
		/* 시스템 날짜를 가져온다 */
		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF
		
		
		FOR i=1 TO ll_row_count
			ls_reg_id = dw_body.GetitemString(i, "reg_id") 
			IF isnull(ls_reg_id) or Trim(ls_reg_id) = "" THEN 
				dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
			end if
			
			idw_status = dw_body.GetItemStatus(i, 0, Primary!)
			 IF idw_status = NewModified! or idw_status = New! THEN				/* New Record    */
				dw_body.Setitem(i, "reg_id", gs_shoP_cd)
			ELSEIF idw_status = DataModified! THEN		   /* Modify Record */ 
				ls_reg_id = dw_body.GetitemString(i, "reg_id") 
				IF isnull(ls_reg_id) or Trim(ls_reg_id) = "" THEN 
					dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
					dw_body.Setitem(i, "reg_id", gs_shoP_cd)
				ELSE
					dw_body.Setitem(i, "mod_id", gs_shoP_cd)
					dw_body.Setitem(i, "mod_dt", ld_datetime)
				END IF
			END IF
		NEXT
		
		
		il_rows = dw_body.Update(TRUE, FALSE)
		
		if il_rows = 1 then
			dw_body.ResetUpdate()
			commit  USING SQLCA;
		else
			rollback  USING SQLCA;
		end if
else
		ll_row_count = dw_1.RowCount()
		IF dw_1.AcceptText() <> 1 THEN RETURN -1
		
		/* 시스템 날짜를 가져온다 */
		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF
		
		ll_cnt = dw_1.getitemnumber(1, "c_t_cnt")
		if ll_cnt < 2 then 
			messagebox("알림!", "두개이상의 항목과 최저 글자수에 충족되지 않습니다! 확인 후 저장하세요!")
			return 0
		end if	
		
		FOR i=1 TO ll_row_count
			idw_status = dw_1.GetItemStatus(i, 0, Primary!)
			IF idw_status = NewModified! THEN				/* New Record */
				dw_1.Setitem(i, "yymmdd"   , is_yymmdd)	
				dw_1.Setitem(i, "shop_cd"  , gs_shop_cd)
				dw_1.Setitem(i, "emp_gubn" , is_emp_gubn)		
				dw_1.Setitem(i, "brand"    , gs_brand)				
				dw_1.Setitem(i, "reg_id"   , gs_user_id)
			ELSEIF idw_status = DataModified! THEN		/* Modify Record */
				dw_1.Setitem(i, "mod_id", gs_user_id)
				dw_1.Setitem(i, "mod_dt", ld_datetime)
			END IF
		NEXT
		
		il_rows = dw_1.Update(TRUE, FALSE)
		
		if il_rows = 1 then
			dw_1.ResetUpdate()
			commit  USING SQLCA;
		else
			rollback  USING SQLCA;
		end if		
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

CHOOSE CASE as_column
	CASE "shop_cd"					
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 and LeftA(as_data,1) = gs_brand THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and brand = '" + gs_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			

			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%' and chno in ( '0','S') "	
				else 	
					gst_cd.default_where   = " WHERE  tag_price <> 0 "
				end if
				
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
								
  
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
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

type cb_close from w_com010_e`cb_close within w_sh234_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh234_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh234_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh234_e
integer x = 2098
integer width = 393
string text = "신상품등록(&Q)"
end type

event cb_retrieve::clicked;wf_head_init()	

pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True
end event

type cb_update from w_com010_e`cb_update within w_sh234_e
end type

type cb_print from w_com010_e`cb_print within w_sh234_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh234_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh234_e
end type

type dw_head from w_com010_e`dw_head within w_sh234_e
integer y = 156
integer height = 208
string dataobject = "d_sh234_h01"
end type

event dw_head::constructor;call super::constructor;string ls_year
datetime ld_datetime
DataWindowChild ldw_child 

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertRow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_nm", "전체")


//라빠레트 시즌적용
SELECT GetDate()
  INTO :ld_datetime
  FROM DUAL ;

GF_CURR_YEAR(ld_datetime, ls_year)

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
//idw_season.retrieve('003', gs_brand, is_year)
idw_season.retrieve('003', gs_brand, ls_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")
end event

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
string ls_shop_nm



CHOOSE CASE dwo.name
	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')		

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if
			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)			
			
			IF gf_shop_nm(gs_shop_cd, 'S', ls_shop_nm) = 0 and LeftA(gs_shop_cd,1) = gs_brand THEN
				dw_head.SetItem(1, "shop_nm", ls_shop_nm)
				dw_head.SetItem(1, "shop_cd", gs_shop_cd)
				RETURN 0
			END IF 
			
			Trigger Event ue_retrieve()
			
	CASE "shop_cd"      // dddw로 작성된 항목
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_year = dw_head.getitemstring(1,'year')
			gs_brand = dw_head.getitemstring(1,'brand')		
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', gs_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")


END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh234_e
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_sh234_e
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_sh234_e
integer x = 18
integer y = 484
integer width = 2862
integer height = 1296
string dataobject = "D_SH234_D01"
end type

event dw_body::ue_keydown;String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
	If MidA(ls_column_name,1,8) <> 'contents'   Then
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_style, ls_chno
long ll_rows

CHOOSE CASE dwo.name
	CASE "style_1" 
		
			ls_style = dw_body.getitemstring(row, "style_1")
			ls_chno  = dw_body.getitemstring(row, "chno_1")			
			ll_rows = dw_2.retrieve(ls_style, ls_chno)
			if ll_rows > 0 then 
				dw_2.visible = true
			else	
				dw_2.visible = false				
			end if	
			
	CASE "style_2" 		

		  ls_style = dw_body.getitemstring(row, "style_2")
			ls_chno  = dw_body.getitemstring(row, "chno_2")			
			ll_rows = dw_2.retrieve(ls_style, ls_chno)
			if ll_rows > 0 then 
				dw_2.visible = true
			else	
				dw_2.visible = false				
			end if	


END CHOOSE



end event

type dw_print from w_com010_e`dw_print within w_sh234_e
end type

type tab_1 from tab within w_sh234_e
integer x = 5
integer y = 384
integer width = 2889
integer height = 1412
integer taborder = 40
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
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event clicked;long ll_cnt, ll_rowcnt, ll_input, ll_style_cnt

IF ib_changed THEN 
CHOOSE CASE gf_update_yn(parent.title)
	CASE 1
		IF parent.Trigger Event ue_update() < 1 THEN
			return
		END IF		
	CASE 3
		return
END CHOOSE
END IF

	
	CHOOSE CASE index
		CASE 1
				dw_head.object.shop_cd_t.visible = true				
				dw_head.object.shop_cd.visible = true
				dw_head.object.shop_nm.visible = true				
				dw_head.object.cb_shop_cd.visible = true								
				dw_head.object.fr_ymd.visible = true								
				dw_head.object.fr_ymd_t.visible = true							
				dw_head.object.t_1.visible = true						
				dw_head.object.to_ymd.visible = true								
				dw_head.object.style_t.visible = true																
				dw_head.object.style.visible = true												
				dw_head.object.chno.visible = true												
				dw_head.object.cb_style.visible = true						
				dw_head.object.year_t.visible = true																
				dw_head.object.year.visible = true												
				dw_head.object.season.visible = true				
			
			dw_body.visible = true
			dw_1.visible = false
		
		CASE 2
		 	ll_cnt = dw_body.getitemnumber(1,"c_cnt_contents") 
//		   ll_style_cnt = dw_body.getitemnumber(1,"c_tot_style_cnt") 
			
			if isnull(ll_cnt) then ll_cnt = 0 
			ll_rowcnt = dw_body.rowcount()
			
			if ll_rowcnt < 10 then
				ll_input = ll_rowcnt
			else 	
				ll_input = 10
			end if	
			
			if ll_cnt >= ll_input then
				dw_head.object.shop_cd_t.visible = false				
				dw_head.object.shop_cd.visible = false
				dw_head.object.shop_nm.visible = false				
				dw_head.object.cb_shop_cd.visible = false								
				dw_head.object.fr_ymd.visible = false								
				dw_head.object.fr_ymd_t.visible = false							
				dw_head.object.t_1.visible = false						
				dw_head.object.to_ymd.visible = false								
				dw_head.object.style_t.visible = false																
				dw_head.object.style.visible = false												
				dw_head.object.chno.visible = false												
				dw_head.object.cb_style.visible = false						
				dw_head.object.year_t.visible = false																
				dw_head.object.year.visible = false												
				dw_head.object.season.visible = false												
				
				dw_1.visible = true
				dw_body.visible = false 
			else
				messagebox("알림!", "10개 이상의 스타일 반응 정보를 입력하셔야 가능합니다!") 				
				tab_1.selectedtab = 1
				
			end if	
		
 
	END CHOOSE
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2853
integer height = 1300
long backcolor = 79741120
string text = "스타일별 반응"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2853
integer height = 1300
long backcolor = 79741120
string text = "주간리포트"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_2 from datawindow within w_sh234_e
boolean visible = false
integer x = 891
integer y = 48
integer width = 1376
integer height = 1476
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "제품사진"
string dataobject = "d_sh234_d03"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_retrieve1 from commandbutton within w_sh234_e
integer x = 1714
integer y = 44
integer width = 384
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회"
end type

event clicked;pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
		Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type st_1 from statictext within w_sh234_e
integer x = 398
integer y = 64
integer width = 1280
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※신상품등록을 누른 후 작성하세요!"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_sh234_e
event ue_keydown pbm_dwnkey
integer x = 18
integer y = 484
integer width = 2862
integer height = 1296
integer taborder = 40
string title = "none"
string dataobject = "d_sh234_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
	If MidA(ls_column_name,1,8) <> 'contents'   Then
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false







end event

event rowfocuschanging;//string ls_contents
//
//messagebox("current", string(currentrow,"0000"))
//messagebox("newcurrent", string(newrow,"0000"))
//
//
//if currentrow > 0 then
//	ls_contents = dw_1.getitemstring(currentrow, "contents")
//	if isnull(ls_contents) or trim(lscontents) ="" then
//		dw_1.
end event

