$PBExportHeader$w_11012_e.srw
$PBExportComments$테마별 물량계획
forward
global type w_11012_e from w_com010_e
end type
type dw_1 from datawindow within w_11012_e
end type
type st_1 from statictext within w_11012_e
end type
end forward

global type w_11012_e from w_com010_e
dw_1 dw_1
st_1 st_1
end type
global w_11012_e w_11012_e

type variables
DataWindowChild idw_brand, idw_season, idw_plan_seq

String is_brand, is_year, is_season 
Long   il_plan_seq 

end variables

on w_11012_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
end on

on w_11012_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
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
   MessageBox(ls_title,"시즌코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

il_plan_seq = dw_head.GetItemNumber(1, "plan_seq")
if IsNull(il_plan_seq) then
   MessageBox(ls_title,"사업계획차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("plan_seq")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.retrieve(is_brand, is_year, is_season, il_plan_seq)
il_rows = dw_body.retrieve(is_brand, is_year, is_season, il_plan_seq)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")

dw_1.SetTransObject(SQLCA)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/
long     i, k, ll_row_count, ll_row
datetime ld_datetime 
String   ls_find, ls_concept[] = {"B", "N", "T"}
String   ls_plan_fg, ls_sojae, ls_item   
Long     ll_mod_cnt,   ll_avg_lot 
Decimal  ldc_plan_amt, ldc_cost_rate, ldc_cost_amt

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

// 테마별 물량 계획 처리 
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN	
		ls_plan_fg = dw_body.object.plan_fg[i] 
		ls_sojae   = dw_body.object.sojae[i] 
		ls_item    = dw_body.object.item[i] 
		// 차순별 물량 계획 처리 
		FOR k = 1 TO 3 
         ll_mod_cnt    = dw_body.GetitemNumber(i, "mod_cnt_" + lower(ls_concept[k]))
         ll_avg_lot    = dw_body.GetitemNumber(i, "avg_lot_" + lower(ls_concept[k]))
         ldc_plan_amt  = dw_body.GetitemDecimal(i, "c_plan_amt_" + lower(ls_concept[k]))
         ldc_cost_rate = dw_body.GetitemDecimal(i, "cost_rate_" + lower(ls_concept[k]))
         ldc_cost_amt  = dw_body.GetitemDecimal(i, "c_cost_amt_" + lower(ls_concept[k]))

			ls_find = "plan_fg = '" + ls_plan_fg + "' and sojae = '" + ls_sojae + & 
			          "' and item = '" + ls_item + "' and concept = '" + ls_concept[k] + "'" 
    	   ll_row = dw_1.find(ls_find, 1, dw_1.RowCount())  
			IF ll_row < 1 THEN
				ll_row = dw_1.insertRow(0)
		   	dw_1.Setitem(ll_row, "brand",    is_brand)
			   dw_1.Setitem(ll_row, "year",     is_year)
			   dw_1.Setitem(ll_row, "season",   is_season)
			   dw_1.Setitem(ll_row, "plan_seq", il_plan_seq)
			   dw_1.Setitem(ll_row, "plan_fg",  ls_plan_fg)
			   dw_1.Setitem(ll_row, "sojae",    ls_sojae)
			   dw_1.Setitem(ll_row, "item",     ls_item)
			   dw_1.Setitem(ll_row, "concept",  ls_concept[k])
            dw_1.Setitem(ll_row, "reg_id",   gs_user_id)
			ELSE
            dw_1.Setitem(ll_row, "mod_id", gs_user_id)
            dw_1.Setitem(ll_row, "mod_dt", ld_datetime)
			END IF
         dw_1.Setitem(ll_row, "mod_cnt",   ll_mod_cnt)
         dw_1.Setitem(ll_row, "avg_lot",   ll_avg_lot)
	      dw_1.Setitem(ll_row, "plan_amt",  ldc_plan_amt * 1000)
         dw_1.Setitem(ll_row, "cost_rate", ldc_cost_rate)
         dw_1.Setitem(ll_row, "cost_amt",  ldc_cost_amt * 1000)
		NEXT 
	END IF
NEXT 

il_rows = dw_1.Update()

if il_rows = 1 then 
	// 화면용 update정보 Reset
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + & 
				"t_brand.Text = '브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_season.Text = ' 시즌 : " + is_year + " " + idw_season.GetitemString(idw_season.GetRow(), "inter_display") + "'" + & 
				"t_plan_seq.Text = '사업계획차수 : " +  String(il_plan_seq) + "차'"
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11012_e","0")
end event

type cb_close from w_com010_e`cb_close within w_11012_e
end type

type cb_delete from w_com010_e`cb_delete within w_11012_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_11012_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_11012_e
end type

type cb_update from w_com010_e`cb_update within w_11012_e
end type

type cb_print from w_com010_e`cb_print within w_11012_e
end type

type cb_preview from w_com010_e`cb_preview within w_11012_e
end type

type gb_button from w_com010_e`gb_button within w_11012_e
end type

type cb_excel from w_com010_e`cb_excel within w_11012_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_11012_e
integer height = 168
string dataobject = "d_11012_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(sqlca)
idw_season.Retrieve('003')

This.GetChild("plan_seq", idw_plan_seq)
idw_plan_seq.SetTransObject(sqlca)
idw_plan_seq.insertRow(0)


end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name 
	CASE "plan_seq" 
		ls_brand  = This.GetitemString(1, "brand")
		ls_year   = This.GetitemString(1, "year")
		ls_season = This.GetitemString(1, "season")
		idw_plan_seq.Retrieve(ls_brand, ls_year, ls_season)
END CHOOSE

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
Long ll_seq

CHOOSE CASE dwo.name
	CASE "brand", "year", "season"      // dddw로 작성된 항목
    This.Setitem(1,"plan_seq", ll_seq)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_11012_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_11012_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_11012_e
integer y = 376
integer height = 1672
string dataobject = "d_11012_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_e`dw_print within w_11012_e
string dataobject = "d_11012_r01"
end type

type dw_1 from datawindow within w_11012_e
boolean visible = false
integer x = 2464
integer y = 292
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_11012_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

MessageBox(parent.title, ls_message_string)
return 1
end event

type st_1 from statictext within w_11012_e
integer x = 2706
integer y = 276
integer width = 891
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "단위 : 천원 (평균판매가 : 원)"
alignment alignment = right!
boolean focusrectangle = false
end type

