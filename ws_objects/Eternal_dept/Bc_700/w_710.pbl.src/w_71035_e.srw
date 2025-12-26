$PBExportHeader$w_71035_e.srw
$PBExportComments$증정권전환
forward
global type w_71035_e from w_com010_e
end type
end forward

global type w_71035_e from w_com010_e
end type
global w_71035_e w_71035_e

type variables
String  is_jumin, is_present_no
end variables

forward prototypes
public function boolean wf_max_seq (string ls_yymmdd, ref long ll_max_seq)
end prototypes

public function boolean wf_max_seq (string ls_yymmdd, ref long ll_max_seq);  ll_max_seq = 0
  
  SELECT  max(point_seq)  
	  into    :ll_max_seq
	  from   tb_71011_h with (nolock)
	  where  jumin     = :is_jumin
	  and    give_date = :ls_yymmdd
	  and    point_flag = '1';
	  

if ll_max_seq > 0 then
	return true
else 
	return false
end if

 
end function

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title  

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

is_present_no = dw_head.GetItemString(1, "present_no")


if IsNull(is_present_no) or Trim(is_present_no) = "" then
   MessageBox(ls_title,"증정권 번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("present_no")
   return false
end if

is_jumin = dw_head.GetItemString(1, "jumin")


if IsNull(is_jumin) or Trim(is_jumin) = "" then
   MessageBox(ls_title,"주민번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jumin")
   return false
end if


return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
String ls_accept_flag, ls_use_ymd, ls_card_no , ls_coupon_no1, ls_coupon_no, ls_yymmdd
Long ll_pos, ll_len_str
decimal ld_goods_amt
datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
END IF

ls_yymmdd = String(ld_datetime, "yyyymmdd") 



/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_present_no)
IF il_rows > 0 THEN
   ls_accept_flag = dw_body.GetItemString(1,"accept_flag")
   ls_use_ymd     = dw_body.GetItemString(1,"use_ymd")
	ld_goods_amt   = dw_body.GetItemDecimal(1,"goods_amt")
	
	if ls_accept_flag = 'Y'  then
		messagebox('확인', '이미 쿠폰전환 처리된 증정권 번호 입니다 !') 				 			
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
				dw_body.SetFocus()						 
				cb_update.enabled = false		
		RETURN
	elseif ls_accept_flag = 'C'  then
		messagebox('확인', '이미 소멸된 증정권 번호 입니다 !') 
			cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
				dw_body.SetFocus()						 
				cb_update.enabled = false	 
		RETURN
	end if
	
 	if ls_use_ymd < ls_yymmdd then 
		messagebox('확인', '사용 유효기간이 지난 증정권입니다 !') 
			cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
				dw_body.SetFocus()						 
				cb_update.enabled = false
		RETURN
	end if
	
	
	
	select card_no 
	into   :ls_card_no 
	from   tb_71010_m with (nolock)
	where  jumin = :is_jumin;
	
	dw_body.setitem(1, "jumin", is_jumin)
	dw_body.setitem(1, "card_no", ls_card_no)
	dw_body.setitem(1, "accept_flag", 'Y')
	dw_body.setitem(1, "accept_ymd", ls_yymmdd)



  ls_coupon_no = LeftA(is_present_no,6)
  
   dw_body.setitem(1, "coupon_no", ls_coupon_no)
   dw_body.setitem(1, "mod_dt", ls_yymmdd)
	dw_body.Enabled = TRUE 
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN 
	messagebox('확인', '지급된 증정권 번호가 아닙니다 !')
		      cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
				dw_body.SetFocus()						 
				cb_update.enabled = false
	return
END IF

	cb_update.enabled = true
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
long i, ll_row_count,  ll_point_seq, ll_max_seq
datetime ld_datetime 
String   ls_card_no,   ls_yymmdd, ls_coupon_no, ls_present_no, ls_use_ymd
decimal  ld_goods_amt, ld_give_rate

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1 


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	SQLCA.Lock = "RC"
	Return 0
END IF

ls_yymmdd = String(ld_datetime, "yyyymmdd") 



ls_present_no = dw_body.Getitemstring(1,"present_no") 
	if IsNull(ls_present_no) or Trim(ls_present_no) = "" then
		MessageBox('확인',"조회한 후에 저장하십시오! ")
		dw_head.SetFocus()
		dw_head.SetColumn("present_no")
		return 0
	end if

FOR i=1 TO ll_row_count
	
	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */    		 	
		IF dw_body.GetItemStatus(i, "jumin", Primary!) = DataModified! THEN         		
		END IF
		dw_body.Setitem(i, "mod_id",  gs_user_id)
		dw_body.Setitem(i, "mod_dt",  ld_datetime)

   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		IF dw_body.GetItemStatus(i, "card_no", Primary!) = DataModified! THEN       
			dw_body.Setitem(i, "mod_id",  gs_user_id)
	 	dw_body.Setitem(i, "mod_dt",  ld_datetime)
		END IF		
		dw_body.Setitem(i, "mod_id",  gs_user_id)
	   dw_body.Setitem(i, "mod_dt",  ld_datetime)

   END IF
NEXT

  ls_coupon_no = dw_body.Getitemstring(1, "coupon_no")
  ls_card_no   = dw_body.Getitemstring(1, "card_no")
  ld_goods_amt = dw_body.Getitemdecimal(1, "goods_amt")
  ld_give_rate = dw_body.Getitemdecimal(1, "dc_rate")
  ls_use_ymd   = dw_body.Getitemstring(1, "use_ymd")
 
     ll_max_seq = 0
	 
  //    MESSAGEBOX('확인1', ll_max_seq)
	  
 


  if  wf_max_seq(ls_yymmdd, ll_max_seq)  then 
      ll_max_seq = ll_max_seq + 1
  else
	   ll_max_seq =    1 
  end if
  
  //MESSAGEBOX('확인2', ll_max_seq)
  insert into tb_71011_h(jumin, give_date, point_flag,point_seq,coupon_no, card_no, give_point,accept_flag,Reg_id, give_rate,use_ymd)
  values (:is_jumin, :ls_yymmdd,'1', :ll_max_seq, :ls_coupon_no,:ls_card_no,:ld_goods_amt/10, 'N', :gs_user_id, :ld_give_rate,:ls_use_ymd);
 
 

il_rows = dw_body.Update()

// MESSAGEBOX('확인3', ll_max_seq)
 
if il_rows = 1 then
   commit  USING SQLCA;
	MESSAGEBOX('확인', '저장완료 되었습니다')
	
else
   rollback  USING SQLCA;
end if
SQLCA.Lock = "RC"
	
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

on w_71035_e.create
call super::create
end on

on w_71035_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_e`cb_close within w_71035_e
end type

type cb_delete from w_com010_e`cb_delete within w_71035_e
end type

type cb_insert from w_com010_e`cb_insert within w_71035_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_71035_e
end type

type cb_update from w_com010_e`cb_update within w_71035_e
end type

type cb_print from w_com010_e`cb_print within w_71035_e
end type

type cb_preview from w_com010_e`cb_preview within w_71035_e
end type

type gb_button from w_com010_e`gb_button within w_71035_e
end type

type cb_excel from w_com010_e`cb_excel within w_71035_e
end type

type dw_head from w_com010_e`dw_head within w_71035_e
integer x = 32
integer y = 196
integer height = 232
string dataobject = "d_71035_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_71035_e
end type

type ln_2 from w_com010_e`ln_2 within w_71035_e
end type

type dw_body from w_com010_e`dw_body within w_71035_e
string dataobject = "d_71035_d01"
end type

type dw_print from w_com010_e`dw_print within w_71035_e
end type

