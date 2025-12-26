$PBExportHeader$w_42073_e.srw
$PBExportComments$배분차수 변경
forward
global type w_42073_e from w_com010_e
end type
type dw_1 from datawindow within w_42073_e
end type
end forward

global type w_42073_e from w_com010_e
integer width = 3662
dw_1 dw_1
end type
global w_42073_e w_42073_e

type variables
DataWindowChild idw_brand, idw_shop_type, idw_to_shop_type, idw_house_cd, idw_shop_type1, idw_house_cd1
string is_brand,   is_out_YMD, is_to_out_ymd
string IS_PROC_YN, is_to_shop_cd , is_to_shop_type, is_house_cd, is_yymmdd, is_opt_outday, is_opt_select, is_opt_gubn
long il_deal_seq, il_to_deal_seq, il_deal_qty
end variables

forward prototypes
public function integer wf_update ()
public function integer wf_update2 ()
public function integer wf_update3 ()
public function integer wf_update4 ()
end prototypes

public function integer wf_update ();long i, ll_row_count
string  ls_proc_yn, ls_shop_type, ls_year, ls_season,ls_yymmdd, ls_out_no, ls_out_yymmdd, LS_SELECT , LS_ITEM

ll_row_count = dw_body.RowCount()

	FOR i=1 TO ll_row_count
		
			LS_SELECT   = dw_body.Getitemstring(i, "PROC_YN")
			LS_YEAR     = dw_body.Getitemstring(i, "B_YEAR")				
			ls_SEASON   = dw_body.Getitemstring(i, "B_SEASON")		
			LS_ITEM		= dw_body.Getitemstring(i, "B_ITEM")		
			
		
						
			if LS_SELECT = "Y" then	
				
				UPDATE TB_52031_H SET OUT_YMD = :IS_TO_OUT_YMD, DEAL_SEQ = :IL_TO_DEAL_SEQ, mod_id = :gs_user_id
				WHERE OUT_YMD = :IS_OUT_YMD
				AND   DEAL_SEQ = :IL_DEAL_SEQ
				AND   SHOP_CD   LIKE :IS_BRAND + '%'
				AND   DBO.SF_INTER_CD1('002',SUBSTRING(STYLE,3,1)) = :LS_YEAR
				AND   SUBSTRING(STYLE,4,1) = :LS_SEASON
				AND   SUBSTRING(STYLE,5,1) = :LS_ITEM;
					
							
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;			
				END IF 
	
		
			END IF	
	
	NEXT
Return 1

end function

public function integer wf_update2 ();long i, ll_row_count
string  ls_proc_yn, ls_shop_type, ls_year, ls_season,ls_yymmdd, ls_out_no, ls_out_yymmdd, LS_SELECT , LS_ITEM, ls_shop_cd

ll_row_count = dw_body.RowCount()

	FOR i=1 TO ll_row_count
		
			LS_SELECT   = dw_body.Getitemstring(i, "PROC_YN")
			LS_YEAR     = dw_body.Getitemstring(i, "B_YEAR")				
			ls_SEASON   = dw_body.Getitemstring(i, "B_SEASON")		
			ls_shop_cd		= dw_body.Getitemstring(i, "a_shop_cd")		
			
		
						
			if LS_SELECT = "Y" then	
				
				UPDATE TB_52031_H SET OUT_YMD = :IS_TO_OUT_YMD, DEAL_SEQ = :IL_TO_DEAL_SEQ, mod_id = :gs_user_id
				WHERE OUT_YMD = :IS_OUT_YMD
				AND   DEAL_SEQ = :IL_DEAL_SEQ
				AND   SHOP_CD   LIKE :IS_BRAND + '%'
				AND   DBO.SF_INTER_CD1('002',SUBSTRING(STYLE,3,1)) = :LS_YEAR
				AND   SUBSTRING(STYLE,4,1) = :LS_SEASON
				AND   shop_cd = :ls_shop_cd;
					
							
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;			
				END IF 
	
		
			END IF	
	
	NEXT
Return 1

end function

public function integer wf_update3 ();long i, ll_row_count
string  ls_proc_yn, ls_shop_type, ls_year, ls_season,ls_yymmdd, ls_out_no, ls_out_yymmdd, LS_SELECT , LS_ITEM, ls_shop_cd, ls_brand

