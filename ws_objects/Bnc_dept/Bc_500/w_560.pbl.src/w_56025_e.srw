$PBExportHeader$w_56025_e.srw
$PBExportComments$마진율 품번별 일괄등록
forward
global type w_56025_e from w_com010_e
end type
type cb_copy from commandbutton within w_56025_e
end type
type dw_1 from datawindow within w_56025_e
end type
type dw_2 from datawindow within w_56025_e
end type
type cb_1 from commandbutton within w_56025_e
end type
type cb_chk from commandbutton within w_56025_e
end type
type dw_3 from datawindow within w_56025_e
end type
type cb_diff_chk from commandbutton within w_56025_e
end type
end forward

global type w_56025_e from w_com010_e
integer width = 3689
integer height = 2260
cb_copy cb_copy
dw_1 dw_1
dw_2 dw_2
cb_1 cb_1
cb_chk cb_chk
dw_3 dw_3
cb_diff_chk cb_diff_chk
end type
global w_56025_e w_56025_e

type variables
DataWindowChild idw_sale_type_1, idw_sale_type_2, idw_dep_seq, idw_disc_seq
String is_brand, is_shop_div, is_shop_grp 
String is_year,  is_season,   is_fr_ymd,   is_to_ymd 
String is_job_yn = 'Y' , is_dep_opt,  is_color_opt
DataStore ids_copy

end variables

forward prototypes
public function boolean wf_set_data2 (string as_shop_cd)
public function boolean wf_set_data1 (string as_shop_cd)
end prototypes

public function boolean wf_set_data2 (string as_shop_cd);///*----------------------------------------------------------------*/
///* 품번별마진율 자료편집                                          */
///*----------------------------------------------------------------*/
//Long i, ll_row
//datetime ld_datetime
///* 시스템 날짜를 가져온다 */
//IF gf_sysdate(ld_datetime) = FALSE THEN
//	Return False
//END IF
//
//// 수정후 자료는 'NEW_DATA'로 생성
//ll_row = tab_1.tabpage_1.dw_2.RowCount()
//FOR i = 1 TO ll_row
//   idw_status = tab_1.tabpage_1.dw_2.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN
//      tab_1.tabpage_1.dw_2.Setitem(i, "shop_cd",   as_shop_cd)
//      tab_1.tabpage_1.dw_2.Setitem(i, "brand",     is_brand)
//      tab_1.tabpage_1.dw_2.Setitem(i, "year",      is_year)
//      tab_1.tabpage_1.dw_2.Setitem(i, "season",    is_season)
//      tab_1.tabpage_1.dw_2.Setitem(i, "start_ymd", is_fr_ymd)
//      tab_1.tabpage_1.dw_2.Setitem(i, "end_ymd",   'NEW_DATA')
//      tab_1.tabpage_1.dw_2.Setitem(i, "mod_id",    gs_user_id)
//      tab_1.tabpage_1.dw_2.Setitem(i, "mod_dt",    ld_datetime)
//	ELSEIF idw_status = DataModified! THEN		
//      tab_1.tabpage_1.dw_2.Setitem(i, "shop_cd",   as_shop_cd)
//      tab_1.tabpage_1.dw_2.Setitem(i, "end_ymd",   'NEW_DATA') 
//      tab_1.tabpage_1.dw_2.Setitem(i, "mod_id",    gs_user_id)
//      tab_1.tabpage_1.dw_2.Setitem(i, "mod_dt",    ld_datetime)
//	END IF
//NEXT
//
//IF tab_1.tabpage_1.dw_2.update(TRUE, FALSE) <> 1 THEN RETURN FALSE
//
Return True 

end function

public function boolean wf_set_data1 (string as_shop_cd);/*----------------------------------------------------------------*/
/* 시즌별마진율 자료 편집                                         */
/*----------------------------------------------------------------*/
/*
Long i, ll_row
datetime ld_datetime
// 시스템 날짜를 가져온다 
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

// 임시자료 생성
ll_row = dw_1.RowCount()
FOR i = 1 TO ll_row
   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
      dw_1.Setitem(i, "shop_cd",   as_shop_cd)
      dw_1.Setitem(i, "brand",     is_brand)
      dw_1.Setitem(i, "year",      is_year)
      dw_1.Setitem(i, "season",    is_season)
      dw_1.Setitem(i, "start_ymd", is_fr_ymd)
      dw_1.Setitem(i, "end_ymd",   'NEW_DATA')
      dw_1.Setitem(i, "mod_id",    gs_user_id)   // sp에서 reg로 처리 
      dw_1.Setitem(i, "mod_dt",    ld_datetime)
	ELSEIF idw_status = DataModified! THEN		
      dw_1.Setitem(i, "shop_cd",   as_shop_cd)
      dw_1.Setitem(i, "end_ymd",   'NEW_DATA') 
      dw_1.Setitem(i, "mod_id",    gs_user_id)
      dw_1.Setitem(i, "mod_dt",    ld_datetime)
	END IF
NEXT

IF dw_1.update(TRUE, FALSE) <> 1 THEN RETURN FALSE
*/
Return True 

