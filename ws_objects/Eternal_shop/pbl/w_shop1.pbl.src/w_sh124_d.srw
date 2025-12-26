$PBExportHeader$w_sh124_d.srw
$PBExportComments$백화점 입출내역조회
forward
global type w_sh124_d from w_com010_d
end type
end forward

global type w_sh124_d from w_com010_d
long backcolor = 16777215
end type
global w_sh124_d w_sh124_d

type variables
DataWindowChild idw_year, idw_season, idw_shop_type
String is_frm_ymd, is_to_ymd, is_shop_type, is_year, is_season
end variables

on w_sh124_d.create
call super::create
end on

on w_sh124_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_ymd", MidA(string(ld_datetime, "yyyymmdd"),1,6) + "01")
dw_head.SetItem(1, "to_ymd", string(ld_datetime, "yyyymmdd"))
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
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

il_rows = dw_body.retrieve(gs_brand, is_frm_ymd, is_to_ymd, gs_shop_cd, is_shop_type, is_year, is_season , 'V')
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_sh124_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh124_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh124_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh124_d
end type

type cb_update from w_com010_d`cb_update within w_sh124_d
end type

type cb_print from w_com010_d`cb_print within w_sh124_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh124_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh124_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh124_d
integer y = 156
integer height = 168
string dataobject = "d_sh124_h01"
end type

event dw_head::constructor;call super::constructor;string ls_year
datetime ld_datetime
DataWindowChild ldw_child 

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
idw_season.retrieve('003', gs_brand, ls_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')

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
			is_year = dw_head.getitemstring(1,'year')
			gs_brand = dw_head.getitemstring(1,'brand')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', gs_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
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

type ln_1 from w_com010_d`ln_1 within w_sh124_d
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com010_d`ln_2 within w_sh124_d
integer beginy = 336
integer endy = 336
end type

type dw_body from w_com010_d`dw_body within w_sh124_d
integer y = 344
integer width = 2857
integer height = 1444
string dataobject = "d_sh124_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_sh124_d
end type