ll_row_count = dw_body.RowCount()

	FOR i=1 TO ll_row_count
		
			LS_SELECT   = dw_body.Getitemstring(i, "PROC_YN")
			LS_YEAR     = dw_body.Getitemstring(i, "B_YEAR")				
			ls_SEASON   = dw_body.Getitemstring(i, "B_SEASON")		
			ls_brand		= dw_body.Getitemstring(i, "b_brand")		
			
						
			if LS_SELECT = "Y" then	
				
				UPDATE TB_52031_H SET OUT_YMD = :IS_TO_OUT_YMD, DEAL_SEQ = :IL_TO_DEAL_SEQ, mod_id = :gs_user_id
				WHERE OUT_YMD = :IS_OUT_YMD
				AND   DEAL_SEQ = :IL_DEAL_SEQ
				AND   SHOP_CD   LIKE :IS_BRAND + '%'
				AND   DBO.SF_INTER_CD1('002',SUBSTRING(STYLE,3,1)) = :LS_YEAR
				AND   SUBSTRING(STYLE,4,1) = :LS_SEASON
				AND   SUBSTRING(STYLE,1,1) = :ls_brand	;			

					
							
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;			
				END IF 
	
		
			END IF	
	
	NEXT
Return 1

end function

public function integer wf_update4 ();long i, ll_row_count, ll_deal_qty
string  ls_proc_yn, ls_shop_type, ls_year, ls_season,ls_yymmdd, ls_out_no, ls_out_yymmdd, LS_SELECT , LS_ITEM, ls_shop_cd, ls_brand, ls_style, ls_chno, ls_color, ls_size

ll_row_count = dw_body.RowCount()

	FOR i=1 TO ll_row_count
		
			LS_SELECT   = dw_body.Getitemstring(i, "PROC_YN")
			ls_shop_cd	= dw_body.Getitemstring(i, "a_shop_cd")		
			ls_style		= dw_body.Getitemstring(i, "a_style")		
			ls_chno		= dw_body.Getitemstring(i, "a_chno")		
			ls_color		= dw_body.Getitemstring(i, "a_color")		
			ls_size		= dw_body.Getitemstring(i, "a_size")		
			ll_deal_qty	= dw_body.GetitemNumber(i, "a_deal_qty")					
						
			if LS_SELECT = "Y" then	
				
				UPDATE TB_52031_H SET OUT_YMD = :IS_TO_OUT_YMD, DEAL_SEQ = :IL_TO_DEAL_SEQ, mod_id = :gs_user_id
				WHERE OUT_YMD      = :iS_OUT_YMD
				AND   DEAL_SEQ     = :iL_DEAL_SEQ
				AND   SHOP_CD   LIKE :iS_BRAND + '%'
				and   shop_cd      = :ls_shop_cd
				and   style        = :ls_style
				and   chno         =	:ls_chno
				and   color        = :ls_color
				and   size         = :ls_size				
				and   deal_qty     = :ll_deal_qty;			
					
							
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;			
				END IF 
	
		
			END IF	
	
	NEXT
Return 1

end function

on w_42073_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_42073_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

//dw_head.SetItem(1, "frm_ymd",ld_datetime)
//dw_head.SetItem(1, "to_ymd",ld_datetime)
//dw_head.SetItem(1, "out_yymmdd",ld_datetime)


dw_1.insertrow(0)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_where
DataStore  lds_Source
Boolean    lb_check 

//CHOOSE CASE as_column
//		CASE "shop_cd"	
//			is_brand = dw_head.GetItemString(1, "brand")
//			IF ai_div = 1 THEN
//				If IsNull(as_data) or Trim(as_data) = "" Then
//					dw_head.SetItem(al_row, "shop_nm", "")
//					Return 0
//				End If
//				Choose Case is_brand
//					Case 'J'
//						If (Left(as_data, 1) = 'N' or Left(as_data, 1) = 'J') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//							RETURN 0
//						End If
//					Case 'Y'
//						If (Left(as_data, 1) = 'O' or Left(as_data, 1) = 'Y') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//							RETURN 0
//						END IF 
//					Case Else
//						If Left(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//							RETURN 0
//						END IF 
//				End Choose
//				
//			END IF
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "매장 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com912" 
//			gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div = 'Z'"
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' "
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			Choose Case is_brand
//				Case 'J'
//					ls_where = " AND BRAND IN ('N', 'J') "
//				Case 'Y'
//					ls_where = " AND BRAND IN ('O', 'Y') "
//				Case Else
//					ls_where = " AND BRAND = '" + is_brand + "' "
//			End Choose
//
//			gst_cd.default_where = gst_cd.default_where + ls_where
//			
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				dw_head.SetRow(al_row)
//				dw_head.SetColumn(as_column)
//				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
//				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
//				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("shop_type")
//				ib_itemchanged = False 
//				lb_check = TRUE 
//			ELSE
//				lb_check = FALSE 
//			END IF
//			Destroy  lds_Source
//			
//		CASE "to_shop_cd"	
//			is_brand = dw_head.GetItemString(1, "brand")
//			IF ai_div = 1 THEN
//				If IsNull(as_data) or Trim(as_data) = "" Then
//					dw_head.SetItem(al_row, "to_shop_nm", "")
//					Return 0
//				End If
//				Choose Case is_brand
//					Case 'J'
//						If (Left(as_data, 1) = 'N' or Left(as_data, 1) = 'J') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//							dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
//							RETURN 0
//						End If
//					Case 'Y'
//						If (Left(as_data, 1) = 'O' or Left(as_data, 1) = 'Y') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//							dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
//							RETURN 0
//						END IF 
//					Case Else
//						If Left(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//							dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
//							RETURN 0
//						END IF 
//				End Choose
//				
//			END IF
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "매장 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com912" 
//			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' "
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			Choose Case is_brand
//				Case 'J'
//					ls_where = " AND BRAND IN ('N', 'J') "
//				Case 'Y'
//					ls_where = " AND BRAND IN ('O', 'Y') "
//				Case Else
//					ls_where = " AND BRAND = '" + is_brand + "' "
//			End Choose
//
//			gst_cd.default_where = gst_cd.default_where + ls_where
//			
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				dw_head.SetRow(al_row)
//				dw_head.SetColumn(as_column)
//				dw_head.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
//				dw_head.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
//				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("to_shop_type")
//				ib_itemchanged = False 
//				lb_check = TRUE 
//			ELSE
//				lb_check = FALSE 
//			END IF
//			Destroy  lds_Source			
//				
//			
//END CHOOSE
//
//IF ai_div = 1 THEN 
//	IF lb_check THEN
//      RETURN 2 
//	ELSE
//		RETURN 1
//	END IF
//END IF


