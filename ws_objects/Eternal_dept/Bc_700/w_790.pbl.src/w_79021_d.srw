$PBExportHeader$w_79021_d.srw
$PBExportComments$자가소모처리
forward
global type w_79021_d from w_com010_d
end type
type st_1 from statictext within w_79021_d
end type
end forward

global type w_79021_d from w_com010_d
st_1 st_1
end type
global w_79021_d w_79021_d

type variables
DataWindowChild	idw_brand
String is_yymm, is_brand, is_view_opt, is_to_yymm
end variables

on w_79021_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_79021_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_yymm= dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_to_yymm= dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if


is_view_opt = dw_head.GetItemString(1, "view_opt")
if IsNull(is_view_opt) or Trim(is_view_opt) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("view_opt")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_view_opt = 'A' then 
	dw_body.DataObject = "d_79021_d01"
	dw_body.SetTransObject(SQLCA)
	
	dw_print.DataObject = "d_79021_r01"
	dw_print.SetTransObject(SQLCA)
	il_rows = dw_body.retrieve(is_yymm, is_to_yymm)
else	
	dw_body.DataObject = "d_79021_d02"
	dw_body.SetTransObject(SQLCA)
	
	dw_print.DataObject = "d_79021_r02"
	dw_print.SetTransObject(SQLCA)
	
	il_rows = dw_body.retrieve(is_brand, is_yymm, is_to_yymm)
end if	
	
	
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_yymm

ls_yymm = is_yymm +"-" + is_to_yymm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
 				"t_yymm.Text  = '" + ls_yymm + "' " 

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79021_d","0")
end event

type cb_close from w_com010_d`cb_close within w_79021_d
end type

type cb_delete from w_com010_d`cb_delete within w_79021_d
end type

type cb_insert from w_com010_d`cb_insert within w_79021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79021_d
end type

type cb_update from w_com010_d`cb_update within w_79021_d
end type

type cb_print from w_com010_d`cb_print within w_79021_d
end type

type cb_preview from w_com010_d`cb_preview within w_79021_d
end type

type gb_button from w_com010_d`gb_button within w_79021_d
end type

type cb_excel from w_com010_d`cb_excel within w_79021_d
end type

type dw_head from w_com010_d`dw_head within w_79021_d
integer y = 156
integer height = 200
string dataobject = "d_79021_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_d`ln_1 within w_79021_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_d`ln_2 within w_79021_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_d`dw_body within w_79021_d
integer y = 376
integer height = 1664
string dataobject = "d_79021_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_79021_d
string dataobject = "d_79021_R01"
end type

type st_1 from statictext within w_79021_d
integer x = 187
integer y = 288
integer width = 1778
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "※ 비교조회시 브랜드 조건 미적용 됩니다."
boolean focusrectangle = false
end type

