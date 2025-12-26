$PBExportHeader$w_43026_e.srw
$PBExportComments$실사차이수량 수정
forward
global type w_43026_e from w_com010_e
end type
type dw_detail from datawindow within w_43026_e
end type
type st_1 from statictext within w_43026_e
end type
end forward

global type w_43026_e from w_com010_e
integer width = 3675
integer height = 2276
dw_detail dw_detail
st_1 st_1
end type
global w_43026_e w_43026_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_shop_type
string is_brand, is_shop_cd, is_shop_type, is_style, is_chno
string is_year, is_season, is_silsa_yymmdd, is_base_yymmdd
string is_style_opt, is_wonga_enabled, is_opt_visible

end variables

on w_43026_e.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.st_1
end on

on w_43026_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.st_1)
end on

event pfc_preopen();call super::pfc_preopen;dw_detail.SetTransObject(SQLCA)
end event

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "shop_type", '1')
dw_head.SetItem(1, "base_yymmdd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "silsa_yymmdd",string(ld_datetime, "yyyymmdd"))

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43026_d","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
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


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
is_year = "%"
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
is_season = "%"
end if

is_silsa_yymmdd = dw_head.GetItemString(1, "silsa_yymmdd")
if IsNull(is_silsa_yymmdd) or Trim(is_silsa_yymmdd) = "" then
   MessageBox(ls_title,"실사일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("silsa_yymmdd")
   return false
end if

is_base_yymmdd = dw_head.GetItemString(1, "base_yymmdd")
if IsNull(is_base_yymmdd) or Trim(is_base_yymmdd) = "" then
   MessageBox(ls_title,"재고 기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("base_yymmdd")
   return false
end if


if is_brand <> MidA(is_shop_cd,1,1) then
	MessageBox(ls_title,"매장과 브랜드가 다릅니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_style_opt = "X"
is_opt_visible = "Y"
is_wonga_enabled = "N"

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm
DataStore  lds_Source
Boolean    lb_check 

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
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' or shop_nm like  '%" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("cust_type")
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

st_1.text = ""

il_rows = dw_body.retrieve(is_base_yymmdd, is_silsa_yymmdd, is_brand, is_shop_cd, is_shop_type, is_year, is_season,  is_style_opt,is_opt_visible)

IF il_rows > 0 THEN
   dw_body.SetFocus()
	cb_update.enabled = true
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
string ls_modify, ls_datetime, ls_yearseason
					  
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	   "t_pg_id.Text = '" + is_pgm_id + "'" + &
               "t_user_id.Text = '" + gs_user_id + "'" + &
               "t_datetime.Text = '" + ls_datetime + "'" + &
               "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_year.Text = '" +  idw_year.GetItemString(idw_year.GetRow(), "inter_nm") + "'" + &					
					"t_season.Text = '" +  idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &										
					"t_silsa_yymmdd.Text = '" + String(is_silsa_yymmdd, '@@@@/@@/@@') + "'" + &										
					"t_yymmdd.Text = '" + String(is_base_yymmdd, '@@@@/@@/@@') + "'" + &															
					"t_shop_cd.Text = '" + is_shop_cd + "'"  + &
					"t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" 					

dw_print.Modify(ls_modify)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_stock_qty, ll_sil_qty, ll_qty, ll_cnt
datetime ld_datetime
String ls_style, ls_chno, ls_color, ls_size, ls_out_no


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

select count(out_no)
into :ll_cnt
from tb_42021_h (nolock)
where yymmdd    = :is_silsa_yymmdd
and   shop_cd   = :is_shop_cd
and   shop_type = :is_shop_type
and   house_cd  = '460000'
and   rqst_gubn = 'T';

if ll_cnt > 0  then
   MessageBox("알림!","동일날짜에 실사결과 처리 전표가 존재합니다! 확인바랍니다.")

end if

st_1.text = "전표발행 작업이 진행 중 입니다!"
FOR i=1 TO ll_row_count
	dw_body.ScrollToRow(i)
	dw_body.selectrow(i,TRUE)	
	ls_style = dw_body.GetItemString(i, "style")
	ls_chno  = dw_body.GetItemString(i, "chno")
	ls_color = dw_body.GetItemString(i, "color")	
	ls_size  = dw_body.GetItemString(i, "size")		
	ll_stocK_qty = dw_body.GetItemNumber(i, "stock_qty")		
	ll_sil_qty   = dw_body.GetItemNumber(i, "sil_qty")			
	
	ll_qty = ll_stock_qty - ll_sil_qty
	
	 DECLARE sp_43026_proc PROCEDURE FOR sp_43026_proc  
         @BRAND     = :is_brand,   
         @yymmdd    = :is_silsa_yymmdd,   
         @shop_cd   = :is_shop_cd,   
         @shop_type = :is_shop_type,   
         @style     = :ls_style,   
         @chno      = :ls_chno,   
         @color     = :ls_color,   
         @size      = :ls_size,   
         @qty       = :ll_qty,   
         @reg_id    = :gs_user_id  ;

		 EXECUTE sp_43026_proc;
			IF SQLCA.SQLCODE = -1 THEN 
				rollback  USING SQLCA;
				MessageBox("SQL오류", SQLCA.SqlErrText) 
				Return -1 
			ELSE
				commit  USING SQLCA;
				 il_rows = 1 
			END IF 		
	dw_body.selectrow(i,false)	
NEXT

select max(out_no)
into :ls_out_no
from tb_42021_h (nolock)
where yymmdd    = :is_silsa_yymmdd
and   shop_cd   = :is_shop_cd
and   shop_type = :is_shop_type
and   house_cd  = '460000'
and   rqst_gubn = 'T';


st_1.text = "전표번호 " + ls_out_no + " 로 발행 되었습니다!"
messagebox("알림!", "전표발행 작업이 완료 되었습니다!")


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
			cb_update.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

//      if al_rows >= 0 then
//         ib_changed = false
//         cb_update.enabled = false
//      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_43026_e
end type

type cb_delete from w_com010_e`cb_delete within w_43026_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_43026_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_43026_e
end type

type cb_update from w_com010_e`cb_update within w_43026_e
end type

type cb_print from w_com010_e`cb_print within w_43026_e
end type

type cb_preview from w_com010_e`cb_preview within w_43026_e
end type

type gb_button from w_com010_e`gb_button within w_43026_e
end type

type cb_excel from w_com010_e`cb_excel within w_43026_e
end type

type dw_head from w_com010_e`dw_head within w_43026_e
integer y = 164
integer height = 196
string dataobject = "d_43026_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

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

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

   CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand", "year"		
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

END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_43026_e
integer beginy = 368
integer endy = 368
end type

type ln_2 from w_com010_e`ln_2 within w_43026_e
integer beginy = 372
integer endy = 372
end type

type dw_body from w_com010_e`dw_body within w_43026_e
integer y = 384
integer height = 1656
string dataobject = "d_43026_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_style
   
	
dw_detail.reset()
ls_style =  dw_body.GetitemString(row,"style")	
is_style = MidA(ls_style,1,8)

if LenA(is_style) > 9 then
	is_chno  =  MidA(is_style,10,1)
end if

IF is_style = "" OR isnull(is_style) THEN		
	return
END IF

IF is_chno = "" OR isnull(is_chno) THEN		
		is_chno = '%'
	END IF
	
IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.retrieve(is_style, is_chno)
	
END IF 

dw_detail.visible = True

end event

type dw_print from w_com010_e`dw_print within w_43026_e
end type

type dw_detail from datawindow within w_43026_e
boolean visible = false
integer x = 1225
integer y = 400
integer width = 1861
integer height = 1692
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "품번정보"
string dataobject = "d_style_pic"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_43026_e
integer x = 389
integer y = 52
integer width = 1019
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
boolean focusrectangle = false
end type

