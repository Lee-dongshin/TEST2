$PBExportHeader$w_32002_d.srw
$PBExportComments$사전 원가 LIST
forward
global type w_32002_d from w_com010_d
end type
type st_1 from statictext within w_32002_d
end type
end forward

global type w_32002_d from w_com010_d
st_1 st_1
end type
global w_32002_d w_32002_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item

String is_brand, is_year, is_season, is_sojae, is_item, is_style_no, is_yymmdd, is_make_type, is_kor_chn
String is_to_ymd

end variables

on w_32002_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_32002_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
String ls_style, ls_chno


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

If is_style_no = '%' Then
	ls_style = '%'
	ls_chno  = '%'
Else
	ls_style = LeftA(is_style_no, 8)
	ls_chno  = MidA(is_style_no, 9, 1)
End IF

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, ls_style, ls_chno, is_yymmdd, is_to_ymd, is_make_type, is_kor_chn)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_sojae = dw_head.GetItemString(1, "sojae")
is_item = dw_head.GetItemString(1, "item")
is_style_no = dw_head.GetItemString(1, "style_no")

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
//if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
//   MessageBox(ls_title,"시작일자를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("yymmdd")
//   return false
//end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_make_type = dw_head.GetItemString(1, "make_type")
is_kor_chn = dw_head.GetItemString(1, "kor_chn")

return true

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_style_no, ls_kor_chn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_style_no = '%' Then
	ls_style_no = '전체'
Else
	ls_style_no = String(is_style_no, '@@@@@@@@-@')
End If

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text = '" + is_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
            "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
            "t_style_no.Text = '" + ls_style_no + "'"

dw_print.Modify(ls_modify)

if is_kor_chn = '%' then
	ls_kor_chn = '전체물량'
elseif is_kor_chn = 'K' then
	ls_kor_chn = '국내물량'
elseif is_kor_chn = 'C' then
	ls_kor_chn = '중국물량'	
end if

dw_print.object.t_kor_chn.text = ls_kor_chn
end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				END IF 
				IF LeftA(as_data, 8) = is_brand and gf_style_chk(LeftA(as_data, 8), MidA(as_data, 9, 1)) = True THEN
					RETURN 0
				END IF 
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE NO 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + LeftA(as_data, 8) + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32002_d","0")
end event

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 300
end event

type cb_close from w_com010_d`cb_close within w_32002_d
end type

type cb_delete from w_com010_d`cb_delete within w_32002_d
end type

type cb_insert from w_com010_d`cb_insert within w_32002_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_32002_d
end type

type cb_update from w_com010_d`cb_update within w_32002_d
end type

type cb_print from w_com010_d`cb_print within w_32002_d
end type

type cb_preview from w_com010_d`cb_preview within w_32002_d
end type

type gb_button from w_com010_d`gb_button within w_32002_d
end type

type cb_excel from w_com010_d`cb_excel within w_32002_d
end type

type dw_head from w_com010_d`dw_head within w_32002_d
integer y = 152
integer height = 224
string dataobject = "d_32002_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


This.GetChild("make_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('030')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.05.24                                                  */	
/* 수정일      : 2002.05.24                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand", "year"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")

			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
				
		
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_32002_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_32002_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_32002_d
integer y = 444
integer height = 1596
string dataobject = "d_32002_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_32002_d
integer y = 768
string dataobject = "d_32002_r01"
end type

type st_1 from statictext within w_32002_d
integer x = 1024
integer y = 360
integer width = 1664
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 전체 조회시 시작일자를 지우고 조회하세요"
boolean focusrectangle = false
end type

