$PBExportHeader$w_sh232_d.srw
$PBExportComments$베스트판매 스타일
forward
global type w_sh232_d from w_com010_d
end type
end forward

global type w_sh232_d from w_com010_d
integer width = 2990
integer height = 2092
end type
global w_sh232_d w_sh232_d

type variables
string is_brand, is_year, is_season, is_sojae, is_item, is_yymmdd, is_out_seq, is_opt_chno
int ii_top_cnt

datawindowchild idw_brand, idw_season, idw_sojae, idw_item, idw_out_seq, idw_year

end variables

on w_sh232_d.create
call super::create
end on

on w_sh232_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	is_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
else	
	is_brand = dw_head.GetItemString(1, "brand")
	if IsNull(is_brand) or Trim(is_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

//messagebox(is_brand, gs_brand)
if gs_brand = "N" then 
	if is_brand = 'N' or is_brand = 'E' or is_brand = 'M' then
	else
		MessageBox(ls_title,"매장별 유통 브랜드가 아닙니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if	
	
elseif gs_brand = "J" then  	
	if is_brand = 'N' or is_brand = 'J' then
	else
		MessageBox(ls_title,"매장별 유통 브랜드가 아닙니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if	

elseif gs_brand = "O" or gs_brand = "D" then  
	if is_brand = 'O' or is_brand = 'D' then
	else
		MessageBox(ls_title,"매장별 유통 브랜드가 아닙니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if	

end if	


is_year    = dw_head.GetItemString(1, "year")
is_season  = dw_head.GetItemString(1, "season")
is_sojae   = dw_head.GetItemString(1, "sojae")
is_item    = dw_head.GetItemString(1, "item")
ii_top_cnt = dw_head.GetItemdecimal(1, "top_cnt")
is_yymmdd  = dw_head.GetItemString(1, "yymmdd")
is_out_seq = dw_head.GetItemString(1, "out_seq")
is_opt_chno = dw_head.GetItemString(1, "opt_chno")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_style
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_yymmdd, ii_top_cnt, is_out_seq, is_opt_chno)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_sh232_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh232_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh232_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh232_d
end type

type cb_update from w_com010_d`cb_update within w_sh232_d
end type

type cb_print from w_com010_d`cb_print within w_sh232_d
end type

type cb_preview from w_com010_d`cb_preview within w_sh232_d
end type

type gb_button from w_com010_d`gb_button within w_sh232_d
end type

type dw_head from w_com010_d`dw_head within w_sh232_d
string dataobject = "d_sh232_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild	idw_child
datetime ld_datetime
string ls_year, ls_brand_filter

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand.protect = 0
//	dw_head.object.brand_t.visible = true
//	dw_head.object.brand.visible = true
elseif MidA(gs_shop_cd_1,1,1) = 'O' or MidA(gs_shop_cd_1,1,1) = 'D' then
	dw_head.object.brand.protect = 1
//	dw_head.object.brand.backgroupcolor = 'grary'
//	dw_head.object.brand_t.visible = false
//	dw_head.object.brand.visible = false
else 
	dw_head.object.brand.protect = 0
end if


this.getchild("brand",idw_brand)
idw_brand.SetTransObject(SQLCA) 
idw_brand.retrieve('001')



// 해당 브랜드 선별작업 
String   ls_filter_str = ''	

if gs_brand = "N" then 
	ls_brand_filter = "[NEM]"
	ls_filter_str = "inter_cd = 'N' or inter_cd = 'E' or inter_cd = 'M'" 	
	
	
elseif gs_brand = "J" then  	
	ls_brand_filter = "[NJ]"	
	ls_filter_str = "inter_cd = 'N' or inter_cd = 'J' " 		
else 
	ls_filter_str = "inter_cd = '"    + gs_brand + "'" 
end if	

//
////ls_filter_str = "rtim(ltrim(inter_cd)) like '"    + ls_brand_filter + "%'" 
//
//	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 

idw_brand.SetFilter(ls_filter_str)
idw_brand.Filter( )
//
//messagebox("", ls_filter_str)

//
//String   ls_filter_str = ''	
//
//
//if gs_brand = "J"  then
//	ls_filter_str = ''	
//	ls_filter_str = "inter_cd = 'N' or  inter_cd = 'J'  "
//	idw_brand.SetFilter(ls_filter_str)
//	idw_brand.Filter( )
//end if



This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertRow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_nm", "전체")

//라빠레트 시즌적용
SELECT GetDate()
  INTO :ld_datetime
  FROM DUAL ;

GF_CURR_YEAR(ld_datetime, ls_year)

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
//idw_season.retrieve('003', gs_brand, is_year)
idw_season.retrieve('003', gs_brand, ls_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

//ls_year    = dw_head.GetItemString(1, "year")


//라빠레트소재
This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.insertRow(1)
idw_sojae.Setitem(1, "sojae", "%")
idw_sojae.Setitem(1, "sojae_nm", "전체")


//라빠레트 아이템
This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "inter_cd", '%')
idw_item.SetItem(1, "inter_nm", '전체')

this.getchild("out_seq",idw_out_seq)
idw_out_seq.SetTransObject(SQLCA) 
idw_out_seq.retrieve('010')
idw_out_seq.insertrow(1)
idw_out_seq.setitem(1,"inter_cd","%")
idw_out_seq.setitem(1,"inter_nm","전체")
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/
long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "brand", "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			
			if gs_brand_1 = "X" then
				gs_brand = dw_head.getitemstring(1,'brand')
			end if	
			
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)

			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.InsertRow(1)
			idw_item.SetItem(1, "inter_cd", '%')
			idw_item.SetItem(1, "inter_nm", '전체')		
			

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

type ln_1 from w_com010_d`ln_1 within w_sh232_d
end type

type ln_2 from w_com010_d`ln_2 within w_sh232_d
end type

type dw_body from w_com010_d`dw_body within w_sh232_d
string dataobject = "d_sh232_d01"
end type

type dw_print from w_com010_d`dw_print within w_sh232_d
end type

