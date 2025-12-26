$PBExportHeader$w_sh170_e.srw
$PBExportComments$매장행사제품요청
forward
global type w_sh170_e from w_com010_e
end type
type st_2 from statictext within w_sh170_e
end type
end forward

global type w_sh170_e from w_com010_e
integer width = 2981
integer height = 2088
st_2 st_2
end type
global w_sh170_e w_sh170_e

type variables
String is_yymmdd
DataWindowChild idw_color
end variables

forward prototypes
public subroutine wf_style_dup (long al_row, string as_style)
public function boolean wf_stock_chk (long al_row, string as_style_no)
public function boolean wf_style_chk_color (long al_row, string as_style_no, string as_color)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public subroutine wf_style_dup (long al_row, string as_style);
end subroutine

public function boolean wf_stock_chk (long al_row, string as_style_no);String ls_style, ls_chno, ls_color, ls_size , ls_find
Long   ll_stock_qty, ll_cnt_stop, ll_row_count, i, k, ll, ll_chk_qty

//IF Len(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

//select dbo.sf_get_stockqty(:gs_shop_cd, '1', :ls_style, :ls_chno, :ls_color, :ls_size)
//  into :ll_stock_qty
//  from dual;
//
//
//// 기존의 완불등록사항및 승인체크
//select isnull(sum(d.rqst_qty) - (sum(d.accept_qty) +  sum(d.check_cnt)),0)
//into :ll_chk_qty
//from (		
//	select sum(a.rqst_qty) 		as rqst_qty,
//	       sum(a.Accept_Qty)	as accept_qty,
//	
//		isnull((select sum(b.Accept_Qty)
//		  from tb_54031_d b
//		  where b.shop_cd = a.shop_cd
//		  and   b.yymmdd  = a.yymmdd
//		  and   b.rqst_seq = a.rqst_seq
//		  and   b.shop_type = a.shop_type
//		  and   b.accept_fg = 'Y' ),0) as check_cnt	
//	from tb_54030_h a with (nolock) 
//	where a.self_yn = 'N'
//	and   a.yymmdd  >= '20030714'
//	and   a.shop_cd = :gs_shop_cd
//	and   a.style   = :ls_style
//	and   a.chno    = :ls_chno
//	and   a.color   = :ls_color
//	and   a.size    = :ls_size
//	group by a.shop_cd, a.yymmdd, a.rqst_seq,a.shop_type ) d ;
//
//
//
////messagebox("ll_stock_qty", string(ll_stock_qty))
////messagebox("ll_chk_qty", string(ll_chk_qty))
//
//ll_stock_qty = ll_stock_qty + ll_chk_qty
//
////messagebox("ll_stock_qty", string(ll_stock_qty))
////messagebox("ll_chk_qty", string(ll_chk_qty))
////
//ll_row_count = dw_body.rowcount() 
//
//for i = 1 to ll_row_count - 1
//	ls_find = "style_no = '" + ls_style + ls_chno +  ls_color + ls_size + "'"
//	
//	if i <> al_row then
//		k = dw_body.find(ls_find, 1, ll_row_count)		
//   end if
//	
//	if k <> 0 then
//	 ll = dw_body.getitemnumber(k, "rqst_qty")
//   end if
//
////   messagebox("ll_stock_qty", string(ll_stock_qty))
//	
//	ll_stock_qty = ll_stock_qty + ll
//next  
//
//IF sqlca.sqlcode <> 0 THEN 
//	MessageBox("SQL 오류", SQLCA.SQLERRTEXT) 
//	RETURN FALSE 
//ELSEIF ll_stock_qty >= 0 THEN 
//	MessageBox("확인", "재고가 있거나 이미 요청한 제품은 의뢰할수 없습니다!") 
//	dw_body.setitem(al_row, "style_no", "")
//	RETURN FALSE 
//END IF
//
//  
//	select count(style)
//	into :ll_cnt_stop
//	from tb_54040_m
// where brand   = :gs_brand 
//   and style   = :ls_style 
//	and chno    = :ls_chno
//	and color   = :ls_color 
//	and size    = :ls_size
//	and fr_stop_date <= :is_yymmdd
//	and to_stop_date >= :is_yymmdd ;
//	
//
//IF SQLCA.SQLCODE <> 0 THEN 
//	MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
//	RETURN FALSE 
//END IF
//
//
//IF ll_cnt_stop <> 0  THEN 
//	MessageBox("확인", "완불통제된 상품이므로  의뢰할수 없습니다!")
//		dw_body.setitem(al_row, "style_no", "")
//	RETURN FALSE 
//END IF
//
//dw_body.Setitem(al_row, "rqst_qty", 1)

