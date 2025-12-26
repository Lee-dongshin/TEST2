$PBExportHeader$w_56015_e.srw
$PBExportComments$점재고 재매입처리
forward
global type w_56015_e from w_com010_e
end type
type dw_1 from datawindow within w_56015_e
end type
end forward

global type w_56015_e from w_com010_e
dw_1 dw_1
end type
global w_56015_e w_56015_e

type variables
DataWindowChild idw_brand, idw_shop_type, idw_year, idw_season
string is_brand, is_base_yymmdd, is_out_yymmdd, is_shop_cd, is_shop_type
string is_year, is_season, IS_PROC_YN
end variables

forward prototypes
public function integer wf_update ()
end prototypes

public function integer wf_update ();/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      :                                                 */	
/* 수정일      :                                                 */
/*===========================================================================*/
// 점재고 재매입처리 

 DECLARE sp_56015 PROCEDURE FOR sp_56015  
         @BRAND = :is_brand,   
         @base_yymmdd = :is_base_yymmdd,   
         @OUT_yymmdd = :is_out_yymmdd,   
         @shop_cd = :is_shop_cd,   
         @shop_type = :is_shop_type,   
         @year = :is_year,   
         @season = :is_season,   
         @reg_id = :gs_user_id  ;

EXECUTE sp_56015;
	

IF SQLCA.SQLCODE = -1 THEN 
	rollback  USING SQLCA;
	MessageBox("판매 SQL오류", SQLCA.SqlErrText) 
	Return -1 
ELSE
	commit  USING SQLCA;
END IF 

Return 1

end function

on w_56015_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_56015_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "base_yymmdd",string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "out_yymmdd",string(ld_datetime,"yyyymmdd"))


dw_1.insertrow(0)
end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_where
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
		CASE "shop_cd"	
			is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "shop_nm", "")
					Return 0
				End If
				Choose Case is_brand
					Case 'J'
						If (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = 'J') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						End If
					Case 'Y'
						If (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = 'Y') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						END IF 
					Case Else
						If LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						END IF 
				End Choose
				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' "
			ELSE
				gst_cd.Item_where = ""
			END IF

			Choose Case is_brand
				Case 'J'
					ls_where = " AND BRAND IN ('N', 'J') "
				Case 'Y'
					ls_where = " AND BRAND IN ('O', 'Y') "
				Case Else
					ls_where = " AND BRAND = '" + is_brand + "' "
			End Choose

			gst_cd.default_where = gst_cd.default_where + ls_where
			
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
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

is_base_yymmdd = dw_head.GetItemString(1, "base_yymmdd")
if IsNull(is_base_yymmdd) or Trim(is_base_yymmdd) = "" then
   MessageBox(ls_title,"반품일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("base_yymmdd")
   return false
end if

is_out_yymmdd = dw_head.GetItemString(1, "out_yymmdd")
if IsNull(is_out_yymmdd) or Trim(is_out_yymmdd) = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
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


return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.visible = true

il_rows = dw_body.retrieve(is_brand, is_base_yymmdd, is_shop_cd, is_year, is_season)
IF il_rows > 0 THEN
	DW_BODY.ENABLED = TRUE
   dw_body.SetFocus()
END IF

dw_1.visible = false

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;/*===========================================================================*/
/* 작성자      :                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string  ls_proc_yn, ls_shop_type, ls_year, ls_season

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

dw_1.visible = true

FOR i=1 TO ll_row_count
   
		ls_proc_yn   = dw_body.Getitemstring(i, "proc_yn")
		is_year      = dw_body.Getitemstring(i, "year")
		is_season    = dw_body.Getitemstring(i, "season")
		is_shop_type = dw_body.Getitemstring(i, "shop_type")		
		
		if ls_proc_yn = "Y" then	
	   	  il_rows = wf_update()			
		END IF	

NEXT

dw_1.visible = false

IF il_rows = 1 THEN
   MessageBox("확인", "처리 완료") 
	DW_BODY.ENABLED = FALSE
END IF


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56015_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56015_e
end type

type cb_delete from w_com010_e`cb_delete within w_56015_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56015_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56015_e
end type

type cb_update from w_com010_e`cb_update within w_56015_e
end type

type cb_print from w_com010_e`cb_print within w_56015_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56015_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56015_e
end type

type cb_excel from w_com010_e`cb_excel within w_56015_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56015_e
integer x = 411
integer y = 224
integer width = 2697
integer height = 524
string dataobject = "d_56015_h01"
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
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

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

type ln_1 from w_com010_e`ln_1 within w_56015_e
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_56015_e
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_56015_e
integer x = 658
integer y = 792
integer width = 2478
integer height = 1204
string dataobject = "d_56015_d01"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_body::itemchanged;//ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_out_no

If dwo.Name = 'cancle_yn' Then
	If dwo.Text = '전체선택' Then
		ls_yn = 'Y'
		dwo.Text = '전체해제'
	Else
		ls_yn = 'N'
		dwo.Text = '전체선택'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "proc_yn", ls_yn)
	Next

End If

end event

type dw_print from w_com010_e`dw_print within w_56015_e
end type

type dw_1 from datawindow within w_56015_e
boolean visible = false
integer x = 823
integer y = 600
integer width = 2089
integer height = 260
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "작업알림!"
string dataobject = "d_56015_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

