$PBExportHeader$w_62023_d.srw
$PBExportComments$주말판매현황
forward
global type w_62023_d from w_com010_d
end type
type dw_1 from datawindow within w_62023_d
end type
end forward

global type w_62023_d from w_com010_d
dw_1 dw_1
end type
global w_62023_d w_62023_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
String 	is_brand,is_year,is_season,is_shop_div , is_shop_type, is_week_cd, is_fr_yymmdd, is_to_yymmdd


DataWindowChild	idw_brand,	idw_season
end variables

on w_62023_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_62023_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,-3)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

IF gf_cdate(ld_datetime,1)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

dw_head.setitem(1,"brand","%")
dw_head.setitem(1,"year","%")
dw_head.setitem(1,"season","%")

dw_1.insertrow(0)
Trigger Event ue_retrieve()	//조회
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) OR is_year = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_brand		 = dw_head.GetItemString(1, "brand")
is_season	 = dw_head.GetItemString(1, "season")
is_shop_div	 = dw_head.GetItemString(1, "shop_div")
is_shop_type = dw_head.GetItemString(1, "shop_type")
is_week_cd	 = dw_head.GetItemString(1, "week_cd")

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_shop_div, is_shop_type, is_week_cd, is_fr_yymmdd, is_to_yymmdd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
	il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_shop_div, is_shop_type, is_week_cd, is_fr_yymmdd, is_to_yymmdd)
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_fr_ymd, ls_to_ymd


IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy-mm-dd hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"
dw_print.Modify(ls_modify)


end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62023_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(ln_1, "ScaleToRight")


/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)

end event

type cb_close from w_com010_d`cb_close within w_62023_d
end type

type cb_delete from w_com010_d`cb_delete within w_62023_d
end type

type cb_insert from w_com010_d`cb_insert within w_62023_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62023_d
end type

type cb_update from w_com010_d`cb_update within w_62023_d
end type

type cb_print from w_com010_d`cb_print within w_62023_d
end type

type cb_preview from w_com010_d`cb_preview within w_62023_d
end type

type gb_button from w_com010_d`gb_button within w_62023_d
end type

type cb_excel from w_com010_d`cb_excel within w_62023_d
end type

type dw_head from w_com010_d`dw_head within w_62023_d
integer y = 164
integer width = 3561
integer height = 220
string dataobject = "d_62023_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.Setitem(1, "inter_cd", "%")
idw_brand.Setitem(1, "inter_nm", "전체")

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.07                                                  */	
/* 수정일      : 2002.03.07                                                  */
/*===========================================================================*/

string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
		
//This.GetChild("sojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%', data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "sojae", "%")
//		ldw_child.Setitem(1, "sojae_nm", "전체")
//		
//	
//		This.GetChild("item", idw_item)
//		idw_item.SetTransObject(SQLCA)
//		idw_item.Retrieve(data)
//		idw_item.insertrow(1)
//		idw_item.Setitem(1, "item", "%")
//		idw_item.Setitem(1, "item_nm", "전체")		
				
		
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

type ln_1 from w_com010_d`ln_1 within w_62023_d
integer beginy = 408
integer endy = 408
end type

type ln_2 from w_com010_d`ln_2 within w_62023_d
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_d`dw_body within w_62023_d
integer x = 9
integer y = 420
integer width = 3584
integer height = 1620
string dataobject = "d_62023_d01"
boolean hscrollbar = true
end type

event dw_body::resize;call super::resize;this.object.gr_1.height = this.height - 100

dw_1.height = this.height - 100

end event

type dw_print from w_com010_d`dw_print within w_62023_d
integer x = 114
integer y = 856
integer width = 978
integer height = 288
end type

type dw_1 from datawindow within w_62023_d
integer x = 1152
integer y = 444
integer width = 1774
integer height = 1580
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_62023_d02"
boolean border = false
boolean livescroll = true
end type

