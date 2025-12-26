$PBExportHeader$w_56027_e.srw
$PBExportComments$쿠폰 등록(라운지비)
forward
global type w_56027_e from w_com010_e
end type
type tab_1 from tab within w_56027_e
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_56027_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_imsi1 from datawindow within w_56027_e
end type
end forward

global type w_56027_e from w_com010_e
tab_1 tab_1
dw_imsi1 dw_imsi1
end type
global w_56027_e w_56027_e

type variables
DataWindowChild idw_sale_type_b, idw_sale_type_1, idw_sale_type_2
String is_brand,  is_shop_cd, is_year, is_season, is_item
String is_yymmdd, is_bf_ymd
string is_fr_ymd, is_to_ymd

end variables

forward prototypes
public function boolean wf_set_data3 ()
public function boolean wf_set_data1 ()
public function boolean wf_set_data2 ()
end prototypes

public function boolean wf_set_data3 ();/*----------------------------------------------------------------*/
/* 품번별마진율 자료 처리                                         */
/*----------------------------------------------------------------*/
Long     i, ll_row, ll_cnt
datetime ld_datetime
string ls_style, ls_year, ls_season, ls_shop_type, ls_sale_type, ls_start_ymd, ls_end_ymd

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

ll_row = tab_1.tabpage_2.dw_2.RowCount()
FOR i = 1 TO ll_row
   idw_status = tab_1.tabpage_2.dw_2.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
		ls_style = tab_1.tabpage_2.dw_2.GetItemString(i, 'style')
		ls_year = tab_1.tabpage_2.dw_2.GetItemString(i, 'year')
		ls_season = tab_1.tabpage_2.dw_2.GetItemString(i, 'season')
	
		if ls_year = '' or isnull(ls_year) then
			gf_style_year(ls_style, ls_year)
		end if
	
		if ls_season = '' or isnull(ls_season) then
			gf_style_season(ls_style, ls_season)
		end if
		
		select shop_type, sale_type
		into :ls_shop_type, :ls_sale_type
		from tb_56012_d
		where shop_cd    = :is_shop_cd
				and brand  = :is_brand
				and year   = :ls_year
				and season = :ls_season
				and style  = :ls_style;
				
		if ls_shop_type = '' or isnull(ls_shop_type) then
			ls_shop_type = '1'
		end if
		
		if ls_sale_type = '' or isnull(ls_sale_type) then
			ls_sale_type = '11'
		end if	
	
      tab_1.tabpage_2.dw_2.Setitem(i, "shop_cd",   is_shop_cd)
      tab_1.tabpage_2.dw_2.Setitem(i, "brand",     is_brand)
		tab_1.tabpage_2.dw_2.Setitem(i, "shop_type", ls_shop_type)
		tab_1.tabpage_2.dw_2.Setitem(i, "sale_type", ls_sale_type)
		tab_1.tabpage_2.dw_2.Setitem(i, "year", ls_year)
		tab_1.tabpage_2.dw_2.Setitem(i, "season", ls_season)
      tab_1.tabpage_2.dw_2.Setitem(i, "reg_id",    gs_user_id)
	ELSEIF idw_status = DataModified! THEN		
      tab_1.tabpage_2.dw_2.Setitem(i, "mod_id",    gs_user_id)
      tab_1.tabpage_2.dw_2.Setitem(i, "mod_dt",    ld_datetime)
	END IF
/*	
   IF idw_status = NewModified! THEN
		ls_start_ymd = tab_1.tabpage_2.dw_2.getitemstring(i,'start_ymd')
		ls_end_ymd = tab_1.tabpage_2.dw_2.getitemstring(i,'start_ymd')
	
		select count(shop_cd)
		into  :ll_cnt
		from tb_56016_d
		where shop_cd = :is_shop_cd
				and brand = :is_brand
				and year = :ls_year
				and season = :ls_season
				and style  = :ls_style
				and shop_type = :ls_shop_type
				and ((:ls_start_ymd between start_ymd and end_ymd) or ( :ls_end_ymd between start_ymd and end_ymd));
	end if
	
	if ll_cnt >= 1 then
		messagebox('확인','기간이 중복됩니다. 확인후 처리 바랍니다!')
		return false
	end if
*/	
NEXT

