$PBExportHeader$w_56026_e.srw
$PBExportComments$행사 마진율 일괄등록
forward
global type w_56026_e from w_com010_e
end type
type cb_copy from commandbutton within w_56026_e
end type
type tab_1 from tab within w_56026_e
end type
type tabpage_1 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_2 dw_2
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_2
end type
type dw_4 from datawindow within tabpage_2
end type
type dw_3 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_5 dw_5
dw_4 dw_4
dw_3 dw_3
end type
type tab_1 from tab within w_56026_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_56026_e from w_com010_e
integer width = 3689
integer height = 2252
cb_copy cb_copy
tab_1 tab_1
end type
global w_56026_e w_56026_e

type variables
DataWindowChild idw_sale_type_1, idw_sale_type_2
String is_brand, is_shop_div, is_shop_grp, is_yymmdd, is_no, is_gubn
String is_year,  is_season,   is_fr_ymd,   is_to_ymd 
String is_job_yn = 'Y' , is_dep_opt
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

on w_56026_e.create
int iCurrent
call super::create
this.cb_copy=create cb_copy
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy
this.Control[iCurrent+2]=this.tab_1
end on

on w_56026_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copy)
destroy(this.tab_1)
end on

event pfc_preopen();call super::pfc_preopen;/* DataWindow의 Transction 정의 */
dw_head.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_5.SetTransObject(SQLCA)
//dw_print.SetTransObject(SQLCA)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
tab_1.tabpage_1.dw_2.InsertRow(0)
tab_1.tabpage_2.dw_3.InsertRow(0)
tab_1.tabpage_2.dw_4.InsertRow(0)
tab_1.tabpage_2.dw_5.InsertRow(0)


/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleTobottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_5, "ScaleToBottom")


/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(tab_1.tabpage_1.dw_1)





end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

//dw_head.SetItem(1, "fr_ymd" ,string(ld_datetime,"yyyymmdd"))
//dw_head.SetItem(1, "to_ymd" ,string(ld_datetime,"yyyymmdd"))

dw_head.setitem(1, 'brand', gs_brand)
dw_head.Setitem(1, "shop_div", "G")
dw_head.Setitem(1, "shop_grp", "%")
dw_head.SetItem(1, "yymmdd" ,string(ld_datetime,"yyyymmdd"))
is_gubn = '1'
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"등록일자를 입력해 주세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if
/*
is_no = dw_head.GetItemString(1, "no")
if IsNull(is_no) or Trim(is_no) = "" then
   MessageBox(ls_title,"등록순번을 입력해 주세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("no")
   return false
end if
*/
/*
is_dep_opt = dw_head.GetItemString(1, "dep_opt")
if IsNull(is_dep_opt) or Trim(is_dep_opt) = "" then
   MessageBox(ls_title,"작업구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_opt")
   return false
end if


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

*/

Return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.02.09                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_gubn = '1' then
	il_rows = tab_1.tabpage_1.dw_1.retrieve(is_brand, is_shop_div, '%')
	IF il_rows > 0 THEN
		tab_1.tabpage_1.dw_2.Reset()
		tab_1.tabpage_1.dw_2.insertrow(0)
	end if
elseif is_gubn = '2' then
//	il_rows = tab_1.tabpage_2.dw_3.retrieve(is_yymmdd, is_no)	
	il_rows = tab_1.tabpage_2.dw_5.retrieve(is_yymmdd)
	IF il_rows < 1 THEN	
		messagebox('확인','조회할 자료가 없습니다!')
	end if
	/*
	DataWindowChild ldw_child
	
	tab_1.tabpage_2.dw_4.GetChild("shop_type", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve('911')
	
	tab_1.tabpage_2.dw_4.GetChild("sale_type", idw_sale_type_1)
	idw_sale_type_1.SetTransObject(SQLCA)
	idw_sale_type_1.Retrieve('011')
	*/
end if


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
         cb_update.Enabled = true
			
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
long i, ll_row_count, ll_row_count2, ll_row_count3
datetime ld_datetime 
boolean  lb_ok
decimal  ld_max_id
String   ls_shop_cd, ls_ErrMsg, ls_sql_shop, ls_sql_1, ls_sql_marjin, ls_sql_2, ls_sql_execute, ls_yymmdd, ls_no, ls_conform
string   ls_style, ls_start_ymd, ls_end_ymd, ls_shop_type, ls_sale_type, ls_excp_yn, ls_brand, ls_season, ls_year, ls_check
long     ll_sale_price, ll_dc_rate, ll_rows



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

