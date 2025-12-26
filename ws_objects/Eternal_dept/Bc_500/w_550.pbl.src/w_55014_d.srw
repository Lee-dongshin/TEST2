$PBExportHeader$w_55014_d.srw
$PBExportComments$특정스타일판매현황조회
forward
global type w_55014_d from w_com010_d
end type
type dw_color from datawindow within w_55014_d
end type
type dw_detail from datawindow within w_55014_d
end type
end forward

global type w_55014_d from w_com010_d
integer width = 3675
integer height = 2276
string title = "년도시즌별재고현황"
dw_color dw_color
dw_detail dw_detail
end type
global w_55014_d w_55014_d

type variables
DataWindowChild idw_brand, idw_color, idw_area_cd
string is_brand, is_yymmdd, is_style, is_chno, is_color, is_order_gubn, is_area_cd, is_color_yn

end variables

on w_55014_d.create
int iCurrent
call super::create
this.dw_color=create dw_color
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_color
this.Control[iCurrent+2]=this.dw_detail
end on

on w_55014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_color)
destroy(this.dw_detail)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title, ls_chno_yn

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

ls_chno_yn = dw_head.getitemstring(1, "chno_yn")

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
   MessageBox(ls_title,"제품번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style")
   return false
end if

is_chno = dw_head.GetItemString(1, "chno")
	if ls_chno_yn = "N" then
		if IsNull(is_chno) or Trim(is_chno) = "" then
			MessageBox(ls_title,"제품차수를 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("chno")
			return false
		end if
	else	
		is_chno = "%"
	end if	

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
	is_color = "%"
end if

is_order_gubn = dw_head.GetItemString(1, "order_gubn")
if IsNull(is_order_gubn) or Trim(is_order_gubn) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("order_gubn")
   return false
end if

is_area_cd = dw_head.GetItemString(1, "area_cd")
if IsNull(is_area_cd) or Trim(is_area_cd) = "" then
   MessageBox(ls_title,"지역구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("area_cd")
   return false
end if

is_color_yn = dw_head.GetItemString(1, "color_yn")
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_55014_d01 '20020611', 'n', 'nw2mj204','0','%','B', '%'


il_rows = dw_body.retrieve( is_yymmdd,is_brand, is_style, is_chno, is_color, is_order_gubn, is_area_cd, is_color_yn)
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

event ue_title;call super::ue_title;///*===========================================================================*/
///* 작성자      :                                                      */	
///* 작성일      : 2002..                                                  */	
///* 수정일      : 2002..                                                  */
///*===========================================================================*/
//
//datetime ld_datetime
//string ls_modify, ls_datetime
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
//					"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &					
//					"t_yymmdd.Text = '" + is_yymmdd + "'" + &										
//					"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 
//
//dw_print.Modify(ls_modify)
//
//
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_style, ls_chno ,ls_bujin_chk, ls_dep_ymd, ls_dep_seq
long		  ll_tag_price 	
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				if gs_brand <> 'K' then
					gst_cd.default_where   = " WHERE 1 = 1 "
				else
					gst_cd.default_where   = ""
				end if
				
				if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
					ELSE
						gst_cd.Item_where = ""
					END IF
				else
					gst_cd.Item_where = ""
				end if
				
				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
								
            ls_style = lds_Source.GetItemString(1,"style") 								
  				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'), isnull(tag_price,0)
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ll_tag_price
				from tb_12020_m
				where style = :ls_style;

  		if ls_bujin_chk = "Y" then 
			dw_head.setitem(1,"bujin_chk", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
		else	
			dw_head.setitem(1,"bujin_chk", "정상제품입니다!")
      end if 					
			dw_head.setitem(1,"tag_price", ll_tag_price)
			
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
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

event pfc_preopen();call super::pfc_preopen;dw_color.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55014_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55014_d
end type

type cb_delete from w_com010_d`cb_delete within w_55014_d
end type

type cb_insert from w_com010_d`cb_insert within w_55014_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55014_d
end type

type cb_update from w_com010_d`cb_update within w_55014_d
end type

type cb_print from w_com010_d`cb_print within w_55014_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_55014_d
end type

type gb_button from w_com010_d`gb_button within w_55014_d
end type

type cb_excel from w_com010_d`cb_excel within w_55014_d
end type

type dw_head from w_com010_d`dw_head within w_55014_d
integer y = 168
integer height = 304
string dataobject = "d_55014_h01"
end type

event dw_head::constructor;
THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


THIS.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%')
//idw_season.InsertRow(1)
//idw_season.SetItem(1, "inter_cd", '%')
//idw_season.SetItem(1, "inter_nm", '전체')



THIS.GetChild("area_cd", idw_area_cd)
idw_area_cd.SetTransObject(SQLCA)
idw_area_cd.Retrieve('090')

idw_area_cd.InsertRow(1)
idw_area_cd.SetItem(1, "inter_cd", '[01]')
idw_area_cd.SetItem(1, "inter_nm", '서울경기')

idw_area_cd.InsertRow(1)
idw_area_cd.SetItem(1, "inter_cd", '[^01]')
idw_area_cd.SetItem(1, "inter_nm", '서울경기제외')

idw_area_cd.InsertRow(1)
idw_area_cd.SetItem(1, "inter_cd", '%')
idw_area_cd.SetItem(1, "inter_nm", '전체')


end event

event dw_head::itemchanged;call super::itemchanged;string DWfilter, ls_style, ls_chno, ls_color, ls_type, ls_in_ymd, ls_out_ymd, ls_sale_ymd, ls_order_yn
long     i, j, ll_row_count, ll_row

CHOOSE CASE dwo.name
	CASE "style" 
//      IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//

	CASE "chno_yn" 
      ls_style = dw_head.getitemstring(row, "style")
		ls_chno  = dw_head.getitemstring(row, "chno")		
		
		if data = "Y" then
		ls_chno  = "%"	
		is_chno  = "%"	
   	end if
	
		il_rows = dw_color.retrieve(ls_style, ls_chno)
		
			if il_rows > 0 then
				FOR i=1 TO il_rows
					  if i = il_rows then
						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'"
					else
						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'" + " or "
					end if	  
				next	
					 DWfilter = ls_Type
			END IF
			  idw_color.SetFilter(DWfilter)
			  idw_color.Filter()
	   
	  
 
END CHOOSE


	
end event

type ln_1 from w_com010_d`ln_1 within w_55014_d
integer beginy = 484
integer endy = 484
end type

type ln_2 from w_com010_d`ln_2 within w_55014_d
integer beginy = 488
integer endy = 488
end type

type dw_body from w_com010_d`dw_body within w_55014_d
integer x = 9
integer y = 500
integer width = 3584
integer height = 1540
string dataobject = "d_55014_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;This.of_SetSort(false)

end event

event dw_body::doubleclicked;call super::doubleclicked;//   dw_detail.reset()
//	
//	IF is_style = "" OR isnull(is_style) THEN		
//		return
//	END IF
//
//IF is_chno = "" OR isnull(is_chno) THEN		
//		is_chno = '%'
//	END IF
//	
//IF dw_detail.RowCount() < 1 THEN 
//	il_rows = dw_detail.retrieve(is_style, is_chno)
//END IF 
//
//	dw_detail.visible = True
STRING LS_COLOR

LS_COLOR = this.getitemstring(row,"color")

// gf_style_color_pic(IS_STYLE, '%',left(ls_color,2))			
 gf_style_color_size_pic(IS_STYLE, '%',ls_color,'%','K')


end event

type dw_print from w_com010_d`dw_print within w_55014_d
integer x = 2437
integer y = 1560
string dataobject = "d_55014_r01"
end type

type dw_color from datawindow within w_55014_d
boolean visible = false
integer x = 2871
integer y = 896
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43006_d07"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_55014_d
boolean visible = false
integer x = 905
integer y = 80
integer width = 1819
integer height = 1884
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "스타일정보"
string dataobject = "d_style_pic"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

