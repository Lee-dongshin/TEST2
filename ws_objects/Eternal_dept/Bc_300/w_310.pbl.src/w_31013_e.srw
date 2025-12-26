$PBExportHeader$w_31013_e.srw
$PBExportComments$QC 등록
forward
global type w_31013_e from w_com010_e
end type
type st_1 from statictext within w_31013_e
end type
type cb_reorder from commandbutton within w_31013_e
end type
end forward

global type w_31013_e from w_com010_e
integer width = 3675
integer height = 2248
st_1 st_1
cb_reorder cb_reorder
end type
global w_31013_e w_31013_e

type variables
string is_brand, is_year, is_season, is_item , is_yymmdd
datawindowchild idw_brand, idw_season, idw_item
end variables

on w_31013_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_reorder=create cb_reorder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_reorder
end on

on w_31013_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_reorder)
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

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item = dw_head.GetItemString(1, "item")
is_yymmdd = dw_head.GetItemString(1, "yymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, gs_user_id)
IF il_rows > 0 THEN
	dw_body.setrow(il_rows)
   dw_body.SetFocus()
	dw_body.setcolumn("style")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)



end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()

	
   commit  USING SQLCA;
	
else
   rollback  USING SQLCA;
end if
//post event ue_retrieve()

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows



end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_brand, ls_cust_nm , ls_message
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
		CASE "cust_cd"							// 거래처 코드
			ls_brand = dw_body.getitemstring(al_row,"style")
			ls_brand = LeftA(ls_brand,1)
			
			IF ai_div = 1 THEN 	
				if isnull(as_data) or trim(as_data) = "" then
					dw_body.object.ord_qc_dt_yn.visible = false
					RETURN 0
				end if	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_body.SetItem(al_row, "cust_nm", ls_cust_nm)
					dw_body.object.ord_qc_dt_yn.visible = true
					RETURN 0
				END IF 
			END IF
				
				gst_cd.window_title    = "생산처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9000' "
				IF Trim(as_data) <> "" THEN
//					ls_message = " CustCode LIKE ~'" + as_data + "%~'  or cust_sname like ~'" + as_data + "%~' "
//					messagebox("", ls_message)
					
					gst_cd.Item_where = " (CustCode LIKE '%" + as_data + "%'  or cust_sname like '%" + as_data + "%') "

				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
					dw_body.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_body.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_Name"))
					dw_body.object.ord_qc_dt_yn.visible = true
					/* 다음컬럼으로 이동 */
					dw_body.SetColumn("mat_nm")
					ib_itemchanged = False
				else
					dw_body.object.ord_qc_dt_yn.visible = false
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm") + "'" + &
				 "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + is_season + ' ' + idw_season.getitemstring(idw_season.getrow(),"inter_nm") + "'" + &
				 "t_item.Text = '" + is_item + ' ' + idw_item.getitemstring(idw_item.getrow(),"item_nm") + "'" 
dw_print.Modify(ls_modify)


end event

event ue_insert();call super::ue_insert;	dw_body.Setitem(dw_body.rowcount(), "gubn", "1")
	dw_body.setrow(dw_body.rowcount())
   dw_body.SetFocus()
	dw_body.setcolumn("style")
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31013_e","0")
end event

event ue_preview();This.Trigger Event ue_title ()


dw_print.Object.DataWindow.Print.Orientation	 = 1
dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()
end event

event open;call super::open;string ls_level
dw_head.setitem(1,"brand",gs_brand)
trigger event ue_retrieve()

//select '1'
//	into :ls_level
//from tb_93013_d 
//where work_gbn = '2'
//and   person_id = :gs_user_id
//and   user_level like '%1%';
//
//
//if ls_level = '1' then 
//	cb_insert.visible = true
//	cb_delete.visible = true
//
//end if


dw_body.Object.DataWindow.HorizontalScrollSplit  = 1110
end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
end if

end event

event ue_delete();call super::ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

if idw_status = New! or idw_status = NewModified! then
	il_rows = dw_body.DeleteRow (ll_cur_row)
	dw_body.SetFocus()
else
	messagebox("확인","기존 데이타는 삭제할 수 없습니다..")
end if

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_31013_e
end type

type cb_delete from w_com010_e`cb_delete within w_31013_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_31013_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_31013_e
end type

type cb_update from w_com010_e`cb_update within w_31013_e
end type

type cb_print from w_com010_e`cb_print within w_31013_e
integer width = 549
boolean enabled = true
string text = "CAD실 업무일지(&P)"
end type

event cb_print::clicked;
dw_print.dataobject = "d_31013_r02"
dw_print.SetTransObject(SQLCA)

dw_print.retrieve(is_yymmdd)
//dw_print.retrieve('20030725')
dw_print.object.t_title.text = 'CAD실 업무 일지 (' + is_yymmdd + ')'
dw_print.Object.DataWindow.Print.Orientation	 = 2
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_preview from w_com010_e`cb_preview within w_31013_e
integer x = 1979
integer width = 370
boolean enabled = true
end type