if is_gubn = '1' then
	ll_row_count = tab_1.tabpage_1.dw_1.RowCount()
	IF tab_1.tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN -1

	/* 매장코드 저장 테이블 create */
	ls_sql_shop = "create table ##a_shop_cd (shop_cd varchar(6))"
	EXECUTE IMMEDIATE :ls_sql_shop;
	
	/* 선택된 매장코드 input */
	FOR i = 1 TO ll_row_count 
		 IF tab_1.tabpage_1.dw_1.Object.job_yn[i] = 'N' THEN CONTINUE 
		 ls_shop_cd = tab_1.tabpage_1.dw_1.GetitemString(i, "shop_cd")
		 insert into ##a_shop_cd values(:ls_shop_cd);
	next
	
	/* 마진율 테이블 create */
	
	ls_sql_marjin = 'Create table ##a_marjin_shop (	yymmdd	varchar(08),  '+ '~r~n' + &
										'                    no				varchar(04),  '+ '~r~n' + &
										'                    style			varchar(08),  '+ '~r~n' + &
										'                    end_ymd		varchar(08),  '+ '~r~n' + &
										'                    start_ymd   varchar(08),  '+ '~r~n' + &
										'                    sale_price	decimal(8),  '+ '~r~n' + &
										'                    dc_rate		decimal(5),  '+ '~r~n' + &
										'                    excp_yn		varchar(01), '+ '~r~n' + &
										'                    conform		varchar(01), '+ '~r~n' + &										
										'                    brand			varchar(01), '+ '~r~n' + &
										'                    year			varchar(04), '+ '~r~n' + &
										'                    season		varchar(01))'
	EXECUTE IMMEDIATE :ls_sql_marjin;
	
	
	tab_1.tabpage_1.dw_2.accepttext()
	
	ll_row_count2 = tab_1.tabpage_1.dw_2.RowCount()
	IF tab_1.tabpage_1.dw_2.AcceptText() <> 1 THEN RETURN -1
	
		
	/* 마진율 input */
		ls_yymmdd     = dw_head.getitemstring(1,'yymmdd')
		
		select isnull(max(no),0) into :ld_max_id
		from tb_56014_d //with (nolock)
		where yymmdd = :ls_yymmdd;
		
		ls_no         = string(ld_max_id + 1, '0000')
		
		FOR i = 1 TO ll_row_count2
			ls_style      = tab_1.tabpage_1.dw_2.getitemstring(i,'style')
			IF gf_style_chk(ls_style, '%') THEN
			else
				messagebox('확인', ls_style +' Style 번호를 확인해 주세요!')
				RETURN 0	
			END IF 			
			ls_end_ymd    = tab_1.tabpage_1.dw_2.getitemstring(i,'end_ymd')
			ls_start_ymd  = tab_1.tabpage_1.dw_2.getitemstring(i,'start_ymd')
			ll_sale_price = tab_1.tabpage_1.dw_2.getitemnumber(i,'sale_price')
			ll_dc_rate    = tab_1.tabpage_1.dw_2.getitemnumber(i,'dc_rate')
			ls_excp_yn    = 'N'
			ls_conform    = 'N'
			ls_brand      = MidA(ls_style,1,1)
			ls_year       = '201' + MidA(ls_style,3,1)		
			ls_season     = MidA(ls_style,4,1)
	
			insert into ##a_marjin_shop
			values(:ls_yymmdd, :ls_no, :ls_style, :ls_end_ymd, :ls_start_ymd, :ll_sale_price, :ll_dc_rate, :ls_excp_yn, :ls_conform, :ls_brand, :ls_year, :ls_season);
		next
		
		ls_sql_execute = 'sp_56026_update'
		EXECUTE IMMEDIATE :ls_sql_execute;

elseif is_gubn = '2' then

	ll_row_count3 = tab_1.tabpage_2.dw_3.RowCount()
	
	select top 1 conform
	into :ls_conform
	from tb_56014_d
	where yymmdd = :is_yymmdd
			and no = :is_no;
			
	if ls_conform <> 'Y' then	
		tab_1.tabpage_2.dw_3.accepttext()
		/* 선택된코드  update */		
		FOR i = 1 TO ll_row_count3 			
			 ls_check = tab_1.tabpage_2.dw_3.GetitemString(i, "check_yn")
			 ls_style = tab_1.tabpage_2.dw_3.GetitemString(i, "style")
			 
			 update tb_56014_d 
			 set check_yn = :ls_check
			 from tb_56014_d
			 where yymmdd = :is_yymmdd
					and no = :is_no
					and style = :ls_style;

		//먼저 업데이트 시키기...		
			IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
				il_rows = 1	
				commit  USING SQLCA;
			ELSE
				ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
				Rollback  USING SQLCA;
				MessageBox("저장 실패 [" + ls_shop_cd + "]", ls_ErrMsg)
				il_rows = -1 
			END IF			
		next
			
		ll_rows = tab_1.tabpage_2.dw_3.Update(TRUE, FALSE)
		ls_sql_execute = "SP_56026_H_TRG " + "'" + is_yymmdd + "', '" + is_no + "'"
		EXECUTE IMMEDIATE :ls_sql_execute;
		
	elseif ls_conform = 'Y' then
		messagebox('확인', '이미 처리한 데이터입니다. 수정이 불가능합니다!!!')
		return 0
	end if

