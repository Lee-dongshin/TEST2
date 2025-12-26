$PBExportHeader$w_42051_e.srw
$PBExportComments$물류배분출고
forward
global type w_42051_e from w_com010_e
end type
type st_1 from statictext within w_42051_e
end type
end forward

global type w_42051_e from w_com010_e
integer width = 3689
integer height = 2280
st_1 st_1
end type
global w_42051_e w_42051_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_color
String is_out_ymd, is_shop_cd, is_year, is_season, is_brand, is_fr_shop_cd, is_dep_fg, is_plan_yn
int	ii_deal_seq, ii_deal_qty
end variables

on w_42051_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_42051_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42051_e","0")
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


if is_brand = "V" or is_brand = "B" or is_brand = "F" or is_brand = "L" then
			messagebox("주의", "이터널 브랜드의 경우 이터널영업관리를 이용하세요!")
			 return false	
//			return -1
//			Return 0
End if		

is_out_ymd = dw_head.GetItemString(1, "out_ymd")
if IsNull(is_out_ymd) or Trim(is_out_ymd) = "" then
   MessageBox(ls_title,"배분일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_ymd")
   return false
end if

ii_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(ii_deal_seq) or ii_deal_seq <= 0 then
   MessageBox(ls_title,"배분번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if



is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_fr_shop_cd = dw_head.GetItemString(1, "fr_shop_cd")
if IsNull(is_fr_shop_cd) or Trim(is_fr_shop_cd) = "" then
	is_fr_shop_cd = "XXXXXX"
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

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_dep_fg = dw_head.GetItemString(1, "dep_fg")
if IsNull(is_dep_fg) or Trim(is_dep_fg) = "" then
   MessageBox(ls_title,"부진구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_fg")
   return false
end if

is_plan_yn = dw_head.GetItemString(1, "plan_yn")
if IsNull(is_plan_yn) or Trim(is_plan_yn) = "" then
   MessageBox(ls_title,"기획구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("plan_yn")
   return false
end if

ii_deal_qty = dw_head.GetItemNumber(1, "deal_qty")
if is_fr_shop_cd = 'XXXXXX' then
	if IsNull(ii_deal_qty) or ii_deal_qty <= 0 then
		MessageBox(ls_title,"배분수량을 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("deal_qty")
		return false
	end if
else
	ii_deal_qty = 0
end if	


ii_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if is_fr_shop_cd = 'XXXXXX' then
	if IsNull(ii_deal_seq) or ii_deal_seq <= 0 then
		MessageBox(ls_title,"배분번호를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("deal_seq")
		return false
	end if
else	
	if IsNull(ii_deal_seq) or ii_deal_seq < 160 or ii_deal_seq > 169  then
		MessageBox(ls_title,"오픈배분은 160 ~ 169차로만 등록가능합니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("deal_seq")
		return false
	end if
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_out_ymd, ii_deal_seq, ii_deal_qty, is_shop_cd, is_fr_shop_cd, is_year, is_season, gs_user_id, is_dep_fg, is_plan_yn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
string ls_chk

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//out_ymd	deal_seq  style   chno    color size deal_fg shop_cd deal_qty
//out_qty   proc_yn   yymmdd  out_no  work_no dps_yn reg_id reg_dt mod_id mod_dt rshop_cd

FOR i=1 TO ll_row_count
	ls_chk = dw_body.GetitemString(i, "chk") 
	IF isnull(ls_chk) or ls_chk = "New" THEN 
	   dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
	end if

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

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "out_ymd" ,string(ld_datetime,"yyyymmdd"))
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;
String     ls_shop_nm , ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			ls_brand = dw_head.getitemstring(1,'brand')			
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' and brand = '" + ls_brand + "' "
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("year")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "fr_shop_cd"				
			ls_brand = dw_head.getitemstring(1,'brand')			
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "fr_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' and brand = '" + ls_brand + "' "
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
				dw_head.SetItem(al_row, "fr_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "fr_shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
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

type cb_close from w_com010_e`cb_close within w_42051_e
end type

type cb_delete from w_com010_e`cb_delete within w_42051_e
integer x = 1125
string text = "행삭제(&D)"
end type

type cb_insert from w_com010_e`cb_insert within w_42051_e
integer width = 384
string text = "배분삭제(&A)"
end type

event cb_insert::clicked;Long   ll_row, ll_deal_seq
String ls_shop_nm, ls_proc_yn
String ls_ErrMsg
int    li_ret 


ls_shop_nm   = dw_head.GetitemString(1, "shop_nm")


li_ret = MessageBox("확인", "[" + ls_shop_nm + "][" + string(ii_deal_seq, '0000')  + "] 차 배분을 정말 삭제 하시겠습니까 ?", Question!, YesNo!)

IF li_ret = 2 THEN RETURN 

select top 1 isnull(dps_yn,'N')
  into :ls_proc_yn
  from dbo.tb_52031_h with (nolock)
 where out_ymd  = :is_out_ymd
   and deal_seq = :ii_deal_seq
   and shop_cd  = :is_shop_cd;
	
IF isnull(ls_proc_yn) OR Trim(ls_proc_yn) = "" THEN 
	MessageBox("확인", String(is_out_ymd, "@@@@/@@/@@") + " " + String(ii_deal_seq) + "차 자료에는 배분된 내역이 없습니다.")
	RETURN 
ELSEIF ls_proc_yn = 'Y' THEN
	MessageBox("확인", "이미 출고처리가 되여 삭제할수 없습니다.")
	RETURN 
END IF

 delete
  from dbo.tb_52031_h
 where out_ymd  = :is_out_ymd
   and deal_seq = :ii_deal_seq
   and shop_cd  = :is_shop_cd;

IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
   COMMIT;
	dw_body.Reset()
   MessageBox("확인", "삭제 되였습니다 !.")
ELSE
	ls_ErrMsg = SQLCA.SqlErrText
	ROLLBACK;
	MessageBox("오류", ls_ErrMsg)
END IF

end event

type cb_retrieve from w_com010_e`cb_retrieve within w_42051_e
end type

type cb_update from w_com010_e`cb_update within w_42051_e
end type

type cb_print from w_com010_e`cb_print within w_42051_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_42051_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_42051_e
end type

type cb_excel from w_com010_e`cb_excel within w_42051_e
end type

type dw_head from w_com010_e`dw_head within w_42051_e
integer y = 160
integer width = 3525
integer height = 296
string dataobject = "d_42051_h01"
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

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')



end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "shop_cd"	, "fr_shop_cd"     //  Popup 검색창이 존재하는 항목 
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
			
END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_42051_e
integer beginy = 456
integer endy = 456
end type

type ln_2 from w_com010_e`ln_2 within w_42051_e
integer beginy = 460
integer endy = 460
end type

type dw_body from w_com010_e`dw_body within w_42051_e
integer y = 472
integer height = 1568
string dataobject = "d_42051_d01"
end type

event dw_body::itemchanged;call super::itemchanged;This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.retrieve('%')


end event

type dw_print from w_com010_e`dw_print within w_42051_e
end type

type st_1 from statictext within w_42051_e
integer x = 1618
integer y = 368
integer width = 1975
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 오픈매장배분의 경우 년도/시즌, 수량은 무시합니다!"
boolean focusrectangle = false
end type

