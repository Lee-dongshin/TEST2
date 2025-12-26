$PBExportHeader$w_61052_d.srw
$PBExportComments$BEST/WORST STYLE조회
forward
global type w_61052_d from w_com010_d
end type
type rb_1 from radiobutton within w_61052_d
end type
type rb_2 from radiobutton within w_61052_d
end type
type rb_sale_rate from radiobutton within w_61052_d
end type
type rb_sale_qty from radiobutton within w_61052_d
end type
type cbx_gubn from checkbox within w_61052_d
end type
type cbx_chn from checkbox within w_61052_d
end type
type cbx_dep_fg from checkbox within w_61052_d
end type
type cbx_plan_fg from checkbox within w_61052_d
end type
type cbx_spot from checkbox within w_61052_d
end type
type cbx_bujin from checkbox within w_61052_d
end type
type cbx_halin from checkbox within w_61052_d
end type
type dw_1 from datawindow within w_61052_d
end type
type cbx_halin_exc from checkbox within w_61052_d
end type
type dw_2 from datawindow within w_61052_d
end type
type gb_1 from groupbox within w_61052_d
end type
end forward

global type w_61052_d from w_com010_d
integer width = 4407
integer height = 2216
rb_1 rb_1
rb_2 rb_2
rb_sale_rate rb_sale_rate
rb_sale_qty rb_sale_qty
cbx_gubn cbx_gubn
cbx_chn cbx_chn
cbx_dep_fg cbx_dep_fg
cbx_plan_fg cbx_plan_fg
cbx_spot cbx_spot
cbx_bujin cbx_bujin
cbx_halin cbx_halin
dw_1 dw_1
cbx_halin_exc cbx_halin_exc
dw_2 dw_2
gb_1 gb_1
end type
global w_61052_d w_61052_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_sojae, idw_item
String is_brand, is_frm_yymmdd, is_to_yymmdd, is_year, is_season, is_sojae, is_item, is_opt_orderby, is_dep_fg, is_shop_cd
string is_fr_out_ymd, is_to_out_ymd, is_plan_fg = '[^Z]', is_spot, is_bujin, is_halin, is_halin_exc
long	il_ranking, il_out_day,il_sale_qty,il_sale_rate

end variables

on w_61052_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_sale_rate=create rb_sale_rate
this.rb_sale_qty=create rb_sale_qty
this.cbx_gubn=create cbx_gubn
this.cbx_chn=create cbx_chn
this.cbx_dep_fg=create cbx_dep_fg
this.cbx_plan_fg=create cbx_plan_fg
this.cbx_spot=create cbx_spot
this.cbx_bujin=create cbx_bujin
this.cbx_halin=create cbx_halin
this.dw_1=create dw_1
this.cbx_halin_exc=create cbx_halin_exc
this.dw_2=create dw_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_sale_rate
this.Control[iCurrent+4]=this.rb_sale_qty
this.Control[iCurrent+5]=this.cbx_gubn
this.Control[iCurrent+6]=this.cbx_chn
this.Control[iCurrent+7]=this.cbx_dep_fg
this.Control[iCurrent+8]=this.cbx_plan_fg
this.Control[iCurrent+9]=this.cbx_spot
this.Control[iCurrent+10]=this.cbx_bujin
this.Control[iCurrent+11]=this.cbx_halin
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.cbx_halin_exc
this.Control[iCurrent+14]=this.dw_2
this.Control[iCurrent+15]=this.gb_1
end on

on w_61052_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_sale_rate)
destroy(this.rb_sale_qty)
destroy(this.cbx_gubn)
destroy(this.cbx_chn)
destroy(this.cbx_dep_fg)
destroy(this.cbx_plan_fg)
destroy(this.cbx_spot)
destroy(this.cbx_bujin)
destroy(this.cbx_halin)
destroy(this.dw_1)
destroy(this.cbx_halin_exc)
destroy(this.dw_2)
destroy(this.gb_1)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55021_d","0")
end event

