$PBExportHeader$w_56011_e.srw
$PBExportComments$출고/판매 마진 일괄 변경
forward
global type w_56011_e from w_com010_e
end type
type tab_1 from tab within w_56011_e
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type p_1 from picture within tabpage_2
end type
type dw_2 from datawindow within tabpage_2
end type
type dw_1 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
p_1 p_1
dw_2 dw_2
dw_1 dw_1
end type
type tabpage_3 from userobject within tab_1
end type
type p_2 from picture within tabpage_3
end type
type dw_5 from datawindow within tabpage_3
end type
type dw_4 from datawindow within tabpage_3
end type
type st_1 from statictext within tabpage_3
end type
type tabpage_3 from userobject within tab_1
p_2 p_2
dw_5 dw_5
dw_4 dw_4
st_1 st_1
end type
type tab_1 from tab within w_56011_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_56011_e from w_com010_e
tab_1 tab_1
end type
global w_56011_e w_56011_e

type variables
String  is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_shop_type, is_job_fg 
String  is_bf_sale_type, is_af_sale_type 
Decimal idc_dc_rate,     idc_sale_rate, idc_fr_dc_rate, idc_to_dc_rate, idc_fr_marjin_rate, idc_to_marjin_rate 
end variables

forward prototypes
public function long wf_update_1 ()
public function integer wf_update_2 ()
public function integer wf_update_3 ()
end prototypes

public function long wf_update_1 ();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.14                                                  */	
/* 수정일      : 2002.05.14                                                  */
/*===========================================================================*/
// 마진율 변경 처리 

IF is_job_fg = 'O' OR is_job_fg = '%' THEN
   DECLARE SP_56011_OUT PROCEDURE FOR SP_56011_OUT  
           @brand     = :is_brand,   
           @fr_ymd    = :is_fr_ymd,   
           @to_ymd    = :is_to_ymd,   
           @shop_cd   = :is_shop_cd,   
           @shop_type = :is_shop_type, 
			  @user_id   = :gs_user_id ;
   EXECUTE SP_56011_OUT;
	IF SQLCA.SQLCODE = -1 THEN 
		rollback  USING SQLCA;
		MessageBox("출고 SQL오류", SQLCA.SqlErrText) 
		Return -1 
	ELSE
		commit  USING SQLCA;
	END IF 
END IF 

IF is_job_fg = 'T' OR is_job_fg = '%' THEN
   DECLARE SP_56011_WORK PROCEDURE FOR SP_56011_WORK  
           @brand     = :is_brand,   
           @fr_ymd    = :is_fr_ymd,   
           @to_ymd    = :is_to_ymd,   
           @shop_cd   = :is_shop_cd,   
           @shop_type = :is_shop_type, 
			  @user_id   = :gs_user_id ;
   EXECUTE SP_56011_WORK;
	IF SQLCA.SQLCODE = -1 THEN 
		rollback  USING SQLCA;
		MessageBox("출고 SQL오류", SQLCA.SqlErrText) 
		Return -1 
	ELSE
		commit  USING SQLCA;
	END IF 
END IF 

IF is_job_fg = 'R' OR is_job_fg = '%' THEN
   DECLARE SP_56011_RTRN PROCEDURE FOR SP_56011_RTRN  
           @brand     = :is_brand,   
           @fr_ymd    = :is_fr_ymd,   
           @to_ymd    = :is_to_ymd,   
           @shop_cd   = :is_shop_cd,   
           @shop_type = :is_shop_type, 
			  @user_id   = :gs_user_id ;
   EXECUTE SP_56011_RTRN;
	IF SQLCA.SQLCODE = -1 THEN 
		rollback  USING SQLCA;
		MessageBox("반품 SQL오류", SQLCA.SqlErrText) 
		Return -1 
	ELSE
		commit  USING SQLCA;
	END IF 
END IF 

IF is_job_fg = 'S' OR is_job_fg = '%' THEN
   DECLARE SP_56011_SALE PROCEDURE FOR SP_56011_SALE  
           @brand     = :is_brand,   
           @fr_ymd    = :is_fr_ymd,   
           @to_ymd    = :is_to_ymd,   
           @shop_cd   = :is_shop_cd,   
           @shop_type = :is_shop_type, 
			  @user_id   = :gs_user_id   ;
   EXECUTE SP_56011_SALE;
	IF SQLCA.SQLCODE = -1 THEN 
		rollback  USING SQLCA;
		MessageBox("판매 SQL오류", SQLCA.SqlErrText) 
		Return -1 
	ELSE
		commit  USING SQLCA;
	END IF 
END IF 

Return 1
end function

