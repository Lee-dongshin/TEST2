$PBExportHeader$w_62021_d.srw
$PBExportComments$주단위판매 스타일선정
forward
global type w_62021_d from w_com010_d
end type
type cb_group from commandbutton within w_62021_d
end type
type cbx_gubn from checkbox within w_62021_d
end type
end forward

global type w_62021_d from w_com010_d
integer width = 3689
integer height = 2280
event ue_first_open ( )
event ue_group_open ( )
cb_group cb_group
cbx_gubn cbx_gubn
end type
global w_62021_d w_62021_d

type variables
String is_yymmdd, is_brand, is_year, is_season, is_sojae, is_item, is_dep_fg, is_gubun, is_chno_gubun, is_grp_gbn
string is_style_no, is_print_gubun, is_ps_chn
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_dep_fg, idw_color, idw_size

end variables

event ue_first_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다. 'W_CU100_e04'      */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
gf_open_sheet(lw_window, 'W_61015_d', '주단위판매 현황')


end event

event ue_group_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다. 'W_CU100_e04'      */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
gf_open_sheet(lw_window, 'W_55017_d', 'Group별 판매현황')


end event

on w_62021_d.create
int iCurrent
call super::create
this.cb_group=create cb_group
this.cbx_gubn=create cbx_gubn
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_group
this.Control[iCurrent+2]=this.cbx_gubn
end on

on w_62021_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_group)
destroy(this.cbx_gubn)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_sojae, is_year, is_season, &
									is_item, is_dep_fg, is_gubun, is_chno_gubun, is_style_no, is_ps_chn)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
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

