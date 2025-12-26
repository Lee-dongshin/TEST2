$PBExportHeader$w_56030_e.srw
$PBExportComments$매장재고(정상<>행사)재매입
forward
global type w_56030_e from w_com010_e
end type
end forward

global type w_56030_e from w_com010_e
end type
global w_56030_e w_56030_e

type variables
DataWindowChild idw_brand, idw_st_brand, idw_year, idw_season, idw_shop_type, idw_to_shop_type
string is_brand , is_st_brand, is_yymmdd, is_proc_ymd, is_shop_cd, is_year, is_season, is_shop_type, is_to_shop_type

end variables

on w_56030_e.create
call super::create
end on

on w_56030_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56030_e","0")
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


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_proc_ymd = dw_head.GetItemString(1, "proc_ymd")
if IsNull(is_proc_ymd) or Trim(is_proc_ymd) = "" then
   MessageBox(ls_title,"처리일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_ymd")
   return false
end if


if is_yymmdd > is_proc_ymd then 
   MessageBox(ls_title,"처리일자는 기준일(재고기준) 이후 일자로 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_ymd")
   return false
end if


//string is_brand , is_st_brand, is_yymmdd, is_proc_ymd, is_shop_cd, is_year, is_season, is_shop_type, is_to_shop_type

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if


is_to_shop_type = dw_head.GetItemString(1, "to_shop_type")
if IsNull(is_to_shop_type) or Trim(is_to_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_type")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_st_brand = dw_head.GetItemString(1, "st_brand")
if IsNull(is_st_brand) or Trim(is_st_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_brand")
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
  is_season = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_st_brand, is_year, is_season)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn, ls_SHOP_TYPE, ls_proc_type
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		is_brand = dw_head.getitemstring(1, "brand")
		
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
						dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			
//			if is_brand = "J" then
//		    gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
//			                         "  AND SHOP_DIV <> 'A' and brand in ('N','J') " 
//			else								 
		    gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  <> 'A' " + &
											 "  AND BRAND = '" + is_brand + "'"
//	   	end if										 
											 
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
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

event type long ue_update();call super::ue_update;long i, ll_row_count,ll_ok
datetime ld_datetime
string ls_brand, ls_proc_yn,ls_shop_cd, ls_season
int net

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


Net = MessageBox("경고", "선택된 매장,년도,시즌의 해당 재고가 처리됩니다. 계속하시겠습니까?", Exclamation!, OKCancel!, 2)

IF Net = 1 THEN 

					
					FOR i=1 TO ll_row_count
					  ls_proc_yn = dw_body.getitemstring(i, "proc_yn")
					  ls_brand   = dw_body.getitemstring(i, "brand")
					  ls_shop_cd = dw_body.getitemstring(i, "shop_cd")
					  ls_season  = dw_body.getitemstring(i, "season")
						
					  if ls_proc_yn = "Y" then
						
							dw_body.ScrollToRow(i)
							dw_body.selectrow(i,TRUE)	
						
							//exec sp_56015_shop 'J', '20200422', '20200422', 'JO0001', '4', 'JO0001', '1', '2019', 'W', '991001'
								 
								 
								  DECLARE sp_56030_p01 PROCEDURE FOR sp_56030_p01  
									@BRAND 			= :is_st_brand,   
									@base_yymmdd 	= :is_yymmdd,   
									@OUT_yymmdd 	= :is_proc_ymd,   
									@shop_cd 		= :ls_shop_cd,   
									@shop_type 		= :is_shop_type,   
									@to_shop_cd 	= :ls_shop_cd,   
									@to_shop_type 	= :is_to_shop_type,   
									@year 			= :is_year,   
									@season 			= :ls_season,   
									@reg_id 			= :gs_user_id  ;
					
					
								 execute sp_56030_p01;
								 commit  USING SQLCA; 			
							
//messagebox("", is_brand   +  "/" + is_yymmdd   +  "/" + is_proc_ymd   +  "/" + ls_shop_cd +  "/" +  is_shop_type +  "/" +ls_shop_cd +  "/" +   is_to_shop_type +  "/" +   is_year +  "/" + ls_season +  "/" + gs_user_id)
							
								IF SQLCA.SQLCODE <> 0  THEN 
								rollback  USING SQLCA; 
								else 
									ll_ok = ll_ok + 1
									
								END IF 
							
								dw_body.selectrow(i,false)	
							
					  end if
					  
					NEXT
					
							if ll_ok > 0 then 
								messagebox("알림!" , "총 " + string(ll_ok) + "건이 처리되었습니다!")
								ib_changed = false
								Trigger Event ue_retrieve()
					
					
							end if
ELSE							
							
  MessageBox("알림", "작업이 취소되었습니다!")

END IF		

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_56030_e
end type

type cb_delete from w_com010_e`cb_delete within w_56030_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56030_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56030_e
end type

type cb_update from w_com010_e`cb_update within w_56030_e
string text = "처리(&S)"
end type

type cb_print from w_com010_e`cb_print within w_56030_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56030_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56030_e
end type

type cb_excel from w_com010_e`cb_excel within w_56030_e
end type

type dw_head from w_com010_e`dw_head within w_56030_e
integer y = 168
integer height = 252
string dataobject = "d_56030_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("st_brand", idw_st_brand)
idw_st_brand.SetTransObject(SQLCA)
idw_st_brand.Retrieve('001')


This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')


This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')


This.GetChild("to_shop_type", idw_to_shop_type)
idw_to_shop_type.SetTransObject(SQLCA)
idw_to_shop_type.Retrieve('911')
end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56030_e
end type

type ln_2 from w_com010_e`ln_2 within w_56030_e
end type

type dw_body from w_com010_e`dw_body within w_56030_e
integer width = 3566
integer height = 1528
string dataobject = "d_56030_D01"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_out_no

If dwo.Name = 'cb_select' Then
	If dwo.Text = '전체선택' Then
		ls_yn = 'Y'
		dwo.Text = '전체제외'
	Else
		ls_yn = 'N'
		dwo.Text = '전체선택'
	End If
	
	For i = 1 To This.RowCount()
			This.SetItem(i, "proc_yn", ls_yn)
	Next
	
ib_changed = true
cb_update.enabled = true
	
End If

end event

type dw_print from w_com010_e`dw_print within w_56030_e
end type

