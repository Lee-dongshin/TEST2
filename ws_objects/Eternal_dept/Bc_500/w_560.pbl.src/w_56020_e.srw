$PBExportHeader$w_56020_e.srw
$PBExportComments$기획/행사재고처리
forward
global type w_56020_e from w_com010_e
end type
type st_1 from statictext within w_56020_e
end type
end forward

global type w_56020_e from w_com010_e
integer width = 3675
integer height = 2276
st_1 st_1
end type
global w_56020_e w_56020_e

type variables
DataWindowChild idw_brand, idw_shop_type, idw_year, idw_season, idw_color, idw_size, idw_house_cd
String  is_brand, is_shop_cd, is_shop_type, is_frm_ymd, is_to_ymd, is_opt_gubn
String  is_year, is_season, is_yymmdd, is_house_cd
end variables

on w_56020_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_56020_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_date" , MidA(string(ld_datetime,"yyyymmdd"),1,6) + '01')
dw_head.SetItem(1, "to_date"  ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "house_cd"  ,"460000")
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56020_e","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_frm_ymd = dw_head.GetItemString(1, "frm_date")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"반품일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
						dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
											//+ &
			                        // " and gs_brand = '" + gs_brand + "'"
			if gs_brand <> 'K' then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				gst_cd.Item_where = ""
			end if
			
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

// exec sp_56018_d01 'n','ng0006','3','2003','m','20030101','20030722', 's'

il_rows = dw_body.retrieve(is_brand, is_shop_cd, is_shop_type, is_year, is_season, is_frm_ymd, is_to_ymd)
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

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_stock_qty, ll_proc_qty, ll_qty, ll_cnt
datetime ld_datetime
String ls_style, ls_chno, ls_color, ls_size, ls_out_no,ls_start_ymd


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

select count(out_no)
into :ll_cnt
from tb_42021_h (nolock)
where yymmdd    = :is_yymmdd
and   shop_cd   = :is_shop_cd
and   shop_type = :is_shop_type
and   house_cd  = '460000'
and   rqst_gubn = 'U';

if ll_cnt > 0  then
   MessageBox("경고!","동일날짜에 발행한 전표가 존재합니다! 다시 확인바랍니다.")
   return -1
end if

st_1.text = "전표발행 작업이 진행 중 입니다!"
FOR i=1 TO ll_row_count
	dw_body.ScrollToRow(i)
	dw_body.selectrow(i,TRUE)	
	ls_style = dw_body.GetItemString(i, "style")
	ls_chno  = dw_body.GetItemString(i, "chno")
	ls_color = dw_body.GetItemString(i, "color")	
	ls_size  = dw_body.GetItemString(i, "size")		
	ls_start_ymd  = dw_body.GetItemString(i, "start_ymd")			
	ll_proc_qty   = dw_body.GetItemNumber(i, "proc_qty")			
	
	if ll_proc_qty <> 0 then
	
		 DECLARE sp_56020_proc PROCEDURE FOR sp_56020_proc  
				@BRAND     = :is_brand,   
				@yymmdd    = :is_yymmdd,   
				@shop_cd   = :is_shop_cd,   
				@shop_type = :is_shop_type,   
				@style     = :ls_style,   
				@chno      = :ls_chno,   
				@color     = :ls_color,   
				@size      = :ls_size,   
				@qty       = :ll_proc_qty,   
				@reg_id    = :gs_user_id,
				@start_ymd = :ls_start_ymd		;
	
			 EXECUTE sp_56020_proc;
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;
					 il_rows = 1 
				END IF 		
			end if		
	dw_body.selectrow(i,false)	
NEXT

select max(out_no)
into :ls_out_no
from tb_42021_h (nolock)
where yymmdd    = :is_yymmdd
and   shop_cd   = :is_shop_cd
and   shop_type = :is_shop_type
and   house_cd  = '460000'
and   rqst_gubn = 'U';


st_1.text = "전표번호 " + ls_out_no + " 로 발행 되었습니다!"
messagebox("알림!", "전표발행 작업이 완료 되었습니다!")

Trigger Event ue_RETRIEVE()
CB_UPDATE.ENABLED = FALSE
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_56020_e
end type

type cb_delete from w_com010_e`cb_delete within w_56020_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56020_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56020_e
end type

type cb_update from w_com010_e`cb_update within w_56020_e
end type

type cb_print from w_com010_e`cb_print within w_56020_e
end type

type cb_preview from w_com010_e`cb_preview within w_56020_e
end type

type gb_button from w_com010_e`gb_button within w_56020_e
end type

type cb_excel from w_com010_e`cb_excel within w_56020_e
end type

type dw_head from w_com010_e`dw_head within w_56020_e
integer height = 292
string dataobject = "d_56020_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.SetFilter("inter_cd >= '3'")
idw_shop_type.Filter()

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
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

type ln_1 from w_com010_e`ln_1 within w_56020_e
integer beginy = 488
integer endy = 488
end type

type ln_2 from w_com010_e`ln_2 within w_56020_e
integer beginy = 492
integer endy = 492
end type

type dw_body from w_com010_e`dw_body within w_56020_e
integer x = 9
integer y = 516
integer height = 1524
string dataobject = "d_56020_d01"
end type

type dw_print from w_com010_e`dw_print within w_56020_e
end type

type st_1 from statictext within w_56020_e
integer x = 393
integer y = 64
integer width = 1006
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

