$PBExportHeader$w_11011_e.srw
$PBExportComments$시즌/품종별물량계획
forward
global type w_11011_e from w_com010_e
end type
type dw_temp1 from datawindow within w_11011_e
end type
type dw_1 from datawindow within w_11011_e
end type
type dw_2 from datawindow within w_11011_e
end type
type st_1 from statictext within w_11011_e
end type
end forward

global type w_11011_e from w_com010_e
dw_temp1 dw_temp1
dw_1 dw_1
dw_2 dw_2
st_1 st_1
end type
global w_11011_e w_11011_e

type variables
DataWindowChild idw_brand, idw_season, idw_plan_seq
String is_brand, is_year, is_season
Long   il_plan_seq

end variables

forward prototypes
public function boolean wf_bf_set ()
public subroutine wf_outseq_set ()
public subroutine wf_plan_set ()
end prototypes

public function boolean wf_bf_set ();/*----------------------------------------------------------*/
/* 전년 실적 처리                                           */
/*----------------------------------------------------------*/
Long    ll_row,  i 
String  ls_imsi_fg = ' ', ls_imsi_sojae = ' ', ls_imsi_item = ' '
decimal ld_bf_cost
// FETCH 항목 
String  ls_plan_fg, ls_plan_fg_nm, ls_sojae,  ls_sojae_nm
String  ls_item,    ls_item_nm,    ls_out_seq
Long    ll_mod_cnt
decimal ld_pcs, ld_tag_amt, ld_cost_amt

DECLARE SP_11011_D PROCEDURE FOR SP_11011_D  
        @brand  = :is_brand,   
        @year   = :is_year,   
        @season = :is_season  ;

EXECUTE SP_11011_D; 
IF sqlca.sqlcode <> 0 THEN
	MessageBox("SQL 오류", String(sqlca.sqlcode) + "]" + SQLCA.SQLERRTEXT) 
	Return False 
END IF

FETCH SP_11011_D INTO :ls_plan_fg, :ls_plan_fg_nm, :ls_sojae,    :ls_sojae_nm, 
                      :ls_item,    :ls_item_nm,    :ls_out_seq,
                      :ll_mod_cnt, :ld_pcs,        :ld_tag_amt,  :ld_cost_amt;

DO WHILE sqlca.sqlcode = 0 
  IF ls_imsi_fg <> ls_plan_fg OR ls_imsi_sojae <> ls_sojae OR ls_imsi_item <> ls_item THEN 
	  ll_row = dw_body.insertRow(0) 
	  ls_imsi_fg    = ls_plan_fg
	  ls_imsi_sojae = ls_sojae
	  ls_imsi_item  = ls_item 
	  ld_bf_cost    = 0 
	  dw_body.Setitem(ll_row, "plan_fg",       ls_plan_fg)
	  dw_body.Setitem(ll_row, "plan_fg_nm",    ls_plan_fg_nm)
	  dw_body.Setitem(ll_row, "plan_sojae",    ls_sojae)
	  dw_body.Setitem(ll_row, "plan_sojae_nm", ls_sojae_nm)
	  dw_body.Setitem(ll_row, "plan_item",     ls_item)
	  dw_body.Setitem(ll_row, "plan_item_nm",  ls_item_nm)
  END IF 
  i = dw_temp1.find("inter_cd = '" + ls_out_seq + "'", 1, dw_temp1.RowCount())
  IF i > 0 THEN 
	  dw_body.Setitem(ll_row, "b_mod_" + String(i), ll_mod_cnt)
	  dw_body.Setitem(ll_row, "b_pcs_" + String(i), ld_pcs)
	  dw_body.Setitem(ll_row, "b_amt_" + String(i), ld_tag_amt) 
	  ld_bf_cost = ld_bf_cost + ld_cost_amt
	  dw_body.Setitem(ll_row, "b_cost_amt", ld_bf_cost) 
  END IF 
  FETCH SP_11011_D INTO :ls_plan_fg, :ls_plan_fg_nm, :ls_sojae,   :ls_sojae_nm, 
                        :ls_item,    :ls_item_nm,    :ls_out_seq,
                        :ll_mod_cnt, :ld_pcs,        :ld_tag_amt, :ld_cost_amt;
