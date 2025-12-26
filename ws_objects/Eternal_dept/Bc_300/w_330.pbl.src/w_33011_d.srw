$PBExportHeader$w_33011_d.srw
$PBExportComments$상제품원가현황(결산용)
forward
global type w_33011_d from w_com010_d
end type
type cbx_1 from checkbox within w_33011_d
end type
end forward

global type w_33011_d from w_com010_d
integer width = 3675
integer height = 2276
cbx_1 cbx_1
end type
global w_33011_d w_33011_d

type variables
datawindowchild	idw_brand, idw_season, idw_sojae
string is_brand, is_year, is_season, is_sojae, is_style, is_mat_cd ,is_fr_yymm, is_to_yymm, is_gubn

end variables

on w_33011_d.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_33011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
end on

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymm"))
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymm"))
end if

end event

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

is_style = dw_head.GetItemString(1, "style")
is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
is_to_yymm = dw_head.GetItemString(1, "to_yymm")
is_gubn = dw_head.GetItemString(1, "gubn")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//describe
if cbx_1.checked then
	if is_gubn = "S" then 
		dw_body.dataobject = "d_33011_style1"
		dw_print.dataobject = "d_33011_r_style1"		
	else
		dw_body.dataobject = "d_33011_mat1"
		dw_print.dataobject = "d_33011_r_mat1"		
	end if
else
	if is_gubn = "S" then 
		dw_body.dataobject = "d_33011_style"
		dw_print.dataobject = "d_33011_r_style"
	else
		dw_body.dataobject = "d_33011_mat"
		dw_print.dataobject = "d_33011_r_mat"
	end if
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

//il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_style, is_mat_cd, is_fr_yymm, is_to_yymm, is_gubn)
il_rows = dw_body.retrieve(is_brand, is_fr_yymm, is_to_yymm, is_gubn)
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

event ue_title();call super::ue_title;if is_gubn = 'S' then 
	dw_print.dataobject = "d_33011_r_style"
else 
	dw_print.dataobject = "d_33011_r_mat"
end if
dw_print.SetTransObject(SQLCA)

/*===========================================================================*/
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


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_33011_d","0")
end event

event open;call super::open;dw_head.setitem(1,"year","%")
dw_head.setitem(1,"season","%")
end event

type cb_close from w_com010_d`cb_close within w_33011_d
integer taborder = 110
end type

type cb_delete from w_com010_d`cb_delete within w_33011_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_33011_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_33011_d
end type

type cb_update from w_com010_d`cb_update within w_33011_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_33011_d
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_33011_d
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_33011_d
end type

type cb_excel from w_com010_d`cb_excel within w_33011_d
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_33011_d
string dataobject = "d_33011_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")

this.setitem(1,"season","%")
this.setitem(1,"year","%")

this.getchild("sojae",idw_sojae)
idw_sojae.settransobject(sqlca)
idw_sojae.retrieve('111')
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"inter_cd","%")
idw_sojae.setitem(1,"inter_nm","전체")




end event

type ln_1 from w_com010_d`ln_1 within w_33011_d
end type

type ln_2 from w_com010_d`ln_2 within w_33011_d
end type

type dw_body from w_com010_d`dw_body within w_33011_d
integer taborder = 40
string dataobject = "d_33011_style"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_33011_d
integer x = 27
integer y = 572
string dataobject = "d_33011_r_style"
end type

type cbx_1 from checkbox within w_33011_d
boolean visible = false
integer x = 3099
integer y = 204
integer width = 402
integer height = 60
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "계산서기준"
borderstyle borderstyle = stylelowered!
end type

