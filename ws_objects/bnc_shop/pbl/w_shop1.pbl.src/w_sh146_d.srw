$PBExportHeader$w_sh146_d.srw
$PBExportComments$창고재고현황조회
forward
global type w_sh146_d from w_com010_d
end type
end forward

global type w_sh146_d from w_com010_d
integer width = 2939
integer height = 2032
end type
global w_sh146_d w_sh146_d

type variables
String is_fr_ymd, is_to_ymd, is_style_no, is_jup_gubn, is_year, is_season, is_brand, is_chno_gubn
DatawindowChild idw_year, idw_season, idw_brand
end variables

on w_sh146_d.create
call super::create
end on

on w_sh146_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;string ls_modify

dw_head.Setitem(1, "jup_gubn", "%")

dw_head.setitem(1, "brand", upper(MidA(gs_shop_cd,1,1)))
if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.setitem(1, "brand", 'N')
	gs_brand = 'N'
end if

//if mid(gs_shop_cd,3,4) <> '2000' then 
//	if mid(gs_shop_cd_1,1,2) <> 'XX' then
//		ls_modify =	'brand.protect = 1'
//		dw_head.Modify(ls_modify)
//	end if
//end if

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
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


is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"제품 브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if



is_style_no = dw_head.GetItemString(1, "style_no")
is_chno_gubn = dw_head.GetItemString(1, "chno_gubn")

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

if gs_brand = "O" or gs_brand = "D" then
	MessageBox(ls_title,"올리브, 미밍코 매장은 사용할 수 없습니다.")
	dw_head.SetFocus()
	dw_head.SetColumn("is_brand")
	return false	

end if	


if is_brand <> MidA(gs_shop_cd ,1,1) and (is_brand = "O"  or is_brand = "D" )then
	MessageBox(ls_title,"타브랜드 조회 불가능합니다."  )
	dw_head.SetFocus()
	dw_head.SetColumn("is_brand")
	return false	
end if	

//if is_brand <> mid(gs_shop_cd ,1,1) and gs_brand = "N" then
//	MessageBox(ls_title,"타브랜드 조회 불가능합니다."  )
//	dw_head.SetFocus()
//	dw_head.SetColumn("is_brand")
//	return false	
//end if	
//

return true
end event

event ue_retrieve();call super::ue_retrieve;string ls_shop_cd
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,  is_year, is_season, is_style_no, is_chno_gubn)

This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;
This.Trigger Event ue_retrieve()
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size  
Boolean    lb_check 
DataStore  lds_Source 

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

CHOOSE CASE as_column
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				RETURN 0 
			END IF
			ls_style = LeftA(as_data, 8)  
			ls_chno  = MidA(as_data,  9, 1)  
			ls_color = MidA(as_data, 10, 2)  
			ls_size  = MidA(as_data, 12, 2)  
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
			
			if gs_brand = "J" then
				gst_cd.default_where   = "WHERE brand in ('N','J') "
			else 	
				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' "
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno  + "%'"  + &
				                " and color LIKE '" + ls_color + "%'"  + &
				                " and size  LIKE '" + ls_size  + "%'"  
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

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
		      lb_check = TRUE 
				ib_itemchanged = FALSE
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_sh146_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh146_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_sh146_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh146_d
integer taborder = 30
end type

type cb_update from w_com010_d`cb_update within w_sh146_d
end type

type cb_print from w_com010_d`cb_print within w_sh146_d
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_sh146_d
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_sh146_d
end type

type dw_head from w_com010_d`dw_head within w_sh146_d
integer x = 0
integer y = 160
integer width = 2857
integer height = 144
integer taborder = 20
string dataobject = "d_sh146_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/
long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "style_no"	 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand", "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
//			gs_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
//			idw_season.insertrow(1)
//			idw_season.Setitem(1, "inter_cd", "%")
//			idw_season.Setitem(1, "inter_nm", "전체")
//			
		
			Trigger Event ue_retrieve()	
END CHOOSE

end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 
string ls_year
datetime ld_datetime
String   ls_filter_str = ''	


/*
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
*/
if MidA(gs_shop_cd_1,1,2) = 'XX' then	
	This.GetChild("brand", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve('001')
	ldw_child.InsertRow(1)
	ldw_child.SetItem(1, "inter_cd", '%')
	ldw_child.SetItem(1, "inter_nm", '전체')
	
	
	ls_filter_str = ''	
	ls_filter_str = "inter_cd in ('N','J') " 
	ldw_child.SetFilter(ls_filter_str)
	ldw_child.Filter( )
	
else
	This.GetChild("brand", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve('001')

	ls_filter_str = ''	
	ls_filter_str = "inter_cd in ('N','J') " 
	ldw_child.SetFilter(ls_filter_str)
	ldw_child.Filter( )
	
end if






This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

//라빠레트 시즌적용
SELECT GetDate()
  INTO :ld_datetime
  FROM DUAL ;

GF_CURR_YEAR(ld_datetime, ls_year)

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
//idw_season.retrieve('003', gs_brand, is_year)
idw_season.retrieve('003', gs_brand, ls_year)
//idw_season.retrieve('003')



end event

type ln_1 from w_com010_d`ln_1 within w_sh146_d
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_d`ln_2 within w_sh146_d
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_d`dw_body within w_sh146_d
integer y = 324
integer width = 2857
integer height = 1476
integer taborder = 40
string dataobject = "d_sh146_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_sh146_d
end type