end function

on w_56025_e.create
int iCurrent
call super::create
this.cb_copy=create cb_copy
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_1=create cb_1
this.cb_chk=create cb_chk
this.dw_3=create dw_3
this.cb_diff_chk=create cb_diff_chk
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_chk
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.cb_diff_chk
end on

on w_56025_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copy)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.cb_chk)
destroy(this.dw_3)
destroy(this.cb_diff_chk)
end on

event pfc_preopen();call super::pfc_preopen;/* DataWindow의 Transction 정의 */
dw_head.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

//dw_print.SetTransObject(SQLCA)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_1.InsertRow(0)


/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_3, "ScaleToBottom")
inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(cb_chk, "FixedToRight")
inv_resize.of_Register(cb_diff_chk, "FixedToRight")

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)





end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_ymd" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_ymd" ,string(ld_datetime,"yyyymmdd"))

dw_head.setitem(1, 'brand', gs_brand)
dw_head.Setitem(1, "shop_div", "G")
dw_head.Setitem(1, "shop_grp", "%")

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.04.01                                                  */
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


is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_shop_grp = dw_head.GetItemString(1, "shop_grp")
if IsNull(is_shop_grp) or Trim(is_shop_grp) = "" then
   MessageBox(ls_title,"백화점유형 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_grp")
   return false
end if

is_dep_opt = dw_head.GetItemString(1, "dep_opt")
if IsNull(is_dep_opt) or Trim(is_dep_opt) = "" then
   MessageBox(ls_title,"작업구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_opt")
   return false
end if

is_color_opt = dw_head.GetItemString(1, "color_opt")
if IsNull(is_color_opt) or Trim(is_color_opt) = "" then
   MessageBox(ls_title,"칼라작업구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color_opt")
   return false
end if


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if



Return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.02.09                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_color_opt = "N" then
	dw_2.DataObject = "d_56025_d03"	
	dw_2.SetTransObject(SQLCA)
else
	dw_2.DataObject = "d_56025_d04"		
	dw_2.SetTransObject(SQLCA)	
end if

il_rows = dw_body.retrieve(is_brand, is_shop_div, is_shop_grp)
IF il_rows > 0 THEN
//	dw_1.Reset()
	dw_2.Reset()

   idw_dep_seq.Retrieve(is_brand, is_year, is_season)
   idw_disc_seq.Retrieve(is_brand, is_year, is_season)	

	if is_dep_opt = "C" then 
//		dw_3.object.disc_seq.visible = false
//		dw_3.object.dep_seq.visible = true		
//		cb_1.text = "부진상품 일괄등록"
   else	
//		dw_3.object.disc_seq.visible = true
//		dw_3.object.dep_seq.visible = false
//		cb_1.text = "품목할인 일괄등록"
	end if		
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_shop_type
Boolean    lb_check 
DataStore  lds_Source
/*
CHOOSE CASE as_column
	CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') THEN
					RETURN 0
				END IF 
			END IF
			ls_shop_type = dw_2.GetitemString(al_row, "shop_type")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
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
				dw_2.SetRow(al_row)
				dw_2.SetColumn(as_column)
				dw_2.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				/* 다음컬럼으로 이동 */
				dw_2.SetColumn("sale_type")
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
*/
RETURN 0

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
//         dw_1.Enabled = true
//         dw_2.Enabled = true
//         dw_3.Enabled = true
         cb_update.Enabled = false
			
      end if
   CASE 5    /* 조건 */
//      dw_1.Enabled = false
//      dw_2.Enabled = false
//      dw_3.Enabled = false
//      cb_1.Enabled = false
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.19                                                  */	
/* 수정일      : 2001.12.19                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
boolean  lb_ok
String   ls_shop_cd, ls_ErrMsg, ls_sql_shop, ls_sql_1, ls_sql_marjin, ls_sql_2, ls_sql_execute, ls_color
string   ls_style, ls_start_ymd, ls_end_ymd, ls_shop_type, ls_sale_type, ls_excp_yn, ls_brand, ls_season, ls_year, ls_year_part
long     ll_sale_price, ll_dc_rate, LL_CHK

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 매장코드 저장 테이블 create */
ls_sql_shop = "create table ##a_shop_cd (shop_cd varchar(6))"
EXECUTE IMMEDIATE :ls_sql_shop;

/* 선택된 매장코드 input */
FOR i = 1 TO ll_row_count 
	 IF dw_body.Object.job_yn[i] = 'N' THEN CONTINUE 
	 ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
    insert into ##a_shop_cd values(:ls_shop_cd);