event cb_preview::clicked;dw_print.dataobject = "d_31013_r01"
dw_print.SetTransObject(SQLCA)

Parent.Trigger Event ue_preview()
end event

type gb_button from w_com010_e`gb_button within w_31013_e
end type

type cb_excel from w_com010_e`cb_excel within w_31013_e
integer x = 2514
integer y = 48
end type

type dw_head from w_com010_e`dw_head within w_31013_e
integer y = 180
integer height = 136
string dataobject = "d_31013_h01"
boolean livescroll = false
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve()
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

end event

type ln_1 from w_com010_e`ln_1 within w_31013_e
boolean visible = false
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com010_e`ln_2 within w_31013_e
boolean visible = false
integer beginy = 344
integer endy = 344
end type

type dw_body from w_com010_e`dw_body within w_31013_e
event type long ue_style_chk ( string as_style,  long as_row )
event ue_date ( long as_row,  string as_field_nm,  string as_date )
event ue_dt_set ( long al_row,  string as_fld_nm,  string as_data )
integer y = 332
integer height = 1680
string dataobject = "d_31013_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event type long dw_body::ue_style_chk(string as_style, long as_row);string ls_brand, ls_year, ls_season, ls_item, ls_sojae
long 	 ll_ret

ll_ret = 0


select top 1 brand, year, season, sojae, item, 1 
	into :ls_brand, :ls_year, :ls_season, :ls_sojae, :ls_item, :ll_ret
from tb_31030_m (nolock)
where style = :as_style
and   chno in ('0','s');


if isnull(ls_brand) or ls_brand = '' then
	ls_brand  = LeftA(as_style,1)
	ls_sojae  = MidA(as_style,2,1)
	ls_year   = '200' + MidA(as_style,3,1)
	ls_season = MidA(as_style,4,1)
	ls_item   = MidA(as_style,5,1)
	
	ll_ret = 1
end if
	

dw_body.setitem(as_row, "brand" , ls_brand )
dw_body.setitem(as_row, "year"  , ls_year  )
dw_body.setitem(as_row, "season", ls_season)
dw_body.setitem(as_row, "sojae" , ls_sojae )
dw_body.setitem(as_row, "item"  , ls_item  )

return ll_ret


end event

event dw_body::ue_date(long as_row, string as_field_nm, string as_date);this.setitem(as_row,as_field_nm,as_date)
end event

event dw_body::ue_dt_set;string ls_date, ls_temp, ls_null
datetime ld_datetime

setnull(ls_null)
IF this.AcceptText() <> 1 THEN RETURN

as_fld_nm = LeftA(as_fld_nm , LenA(as_fld_nm) -3)


if as_data = 'N' then 
	SetNull(ls_date)
	dw_body.setitem(al_row, as_fld_nm, ls_date)
else 
		
	IF gf_cdate(ld_datetime,0)  THEN  
		//ls_date = string(this.getitemdatetime(1,"today"))

		select convert(char(16),getdate(),121) into :ls_date from dual;
	
	end if

	
	ls_temp = dw_body.getitemstring(al_row, as_fld_nm, Primary!, TRUE)
	if ls_temp = '' or isnull(ls_temp) then	
		dw_body.setitem(al_row, as_fld_nm, ls_date)
	else 			
		dw_body.setitem(al_row, as_fld_nm, ls_temp)
	end if
	

	if as_fld_nm = "re_qc_dt" then 	//재QC때 QC입고 리셋
		dw_body.setitem(al_row, "in_qc_dt_yn", ls_null )	
		dw_body.setitem(al_row, "in_qc_dt", ls_null )	
		dw_body.setitem(al_row, "qc_fix_dsn_yn", ls_null )	
		dw_body.setitem(al_row, "qc_fix_dsn", ls_null )	
		dw_body.setitem(al_row, "qc_fix_yn", ls_null )	
		dw_body.setitem(al_row, "qc_fix", ls_null )	
		
	end if

end if





end event

event dw_body::itemchanged;call super::itemchanged;string ls_date, ls_year
datetime ld_datetime

CHOOSE CASE dwo.name
	CASE "style" 
		if trigger event ue_style_chk(data, row) = 0 then return 1
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
				
	case "mmat_dt_yn", "smat_dt_yn", "ord_qc_dt_yn", "re_qc_dt_yn", "in_qc_dt_yn", "qc_fix_dsn_yn", "qc_fix_yn", "cading_dt_yn", "cad_dt_yn"
		post event  ue_dt_set(row, string(dwo.name), data)
		
END CHOOSE




end event

event dw_body::constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)
end event

type dw_print from w_com010_e`dw_print within w_31013_e
integer x = 142
integer y = 592
string dataobject = "d_31013_r02"
end type

type st_1 from statictext within w_31013_e
integer x = 1600
integer y = 264
integer width = 672
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
string text = "(Y:완료, H:진행, X:대기)"
boolean focusrectangle = false
end type

type cb_reorder from commandbutton within w_31013_e
integer x = 699
integer y = 44
integer width = 402
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "리오더추가"
end type

event clicked;Parent.Trigger Event ue_insert()
end event

