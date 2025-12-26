$PBExportHeader$w_61005_d.srw
$PBExportComments$브랜드별진행현황
forward
global type w_61005_d from w_com010_d
end type
type st_1 from statictext within w_61005_d
end type
type cbx_1 from checkbox within w_61005_d
end type
end forward

global type w_61005_d from w_com010_d
integer width = 3675
integer height = 2244
st_1 st_1
cbx_1 cbx_1
end type
global w_61005_d w_61005_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
DataWindowChild	idw_brand, idw_season_fr, idw_season_to

String is_brand, is_year_fr, is_year_to, is_season_fr, is_season_to, is_yymmdd, is_sojae_gubn, is_balju, is_ps_chn, is_opt_view
String is_sale_gubn, is_by_season, is_opt_brand, is_stock_mat, is_event_gubn
end variables

on w_61005_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cbx_1
end on

on w_61005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cbx_1)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_season_to

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

if gs_brand = "B" or  gs_brand = "F"  or gs_brand = "L" then
	ls_season_to = 'A'
else 	
	ls_season_to = 'W'
end if	


dw_head.SetItem(1, "year_fr", String(ld_datetime,'yyyy'))
dw_head.SetItem(1, "year_to", String(ld_datetime,'yyyy'))
dw_head.SetItem(1, "season_fr", 'S')
dw_head.SetItem(1, "season_to", ls_season_to)
dw_head.SetItem(1, "event_gubn", '%')

dw_head.SetColumn("season_fr")
dw_head.SetColumn("season_to")


if gs_brand = "O" then 
	dw_head.object.opt_brand.visible = true
else 	
	dw_head.object.opt_brand.visible = false
end if			
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

is_brand		= Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) OR is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year_fr = Trim(dw_head.GetItemString(1, "year_fr"))
if IsNull(is_year_fr) OR is_year_fr = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year_fr")
   return false
end if

is_season_fr= Trim(dw_head.GetItemString(1, "season_fr"))
if IsNull(is_season_fr) OR is_season_fr = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season_fr")
   return false
end if

is_year_to = Trim(dw_head.GetItemString(1, "year_to"))
if IsNull(is_year_to) OR is_year_to = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year_to")
   return false
end if

is_season_to= Trim(dw_head.GetItemString(1, "season_to"))
if IsNull(is_season_to) OR is_season_to = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season_to")
   return false
end if

