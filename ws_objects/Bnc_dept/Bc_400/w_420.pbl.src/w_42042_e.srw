$PBExportHeader$w_42042_e.srw
$PBExportComments$행사완불요청등록
forward
global type w_42042_e from w_com010_e
end type
type cb_print1 from commandbutton within w_42042_e
end type
type cbx_a4 from checkbox within w_42042_e
end type
end forward

global type w_42042_e from w_com010_e
integer width = 3694
integer height = 2276
event ue_print1 ( )
cb_print1 cb_print1
cbx_a4 cbx_a4
end type
global w_42042_e w_42042_e

type variables
DataWindowChild idw_brand 
String is_brand, is_yymmdd, is_fr_ymd, is_to_ymd, is_accept_yn 
end variables

forward prototypes
public function boolean wf_out_update (long al_row, datetime ad_datetime, ref string as_err_msg)
public function boolean wf_margin_set (long al_row)
end prototypes

event ue_print1();Long   i , J
String ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_fg, ls_modify,ls_Error,ls_jup_name

dw_print.Dataobject = "d_com420_A4"
dw_print.SetTransObject(SQLCA)

if cbx_a4.checked then 		
   ls_jup_name = "(매 장 용)"	
		FOR i = 1 TO dw_body.RowCount() 
			 IF dw_body.Object.accept_yn[i] = "Y" and dw_body.Object.print_gubn[i] = "Y" THEN
				 ls_yymmdd    =  dw_body.GetitemString(i, "out_ymd")
				 ls_shop_cd   =  dw_body.GetitemString(i, "shop_cd")
				 ls_shop_type =  dw_body.GetitemString(i, "shop_type")
				 ls_out_no    =  dw_body.GetitemString(i, "out_no")
				 ls_out_fg    =  dw_body.GetitemString(i, "out_fg")
							
					if ls_out_fg = "N" and ls_shop_type = "4" then
						ls_shop_type = "1"
					elseif ls_out_fg = "N" and ls_shop_type = "3" then
						ls_shop_type = "3"				
					end if			 
				 dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')

				ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
				ls_Error = dw_print.Modify(ls_modify)
						IF (ls_Error <> "") THEN 
							MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
						END IF				 
				 
				 IF dw_print.RowCount() > 0 Then
					 il_rows = dw_print.Print()
				 END IF
			END IF
		NEXT 
ELSE		
		FOR i = 1 TO dw_body.RowCount() 
			 IF dw_body.Object.accept_yn[i] = "Y" and dw_body.Object.print_gubn[i] = "Y" THEN
				 ls_yymmdd    =  dw_body.GetitemString(i, "out_ymd")
				 ls_shop_cd   =  dw_body.GetitemString(i, "shop_cd")
				 ls_shop_type =  dw_body.GetitemString(i, "shop_type")
				 ls_out_no    =  dw_body.GetitemString(i, "out_no")
				 ls_out_fg    =  dw_body.GetitemString(i, "out_fg")
							
					if ls_out_fg = "N" and ls_shop_type = "4" then
						ls_shop_type = "1"
					elseif ls_out_fg = "N" and ls_shop_type = "3" then
						ls_shop_type = "3"				
					end if			 
					
				for j = 1 to 3
					if j = 1 then 
						ls_jup_name = "(거 래 처 용)"			
					elseif j = 2 then
						ls_jup_name = "(매 장 용)"			
					else
						ls_jup_name = "(창 고 용)"			
					end if					
					
						 dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')
		
						ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
						ls_Error = dw_print.Modify(ls_modify)
								IF (ls_Error <> "") THEN 
									MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
								END IF				 
						 
						 IF dw_print.RowCount() > 0 Then
							 il_rows = dw_print.Print()
						 END IF
					NEXT	 
			END IF
		NEXT 
END IF		

This.Trigger Event ue_msg(6, il_rows)


end event

public function boolean wf_out_update (long al_row, datetime ad_datetime, ref string as_err_msg);Long    ll_old_qty,   ll_new_qty  , ll_exist_cnt, ll_accept_qty
String  ls_accept_yn, ls_org_yn
String  ls_out_ymd,   ls_shop_cd, ls_shop_type, ls_out_no, ls_no 
String  ls_brand,     ls_year,    ls_season,    ls_item,   ls_sojae 
String  ls_style,     ls_chno,    ls_color,     ls_size,   ls_sale_type,ls_chno1 
String  ls_exist, LS_OUT_FG
Decimal ldc_tag_price,    ldc_curr_price, ldc_out_price 
Decimal ldc_out_collect,  ldc_vat 
Decimal ldc_Margin_Rate,  ldc_disc_Rate

