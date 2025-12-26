$PBExportHeader$w_31028_d.srw
$PBExportComments$전년대비 시즌별 투입현황
forward
global type w_31028_d from w_com010_d
end type
end forward

global type w_31028_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_31028_d w_31028_d

type variables
string is_brand, is_fr_year, is_to_year, is_fr_season, is_to_season, is_to_ymd
datawindowchild idw_brand, idw_fr_season, idw_to_season


end variables

on w_31028_d.create
call super::create
end on

on w_31028_d.destroy
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

is_fr_year   = dw_head.GetItemString(1, "fr_year")
is_fr_season = dw_head.GetItemString(1, "fr_season")
is_to_year   = dw_head.GetItemString(1, "to_year")
is_to_season = dw_head.GetItemString(1, "to_season")
is_to_ymd    = dw_head.GetItemString(1, "to_ymd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("is_brand" , is_brand)
//messagebox("is_season" , is_season)
//messagebox("is_fr_ymd" , is_fr_ymd)
//messagebox("is_to_ymd" , is_to_ymd)

il_rows = dw_body.retrieve(is_brand, is_fr_year, is_fr_season, is_to_year, is_to_season, is_to_ymd)
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

dw_print.object.t_brand.text = "브랜드 : " + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_season.text = "시즌 : " + is_fr_year + is_fr_season + " <--> " + is_to_year + is_to_season
dw_print.object.t_yymmdd.text = "기준일자 : " + is_to_ymd

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event open;call super::open;datetime ld_datetime

//dw_body.Object.DataWindow.HorizontalScrollSplit  = 570



IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_ymd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_ymd",string(ld_datetime,"yyyymmdd"))
end if
end event

type cb_close from w_com010_d`cb_close within w_31028_d
end type

type cb_delete from w_com010_d`cb_delete within w_31028_d
end type

type cb_insert from w_com010_d`cb_insert within w_31028_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31028_d
end type

type cb_update from w_com010_d`cb_update within w_31028_d
end type

type cb_print from w_com010_d`cb_print within w_31028_d
end type

type cb_preview from w_com010_d`cb_preview within w_31028_d
end type

type gb_button from w_com010_d`gb_button within w_31028_d
end type

type cb_excel from w_com010_d`cb_excel within w_31028_d
end type

type dw_head from w_com010_d`dw_head within w_31028_d
integer height = 164
string dataobject = "d_31028_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","[NO]")
idw_brand.setitem(1,"inter_nm","온앤온올리브")

/*
This.GetChild("fr_season", idw_fr_season)
idw_fr_season.SetTransObject(SQLCA)
idw_fr_season.Retrieve('003')


This.GetChild("to_season", idw_to_season)
idw_to_season.SetTransObject(SQLCA)
idw_to_season.Retrieve('003')
*/

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_fr_year = dw_head.getitemstring(1,'fr_year')
is_to_year = dw_head.getitemstring(1,'to_year')

this.getchild("fr_season",idw_fr_season)
idw_fr_season.settransobject(sqlca)
idw_fr_season.retrieve('003', is_brand, is_fr_year)
//idw_season.retrieve('003')

this.getchild("to_season",idw_to_season)
idw_to_season.settransobject(sqlca)
idw_to_season.retrieve('003', is_brand, is_to_year)
//idw_season.retrieve('003')
end event

event dw_head::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name
	CASE "brand", "fr_year"	, "to_year"	
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_fr_year = dw_head.getitemstring(1,'fr_year')
		is_to_year = dw_head.getitemstring(1,'to_year')
		
		this.getchild("fr_season",idw_fr_season)
		idw_fr_season.settransobject(sqlca)
		idw_fr_season.retrieve('003', is_brand, is_fr_year)
		//idw_season.retrieve('003')
		
		this.getchild("to_season",idw_to_season)
		idw_to_season.settransobject(sqlca)
		idw_to_season.retrieve('003', is_brand, is_to_year)

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_31028_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_d`ln_2 within w_31028_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_d`dw_body within w_31028_d
integer y = 392
integer height = 1652
string dataobject = "d_31028_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_31028_d
string dataobject = "d_31028_r01"
end type