IF tab_1.tabpage_2.dw_2.update(TRUE, FALSE) <> 1 THEN RETURN FALSE

Return True 

end function

public function boolean wf_set_data1 ();/*----------------------------------------------------------------*/
/* 기본마진율 임시자료 편집                                       */
/*----------------------------------------------------------------*/
Long i, k, ll_row
datetime ld_datetime
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF
dw_imsi1.Reset()
// 1.삭제된 자료 'OLD_DATA' 로 생성
ll_row = dw_body.DeletedCount()

IF ll_row > 0 THEN
   dw_body.RowsCopy(1, ll_row, Delete!, dw_imsi1, 1, Primary!)
	/* 변경후 삭제할경우 대비 최초 자료로 Set */
	FOR k = 1 TO ll_row 
      dw_imsi1.Setitem(k, "shop_type", dw_body.GetItemString(k, "shop_type", Delete!, TRUE)) 
      dw_imsi1.Setitem(k, "sale_type", dw_body.GetItemString(k, "sale_type", Delete!, TRUE)) 
      dw_imsi1.Setitem(k, "dc_rate",   dw_body.GetItemDecimal(k, "dc_rate", Delete!, TRUE)) 
      dw_imsi1.Setitem(k, "end_ymd",   'OLD_DATA')
      dw_imsi1.Setitem(k, "mod_id",    gs_user_id)
      dw_imsi1.Setitem(k, "mod_dt",    ld_datetime)
	NEXT 
ELSE
	k = 1
END IF
// 2. 수정전 자료 및 종료일이 '99999999'가 아닌자료는 'OLD_DATA'로 생성
ll_row = dw_body.RowCount()
FOR i = 1 TO ll_row
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! then // OR dw_body.object.end_ymd[i] <> '99999999' THEN		   /* Modify Record */
      dw_body.RowsCopy(i, i, Primary!, dw_imsi1, k, Primary!)
      dw_imsi1.Setitem(k, "shop_type", dw_body.GetitemString(i, "shop_type", Primary!, True))
      dw_imsi1.Setitem(k, "sale_type", dw_body.GetitemString(i, "sale_type", Primary!, True))
      dw_imsi1.Setitem(k, "dc_rate",   dw_body.GetitemDecimal(i, "dc_rate",   Primary!, True))
      dw_imsi1.Setitem(k, "mod_id",    gs_user_id)
      dw_imsi1.Setitem(k, "mod_dt",    ld_datetime)
      dw_imsi1.Setitem(k, "end_ymd",   'OLD_DATA')
	   k++
   END IF
NEXT
// 3. 수정후 자료 및 종료일이 '99999999'가 아닌자료는 'NEW_DATA'로 생성 
FOR i = 1 TO ll_row
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
      dw_body.RowsCopy(i, i, Primary!, dw_imsi1, k, Primary!)
      dw_imsi1.Setitem(k, "shop_cd",   is_shop_cd)
      dw_imsi1.Setitem(k, "brand",     is_brand)
      dw_imsi1.Setitem(k, "start_ymd", is_yymmdd)
      dw_imsi1.Setitem(k, "end_ymd",   'NEW_DATA')
      dw_imsi1.Setitem(k, "mod_id",    gs_user_id)
      dw_imsi1.Setitem(k, "mod_dt",    ld_datetime)
	   k++
	ELSEIF idw_status = DataModified! then // OR dw_body.object.end_ymd[i] <> '99999999' THEN		
      dw_body.RowsCopy(i, i, Primary!, dw_imsi1, k, Primary!) 
      dw_imsi1.Setitem(k, "end_ymd",   'NEW_DATA') 
      dw_imsi1.Setitem(k, "mod_id",    gs_user_id)
      dw_imsi1.Setitem(k, "mod_dt",    ld_datetime)
	   k++
	END IF
NEXT

IF dw_imsi1.update() <> 1 THEN RETURN FALSE

Return True
end function

public function boolean wf_set_data2 ();/*----------------------------------------------------------------*/
/* 시즌별 마진율 자료 처리                                        */
/*----------------------------------------------------------------*/
Long     i, ll_row, ll_cnt, ll_row_count
datetime ld_datetime
string ls_item, ls_start_ymd, ls_end_ymd
string ls_shop_type, ls_sale_type, ls_year, ls_season
string ls_start_ymd_1,ls_end_ymd_1,ls_year_1,ls_season_1, ls_sql_year

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

