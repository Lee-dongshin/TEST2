$PBExportHeader$w_11014_d.srw
$PBExportComments$시즌별 총괄 원가계획 현황
forward
global type w_11014_d from w_com010_d
end type
type st_1 from statictext within w_11014_d
end type
type st_2 from statictext within w_11014_d
end type
end forward

global type w_11014_d from w_com010_d
st_1 st_1
st_2 st_2
end type
global w_11014_d w_11014_d

type variables
DataWindowChild idw_brand
String is_brand, is_yyyy
end variables

on w_11014_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_11014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yyyy)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")


end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_brand, ls_yyyy

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss") 
ls_brand = "브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") 
ls_yyyy  = is_yyyy + "년도"

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + ls_brand + "'" + &
            "t_yyyy.Text = '" + ls_yyyy + "'"

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11014_d","0")
end event

type cb_close from w_com010_d`cb_close within w_11014_d
end type

type cb_delete from w_com010_d`cb_delete within w_11014_d
end type

type cb_insert from w_com010_d`cb_insert within w_11014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_11014_d
end type

type cb_update from w_com010_d`cb_update within w_11014_d
end type

type cb_print from w_com010_d`cb_print within w_11014_d
end type

type cb_preview from w_com010_d`cb_preview within w_11014_d
end type

type gb_button from w_com010_d`gb_button within w_11014_d
end type

type cb_excel from w_com010_d`cb_excel within w_11014_d
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_11014_d
integer height = 168
string dataobject = "d_11014_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')


end event

type ln_1 from w_com010_d`ln_1 within w_11014_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_11014_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_11014_d
integer y = 376
integer height = 1672
string dataobject = "d_11014_d01"
end type

type dw_print from w_com010_d`dw_print within w_11014_d
string dataobject = "d_11014_r01"
end type

type st_1 from statictext within w_11014_d
integer x = 3154
integer y = 276
integer width = 425
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "( 단위 : 천원 )"
boolean focusrectangle = false
end type

type st_2 from statictext within w_11014_d
integer x = 1760
integer y = 220
integer width = 480
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 국내(중국제외)"
boolean focusrectangle = false
end type

