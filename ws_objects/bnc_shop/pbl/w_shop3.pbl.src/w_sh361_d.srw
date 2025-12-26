$PBExportHeader$w_sh361_d.srw
$PBExportComments$부진재고조회
forward
global type w_sh361_d from w_com010_d
end type
end forward

global type w_sh361_d from w_com010_d
end type
global w_sh361_d w_sh361_d

type variables

Datawindowchild idw_dep_seq

String  is_year,    is_season,       is_dep_seq
String is_yymmdd, is_shop_type  


end variables

on w_sh361_d.create
call super::create
end on

on w_sh361_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.04.01                                                  */
/*===========================================================================*/
String   ls_title
int net



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

is_dep_seq = dw_head.GetItemString(1, "dep_seq")
if IsNull(is_dep_seq) or Trim(is_dep_seq) = "" then
   MessageBox(ls_title,"부진 차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_seq")
   return false
end if

is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")


is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장 형태 코드를 입력하십시요!")
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

Return true
end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

dw_body.DataObject = "d_sh361_d01"
dw_print.DataObject = "d_sh361_r01"	

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


il_rows = dw_body.retrieve(is_yymmdd,gs_shop_cd, is_shop_type, gs_brand, is_year, is_season, is_dep_seq)

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

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      :                                              */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime
string ls_season, ls_shop_type, ls_dep_seq

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

// 인쇄 DW에 출력될 내부코드명 by 김종길//////////////////////////////////////////

// ls_season
select inter_cd+' '+inter_nm
into :ls_season
from TB_91011_C (nolock)
where INTER_GRP = '003'
and inter_cd = :is_season;

// ls_shop_type
select inter_cd+' '+inter_nm
into :ls_shop_type
from TB_91011_C (nolock)
where INTER_GRP = '009'
and inter_cd = :is_shop_type;

// ls_dep_seq
select distinct dep_seq+' '+dep_ymd 
into :ls_dep_seq
from  tb_12020_m   with (nolock)
		 where  brand  =  :gs_brand
		   and  year   =  :is_year
		   and  season =  :is_season
		   and  dep_seq = :is_dep_seq
		   and  dep_fg = 'y' ;

///////////////////////////////////////////////////////////////////////



ls_modify =	"t_yymmdd.Text = '" + is_yymmdd + "'" + &
             "t_season.Text = '" + ls_season + "'" + &
             "t_dep_seq.Text = '" + ls_dep_seq + "'" + &
             "t_shop_type.Text = '" + ls_shop_type + "'" 

		
dw_print.Modify(ls_modify)
end event

type cb_close from w_com010_d`cb_close within w_sh361_d
integer taborder = 90
end type

type cb_delete from w_com010_d`cb_delete within w_sh361_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh361_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh361_d
end type

type cb_update from w_com010_d`cb_update within w_sh361_d
integer taborder = 80
end type

type cb_print from w_com010_d`cb_print within w_sh361_d
end type

type cb_preview from w_com010_d`cb_preview within w_sh361_d
end type

type gb_button from w_com010_d`gb_button within w_sh361_d
integer x = 5
end type

type dw_head from w_com010_d`dw_head within w_sh361_d
integer x = 5
integer y = 180
integer width = 2880
integer height = 204
string dataobject = "d_sh361_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child
string ls_year
datetime ld_datetime

//라빠레트 시즌적용
SELECT GetDate()
  INTO :ld_datetime
  FROM DUAL ;

GF_CURR_YEAR(ld_datetime, ls_year)

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

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', gs_brand, ls_year)
//idw_season.retrieve('003')

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTransObject(SQLCA)

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

end event

event dw_head::itemchanged;call super::itemchanged;String ls_null, ls_yymmdd
long ll_b_cnt

SetNull(ls_null)
DataWindowChild ldw_child

//라빠레트 시즌적용
dw_head.accepttext()
gs_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', gs_brand, is_year)
//idw_season.retrieve('003')

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
			
	CASE "year", "season"
		This.Setitem(1, "dep_seq", ls_null)
		
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', gs_brand, is_year)
		//idw_season.retrieve('003')
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
		
	
END CHOOSE

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_brand, ls_year, ls_season 

CHOOSE CASE dwo.name
	CASE "dep_seq"
		  ls_year    = This.GetitemString(1, "year") 
		  ls_season  = This.GetitemString(1, "season") 
		  if gs_brand_1 = 'X' then
	        gs_brand = dw_head.getitemstring(1,'brand')
		  end if
        idw_dep_seq.Retrieve(gs_brand, ls_year, ls_season)
		  
		//  messagebox(gs_brand, ls_year + ls_season )
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_sh361_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_sh361_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_sh361_d
integer y = 404
integer width = 2857
integer height = 1384
string dataobject = "d_sh361_d01"
end type

type dw_print from w_com010_d`dw_print within w_sh361_d
string dataobject = "d_sh361_r01"
end type