public function integer wf_update_2 ();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.14                                                  */	
/* 수정일      : 2002.05.14                                                  */
/*===========================================================================*/
// 판매형태 변경 처리 

DECLARE SP_56011_SALE2 PROCEDURE FOR SP_56011_SALE2  
        @brand        = :is_brand,   
        @fr_ymd       = :is_fr_ymd,   
        @to_ymd       = :is_to_ymd,   
        @shop_cd      = :is_shop_cd,   
        @shop_type    = :is_shop_type, 
        @bf_sale_type = :is_bf_sale_type, 
        @af_sale_type = :is_af_sale_type, 
        @dc_rate      = :idc_dc_rate, 
        @sale_rate    = :idc_sale_rate, 
		  @user_id      = :gs_user_id   ;

EXECUTE SP_56011_SALE2;

IF SQLCA.SQLCODE = -1 THEN 
	rollback  USING SQLCA;
	MessageBox("판매 SQL오류", SQLCA.SqlErrText) 
	Return -1 
ELSE
	commit  USING SQLCA;
END IF 

Return 1

end function

public function integer wf_update_3 ();// 판매형태 변경 처리 


//ALTER    PROCEDURE SP_56011_OUT2 
//       	@brand       varchar(1), 
//       	@fr_ymd      varchar(8),   
//       	@to_ymd      varchar(8), 
//       	@shop_cd     varchar(6), 
//       	@shop_type   varchar(1),
//	         @sale_type   varchar(02),   	
// 	      @fr_marjin   decimal(5,2),
// 	      @fr_dc	     decimal(5,2),
// 	      @to_marjin   decimal(5,2),
// 			@to_dc	     decimal(5,2),		 
//       	@user_id     varchar(6)


DECLARE SP_56011_out2 PROCEDURE FOR SP_56011_out2  
        @brand        = :is_brand,   
        @fr_ymd       = :is_fr_ymd,   
        @to_ymd       = :is_to_ymd,   
        @shop_cd      = :is_shop_cd,   
        @shop_type    = :is_shop_type, 
        @sale_type    = :is_bf_sale_type, 
		  @fr_marjin    = :idc_fr_marjin_rate,
        @fr_dc        = :idc_fr_dc_rate, 
		  @to_marjin    = :idc_to_marjin_rate,
        @to_dc        = :idc_to_dc_rate, 		  
		  @user_id      = :gs_user_id   ;

EXECUTE SP_56011_out2;

IF SQLCA.SQLCODE = -1 THEN 
	rollback  USING SQLCA;
	MessageBox("판매 SQL오류", SQLCA.SqlErrText) 
	Return -1 
ELSE
	commit  USING SQLCA;
END IF 

Return 1
end function

on w_56011_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_56011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;dw_head.Setitem(1, "shop_type", "%") 
dw_head.Setitem(1, "job_fg", "%")
cb_update.Visible = True
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
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
				IF ai_div = 2 THEN
					This.Post Event ue_retrieve()
				END IF
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
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
String   ls_title
Long     ll_row
Decimal  ll_to_dc_rate

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
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G') then
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



is_fr_ymd = String(dw_head.GetitemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetitemDate(1, "to_ymd"), "yyyymmdd")

