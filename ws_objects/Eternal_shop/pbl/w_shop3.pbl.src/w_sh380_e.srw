$PBExportHeader$w_sh380_e.srw
$PBExportComments$이벤트 등록
forward
global type w_sh380_e from w_com010_e
end type
end forward

global type w_sh380_e from w_com010_e
integer width = 2981
integer height = 2048
long backcolor = 16777215
end type
global w_sh380_e w_sh380_e

type variables
string   is_yymmdd, is_no, is_shop_cd
end variables

forward prototypes
public function boolean wf_member_set (string as_flag, string as_find)
public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name)
end prototypes

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name,   ls_jumin,      ls_card_no,  ls_email,ls_age_grp, ls_tel_no3, ls_secure_no
Long    ll_seq_no
int	  ll_ans
 
DataStore	lds_source	
Boolean lb_return 
DataWindowChild ldw_child
IF as_flag = '3' THEN
		if LenA(as_find) < 10 then 
			messagebox("확인","전화번호를 올바로 입력하세요..")			
			return true				

		else 			

			
			gst_cd.ai_div          = 1
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_find) <> "" THEN
				gst_cd.Item_where   = " tel_no3 = '" + as_find + "' "
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(1)
				ls_jumin = lds_Source.GetItemString(1,"jumin")
				dw_head.SetItem(1, "jumin",  ls_jumin) 

			END IF			
			Destroy  lds_Source	
		end if
		as_flag = '1'
		as_find = ls_jumin
end if
	
//IF as_flag = '2' THEN
//	  
//		if len(as_find) < 2 then 
//			messagebox("확인","고객명을 올바로 입력하세요..")			
//			return true				
//
//		else 			
//			
//			gst_cd.ai_div          = 1
//			gst_cd.window_title    = "회원 검색" 
//			gst_cd.datawindow_nm   = "d_com701" 
//			gst_cd.default_where   = ""
//			IF Trim(as_find) <> "" THEN
//				gst_cd.Item_where   = " user_name like '" + as_find + "'  "
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				dw_head.SetRow(1)
//				ls_jumin = lds_Source.GetItemString(1,"jumin")
//				dw_head.SetItem(1, "jumin",  ls_jumin) 
//
//			END IF			
//			Destroy  lds_Source	
//		end if
//		as_flag = '1'
//		as_find = ls_jumin
//end if
//	
			
IF as_flag = '1' THEN
	SELECT user_name,       jumin,          card_no, email,
			  tel_no3 
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  :ls_email,
			 :ls_tel_no3
	  FROM beaucre.dbo.TB_71010_M  with (nolock)  
	 WHERE jumin   = :as_find ; 	
END IF

IF SQLCA.SQLCODE <> 0 AND isnull(as_find) = false THEN 
	lb_return = False  
ELSEIF isnull(ls_card_no) OR Trim(ls_card_no) = "" THEN
	SetNull(ls_jumin)
	lb_return = False  
ELSE	
	lb_return = True 
END IF

dw_head.SetItem(1, "user_name",    ls_user_name)
dw_head.SetItem(1, "jumin",        ls_jumin)
dw_head.Setitem(1, "tel_no3", 	  ls_tel_no3)

ll_seq_no = 0


select max(seq_no) 
into	 :ll_seq_no
from   beaucre.dbo.tb_71050_h (nolock)
where  jumin = :ls_jumin;

 if  isnull(ll_seq_no) then
	  ll_seq_no = 0
end if


ll_seq_no = ll_seq_no + 1

dw_body.reset()


il_rows = dw_body.InsertRow(0)

dw_body.SetItem(1, "user_name",    ls_user_name)
dw_body.SetItem(1, "jumin",        ls_jumin)
dw_body.SetItem(1, "card_no",      ls_card_no)
dw_body.SetItem(1, "h_phone",      ls_tel_no3)
dw_body.SetItem(1, "seq_no",       ll_seq_no)
dw_body.SetItem(1, "email",        ls_email)
dw_body.SetItem(1, "shop_cd",      gs_shop_cd)
dw_body.SetItem(1, "shop_nm",      gs_shop_nm)


/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if



This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)




Return lb_return

end function

