$PBExportHeader$w_11013_e.srw
$PBExportComments$ITEM별 원가 계획
forward
global type w_11013_e from w_com010_e
end type
type dw_1 from datawindow within w_11013_e
end type
type st_1 from statictext within w_11013_e
end type
type st_2 from statictext within w_11013_e
end type
end forward

global type w_11013_e from w_com010_e
integer width = 5042
dw_1 dw_1
st_1 st_1
st_2 st_2
end type
global w_11013_e w_11013_e

type variables
DataWindowChild idw_brand, idw_season, idw_plan_seq
String is_brand, is_year, is_season
Long   il_plan_seq

end variables

on w_11013_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
end on

on w_11013_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.20                                                  */
/*===========================================================================*/
Long  ll_smat_rate, ll_make_rate

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, il_plan_seq)
IF il_rows > 0 THEN 
	ll_smat_rate = dw_body.GetitemNumber(1, "smat_rate")
	ll_make_rate = dw_body.GetitemNumber(1, "make_rate")
	dw_1.Setitem(1, "smat_rate", ll_smat_rate)
	dw_1.Setitem(1, "make_rate", ll_make_rate)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.20                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
String   ls_brand 
decimal	ldc_temp

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		ldc_temp = dw_body.getitemnumber(i,"mmat_amt")
		
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		IF isnull(dw_body.object.brand[i]) THEN
         dw_body.Setitem(i, "brand",      is_brand)
         dw_body.Setitem(i, "year",       is_year)
         dw_body.Setitem(i, "season",     is_season)
         dw_body.Setitem(i, "plan_seq",   il_Plan_seq)
         dw_body.Setitem(i, "season_seq", '0')
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF

   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_1, "FixedToRight")
inv_resize.of_Register(st_1, "FixedToRight") 

dw_1.insertRow(0)

end event

event ue_button;call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         dw_1.Enabled = true
      end if

   CASE 5    /* 조건 */
      dw_1.Enabled = false
END CHOOSE

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
				"t_plan_seq.Text = '사업계획차수 : " +  String(il_plan_seq) + "차'" + "'"
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11013_e","0")
end event

type cb_close from w_com010_e`cb_close within w_11013_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_11013_e
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_11013_e
boolean visible = false
integer taborder = 50
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_11013_e
end type

type cb_update from w_com010_e`cb_update within w_11013_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_11013_e
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_11013_e
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_11013_e
end type

type cb_excel from w_com010_e`cb_excel within w_11013_e
boolean visible = false
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_11013_e
integer height = 140
string dataobject = "d_11013_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(sqlca)
idw_season.Retrieve('003')

This.GetChild("plan_seq", idw_plan_seq)
idw_plan_seq.SetTransObject(sqlca)
idw_plan_seq.insertRow(0)


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
END CHOOSE

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

type ln_1 from w_com010_e`ln_1 within w_11013_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_11013_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_11013_e
event type long ue_wonga_refresh ( long as_row,  dwobject as_dwo,  string as_data )
integer y = 440
integer width = 4631
integer height = 1604
integer taborder = 40
string dataobject = "d_11013_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event type long dw_body::ue_wonga_refresh(long as_row, dwobject as_dwo, string as_data);string ls_plan_fg
decimal ldc_mmat_avgyd, ldc_t_need_qty, ldc_mmat_price, ldc_mmat_amt, ldc_smat_amt, ldc_make_amt
decimal ldc_smat_rate, ldc_make_rate, ldc_cost_amt

IF dw_1.AcceptText() <> 1 THEN RETURN -1

ls_plan_fg = this.getitemstring(as_row,'plan_fg')

ldc_mmat_avgyd = this.getitemnumber(as_row,'mmat_avgyd')
ldc_t_need_qty = this.getitemnumber(as_row,'t_need_qty')
ldc_mmat_price = this.getitemnumber(as_row,'mmat_price')
ldc_mmat_amt   = this.getitemnumber(as_row,'mmat_amt')
ldc_smat_amt   = this.getitemnumber(as_row,'smat_amt')
ldc_make_amt   = this.getitemnumber(as_row,'make_amt')
ldc_cost_amt   = this.getitemnumber(as_row,'cost_amt')

