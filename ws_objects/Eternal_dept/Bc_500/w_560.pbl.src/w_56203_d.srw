$PBExportHeader$w_56203_d.srw
$PBExportComments$매장별 월별 세금계산서 발행
forward
global type w_56203_d from w_com010_d
end type
type st_1 from statictext within w_56203_d
end type
type rb_1 from radiobutton within w_56203_d
end type
type rb_2 from radiobutton within w_56203_d
end type
end forward

global type w_56203_d from w_com010_d
integer width = 3685
integer height = 2284
st_1 st_1
rb_1 rb_1
rb_2 rb_2
end type
global w_56203_d w_56203_d

type variables
String is_brand, is_yymm_st, is_yymm_ed, is_sale_gubn, is_shop_div

DataWindowChild idw_brand, idw_sale_gubn, idw_shop_div
end variables

forward prototypes
public subroutine wf_set (ref string as_modify)
end prototypes

public subroutine wf_set (ref string as_modify);String ls_yymm, ls_modify
Long i = 0, j

DECLARE CUR1 CURSOR FOR
 SELECT DISTINCT LEFT(T_DATE, 6)
   FROM TB_DATE
  WHERE T_DATE BETWEEN :is_yymm_st + '01' AND :is_yymm_ed + '01'
;

OPEN CUR1;

FETCH CUR1 INTO :ls_yymm;

DO WHILE sqlca.sqlcode = 0
	i++
	ls_modify = ls_modify + "amt"     + String(i, '00') + ".Visible = 1 " + &
	                        "vat"     + String(i, '00') + ".Visible = 1 " + &
	                        "tot_amt" + String(i, '00') + ".Visible = 1 " + &
	                        "amt"     + String(i, '00') + "_all.Visible = 1 " + &
	                        "vat"     + String(i, '00') + "_all.Visible = 1 " + &
	                        "tot_amt" + String(i, '00') + "_all.Visible = 1 " + &
	                        "amt"     + String(i, '00') + "_t.Visible = 1 " + &
	                        "vat"     + String(i, '00') + "_t.Visible = 1 " + &
	                        "tot_amt" + String(i, '00') + "_t.Visible = 1 " + &
	                        "tot"     + String(i, '00') + "_t.Text = '" + String(ls_yymm, '@@@@/@@') + "' "
	
FETCH CUR1 INTO :ls_yymm;
LOOP

CLOSE CUR1;

i++

For j = i To 3
	ls_modify = ls_modify + "amt"     + String(j, '00') + ".Visible = 0 " + &
	                        "vat"     + String(j, '00') + ".Visible = 0 " + &
	                        "tot_amt" + String(j, '00') + ".Visible = 0 " + &
	                        "amt"     + String(j, '00') + "_all.Visible = 0 " + &
	                        "vat"     + String(j, '00') + "_all.Visible = 0 " + &
	                        "tot_amt" + String(j, '00') + "_all.Visible = 0 " + &
	                        "amt"     + String(j, '00') + "_t.Visible = 0 " + &
	                        "vat"     + String(j, '00') + "_t.Visible = 0 " + &
	                        "tot_amt" + String(j, '00') + "_t.Visible = 0 " + &
	                        "tot"     + String(j, '00') + "_t.Visible = 0 "
Next

as_modify = ls_modify

end subroutine

on w_56203_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
end on

on w_56203_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.27                                                  */	
/* 수정일      : 2002.02.27                                                  */
/*===========================================================================*/
String ls_modify

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

//dw_body.DataObject = 'd_56203_d01'
//dw_body.SetTransObject(SQLCA)
//
dw_body.SetReDraw(False)
il_rows = dw_body.retrieve(is_brand, is_yymm_st, is_yymm_ed, is_sale_gubn, is_shop_div)

IF il_rows > 0 THEN
   dw_body.SetFocus()
	wf_set(ls_modify)
	dw_body.Modify(ls_modify)
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF
dw_body.SetReDraw(True)

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

is_yymm_st = Trim(String(dw_head.GetItemDateTime(1, "fr_yymm"), 'yyyymm'))
IF IsNull(is_yymm_st) OR is_yymm_st = "" THEN
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   RETURN FALSE
END IF

is_yymm_ed = Trim(String(dw_head.GetItemDateTime(1, "to_yymm"), 'yyyymm'))
IF IsNull(is_yymm_ed) OR is_yymm_ed = "" THEN
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   RETURN FALSE
END IF

IF is_yymm_st > is_yymm_ed THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   RETURN FALSE 
END IF