ls_org_yn    = dw_body.GetitemString(al_row, "accept_yn",   Primary!, True)	
ls_accept_yn = dw_body.GetitemString(al_row, "accept_yn")  
ll_old_qty   = dw_body.GetitemNumber(al_row, "accept_qty",  Primary!, True)  
ll_new_qty   = dw_body.GetitemNumber(al_row, "accept_qty")	
ls_shop_cd   = dw_body.GetitemString(al_row, "shop_cd")  
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")
ls_style     = dw_body.GetitemString(al_row, "style")  
ls_chno      = dw_body.GetitemString(al_row, "chno")  
ls_color     = dw_body.GetitemString(al_row, "color")  
ls_size      = dw_body.GetitemString(al_row, "size")  
ls_out_fg    = dw_body.GetitemString(al_row, "out_fg")


if ls_out_fg = "N" and ls_shop_type = "4" then
	ls_shop_type = "1"
end if	


IF ls_accept_yn = 'N' and ls_org_yn = 'Y' THEN 
	ls_out_ymd   = dw_body.GetitemString(al_row, "out_ymd", Primary!, True)  
	ls_out_no    = dw_body.GetitemString(al_row, "out_no",  Primary!, True)  
	ls_no        = dw_body.GetitemString(al_row, "no",      Primary!, True)  
//	Return False 
	Delete from tb_52031_h
    where out_ymd     = :ls_out_ymd 
      and deal_seq    = case when :ls_shop_type = '3' then 98 
							  		  when :ls_shop_type = '1' then 97 
								     else 99 end	
	   and Shop_Cd     = :ls_shop_cd 
		and style       = :ls_style
		and chno        = :ls_chno
		and color       = :ls_color
		and size 	    = :ls_size	;
		
		
ELSEIF ls_accept_yn = 'Y' and ls_org_yn = 'Y' and ll_old_qty <> ll_new_qty THEN 
	ls_out_ymd   = dw_body.GetitemString(al_row, "out_ymd")  
	
	Update tb_52031_h
	   Set deal_qty    = :ll_new_qty, 
		    mod_id = :gs_user_id, 
			 mod_dt = :ad_dateTime  
    where out_ymd     = :ls_out_ymd 
	   and deal_seq    =  case when :ls_shop_type = '3' then 98 
 							  		   when :ls_shop_type = '1' then 97 
								     else 99 end	
	   and Shop_Cd     = :ls_shop_cd 
		and style       = :ls_style
		and chno        = :ls_chno
		and color       = :ls_color
		and size 	    = :ls_size	;
		
ELSEIF ls_accept_yn = 'Y' and ls_org_yn = 'N' THEN 

	
			
   ls_style        = dw_body.Object.style[al_row] 
   ls_chno1        = dw_body.Object.chno[al_row] 
   ls_color        = dw_body.Object.color[al_row] 
   ls_size         = dw_body.Object.size[al_row] 
   ls_brand        = dw_body.Object.brand[al_row] 
   ls_year         = dw_body.Object.year[al_row] 
   ls_season       = dw_body.Object.season[al_row] 
   ls_item         = dw_body.Object.item[al_row] 
   ls_sojae        = dw_body.Object.sojae[al_row] 
  // ll_accept_qty   = dw_body.Object.ll_accept_qty[al_row] 	

//out_ymd	deal_seq	style		chno		color		size		deal_fg	shop_cd	deal_qty	out_qty
//proc_yn	yymmdd	out_no	work_no	dps_yn	reg_id	reg_dt	mod_id	mod_dt	rshop_cd


	insert into tb_52031_h
  	    (	out_ymd,	deal_seq,	style,	chno,		color,	size,		
			deal_fg,	shop_cd,	deal_qty,	out_qty,
			proc_yn,	yymmdd,	out_no,	work_no,	dps_yn,	reg_id,	reg_dt)
      values 
	  	    (:is_yymmdd,         case when :ls_shop_type = '3' then 98 
		 							  		   when :ls_shop_type = '1' then 97 
								       else 99 end	,    
			  :ls_style,         :ls_chno,        :ls_color,        :ls_size, 
           '3',               :ls_shop_cd,	  :ll_new_qty	, :ll_new_qty ,
           'N',					:is_yymmdd,		  null,				  null,
			  'N',					:gs_user_id,       :ad_dateTime) ;

END IF 

IF SQLCA.SQLCODE <> 0 THEN 
	as_err_msg = SQLCA.SQLErrText
   Rollback  USING SQLCA;
	Return False 
ELSEIF ls_accept_yn = 'Y' and ls_org_yn = 'N' THEN 
   commit  USING SQLCA;
	dw_body.Setitem(al_row, "out_ymd", is_yymmdd)  
END IF

Return True 

end function