Return True

end function

public function boolean wf_style_chk_color (long al_row, string as_style_no, string as_color);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null, ls_shop_type
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2
String ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
Long   ll_tag_price,  ll_cnt 
SetNull(ls_null)


Ls_style = LeftA(as_style_no, 8)


Select count(style), 
       max(style)  ,   
       max(brand)  ,   max(year),     max(season),     
       max(sojae)  ,   max(item),     max(tag_price)  
  into :ll_cnt     , 
       :ls_style   ,   
       :ls_brand   ,   :ls_year,      :ls_season, 
		 :ls_sojae   ,   :ls_item,      :ll_tag_price
  from vi_12020_1 with (nolock) 
 where style   like :ls_style 
	and brand   = 	  :Gs_brand
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 


   dw_BODY.SetItem(al_row, "style",    ls_style)
	dw_BODY.SetItem(al_row, "brand",    ls_brand)
	
//	if is_yymmdd <= '20170915' then
//		Select shop_type
//		into :ls_shop_type
//		From tb_56012_d with (nolock)
//		Where style      = :ls_style 
//		  and start_ymd <= :is_yymmdd
//		  and end_ymd   >= :is_yymmdd
//		  and shop_cd    = :gs_shop_cd ;
//	else
		Select shop_type
		into :ls_shop_type
		From tb_56012_d_color with (nolock)
		Where style      = :ls_style 
		  and color      = :as_color
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :gs_shop_cd ;
		  
		  if Isnull(ls_shop_type) or Trim(ls_shop_type) = "" then
				Select shop_type
				into :ls_shop_type
				From tb_56012_d with (nolock)
				Where style      = :ls_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = :gs_shop_cd ;
			end if		
//	end if
	 
	if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
		ls_shop_type = "1"
	end if	
				
	if ls_shop_type <= "3" THEN 
		IF  MidA(LS_STYLE,5,1) <> "Z" then 
			messagebox("경고!", "기획 또는 행사 품번이 아니므로 의뢰할 수 없습니다!")
			dw_body.setitem( al_row,"style", "")
			return false					
		END IF
	ELSE
	end if					
					


Return True

end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null, ls_shop_type
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2
String ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
Long   ll_tag_price,  ll_cnt 
SetNull(ls_null)


Ls_style = LeftA(as_style_no, 8)
ls_color = dw_body.getitemstring(al_row, "color") 

Select count(style), 
       max(style)  ,   
       max(brand)  ,   max(year),     max(season),     
       max(sojae)  ,   max(item),     max(tag_price)  
  into :ll_cnt     , 
       :ls_style   ,   
       :ls_brand   ,   :ls_year,      :ls_season, 
		 :ls_sojae   ,   :ls_item,      :ll_tag_price
  from vi_12020_1 with (nolock) 
 where style   like :ls_style 
	and brand   LIKE CASE WHEN LEFT(:GS_shop_cd,1) in ('N','J') THEN '[NJ]' ELSE :Gs_brand END + '%'
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 


   dw_BODY.SetItem(al_row, "style",    ls_style)
	dw_BODY.SetItem(al_row, "brand",    ls_brand)
	
