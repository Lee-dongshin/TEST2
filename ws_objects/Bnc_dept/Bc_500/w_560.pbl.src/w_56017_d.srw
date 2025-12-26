$PBExportHeader$w_56017_d.srw
$PBExportComments$백화점 매입매출 비교조회
forward
global type w_56017_d from w_com010_d
end type
end forward

global type w_56017_d from w_com010_d
integer width = 3689
integer height = 2248
end type
global w_56017_d w_56017_d

type variables
DataWindowChild idw_brand, idw_shop_type, idw_year, idw_season
String is_brand, is_frm_date, is_to_date, is_shop_cd, is_shop_type, is_opt_gubn, is_year, is_season
end variables

on w_56017_d.create
call super::create
end on

on w_56017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;DateTime ld_datetime
String ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyymmdd")

dw_head.Setitem(1, "frm_date", MidA(ls_datetime,1,6) + '01' )
dw_head.Setitem(1, "to_date", ls_datetime )
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

is_frm_date = dw_head.GetItemString(1, "frm_date")
if IsNull(is_frm_date) or Trim(is_frm_date) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_date")
   return false
end if

is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
if IsNull(is_opt_gubn) or Trim(is_opt_gubn) = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_gubn")
   return false
end if


if is_opt_gubn = "A" then
	is_shop_cd = dw_head.GetItemString(1, "shop_cd")
	if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	   MessageBox(ls_title,"매장코들를 입력하십시요!")
	   dw_head.SetFocus()
	   dw_head.SetColumn("shop_cd")
	   return false
	end if
else
	is_shop_cd = dw_head.GetItemString(1, "shop_cd")
	if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
		is_shop_cd = "%"
	//   MessageBox(ls_title,"매장코들를 입력하십시요!")
	//   dw_head.SetFocus()
	//   dw_head.SetColumn("shop_cd")
	//   return false
	end if
end if


is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
	is_shop_type = "%"
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
	is_year = "%"
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
	is_season = "%"
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec SP_56017_D01 'n', '20030201','20030228', 'ng0008', '%'
if is_opt_gubn <> "C" then
	il_rows = dw_body.retrieve(is_brand, is_frm_date, is_to_date, is_shop_cd, is_shop_type)
else	
	il_rows = dw_body.retrieve(is_brand, is_frm_date, is_to_date, is_shop_cd, is_shop_type, is_year, is_season , 'V')
end if	

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

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_shop_nm = dw_head.getitemstring(1, "shop_nm")
if IsNull(ls_shop_nm) or Trim(ls_shop_nm) = "" then
	ls_shop_nm = "전체매장"
end if
	
ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &				 
  			   "t_frm_date.Text = '" + String(is_frm_date, '@@@@/@@/@@') + "'" + &																			 
  			   "t_to_date.Text = '" + String(is_to_date, '@@@@/@@/@@') + "'" + &			
				"t_shop.text = '" + is_shop_cd + ' ' + ls_shop_nm + "'" + &  
            "t_shop_tpye.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" 
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56017_d","0")
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + &
			                         " and brand = '" + gs_brand + "'"
         if gs_brand <> 'K' then				
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' or shop_nm like  '%" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

type cb_close from w_com010_d`cb_close within w_56017_d
end type

type cb_delete from w_com010_d`cb_delete within w_56017_d
end type

type cb_insert from w_com010_d`cb_insert within w_56017_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56017_d
end type

type cb_update from w_com010_d`cb_update within w_56017_d
end type

type cb_print from w_com010_d`cb_print within w_56017_d
end type

type cb_preview from w_com010_d`cb_preview within w_56017_d
end type

type gb_button from w_com010_d`gb_button within w_56017_d
end type

type cb_excel from w_com010_d`cb_excel within w_56017_d
end type

type dw_head from w_com010_d`dw_head within w_56017_d
integer x = 9
integer y = 156
integer width = 3502
integer height = 208
string dataobject = "d_56017_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')



This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if
			
		
	CASE "opt_gubn"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if data = "A" then 
			dw_body.DataObject = "d_56017_d01" 
			dw_print.DataObject = "d_56017_r01"
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)
			dw_head.Object.year.Visible = 0
			dw_head.Object.season.Visible = 0
			dw_head.Object.t_2.Visible = 0

		elseif data = "B" then
			dw_body.DataObject = "d_56017_d02" 
			dw_print.DataObject = "d_56017_r02" 
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)	
			dw_head.Object.year.Visible = 0
			dw_head.Object.season.Visible = 0			
			dw_head.Object.t_2.Visible = 0			
		else
			dw_body.DataObject = "d_56017_d03" 
			dw_print.DataObject = "d_56017_r03" 
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)			
			dw_head.Object.year.Visible = 1
			dw_head.Object.season.Visible = 1
			dw_head.Object.t_2.Visible = 1			
			
		end if	
		
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56017_d
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_d`ln_2 within w_56017_d
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_d`dw_body within w_56017_d
integer y = 392
integer width = 3598
integer height = 1620
string dataobject = "d_56017_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_56017_d
string dataobject = "d_56017_r01"
end type

