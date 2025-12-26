$PBExportHeader$w_53013_d.srw
$PBExportComments$타브랜드 매출현황(월)
forward
global type w_53013_d from w_com010_d
end type
type dw_1 from datawindow within w_53013_d
end type
end forward

global type w_53013_d from w_com010_d
integer width = 3675
integer height = 2276
dw_1 dw_1
end type
global w_53013_d w_53013_d

type variables
datawindowchild idw_brand
string is_brand, is_fr_yymm, is_to_yymm, is_shop_cd, is_opt_cnt
end variables

on w_53013_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_53013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

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

is_opt_cnt = dw_head.GetItemString(1, "opt_cnt")
if IsNull(is_opt_cnt) or Trim(is_opt_cnt) = "" then
   MessageBox(ls_title,"등락구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_cnt")
   return false
end if

is_fr_yymm    = dw_head.GetItemString(1, "fr_yymm")
is_to_yymm    = dw_head.GetItemString(1, "to_yymm")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymm, is_to_yymm, is_shop_cd, is_opt_cnt)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	il_rows = dw_1.retrieve(is_brand, is_fr_yymm, is_to_yymm, is_shop_cd,'%')
	if il_rows > 0 then	
		dw_1.object.gr_1.title = dw_head.getitemstring(1,"shop_nm")
		dw_1.visible = true
		
	end if
		
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_78, ls_79

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

//if is_brand = "N" then
//	ls_78 = "부장"
//	ls_79 = "이사"
//elseif is_brand = "O" then
//	ls_78 = "차장"
//	ls_79 = "이사"	
//else
//	ls_78 = "차장"
//	ls_79 = "이사"	
//end if	

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


if is_opt_cnt = "Y" then
	ls_modify =	"t_pg_id.Text 		= '" + is_pgm_id 	 + "'" + &
					 "t_user_id.Text 	= '" + gs_user_id  + "'" + &
					 "t_datetime.Text = '" + ls_datetime + "'" + &
					 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_nm") + "'" + &
					 "t_yymm.Text 		= '" + is_fr_yymm + "-" + is_to_yymm	 + "'" + &
					 "t_shop_cd.Text 	= '" + is_shop_cd  + "'" 
//					 + &
//					 "t_78.text        = '" + ls_78 + "'" + &
//					 "t_79.text        = '" + ls_79 + "'"  
else					 
	ls_modify =	"t_pg_id.Text 		= '" + is_pgm_id 	 + "'" + &
					 "t_user_id.Text 	= '" + gs_user_id  + "'" + &
					 "t_datetime.Text = '" + ls_datetime + "'" + &
					 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_nm") + "'" + &
					 "t_yymm.Text 		= '" + is_fr_yymm + "-" + is_to_yymm	 + "'" + &
					 "t_shop_cd.Text 	= '" + is_shop_cd  + "'" 
//					 + &
//					 "t_78.text        = '" + ls_78 + "'" + &
//					 "t_79.text        = '" + ls_79 + "'" + &
//					 "t_37.text        = ' ' " 
end if					 
dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_flag, ls_age_grp, ls_jumin 
String     ls_style,   ls_chno, ls_data 
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_DIV")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
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

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymm",LeftA(string(ld_datetime,"yyyymmdd"),4))
end if


inv_resize.of_Register(dw_1, "FixedToBottom")
dw_1.width = dw_body.width
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)


end event

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 955
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_53013_d
end type

type cb_delete from w_com010_d`cb_delete within w_53013_d
end type

type cb_insert from w_com010_d`cb_insert within w_53013_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53013_d
end type

type cb_update from w_com010_d`cb_update within w_53013_d
end type

type cb_print from w_com010_d`cb_print within w_53013_d
end type

type cb_preview from w_com010_d`cb_preview within w_53013_d
end type

type gb_button from w_com010_d`gb_button within w_53013_d
end type

type cb_excel from w_com010_d`cb_excel within w_53013_d
end type

type dw_head from w_com010_d`dw_head within w_53013_d
integer y = 168
integer height = 152
string dataobject = "d_53013_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')


end event

type ln_1 from w_com010_d`ln_1 within w_53013_d
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com010_d`ln_2 within w_53013_d
integer beginy = 344
integer endy = 344
end type

type dw_body from w_com010_d`dw_body within w_53013_d
integer y = 356
integer height = 1684
string dataobject = "d_53013_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;string ls_shop_cd
if row > 0 then
	ls_shop_cd = this.getitemstring(row,"shop_cd")
	il_rows = dw_1.retrieve(is_brand, is_fr_yymm, is_to_yymm, ls_shop_cd,'%')
	if il_rows > 0 then 
		dw_1.object.gr_1.title = dw_body.getitemstring(row,"shop_nm")
		dw_1.visible = true
	end if
		
end if
end event

type dw_print from w_com010_d`dw_print within w_53013_d
integer x = 1403
integer y = 392
string dataobject = "d_53013_r04"
end type

type dw_1 from datawindow within w_53013_d
boolean visible = false
integer x = 14
integer y = 1304
integer width = 3575
integer height = 736
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "타브랜드 매출현황(단위: 만원)"
string dataobject = "d_53013_d02"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