//	if is_yymmdd <= '20170915' then
		Select shop_type
		into :ls_shop_type
		From tb_56012_d with (nolock)
		Where style      = :ls_style 
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :gs_shop_cd ;
//	else
//		Select shop_type
//		into :ls_shop_type
//		From tb_56012_d_color with (nolock)
//		Where style      = :ls_style 
//		  and color     like :ls_color
//		  and start_ymd <= :is_yymmdd
//		  and end_ymd   >= :is_yymmdd
//		  and shop_cd    = :gs_shop_cd ;
//		
//	end if
//	
	if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
		ls_shop_type = "1"
	end if	
				
	if ls_shop_type <= "3" THEN 
		IF  MidA(LS_STYLE,5,1) <> "Z" then 
			messagebox("경고!", "기획 또는 행사 품번이 아니므로 의뢰할 수 없습니다!")
			dw_body.setitem( al_row,"style", "")
			return false					
		END IF
	ELSE
	end if					
					


Return True

end function

on w_sh170_e.create
int iCurrent
call super::create
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
end on

on w_sh170_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
end on

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;long ll_cnt
INTEGER li_day_no

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

is_yymmdd = dw_head.GetItemSTRING(1, "yymmdd")

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox('확인!',"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

select count(shop_cd)
  into :ll_cnt
   from tb_51035_h a (nolock)
    where a.brand = :gs_brand
      and :is_yymmdd between a.frm_ymd and a.to_ymd
      and a.shop_cd = :gs_shop_cd ;

if ll_cnt < 1 then
	st_2.text = "※ 요청등록은 진행 행사가 있는 기간에만 가능합니다."
	RETURN FALSE
else 	
	st_2.text = ""	
end if




return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/
datetime ld_datetime
string   ls_yymmdd, ls_style
long ii
string ls_find
long ll_found, ll_row

gf_sysdate(ld_datetime)

ls_yymmdd = String(ld_datetime, "YYYYMMDD")

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(is_yymmdd, gs_shop_cd)

IF il_rows > 0 and ls_yymmdd = is_yymmdd THEN
	dw_body.insertRow(0)
	dw_body.SetRow(il_rows + 1)
   dw_body.SetFocus()
ELSEIF il_rows = 0 and ls_yymmdd = is_yymmdd THEN
	dw_body.insertRow(0)
	dw_body.SetRow(1)
   dw_body.SetFocus()
else
   dw_body.SetFocus()
END IF





This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_bujin_chk
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source 

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

CHOOSE CASE as_column
	CASE "style"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
					RETURN 0 
				END IF 
			END IF
		   ls_style = MidA(as_data, 1, 8)
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			
			IF MidA(GS_SHOP_CD,1,1) = "N" OR  MidA(GS_SHOP_CD,1,1) = "J" THEN
				gst_cd.default_where   = "WHERE brand IN ('N','J') "
			ELSE	
				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' " 
			END IF	
				
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + AS_DATA + "%'" + &
									     " and isnull(tag_price,0) > 0 " 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				
				LS_STYLE = lds_Source.GetItemString(1,"style")
				ls_color = lds_Source.GetItemString(1,"color")				
				
				Select shop_type
				into :ls_shop_type
				From tb_56012_d_color with (nolock)
				Where style      = :ls_style 
				  and color      = :ls_color	
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = :gs_shop_cd ;
				  
				  
				 if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then 
					Select shop_type
					into :ls_shop_type
					From tb_56012_d with (nolock)
					Where style      = :ls_style 
					  and start_ymd <= :is_yymmdd
					  and end_ymd   >= :is_yymmdd
					  and shop_cd    = :gs_shop_cd ;		
				 end if					  
				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
					ls_shop_type = "1"
				end if	
							
				if ls_shop_type <= "3" THEN 
					IF  MidA(LS_STYLE,5,1) <> "Z" then 
						messagebox("경고!", "기획 또는 행사 품번이 아니므로 의뢰할 수 없습니다!")
						ib_itemchanged = FALSE
						return 1					
					END IF
				ELSE
				end if					
				
 				IF wf_stock_chk(al_row, lds_Source.GetItemString(1,"style")) THEN 
				   dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))

				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
				   dw_body.SetRow(ll_row_cnt)  
				   dw_body.SetColumn("color")
			      lb_check = TRUE 
				else	
				   dw_body.SetColumn("color")
				END IF
				ib_itemchanged = FALSE
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/
long i, ll_row_count, ii, ll_found, ll_row
datetime ld_datetime
string ls_yymmdd, ls_style

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = string(ld_datetime, "YYYYMMDD")




