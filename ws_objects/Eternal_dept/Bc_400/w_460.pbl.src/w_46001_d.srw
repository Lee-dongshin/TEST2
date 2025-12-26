$PBExportHeader$w_46001_d.srw
$PBExportComments$특수부자재 스타일현황
forward
global type w_46001_d from w_com010_d
end type
end forward

global type w_46001_d from w_com010_d
integer width = 3680
integer height = 2276
end type
global w_46001_d w_46001_d

type variables
string is_brand, is_year, is_season, is_sojae, is_item
datawindowchild idw_brand, idw_season, idw_sojae, idw_item


end variables

on w_46001_d.create
call super::create
end on

on w_46001_d.destroy
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_sojae = dw_head.GetItemString(1, "sojae")
is_item = dw_head.GetItemString(1, "item")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item)
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
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = "브랜드:" + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_year.text = "년도:" + is_year
dw_print.object.t_season.text = "시즌:" + idw_season.getitemstring(idw_season.getrow(),"inter_nm")
dw_print.object.t_sojae.text = "소재:" + idw_sojae.getitemstring(idw_sojae.getrow(),"sojae_nm")
dw_print.object.t_item.text = "품종:" + idw_item.getitemstring(idw_item.getrow(),"item_nm")

end event

type cb_close from w_com010_d`cb_close within w_46001_d
end type

type cb_delete from w_com010_d`cb_delete within w_46001_d
end type

type cb_insert from w_com010_d`cb_insert within w_46001_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_46001_d
end type

type cb_update from w_com010_d`cb_update within w_46001_d
end type

type cb_print from w_com010_d`cb_print within w_46001_d
end type

type cb_preview from w_com010_d`cb_preview within w_46001_d
end type

type gb_button from w_com010_d`gb_button within w_46001_d
end type

type cb_excel from w_com010_d`cb_excel within w_46001_d
end type

type dw_head from w_com010_d`dw_head within w_46001_d
integer height = 152
string dataobject = "d_46001_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('1',is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')



end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			
			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('1',is_brand)
			idw_sojae.InsertRow(1)
			idw_sojae.SetItem(1, "sojae", '%')
			idw_sojae.SetItem(1, "sojae_nm", '전체')
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.InsertRow(1)
			idw_item.SetItem(1, "item", '%')
			idw_item.SetItem(1, "item_nm", '전체')

		
END CHOOSE
		
end event

type ln_1 from w_com010_d`ln_1 within w_46001_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_46001_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_46001_d
integer y = 376
integer height = 1660
string dataobject = "d_46001_d01"
end type

type dw_print from w_com010_d`dw_print within w_46001_d
string dataobject = "d_46001_r01"
end type