ll_row = tab_1.tabpage_1.dw_1.RowCount()

FOR i = 1 TO ll_row
   idw_status = tab_1.tabpage_1.dw_1.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
		ls_item = tab_1.tabpage_1.dw_1.getitemstring(i,'item')
		if ls_item = '' or isnull(ls_item) then
			ls_item = '%'
		end if
		
		ls_year = tab_1.tabpage_1.dw_1.GetItemString(i, 'year')
		ls_season = tab_1.tabpage_1.dw_1.GetItemString(i, 'season')
		
		select shop_type, sale_type
		into :ls_shop_type, :ls_sale_type
		from tb_56011_d
		where shop_cd    = :is_shop_cd
				and brand  = :is_brand
				and year   = :ls_year
				and season = :ls_season;
				
		if ls_shop_type = '' or isnull(ls_shop_type) then
			ls_shop_type = '1'
		end if
		
		if ls_sale_type = '' or isnull(ls_sale_type) then
			ls_sale_type = '11'
		end if	
		
      tab_1.tabpage_1.dw_1.Setitem(i, "shop_cd",   is_shop_cd)
      tab_1.tabpage_1.dw_1.Setitem(i, "brand",     is_brand)
      tab_1.tabpage_1.dw_1.Setitem(i, "shop_type", ls_shop_type)
      tab_1.tabpage_1.dw_1.Setitem(i, "sale_type", ls_sale_type)
		tab_1.tabpage_1.dw_1.Setitem(i, "item",      ls_item )
      tab_1.tabpage_1.dw_1.Setitem(i, "reg_id",    gs_user_id)
      tab_1.tabpage_1.dw_1.Setitem(i, "reg_dt",    ld_datetime)
	ELSEIF idw_status = DataModified! THEN		
      tab_1.tabpage_1.dw_1.Setitem(i, "mod_id",    gs_user_id)
      tab_1.tabpage_1.dw_1.Setitem(i, "mod_dt",    ld_datetime)
	END IF


/*		
		//중복체크하기 위해 임시테이블에 넣기
		//마진율 테이블 create 
		ls_sql_year = 'Create table ##tb_56015_d (	shop_cd		varchar(06),  '+ '~r~n' + &
											'                 start_ymd	varchar(08),  '+ '~r~n' + &
											'                 end_ymd		varchar(08),  '+ '~r~n' + &
											'                 year			varchar(04),  '+ '~r~n' + &
											'                 season		varchar(04))'
		EXECUTE IMMEDIATE :ls_sql_year;
		

		ll_row_count = tab_1.tabpage_1.dw_1.RowCount()
		
		// 마진율 input 
		FOR i = 1 TO ll_row_count
			ls_start_ymd_1 = tab_1.tabpage_1.dw_1.getitemstring(i,'start_ymd')
			ls_end_ymd_1 = tab_1.tabpage_1.dw_1.getitemstring(i,'end_ymd')
			ls_year_1 = tab_1.tabpage_1.dw_1.getitemstring(i,'year')
			ls_season_1 = tab_1.tabpage_1.dw_1.getitemstring(i,'season')

			insert into ##tb_56015_d(shop_cd, start_ymd, end_ymd, year, season)
			values(:is_shop_cd, :ls_start_ymd_1, :ls_end_ymd_1, :ls_year_1, :ls_season_1);
		next

		messagebox('is_shop_cd', is_shop_cd)
		messagebox('is_brand', is_brand)
		select count(shop_cd)
		into  :ll_cnt
		from ##tb_56015_d
		where shop_cd = :is_shop_cd
				and brand = :is_brand
				and year = :ls_year
				and season = :ls_season
				and shop_type = :ls_shop_type
				and ((:ls_start_ymd between start_ymd and end_ymd) or ( :ls_end_ymd between start_ymd and end_ymd));

	if ll_cnt >= 1 then
		messagebox('확인','기간이 중복됩니다. 확인후 처리 바랍니다!')
		return false
	end if
*/
NEXT



IF tab_1.tabpage_1.dw_1.update(TRUE, FALSE) <> 1 THEN RETURN FALSE

Return True 


end function

on w_56027_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_imsi1=create dw_imsi1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_imsi1
end on

