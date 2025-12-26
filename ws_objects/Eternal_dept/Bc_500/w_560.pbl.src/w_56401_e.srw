$PBExportHeader$w_56401_e.srw
$PBExportComments$사은품관리
forward
global type w_56401_e from w_com010_e
end type
type dw_1 from datawindow within w_56401_e
end type
end forward

global type w_56401_e from w_com010_e
integer width = 3680
integer height = 2280
dw_1 dw_1
end type
global w_56401_e w_56401_e

type variables
DataWindowChild idw_brand, idw_year,idw_season, idw_color
string is_brand,  is_year, is_season, is_gubn

end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_shop_type, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price,  ll_cnt 

IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style[al_row - 1], as_style_no, ls_style, ls_chno) 
ELSE 
	ls_style = LeftA(as_style_no, 8)
END IF 


Select count(style), 
       max(style)  ,   max(chno), 
       max(brand)  ,   max(year),     max(season),     
       max(sojae)  ,   max(item),     max(tag_price)  
  into :ll_cnt     , 
       :ls_style   ,   :ls_chno, 
       :ls_brand   ,   :ls_year,      :ls_season, 
		 :ls_sojae   ,   :ls_item,      :ll_tag_price
  from vi_12020_1
 where style   like :ls_style 
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 


   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)

Return True

end function

on w_56401_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_56401_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_yymmdd, ls_style, ls_chno
Boolean    lb_check 
datetime ld_datetime
DataStore  lds_Source

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = string(ld_datetime, "YYYYMMDD")



CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
			IF ai_div = 1 THEN 	
			   IF wf_style_chk(al_row, as_data)  THEN
				   RETURN 2 
				END IF
			END IF
			
			IF al_row > 1 and LenA(Trim(as_data)) <> 9 THEN 
				gf_style_edit(dw_body.Object.style[al_row - 1], as_data, ls_style, ls_chno)
			ELSE
		      ls_style = MidA(as_data, 1, 8)
			end if	

				
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com011" 
				gst_cd.default_where   = " WHERE 1 = 1 "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				 
					dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_body.SetItem(al_row, "year",  lds_Source.GetItemString(1,"year"))
					dw_body.SetItem(al_row, "season",lds_Source.GetItemString(1,"season"))
					dw_body.SetItem(al_row, "brand", MidA(lds_Source.GetItemString(1,"style"),1,1))					
					
								
  					/* 다음컬럼으로 이동 */
					dw_body.SetItem(al_row, "given_ymd", ls_yymmdd)										  
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if is_gubn = 'G' then
	dw_1.retrieve(is_brand, is_year, is_season)  /* style master read */
end if	

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_gubn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

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
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_gubn = dw_head.GetItemString(1, "opt_gubn")

return true

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count,ll_row, ll_row2
datetime ld_datetime
STRING   ls_style, ls_brand, ls_year, ls_season, ls_given_fg, ls_given_ymd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	

   IF idw_status = NewModified! THEN				/* New Record */
		if is_gubn = 'G' then
			dw_body.Setitem(i, "reg_id", gs_user_id)
	
			ls_style     = dw_body.GetitemString(i, "style") 	
			ls_given_ymd = dw_body.GetitemString(i, "given_ymd") 	
			ll_row  = dw_1.Find("style = '" + ls_style + "'", 1, dw_1.RowCount())
	
			IF ll_row > 0 THEN 
					 dw_1.Setitem(ll_row, "given_fg" , "Y") 
					 dw_1.Setitem(ll_row, "given_ymd" , ls_given_ymd) 
					 dw_1.Setitem(ll_row, "mod_id", gs_user_id)
					 dw_1.Setitem(ll_row, "mod_dt", ld_datetime)		
			END IF
		else	
			dw_body.Setitem(i, "gubn", is_gubn)
			dw_body.Setitem(i, "reg_id", gs_user_id)
		
		end if		
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		if is_gubn = 'G' then
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
			
			ls_style   = dw_body.GetitemString(i, "style") 		
			ls_given_ymd = dw_body.GetitemString(i, "given_ymd") 	
			ll_row  = dw_1.Find("style = '" + ls_style + "'", 1, dw_1.RowCount())
	
			IF ll_row > 0 THEN 
					 dw_1.Setitem(ll_row, "given_fg" , "Y") 
					 dw_1.Setitem(ll_row, "given_ymd" , ls_given_ymd) 
					 dw_1.Setitem(ll_row, "mod_id", gs_user_id)
					 dw_1.Setitem(ll_row, "mod_dt", ld_datetime)		
			END IF		
		else			
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)	
		
		end if	
		
   END IF

		


NEXT

il_rows = dw_body.Update()
if is_gubn = 'G' then 
	il_rows = dw_1.Update()
end if	

if il_rows = 1 then
	dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56401_e","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event ue_insert();long ll_row_cnt

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
	ll_row_cnt = dw_1.rowcount()
   dw_1.retrieve(is_brand, is_year, is_season)		
END IF


 
il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete();long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

IF idw_status = NotModified! OR idw_status = DataModified! THEN
	RETURN 
END IF 

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)
end event

type cb_close from w_com010_e`cb_close within w_56401_e
end type

type cb_delete from w_com010_e`cb_delete within w_56401_e
end type

type cb_insert from w_com010_e`cb_insert within w_56401_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56401_e
end type

type cb_update from w_com010_e`cb_update within w_56401_e
end type

type cb_print from w_com010_e`cb_print within w_56401_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56401_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56401_e
end type

type cb_excel from w_com010_e`cb_excel within w_56401_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56401_e
integer y = 200
integer height = 192
string dataobject = "d_56401_h01"
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
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

type ln_1 from w_com010_e`ln_1 within w_56401_e
end type

type ln_2 from w_com010_e`ln_2 within w_56401_e
end type

type dw_body from w_com010_e`dw_body within w_56401_e
string dataobject = "d_56401_d01"
end type

event dw_body::constructor;
  This.GetChild("color", idw_color )
  idw_color.SetTransObject(SQLCA)
  idw_color.Retrieve('%')

end event

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "style" 
      IF ib_itemchanged THEN RETURN 1
      return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE


	
end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		if ls_style <> "" then		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_e`dw_print within w_56401_e
end type

type dw_1 from datawindow within w_56401_e
boolean visible = false
integer x = 1650
integer y = 616
integer width = 1883
integer height = 536
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_56401_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