LOOP

CLOSE SP_11011_D;

Return True

end function

public subroutine wf_outseq_set ();Long   i, ll_row 
String ls_modify

ll_row = dw_temp1.Retrieve(is_season)

IF ll_row < 1 THEN Return

FOR i = 1 TO 8 
	IF i > ll_row THEN
		ls_modify = "t_out_" + String(i) + ".text = '' " + &
		            "mod_"   + String(i) + ".visible = '0'"
	ELSE
		ls_modify = "t_out_" + String(i) + ".text = '" + dw_temp1.object.inter_nm[i] + "'" + &
		            "mod_"   + String(i) + ".visible = '1'"
	END IF
	dw_body.modify(ls_modify)
	dw_print.modify(ls_modify)
NEXT

end subroutine

public subroutine wf_plan_set ();/*----------------------------------------------------------*/
/* 전년 실적 처리                                           */
/*----------------------------------------------------------*/
Long    i, k, ll_row 
String  ls_plan_fg,  ls_sojae,      ls_item 
Decimal ldc_avg_lot, ldc_avg_price, ldc_cost_rate, ldc_mod
String ls_find 

dw_1.Retrieve(is_brand, is_year, is_season, il_plan_seq)
dw_2.Retrieve(is_brand, is_year, is_season, il_plan_seq)

// 시즌별 물량 계획 
FOR i = 1 TO dw_1.RowCount() 
	ls_plan_fg = dw_1.object.plan_fg[i]
	ls_sojae   = dw_1.object.sojae[i] 
	ls_item    = dw_1.object.item[i]
	ls_find    = "plan_fg = '" + ls_plan_fg + "' and plan_sojae = '" + ls_sojae + "' and plan_item = '" + ls_item + "'" 
	ll_row     = dw_body.find(ls_find, 1, dw_body.RowCount()) 
	IF ll_row > 0 THEN 
      ldc_avg_lot   = dw_1.GetitemDecimal(i, "avg_lot")
      ldc_avg_price = dw_1.GetitemDecimal(i, "avg_price") 
      ldc_cost_rate = dw_1.GetitemDecimal(i, "cost_rate") 
		dw_body.Setitem(ll_row, "avg_lot",   ldc_avg_lot)
		dw_body.Setitem(ll_row, "avg_price", ldc_avg_price)
		dw_body.Setitem(ll_row, "rate_1",    ldc_cost_rate)
	END IF
NEXT 

// 출고 차순별 물량 계획 
FOR i = 1 TO dw_2.RowCount()
	ls_plan_fg = dw_2.object.plan_fg[i]
	ls_sojae   = dw_2.object.sojae[i] 
	ls_item    = dw_2.object.item[i]
	ls_find    = "plan_fg = '" + ls_plan_fg + "' and plan_sojae = '" + ls_sojae + "' and plan_item = '" + ls_item + "'" 
	ll_row     = dw_body.find(ls_find, 1, dw_body.RowCount()) 
	IF ll_row > 0 THEN 
		k = dw_temp1.find("inter_cd = '" + dw_2.object.out_seq[i] + "'", 1, dw_temp1.RowCount())
		IF k > 0 THEN 
			ldc_mod = dw_2.GetitemDecimal(i, "mod_cnt")
			dw_body.Setitem(ll_row, "mod_" + String(k), ldc_mod)
		END IF
	END IF
NEXT

end subroutine

on w_11011_e.create
int iCurrent
call super::create
this.dw_temp1=create dw_temp1
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_temp1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.st_1
end on