end if
/* DataBase commit or rollback */
IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
//IF SQLCA.SQLCODE = 0 THEN	
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56026_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56026_e
end type

type cb_delete from w_com010_e`cb_delete within w_56026_e
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

type cb_insert from w_com010_e`cb_insert within w_56026_e
integer x = 2523
string text = "입력"
end type

event cb_insert::clicked;//ids_copy.Reset()
//dw_4.reset()
//dw_2.RowsCopy(1, dw_2.RowCount(), Primary!, dw_4, 1, Primary!)

end event

type cb_retrieve from w_com010_e`cb_retrieve within w_56026_e
integer x = 2871
end type

type cb_update from w_com010_e`cb_update within w_56026_e
end type

type cb_print from w_com010_e`cb_print within w_56026_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56026_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56026_e
end type

type cb_excel from w_com010_e`cb_excel within w_56026_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56026_e
integer x = 18
integer y = 160
integer width = 3584
integer height = 148
string dataobject = "d_56026_h01"
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
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", '%')
ldw_child.Setitem(1, "inter_nm", '전체')
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
				messagebox('확인', is_pgm_id)
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56026_e
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_e`ln_2 within w_56026_e
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_e`dw_body within w_56026_e
boolean visible = false
integer x = 0
integer y = 404
integer width = 1111
integer height = 716
boolean enabled = false
string dataobject = "d_56026_d01"
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