event open;call super::open;datetime ld_datetime
string ls_fr_yymmdd

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF


select convert(char(08), dateadd(day, -1, getdate()),112)
into :ls_fr_yymmdd
from dual;

//dw_head.SetItem(1, "frm_yymmdd" , mid(string(ld_datetime,"yyyymmdd"),1,6) + "01" )
dw_head.SetItem(1, "frm_yymmdd" , ls_fr_yymmdd )
dw_head.SetItem(1, "to_yymmdd" , string(ld_datetime,"yyyymmdd"))

dw_head.SetItem(1, "season" , "%" )

if gs_user_id = 'PURITA' then 
	dw_head.Modify("brand.Protect=1")
end if 
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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

is_frm_yymmdd = dw_head.GetItemString(1, "frm_yymmdd")
if IsNull(is_frm_yymmdd) or Trim(is_frm_yymmdd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"마지막일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

il_ranking= dw_head.GetItemDecimal(1, "ranking")
if IsNull(il_ranking) or il_ranking = 0 then
   MessageBox(ls_title,"순위를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ranking")
   return false
end if

if rb_2.checked = true then 
	il_out_day = dw_head.GetItemDecimal(1, "out_day")
	if IsNull(il_out_day) or il_out_day = 0 then
		MessageBox(ls_title,"출고일수를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("out_day")
		return false
	end if
	
	il_sale_qty= dw_head.GetItemDecimal(1, "sale_qty")
	if IsNull(il_sale_qty) or il_sale_qty = 0 then
		MessageBox(ls_title,"일평균판매량을 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("sale_qty")
		return false
	end if
	
	il_sale_rate= dw_head.GetItemDecimal(1, "sale_rate")
	if IsNull(il_sale_rate) or il_sale_rate = 0 then
		MessageBox(ls_title,"판매율을 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("sale_rate")
		return false
	end if
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")

is_fr_out_ymd = dw_head.GetItemString(1, "fr_out_ymd")
is_to_out_ymd = dw_head.GetItemString(1, "to_out_ymd")

if cbx_dep_fg.checked then
	is_dep_fg = 'Y'
else
	setnull(is_dep_fg)
end if

if rb_sale_rate.checked then
	is_opt_orderby = '0'
else
	is_opt_orderby = '1'
end if


if cbx_plan_fg.checked then
	is_plan_fg = '%'
else
	is_plan_fg = '[^Z]'
end if

if cbx_spot.checked then
	is_spot='1'
else 
	is_spot='0'
end if

if cbx_bujin.checked then
	is_bujin='1'
else 
	is_bujin='0'
end if

if cbx_halin.checked then
	is_halin='1'
else 
	is_halin='0'
end if

if cbx_halin_exc.checked then
	is_halin_exc ='1'
else 
	is_halin_exc ='0'
end if





return true

end event

event ue_retrieve();call super::ue_retrieve;integer ii,jj
long ll_row
String ls_file_name, ls_style, ls_color

String ls_ErrMsg
Long   ll_sqlcode

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//messagebox('body',string(dw_body.DataObject))
//messagebox('print',string(dw_print.DataObject))
//
//	messagebox("is_brand",is_brand)
//	messagebox("is_year",is_year)
//	messagebox("is_season",is_season)
//	messagebox("is_sojae",is_sojae)
//	messagebox("is_item",is_item)
//	messagebox("il_out_day",il_out_day)
//	messagebox("il_sale_qty",il_sale_qty)
//	messagebox("il_sale_rate",il_sale_rate)
//	messagebox("il_ranking",il_ranking)
//	messagebox("is_opt_orderby",is_opt_orderby)
//	messagebox("is_shop_cd",is_shop_cd)
//	messagebox("is_frm_yymmdd",is_fr_out_ymd)
//	messagebox("is_to_yymmdd",is_to_out_ymd)
//	messagebox("is_plan_fg",is_plan_fg)
//	messagebox("is_spot",is_spot)
//	messagebox("is_bujin",is_bujin)
//	messagebox("is_halin",is_halin)
//return	

//messagebox("",string(dw_body.dataobject))
//return
if rb_1.checked  then
	il_rows = dw_body.retrieve(is_brand, is_year, is_season,is_sojae,is_item,is_frm_yymmdd, is_to_yymmdd,il_ranking, is_opt_orderby, is_dep_fg, is_shop_cd, is_fr_out_ymd, is_to_out_ymd, is_plan_fg, is_spot, is_bujin, is_halin, is_halin_exc )
elseif rb_2.checked then 
	il_rows = dw_body.retrieve(is_brand, is_year, is_season,is_sojae,is_item,il_out_day,il_sale_qty,il_sale_rate,il_ranking, is_opt_orderby, is_shop_cd, is_fr_out_ymd, is_to_out_ymd, is_plan_fg, is_spot, is_bujin, is_halin, is_frm_yymmdd, is_to_yymmdd, is_dep_fg, is_halin_exc)
end if



dw_body.object.t_frm_yymmdd.text = is_frm_yymmdd
dw_body.object.t_to_yymmdd.text = is_to_yymmdd
dw_body.object.t_season.text = '시즌:' + is_year + is_season +' '+ idw_season.getitemstring(idw_season.getrow(),"inter_nm")
dw_body.object.t_shop_cd.text = '매장:' + is_shop_cd + ' ' + dw_head.getitemstring(1,"shop_nm")

if is_spot ='1' then 
	dw_body.object.t_gubn.text = '구분: 스팟'
elseif is_bujin='1' then 
	dw_body.object.t_gubn.text = '구분: 부진행사'
elseif is_halin='1' then 
	dw_body.object.t_gubn.text = '구분: 품목할인'
end if

IF il_rows > 0 THEN

for jj = 1 to 	il_rows
	// 사진이 없는 경우 있는 칼라를 찾아 사진 보이도록 작업
//	ls_file_name = dw_body.getitemstring(jj,"style_pic")
	ls_style     = dw_body.getitemstring(jj,"style")
	
//	if FileExists(ls_file_name) = false then 
		
		dw_1.retrieve(ls_style)
		ll_row = dw_1.RowCount()
		
		for ii = 1 to ll_row
			 ls_color = dw_1.getitemstring(ii, "color")
			 
			 select dbo.SF_PIC_COLOR_DIR(:ls_style +'%',:ls_color)
			 into :ls_file_name
			 from dual ;
			 
			 if FileExists(ls_file_name) then
				goto NextStep
			 end if
	
		next
		
		NextStep:
		dw_body.setitem(jj,"style_pic", ls_file_name)
		
//end if	
next	
   dw_body.SetFocus()
	//베스트 컬러별 계산
if rb_1.checked = true and is_brand = 'L' then
	if cbx_gubn.checked = true then
		DECLARE SP_55021_c11 PROCEDURE FOR SP_55021_c11 
					@brand			= :is_brand,   
					@year				= :is_year,
					@season			= :is_season,
					@sojae			= :is_sojae,
					@item				= :is_item,
					@from_ymd		= :is_frm_yymmdd,
					@to_ymd			= :is_to_yymmdd,
					@pdc_ranking	= :il_ranking,
					@opt_orderby	= :is_opt_orderby,
					@dep_fg			= :is_dep_fg,
					@shop_cd			= :is_shop_cd,
					@fr_out_ymd		= :is_fr_out_ymd,
					@to_out_ymd		= :is_to_out_ymd,
					@plan_fg			= :is_plan_fg,
					@spot_fg			= :is_spot,
					@bujin_fg		= :is_bujin,
					@halin_fg		= :is_halin,
					@halin_exc_fg	= :is_halin_exc
					;	
		EXECUTE SP_55021_c11;

	end if
	//워스트 컬러별 계산
elseif rb_2.checked = true and is_brand = 'L' then
	if cbx_gubn.checked = true then
		DECLARE SP_55021_c13 PROCEDURE FOR SP_55021_c13 
					@brand			= :is_brand,   
					@year				= :is_year,
					@season			= :is_season,
					@sojae			= :is_sojae,
					@item				= :is_item,
					@out_day			= :il_out_day,
					@sale_qty		= :il_sale_qty,
					@sale_rate		= :il_sale_rate,
					@pdc_ranking	= :il_ranking,
					@opt_orderby	= :is_opt_orderby,
					@shop_cd			= :is_shop_cd,
					@fr_out_ymd		= :is_frm_yymmdd,
					@to_out_ymd		= :is_to_yymmdd,
					@plan_fg			= :is_plan_fg,
					@spot_fg			= :is_spot,
					@bujin_fg		= :is_bujin,
					@halin_fg		= :is_halin,
					@from_ymd		= :is_fr_out_ymd,
					@to_ymd			= :is_to_out_ymd,
					@dep_fg			= :is_dep_fg,
					@halin_exc_fg	= :is_halin_exc
					;	
		EXECUTE SP_55021_c13;
		

	end if
end if

if SQLCA.SQLCODE = 0  OR SQLCA.SQLCODE = 100 then
	commit  USING SQLCA;
	il_rows = 1 
else 
	ll_sqlcode = SQLCA.SQLCODE
	ls_ErrMsg  = SQLCA.SQLErrText 
	rollback  USING SQLCA; 
	MessageBox("SQL 오류", "[" + String(ll_sqlcode) + "]" + ls_ErrMsg) 
end if

ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_chno_gubun, ls_gubun

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_frm_yymmdd.Text   = '" + is_frm_yymmdd  + "'" + &
            "t_to_yymmdd.Text    = '" + is_to_yymmdd   + "'" 	
		
           
dw_print.Modify(ls_modify)

dw_print.object.t_season.text = '시즌:' + is_year + is_season + idw_season.getitemstring(idw_season.getrow(),"inter_nm")
dw_print.object.t_shop_cd.text = '매장:' + is_shop_cd + ' ' + dw_head.getitemstring(1,"shop_nm")

if is_spot ='1' then 
	dw_print.object.t_gubn.text = '구분: 스팟'
elseif is_bujin='1' then 
	dw_print.object.t_gubn.text = '구분: 부진행사'
elseif is_halin='1' then 
	dw_print.object.t_gubn.text = '구분: 품목할인'
end if
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		ls_brand = Trim(dw_head.GetItemString(1, "brand"))
		ls_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 

				If ls_shop_div <> '%' Then
					If MidA(as_data, 2, 1) <> ls_shop_div Then
						MessageBox("입력오류", "유통망이 다릅니다!")
						dw_head.SetItem(al_row, "shop_cd", "")
						dw_head.SetItem(al_row, "shop_nm", "")
						Return 1
					End If
				End If
					
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' " + &
											 "  AND SHOP_STAT = '00' "
											 
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */

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

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
integer ii,jj
long ll_row
String ls_file_name, ls_style, ls_color

This.Trigger Event ue_title ()

if cbx_gubn.checked then
	
//	if rb_1.checked  then
//		il_rows = dw_print.retrieve(is_brand, is_year, is_season,is_sojae,is_item,is_frm_yymmdd, is_to_yymmdd,il_ranking, is_opt_orderby, is_dep_fg, is_shop_cd, is_fr_out_ymd, is_to_out_ymd, is_plan_fg, is_spot, is_bujin, is_halin )
//	elseif rb_2.checked then 
//		il_rows = dw_print.retrieve(is_brand, is_year, is_season,is_sojae,is_item,il_out_day,il_sale_qty,il_sale_rate,il_ranking, is_opt_orderby, is_shop_cd, is_fr_out_ymd, is_to_out_ymd, is_plan_fg, is_spot, is_bujin, is_halin, is_frm_yymmdd, is_to_yymmdd, is_dep_fg)
//	end if
	
	if rb_1.checked  then
	il_rows = dw_print.retrieve(is_brand, is_year, is_season,is_sojae,is_item,is_frm_yymmdd, is_to_yymmdd,il_ranking, is_opt_orderby, is_dep_fg, is_shop_cd, is_fr_out_ymd, is_to_out_ymd, is_plan_fg, is_spot, is_bujin, is_halin, is_halin_exc )
	elseif rb_2.checked then 
	il_rows = dw_print.retrieve(is_brand, is_year, is_season,is_sojae,is_item,il_out_day,il_sale_qty,il_sale_rate,il_ranking, is_opt_orderby, is_shop_cd, is_fr_out_ymd, is_to_out_ymd, is_plan_fg, is_spot, is_bujin, is_halin, is_frm_yymmdd, is_to_yymmdd, is_dep_fg, is_halin_exc)
	end if
	
	for jj = 1 to 	il_rows
		// 사진이 없는 경우 있는 칼라를 찾아 사진 보이도록 작업
	//	ls_file_name = dw_print.getitemstring(jj,"style_pic")
		ls_style     = dw_print.getitemstring(jj,"style")
		
//		if FileExists(ls_file_name) = false then 
			
			dw_1.retrieve(ls_style)
			ll_row = dw_1.RowCount()
			
			for ii = 1 to ll_row
				 ls_color = dw_1.getitemstring(ii, "color")
				 
				 select dbo.SF_PIC_COLOR_DIR(:ls_style +'%',:ls_color)
				 into :ls_file_name
				 from dual ;
				 
				 if FileExists(ls_file_name) then
					goto NextStep
				 end if
		
			next
			
			NextStep:
			dw_print.setitem(jj,"style_pic", ls_file_name)
			
//		end if	
	next		
	
	
else
	dw_body.ShareData(dw_print)
end if

dw_print.inv_printpreview.of_SetZoom()





end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)

dw_2.SetTransObject(SQLCA)
end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

//dw_body.ShareData(dw_print)

IF dw_body.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_body.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_excel();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm, ls_ErrMsg
long ll_sqlcode
integer li_ret
boolean lb_exist
Pointer Old_pointer

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
if cbx_gubn.checked then

	dw_2.retrieve()
	
	li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
else
	li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
end if

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_61052_d
integer taborder = 110
end type

type cb_delete from w_com010_d`cb_delete within w_61052_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_61052_d
integer taborder = 50
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61052_d
end type

type cb_update from w_com010_d`cb_update within w_61052_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_61052_d
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_61052_d
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_61052_d
end type

type cb_excel from w_com010_d`cb_excel within w_61052_d
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_61052_d
integer x = 0
integer y = 160
integer width = 4329
integer height = 288
string dataobject = "d_55021_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


//This.GetChild("year", idw_year )
//idw_year.SetTransObject(SQLCA)
//idw_year.Retrieve('002')
//idw_year.SetItem(1, "inter_cd", '%')
//idw_year.SetItem(1, "inter_nm", '전체')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '[^X]')
idw_sojae.SetItem(1, "sojae_nm", '악세사리제외')
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve( gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	   This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.InsertRow(1)
		idw_sojae.SetItem(1, "sojae", '[^X]')
		idw_sojae.SetItem(1, "sojae_nm", '악세사리제외')
		idw_sojae.InsertRow(1)
		idw_sojae.SetItem(1, "sojae", '%')
		idw_sojae.SetItem(1, "sojae_nm", '전체')
		
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
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

type ln_1 from w_com010_d`ln_1 within w_61052_d
integer beginy = 452
integer endx = 4357
integer endy = 452
end type

type ln_2 from w_com010_d`ln_2 within w_61052_d
integer beginy = 456
integer endx = 4357
integer endy = 456
end type

type dw_body from w_com010_d`dw_body within w_61052_d
integer x = 9
integer width = 4347
integer height = 1544
integer taborder = 40
string dataobject = "d_55021_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style_1'
			ls_search 	= this.GetItemString(row,'style_1')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')		
		case 'style_2'
			ls_search 	= this.GetItemString(row,'style_2')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')		
		case 'style_3'
			ls_search 	= this.GetItemString(row,'style_3')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			
		case 'style_4'
			ls_search 	= this.GetItemString(row,'style_4')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			
		case 'style_5'
			ls_search 	= this.GetItemString(row,'style_5')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			

		case 'style_pic_1'
			ls_search 	= this.GetItemString(row,'style_1')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			
		case 'style_pic_2'
			ls_search 	= this.GetItemString(row,'style_2')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')		
		case 'style_pic_3'
			ls_search 	= this.GetItemString(row,'style_3')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			
		case 'style_pic_4'
			ls_search 	= this.GetItemString(row,'style_4')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')		
		case 'style_pic_5'
			ls_search 	= this.GetItemString(row,'style_5')
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')					
	end choose	
end if

end event

type dw_print from w_com010_d`dw_print within w_61052_d
integer x = 2368
integer y = 1628
string dataobject = "d_55021_d01"
end type

type rb_1 from radiobutton within w_61052_d
integer x = 2839
integer y = 324
integer width = 393
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "Best Style"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor      = RGB(0, 0, 255)
rb_2.TextColor  = RGB(0, 0, 0)

if cbx_gubn.checked then

	dw_body.DataObject  = 'd_55021_r01'
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = 'd_55021_r01'
	dw_print.SetTransObject(SQLCA)

else

	dw_body.DataObject  = 'd_55021_d01'
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = 'd_55021_d01'
	dw_print.SetTransObject(SQLCA)

end if

end event

type rb_2 from radiobutton within w_61052_d
integer x = 2839
integer y = 392
integer width = 393
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
string text = "Worst Style"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor  = RGB(0, 0, 255)
rb_1.TextColor  = RGB(0, 0, 0)

if cbx_gubn.checked then

	dw_body.DataObject  = 'd_55021_r03'
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = 'd_55021_r03'
	dw_print.SetTransObject(SQLCA)

else

	dw_body.DataObject  = 'd_55021_d03'
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = 'd_55021_d03'
	dw_print.SetTransObject(SQLCA)

end if


end event

type rb_sale_rate from radiobutton within w_61052_d
integer x = 1047
integer y = 248
integer width = 325
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
string text = "판매율순"
borderstyle borderstyle = stylelowered!
end type

type rb_sale_qty from radiobutton within w_61052_d
integer x = 1371
integer y = 248
integer width = 325
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
string text = "판매량순"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_gubn from checkbox within w_61052_d
integer x = 3273
integer y = 332
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "칼라별보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	
	Messagebox("알림!", "시스템설정에 용지를 A4에 가로로 변경하시고 조회하세요!")
	
	if cbx_chn.checked then
		if rb_1.checked then
			dw_body.DataObject = 'd_55021_rc01'
			dw_body.SetTransObject(SQLCA)


			dw_print.DataObject = 'd_55021_rc01'
			dw_print.SetTransObject(SQLCA)	
		else
			dw_body.DataObject = 'd_55021_rc03'
			dw_body.SetTransObject(SQLCA)

			dw_print.DataObject = 'd_55021_rc03'
			dw_print.SetTransObject(SQLCA)	
			
		end if
	else
		if rb_1.checked then
			dw_body.DataObject = 'd_55021_r01'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_r01'
			dw_print.SetTransObject(SQLCA)	
		else
			dw_body.DataObject = 'd_55021_r03'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_r03'
			dw_print.SetTransObject(SQLCA)	
			
		end if		
	end if
else
	if cbx_chn.checked then
		if rb_1.checked then
			dw_body.DataObject = 'd_55021_c01'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_c01'
			dw_print.SetTransObject(SQLCA)		
		else
			dw_body.DataObject = 'd_55021_c03'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_c03'
			dw_print.SetTransObject(SQLCA)		
	
		end if
	else
		if rb_1.checked then
			dw_body.DataObject = 'd_55021_d01'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_d01'
			dw_print.SetTransObject(SQLCA)		
		else
			dw_body.DataObject = 'd_55021_d03'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_d03'
			dw_print.SetTransObject(SQLCA)		
	
		end if		
	end if
	
end if

dw_body.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

end event

type cbx_chn from checkbox within w_61052_d
boolean visible = false
integer x = 3237
integer y = 372
integer width = 288
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
string text = "중국용"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	if cbx_gubn.checked then
		if rb_1.checked then
			dw_body.DataObject = 'd_55021_rc01'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_rc01'
			dw_print.SetTransObject(SQLCA)	
		else
			dw_body.DataObject = 'd_55021_rc03'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_rc03'
			dw_print.SetTransObject(SQLCA)	
			
		end if
	else
		if rb_1.checked then
			dw_body.DataObject = 'd_55021_c01'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_c01'
			dw_print.SetTransObject(SQLCA)	
		else
			dw_body.DataObject = 'd_55021_c03'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_c03'
			dw_print.SetTransObject(SQLCA)	
			
		end if		
	end if
else
	if cbx_gubn.checked then
		if rb_1.checked then
			dw_body.DataObject = 'd_55021_r01'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_r01'
			dw_print.SetTransObject(SQLCA)		
		else
			dw_body.DataObject = 'd_55021_r03'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_r03'
			dw_print.SetTransObject(SQLCA)		
	
		end if
	else
		if rb_1.checked then
			dw_body.DataObject = 'd_55021_d01'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_d01'
			dw_print.SetTransObject(SQLCA)		
		else
			dw_body.DataObject = 'd_55021_d03'
			dw_body.SetTransObject(SQLCA)
			dw_print.DataObject = 'd_55021_d03'
			dw_print.SetTransObject(SQLCA)		
	
		end if		
	end if
	
end if

end event

type cbx_dep_fg from checkbox within w_61052_d
integer x = 1714
integer y = 248
integer width = 320
integer height = 60
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "부진제외"
borderstyle borderstyle = stylelowered!
end type

type cbx_plan_fg from checkbox within w_61052_d
integer x = 3273
integer y = 392
integer width = 334
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
string text = "기획포함"
borderstyle borderstyle = stylelowered!
end type

type cbx_spot from checkbox within w_61052_d
integer x = 3918
integer y = 168
integer width = 338
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
string text = "스 팟"
borderstyle borderstyle = stylelowered!
end type

type cbx_bujin from checkbox within w_61052_d
integer x = 3918
integer y = 224
integer width = 338
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
string text = "부진행사"
borderstyle borderstyle = stylelowered!
end type

type cbx_halin from checkbox within w_61052_d
integer x = 3918
integer y = 280
integer width = 338
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
string text = "품목할인"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked and cbx_halin_exc.checked then
		cbx_halin_exc.checked = false
end if
	
end event

type dw_1 from datawindow within w_61052_d
boolean visible = false
integer x = 2793
integer y = 556
integer width = 411
integer height = 432
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_55021_color"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_halin_exc from checkbox within w_61052_d
integer x = 3918
integer y = 340
integer width = 411
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
string text = "품목할인제외"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked and cbx_halin.checked then
		cbx_halin.checked = false
end if
end event

type dw_2 from datawindow within w_61052_d
boolean visible = false
integer x = 1641
integer y = 548
integer width = 2313
integer height = 840
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_55021_d11"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_61052_d
boolean visible = false
integer x = 2793
integer y = 272
integer width = 480
integer height = 160
integer taborder = 130
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

