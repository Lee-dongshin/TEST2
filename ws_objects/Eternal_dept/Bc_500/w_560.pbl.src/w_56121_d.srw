$PBExportHeader$w_56121_d.srw
$PBExportComments$대리점 공제 출력
forward
global type w_56121_d from w_com010_d
end type
end forward

global type w_56121_d from w_com010_d
integer width = 3680
integer height = 2276
end type
global w_56121_d w_56121_d

type variables
String is_brand, is_yymm, is_shop_div, is_CHNO
DataWindowChild idw_brand, idw_shop_div, idw_comm_fg
end variables

on w_56121_d.create
call super::create
end on

on w_56121_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_title();call super::ue_title;
DateTime ld_datetime
String ls_modify, ls_datetime, ls_shop_type, ls_shop_nm_st, ls_shop_nm_ed

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

is_yymm = String(dw_head.GetItemDateTime(1, "yymm"), 'yyyy/mm')

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id     + "'" + &
            "t_user_id.Text  = '" + gs_user_id    + "'" + &
            "t_datetime.Text = '" + ls_datetime   + "'" + &
            "t_yymm.Text     = '" + is_yymm       + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(),       "inter_display") + "'" + &
            "t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'" + &
            "t_CHNO.Text  =  '당월" + IS_CHNO + "차공제' "

dw_print.Modify(ls_modify)

end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, IS_CHNO, is_shop_div)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

is_yymm = Trim(String(dw_head.GetItemDateTime(1, "yymm"), 'yyyymm'))
IF IsNull(is_yymm) OR is_yymm = "" THEN
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   RETURN FALSE
END IF

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

is_CHNO = Trim(dw_head.GetItemString(1, "CHNO"))
IF IsNull(is_CHNO) OR is_CHNO = "" THEN
   MessageBox(ls_title,"공제차수를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("CHNO")
   RETURN FALSE
END IF

RETURN TRUE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56121_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56121_d
end type

type cb_delete from w_com010_d`cb_delete within w_56121_d
end type

type cb_insert from w_com010_d`cb_insert within w_56121_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56121_d
end type

type cb_update from w_com010_d`cb_update within w_56121_d
end type

type cb_print from w_com010_d`cb_print within w_56121_d
end type

type cb_preview from w_com010_d`cb_preview within w_56121_d
end type

type gb_button from w_com010_d`gb_button within w_56121_d
end type

type cb_excel from w_com010_d`cb_excel within w_56121_d
end type

type dw_head from w_com010_d`dw_head within w_56121_d
integer x = 5
integer y = 168
integer height = 236
string dataobject = "d_56121_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

THIS.GetChild("comm_fg", idw_comm_fg)
idw_comm_fg.SetTransObject(SQLCA)
idw_comm_fg.Retrieve('919')
idw_comm_fg.InsertRow(1)
idw_comm_fg.SetItem(1, "inter_cd", '%')
idw_comm_fg.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_56121_d
integer beginy = 428
integer endy = 428
end type

type ln_2 from w_com010_d`ln_2 within w_56121_d
integer beginy = 432
integer endy = 432
end type

type dw_body from w_com010_d`dw_body within w_56121_d
integer x = 9
integer y = 448
integer width = 3593
integer height = 1596
string dataobject = "d_56121_d01"
end type

type dw_print from w_com010_d`dw_print within w_56121_d
integer x = 709
integer y = 264
string dataobject = "d_56121_r01"
end type