on w_11011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_temp1)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
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
/* 수정일      : 2002.01.19                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.setredraw(False) 
dw_body.Reset()
// 출고 차순 Head Set 
wf_outseq_set()
// 전년도 실적 Set 
wf_bf_set() 
// 당해 년도 계획 Set
wf_plan_set()
dw_body.ResetUpdate()
dw_body.setredraw(True)

il_rows = 1
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")
dw_temp1.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
long     i, k, ll_row_count, ll_row
datetime ld_datetime 

String   ls_plan_fg, ls_sojae, ls_item, ls_out_seq 
String   ls_find,    ls_find_2 

int      li_loop
Long     ll_mod_cnt,   ll_avg_lot,    ll_avg_price
Decimal  ldc_plan_amt, ldc_cost_rate, ldc_cost_amt

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

li_loop = dw_temp1.RowCount() 
IF li_loop < 1 THEN Return 0 

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN	
		ls_plan_fg = dw_body.object.plan_fg[i] 
		ls_sojae   = dw_body.object.plan_sojae[i] 
		ls_item    = dw_body.object.plan_item[i] 
// 물량 계획 처리 
      ll_mod_cnt    = dw_body.GetitemNumber(i, "c_mod_tot")
		ll_avg_lot    = dw_body.GetitemNumber(i, "avg_lot")
		ll_avg_price  = dw_body.GetitemNumber(i, "avg_price")
		ldc_plan_amt  = ll_mod_cnt * ll_avg_lot * Dec(ll_avg_price)
		ldc_cost_rate = dw_body.GetitemDecimal(i, "rate_1") 
		ldc_cost_amt  = Round(ldc_plan_amt / ldc_cost_rate, 0)
      ls_find    = "plan_fg = '" + ls_plan_fg + "' and sojae = '" + ls_sojae + "' and item = '" + ls_item + "'" 
		ll_row = dw_1.find(ls_find, 1, dw_1.RowCount())  
		IF ll_row < 1 THEN 
			ll_row = dw_1.insertRow(0) 
			dw_1.Setitem(ll_row, "brand",      is_brand)
			dw_1.Setitem(ll_row, "year",       is_year)
			dw_1.Setitem(ll_row, "season",     is_season)
			dw_1.Setitem(ll_row, "plan_seq",   il_plan_seq)
			dw_1.Setitem(ll_row, "season_seq", '0')
			dw_1.Setitem(ll_row, "plan_fg",    ls_plan_fg)
			dw_1.Setitem(ll_row, "sojae",      ls_sojae)
			dw_1.Setitem(ll_row, "item",       ls_item)
         dw_1.Setitem(ll_row, "reg_id", gs_user_id)
		ELSE
         dw_1.Setitem(ll_row, "mod_id", gs_user_id)
         dw_1.Setitem(ll_row, "mod_dt", ld_datetime)
		END IF
      dw_1.Setitem(ll_row, "mod_cnt",   ll_mod_cnt)
      dw_1.Setitem(ll_row, "avg_lot",   ll_avg_lot)
      dw_1.Setitem(ll_row, "avg_price", ll_avg_price)
	   dw_1.Setitem(ll_row, "plan_amt",  ldc_plan_amt)
	   dw_1.Setitem(ll_row, "cost_rate", ldc_cost_rate)
	   dw_1.Setitem(ll_row, "cost_amt",  ldc_cost_amt)
		// 차순별 물량 계획 처리 
		FOR k = 1 TO li_loop 
         ll_mod_cnt = dw_body.GetitemNumber(i, "mod_" + String(k))
			IF isnull(ll_mod_cnt) and dw_body.GetItemStatus(i, "mod_" + String(k), Primary!) = NotModified! THEN 
				CONTINUE
			END IF 
			ls_find_2  = ls_find + " and out_seq = '" + dw_temp1.Object.inter_cd[k] + "'"
    	   ll_row = dw_2.find(ls_find_2, 1, dw_2.RowCount())  
			IF ll_row < 1 THEN
				ll_row = dw_2.insertRow(0)
		   	dw_2.Setitem(ll_row, "brand",      is_brand)
			   dw_2.Setitem(ll_row, "year",       is_year)
			   dw_2.Setitem(ll_row, "season",     is_season)
			   dw_2.Setitem(ll_row, "plan_seq",   il_plan_seq)
			   dw_2.Setitem(ll_row, "season_seq", '0')
			   dw_2.Setitem(ll_row, "plan_fg",    ls_plan_fg)
			   dw_2.Setitem(ll_row, "sojae",      ls_sojae)
			   dw_2.Setitem(ll_row, "item",       ls_item)
			   dw_2.Setitem(ll_row, "out_seq",    dw_temp1.Object.inter_cd[k])
            dw_2.Setitem(ll_row, "reg_id", gs_user_id)
			ELSE
            dw_2.Setitem(ll_row, "mod_id", gs_user_id)
            dw_2.Setitem(ll_row, "mod_dt", ld_datetime)
			END IF
         dw_2.Setitem(ll_row, "mod_cnt",   ll_mod_cnt)
	      dw_2.Setitem(ll_row, "plan_qty",  ll_mod_cnt * ll_avg_lot)
	      dw_2.Setitem(ll_row, "plan_amt",  ll_mod_cnt * ll_avg_lot * ll_avg_price)
		NEXT 
	END IF
NEXT 

il_rows = dw_1.Update(TRUE, FALSE)
if il_rows = 1 then
   il_rows = dw_2.Update(TRUE, FALSE)
end if

if il_rows = 1 then
   dw_1.ResetUpdate()
   dw_2.ResetUpdate()
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
string ls_modify, ls_datetime, ls_season

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_season = is_year + " " + idw_season.GetitemString(idw_season.GetRow(), "inter_display") 

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + & 
				"t_brand.Text = '브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_season.Text = ' 시즌 : " + ls_season + "'" + & 
				"t_plan_seq.Text = '사업계획차수 : " +  String(il_plan_seq) + "차'"
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11011_e","0")
end event

type cb_close from w_com010_e`cb_close within w_11011_e
end type

type cb_delete from w_com010_e`cb_delete within w_11011_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_11011_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_11011_e
end type

type cb_update from w_com010_e`cb_update within w_11011_e
end type

type cb_print from w_com010_e`cb_print within w_11011_e
end type

type cb_preview from w_com010_e`cb_preview within w_11011_e
end type

type gb_button from w_com010_e`gb_button within w_11011_e
end type

type cb_excel from w_com010_e`cb_excel within w_11011_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_11011_e
integer height = 176
string dataobject = "d_11011_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')

is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003',is_brand,is_year)
//idw_season.Retrieve('003')


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

SetNull(ll_seq)

CHOOSE CASE dwo.name
	CASE "brand", "year", "season"      // dddw로 작성된 항목
    This.Setitem(1,"plan_seq", ll_seq)
	 
	 //라빠레트 시즌적용
	dw_head.accepttext()

	is_brand = dw_head.getitemstring(1,'brand')
	is_year = dw_head.getitemstring(1,'year')

	this.getchild("season",idw_season)
	idw_season.settransobject(sqlca)
	idw_season.retrieve('003',is_brand,is_year)

END CHOOSE



end event

type ln_1 from w_com010_e`ln_1 within w_11011_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_11011_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_11011_e
integer y = 376
integer height = 1668
string dataobject = "d_11011_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_e`dw_print within w_11011_e
string dataobject = "d_11011_r01"
end type

type dw_temp1 from datawindow within w_11011_e
boolean visible = false
integer x = 475
integer y = 296
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_11011_d11"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_11011_e
boolean visible = false
integer x = 1335
integer y = 308
integer width = 411
integer height = 432
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_11011_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_11011_e
boolean visible = false
integer x = 1984
integer y = 320
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_11011_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_11011_e
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

