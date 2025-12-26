$PBExportHeader$w_73010_e.srw
$PBExportComments$smS 발송요청 확인
forward
global type w_73010_e from w_com020_e
end type
type dw_1 from u_dw within w_73010_e
end type
end forward

global type w_73010_e from w_com020_e
dw_1 dw_1
end type
global w_73010_e w_73010_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_cust_grade
String is_shop_cd, is_brand, is_yymm
end variables

forward prototypes
public function integer wf_resizepanels ()
end prototypes

public function integer wf_resizepanels ();// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = dw_body.X + dw_body.Width - st_1.X - ii_BarThickness

dw_list.Resize (st_1.X - dw_list.X, dw_list.Height)

dw_body.Move (st_1.X + ii_BarThickness, dw_body.Y)
dw_body.Resize (ll_Width, dw_body.Height)

dw_1.Move (st_1.X + ii_BarThickness, dw_1.Y)
dw_1.Resize (ll_Width, dw_1.Height)
Return 1


end function

on w_73010_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_73010_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_73010_e","0")
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

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"요청월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_shop_cd, is_yymm)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)
dw_1.insertrow(0)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
String ls_snd_ymd, ls_smscontents, ls_mkt_type, ls_sale_diff,ls_birth_day, ls_only_birth, ls_cist_grade, ls_season
String ls_season_opt, ls_year,  ls_rqst_no, ls_cust_grade, ls_yymmdd ,ls_user_name,	ls_tel_no3	,ls_sale_diff2
decimal ldc_sale_amt, ldc_sale_cnt, ldc_mileage
int li_rqst_cnt, li_no
String ls_shoP_cd,  ls_biz_chk, ls_crm_chk,	ls_biz_reason, ls_crm_reason,	ls_accept_send	

		ls_shop_cd     = dw_1.getitemstring(1, "shoP_cd")
		ls_yymmdd      = dw_1.getitemstring(1, "yymmdd")
		ls_rqst_no     = dw_1.getitemstring(1, "rqst_no")
		ls_mkt_type    = dw_1.getitemstring(1, "opt_ret")
		ls_snd_ymd     = dw_1.getitemstring(1, "snd_ymd")
		ls_smscontents = dw_1.getitemstring(1, "smscontents")			
		ls_sale_diff   = dw_1.getitemstring(1,"sale_diff")	
		ls_sale_diff2  = dw_1.getitemstring(1,"sale_diff2")			
		ldc_sale_amt   = dw_1.getitemnumber(1,"sale_amt")
		ldc_sale_cnt   = dw_1.getitemnumber(1,"sale_cnt")		
		ldc_mileage    = dw_1.getitemnumber(1,"mileage")				
		ls_birth_day   = dw_1.getitemstring(1,"birth_day")			
		ls_only_birth  = dw_1.getitemstring(1,"only_birth")					
		ls_cust_grade  = dw_1.getitemstring(1,"cust_grade")							
		ls_season_opt  = dw_1.getitemstring(1,"season_opt")									
		ls_year        = dw_1.getitemstring(1,"year")									
		ls_season      = dw_1.getitemstring(1,"season")											
		li_rqst_cnt    = dw_1.getitemNumber(1,"rqst_cnt")											
		ls_biz_chk     = dw_1.getitemstring(1,"biz_chk")											
		ls_crm_chk     = dw_1.getitemstring(1,"crm_chk")											
		ls_biz_reason  = dw_1.getitemstring(1,"biz_reason")													
		ls_crm_reason  = dw_1.getitemstring(1,"crm_reason")															
		ls_accept_send = dw_1.getitemstring(1,"accept_send")																	
		ls_snd_ymd     = dw_1.getitemstring(1,"snd_ymd")																			
		ls_smscontents = dw_1.getitemstring(1,"smscontents")																					