IF LeftA(is_fr_ymd, 6) <> LeftA(is_to_ymd, 6) THEN 
   MessageBox(ls_title,"같은 월 내에서만 작업할수 있습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_job_fg = dw_head.GetItemString(1, "job_fg")
if IsNull(is_job_fg) or Trim(is_job_fg) = "" then
   MessageBox(ls_title,"작업구분 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("job_fg")
   return false
end if

IF tab_1.SelectedTab = 2 THEN 
	IF is_shop_type = '%' THEN 
      MessageBox(ls_title,"매장형태 전체는 작업할수 없습니다!")
      dw_head.SetFocus()
      dw_head.SetColumn("shop_type")
      return false
   end if
	ll_row = tab_1.tabpage_2.dw_1.GetSelectedRow(0)
	IF ll_row < 1 THEN
      MessageBox(ls_title,"FROM 판매형태를 선택하십시요 !")
      return false
	END IF
	is_bf_sale_type = tab_1.tabpage_2.dw_1.GetitemString(ll_row,  "sale_type")
   idc_dc_rate     = tab_1.tabpage_2.dw_1.GetitemDecimal(ll_row, "dc_rate")
	//
	ll_row = tab_1.tabpage_2.dw_2.GetSelectedRow(0)
	IF ll_row < 1 THEN
      MessageBox(ls_title,"TO 판매형태를 선택하십시요 !")
      return false
	END IF
	ll_to_dc_rate   = tab_1.tabpage_2.dw_2.GetitemDecimal(ll_row, "dc_rate")
	IF idc_dc_rate <> ll_to_dc_rate THEN
      MessageBox(ls_title,"같은 할인율대를 선택하십시요 !")
      return false
	END IF 
	is_af_sale_type = tab_1.tabpage_2.dw_2.GetitemString(ll_row,  "sale_type")
   idc_sale_rate   = tab_1.tabpage_2.dw_2.GetitemDecimal(ll_row, "marjin_rate")
END IF

IF tab_1.SelectedTab = 3 THEN 
	IF is_shop_type = '%' THEN 
      MessageBox(ls_title,"매장형태 전체는 작업할수 없습니다!")
      dw_head.SetFocus()
      dw_head.SetColumn("shop_type")
      return false
   end if
	ll_row = tab_1.tabpage_3.dw_4.GetSelectedRow(0)
	IF ll_row < 1 THEN
      MessageBox(ls_title,"FROM 판매형태를 선택하십시요 !")
      return false
	END IF
	is_bf_sale_type      = tab_1.tabpage_3.dw_4.GetitemString(ll_row,  "sale_type")
   idc_fr_dc_rate       = tab_1.tabpage_3.dw_4.GetitemDecimal(ll_row, "dc_rate")
   idc_fr_marjin_rate   = tab_1.tabpage_3.dw_4.GetitemDecimal(ll_row, "marjin_rate")	
	//
	ll_row = tab_1.tabpage_3.dw_5.GetSelectedRow(0)
	IF ll_row < 1 THEN
      MessageBox(ls_title,"TO 판매형태를 선택하십시요 !")
      return false
	END IF
	is_af_sale_type 		= tab_1.tabpage_3.dw_5.GetitemString(ll_row,  "sale_type")
	idc_to_dc_rate   		= tab_1.tabpage_3.dw_5.GetitemDecimal(ll_row, "dc_rate")
   idc_to_marjin_rate   = tab_1.tabpage_3.dw_5.GetitemDecimal(ll_row, "marjin_rate")		
	
//	IF idc_dc_rate <> ll_to_dc_rate THEN
//      MessageBox(ls_title,"같은 할인율대를 선택하십시요 !")
//      return false
//	END IF 
	
	if is_bf_sale_type <> is_af_sale_type then
		messagebox("경고!", "동일 판매형태에서만 변경 가능합니다!")
      return false
   end if		
	
END IF



Return true

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.14                                                  */	
/* 수정일      : 2002.05.14                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1

IF tab_1.SelectedTab = 1 THEN 
   il_rows = wf_update_1()
ELSEIF tab_1.SelectedTab = 2 THEN 
   il_rows = wf_update_2()
ELSE
   il_rows = wf_update_3()	
END IF

IF il_rows = 1 THEN
   MessageBox("확인", "처리 완료") 
END IF

This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_retrieve();call super::ue_retrieve;String ls_brand, ls_shop_cd, ls_shop_type, ls_yymmdd 

ls_brand      = dw_head.GetitemString(1, "brand") 
ls_shop_cd    = dw_head.GetitemString(1, "shop_cd") 
ls_shop_type  = dw_head.GetitemString(1, "shop_type") 
ls_yymmdd     = String(dw_head.GetitemDate(1, "to_ymd"), "yyyymmdd")



IF tab_1.SelectedTab = 2 THEN 
	tab_1.tabpage_2.dw_1.Retrieve(ls_brand, ls_shop_cd, ls_shop_type, ls_yymmdd)
	tab_1.tabpage_2.dw_2.Retrieve(ls_brand, ls_shop_cd, ls_shop_type, ls_yymmdd)	
elseIF tab_1.SelectedTab = 3 THEN 
	tab_1.tabpage_3.dw_4.Retrieve(ls_brand, ls_shop_cd, ls_shop_type, ls_yymmdd)
	tab_1.tabpage_3.dw_5.Retrieve(ls_brand, ls_shop_cd, ls_shop_type, ls_yymmdd)	
end if	
end event

event pfc_preopen();call super::pfc_preopen;tab_1.tabpage_2.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_5.SetTransObject(SQLCA)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56011_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56011_e
end type

type cb_delete from w_com010_e`cb_delete within w_56011_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56011_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56011_e
boolean visible = false
end type

type cb_update from w_com010_e`cb_update within w_56011_e
boolean enabled = true
end type

type cb_print from w_com010_e`cb_print within w_56011_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56011_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56011_e
end type

type cb_excel from w_com010_e`cb_excel within w_56011_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56011_e
integer x = 654
integer y = 324
integer width = 1888
integer height = 840
string dataobject = "d_56011_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('001') 

This.GetChild("shop_type", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('911') 
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%") 
ldw_child.Setitem(1, "inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.14                                                  */	
/* 수정일      : 2002.05.14                                                  */
/*===========================================================================*/
Long  ll_ret
cb_update.Enabled = TRUE

CHOOSE CASE dwo.name
	CASE "shop_cd"	    
		IF ib_itemchanged THEN RETURN 1
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
		IF ll_ret = 0 OR ll_ret = 2 THEN
	      Parent.Post Event ue_retrieve()
 		END IF
		return ll_ret
	CASE "shop_type"	    
		Parent.Post Event ue_retrieve()
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56011_e
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_56011_e
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_56011_e
boolean visible = false
end type

type dw_print from w_com010_e`dw_print within w_56011_e
end type

type tab_1 from tab within w_56011_e
integer x = 288
integer y = 216
integer width = 3159
integer height = 1680
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
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;String ls_modify

CHOOSE CASE newindex
	CASE 1 
		ls_modify = "job_fg.Visible =1 t_2.Visible =0 t_3.visible = 0 "
		dw_head.modify(ls_modify)
	CASE 2 
		ls_modify = "job_fg.Visible =0 t_2.Visible =1 t_3.visible = 0"
		dw_head.modify(ls_modify)
	CASE 3 
		ls_modify = "job_fg.Visible =0 t_2.Visible =0 t_3.visible = 1"
		dw_head.modify(ls_modify)		
		
END CHOOSE 
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3122
integer height = 1568
long backcolor = 79741120
string text = "마진율 변경 처리"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3122
integer height = 1568
long backcolor = 79741120
string text = "판매형태 변경처리"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
p_1 p_1
dw_2 dw_2
dw_1 dw_1
end type

on tabpage_2.create
this.p_1=create p_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.p_1,&
this.dw_2,&
this.dw_1}
end on

on tabpage_2.destroy
destroy(this.p_1)
destroy(this.dw_2)
destroy(this.dw_1)
end on

type p_1 from picture within tabpage_2
integer x = 1440
integer y = 1096
integer width = 142
integer height = 124
boolean originalsize = true
string picturename = "C:\Bnc_dept\bmp\next.bmp"
boolean focusrectangle = false
end type

type dw_2 from datawindow within tabpage_2
integer x = 1591
integer y = 876
integer width = 1051
integer height = 588
integer taborder = 50
string title = "none"
string dataobject = "d_56011_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

event clicked;
IF row < 1 THEN RETURN 

This.SelectRow(0,   False)
This.SelectRow(row, True)

end event

type dw_1 from datawindow within tabpage_2
integer x = 370
integer y = 888
integer width = 1056
integer height = 576
integer taborder = 40
string title = "none"
string dataobject = "d_56011_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

event clicked;
IF row < 1 THEN RETURN 

This.SelectRow(0,   False)
This.SelectRow(row, True)

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3122
integer height = 1568
long backcolor = 79741120
string text = "출고할인마진변경"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
p_2 p_2
dw_5 dw_5
dw_4 dw_4
st_1 st_1
end type

on tabpage_3.create
this.p_2=create p_2
this.dw_5=create dw_5
this.dw_4=create dw_4
this.st_1=create st_1
this.Control[]={this.p_2,&
this.dw_5,&
this.dw_4,&
this.st_1}
end on

on tabpage_3.destroy
destroy(this.p_2)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.st_1)
end on

type p_2 from picture within tabpage_3
integer x = 1440
integer y = 1096
integer width = 142
integer height = 124
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Bnc_dept\bmp\next.bmp"
boolean focusrectangle = false
end type

type dw_5 from datawindow within tabpage_3
integer x = 1591
integer y = 876
integer width = 1051
integer height = 588
integer taborder = 60
string title = "none"
string dataobject = "d_56011_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
IF row < 1 THEN RETURN 

This.SelectRow(0,   False)
This.SelectRow(row, True)

end event

event constructor;DataWindowChild ldw_child

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

type dw_4 from datawindow within tabpage_3
integer x = 370
integer y = 888
integer width = 1056
integer height = 576
integer taborder = 50
string title = "none"
string dataobject = "d_56011_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
IF row < 1 THEN RETURN 

This.SelectRow(0,   False)
This.SelectRow(row, True)

end event

event constructor;DataWindowChild ldw_child

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

type st_1 from statictext within tabpage_3
integer x = 731
integer y = 1484
integer width = 1778
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 판매형태가 같은 경우에만 처리가능합니다!"
boolean focusrectangle = false
end type

