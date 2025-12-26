$PBExportHeader$w_52032_e.srw
$PBExportComments$배분차수별 조회 수정
forward
global type w_52032_e from w_com020_e
end type
end forward

global type w_52032_e from w_com020_e
integer width = 3680
integer height = 2284
end type
global w_52032_e w_52032_e

type variables
DataWindowChild idw_brand
string is_brand, is_out_ymd, is_shop_cd, is_style
long  il_fr_deal_seq, il_to_deal_seq, il_deal_seq
end variables

on w_52032_e.create
call super::create
end on

on w_52032_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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


is_out_ymd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_out_ymd) or Trim(is_out_ymd) = "" then
   MessageBox(ls_title,"배분일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_ymd")
   return false
end if

il_fr_deal_seq = dw_head.GetItemNumber(1, "fr_deal_seq")
if IsNull(il_fr_deal_seq) then
  il_fr_deal_seq = 0
end if

il_to_deal_seq = dw_head.GetItemNumber(1, "to_deal_seq")
if IsNull(il_to_deal_seq) then
  il_to_deal_seq = 999
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
  is_shop_cd = "%"
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
  is_style = "%"
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_out_ymd, il_fr_deal_seq, il_to_deal_seq, is_shop_cd, is_style)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm",  ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
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
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				if gs_brand <> 'K' then
					gst_cd.default_where   = " WHERE 1 = 1 "
				else
					gst_cd.default_where   = ""
				end if
				
				if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'%" + as_data + "%~' "
					ELSE
						gst_cd.Item_where = ""
					END IF
				else
					gst_cd.Item_where = ""
				end if

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					/* 다음컬럼으로 이동 */
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

event ue_delete();long			ll_cur_row
STRING		ls_proc_yn, ls_dps_yn

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

ls_proc_yn = dw_body.GetItemString (ll_cur_row, "proc_yn")	
ls_dps_yn = dw_body.GetItemString (ll_cur_row, "dps_yn")	


if ls_proc_yn = "N" and ls_dps_yn = "N" then
	idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
	il_rows = dw_body.DeleteRow (ll_cur_row)
else
	messagebox("경고!", "물류 작업중인 내역은 삭제 할 수 없습니다!")
end if

dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
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


//il_rows = dw_body.retrieve(is_brand, is_out_ymd, ll_deal_seq, is_shop_cd, is_style)

//배분차수별 예약재고 재설정
	 DECLARE sp_reserve_reset_deal_seq PROCEDURE FOR sp_reserve_reset_deal_seq  
				@out_ymd		 = :is_out_ymd,
				@deal_seq  	 = :il_deal_seq;						
	 execute sp_reserve_reset_deal_seq;		
			 
 	 commit  USING SQLCA;		

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com020_e`cb_close within w_52032_e
end type

type cb_delete from w_com020_e`cb_delete within w_52032_e
end type

type cb_insert from w_com020_e`cb_insert within w_52032_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_52032_e
end type

type cb_update from w_com020_e`cb_update within w_52032_e
end type

type cb_print from w_com020_e`cb_print within w_52032_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_52032_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_52032_e
end type

type cb_excel from w_com020_e`cb_excel within w_52032_e
end type

type dw_head from w_com020_e`dw_head within w_52032_e
integer y = 148
string dataobject = "d_52032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;/*===========================================================================*/
String ls_yymmdd, ls_dep_ymd,ls_year,ls_brand
DataWindowChild ldw_child 

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = Data
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF

   CASE "style" 
      IF ib_itemchanged THEN RETURN 1
		IF isnull(data) or trim(data) = "" then RETURN 0
		//IF len(trim(data)) = 4 then RETURN 0	//유수비
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	  
	  
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)	  
	  

		
		  
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_52032_e
integer beginy = 412
integer endy = 412
end type

type ln_2 from w_com020_e`ln_2 within w_52032_e
integer beginy = 416
integer endy = 416
end type

type dw_list from w_com020_e`dw_list within w_52032_e
integer x = 5
integer y = 420
integer width = 1143
integer height = 1620
string dataobject = "d_52032_d01"
end type

event dw_list::clicked;call super::clicked;long ll_deal_seq


IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ll_deal_seq = This.GetItemNumber(row, 'deal_seq') /* DataWindow에 Key 항목을 가져온다 */
il_deal_seq = ll_deal_seq


IF IsNull(ll_deal_seq) THEN return


il_rows = dw_body.retrieve(is_brand, is_out_ymd, ll_deal_seq, is_shop_cd, is_style)


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_52032_e
integer x = 1175
integer y = 420
integer width = 2418
integer height = 1620
string dataobject = "d_52032_d02"
end type

event dw_body::clicked;call super::clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
this.SetRow(row)
this.SetColumn("deal_qty")
end event

type st_1 from w_com020_e`st_1 within w_52032_e
integer x = 1157
integer y = 420
integer height = 1620
end type

type dw_print from w_com020_e`dw_print within w_52032_e
end type