public function boolean wf_margin_set (long al_row);Long    ll_qty      
Long    ll_curr_price,  ll_out_price,  ll_out_collect
String  ls_sale_type = space(2)
String  ls_shop_cd,     ls_shop_type,  ls_style , ls_out_fg, ls_color
decimal ldc_marjin, ldc_dc_rate

ls_shop_cd   = dw_body.GetitemString(al_row, "shop_cd")
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")
ls_style     = dw_body.GetitemString(al_row, "style")
ls_color     = dw_body.GetitemString(al_row, "color")
ls_out_fg    = dw_body.GetitemString(al_row, "out_fg")


if ls_out_fg = "N" and ls_shop_type = "4" then
	ls_shop_type = "1"
end if	


/* 출고시 마진율 체크 */
IF gf_outmarjin_color (is_yymmdd,    ls_shop_cd, ls_shop_type, ls_style, ls_color, & 
                  ls_sale_type, ldc_marjin, ldc_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

ll_qty = dw_body.GetitemNumber(al_row, "accept_qty") 

/* 단가 및 율 등록 */
dw_body.Setitem(al_row, "curr_price",  ll_curr_price)
dw_body.Setitem(al_row, "sale_type",   ls_sale_type)
dw_body.Setitem(al_row, "disc_rate",   ldc_dc_rate)
dw_body.Setitem(al_row, "margin_rate", ldc_marjin)
dw_body.Setitem(al_row, "out_price",   ll_out_price)
ll_out_collect = ll_out_price * ll_qty
dw_body.Setitem(al_row, "out_collect", ll_out_collect)
dw_body.Setitem(al_row, "vat", ll_out_collect - Round(ll_out_collect / 1.1, 0))

RETURN True
end function

on w_42042_e.create
int iCurrent
call super::create
this.cb_print1=create cb_print1
this.cbx_a4=create cbx_a4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print1
this.Control[iCurrent+2]=this.cbx_a4
end on

on w_42042_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print1)
destroy(this.cbx_a4)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.22                                                  */	
/* 수정일      : 2002.03.22                                                  */
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


is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

