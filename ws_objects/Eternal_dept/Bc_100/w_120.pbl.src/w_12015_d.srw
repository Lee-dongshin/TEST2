$PBExportHeader$w_12015_d.srw
$PBExportComments$출고차순조회
forward
global type w_12015_d from w_com010_d
end type
type dw_1 from datawindow within w_12015_d
end type
end forward

global type w_12015_d from w_com010_d
integer width = 3689
integer height = 2260
dw_1 dw_1
end type
global w_12015_d w_12015_d

type variables
DataWindowChild idw_brand, idw_season, idw_out_seq
String is_brand, is_year, is_season, is_out_seq, is_sort_fg, is_style, is_chno, is_out_seq1
decimal idc_models, idc_ord_qty 
end variables

forward prototypes
public function long wf_body_set (long al_rows)
end prototypes

public function long wf_body_set (long al_rows);/* dw_body에 dw_1에서 조회된 data를 셋팅 */
Long i, ll_col_cnt = 0, ll_rows
ll_rows = dw_body.InsertRow(0)
For i = 1 To al_rows
	ll_col_cnt++
	If ll_col_cnt > 5    Then
		ll_rows = dw_body.InsertRow(0)
		If ll_rows <= 0 Then Return -1
		ll_col_cnt = 1
	End If
	dw_body.SetItem(ll_rows, "style" + String(ll_col_cnt), dw_1.GetItemString(i, "style"))
	dw_body.SetItem(ll_rows, "chno" + String(ll_col_cnt), dw_1.GetItemString(i, "chno"))
	dw_body.SetItem(ll_rows, "style_pic" + String(ll_col_cnt), dw_1.GetItemString(i, "style_pic"))
	dw_body.SetItem(ll_rows, "mat_nm" + String(ll_col_cnt), dw_1.GetItemString(i, "mat_nm"))	
	dw_body.SetItem(ll_rows, "cust_nm" + String(ll_col_cnt), dw_1.GetItemString(i, "cust_nm"))	
	dw_body.SetItem(ll_rows, "tag_price" + String(ll_col_cnt), dw_1.GetItemdecimal(i,"tag_price"))
	dw_body.SetItem(ll_rows, "ord_ymd" + String(ll_col_cnt), dw_1.GetItemString(i, "ord_ymd"))
	dw_body.SetItem(ll_rows, "dlvy_ymd" + String(ll_col_cnt), dw_1.GetItemString(i, "dlvy_ymd"))	
	dw_body.SetItem(ll_rows, "out_ymd" + String(ll_col_cnt), dw_1.GetItemString(i, "out_ymd"))	

Next

Return ll_rows


end function

on w_12015_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_12015_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_out_seq

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_brand,is_year,is_season,is_out_seq,is_sort_fg, is_style, is_chno)
dw_body.Reset()

dw_body.SetRedraw(False)
IF il_rows > 0 THEN
	If wf_body_set(il_rows) <= 0 Then 
		MessageBox("조회오류", "데이터 셋팅에 실패 하였습니다.")
		il_rows = -1
	Else
		This.Trigger Event ue_title()		
		
		select count(distinct a.style) 	as models,
					isnull(sum(isnull(a.ord_qty, a.plan_qty)),0)			as ord_qty 	
		into :idc_models, :idc_ord_qty
		from tb_12030_s a(nolock), tb_12028_d b(nolock)
		where a.style    =* b.style
		and   a.chno     =* b.chno
		and   b.brand    = :is_brand
		and   b.year     = :is_year
		and   b.season   like :is_season  + '%'
		and   b.out_seq  like :is_out_seq + '%'
		and   a.style    like :is_style + '%'
		and   a.chno     like :is_chno + '%'	
		AND   A.STYLE    LIKE :IS_BRAND + '%';
	
		dw_body.object.t_models.text = string(idc_models,"#,##0")
		dw_body.object.t_ord_qty.text = string(idc_ord_qty,"#,##0")
		
		
		if is_style <> "%" then
			select (select b.inter_nm
						FROM TB_91011_C b (nolock)
						WHERE b.INTER_GRP = '032'
						  AND b.INTER_CD  = a.out_seq)
			into :is_out_seq1				  
			from tb_12028_d a
			where a.style = :is_style
			and   a.chno  = :is_chno;
  	  else
			is_out_seq1 = idw_out_seq.GetItemString(idw_out_seq.GetRow(), "inter_display")
	  end if	
	  
	   dw_body.object.t_out_seq.text = is_out_seq1
		
	   dw_body.SetFocus()
	End If
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF
dw_body.SetRedraw(True)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
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
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_out_seq = Trim(dw_head.GetItemString(1, "out_seq"))
if IsNull(is_out_seq) or is_out_seq = "" then
   MessageBox(ls_title,"출고차순을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_seq")
   return false
