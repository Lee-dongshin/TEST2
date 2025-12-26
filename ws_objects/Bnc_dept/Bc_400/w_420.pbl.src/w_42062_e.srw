$PBExportHeader$w_42062_e.srw
$PBExportComments$유통불량반품승인
forward
global type w_42062_e from w_com010_e
end type
type dw_1 from datawindow within w_42062_e
end type
end forward

global type w_42062_e from w_com010_e
integer width = 3648
dw_1 dw_1
end type
global w_42062_e w_42062_e

type variables
DataWindowChild idw_brand, idw_year , idw_season, idw_color, idw_tran_cust
string is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_proc_gubn, is_year, is_season, is_yymmdd
end variables

on w_42062_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_42062_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42062_e","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_brand
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column


CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			
			ls_brand = dw_head.getitemstring(1, "brand")
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			IF  gl_user_level >= 50 then 
					gst_cd.default_where   = "WHERE   shop_cd like '" + ls_brand + "%'"	
				else 	
					gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			end if
			
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
				dw_head.SetColumn("year")
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
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
	is_shop_cd = "%"
end if

is_proc_gubn = dw_head.GetItemString(1, "proc_gubn")
if IsNull(is_proc_gubn) or Trim(is_proc_gubn) = "" then
   MessageBox(ls_title,"처리구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_gubn")
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
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"반품일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_proc_gubn, is_year, is_season)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_ok
integer li_no, li_qty
datetime ld_datetime
string ls_shop_cd, ls_shop_type, ls_style, ls_chno, ls_color, ls_size, ls_reason, ls_out_dest,ls_rtrn_yn, ls_rtrn_no, ls_yymmdd
string ls_out_no
ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	
 ls_shop_cd 	= dw_body.getitemstring(i, "shop_cd")	
 ls_shop_type 	= dw_body.getitemstring(i, "shop_type")	 
 li_no  			= dw_body.getitemNumber(i, "no") 
 ls_style 		= dw_body.getitemstring(i, "style") 
 ls_chno			= dw_body.getitemstring(i, "chno") 
 ls_color		= dw_body.getitemstring(i, "color") 
 ls_size 		= dw_body.getitemstring(i, "size") 
 li_qty 			= dw_body.getitemNumber(i, "qty")  
 ls_reason 		= dw_body.getitemstring(i, "reason") 
 ls_out_dest 	= dw_body.getitemstring(i, "out_dest")  
 ls_rtrn_no 	= dw_body.getitemstring(i, "rtrn_no") 
 ls_rtrn_yn		= dw_body.getitemstring(i, "rtrn_yn") 
 ls_yymmdd		= dw_body.getitemstring(i, "yymmdd")  
 ls_out_no     = dw_body.getitemstring(i, "out_no")  
 
	 if (isnull(ls_rtrn_no) and ls_rtrn_yn = "Y") or (isnull(ls_out_no) and ls_rtrn_yn = "S" )then 
			
		 DECLARE sp_42062_proc PROCEDURE FOR sp_42062_proc  
         @BRAND 		= :is_brand,   
         @yymmdd 		= :is_yymmdd,   
         @shop_cd 	= :ls_shop_cd,   
         @shop_type 	= :ls_shop_type,   
         @no 			= :li_no,   
         @style 		= :ls_style,   
         @chno			= :ls_chno,   
         @color 		= :ls_color,   
         @size 		= :ls_size,   
         @qty 			= :li_qty,   
         @reason 		= :ls_reason,   
         @out_dest 	= :ls_out_dest,   
         @rtrn_yn 	= :ls_rtrn_yn,   
         @reg_id 		= :gs_user_id,
			@yymmdd_d	= :ls_yymmdd	;

		 execute sp_42062_proc;
		 commit  USING SQLCA; 	

//		messagebox("i", string(i, "0000"))
		 
		IF SQLCA.SQLCODE <> 0  THEN 
			rollback  USING SQLCA; 
		else 
			ll_ok = ll_ok + 1
		END IF 

		
	end if				 
			
