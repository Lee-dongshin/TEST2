$PBExportHeader$w_56008_e.srw
$PBExportComments$매장재고감가처리
forward
global type w_56008_e from w_com010_e
end type
end forward

global type w_56008_e from w_com010_e
integer width = 3675
integer height = 2280
end type
global w_56008_e w_56008_e

type variables
DataWindowChild idw_brand, idw_season, idw_shop_div, idw_shop_type  
String is_brand, is_year, is_season, is_yymmdd, is_shop_div, is_shop_type 
String is_yn

end variables

on w_56008_e.create
call super::create
end on

on w_56008_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.Setitem(1, "shop_div",  "%")
dw_head.Setitem(1, "shop_type", "1")

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.02.09                                                  */
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

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

Return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_year, is_season, is_shop_div, is_shop_type)
IF il_rows > 0 THEN
	is_yn = 'N'
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
String   ls_shop_cd,  ls_ErrMsg 
Long     ll_qty, ll_rtn_amt, ll_rtn_collect, ll_out_amt, ll_out_collect 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

FOR i=1 TO ll_row_count 
	IF dw_body.Object.job_yn[i] <> 'Y' THEN CONTINUE
	ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
   DECLARE SP_56008 PROCEDURE FOR SP_56008  
           @yymmdd    = :is_yymmdd, 
           @shop_cd   = :ls_shop_cd,   
           @brand     = :is_brand,   
           @year      = :is_year,   
           @season    = :is_season,   
			  @shop_type = :is_shop_type, 
			  @person_id = :gs_user_id; 
   EXECUTE SP_56008;
   IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
      il_rows = 1
      commit  USING SQLCA;
		//  감가 처리내역 산출 
		select sum(qty), 
             sum(rtn_amt), sum(rtn_collect), 
             sum(out_amt), sum(out_collect) 
        into :ll_qty, 
		       :ll_rtn_amt, :ll_rtn_collect, 
				 :ll_out_amt, :ll_out_collect 
        from tb_56020_h  
       where yymmdd    =    :is_yymmdd 
         and shop_cd   like :ls_shop_cd 
         and brand     =    :is_brand 
         and year      =    :is_year 
         and season    =    :is_season 
         and shop_type =    :is_shop_type ; 
		//
		dw_body.Setitem(i, "qty", ll_qty)
		dw_body.Setitem(i, "rtn_amt", ll_rtn_amt)
		dw_body.Setitem(i, "rtn_collect", ll_rtn_collect)
		dw_body.Setitem(i, "out_amt", ll_out_amt)
		dw_body.Setitem(i, "out_collect", ll_out_collect) 
   ELSE
      ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
      Rollback  USING SQLCA;
      MessageBox("저장 실패 [" + ls_shop_cd + "]", ls_ErrMsg)
      il_rows = -1 
      EXIT
   END IF
NEXT

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56008_e","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_season

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_season = is_year + "/" + is_season

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '브랜드: " + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				 "t_season.text = '년도/시즌: " + ls_season + "' " + &
				 "t_yymmdd.text = '기준일: " + is_yymmdd + "' " + &
				 "t_shop_div.Text = '유통망: " + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'" + &
				 "t_shop_type.Text = '매장형태: " + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" 


dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_e`cb_close within w_56008_e
end type

type cb_delete from w_com010_e`cb_delete within w_56008_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56008_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56008_e
end type

type cb_update from w_com010_e`cb_update within w_56008_e
end type

type cb_print from w_com010_e`cb_print within w_56008_e
end type

type cb_preview from w_com010_e`cb_preview within w_56008_e
end type

type gb_button from w_com010_e`gb_button within w_56008_e
end type

type cb_excel from w_com010_e`cb_excel within w_56008_e
end type

type dw_head from w_com010_e`dw_head within w_56008_e
integer height = 240
string dataobject = "d_56008_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.SetFilter("inter_data2 = 'Y'")
idw_shop_div.Filter()
idw_shop_div.insertRow(1)
idw_shop_div.Setitem(1, "inter_cd", "%")
idw_shop_div.Setitem(1, "inter_nm", "전체")

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')

end event

type ln_1 from w_com010_e`ln_1 within w_56008_e
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_e`ln_2 within w_56008_e
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_e`dw_body within w_56008_e
integer y = 440
integer height = 1608
string dataobject = "d_56008_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i

IF dwo.name = "b_yn" THEN 
	IF is_yn = 'Y' THEN 
		is_yn = 'N' 
	ELSE
		is_yn = 'Y'
	END IF
	FOR i = 1 TO dw_body.RowCount() 
		dw_body.Setitem(i, "job_yn", is_yn)
	NEXT 
   ib_changed = true
   cb_update.enabled = true
   cb_print.enabled = false
   cb_preview.enabled = false
   cb_excel.enabled = false
END IF

end event

type dw_print from w_com010_e`dw_print within w_56008_e
string dataobject = "d_56008_r01"
end type