IF DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 7 THEN
   MessageBox(ls_title,"1주일 이상 조회할수 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF	
is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")
if is_fr_ymd > is_to_ymd then
   MessageBox(ls_title,"종료일이 시작일보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_accept_yn = dw_head.GetItemString(1, "accept_yn")
if IsNull(is_accept_yn) or Trim(is_accept_yn) = "" then
   MessageBox(ls_title,"승인구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("accept_yn")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.22                                                  */	
/* 수정일      : 2002.02.22                                                  */
/*===========================================================================*/
String ls_modify
long ii

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.SetRedraw(False)
il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_accept_yn)
IF il_rows > 0 THEN 
	ls_modify = "accept_qty.Protect='0~tIf(isnull(out_ymd),0,If(out_ymd = ~~'" + is_yymmdd + "~~',0,1))' " + &
	            "accept_qty.Background.Color='16777215~tIf(isnull(out_ymd),16777215,If(out_ymd = ~~'" + is_yymmdd + "~~',16777215,12639424))' "  + &
	            "accept_yn.Protect='0~tIf(isnull(out_ymd),0,If(out_ymd = ~~'" + is_yymmdd + "~~',0,1))' " + &
	            "accept_yn.Background.Color='16777215~tIf(isnull(out_ymd),16777215,If(out_ymd = ~~'" + is_yymmdd + "~~',16777215,12639424))' " 
	dw_body.Modify(ls_modify)
   dw_body.SetFocus()
	for ii = 1 to il_rows
     dw_body.setitemstatus(ii, "accept_qty", primary!, dataModified!)
   next  
END IF
dw_body.SetRedraw(True)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;dw_head.Setitem(1, "accept_yn", "N")
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.22                                                  */	
/* 수정일      : 2002.02.22                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
String   ls_Err_Msg

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

il_rows = 1 
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime) 
		IF wf_out_update(i, ld_datetime, ls_Err_Msg) = FALSE THEN 
         Rollback  USING SQLCA;
			MessageBox("SQL 오류", ls_Err_Msg)
         This.Trigger Event ue_msg(3, -1)
			Return -1
		END IF 
   END IF
NEXT

IF il_rows = 1 THEN
   il_rows = dw_body.Update() 
END IF

if il_rows = 1 then
   commit  USING SQLCA;
gf_reserve_reset (ls_Err_Msg)		
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

Return il_rows

end event

event pfc_dberror;//
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i 
String ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_fg

dw_print.Dataobject = "d_com420"
dw_print.SetTransObject(SQLCA)

FOR i = 1 TO dw_body.RowCount() 
    IF dw_body.Object.accept_yn[i] = "Y" and dw_body.Object.print_gubn[i] = "Y" THEN
       ls_yymmdd    =  dw_body.GetitemString(i, "out_ymd")
	    ls_shop_cd   =  dw_body.GetitemString(i, "shop_cd")
       ls_shop_type =  dw_body.GetitemString(i, "shop_type")
   	 ls_out_no    =  dw_body.GetitemString(i, "out_no")
 		 ls_out_fg    =  dw_body.GetitemString(i, "out_fg")
					
			if ls_out_fg = "N" and ls_shop_type = "4" then
				ls_shop_type = "1"
			elseif ls_out_fg = "N" and ls_shop_type = "3" then
				ls_shop_type = "3"				
			end if			 
       dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')
       IF dw_print.RowCount() > 0 Then
          il_rows = dw_print.Print()
       END IF
	END IF
NEXT 

This.Trigger Event ue_msg(6, il_rows)

end event

event ue_print();
dw_print.Dataobject = "d_42042_r01"
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title()

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_yearseason

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pgm_id.Text = '" + is_pgm_id + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_fr_ymd.Text = '" + String(is_fr_ymd, '@@@@/@@/@@') + "'" + &										
				"t_to_ymd.Text = '" + String(is_to_ymd, '@@@@/@@/@@') + "'" 


dw_print.Modify(ls_modify)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
			cb_print1.enabled = true			
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
			cb_print1.enabled = FALSE						
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
//			cb_print.enabled = false
//			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_print1.enabled = true						
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
//         cb_print.enabled = false
//         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
//      cb_print.enabled = false
//      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42042_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42042_e
end type

type cb_delete from w_com010_e`cb_delete within w_42042_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_42042_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42042_e
end type

type cb_update from w_com010_e`cb_update within w_42042_e
end type

type cb_print from w_com010_e`cb_print within w_42042_e
end type

type cb_preview from w_com010_e`cb_preview within w_42042_e
boolean visible = false
integer width = 439
string text = "거래명세서(&V)"
end type

type gb_button from w_com010_e`gb_button within w_42042_e
end type

type cb_excel from w_com010_e`cb_excel within w_42042_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_42042_e
integer width = 3534
integer height = 152
string dataobject = "d_42042_h01"
end type

event dw_head::constructor;call super::constructor;

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_42042_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_42042_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_42042_e
integer x = 18
integer y = 368
integer height = 1668
string dataobject = "d_42042_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.Getchild("sale_type", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('011')

end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.22                                                  */	
/* 수정일      : 2002.03.22                                                  */
/*===========================================================================*/
Long    ll_qty,  ll_out_price, ll_out_collect , ll_stock_qty
String  ls_null, ls_org_yn 

ib_changed = true
cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
cb_excel.enabled = false


CHOOSE CASE dwo.name
	CASE "accept_qty" 
		ll_stock_qty = This.GetitemDecimal(row, "stock_qty")
		IF Long(Data) < 1 OR ll_stock_qty < Long(Data) THEN 
//			MessageBox("확인요망", "출고수량을 잘못 입력 하셨습니다.")
//			RETURN 1
		END IF
      ll_out_price = dw_body.GetitemDecimal(row, "out_price")
      ll_out_collect = ll_out_price * Long(Data)
	CASE "accept_yn" 
		IF Data = 'Y' THEN
			ll_qty    = This.GetitemDecimal(row, "accept_qty") 
			ls_org_yn = This.GetitemString(row, "accept_yn", Primary!, True) 
			IF ls_org_yn = 'Y' THEN
				This.Setitem(row, "out_ymd",     This.GetitemString(row, "out_ymd", Primary!, True))			
			ELSE
   			IF isnull(ll_qty) OR ll_qty = 0 THEN 
	   			This.Setitem(row, "accept_qty", This.GetitemDecimal(row, "rqst_qty"))
		   	END IF 
			END IF
		ELSE
			SetNull(ll_qty)
			SetNull(ls_Null)
			This.Setitem(row, "out_ymd",     ls_null)
			This.Setitem(row, "out_no",      ls_null)
		END IF
END CHOOSE

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::dberror;//
end event

event dw_body::clicked;call super::clicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_e`dw_print within w_42042_e
integer x = 302
integer y = 768
string dataobject = "d_42042_R01"
end type

type cb_print1 from commandbutton within w_42042_e
boolean visible = false
integer x = 375
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "명세서(A4)"
end type

event clicked;Parent.Trigger Event ue_print1()
end event

type cbx_a4 from checkbox within w_42042_e
boolean visible = false
integer x = 731
integer y = 60
integer width = 585
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서A4(매장용)"
borderstyle borderstyle = stylelowered!
end type