on w_56027_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_imsi1)
end on

event pfc_preopen();/*===========================================================================*/
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
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
inv_resize.of_Register(dw_body, "ScaleToBottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)

dw_print.SetTransObject(SQLCA)

dw_imsi1.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source


CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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



is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = '%'
//   MessageBox(ls_title,"매장 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("shop_cd")
//   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_season) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")




is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
is_bf_ymd = String(RelativeDate(dw_head.GetItemDate(1, "yymmdd"), -1), "yyyymmdd")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_shop_cd)
tab_1.tabpage_1.dw_1.reset()
tab_1.tabpage_2.dw_2.reset()

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
	il_rows =dw_body.insertRow(0)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.19                                                  */	
/* 수정일      : 2001.12.19                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
boolean  lb_ok
String   ls_ErrMsg

ll_row_count = dw_body.RowCount()
//IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_2.dw_2.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

lb_ok = False
IF WF_SET_DATA2() THEN 
	IF WF_SET_DATA3() THEN 
		lb_ok = True
	END IF
END IF

IF lb_ok THEN
   DECLARE SP_56027_UPDATE PROCEDURE FOR SP_56027_UPDATE  
           @brand   = :is_brand,   
           @shop_cd = :is_shop_cd,   
           @year    = :is_year,   
           @season  = :is_season, 
			  @item    = :is_item,
           @fr_ymd  = :is_fr_ymd,
           @to_ymd  = :is_to_ymd;
			  
   EXECUTE SP_56027_UPDATE;
	IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
		il_rows = 1
//      dw_body.ResetUpdate()
      tab_1.tabpage_1.dw_1.ResetUpdate()
      tab_1.tabpage_2.dw_2.ResetUpdate()
      commit  USING SQLCA;
		dw_imsi1.reset()
	ELSE
		ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
      rollback  USING SQLCA;
		MessageBox("저장 실패[SP]", ls_ErrMsg)
		il_rows = -1
	END IF
ELSE
	ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
   rollback  USING SQLCA;
   MessageBox("저장 실패[DW]", ls_ErrMsg)
	il_rows = -1
END IF


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_button;call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.21                                                  */	
/* 수정일      : 2001.12.21                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
         cb_insert.enabled = true
      end if
   CASE 5    /* 조건 */
      cb_insert.enabled = false
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56027_e","0")
end event

event open;call super::open;string ls_yymmdd
date ld_ymd

ls_yymmdd = string(dw_head.GetItemDate(1,'yymmdd'))

ld_ymd = date(long(MidA(ls_yymmdd,1,4)), long(MidA(ls_yymmdd,6,2)), 01 )

dw_head.setitem(1,'fr_ymd',ld_ymd)

end event

type cb_close from w_com010_e`cb_close within w_56027_e
end type

type cb_delete from w_com010_e`cb_delete within w_56027_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56027_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56027_e
end type

type cb_update from w_com010_e`cb_update within w_56027_e
end type

type cb_print from w_com010_e`cb_print within w_56027_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56027_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56027_e
end type

type cb_excel from w_com010_e`cb_excel within w_56027_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56027_e
integer x = 5
integer y = 168
integer width = 3561
integer height = 212
string dataobject = "d_56027_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String ls_yymmdd
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
/*
	CASE "yymmdd"	
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
*/
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		messagebox('1','shop_cd')
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
		THIS.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve( data )
		ldw_child.InsertRow(1)
		ldw_child.SetItem(1, "item", '%')
		ldw_child.SetItem(1, "item_nm", '전체')
		
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

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')
/*
This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', gs_brand, '%')
*/


//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, is_year)
ldw_child.insertrow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")

THIS.GetChild("item", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(is_brand)
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "item", '%')
ldw_child.SetItem(1, "item_nm", '전체')


end event

type ln_1 from w_com010_e`ln_1 within w_56027_e
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_e`ln_2 within w_56027_e
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_e`dw_body within w_56027_e
integer y = 408
integer width = 1344
integer height = 1588
string dataobject = "d_56027_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_shop_cd
long ll_rows, ll_rows_1