NEXT




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
	
	if ll_ok > 0 then 
		messagebox("알림!" , "총 " + string(ll_ok) + "건의 자료가 처리되었습니다!")
	   ib_changed = false
		Trigger Event ue_retrieve()
	 end if
	
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event ue_print();Long   i , ll_row
String ls_rtrn_shop_cd, ls_rtrn_shop_type, ls_rtrn_ymd, ls_rtrn_no, ls_out_shop, ls_out_shop_type, ls_out_ymd,	ls_out_no
string ls_rtrn_prt, ls_out_prt, ls_out_gubn, ls_yymmdd,  ls_shop_cd, ls_shop_type,ls_yymmdd1
string ls_find

	dw_print.DataObject = "d_com420"
	dw_print.SetTransObject(SQLCA)
	dw_1.reset()
	
FOR i = 1 TO dw_body.RowCount() 
	ls_rtrn_prt = dw_body.getitemstring(i, "rtrn_prt")
	ls_out_prt  = dw_body.getitemstring(i, "out_prt")	
	IF ls_rtrn_prt = "Y" or ls_out_prt = "Y" THEN 			
		ls_yymmdd1		    = dw_body.GetitemString(i, "yymmdd")			 
		ls_rtrn_ymd        = dw_body.GetitemString(i, "rtrn_ymd")			 
		ls_rtrn_no         = dw_body.GetitemString(i, "rtrn_no")
		ls_shop_cd         = dw_body.GetitemString(i, "shop_cd") 
		ls_rtrn_shop_type  = dw_body.GetitemString(i, "rtrn_shop_type")
		ls_out_ymd         = dw_body.GetitemString(i, "out_ymd")			 
		ls_out_no          = dw_body.GetitemString(i, "out_no")
		ls_out_shop        = dw_body.GetitemString(i, "out_shop") 
		ls_out_shop_type   = dw_body.GetitemString(i, "out_shop_type")
	END IF 	
	

		ls_Find  = "rtrn_ymd = '" + ls_rtrn_ymd + "' and rtrn_no = '" + ls_rtrn_no + "'and  shop_cd = '" + ls_shop_cd + "' And rtrn_shop_type = '" + ls_rtrn_shop_type + "' and rtrn_prt = '" + ls_rtrn_prt + "'"
//		messagebox("ls_Find",ls_Find)
		ll_row = dw_1.Find(ls_Find, 1, dw_1.RowCount()) 
		IF ll_row > 0 THEN 
			dw_1.Setitem(ll_row, "yymmdd",    ls_yymmdd1)
			dw_1.Setitem(ll_row, "shop_cd",   ls_shop_cd)
			dw_1.Setitem(ll_row, "rtrn_shop_type",   ls_rtrn_shop_type)			
			dw_1.Setitem(ll_row, "rtrn_ymd",   ls_rtrn_ymd)						
			dw_1.Setitem(ll_row, "rtrn_no",   ls_rtrn_no)									
			dw_1.Setitem(ll_row, "rtrn_prt",   ls_rtrn_prt)					
			dw_1.Setitem(ll_row, "out_shop",   ls_out_shop)									
			dw_1.Setitem(ll_row, "out_shop_type",   ls_out_shop_type)												
			dw_1.Setitem(ll_row, "out_ymd",   ls_out_ymd)												
			dw_1.Setitem(ll_row, "out_no",   ls_out_no)		
			dw_1.Setitem(ll_row, "out_prt",   ls_out_prt)		
		else
			ll_row = dw_1.insertRow(0)
			dw_1.Setitem(ll_row, "yymmdd",    ls_yymmdd1)
			dw_1.Setitem(ll_row, "shop_cd",   ls_shop_cd)
			dw_1.Setitem(ll_row, "rtrn_shop_type",   ls_rtrn_shop_type)			
			dw_1.Setitem(ll_row, "rtrn_ymd",   ls_rtrn_ymd)						
			dw_1.Setitem(ll_row, "rtrn_no",   ls_rtrn_no)									
			dw_1.Setitem(ll_row, "out_shop",   ls_out_shop)									
			dw_1.Setitem(ll_row, "out_shop_type",   ls_out_shop_type)												
			dw_1.Setitem(ll_row, "out_ymd",   ls_out_ymd)												
			dw_1.Setitem(ll_row, "out_no",   ls_out_no)															
			dw_1.Setitem(ll_row, "rtrn_prt",   ls_rtrn_prt)																		
			dw_1.Setitem(ll_row, "out_prt",   ls_out_prt)																					
		END IF
		
NEXT 

ls_rtrn_prt  = ''
ls_out_prt   = ''
ls_yymmdd    = ''
ls_out_no    = ''
ls_shop_cd   = ''
ls_shop_type = ''