next

 
if is_color_opt = "N" then
			/* 마진율 테이블 create */
			ls_sql_marjin = 'Create table ##a_marjin_shop (	style			varchar(08),  '+ '~r~n' + &
												'                    shop_type	varchar(01),  '+ '~r~n' + &
												'                    end_ymd		varchar(08),  '+ '~r~n' + &
												'                    start_ymd   varchar(08),  '+ '~r~n' + &
												'                    sale_type   varchar(02),  '+ '~r~n' + &
												'                    sale_price	decimal(8),  '+ '~r~n' + &
												'                    dc_rate		decimal(5),  '+ '~r~n' + &
												'                    excp_yn		varchar(01), '+ '~r~n' + &
												'                    brand			varchar(01), '+ '~r~n' + &
												'                    year			varchar(04), '+ '~r~n' + &
												'                    season		varchar(01))'
			EXECUTE IMMEDIATE :ls_sql_marjin;
			
			ll_row_count = 0
			ll_row_count = dw_2.RowCount()
			
			/* 마진율 input */
			FOR i = 1 TO ll_row_count
				ls_style      = dw_2.getitemstring(i,'style')
				ls_shop_type  = dw_2.getitemstring(i,'shop_type')
				ls_end_ymd    = dw_2.getitemstring(i,'end_ymd')
				ls_start_ymd  = dw_2.getitemstring(i,'start_ymd')
				ls_sale_type  = dw_2.getitemstring(i,'sale_type')
				ll_sale_price = dw_2.getitemnumber(i,'sale_price')
				ll_dc_rate    = dw_2.getitemnumber(i,'dc_rate')
				ls_excp_yn    = 'N'
				ls_brand      = MidA(ls_style,1,1)
			//	ls_year       = '201' + mid(ls_style,3,1)
				
   			ls_year_part =  MidA(ls_style,3,1)
				
				select dbo.sf_inter_cd1('002',:ls_year_part)
				into :ls_year
				from dual;
				
				ls_season     = MidA(ls_style,4,1)
			
				insert into ##a_marjin_shop(style, shop_type, end_ymd, start_ymd, sale_type, sale_price, dc_rate, excp_yn, brand, year, season)
				values(:ls_style, :ls_shop_type, :ls_end_ymd, :ls_start_ymd, :ls_sale_type, :ll_sale_price, :ll_dc_rate, :ls_excp_yn, :ls_brand, :ls_year, :ls_season);
			next
			

			
			ls_sql_execute = 'sp_56025_update'
			EXECUTE IMMEDIATE :ls_sql_execute;
else			
	/* 마진율 테이블 create */
			ls_sql_marjin = 'Create table ##a_marjin_shop (	style			varchar(08),  '+ '~r~n' + &
												'							color			varchar(02),  '+ '~r~n' + &
												'                    shop_type	varchar(01),  '+ '~r~n' + &
												'                    end_ymd		varchar(08),  '+ '~r~n' + &
												'                    start_ymd   varchar(08),  '+ '~r~n' + &
												'                    sale_type   varchar(02),  '+ '~r~n' + &
												'                    sale_price	decimal(8),  '+ '~r~n' + &
												'                    dc_rate		decimal(5),  '+ '~r~n' + &
												'                    excp_yn		varchar(01), '+ '~r~n' + &
												'                    brand			varchar(01), '+ '~r~n' + &
												'                    year			varchar(04), '+ '~r~n' + &
												'                    season		varchar(01))'
			EXECUTE IMMEDIATE :ls_sql_marjin;
			
			ll_row_count = 0
			ll_row_count = dw_2.RowCount()
			
			/* 마진율 input */
			FOR i = 1 TO ll_row_count
				ls_style      = dw_2.getitemstring(i,'style')
				ls_color      = dw_2.getitemstring(i,'color')				
				ls_shop_type  = dw_2.getitemstring(i,'shop_type')
				ls_end_ymd    = dw_2.getitemstring(i,'end_ymd')
				ls_start_ymd  = dw_2.getitemstring(i,'start_ymd')
				ls_sale_type  = dw_2.getitemstring(i,'sale_type')
				ll_sale_price = dw_2.getitemnumber(i,'sale_price')
				ll_dc_rate    = dw_2.getitemnumber(i,'dc_rate')
				ls_excp_yn    = 'N'
				ls_brand      = MidA(ls_style,1,1)
				//ls_year       = '201' + mid(ls_style,3,1)
				
   			ls_year_part =  MidA(ls_style,3,1)
				
				select dbo.sf_inter_cd1('002',:ls_year_part)
				into :ls_year
				from dual;
								
			//	MESSAGEBOX("ls_year", ls_year)
				ls_season     = MidA(ls_style,4,1)
			
				insert into ##a_marjin_shop(style, color, shop_type, end_ymd, start_ymd, sale_type, sale_price, dc_rate, excp_yn, brand, year, season)
				values(:ls_style, :ls_color, :ls_shop_type, :ls_end_ymd, :ls_start_ymd, :ls_sale_type, :ll_sale_price, :ll_dc_rate, :ls_excp_yn, :ls_brand, :ls_year, :ls_season);
			next
			
			

			
			ls_sql_execute = 'sp_56025_update2'
			EXECUTE IMMEDIATE :ls_sql_execute;