//----------------------------------------------------------
ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	
		dw_body.Setitem(i, "sms_contents", ls_smscontents)
		dw_body.Setitem(i, "biz_chk", ls_biz_chk)
		dw_body.Setitem(i, "crm_chk", ls_crm_chk)
		dw_body.Setitem(i, "biz_reason", ls_biz_reason)
		dw_body.Setitem(i, "crm_reason", ls_crm_reason)
		dw_body.Setitem(i, "accept_send", ls_accept_send)
		dw_body.Setitem(i, "snd_ymd", ls_snd_ymd)

NEXT

	
		select convert(integer, max(no)) + 1
		into :li_no
		from tb_71085_H (nolock)
		where yymmdd = :ls_yymmdd
		  and rqst_no = :ls_rqst_no
		  and shoP_cd = :ls_shop_cd;


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	
	ls_user_name = dw_body.getitemstring(i, "user_name")
	ls_tel_no3 = dw_body.getitemstring(i, "tel_no3")	
	
	if isnull(ls_user_name) or isnull(ls_tel_no3) then 
		messagebox("알림!", "고객명과 핸드폰번호는 반드시 입력하셔야 합니다!")
		RETURN -1
	end if	
	
   IF idw_status = NewModified! THEN				/* New Record */
	
		dw_body.Setitem(i, "yymmdd", ls_yymmdd)
		dw_body.Setitem(i, "rqst_no", ls_rqst_no)
		dw_body.Setitem(i, "no", string(li_no,"0000"))		

		dw_body.Setitem(i, "shop_cd", ls_shop_cd)
		dw_body.Setitem(i, "mkt_type", ls_mkt_type)
		//jumin		user_name	tel_no3		birthday			zip		addr
		//sale_cnt	sale_amt		score			total_point
		dw_body.Setitem(i, "sms_contents", ls_smscontents)
		dw_body.Setitem(i, "biz_chk", ls_biz_chk)
		dw_body.Setitem(i, "crm_chk", ls_crm_chk)
		dw_body.Setitem(i, "biz_reason", ls_biz_reason)
		dw_body.Setitem(i, "crm_reason", ls_crm_reason)
		dw_body.Setitem(i, "accept_send", ls_accept_send)
		dw_body.Setitem(i, "snd_ymd", ls_snd_ymd)
		
		dw_body.Setitem(i, "i_sale_diff", ls_sale_diff)
		dw_body.Setitem(i, "i_sale_diff2", ls_sale_diff2)		
		dw_body.Setitem(i, "i_sale_cnt", ldc_sale_cnt)
		dw_body.Setitem(i, "i_sale_amt", ldc_sale_amt)
		dw_body.Setitem(i, "i_mileage", ldc_mileage)
		dw_body.Setitem(i, "i_birth_day", ls_birth_day)
		dw_body.Setitem(i, "i_only_birth", ls_only_birth)
		dw_body.Setitem(i, "i_cust_grade", ls_cust_grade)
		dw_body.Setitem(i, "i_season_opt", ls_season_opt)
		dw_body.Setitem(i, "i_year", ls_year)
		dw_body.Setitem(i, "i_season", ls_season)
		dw_body.Setitem(i, "i_rqst_cnt", li_rqst_cnt)
      dw_body.Setitem(i, "reg_id", gs_user_id)
		li_no = li_no + 1
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_body.Setitem(i, "biz_chk", ls_biz_chk)
		dw_body.Setitem(i, "crm_chk", ls_crm_chk)
		dw_body.Setitem(i, "biz_reason", ls_biz_reason)
		dw_body.Setitem(i, "crm_reason", ls_crm_reason)		
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

type cb_close from w_com020_e`cb_close within w_73010_e
end type

type cb_delete from w_com020_e`cb_delete within w_73010_e
end type

type cb_insert from w_com020_e`cb_insert within w_73010_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_73010_e
end type

type cb_update from w_com020_e`cb_update within w_73010_e
end type

type cb_print from w_com020_e`cb_print within w_73010_e
end type

type cb_preview from w_com020_e`cb_preview within w_73010_e
end type