type dw_print from w_com010_e`dw_print within w_56026_e
end type

type cb_copy from commandbutton within w_56026_e
boolean visible = false
integer x = 741
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

type tab_1 from tab within w_56026_e
event create ( )
event destroy ( )
integer y = 320
integer width = 3607
integer height = 1696
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
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

event clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

//IF dw_head.Enabled = TRUE THEN Return 1

  	CHOOSE CASE index
		CASE 1
			is_gubn = '1'
			//dw_body.visible = false
			tab_1.tabpage_1.dw_1.visible = true
			tab_1.tabpage_1.dw_2.visible = true
			tab_1.tabpage_2.dw_3.visible = false
			tab_1.tabpage_2.dw_4.visible = false
		CASE 2
			if gs_dept_cd = 'S360' or gs_dept_cd = '4100' or gs_dept_cd = 'T310' or gs_dept_cd = 'R340' or gs_dept_cd = '9000' or gs_dept_cd = 'T500' or gs_dept_cd = 'R300'  then
				//dw_body.visible = false
				is_gubn = '2'
				tab_1.tabpage_2.dw_3.visible = true
				tab_1.tabpage_2.dw_4.visible = true				
			else
				messagebox('권한 CHECK!','영업관리팀만 사용이 가능합니다.!')
				tab_1.tabpage_2.dw_3.visible = false
				tab_1.tabpage_2.dw_4.visible = false				
				return 
			end if


	END CHOOSE


//if tab_1.selectedtab = 4 then
//	is_proc_yn = "N"
//end if	
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 3570
integer height = 1584
long backcolor = 79741120
string text = "영업팀"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
dw_1 dw_1
end type

on tabpage_1.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.dw_2,&
this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_2)
destroy(this.dw_1)
end on

type dw_2 from datawindow within tabpage_1
integer x = 1147
integer width = 2423
integer height = 1584
integer taborder = 110
string dataobject = "d_56026_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;string aa

/*===========================================================================*/
/* 작성자      : 지우정보 (권 진택)                                          */	
/* 작성일      : 2000.09.07																  */	
/* 수성일      : 2001.10.04                                                  */
/*===========================================================================*/
Integer ll_cur_row

ll_cur_row = tab_1.tabpage_1.dw_2.GetRow()

If dwo.name = "cb_deleterow" Then 
	idw_status = tab_1.tabpage_1.dw_2.GetItemStatus (ll_cur_row, 0, primary!)	
	tab_1.tabpage_1.dw_2.DeleteRow(ll_cur_row)
	if idw_status <> new! and idw_status <> newmodified! then
		ib_changed = true
		cb_update.enabled = true
	end if
end if


end event

type dw_1 from datawindow within tabpage_1
integer width = 1138
integer height = 1584
integer taborder = 20
string dataobject = "d_56026_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;Long i, ll_row 

ll_row = tab_1.tabpage_1.dw_1.RowCount()
IF ll_row < 1 THEN RETURN

IF dwo.name = "b_job_yn" THEN
	IF is_job_yn = 'Y' THEN 
		is_job_yn = 'N' 
	ELSE
		is_job_yn = 'Y' 
	END IF
	FOR i = 1 TO ll_row 
		tab_1.tabpage_1.dw_1.Object.job_yn[i] = is_job_yn
	NEXT 
END IF
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 3570
integer height = 1584
long backcolor = 79741120
string text = "영업관리팀"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
dw_4 dw_4
dw_3 dw_3
end type

on tabpage_2.create
this.dw_5=create dw_5
this.dw_4=create dw_4
this.dw_3=create dw_3
this.Control[]={this.dw_5,&
this.dw_4,&
this.dw_3}
end on

on tabpage_2.destroy
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.dw_3)
end on

type dw_5 from datawindow within tabpage_2
integer width = 741
integer height = 1580
integer taborder = 20
string title = "none"
string dataobject = "d_56026_d04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
string ls_receipt_ymd 
long ll_rows
IF row <= 0 THEN Return

is_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_no = This.GetItemString(row, 'no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) or IsNull(is_no) THEN return

il_rows = tab_1.tabpage_2.dw_3.retrieve(is_yymmdd, is_no)

			 
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
end event

type dw_4 from datawindow within tabpage_2
integer x = 1906
integer width = 3232
integer height = 84
integer taborder = 130
string title = "none"
string dataobject = "d_56026_h02"
boolean border = false
boolean livescroll = true
end type

event constructor;DataWindowChild ldw_child

this.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

/*
This.GetChild("shop_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')
*/
This.GetChild("sale_type", idw_sale_type_1)
idw_sale_type_1.SetTransObject(SQLCA)
idw_sale_type_1.Retrieve('011')
/*
This.GetChild("sale_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')
*/
//This.SetRowFocusIndicator(Hand!)
end event

event clicked;Long i, ll_row 
string ls_shop_type, ls_sale_type, ls_start_ymd, ls_end_ymd
decimal ld_sale_price, ld_dc_rate

tab_1.tabpage_2.dw_4.accepttext()
ll_row = tab_1.tabpage_2.dw_3.RowCount()
IF ll_row < 1 THEN RETURN

ls_shop_type = tab_1.tabpage_2.dw_4.getitemstring(1,'shop_type')
ls_sale_type = tab_1.tabpage_2.dw_4.getitemstring(1,'sale_type')
ld_sale_price = tab_1.tabpage_2.dw_4.getitemnumber(1,'sale_price')
ld_dc_rate = tab_1.tabpage_2.dw_4.getitemnumber(1,'dc_rate')
ls_start_ymd = tab_1.tabpage_2.dw_4.getitemstring(1,'start_ymd')
ls_end_ymd = tab_1.tabpage_2.dw_4.getitemstring(1,'end_ymd')

IF dwo.name = "b_1" THEN
	FOR i = 1 TO ll_row 
		tab_1.tabpage_2.dw_3.setitem(i, 'shop_type', ls_shop_type)
		tab_1.tabpage_2.dw_3.setitem(i, 'sale_type', ls_sale_type)
	NEXT 
ELSEIF dwo.name = "b_2" THEN
	FOR i = 1 TO ll_row 
		tab_1.tabpage_2.dw_3.setitem(i, 'start_ymd', ls_start_ymd)
		tab_1.tabpage_2.dw_3.setitem(i, 'end_ymd', ls_end_ymd)
	NEXT 
END IF


end event

type dw_3 from datawindow within tabpage_2
integer x = 754
integer y = 84
integer width = 2816
integer height = 1500
integer taborder = 20
string title = "none"
string dataobject = "d_56026_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_yn
Long i, ll_row 

ll_row = tab_1.tabpage_2.dw_3.RowCount()
IF ll_row < 1 THEN RETURN

IF dwo.name = "b_1" THEN
	IF ls_yn = 'Y' THEN 
		ls_yn = 'N' 
	ELSE
		ls_yn = 'Y' 
	END IF
	FOR i = 1 TO ll_row 
		tab_1.tabpage_2.dw_3.Object.check_yn[i] = ls_yn
	NEXT 
END IF
end event

event constructor;DataWindowChild ldw_child

this.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

/*
This.GetChild("shop_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')
*/
This.GetChild("sale_type", idw_sale_type_1)
idw_sale_type_1.SetTransObject(SQLCA)
idw_sale_type_1.Retrieve('011')

end event