end if			

/* DataBase commit or rollback */
IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
	il_rows = 1	
	commit  USING SQLCA;
	MessageBox("저장 성공", "저장을 완료하였습니다.")
ELSE
	ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
	Rollback  USING SQLCA;
	MessageBox("저장 실패 [" + ls_shop_cd + "]", ls_ErrMsg)
	il_rows = -1 
END IF

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56025_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56025_e
end type

type cb_delete from w_com010_e`cb_delete within w_56025_e
boolean visible = false
boolean enabled = true
string text = "붙여넣기"
end type

event cb_delete::clicked;//Long   ll_rows, ll_find, i, j, ll_deal_qty , ll_row 
//String ls_shop_type, ls_style, ls_sale_type, ls_excp_yn
//decimal ldc_sale_price, ldc_dc_rate
//
////ll_rows = ids_copy.RowCount()
//ll_rows = dw_4.RowCount()
//
//FOR i = 1 TO ll_rows 
//	ls_shop_type   = dw_4.GetitemString(i, "shop_type")
//	ls_style       = dw_4.GetitemString(i, "style")
//	ls_sale_type   = dw_4.GetitemString(i, "sale_type")
//	ls_excp_yn     = dw_4.GetitemString(i, "excp_yn")
//	ldc_sale_price = dw_4.GetitemNumber(i, "sale_price")
//	ldc_dc_rate    = dw_4.GetitemNumber(i, "dc_rate")
//	
//	ll_find = dw_2.Find("shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'", 1, dw_2.RowCount())
//	IF ll_find < 1 THEN
//	   ll_row     =  dw_2.insertRow(0)
//      dw_2.Setitem(ll_row, "shop_type",   ls_shop_type)
//      dw_2.Setitem(ll_row, "style",       ls_style)
//      dw_2.Setitem(ll_row, "sale_type",   ls_sale_type)
//      dw_2.Setitem(ll_row, "excp_yn",     ls_excp_yn)		
//      dw_2.Setitem(ll_row, "sale_price",  ldc_sale_price)
//      dw_2.Setitem(ll_row, "dc_rate",     ldc_dc_rate)		
//	END IF 
//NEXT 
//
//ib_changed = true
//cb_update.enabled = true
//
end event

type cb_insert from w_com010_e`cb_insert within w_56025_e
boolean visible = false
string text = "복사"
end type

event cb_insert::clicked;//ids_copy.Reset()
//dw_4.reset()
//dw_2.RowsCopy(1, dw_2.RowCount(), Primary!, dw_4, 1, Primary!)

end event

type cb_retrieve from w_com010_e`cb_retrieve within w_56025_e
end type

type cb_update from w_com010_e`cb_update within w_56025_e
end type

type cb_print from w_com010_e`cb_print within w_56025_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56025_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56025_e
end type

type cb_excel from w_com010_e`cb_excel within w_56025_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56025_e
integer x = 18
integer y = 160
integer width = 3584
integer height = 144
string dataobject = "d_56025_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("001")

//This.GetChild("season", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve("003") 

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("910") 
//ldw_child.SetFilter("inter_cd > 'A' and inter_cd < 'Z'")
ldw_child.Filter()

This.GetChild("shop_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('912')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", '%')
ldw_child.Setitem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_yymmdd 

CHOOSE CASE dwo.name
	CASE "yymmdd"	
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56025_e
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_e`ln_2 within w_56025_e
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_e`dw_body within w_56025_e
integer x = 0
integer y = 320
integer width = 1111
integer height = 1700
boolean enabled = false
string dataobject = "d_56025_d01"
end type

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

event dw_body::buttonclicked;call super::buttonclicked;Long i, ll_row 

ll_row = dw_body.RowCount()
IF ll_row < 1 THEN RETURN

IF dwo.name = "b_job_yn" THEN
	IF is_job_yn = 'Y' THEN 
		is_job_yn = 'N' 
	ELSE
		is_job_yn = 'Y' 
	END IF
	FOR i = 1 TO ll_row 
		dw_body.Object.job_yn[i] = is_job_yn
	NEXT 
END IF
end event

