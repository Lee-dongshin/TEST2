$PBExportHeader$w_53039_e.srw
$PBExportComments$쇼핑몰판매 이월반품처리
forward
global type w_53039_e from w_com010_e
end type
type st_1 from statictext within w_53039_e
end type
end forward

global type w_53039_e from w_com010_e
integer width = 3680
integer height = 2280
st_1 st_1
end type
global w_53039_e w_53039_e

type variables
string is_brand, is_shop_div, is_user_id, is_yymmdd, is_to_yymmdd, is_yn
datawindowchild idw_brand, idw_shop_div, idw_shop_type

end variables

on w_53039_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_53039_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm ,ls_emp_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "user_id"				

			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_head.Setitem(al_row, "user_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "where goout_gubn = '1'  and dept_code in ('T310','K140','4100') " 
	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
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
				dw_head.SetItem(al_row, "user_id",    lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "user_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_head.TriggerEvent(Editchanged!)
				dw_head.SetColumn("yymmdd")
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망을 선택하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_user_id = dw_head.GetItemString(1, "user_id")
if IsNull(is_user_id) or Trim(is_user_id) = "" then
  is_user_id = "%"
end if


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"판매일자를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"반품등록일자를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;//xecute dbo.SP_53039_d01;1 




/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_div, '1', is_to_yymmdd, is_user_id)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
String ls_shoP_cd, ls_shop_type, ls_sale_no, ls_chk_yn


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



st_1.text = "전표발행 작업이 진행 중 입니다!"

FOR i=1 TO ll_row_count
	dw_body.ScrollToRow(i)
	dw_body.selectrow(i,TRUE)	
	ls_shoP_cd 		= dw_body.getitemstring(i, "shop_cd")
	ls_shop_type	= dw_body.getitemstring(i, "shop_type")
	ls_sale_no 		= dw_body.getitemstring(i, "sale_no")
	ls_chk_yn		= dw_body.getitemstring(i, "chk_yn")
	
	if ls_chk_yn = "Y" then
	
		 DECLARE sp_53039_p01 PROCEDURE FOR sp_53039_p01  
		 @brand		= :is_brand,
       @yymmdd    = :is_yymmdd,
       @shop_cd   = :ls_shop_cd,
       @shop_type = :ls_shop_type,
       @sale_no_o = :ls_sale_no,
       @to_yymmdd = :is_to_yymmdd,
       @user_id   = :is_user_id ;
	
		 EXECUTE sp_53039_p01;
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

st_1.text = ""
messagebox("알림!", "전표발행 작업이 완료 되었습니다!")

Trigger Event ue_RETRIEVE()
CB_UPDATE.ENABLED = FALSE
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

type cb_close from w_com010_e`cb_close within w_53039_e
end type

type cb_delete from w_com010_e`cb_delete within w_53039_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_53039_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53039_e
end type

type cb_update from w_com010_e`cb_update within w_53039_e
end type

type cb_print from w_com010_e`cb_print within w_53039_e
end type

type cb_preview from w_com010_e`cb_preview within w_53039_e
end type

type gb_button from w_com010_e`gb_button within w_53039_e
end type

type cb_excel from w_com010_e`cb_excel within w_53039_e
end type

type dw_head from w_com010_e`dw_head within w_53039_e
integer height = 268
string dataobject = "d_53039_h01"
end type

event dw_head::constructor;call super::constructor;string ls_filter_str

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

ls_filter_str = ''	
ls_filter_str = "inter_cd IN ('D','E') "
idw_shop_div.SetFilter(ls_filter_str)
idw_shop_div.Filter( )


end event

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name
	case "user_id"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		

END CHOOSE


end event

type ln_1 from w_com010_e`ln_1 within w_53039_e
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_53039_e
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_53039_e
integer y = 440
integer height = 1604
string dataobject = "d_53039_d01"
end type

event dw_body::constructor;call super::constructor;
This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('009')

end event

event dw_body::buttonclicked;call super::buttonclicked;Long i, ll_row
string ls_modify

if dwo.name = 'cb_all'  then 	

	if is_yn = 'Y' then 
		is_yn = 'N'
	else
		is_yn = 'Y'
	end if	

	 ll_row = this.rowcount()
	
		if this.object.cb_all.text = "전체"  then 
			for i = 1 to ll_row
				this.setitem(i , "chk_yn", "Y")
			next	
		  ls_modify = 'cb_all.text= "해제"'
		  this.Modify(ls_modify)		
			
		else
			for i = 1 to ll_row
				this.setitem(i , "chk_yn", "N")
			next	
		  ls_modify = 'cb_all.text= "전체"' 
		  this.Modify(ls_modify)		
					
			
		end if	
	end if



end event

type dw_print from w_com010_e`dw_print within w_53039_e
end type

type st_1 from statictext within w_53039_e
integer x = 389
integer y = 52
integer width = 1029
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 79741120
boolean focusrectangle = false
end type

