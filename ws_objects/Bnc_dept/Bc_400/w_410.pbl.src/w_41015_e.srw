$PBExportHeader$w_41015_e.srw
$PBExportComments$입고전환처리
forward
global type w_41015_e from w_com020_e
end type
type st_2 from statictext within w_41015_e
end type
end forward

global type w_41015_e from w_com020_e
st_2 st_2
end type
global w_41015_e w_41015_e

type variables
String is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_in_ymd
DataWindowChild idw_brand, idw_shop_type
end variables

on w_41015_e.create
int iCurrent
call super::create
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
end on

on w_41015_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41015_e","0")
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


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_in_ymd = dw_head.GetItemString(1, "in_ymd")
if IsNull(is_in_ymd) or Trim(is_in_ymd) = "" then
   MessageBox(ls_title,"입고전환일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_ymd")
   return false
end if

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetColumn("end_ymd")
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

il_rows = dw_list.retrieve(is_fr_ymd, is_to_ymd, is_shop_cd, is_brand)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_ok
integer li_return
datetime ld_datetime
String ls_yymmdd, ls_out_no, ls_chk_sel,  ls_shop_cd, ls_shop_type 


ll_row_count = dw_list.RowCount()
IF dw_list.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

li_return = MessageBox("경고!", "처리 완료 후 출고데이터는 자동 삭제됩니다! 계속 하시겠습니까?", Exclamation!, OKCancel!, 2)

IF li_return <> 1 THEN
	messagebox("확인!", "작업이 취소 되었습니다!")
  	Return 0
END IF


FOR i=1 TO ll_row_count
	
 ls_yymmdd    = dw_list.getitemstring(i, "yymmdd")	
 ls_out_no    = dw_list.getitemstring(i, "out_no") 
 ls_chk_sel   = dw_list.getitemstring(i, "chk_sel") 
 ls_shop_cd   = dw_list.getitemstring(i, "shop_cd") 
 ls_shop_type = dw_list.getitemstring(i, "shop_type") 
 ls_chk_sel   = dw_list.getitemstring(i, "chk_sel")  
 
	 if ls_chk_sel = "Y" then 
		
		IF Trigger Event ue_keycheck('1') = FALSE THEN return -1

		 DECLARE sp_41015_p01 PROCEDURE FOR sp_41015_P01  
         @brand 		= :is_brand,   
         @out_ymd 	= :ls_yymmdd,   
         @in_ymd 		= :is_in_ymd,   
         @shop_cd 	= :ls_shop_cd,   
         @shop_type 	= :ls_shop_type,   
         @out_no 		= :ls_out_no,   
         @reg_id 		= :gs_user_id  ;	
					
		 execute sp_41015_P01;
		 commit  USING SQLCA; 			
		 
		IF SQLCA.SQLCODE <> 0  THEN 
			rollback  USING SQLCA; 
		else 
			ll_ok = ll_ok + 1
		END IF 
	end if				 
			
NEXT

		if ll_ok > 0 then 
			messagebox("알림!" , "총 " + string(ll_ok) + "건의 출고자료가 전환처리되었습니다!")
		   ib_changed = false
			Trigger Event ue_retrieve()			
      end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

type cb_close from w_com020_e`cb_close within w_41015_e
end type

type cb_delete from w_com020_e`cb_delete within w_41015_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_41015_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_41015_e
end type

type cb_update from w_com020_e`cb_update within w_41015_e
end type

type cb_print from w_com020_e`cb_print within w_41015_e
end type

type cb_preview from w_com020_e`cb_preview within w_41015_e
end type

type gb_button from w_com020_e`gb_button within w_41015_e
end type

type cb_excel from w_com020_e`cb_excel within w_41015_e
end type

type dw_head from w_com020_e`dw_head within w_41015_e
string dataobject = "d_41015_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com020_e`ln_1 within w_41015_e
end type

type ln_2 from w_com020_e`ln_2 within w_41015_e
end type

type dw_list from w_com020_e`dw_list within w_41015_e
integer width = 1463
string dataobject = "d_41015_d01"
end type

event dw_list::constructor;call super::constructor;This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('009')

end event

event dw_list::clicked;call super::clicked;string ls_shop_type, ls_out_no, ls_yymmdd, ls_shop_cd


IF row <= 0 THEN Return

//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN 1
//			END IF		
//		CASE 3
//			RETURN 1
//	END CHOOSE
//END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_yymmdd = This.GetItemString(row, 'yymmdd') 
IF IsNull(ls_yymmdd) THEN return

ls_out_no = This.GetItemString(row, 'out_no') 
IF IsNull(ls_out_no) THEN return

ls_shop_cd = This.GetItemString(row, 'shop_cd') 
IF IsNull(ls_shop_cd) THEN return

ls_shop_type = This.GetItemString(row, 'shop_type') 
IF IsNull(ls_shop_type) THEN return

il_rows = dw_body.retrieve(ls_yymmdd,ls_shop_cd,ls_shop_type,ls_out_no )
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_out_no

If dwo.Name = 'cb_sel' Then
	If dwo.Text = '선택' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	  ib_changed = true
  	  cb_update.enabled = true
	Else
		ls_yn = 'N'
		dwo.Text = '선택'
 	  ib_changed = false
  	  cb_update.enabled = false
	End If
	
	For i = 1 To This.RowCount()
			This.SetItem(i, "chk_sel", ls_yn)
	Next

End If

end event

event dw_list::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	

	CASE  "chk_sel"
	IF ib_itemchanged THEN RETURN 1
	   ib_changed = true
		cb_update.enabled = true



END CHOOSE
end event

type dw_body from w_com020_e`dw_body within w_41015_e
integer x = 1504
integer width = 2089
string dataobject = "d_41015_d02"
end type

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "chk_sel" 
	   ib_changed = true
		cb_update.enabled = true



END CHOOSE
end event

type st_1 from w_com020_e`st_1 within w_41015_e
integer x = 1490
end type

type dw_print from w_com020_e`dw_print within w_41015_e
end type

type st_2 from statictext within w_41015_e
integer x = 759
integer y = 288
integer width = 1792
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "◈ 경고! 전환처리 작업 후 출고데이터는 삭제됩니다."
boolean focusrectangle = false
end type