end if

is_sort_fg = Trim(dw_head.GetItemString(1, "sort_fg"))
if IsNull(is_sort_fg) or is_sort_fg = "" then
   MessageBox(ls_title,"조회순서를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sort_fg")
   return false
end if

is_style = Trim(dw_head.GetItemString(1, "style"))
if IsNull(is_style) or is_style = "" then
	is_style = "%"
end if

is_chno = Trim(dw_head.GetItemString(1, "chno"))
if IsNull(is_chno) or is_chno = "" then
	is_chno = "%"
end if



return true

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.19                                                  */	
/* 수정일      : 2002.01.19                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_sale_type, ls_sort_fg, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


If is_sort_fg = '1' Then
	ls_sort_fg = '코드순 '
ElseIf is_sort_fg = '2' Then
	ls_sort_fg = '복종순'
End If

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id + "'" + &
            "t_user_id.Text   = '" + gs_user_id + "'" + &
            "t_datetime.Text  = '" + ls_datetime + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text      = '" + is_year + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_out_seq.Text     = '" + is_out_seq1 + "'" + &
            "t_sort_fg.Text   = '" + ls_sort_fg + "'"

dw_print.Modify(ls_modify)


end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12015_d","0")
end event

event ue_preview();
	
	/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.object.t_models.text = string(idc_models,"#,##0")
dw_print.object.t_ord_qty.text = string(idc_ord_qty,"#,##0")
	
dw_print.inv_printpreview.of_SetZoom()

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/
String     ls_style_no, ls_out_seq, ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
			IF ai_div = 1 THEN 	
			
			END IF
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = ""		//WHERE TB_11010_M.PART_FG IN ('1', '2', '3') 
				
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" +  LeftA(as_data, 8) + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" +  LeftA(as_data, 8) + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if	
			
//				IF Trim(as_data) <> "" THEN
//					gst_cd.Item_where = " STYLE LIKE '" + Left(as_data, 8) + "%' "
//				ELSE
//					gst_cd.Item_where = ""
//				END IF
//
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)

				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))

				ls_style =  lds_Source.GetItemString(1,"style")
				ls_chno  =  lds_Source.GetItemString(1,"chno") 

				select a.out_seq
				into :ls_out_seq				  
				from tb_12028_d a
				where a.style = :ls_style
				and   a.chno  = :ls_chno;			

				dw_head.SetItem(al_row, "out_seq", ls_out_seq )
				
				/* 다음컬럼으로 이동 */
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

type cb_close from w_com010_d`cb_close within w_12015_d
end type

type cb_delete from w_com010_d`cb_delete within w_12015_d
end type

type cb_insert from w_com010_d`cb_insert within w_12015_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12015_d
end type

type cb_update from w_com010_d`cb_update within w_12015_d
end type

type cb_print from w_com010_d`cb_print within w_12015_d
end type

type cb_preview from w_com010_d`cb_preview within w_12015_d
end type

type gb_button from w_com010_d`gb_button within w_12015_d
end type

type cb_excel from w_com010_d`cb_excel within w_12015_d
end type

type dw_head from w_com010_d`dw_head within w_12015_d
integer x = 5
integer y = 156
integer width = 3328
integer height = 212
string dataobject = "d_12015_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
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
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")


This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('032')
idw_out_seq.InsertRow(1)
idw_out_seq.Setitem(1, "inter_cd", "%")
idw_out_seq.Setitem(1, "inter_nm", "전체")






end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand", "year"
		dw_head.accepttext()
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
		
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
		
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) = 0 then
			dw_head.setitem(1, "chno", "" )
			dw_head.setitem(1, "style", "" )
			return 2
		else	
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if
	
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_12015_d
integer beginy = 400
integer endy = 400
end type

type ln_2 from w_com010_d`ln_2 within w_12015_d
integer beginy = 404
integer endy = 404
end type

type dw_body from w_com010_d`dw_body within w_12015_d
integer x = 14
integer y = 412
integer height = 1604
string dataobject = "d_12015_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_12015_d
integer x = 658
integer y = 596
string dataobject = "d_12015_r01"
end type

type dw_1 from datawindow within w_12015_d
boolean visible = false
integer x = 635
integer y = 764
integer width = 1353
integer height = 500
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12015_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