RETURN 0

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title, ls_proc_yn, ls_proc_yn2
LONG LL_CHK_EXISTS

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



is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
if IsNull(is_opt_gubn) or Trim(is_opt_gubn) = "" then
   MessageBox(ls_title,"작업구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_gubn")
   return false
end if


is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if



is_out_ymd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_out_ymd) or Trim(is_out_ymd) = "" then
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


il_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(il_deal_seq) then
   MessageBox(ls_title,"배분차수를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if



is_to_out_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_out_ymd) or Trim(is_to_out_ymd) = "" then
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


il_to_deal_seq = dw_head.GetItemNumber(1, "to_deal_seq")
if IsNull(il_deal_seq) then
   MessageBox(ls_title,"변경 할 배분차수를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_deal_seq")
   return false
end if


il_deal_qty = dw_head.GetItemNumber(1, "deal_qty")
if IsNull(il_deal_qty) then
   MessageBox(ls_title,"배분수량을  입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_qty")
   return false
end if



select max(isnull(proc_yn,'N'))
into :ls_proc_yn
from tb_52031_h (nolock)
where out_ymd = :is_out_ymd
and deal_seq = :il_deal_seq
and dps_yn = 'Y'
and left(shop_cd ,1) = :is_brand;

if ls_proc_yn = "Y" then
   MessageBox(ls_title,string(il_deal_seq,"00") + "차 배분은 출고 작업중 입니다! 차수를 확인하세요! ")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if

select COUNT(*)
into :LL_CHK_EXISTS
from tb_52031_h (nolock)
where out_ymd = :is_to_out_ymd
and deal_seq = :il_to_deal_seq
and left(shop_cd ,1) = :is_brand;

if LL_CHK_EXISTS > 0 then
   MessageBox(ls_title,"변경 차수인 " + string(il_to_deal_seq,"00") + "차 배분이 존재합니다! 다른 차수를 사용 하세요! ")
   dw_head.SetFocus()
   dw_head.SetColumn("to_deal_seq")
  return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt_gubn = "I" then 		
	dw_body.DataObject = "d_42073_d01"
	dw_body.SetTransObject(SQLCA)	
elseif is_opt_gubn = "B" then 		
	dw_body.DataObject = "d_42073_d03"	
	dw_body.SetTransObject(SQLCA)	
elseif is_opt_gubn = "N" then 		
	dw_body.DataObject = "d_42073_d04"		
	dw_body.SetTransObject(SQLCA)	
else 	
	dw_body.DataObject = "d_42073_d02"		
	dw_body.SetTransObject(SQLCA)	
end if

is_opt_select = "N"

dw_1.visible = true

//@BRAND,	@frm_ymd, @to_ymd ,@house_cd, @shop_cd, @shop_type
	if is_opt_gubn = "N" then
		il_rows = dw_body.retrieve(is_brand, is_out_ymd, il_deal_seq, il_deal_qty)
	else 
		il_rows = dw_body.retrieve(is_brand, is_out_ymd, il_deal_seq)		
	end if	


IF il_rows > 0 THEN
	DW_BODY.ENABLED = TRUE
   dw_body.SetFocus()