type gb_button from w_com020_e`gb_button within w_73010_e
end type

type cb_excel from w_com020_e`cb_excel within w_73010_e
end type

type dw_head from w_com020_e`dw_head within w_73010_e
integer height = 156
string dataobject = "d_73010_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com020_e`ln_1 within w_73010_e
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com020_e`ln_2 within w_73010_e
integer beginy = 344
integer endy = 344
end type

type dw_list from w_com020_e`dw_list within w_73010_e
integer x = 9
integer y = 352
integer width = 2149
integer height = 1660
string dataobject = "d_73010_d01"
end type

event dw_list::clicked;call super::clicked;String ls_snd_ymd, ls_smscontents, ls_mkt_type, ls_sale_diff,ls_birth_day, ls_only_birth, ls_cist_grade, ls_season
String ls_season_opt, ls_year,  ls_rqst_no, ls_cust_grade ,ls_sale_diff2
decimal ldc_sale_amt, ldc_sale_cnt, ldc_mileage
int li_rqst_cnt
String ls_yymmdd, ls_shoP_cd,  ls_biz_chk, ls_crm_chk,	ls_biz_reason, ls_crm_reason,	ls_accept_send	

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


ls_yymmdd  = dw_list.getitemstring(ROW, "yymmdd")
ls_shop_cd  = dw_list.getitemstring(ROW, "shop_cd")
ls_rqst_no  = dw_list.getitemstring(ROW, "rqst_no")

IF IsNull(ls_yymmdd) THEN return
IF IsNull(ls_shop_cd) THEN return
IF IsNull(ls_rqst_no) THEN return



il_rows = dw_body.retrieve(ls_yymmdd, ls_rqst_no, ls_shop_cd)

IF il_rows > 0 THEN	
	

		ls_rqst_no     = dw_body.getitemstring(1, "rqst_no")
		ls_mkt_type    = dw_body.getitemstring(1, "mkt_type")
		ls_snd_ymd     = dw_body.getitemstring(1, "snd_ymd")
		ls_smscontents = dw_body.getitemstring(1, "sms_contents")			
		ls_sale_diff   = dw_body.getitemstring(1,"i_sale_diff")	
		ls_sale_diff2  = dw_body.getitemstring(1,"i_sale_diff2")			
		ldc_sale_amt   = dw_body.getitemnumber(1,"i_sale_amt")
		ldc_sale_cnt   = dw_body.getitemnumber(1,"i_sale_cnt")		
		ldc_mileage    = dw_body.getitemnumber(1,"i_mileage")				
		ls_birth_day   = dw_body.getitemstring(1,"i_birth_day")			
		ls_only_birth  = dw_body.getitemstring(1,"i_only_birth")					
		ls_cust_grade  = dw_body.getitemstring(1,"i_cust_grade")							
		ls_season_opt  = dw_body.getitemstring(1,"i_season_opt")									
		ls_year        = dw_body.getitemstring(1,"i_year")									
		ls_season      = dw_body.getitemstring(1,"i_season")											
		li_rqst_cnt    = dw_body.getitemNumber(1,"i_rqst_cnt")											
		ls_biz_chk     = dw_body.getitemstring(1,"biz_chk")											
		ls_crm_chk     = dw_body.getitemstring(1,"crm_chk")											
		ls_biz_reason  = dw_body.getitemstring(1,"biz_reason")													
		ls_crm_reason  = dw_body.getitemstring(1,"crm_reason")															
		ls_accept_send = dw_body.getitemstring(1,"accept_send")																	
		ls_snd_ymd = dw_body.getitemstring(1,"snd_ymd")																			
		ls_smscontents = dw_body.getitemstring(1,"sms_contents")																					

		
		
		dw_1.setitem(1,"SHOP_CD", ls_SHOP_CD) 		
		dw_1.setitem(1,"yymmdd", ls_yymmdd) 		
		dw_1.setitem(1,"rqst_no", ls_rqst_no) 				
		dw_1.setitem(1,"opt_ret", ls_mkt_type) 
		dw_1.setitem(1,"snd_ymd", ls_snd_ymd) 
		dw_1.setitem(1,"sale_diff", ls_sale_diff) 	
		dw_1.setitem(1,"sale_diff2", ls_sale_diff2) 			
		dw_1.setitem(1,"sale_amt", ldc_sale_amt) 	
		dw_1.setitem(1,"sale_cnt", ldc_sale_cnt) 	
		dw_1.setitem(1,"mileage", ldc_mileage) 	
		dw_1.setitem(1,"birth_day", ls_birth_day) 	
		dw_1.setitem(1,"only_birth", ls_only_birth) 	
		dw_1.setitem(1,"cust_grade", ls_cust_grade) 	
		dw_1.setitem(1,"season_opt", ls_season_opt) 	
		dw_1.setitem(1,"year", ls_year) 	
		dw_1.setitem(1,"season", ls_season) 			
		dw_1.setitem(1,"rqst_cnt", li_rqst_cnt) 					
		
		dw_1.setitem(1,"biz_chk", ls_biz_chk) 					
		dw_1.setitem(1,"crm_chk", ls_crm_chk) 					
		dw_1.setitem(1,"biz_reason", ls_biz_reason) 					
		dw_1.setitem(1,"crm_reason", ls_crm_reason) 					
		dw_1.setitem(1,"accept_send", ls_accept_send) 							
		dw_1.setitem(1,"snd_ymd", ls_snd_ymd) 					
		dw_1.setitem(1,"smscontents", ls_smscontents) 							
				
	end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_73010_e