is_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd'))
IF IsNull(is_yymmdd) OR is_yymmdd = "" THEN
	MessageBox(ls_title,"기준일을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("yymmdd")
	RETURN FALSE
END IF

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
	MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("brand")
	RETURN FALSE
END IF

is_year = Trim(dw_head.GetItemString(1, "year"))
IF IsNull(is_year) OR is_year = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
	RETURN FALSE
END IF

is_season = Trim(dw_head.GetItemString(1, "season"))
IF IsNull(is_season) OR is_season = "" THEN
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
	RETURN FALSE
END IF

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
IF IsNull(is_sojae) OR is_sojae = "" THEN
   MessageBox(ls_title,"소재를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
	RETURN FALSE
END IF

is_item = Trim(dw_head.GetItemString(1, "item"))
IF IsNull(is_item) OR is_item = "" THEN
   MessageBox(ls_title,"품종을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
	RETURN FALSE
END IF

is_dep_fg = Trim(dw_head.GetItemString(1, "dep_fg"))
IF IsNull(is_dep_fg) OR is_dep_fg = "" then
   MessageBox(ls_title,"부진구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_fg")
	RETURN FALSE
END IF

is_gubun = Trim(dw_head.GetItemString(1, "gubun"))
IF IsNull(is_gubun) OR is_gubun = "" then
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
	RETURN FALSE
END IF

is_chno_gubun = Trim(dw_head.GetItemString(1, "chno_gubun"))
IF IsNull(is_chno_gubun) OR is_chno_gubun = "" then
   MessageBox(ls_title,"차수 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chno_gubun")
	RETURN FALSE
END IF

 
is_print_gubun = Trim(dw_head.GetItemString(1, "print_type"))
IF IsNull(is_print_gubun) OR is_print_gubun = "" then
   MessageBox(ls_title,"출력 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("print_type")
	RETURN FALSE
END IF

is_ps_chn = dw_head.GetItemString(1, "ps_chn")
IF IsNull(is_ps_chn) OR is_ps_chn = "" then
   MessageBox(ls_title,"조회기준을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ps_chn")
	RETURN FALSE
END IF

is_style_no = Trim(dw_head.GetItemString(1, "style_no"))
IF IsNull(is_style_no) OR is_style_no = "" then
   is_style_no = "%"	
END IF

RETURN TRUE

end event

event ue_title();call super::ue_title;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김진백)                                       */	
///* 작성일      : 2002.02.15                                                  */	
///* 수정일      : 2002.02.15                                                  */
///*===========================================================================*/
//DateTime ld_datetime
//String ls_modify, ls_datetime, ls_chno_gubun, ls_gubun
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//If is_chno_gubun = '1' Then
//	ls_chno_gubun = 'STYLE NO'
//Else
//	ls_chno_gubun = 'STYLE'
//End If
//
//If is_gubun = '1' Then
//	ls_gubun = '수량'
//ElseIf is_gubun = '2' Then
//	ls_gubun = '소비자가액'
//Else
//	ls_gubun = '원가액'
//End If
//
//ls_modify =	"t_pg_id.Text      = '" + is_pgm_id    + "'" + &
//            "t_user_id.Text    = '" + gs_user_id   + "'" + &
//            "t_datetime.Text   = '" + ls_datetime  + "'" + &
//            "t_yymmdd.Text     = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
//				"t_brand.Text      = '" + idw_brand.GetItemString(idw_brand.GetRow(),   "inter_display") + "'" + &
//            "t_year.Text       = '" + is_year      + "'" + &
//            "t_season.Text     = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
//            "t_sojae.Text      = '" + idw_sojae.GetItemString(idw_sojae.GetRow(),   "sojae_display") + "'" + &
//            "t_item.Text       = '" + idw_item.GetItemString(idw_item.GetRow(),     "item_display")  + "'" + &
//            "t_dep_fg.Text     = '" + idw_dep_fg.GetItemString(idw_dep_fg.GetRow(), "inter_display") + "'" + &
//            "t_chno_gubun.Text = '" + ls_chno_gubun + "'" + &
//            "t_gubun.Text      = '" + ls_gubun      + "'"
//
//dw_print.Modify(ls_modify)
//
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
         cb_group.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled  = false
         dw_body.Enabled  = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_group.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_group.enabled = false		
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled  = false
      dw_head.Enabled  = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_print();//
//	dw_print.SetTransObject(SQLCA)
//	
//	
//	This.Trigger Event ue_title ()
//
//dw_body.ShareData(dw_print)
//dw_print.inv_printpreview.of_SetZoom()
//
end event

event ue_preview();////
//
//	dw_print.SetTransObject(SQLCA)
//	
//	This.Trigger Event ue_title ()
//
//dw_body.ShareData(dw_print)
//dw_print.inv_printpreview.of_SetZoom()
//
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62021_d","0")
end event

event pfc_preopen();call super::pfc_preopen;
inv_resize.of_Register(cb_group, "FixedToRight")




end event

type cb_close from w_com010_d`cb_close within w_62021_d
end type

type cb_delete from w_com010_d`cb_delete within w_62021_d
end type

type cb_insert from w_com010_d`cb_insert within w_62021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62021_d
end type

type cb_update from w_com010_d`cb_update within w_62021_d
end type

type cb_print from w_com010_d`cb_print within w_62021_d
integer width = 686
string text = "주간단위 판매 조회"
end type

event cb_print::clicked;/*===========================================================================*/
/* 작성자      :                                                   */	
/* 작성일      :                                                   */	
/* 수정일      :                                                   */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_rt_qty , ll_sale_qty, ll_out_qty
datetime ld_datetime
string ls_chk, ls_style

gs_style_comb = ''	
	
ll_row_count = dw_body.RowCount()

	IF dw_body.AcceptText() <> 1 THEN RETURN -1
		
		/* 시스템 날짜를 가져온다 */
		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF
		
		FOR i=1 TO ll_row_count
			ls_chk = dw_body.GetItemString(i, "chk")
			ls_style = dw_body.GetItemString(i, "style")
			if ls_chk = "Y" then
				gs_style_comb = gs_style_comb + ls_style
			end if			
		NEXT
		
		
		 Parent.Trigger Event ue_first_open()
		
return il_rows

end event

type cb_preview from w_com010_d`cb_preview within w_62021_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_62021_d
end type

type cb_excel from w_com010_d`cb_excel within w_62021_d
end type

type dw_head from w_com010_d`dw_head within w_62021_d
integer x = 27
integer y = 152
integer width = 3433
integer height = 260
string dataobject = "d_62021_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

THIS.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

THIS.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

THIS.GetChild("dep_fg", idw_dep_fg)
idw_dep_fg.SetTransObject(SQLCA)
idw_dep_fg.Retrieve('541')
idw_dep_fg.InsertRow(1)
idw_dep_fg.SetItem(1, "inter_cd", '%')
idw_dep_fg.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"

		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
	
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")		
				
		
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

type ln_1 from w_com010_d`ln_1 within w_62021_d
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_d`ln_2 within w_62021_d
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_d`dw_body within w_62021_d
integer x = 9
integer y = 432
integer width = 3598
integer height = 1612
string dataobject = "d_62021_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_62021_d
integer x = 1573
integer y = 860
string dataobject = "d_55007_r14"
end type

type cb_group from commandbutton within w_62021_d
event ue_disp_group ( )
integer x = 901
integer y = 44
integer width = 521
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "GROUP 별 판매현황"
end type

event ue_disp_group();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN
/*===========================================================================*/
/* 작성자      :                                                   */	
/* 작성일      :                                                   */	
/* 수정일      :                                                   */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_rt_qty , ll_sale_qty, ll_out_qty
datetime ld_datetime
string ls_chk, ls_style

gs_style_comb = ''	
	
ll_row_count = dw_body.RowCount()

IF dw_body.AcceptText() <> 1 THEN RETURN 
	
	/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF

FOR i=1 TO ll_row_count
	ls_chk = dw_body.GetItemString(i, "chk")
	ls_style = dw_body.GetItemString(i, "style")
	if ls_chk = "Y" then
		gs_style_comb = gs_style_comb + ls_style
	end if			
NEXT			


gsv_cd.gs_cd1 = is_yymmdd
gsv_cd.gs_cd2 = is_brand
gsv_cd.gs_cd3 = is_year
gsv_cd.gs_cd4 = is_season
gsv_cd.gs_cd5 = is_grp_gbn
//messagebox("is_yymmdd",is_yymmdd)
//messagebox("is_brand",is_brand)
//messagebox("is_year",is_year)
//messagebox("is_season",is_season)
//messagebox("is_style_no",is_style_no)
//messagebox("is_grp_gbn",is_grp_gbn)
//

trigger event ue_group_open()
end event

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

if cbx_gubn.checked then
	is_grp_gbn = '3'
elseif is_gubun = '1' then 
	is_grp_gbn = is_gubun
elseif is_gubun = '2' then
	is_grp_gbn = is_gubun
else
	is_grp_gbn = '4'
end if

post event ue_disp_group()





end event

type cbx_gubn from checkbox within w_62021_d
boolean visible = false
integer x = 603
integer y = 440
integer width = 411
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
string text = "금액(실판가)"
borderstyle borderstyle = stylelowered!
end type