public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name);string ls_secure_no
int li_cnt

	select jumin, user_name
		into :as_jumin, :as_user_name
	from beaucre.dbo.tb_71010_m (nolock) 
	where tel_no3 = replace(:as_tel_no,'-','');

	select count(jumin)
		into :li_cnt
	from beaucre.dbo.tb_71010_m (nolock) 
	where tel_no3 = replace(:as_tel_no,'-','');


	if li_cnt <> 1 or isnull(as_jumin) or LenA(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
	

end function

on w_sh380_e.create
call super::create
end on

on w_sh380_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"등록일자를 입력해 주세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_no = dw_head.GetItemString(1, "no")
if IsNull(is_no) or Trim(is_no) = "" then
	is_no = '%'
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")

return true
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_amt
decimal ld_max_id
datetime ld_datetime
string   ls_date, ls_shop_cd, ls_start_ymd, ls_end_ymd, ls_event, ls_contents, ls_max_id



ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_start_ymd = dw_body.GetItemString(1, "start_ymd")
if IsNull(ls_start_ymd) or Trim(ls_start_ymd) = "" then
   MessageBox('확인!',"시작일자를 입력하십시요!")
   dw_body.SetFocus()
   dw_body.SetColumn("start_ymd")
   return 0
end if

ls_end_ymd = dw_body.GetItemString(1, "end_ymd")
if IsNull(ls_end_ymd) or Trim(ls_end_ymd) = "" then
   MessageBox('확인!',"종료일자를 입력하십시요!")
   dw_body.SetFocus()
   dw_body.SetColumn("end_ymd")
   return 0
end if

ls_event = dw_body.GetItemString(1, "event_gubn")
if IsNull(ls_event) or Trim(ls_event) = "" then
   MessageBox('확인!',"스타일을 입력하십시요!")
   dw_body.SetFocus()
   dw_body.SetColumn("event_gubn")
   return 0
end if

ls_date = dw_head.getitemstring(1,'yymmdd')

select isnull(max(no),0) into :ld_max_id
from tb_51064_d with (nolock)
where yymmdd = :ls_date;

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		dw_body.Setitem(i, "yymmdd", ls_date)
		dw_body.Setitem(i, "no", string(ld_max_id + 1, '0000'))
		dw_body.Setitem(i, "shop_cd", gs_shop_cd)
      dw_body.Setitem(i, "reg_id", gs_user_id)
		dw_body.Setitem(i, "reg_dt", ld_datetime)
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

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_no, is_shop_cd)
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

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

if MidA(gs_shop_cd_1,1,2) = 'XX'then
	messagebox("주의!", '복합매장에서는 사용할 수 없습니다!')
	return 1
end if	


IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.setitem(1, "yymmdd", string(ld_datetime, "YYYYMMDD"))
dw_head.setitem(1, "shop_cd", gs_shop_cd)

end event

type cb_close from w_com010_e`cb_close within w_sh380_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh380_e
integer x = 1792
boolean enabled = true
end type

type cb_insert from w_com010_e`cb_insert within w_sh380_e
integer x = 1445
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh380_e
integer x = 2139
end type

type cb_update from w_com010_e`cb_update within w_sh380_e
end type

type cb_print from w_com010_e`cb_print within w_sh380_e
boolean visible = false
integer x = 667
end type

type cb_preview from w_com010_e`cb_preview within w_sh380_e
boolean visible = false
integer x = 1010
end type

type gb_button from w_com010_e`gb_button within w_sh380_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh380_e
event type long ue_item_changed ( long row,  dwobject dwo,  string data )
integer x = 5
integer y = 152
integer width = 2880
integer height = 124
string dataobject = "d_sh380_h01"
end type

event type long dw_head::ue_item_changed(long row, dwobject dwo, string data);string  ls_coupon_no, ls_secure_no, ls_tel_no3
long    i, ll_row_count

IF dw_head.AcceptText() <> 1 THEN RETURN  1

CHOOSE CASE dwo.name
	
   CASE "jumin"				
		IF WF_MEMBER_SET('1', data) = FALSE THEN	
			dw_body.reset()
			MessageBox("오류", "미등록된 카드회원 입니다")			
			RETURN  1
		END IF 
//	CASE "user_name"				
//		IF WF_MEMBER_SET('2', data) = FALSE THEN	
//			dw_body.reset()
//			MessageBox("오류", "미등록된 카드회원 입니다")			
//			RETURN  1
//		END IF 
	 CASE "tel_no3"
		IF WF_MEMBER_SET('3', data) = FALSE THEN
			dw_body.reset()
				MessageBox("오류", "미등록된 카드회원 입니다")						
				RETURN 1		
			END IF 
			

	
END CHOOSE 


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String ls_null , ls_coupon_no
Long   ll_give_point, ll_accept_point
decimal ld_goods_amt

IF dw_body.RowCount() > 0 THEN 
	IF dw_body.GetitemStatus(1, 0, Primary!) <> New! THEN 
      ib_changed = true
      cb_update.enabled = true
	END IF
END IF

post event ue_item_changed(row, dwo, data)

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//post event ue_item_changed(row, dwo, data)
end event

type ln_1 from w_com010_e`ln_1 within w_sh380_e
integer beginy = 296
integer endy = 296
end type

type ln_2 from w_com010_e`ln_2 within w_sh380_e
integer beginy = 300
integer endy = 300
end type

type dw_body from w_com010_e`dw_body within w_sh380_e
integer y = 308
integer height = 1488
string dataobject = "d_sh380_d01"
boolean hscrollbar = true
boolean livescroll = false
end type

type dw_print from w_com010_e`dw_print within w_sh380_e
integer x = 1605
integer y = 352
end type