END IF

dw_1.visible = false

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      :                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_chk_cnt
datetime ld_datetime
string  ls_proc_yn, ls_shop_type, ls_year, ls_season,ls_yymmdd, ls_out_no, ls_out_yymmdd, ls_item

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



//select count(*)
//into :ll_chk_cnt
//from tb_52031_h a (nolock)
//where a.out_ymd = :is_out_ymd
//and a.deal_seq = :il_deal_seq
//and left(a.shop_cd ,1) = :is_brand
//and exists (	select * 
//				from tb_52031_h b (nolock)
//				where b.out_ymd = :is_to_out_ymd 
//				and   b.deal_seq = :il_to_deal_seq
//				and   left(b.shop_cd ,1) = :is_brand
//				and   b.style  = a.style
//				and   b.chno   = a.chno
//				and   b.color  = a.color
//				and   b.size   = a.size
//				and   b.deal_fg = a.deal_fg
//				and   b.shop_cd = a.shop_cd);


dw_1.visible = true

if is_opt_gubn = "S" then
	 il_rows = wf_update2()			
elseif is_opt_gubn = "B" then
	 il_rows = wf_update3()				 
elseif is_opt_gubn = "N" then
	 il_rows = wf_update4()				 	 
else 	 
	 il_rows = wf_update()			
end if	 

dw_1.visible = false

IF il_rows = 1 THEN
   MessageBox("확인", "처리 완료") 
   dw_body.ResetUpdate()
	DW_BODY.ENABLED = FALSE
END IF


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42073_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42073_e
end type

type cb_delete from w_com010_e`cb_delete within w_42073_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_42073_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42073_e
end type

type cb_update from w_com010_e`cb_update within w_42073_e
end type

type cb_print from w_com010_e`cb_print within w_42073_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_42073_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_42073_e
end type

type cb_excel from w_com010_e`cb_excel within w_42073_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_42073_e
integer x = 9
integer y = 148
integer width = 3552
integer height = 300
string dataobject = "d_42073_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;	
CHOOSE CASE dwo.name

   CASE "opt_gubn"	     //  Popup 검색창이 존재하는 항목 
		if data = "N" then
			this.object.t_deal_qty.visible = 1
			this.object.deal_qty.visible = 1
		else 	
			this.object.t_deal_qty.visible = 0
			this.object.deal_qty.visible = 0
		end if	
			
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_42073_e
integer beginy = 452
integer endy = 452
end type

type ln_2 from w_com010_e`ln_2 within w_42073_e
integer beginy = 456
integer endy = 456
end type

type dw_body from w_com010_e`dw_body within w_42073_e
integer x = 9
integer y = 476
integer width = 3561
integer height = 1524
string dataobject = "d_42073_d01"
end type

event dw_body::itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

STRING LS_YYMMDD
LONG LL_DEAL_SEQ, ll_cnt


CHOOSE CASE dwo.name
	CASE "proc_yn" 
//    IF data = 'Y' THEN
//		ls_yymmdd = this.getitemstring(row, "a_to_out_ymd")
//		LL_DEAL_SEQ = this.getitemNumber(row, "a_to_deal_seq")
//
//		select count(*)
//		into :ll_cnt
//		from tb_52031_h (nolock)
//		where out_ymd = :ls_yymmdd
//		  and deal_seq = :ll_deal_seq
//		  and isnull(dps_yn,'N') = 'Y'	;
//		
//		if ll_cnt > 0 then
//			messagebox("알림!", "선택한 변경될 차수는 이미 작업중인 배분 차수이기에 해당 차수로 변경 할 수 없습니다! 다른 차수를 입력하세요!")
//			this.setitem(row, "proc_yn","N")
////			this.setitem(row, "a_to_deal_seq",0)
//			return -1
//		end if
//		
//    END IF
	 
	 
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_body::buttonclicked;call super::buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_select"
		If is_opt_select = 'N' then
			is_opt_select = 'Y'
			This.Object.cb_select.Text = '전체제외'
		Else
			is_opt_select = 'N'
			This.Object.cb_select.Text = '전체선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "proc_yn", is_opt_select)
		Next
END CHOOSE

end event

event dw_body::constructor;call super::constructor;This.GetChild("shop_type", idw_shop_type1)
idw_shop_type1.SetTransObject(SQLCA)
idw_shop_type1.Retrieve('911')

This.GetChild("house_cd", idw_house_cd1)
idw_house_cd1.SetTransObject(SQLCA)
idw_house_cd1.Retrieve('%')

end event

type dw_print from w_com010_e`dw_print within w_42073_e
end type

type dw_1 from datawindow within w_42073_e
boolean visible = false
integer x = 827
integer y = 684
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