is_shop_cd = dw_body.getitemstring(row,'shop_cd')
ll_rows = tab_1.tabpage_1.dw_1.retrieve(is_shop_cd, is_brand, is_year, is_season, is_item,  is_fr_ymd, is_to_ymd)
ll_rows_1 = tab_1.tabpage_2.dw_2.retrieve(is_shop_cd, is_brand, is_year, is_season, is_fr_ymd, is_to_ymd)

IF ll_rows > 0 THEN
   tab_1.tabpage_1.dw_1.SetFocus()
ELSEIF ll_rows = 0 THEN
	ll_rows = tab_1.tabpage_1.dw_1.insertRow(0)
//	tab_1.tabpage_1.dw_1.insertRow(0)
   tab_1.tabpage_1.dw_1.SetFocus()
END IF
/*
IF ll_rows_1 > 0 THEN
   tab_1.tabpage_1.dw_1.SetFocus()
ELSEIF ll_rows_1 = 0 THEN
	ll_rows_1 = tab_1.tabpage_2.dw_2.insertRow(0)
   tab_1.tabpage_2.dw_2.SetFocus()
END IF
*/
end event

type dw_print from w_com010_e`dw_print within w_56027_e
end type

type tab_1 from tab within w_56027_e
integer x = 1353
integer y = 408
integer width = 2217
integer height = 1596
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
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

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2181
integer height = 1484
long backcolor = 79741120
string text = "시즌별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
event ue_keydown pbm_dwnkey
integer width = 2181
integer height = 1532
integer taborder = 110
string title = "none"
string dataobject = "d_56027_d02"
boolean vscrollbar = true
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
END CHOOSE

end event

event constructor;DataWindowChild ldw_child

This.GetChild("shop_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')
/*
This.GetChild("year", ldw_child )
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('002')
*/
this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, is_year)

This.GetChild("item", ldw_child )
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(is_brand)
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "item", '%')
ldw_child.SetItem(1, "item_nm", '전체')

/*
This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', gs_brand, '%')
*/
end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
String ls_null
DataWindowChild ldw_child

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name

	CASE "start_ymd", "end_ymd"
		IF GF_DateChk(Data) = False THEN 
			RETURN 1
		END IF 

	CASE "year"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",ldw_child)
			ldw_child.settransobject(sqlca)
			ldw_child.retrieve('003', is_brand, is_year)
	
			This.GetChild("item", ldw_child)
			ldw_child.SetTransObject(SQLCA)
			ldw_child.Retrieve(is_brand)

END CHOOSE

end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm, ls_tag, ls_helpMsg 
String ls_shop_type, ls_filter

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm		
	CASE "sale_type" 
		ls_shop_type = This.GetitemString(row, "shop_type")
		IF ls_shop_type = '1' THEN 
			ls_filter = "inter_cd1 = '1' or inter_cd1 = '2' "
		ELSEIF ls_shop_type = '3' THEN
			ls_filter = "inter_cd1 = '3'"
		ELSE
			ls_filter = "inter_cd1 = '4'"
		END IF
		idw_sale_type_1.SetFilter(ls_filter)
		idw_sale_type_1.Filter()
END CHOOSE

end event

event buttonclicking;PowerObject l_tabpage, l_tab
Window lw_win

IF row < 1 THEN RETURN 

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()

IF dwo.name = "b_delete" THEN 
	idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = 1
   lw_win.Dynamic Trigger Event ue_button(4, il_rows)
   lw_win.Dynamic Trigger Event ue_msg(4, il_rows)
END IF


string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF dwo.name = "b_excel" THEN 
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
	li_ret = tab_1.tabpage_1.dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
	if li_ret <> 1 then
		SetPointer(Old_pointer)
		MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
		return
	end if
	SetPointer(Old_pointer)
	Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)
END IF
end event

event itemerror;Return 1

end event

event buttonclicked;CHOOSE CASE dwo.name
	CASE "cb_date" 
		dw_1.SetSort("start_ymd")
		dw_1.Sort()	

	CASE "cb_shop_type" 
		dw_1.SetSort("shop_type")
		dw_1.Sort()		
	CASE "cb_sale_type" 
		dw_1.SetSort("sale_type")		
		dw_1.Sort()


END CHOOSE
end event

type tabpage_2 from userobject within tab_1
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer x = 18
integer y = 96
integer width = 2181
integer height = 1484
long backcolor = 79741120
string text = "품번별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
string     ls_shop_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%')  THEN
					RETURN 0
				END IF
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
//			                         "  AND year   = '" + is_year   + "'" + &
//											 "  AND season = '" + is_season + "'" 			
			gst_cd.default_where   = "WHERE brand  = '" + is_brand  + "'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style LIKE  '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				tab_1.tabpage_2.dw_2.SetRow(al_row)
				tab_1.tabpage_2.dw_2.SetColumn(as_column)
				tab_1.tabpage_2.dw_2.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				/* 다음컬럼으로 이동 */
//				tab_1.tabpage_2.dw_2.setcolumn("sale_price")
				tab_1.tabpage_2.dw_2.setcolumn("color")
				ib_itemchanged = False
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 	
   RETURN 2
END IF

RETURN 0

end event

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
event ue_keydown pbm_dwnkey
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer y = 4
integer width = 2181
integer height = 1480
integer taborder = 110
string title = "none"
string dataobject = "d_56027_d03"
boolean vscrollbar = true
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
		This.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_shop_type
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') THEN
					RETURN 0
				END IF 
			END IF
			ls_shop_type = This.GetitemString(al_row, "shop_type")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색11" 
			gst_cd.datawindow_nm   = "d_com011" 
			gst_cd.default_where   = "where brand  = '" + is_brand  + "'" + & 
			                         "  and year   = '" + is_year   + "'" + & 
											 "  and season = '" + is_season + "'" 
			IF ls_shop_type = '1' THEN 
				gst_cd.default_where = gst_cd.default_where + "  and Plan_Yn = 'N'" 
			ELSEIF ls_shop_type = '3' THEN 
				gst_cd.default_where = gst_cd.default_where + "  and Plan_Yn = 'Y'" 
			END IF
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style LIKE  '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				This.SetRow(al_row)
				This.SetColumn(as_column)
				This.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				/* 다음컬럼으로 이동 */
				This.SetColumn("sale_price")
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

event constructor;
DataWindowChild ldw_child

This.GetChild("shop_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String ls_null

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "start_ymd", "end_ymd"
		IF GF_DateChk(Data) = False THEN 
			RETURN 1
		END IF 
	CASE "style" 	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

/*
	CASE "shop_type" 
		This.Setitem(row, "sale_type", ls_null)
		This.Setitem(row, "style",     ls_null)
*/

END CHOOSE

end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

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

CHOOSE CASE dwo.name
	CASE "cb_date" 
		dw_2.SetSort("start_ymd")
		dw_2.Sort()	
	CASE "cb_style_no" 
		dw_2.SetSort("style_no")				
		dw_2.Sort()
	CASE "cb_shop_type" 
		dw_2.SetSort("shop_type")
		dw_2.Sort()		
	CASE "cb_sale_type" 
		dw_2.SetSort("sale_type")		
		dw_2.Sort()

END CHOOSE

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg 
String ls_shop_type,  ls_filter

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm

	CASE "sale_type" 		
		ls_shop_type = This.GetitemString(row, "shop_type")
		IF ls_shop_type = '1' THEN 
			ls_filter = "inter_cd1 = '1' or inter_cd1 = '2' "
		ELSEIF ls_shop_type = '3' THEN
			ls_filter = "inter_cd1 = '3'"
		ELSE
			ls_filter = "inter_cd1 = '4'"
		END IF
		idw_sale_type_2.SetFilter(ls_filter)
		idw_sale_type_2.Filter()

END CHOOSE

end event

event buttonclicking;PowerObject l_tabpage, l_tab
Window lw_win

IF row < 1 THEN RETURN 

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()

IF dwo.name = "b_delete" THEN 
	idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = 1
   lw_win.DyNAMIC Trigger Event ue_button(4, il_rows)
   lw_win.DyNAMIC Trigger Event ue_msg(4, il_rows)
END IF

string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF dwo.name = "b_excel" THEN 
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
	li_ret = tab_1.tabpage_2.dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
	if li_ret <> 1 then
		SetPointer(Old_pointer)
		MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
		return
	end if
	SetPointer(Old_pointer)
	Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)
END IF
end event

event itemerror;Return 1

end event

type dw_imsi1 from datawindow within w_56027_e
boolean visible = false
integer x = 1394
integer y = 464
integer width = 2007
integer height = 1436
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_56027_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

