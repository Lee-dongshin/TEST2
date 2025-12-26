$PBExportHeader$w_41014_d.srw
$PBExportComments$입고잔품증 출력
forward
global type w_41014_d from w_com010_d
end type
type dw_1 from datawindow within w_41014_d
end type
end forward

global type w_41014_d from w_com010_d
dw_1 dw_1
end type
global w_41014_d w_41014_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_year, idw_season, idw_jup_gubn
String is_brand, is_cust_cd , is_fr_ymd, is_to_ymd, is_house_cd, is_year, is_season,is_jup_gubn, is_in_gubn

end variables

on w_41014_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_41014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
		CASE "cust_cd"							// 거래처 코드
		

			IF ai_div = 1 THEN 	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
				gst_cd.window_title    = "생산처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '6999' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " CustCode LIKE ~'" + as_data + "%~' "
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
					dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_Name"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("year")
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


is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
is_cust_cd = "%"
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

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" then
   MessageBox(ls_title,"전표구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

is_in_gubn = dw_head.GetItemString(1, "in_gubn")
if IsNull(is_in_gubn) or Trim(is_in_gubn) = "" then
   MessageBox(ls_title,"입고구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_gubn")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//
//	@brand		varchar(1),
//	@fr_date	varchar(8),
//	@to_date	varchar(8),
//	@house_cd	varchar(6),
//	@in_gubn	varchar(1),
//	@jup_gubn	varchar(2),
//	@cust_cd	varchar(6),
//	@year		varchar(4),
//	@season		varchar(1)

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_house_cd, is_in_gubn, is_jup_gubn, is_cust_cd,is_year, is_season)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41014_d","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event ue_preview();

Long i, row_cnt

dw_1.reset()

row_cnt = dw_body.RowCount()
For i = row_cnt To 1 Step -1
	If dw_body.GetItemString(i, 'prt_yn') = 'Y' Then
		dw_body.Rowscopy(i, i, Primary!, dw_1, 1, Primary!)
		dw_1.SetItem(1, 'prt_yn', 'N')
	End If
Next

This.Trigger Event ue_title ()



dw_1.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()


end event

type cb_close from w_com010_d`cb_close within w_41014_d
end type

type cb_delete from w_com010_d`cb_delete within w_41014_d
end type

type cb_insert from w_com010_d`cb_insert within w_41014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_41014_d
end type

type cb_update from w_com010_d`cb_update within w_41014_d
end type

type cb_print from w_com010_d`cb_print within w_41014_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_41014_d
end type

type gb_button from w_com010_d`gb_button within w_41014_d
end type

type cb_excel from w_com010_d`cb_excel within w_41014_d
end type

type dw_head from w_com010_d`dw_head within w_41014_d
string dataobject = "d_41014_h01"
end type

event dw_head::constructor;call super::constructor;string ls_filter_str

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')


This.GetChild("jup_gubn", idw_jup_gubn )
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('024')


This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertrow(1)
idw_year.setitem(1,"inter_cd","%")
idw_year.setitem(1,"inter_cd1","%")
idw_year.setitem(1,"inter_nm","전체")

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")



ls_filter_str = ''	
ls_filter_str = "shop_cd < '100000' "
idw_house_cd.SetFilter(ls_filter_str)
idw_house_cd.Filter( )


end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_41014_d
end type

type ln_2 from w_com010_d`ln_2 within w_41014_d
end type

type dw_body from w_com010_d`dw_body within w_41014_d
string dataobject = "d_41014_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn

If dwo.Name = 'cb_prt' Then
	If dwo.Text = '선택' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	Else
		ls_yn = 'N'
		dwo.Text = '선택'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "prt_yn", ls_yn)		
	Next	
End If

end event

type dw_print from w_com010_d`dw_print within w_41014_d
string dataobject = "d_41014_r01"
end type

type dw_1 from datawindow within w_41014_d
boolean visible = false
integer x = 910
integer y = 932
integer width = 2080
integer height = 600
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_41014_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