FOR i=1 TO ll_row_count
	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record */
		dw_body.Setitem(i, "yymmdd",    is_yymmdd)
		dw_body.Setitem(i, "shop_cd",   gs_shop_cd)
		dw_body.Setitem(i, "shop_type", '4')
		dw_body.Setitem(i, "NO", string(i, "0000"))
		dw_body.Setitem(i, "brand", gs_brand)		
		dw_body.Setitem(i, "reg_id", gs_user_id)
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_body.Setitem(i, "mod_id", gs_user_id)
		dw_body.Setitem(i, "mod_dt", ld_datetime)
	END IF
NEXT


/* 판매일자와 시스템 날짜가 다르면 재 로그인 처리
   장나영차장님 요청 - '20140408'
*/
string ls_date_1, ls_date_2
datetime ld_date_t

SELECT GetDate() 
  INTO :ld_date_t
  FROM DUAL ;

IF dw_head.AcceptText()    <> 1 THEN RETURN -1

ls_date_1 = string(ld_date_t, "YYYYMMDD")
ls_date_2 = dw_head.getitemstring(1,'yymmdd')


IF ls_date_1 <> ls_date_2 then
	messagebox('확인','판매 입력일이 다릅니다. 재 로그인 해주시기 바랍니다!')
	Return 0
END IF


il_rows = dw_body.Update()


if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

datetime ld_datetime
string   ls_yymmdd

gf_sysdate(ld_datetime)

ls_yymmdd = String(ld_datetime, "YYYYMMDD")

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
			if ls_yymmdd = is_yymmdd then 
   	      cb_delete.enabled = true
			else
   	      cb_delete.enabled = false
			end if	
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
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
			cb_preview.enabled = true
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
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event open;call super::open;datetime ld_datetime
string   ls_yymmdd

gf_sysdate(ld_datetime)

ls_yymmdd = String(ld_datetime, "YYYYMMDD")

DW_HEAD.SETITEM(1, "YYMMDD", LS_YYMMDD)
end event

type cb_close from w_com010_e`cb_close within w_sh170_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh170_e
end type

type cb_insert from w_com010_e`cb_insert within w_sh170_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh170_e
end type

type cb_update from w_com010_e`cb_update within w_sh170_e
end type

type cb_print from w_com010_e`cb_print within w_sh170_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh170_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh170_e
end type

type dw_head from w_com010_e`dw_head within w_sh170_e
integer width = 2802
integer height = 128
string dataobject = "d_sh170_h01"
end type

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if
			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

type ln_1 from w_com010_e`ln_1 within w_sh170_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_sh170_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_sh170_e
event ue_set_column ( long al_row )
integer y = 344
integer height = 1492
string dataobject = "d_sh170_d01"
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */


//dw_body.SetRow(al_row + 1)  
//dw_body.SetColumn("style_no")
//
end event

event dw_body::constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%', '%')
end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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
		IF ls_column_name = "color" THEN 
			IF This.GetRow() = This.RowCount() THEN
			il_rows = This.InsertRow(0)				
			This.SetColumn(il_rows)
		   END IF
		END IF
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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/
integer il_ret
string ls_style


CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		il_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF il_ret <> 1 THEN
			This.Post Event ue_set_column(row) 
		END IF
		return il_ret
		
CASE "color"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		ls_style = dw_body.getitemstring(row, "style")
		if wf_style_chk_color(row, ls_style, data) = false then 
			return 0 
		else 
			return 1
		end if	
		
END CHOOSE

end event

event dw_body::editchanged;call super::editchanged;
cb_delete.enabled = true


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color

CHOOSE CASE dwo.name
	CASE "color" 
		ls_style = This.GetitemString(row, "style")
		ls_chno  = "%"	
	
		idw_color.Retrieve(ls_style, ls_chno)

END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_sh170_e
end type

type st_2 from statictext within w_sh170_e
integer x = 1737
integer y = 220
integer width = 1545
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 요청등록은 진행 행사가 있는 기간에만 가능합니다."
boolean focusrectangle = false
end type