is_yymmdd = Trim(String(dw_head.GetItemDate(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_yymmdd) OR is_yymmdd = "" then
   MessageBox(ls_title,"기준 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_sojae_gubn = dw_head.GetItemstring(1, "sojae_gubn")
if IsNull(is_sojae_gubn) OR is_sojae_gubn = "" then
   MessageBox(ls_title,"소재구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae_gubn")
   return false
end if

is_balju = dw_head.GetItemstring(1, "balju")
is_ps_chn = dw_head.GetItemstring(1, "ps_chn")
is_sale_gubn = dw_head.GetItemstring(1, "sale_gubn")

is_by_season = dw_head.GetItemstring(1, "by_season")

is_opt_brand = dw_head.GetItemstring(1, "opt_brand")
is_stock_mat = dw_head.GetItemstring(1, "stock_mat")

is_event_gubn = dw_head.GetItemstring(1, "event_gubn")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

      if is_sojae_gubn = "Y" then   // 소재별보기
				
				if cbx_1.checked then   // 메인 리오다 보기 
					if is_brand = 'B' or is_brand = 'L' then
							dw_body.dataObject = "d_61005_d13"  // SP_61005_D12
						dw_body.Object.DataWindow.HorizontalScrollSplit  = 886
						dw_print.dataObject = "d_61005_r13"
					else
						dw_body.dataObject = "d_61005_d12"  // SP_61005_D11
						dw_body.Object.DataWindow.HorizontalScrollSplit  = 886
						dw_print.dataObject = "d_61005_r12"
					end if
				else
					if is_brand = 'B' or is_brand = 'L' then
						dw_body.dataObject = "d_61005_d04"   // SP_61005_D02
						dw_body.Object.DataWindow.HorizontalScrollSplit  = 869
						dw_print.dataObject = "d_61005_r04"
					else
						dw_body.dataObject = "d_61005_d02"   // SP_61005_D01
						dw_body.Object.DataWindow.HorizontalScrollSplit  = 869
						dw_print.dataObject = "d_61005_r02"
					end if
				end if				
				dw_body.SetTransObject(SQLCA)
				dw_print.SetTransObject(SQLCA)		
		else 	
				If is_brand = 'B' or is_brand = 'L' then
					dw_body.dataObject = "d_61005_d03"   // SP_61005_D02
					dw_body.Object.DataWindow.HorizontalScrollSplit  = 685
					dw_body.SetTransObject(SQLCA)	
					
					dw_print.dataObject = "d_61005_r03"
					dw_print.SetTransObject(SQLCA)
				else
					dw_body.dataObject = "d_61005_d01"   // SP_61005_D01
					dw_body.Object.DataWindow.HorizontalScrollSplit  = 685
					dw_body.SetTransObject(SQLCA)	
					
					dw_print.dataObject = "d_61005_r01"
					dw_print.SetTransObject(SQLCA)
				end if
		end if	

If is_brand = 'B' or is_brand = 'L' then
	il_rows = dw_body.retrieve(is_brand, is_year_fr, is_year_to, is_season_fr, is_season_to, is_yymmdd, is_balju, is_ps_chn, is_sale_gubn, is_by_season, is_opt_brand, is_stock_mat, is_event_gubn)
else
	il_rows = dw_body.retrieve(is_brand, is_year_fr, is_year_to, is_season_fr, is_season_to, is_yymmdd, is_balju, is_ps_chn, is_sale_gubn, is_by_season, is_opt_brand, is_stock_mat)
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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
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
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title, ls_ps_chn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year_fr.Text = '" + is_year_fr + "'" + &
				 "t_season_fr.Text = '" + idw_season_fr.GetItemString(idw_Season_fr.GetRow(), "inter_display") + "'"   + &
				 "t_year_to.Text = '" + is_year_to + "'" + &
				 "t_season_to.Text = '" + idw_season_to.GetItemString(idw_Season_to.GetRow(), "inter_display") + "'"   + &
				 "t_yymmdd.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'"+ & 
             "t_balju.Text = '" + upper(is_balju) + "'" 
dw_print.Modify(ls_modify)

choose case is_ps_chn
	case 'A'	//전체
		ls_ps_chn = '전체'
	case 'K' //국내
		ls_ps_chn = '국내'
	case 'C' //중국
		ls_ps_chn = '중국'
end choose 
dw_print.object.t_chn.text = ls_ps_chn



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61005_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
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

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_61005_d
integer taborder = 110
end type

type cb_delete from w_com010_d`cb_delete within w_61005_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_61005_d
integer taborder = 50
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61005_d
end type

type cb_update from w_com010_d`cb_update within w_61005_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_61005_d
integer taborder = 70
boolean enabled = true
end type

type cb_preview from w_com010_d`cb_preview within w_61005_d
integer taborder = 80
boolean enabled = true
end type

type gb_button from w_com010_d`gb_button within w_61005_d
end type

type cb_excel from w_com010_d`cb_excel within w_61005_d
integer taborder = 90
boolean enabled = true
end type

type dw_head from w_com010_d`dw_head within w_61005_d
integer x = 9
integer y = 156
integer width = 3589
integer height = 264
string dataobject = "d_61005_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season_fr", idw_season_fr )
idw_season_fr.SetTransObject(SQLCA)
idw_season_fr.Retrieve('003', 'B', '%')

This.GetChild("season_to", idw_season_to )
idw_season_to.SetTransObject(SQLCA)
idw_season_to.Retrieve('003', 'B', '%')


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "sojae_gubn"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
      if data = "Y" then 
			dw_body.dataObject = "d_61005_d02"
			dw_body.SetTransObject(SQLCA)
			
			dw_print.dataObject = "d_61005_r02"
			dw_print.SetTransObject(SQLCA)
		else 	
			dw_body.dataObject = "d_61005_d01"
			dw_body.SetTransObject(SQLCA)	
			
			dw_print.dataObject = "d_61005_r01"
			dw_print.SetTransObject(SQLCA)
		end if	
		
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
      if data = "O" then 
			dw_head.object.opt_brand.visible = true
		else 	
			dw_head.object.opt_brand.visible = false
		end if			
		
		If data = 'B' or data = 'L' then
			dw_head.object.event_gubn.visible = true
			dw_head.object.t_6.visible = true
		else
			dw_head.object.event_gubn.visible = false
			dw_head.object.t_6.visible = false
		end if
		
		
		ls_year = this.getitemstring(row, "year_fr")	
		this.getchild("season_fr",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
		ls_year = this.getitemstring(row, "year_to")	
		this.getchild("season_to",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
		
  CASE  "year_fr"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season_fr",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		 		
  CASE  "year_to"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season_to",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
			
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_61005_d
integer beginy = 432
integer endy = 432
end type

type ln_2 from w_com010_d`ln_2 within w_61005_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_61005_d
integer y = 444
integer height = 1564
integer taborder = 40
string dataobject = "d_61005_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_61005_d
string dataobject = "d_61005_r02"
end type

type st_1 from statictext within w_61005_d
integer x = 64
integer y = 76
integer width = 402
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
string text = "※ VAT +"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_61005_d
integer x = 27
integer y = 288
integer width = 576
integer height = 60
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "메인,리오다별 보기"
borderstyle borderstyle = stylelowered!
end type

