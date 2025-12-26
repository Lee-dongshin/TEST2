$PBExportHeader$w_sh123_e.srw
$PBExportComments$백화점 입출KEY입력
forward
global type w_sh123_e from w_com010_e
end type
type dw_db from datawindow within w_sh123_e
end type
type st_1 from statictext within w_sh123_e
end type
type cbx_1 from checkbox within w_sh123_e
end type
end forward

global type w_sh123_e from w_com010_e
integer width = 2976
integer height = 2048
dw_db dw_db
st_1 st_1
cbx_1 cbx_1
end type
global w_sh123_e w_sh123_e

type variables
DataWindowChild	idw_year, idw_season, idw_shop_type
String	is_year, is_season, is_frm_ymd, is_to_ymd, is_shop_type
end variables

on w_sh123_e.create
int iCurrent
call super::create
this.dw_db=create dw_db
this.st_1=create st_1
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_db
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_1
end on

on w_sh123_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_db)
destroy(this.st_1)
destroy(this.cbx_1)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_ymd", MidA(string(ld_datetime, "yyyymmdd"),1,6) + "01")
dw_head.SetItem(1, "to_ymd", string(ld_datetime, "yyyymmdd"))

if gs_shop_cd = 'BK1700' or gs_shop_cd = 'BK1704' or gs_shop_cd = 'TB1004' then
	cbx_1.visible = true
else
	cbx_1.visible = false
end if
end event

event pfc_preopen();call super::pfc_preopen;dw_db.SetTransObject(SQLCA)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
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

//if mid(gs_shop_cd,3,4) = '2000' and  then
//	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
//	return false
//end if	
//

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"종료일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

// exec SP_sh123_D01 'n','20021201' ,'20021231','ng0006','1','2002','w', 's'

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_brand, is_frm_ymd, is_to_ymd, gs_shop_cd, is_shop_type, '%', '%', 'S')
IF il_rows > 0 THEN
	dw_db.retrieve(is_frm_ymd, is_to_ymd, gs_shop_cd, is_shop_type)	
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_dbrow_cnt, ll_find, ll_rows
datetime ld_datetime
String ls_shop_cd, ls_yymmdd, ls_find
long ll_out_qty, ll_out_amt, ll_rtrn_qty, ll_rtrn_amt
integer K

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_dbrow_cnt = dw_db.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! OR idw_status = DataModified! THEN	
		ls_yymmdd  = dw_body.GetitemString(i, "yymmdd")
		ll_out_amt = dw_body.GetitemNumber(i, "out_amt")
		ll_out_qty = dw_body.GetitemNumber(i, "out_qty")		
		ll_rtrn_amt = dw_body.GetitemNumber(i, "rtrn_amt")
		ll_rtrn_qty = dw_body.GetitemNumber(i, "rtrn_qty")				

		ls_find  = "yymmdd =  '" + ls_yymmdd + "'  and shop_cd = '" + gs_shop_cd + "' and shop_type = '" + is_shop_type + "' "
		ll_find = dw_db.find(ls_find, 1, ll_dbrow_cnt)

			IF ll_find > 0 THEN
				dw_db.Setitem(ll_find, "out_qty",  ll_out_qty)
				dw_db.Setitem(ll_find, "out_amt",  ll_out_amt)				
				dw_db.Setitem(ll_find, "rtrn_qty",  ll_rtrn_qty)
				dw_db.Setitem(ll_find, "rtrn_amt",  ll_rtrn_amt)								
				dw_db.Setitem(ll_find, "mod_id",   gs_user_id)
				dw_db.Setitem(ll_find, "mod_dt",   ld_datetime)
			ELSE
				ll_find = dw_db.insertRow(0)
				dw_db.Setitem(ll_find, "yymmdd",    ls_yymmdd)				
				dw_db.Setitem(ll_find, "shop_cd",   gs_shop_cd)								
				dw_db.Setitem(ll_find, "shop_type", is_shop_type)												
				dw_db.Setitem(ll_find, "out_qty",   ll_out_qty)
				dw_db.Setitem(ll_find, "out_amt",   ll_out_amt)				
				dw_db.Setitem(ll_find, "rtrn_qty",  ll_rtrn_qty)
				dw_db.Setitem(ll_find, "rtrn_amt",  ll_rtrn_amt)								
				dw_db.Setitem(ll_find, "brand",     gs_brand)												
				dw_db.Setitem(ll_find, "shop_div",  gs_shop_div)																
				dw_db.Setitem(ll_find, "reg_id",    gs_user_id)
			END IF
	END IF
NEXT

		
il_rows = dw_db.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_db.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows


end event

type cb_close from w_com010_e`cb_close within w_sh123_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh123_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh123_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh123_e
end type

type cb_update from w_com010_e`cb_update within w_sh123_e
end type

type cb_print from w_com010_e`cb_print within w_sh123_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh123_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh123_e
end type

type dw_head from w_com010_e`dw_head within w_sh123_e
integer x = 27
integer y = 160
integer width = 1760
integer height = 160
string dataobject = "d_sh123_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertRow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_nm", "전체")

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertRow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')

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


end event

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
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
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

type ln_1 from w_com010_e`ln_1 within w_sh123_e
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_e`ln_2 within w_sh123_e
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_e`dw_body within w_sh123_e
integer y = 340
integer height = 1460
string dataobject = "d_sh123_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_e`dw_print within w_sh123_e
end type

type dw_db from datawindow within w_sh123_e
boolean visible = false
integer x = 14
integer y = 956
integer width = 2482
integer height = 624
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sh123_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sh123_e
integer x = 1865
integer y = 240
integer width = 1010
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "부가세 포함된 출고가를 입력 하세요"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_sh123_e
boolean visible = false
integer x = 1874
integer y = 168
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "자동입력"
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_row_cnt, ll_rows
datetime ld_datetime
long ll_nout_qty, ll_nout_amt, ll_nrtrn_qty, ll_nrtrn_amt


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	ll_nout_amt = dw_body.GetitemNumber(i, "nout_tagamt")
	ll_nout_qty = dw_body.GetitemNumber(i, "nout_qty")
	ll_nrtrn_amt = dw_body.GetitemNumber(i, "nrtrn_tagamt")
	ll_nrtrn_qty = dw_body.GetitemNumber(i, "nrtrn_qty")
		
	if cbx_1.checked = true then	
		dw_body.Setitem(i, "out_qty",  ll_nout_qty)
		dw_body.Setitem(i, "out_amt",  ll_nout_amt)				
		dw_body.Setitem(i, "rtrn_qty",  ll_nrtrn_qty)
		dw_body.Setitem(i, "rtrn_amt",  ll_nrtrn_amt)
	else
		dw_body.Setitem(i, "out_qty",  0)
		dw_body.Setitem(i, "out_amt",  0)
		dw_body.Setitem(i, "rtrn_qty",  0)
		dw_body.Setitem(i, "rtrn_amt",  0)
	end if
NEXT

cb_update.enabled = true

end event