//IF DaysAfter(Date(String(is_yymm_st + '01', "@@@@/@@/@@")), Date(String(is_yymm_ed + '01', "@@@@/@@/@@"))) > 80 then
//	MessageBox("오류","기간이 3개월을 넘었습니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_yymm")
//	RETURN FALSE 
//END IF

is_sale_gubn = Trim(dw_head.GetItemString(1, "sale_gubn"))
IF IsNull(is_sale_gubn) OR is_sale_gubn = "" THEN
   MessageBox(ls_title,"매출 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_gubn")
   RETURN FALSE
END IF

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

RETURN TRUE

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.02.27                                                  */
/* 수정일      : 2002.02.27                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_modify2, ls_datetime, ls_sale_type, ls_shop_nm, ls_brand_nm
Long i, ll_row_count

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

select inter_data2 
into   :ls_brand_nm
from   tb_91011_c (nolock)
where  inter_grp = '001'
and    inter_cd  = :is_brand;


ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
if rb_2.checked = true then
	ls_modify =	"t_yyyy.Text     = '" + LeftA(is_yymm_st,4)    + "'" + &					
					"t_brand_nm.Text  = '" + ls_brand_nm + "'"		
else	
	ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
					"t_user_id.Text   = '" + gs_user_id   + "'" + &
					"t_datetime.Text  = '" + ls_datetime  + "'" + &
					"t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_yymm_st.Text   = '" + String(is_yymm_st, '@@@@/@@') + "'" + &
					"t_yymm_ed.Text   = '" + String(is_yymm_ed, '@@@@/@@') + "'" + &
					"t_sale_gubn.Text = '" + idw_sale_gubn.GetItemString(idw_sale_gubn.GetRow(), "inter_display") + "'" + &
					"t_shop_div.Text  = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'"	
	wf_set(ls_modify2)
end if	
	dw_print.Modify(ls_modify + ls_modify2)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56203_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56203_d
end type

type cb_delete from w_com010_d`cb_delete within w_56203_d
end type

type cb_insert from w_com010_d`cb_insert within w_56203_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56203_d
end type

type cb_update from w_com010_d`cb_update within w_56203_d
end type

type cb_print from w_com010_d`cb_print within w_56203_d
end type

type cb_preview from w_com010_d`cb_preview within w_56203_d
end type

type gb_button from w_com010_d`gb_button within w_56203_d
end type

type cb_excel from w_com010_d`cb_excel within w_56203_d
end type

type dw_head from w_com010_d`dw_head within w_56203_d
integer y = 164
integer height = 120
string dataobject = "d_56203_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("sale_gubn", idw_sale_gubn)
idw_sale_gubn.SetTransObject(SQLCA)
idw_sale_gubn.Retrieve('560')
idw_sale_gubn.SetFilter("inter_cd1 = 'Y'")
idw_sale_gubn.Filter()
idw_sale_gubn.insertRow(1)
idw_sale_gubn.Setitem(1, "inter_cd", '00')
idw_sale_gubn.Setitem(1, "inter_nm", '의류')
idw_sale_gubn.Setitem(1, "inter_cd1", 'Y')
idw_sale_gubn.insertRow(1)
idw_sale_gubn.Setitem(1, "inter_cd", '%')
idw_sale_gubn.Setitem(1, "inter_nm", '전체')
idw_sale_gubn.Setitem(1, "inter_cd1", 'Y')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.insertRow(1)
idw_shop_div.Setitem(1, "inter_cd", '%')
idw_shop_div.Setitem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_56203_d
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_d`ln_2 within w_56203_d
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_d`dw_body within w_56203_d
integer x = 9
integer y = 412
integer width = 3593
integer height = 1636
string dataobject = "d_56203_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_56203_d
integer x = 1499
integer y = 524
integer width = 1915
integer height = 476
string dataobject = "d_56203_r01"
end type

type st_1 from statictext within w_56203_d
integer x = 27
integer y = 324
integer width = 293
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출력구분:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_56203_d
integer x = 366
integer y = 316
integer width = 430
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "부가세포함"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.DataObject = 'd_56203_d01'
dw_body.SetTransObject(SQLCA)

dw_print.DataObject = 'd_56203_r01'
dw_print.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_56203_d
integer x = 864
integer y = 316
integer width = 457
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "부가세제외"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.DataObject = 'd_56203_d02'
dw_body.SetTransObject(SQLCA)

dw_print.DataObject = 'd_56203_r02'
dw_print.SetTransObject(SQLCA)

end event