FOR i = 1 TO dw_body.RowCount() 
	ls_rtrn_prt = dw_1.getitemstring(i, "rtrn_prt")
	ls_out_prt  = dw_1.getitemstring(i, "out_prt")	
	IF ls_rtrn_prt = "Y"  THEN 
		ls_yymmdd     = dw_1.GetitemString(i, "rtrn_ymd")			 
		ls_out_no     = dw_1.GetitemString(i, "rtrn_no")
		ls_shop_cd    = dw_1.GetitemString(i, "shop_cd") 
		ls_shop_type  = dw_1.GetitemString(i, "rtrn_shop_type")
		ls_out_gubn = "2"		

		il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
		IF dw_print.RowCount() > 0 Then
			il_rows = dw_print.Print()
		END IF
	END IF 	
	
	IF ls_out_prt = "Y"  THEN 
		ls_yymmdd     = dw_1.GetitemString(i, "out_ymd")			 
		ls_out_no     = dw_1.GetitemString(i, "out_no")
		ls_shop_cd    = dw_1.GetitemString(i, "out_shop") 
		ls_shop_type  = dw_1.GetitemString(i, "out_shop_type")
		ls_out_gubn = "1"		

		il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
		IF dw_print.RowCount() > 0 Then
			il_rows = dw_print.Print()
		END IF
	END IF 	
	
NEXT 
	
This.Trigger Event ue_msg(6, il_rows)
end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event ue_preview();
dw_print.DataObject = "d_42062_r01"
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title ()

dw_print.GetChild("tran_cust", idw_tran_cust)
idw_tran_cust.SetTransObject(SQLCA)
idw_tran_cust.Retrieve('404')


dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_shop, ls_shop_cd, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_shop_cd = dw_head.getitemstring(1, "shop_cd")
if isnull(ls_shop_cd ) or LenA(ls_shop_cd) = 0 then
	ls_shop_cd = "%"
end if

ls_shop_nm = dw_head.getitemstring(1, "shop_nm")
if isnull(ls_shop_nm ) or LenA(ls_shop_nm) = 0 then
	ls_shop_nm = "전체"
end if

ls_shop = ls_shop_cd + ' ' + ls_shop_nm

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
			    "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
			    "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &				 
			    "t_to_ymd.Text = '" + is_to_ymd + "'" + &				 				 
			    "t_shop.Text = '" + ls_shop + "'" + &				 				 
			    "t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &				 
			    "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &				 				 
			    "t_proc_gubn.Text = '" + is_proc_gubn  + "'"



dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_e`cb_close within w_42062_e
end type

type cb_delete from w_com010_e`cb_delete within w_42062_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_42062_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42062_e
end type

type cb_update from w_com010_e`cb_update within w_42062_e
end type

type cb_print from w_com010_e`cb_print within w_42062_e
integer x = 1385
integer width = 384
string text = "전표출력(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_42062_e
end type

type gb_button from w_com010_e`gb_button within w_42062_e
end type

type cb_excel from w_com010_e`cb_excel within w_42062_e
end type

type dw_head from w_com010_e`dw_head within w_42062_e
string dataobject = "d_42062_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')




// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "shop_cd", "style"	     //  Popup 검색창이 존재하는 항목 
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
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_42062_e
end type

type ln_2 from w_com010_e`ln_2 within w_42062_e
end type

type dw_body from w_com010_e`dw_body within w_42062_e
string dataobject = "d_42062_d01"
end type

event dw_body::constructor;call super::constructor;
string ls_filter_str

This.SetRowFocusIndicator(Hand!)

This.GetChild("tran_cust", idw_tran_cust)
idw_tran_cust.SetTransObject(SQLCA)
idw_tran_cust.Retrieve('404')

ls_filter_str = "inter_cd in ('M02','M07','M08', 'M10') " 
idw_tran_cust.SetFilter(ls_filter_str)
idw_tran_cust.Filter( )

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()
end event

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "rtrn_prt" ,"out_prt"
	   ib_changed = false
		cb_update.enabled = false
		cb_print.enabled = true		



END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_42062_e
string dataobject = "d_42062_r01"
end type

type dw_1 from datawindow within w_42062_e
boolean visible = false
integer x = 585
integer y = 652
integer width = 3003
integer height = 692
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_42062_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