integer x = 2176
integer y = 1284
integer width = 1417
integer height = 728
string dataobject = "d_73010_d03"
boolean hscrollbar = true
end type

event dw_body::dberror;//
end event

type st_1 from w_com020_e`st_1 within w_73010_e
integer x = 2158
integer y = 352
integer height = 1660
end type

type dw_print from w_com020_e`dw_print within w_73010_e
end type

type dw_1 from u_dw within w_73010_e
integer x = 2176
integer y = 360
integer width = 1417
integer height = 916
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_73010_d02"
boolean hscrollbar = true
end type

event constructor;call super::constructor;This.GetChild("cust_grade", idw_cust_grade )
idw_cust_grade.SetTransObject(SQLCA)
idw_cust_grade.Retrieve('704')
idw_cust_grade.insertRow(1)
idw_cust_grade.Setitem(1, "inter_cd", "%")
idw_cust_grade.Setitem(1, "inter_nm", "전체")

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertRow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_cd1", "%")
idw_year.Setitem(1, "inter_nm", "전체")


This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertRow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


end event

event itemchanged;call super::itemchanged;long ll_row
integer i

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false


ll_row = dw_body.RowCount()

CHOOSE CASE dwo.name
	CASE "accept_send" 
		
     for i = 1 to ll_row
		  dw_body.setitem(i, "accept_send", data)		
	  next	
	  
	CASE "biz_chk" 		
     for i = 1 to ll_row
		  dw_body.setitem(i, "biz_chk", data)		
	  next		
	  
	CASE "crm_chk" 		
	  
     for i = 1 to ll_row
		  dw_body.setitem(i, "crm_chk", data)		
	  next		
	  
	CASE "biz_reason" 		
     for i = 1 to ll_row
		  dw_body.setitem(i, "biz_reason", data)		
	  next		
	  
	CASE "crm_reason" 		
     for i = 1 to ll_row
		  dw_body.setitem(i, "crm_reason", data)		
	  next		  
	 
	CASE "snd_ymd" 		
     for i = 1 to ll_row
		  dw_body.setitem(i, "snd_ymd", data)		
	  next	
	  
	CASE "smscontents" 		
     for i = 1 to ll_row
		  dw_body.setitem(i, "sms_contents", data)		
	  next		  
//	 
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