ldc_smat_rate   = dw_1.getitemnumber(1,'smat_rate')
ldc_make_rate   = dw_1.getitemnumber(1,'make_rate')

if ldc_smat_rate < 0 then return -1


choose case as_dwo.name
	case 'mmat_avgyd','mmat_price'
		
		ldc_mmat_amt = truncate(ldc_t_need_qty * ldc_mmat_price /1000,0)
		this.setitem(as_row,'mmat_amt',ldc_mmat_amt)


		if ls_plan_fg = 'W' then
			ldc_smat_amt = (ldc_cost_amt - ldc_mmat_amt) * ldc_smat_rate / 100
			if ldc_smat_amt < 0 then ldc_smat_amt = 0
			this.setitem(as_row,'smat_amt',ldc_smat_amt)
		end if
		
		ldc_make_amt = ldc_cost_amt - (ldc_mmat_amt + ldc_smat_amt)
		if ldc_make_amt < 0 then ldc_make_amt = 0
		this.setitem(as_row,'make_amt',ldc_make_amt)

		
	case 'mmat_amt'
		ldc_mmat_price = 1000 * ldc_mmat_amt / ldc_t_need_qty
		this.setitem(as_row,'mmat_price',ldc_mmat_price)

		if ls_plan_fg = 'W' then
			ldc_smat_amt = (ldc_cost_amt - ldc_mmat_amt) * ldc_smat_rate / 100
			if ldc_smat_amt < 0 then ldc_smat_amt = 0		
			this.setitem(as_row,'smat_amt',ldc_smat_amt)
		end if
		
		ldc_make_amt = ldc_cost_amt - (ldc_mmat_amt + ldc_smat_amt)
		if ldc_make_amt < 0 then ldc_make_amt = 0		
		this.setitem(as_row,'make_amt',ldc_make_amt)

	case 'smat_amt'

		ldc_make_amt = ldc_cost_amt - (ldc_mmat_amt + ldc_smat_amt)
		if ldc_make_amt < 0 then ldc_make_amt = 0		
		this.setitem(as_row,'make_amt',ldc_make_amt)

	case 'make_amt'

		ldc_smat_amt = ldc_cost_amt - (ldc_mmat_amt + ldc_make_amt)
		if ldc_smat_amt < 0 then ldc_smat_amt = 0
		this.setitem(as_row,'smat_amt',ldc_smat_amt)

end choose



return 1
end event

event dw_body::itemchanged;call super::itemchanged;post event ue_wonga_refresh(row, dwo, data)

end event

type dw_print from w_com010_e`dw_print within w_11013_e
string dataobject = "d_11013_r01"
end type

type dw_1 from datawindow within w_11013_e
event ue_keydown pbm_dwnkey
integer x = 2656
integer y = 340
integer width = 955
integer height = 92
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_11013_d00"
boolean border = false
boolean livescroll = true
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

event itemerror;Return 1
end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
Long  ll_rate, i 
decimal ldc_mmat_price
string ls_plan_fg

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "smat_rate"		
		ll_rate = Long(data) 
		i = 100 - ll_rate
		this.setitem(1,"make_rate", i)
	CASE "make_rate" 
		ll_rate = Long(data) 
		i = 100 - ll_rate
		this.setitem(1,"smat_rate", i)		

END CHOOSE

FOR i = 1 TO dw_body.RowCount() 
//			dw_body.Setitem(i, String(dwo.name), ll_rate)
	ls_plan_fg = dw_body.getitemstring(i,"plan_fg")
	if ls_plan_fg = 'W' then
		ldc_mmat_price = dw_body.GetItemNumber(i,"mmat_price")
		dw_body.post event ue_wonga_refresh(i, dw_body.object.mmat_price, string(ldc_mmat_price))
	end if
NEXT

		

end event

type st_1 from statictext within w_11013_e
integer x = 2194
integer y = 352
integer width = 448
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "원가구성비 =>"
boolean focusrectangle = false
end type

type st_2 from statictext within w_11013_e
integer x = 55
integer y = 368
integer width = 594
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
string text = "단위(천원, 단가:원)"
boolean focusrectangle = false
end type