type dw_print from w_com010_e`dw_print within w_56025_e
end type

type cb_copy from commandbutton within w_56025_e
boolean visible = false
integer x = 1083
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "붙여넣기"
end type

event clicked;//Long   ll_rows, ll_find, i, j, ll_deal_qty , ll_row 
//String ls_shop_type, ls_style, ls_sale_type, ls_excp_yn
//decimal ldc_sale_price, ldc_dc_rate
//
////ll_rows = ids_copy.RowCount()
//ll_rows = dw_4.RowCount()
//
//FOR i = 1 TO ll_rows 
//	ls_shop_type   = dw_4.GetitemString(i, "shop_type")
//	ls_style       = dw_4.GetitemString(i, "style")
//	ls_sale_type   = dw_4.GetitemString(i, "sale_type")
//	ls_excp_yn     = dw_4.GetitemString(i, "excp_yn")
//	ldc_sale_price = dw_4.GetitemNumber(i, "sale_price")
//	ldc_dc_rate    = dw_4.GetitemNumber(i, "dc_rate")
//	
//	ll_find = dw_2.Find("shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'", 1, dw_2.RowCount())
//	IF ll_find < 1 THEN
//	   ll_row     =  dw_2.insertRow(0)
//      dw_2.Setitem(ll_row, "shop_type",   ls_shop_type)
//      dw_2.Setitem(ll_row, "style",       ls_style)
//      dw_2.Setitem(ll_row, "sale_type",   ls_sale_type)
//      dw_2.Setitem(ll_row, "excp_yn",     ls_excp_yn)		
//      dw_2.Setitem(ll_row, "sale_price",  ldc_sale_price)
//      dw_2.Setitem(ll_row, "dc_rate",     ldc_dc_rate)		
//	END IF 
//NEXT 
//
//ib_changed = true
//cb_update.enabled = true
//
end event

type dw_1 from datawindow within w_56025_e
integer x = 1115
integer y = 320
integer width = 2501
integer height = 136
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_56025_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_56025_e
integer x = 1115
integer y = 460
integer width = 2496
integer height = 1560
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_56025_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_56025_e
integer x = 3031
integer y = 344
integer width = 498
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "execl 불러오기"
end type

event clicked;Long   ll_rtn, ll_xls_ret
String ls_filename, ls_name, ls_path, ls_msg, ls_file_name1, ls_shop_type,ls_dc_chk_style , ls_style,ls_dc_chk
Long	 i, ll_rowcnt,ll_row_count1

Oleobject xlapp

SetPointer(HourGlass!)
//dw_c01.AcceptText()
dw_1.AcceptText()

ll_rtn = GetFileOpenName("엑셀파일",   &
			+ ls_filename, ls_name, "XLS", &
			+ " XLS Files (*.XLS),*.XLS")
If ll_rtn   =   1 Then
	dw_1.Object.path[1]   = ls_filename
	dw_1.Object.path_name[1]   = ls_name
End If

ls_filename = dw_1.Object.path[1]
ls_name     = dw_1.Object.path_name[1]		
ls_path     = MidA(ls_filename, 1 , LenA(ls_filename) - LenA(ls_name))

If IsNull(ls_filename) Or Trim(ls_filename) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_1.SetFocus()
	dw_1.SetColumn("path")
	Return
End If

If IsNull(ls_name) Or Trim(ls_name) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_1.SetFocus()
	dw_1.SetColumn("path_text")
	Return
End If

//엑셀용 OleObject를 열어 준다.
xlApp       = Create OLEObject    //엑셀용 OLE Object를 선언 한다.
ll_xls_ret = xlApp.ConnectToNewObject("excel.application") //엑셀과 연결하여 준다.
If ll_xls_ret < 0 Then
	ls_msg = '엑셀 프로그램을 사용하는데 실패 하였습니다! 포멧에 정확히 맞추어 다시 작업하세요!'
	Messagebox('확인',ls_msg)
	Return 
End If

xlApp.Application.Workbooks.Open(ls_filename) //화일을 엑셀에 맞추어서 열어 준다.

ls_file_name1 = ls_path + string(today(),'yyyymmdd') + string(now(),'hhmmss') + '_tmp.txt'

xlApp.Application.Activeworkbook.Saveas(ls_file_name1, -4158) //엑셀화일을 텍스트화일로 변환저장
xlApp.Application.Workbooks.close()
xlApp.DisConnectObject() //엑셀 오브젝트를 파괴한다.

dw_2.Reset()
//데이타 윈도우에 임포트 한다.
dw_2.importfile(ls_file_name1)
		
//필수자료 없는 데이타삭제
ll_rowcnt = dw_2.rowcount()
For i = ll_rowcnt To 1 STEP -1
	If i < 1 Then Exit
	ls_shop_type = dw_2.object.shop_type[i]
	If ls_shop_type = "" Or IsNull(ls_shop_type) Then
		dw_2.DeleteRow(i)
	End If	
Next

FileDelete(ls_file_name1)

messagebox('완료', 'Excel 불러오기가 완료되었습니다! ')


		
ls_dc_chk_style = ""
ll_row_count1 = dw_2.RowCount()

FOR i=1 TO ll_row_count1

	ls_style = 	dw_2.GetItemString(i, "style")
	
	select dbo.SF_dc_except_chk(:ls_style)
	into :ls_dc_chk
	from dual;
	
	if ls_dc_chk = "Y" then
		ls_dc_chk_style = ls_dc_chk_style + "|" + ls_style 
	end if	

   
NEXT

if ls_dc_chk_style <> "" then
	messagebox("알림!",ls_dc_chk_style + " 할인대상 품번이 포함되어 있습니다! 확인바랍니다!"		)
end if		
		
		
/*중복체크하기 위해 임시테이블에 넣기*/


		
		
end event

type cb_chk from commandbutton within w_56025_e
integer x = 2478
integer y = 44
integer width = 398
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "품번별중복체크"
end type

event clicked;long ll_row_count, i, ll_cnt
string ls_sql_marjin, ls_sql_drop, ls_style, ls_shop_type, ls_end_ymd, ls_sale_type, ls_style_rt, ls_color



/*중복체크하기 위해 임시테이블에 넣기*/
/* 마진율 테이블 create */

if is_color_opt = "N" then
	
		ls_sql_marjin = 'Create table ##b_marjin_shop (	style			varchar(08),  '+ '~r~n' + &
											'                    shop_type	varchar(01),  '+ '~r~n' + &
											'                    end_ymd		varchar(08),  '+ '~r~n' + &
											'                    sale_type   varchar(02))'
		EXECUTE IMMEDIATE :ls_sql_marjin;
		
		ll_row_count = 0
		ll_row_count = dw_2.RowCount()
		
		/* 마진율 input */
		FOR i = 1 TO ll_row_count
			ls_style      = dw_2.getitemstring(i,'style')
			ls_shop_type  = dw_2.getitemstring(i,'shop_type')
			ls_end_ymd    = dw_2.getitemstring(i,'end_ymd')
			ls_sale_type  = dw_2.getitemstring(i,'sale_type')
		
			insert into ##b_marjin_shop(style, shop_type, end_ymd, sale_type)
			values(:ls_style, :ls_shop_type, :ls_end_ymd, :ls_sale_type);
		next
		
		/* DataBase commit or rollback */
		IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
			il_rows = 1	
			commit  USING SQLCA;
		ELSE
			Rollback  USING SQLCA;
			il_rows = -1 
		END IF
		
		select style+shop_type+end_ymd+sale_type, count(style+shop_type+end_ymd+sale_type) cnt
		into :ls_style_rt, :ll_cnt
		from ##b_marjin_shop with (nolock)
		group by style+shop_type+end_ymd+sale_type
		having count(style+shop_type+end_ymd+sale_type) > 1;
		
		ls_sql_drop = 'drop table ##b_marjin_shop'
		EXECUTE IMMEDIATE :ls_sql_drop;
else		
	
   	ls_sql_marjin = 'Create table ##b_marjin_shop (	style			varchar(08),  '+ '~r~n' + &
											'							color			varchar(02),  '+ '~r~n' + &
											'                    shop_type	varchar(01),  '+ '~r~n' + &
											'                    end_ymd		varchar(08),  '+ '~r~n' + &
											'                    sale_type   varchar(02))'
		EXECUTE IMMEDIATE :ls_sql_marjin;
		
		ll_row_count = 0
		ll_row_count = dw_2.RowCount()
		
		/* 마진율 input */
		FOR i = 1 TO ll_row_count
			ls_style      = dw_2.getitemstring(i,'style')
			ls_color      = dw_2.getitemstring(i,'color')			
			ls_shop_type  = dw_2.getitemstring(i,'shop_type')
			ls_end_ymd    = dw_2.getitemstring(i,'end_ymd')
			ls_sale_type  = dw_2.getitemstring(i,'sale_type')
		
			insert into ##b_marjin_shop(style, color, shop_type, end_ymd, sale_type)
			values(:ls_style, :ls_shop_type, :ls_color, :ls_end_ymd, :ls_sale_type);
		next
		
		/* DataBase commit or rollback */
		IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
			il_rows = 1	
			commit  USING SQLCA;
		ELSE
			Rollback  USING SQLCA;
			il_rows = -1 
		END IF
		
		select style+ color + shop_type+end_ymd+sale_type, count(style+color + shop_type+end_ymd+sale_type) cnt
		into :ls_style_rt, :ll_cnt
		from ##b_marjin_shop with (nolock)
		group by style+ color + shop_type+end_ymd+sale_type
		having count(style+color + shop_type+end_ymd+sale_type) > 1;
		
		ls_sql_drop = 'drop table ##b_marjin_shop'
		EXECUTE IMMEDIATE :ls_sql_drop;
	
end if	
					
		
		
		if ll_cnt >= 2 then
			ls_style_rt = MidA(ls_style_rt,1,8)
			messagebox('중복', '중복된 품번 ' + ls_style_rt + '를 삭제후 다시 작업해 주세요!' )	
			return
		else
			messagebox('성공', '중복이 없습니다.')	
		end if
		




end event

type dw_3 from datawindow within w_56025_e
boolean visible = false
integer x = 229
integer y = 584
integer width = 3323
integer height = 1244
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "품번별 기간 중복알림"
string dataobject = "D_56025_D05"
boolean controlmenu = true
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_diff_chk from commandbutton within w_56025_e
integer x = 1929
integer y = 44
integer width = 549
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "품번별기간중복체크"
end type

event clicked;long i, ll_row_count
datetime ld_datetime 
boolean  lb_ok
String   ls_shop_cd, ls_ErrMsg, ls_sql_shop, ls_sql_1, ls_sql_marjin, ls_sql_2, ls_sql_execute, ls_color,ls_sql_drop
string   ls_style, ls_start_ymd, ls_end_ymd, ls_shop_type, ls_sale_type, ls_excp_yn, ls_brand, ls_season, ls_year, ls_year_part
long     ll_sale_price, ll_dc_rate, LL_CHK

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 매장코드 저장 테이블 create */
ls_sql_shop = "create table ##a_shop_cd (shop_cd varchar(6))"
EXECUTE IMMEDIATE :ls_sql_shop;

/* 선택된 매장코드 input */
FOR i = 1 TO ll_row_count 
	 IF dw_body.Object.job_yn[i] = 'N' THEN CONTINUE 
	 ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
    insert into ##a_shop_cd values(:ls_shop_cd);
next

if is_color_opt = "N" then 
	dw_3.dataobject = "D_56025_D05"
else 	
	dw_3.dataobject = "D_56025_D05c"	
end if	
dw_3.SetTransObject(SQLCA)




/*중복체크하기 위해 임시테이블에 넣기*/
/* 마진율 테이블 create */

if is_color_opt = "N" then
	
		/* 마진율 테이블 create */
			ls_sql_marjin = 'Create table ##a_marjin_shop (	style			varchar(08),  '+ '~r~n' + &
												'                    shop_type	varchar(01),  '+ '~r~n' + &
												'                    end_ymd		varchar(08),  '+ '~r~n' + &
												'                    start_ymd   varchar(08),  '+ '~r~n' + &
												'                    sale_type   varchar(02),  '+ '~r~n' + &
												'                    sale_price	decimal(8),  '+ '~r~n' + &
												'                    dc_rate		decimal(5),  '+ '~r~n' + &
												'                    excp_yn		varchar(01), '+ '~r~n' + &
												'                    brand			varchar(01), '+ '~r~n' + &
												'                    year			varchar(04), '+ '~r~n' + &
												'                    season		varchar(01))'
			EXECUTE IMMEDIATE :ls_sql_marjin;
			
			ll_row_count = 0
			ll_row_count = dw_2.RowCount()
			
			/* 마진율 input */
			FOR i = 1 TO ll_row_count
				ls_style      = dw_2.getitemstring(i,'style')
				ls_shop_type  = dw_2.getitemstring(i,'shop_type')
				ls_end_ymd    = dw_2.getitemstring(i,'end_ymd')
				ls_start_ymd  = dw_2.getitemstring(i,'start_ymd')
				ls_sale_type  = dw_2.getitemstring(i,'sale_type')
				ll_sale_price = dw_2.getitemnumber(i,'sale_price')
				ll_dc_rate    = dw_2.getitemnumber(i,'dc_rate')
				ls_excp_yn    = 'N'
				ls_brand      = MidA(ls_style,1,1)
			//	ls_year       = '201' + mid(ls_style,3,1)
				
				ls_year_part = MidA(ls_style,3,1)
				
				select dbo.sf_inter_cd1('002',:ls_year_part)
				into :ls_year
				from dual;
				
				ls_season     = MidA(ls_style,4,1)
			
				insert into ##a_marjin_shop(style, shop_type, end_ymd, start_ymd, sale_type, sale_price, dc_rate, excp_yn, brand, year, season)
				values(:ls_style, :ls_shop_type, :ls_end_ymd, :ls_start_ymd, :ls_sale_type, :ll_sale_price, :ll_dc_rate, :ls_excp_yn, :ls_brand, :ls_year, :ls_season);
			next
			

			
			SELECT  COUNT(DISTINCT X.STYLE) 
			INTO :LL_CHK
			FROM 
			( select a.shop_cd, 
			 b.style, b.shop_type, b.end_ymd, b.start_ymd, b.sale_type, b.sale_price, b.dc_rate, b.excp_yn, b.brand, b.year, b.season
			from ##a_shop_cd a, ##a_marjin_shop b ) X, TB_56012_D Y
			WHERE X.SHOP_CD = Y.SHOP_CD
			AND X.SHOP_TYPE = Y.SHOP_TYPE
			AND case when x.end_ymd = '9999999' then convert(char(08),dateadd(day, -1, x.start_ymd),112) else x.end_ymd end= Y.END_YMD
			AND X.STYLE = Y.STYLE;

			IF LL_CHK > 0 THEN 
				MESSAGEBOX("알림","등록하려는 기간과 종료일이 같은 내역이 있습니다. 확인 후 처리 하세요!")
				DW_3.RETRIEVE()
				DW_3.visible = true
			else 	
				DW_3.visible = false				
			END IF	
			
		ls_sql_drop = 'drop table ##a_marjin_shop    drop table  ##a_shop_cd '
		EXECUTE IMMEDIATE :ls_sql_drop;
else		
	
   		/* 마진율 테이블 create */
			ls_sql_marjin = 'Create table ##a_marjin_shop (	style			varchar(08),  '+ '~r~n' + &
												'                    color			varchar(02),  '+ '~r~n' + &
												'                    shop_type	varchar(01),  '+ '~r~n' + &
												'                    end_ymd		varchar(08),  '+ '~r~n' + &
												'                    start_ymd   varchar(08),  '+ '~r~n' + &
												'                    sale_type   varchar(02),  '+ '~r~n' + &
												'                    sale_price	decimal(8),  '+ '~r~n' + &
												'                    dc_rate		decimal(5),  '+ '~r~n' + &
												'                    excp_yn		varchar(01), '+ '~r~n' + &
												'                    brand			varchar(01), '+ '~r~n' + &
												'                    year			varchar(04), '+ '~r~n' + &
												'                    season		varchar(01))'
			EXECUTE IMMEDIATE :ls_sql_marjin;
			
			ll_row_count = 0
			ll_row_count = dw_2.RowCount()
			
			/* 마진율 input */
			FOR i = 1 TO ll_row_count
				ls_style      = dw_2.getitemstring(i,'style')
				ls_color      = dw_2.getitemstring(i,'color')
				ls_shop_type  = dw_2.getitemstring(i,'shop_type')
				ls_end_ymd    = dw_2.getitemstring(i,'end_ymd')
				ls_start_ymd  = dw_2.getitemstring(i,'start_ymd')
				ls_sale_type  = dw_2.getitemstring(i,'sale_type')
				ll_sale_price = dw_2.getitemnumber(i,'sale_price')
				ll_dc_rate    = dw_2.getitemnumber(i,'dc_rate')
				ls_excp_yn    = 'N'
				ls_brand      = MidA(ls_style,1,1)
			//	ls_year       = '201' + mid(ls_style,3,1)
				
				ls_year_part = MidA(ls_style,3,1)
				
				select dbo.sf_inter_cd1('002',:ls_year_part)
				into :ls_year
				from dual;
				
				ls_season     = MidA(ls_style,4,1)
			
				insert into ##a_marjin_shop(style, shop_type, end_ymd, start_ymd, sale_type, sale_price, dc_rate, excp_yn, brand, year, season)
				values(:ls_style, :ls_shop_type, :ls_end_ymd, :ls_start_ymd, :ls_sale_type, :ll_sale_price, :ll_dc_rate, :ls_excp_yn, :ls_brand, :ls_year, :ls_season);
			next
	
			
			SELECT  COUNT(DISTINCT X.STYLE) 
			INTO :LL_CHK
			FROM 
			( select a.shop_cd, 
			 b.style, b.color, b.shop_type, b.end_ymd, b.start_ymd, b.sale_type, b.sale_price, b.dc_rate, b.excp_yn, b.brand, b.year, b.season
			from ##a_shop_cd a, ##a_marjin_shop b ) X, TB_56012_D_color Y
			WHERE X.SHOP_CD = Y.SHOP_CD
			AND X.SHOP_TYPE = Y.SHOP_TYPE
			AND  case when x.end_ymd = '9999999' then convert(char(08),dateadd(day, -1, x.start_ymd),112) else x.end_ymd end = Y.END_YMD
			AND X.STYLE = Y.STYLE
			AND X.color = Y.color;

			IF LL_CHK > 0 THEN 
				MESSAGEBOX("알림","등록하려는 기간과 종료일이 같은 내역이 있습니다. 확인 후 처리 하세요!")
				DW_3.RETRIEVE()
				DW_3.visible = true
			else 	
				DW_3.visible = false				
			END IF	
			
		ls_sql_drop = 'drop table ##a_marjin_shop    drop table  ##a_shop_cd '
		EXECUTE IMMEDIATE :ls_sql_drop;
	
end if	
					
		
		




end event

