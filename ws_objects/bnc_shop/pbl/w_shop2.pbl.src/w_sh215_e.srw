$PBExportHeader$w_sh215_e.srw
$PBExportComments$고객리스트요청
forward
global type w_sh215_e from w_com010_e
end type
type dw_1 from u_dw within w_sh215_e
end type
type st_1 from statictext within w_sh215_e
end type
type st_2 from statictext within w_sh215_e
end type
end forward

global type w_sh215_e from w_com010_e
integer width = 2967
integer height = 2088
dw_1 dw_1
st_1 st_1
st_2 st_2
end type
global w_sh215_e w_sh215_e

type variables
DataWindowChild idw_year, idw_season, idw_cust_grade
String is_yymmdd, is_rqst_no,  is_snd_ymd, is_cust_grade, is_birth_day, is_only_birth, is_season_opt, is_year, is_season
String is_sms_contents, is_sale_diff, is_opt_ret,is_sale_diff2
decimal idc_sale_amt, idc_sale_cnt, idc_mileage
Integer ii_rqst_cnt

//@yymmdd     	varchar(8),  -- 조회일자
//@rqst_no	varchar(4),  -- 요청번호	   
//@shop_cd    	varchar(6),  -- 매장코드
//@opt_ret	varchar(01), -- A: 고객조회, B: 문자, C: 전화, D: DM
//@sale_diff	varchar(01), -- A:1, B: 최근3개월, C:6개월, 
//@sale_amt	decimal(12), -- 구매금액
//@sale_cnt	decimal(12), -- 구매횟수
//@mileage	decimal(12), -- 마일리지
//@birth_day	varchar(01), -- A:전체, B:당일,  C:익일, D: 일주일, E:금월
//@only_birth	varchar(01),  -- 생일자만 조회
//@cust_grade	varchar(01), -- A:전체, B:최우수 C:우수  D: 일반
//@season_opt	varchar(01), -- A:전체, B:해당   C:제외
//@year		varchar(04), -- 제품년도
//@season		varchar(01), -- 제품시즌
//@rqst_cnt	int, -- 조회 선정수 제한
//@sms_contents	varchar(80),
//@snd_ymd	varchar(08)  -- 발송
end variables

on w_sh215_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
end on

on w_sh215_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;//@yymmdd     	varchar(8),  -- 조회일자
//@rqst_no	varchar(4),  -- 요청번호	   
//@shop_cd    	varchar(6),  -- 매장코드
//@opt_ret	varchar(01), -- A: 고객조회, B: 문자, C: 전화, D: DM
//@sale_diff	varchar(01), -- A:1, B: 최근3개월, C:6개월, 
//@sale_amt	decimal(12), -- 구매금액
//@sale_cnt	decimal(12), -- 구매횟수
//@mileage	decimal(12), -- 마일리지
//@birth_day	varchar(01), -- A:전체, B:당일,  C:익일, D: 일주일, E:금월
//@only_birth	varchar(01),  -- 생일자만 조회
//@cust_grade	varchar(01), -- A:전체, B:최우수 C:우수  D: 일반
//@season_opt	varchar(01), -- A:전체, B:해당   C:제외
//@year		varchar(04), -- 제품년도
//@season		varchar(01), -- 제품시즌
//@rqst_cnt	int, -- 조회 선정수 제한
//@sms_contents	varchar(80),
//@snd_ymd	varchar(08)  -- 발송

string   ls_title, ls_time, ls_today, ls_tomorrow
datetime ld_datetime
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

IF gf_sysdate(ld_datetime) = FALSE THEN
	Return FALSE
END IF

ls_TIME = string(ld_datetime, "HM")
ls_today = string(ld_datetime, "YYYYMMDD")

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"요청일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_rqst_no = dw_head.GetItemString(1, "rqst_no")

is_opt_ret = dw_head.GetItemString(1, "opt_ret")
if IsNull(is_opt_ret) or Trim(is_opt_ret) = "" then
   MessageBox(ls_title,"조회 조건을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_ret")
   return false
end if

is_sale_diff = dw_head.GetItemString(1, "sale_diff")
is_sale_diff2 = dw_head.GetItemString(1, "sale_diff2")


idc_sale_amt = dw_head.GetItemNumber(1, "sale_amt")
if idc_sale_amt < 0  or IsNull(idc_sale_amt) then
  idc_sale_amt = 0
end if

idc_sale_cnt = dw_head.GetItemNumber(1, "sale_cnt")
if idc_sale_cnt < 0 or IsNull(idc_sale_cnt)  then
  idc_sale_cnt = 0
end if


idc_mileage = dw_head.GetItemNumber(1, "mileage")
if idc_mileage < 0 or IsNull(idc_mileage)  then
  idc_mileage = 0
end if

is_cust_grade = dw_head.GetItemString(1, "cust_grade")
if IsNull(is_cust_grade) or Trim(is_cust_grade) = "" then
	MessageBox(ls_title,"고객등급을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("cust_grade")
	return false
end if


is_birth_day = dw_head.GetItemString(1, "birth_day")
if IsNull(is_birth_day) or Trim(is_birth_day) = "" then
	MessageBox(ls_title,"생일자 기준을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("birth_day")
	return false
end if

is_only_birth = dw_head.GetItemString(1, "only_birth")

ii_rqst_cnt = dw_head.GetItemNumber(1, "rqst_cnt")
if IsNull(ii_rqst_cnt) or ii_rqst_cnt < 0 then
  ii_rqst_cnt = 0
end if

if is_opt_ret = "B"  then
	

	is_snd_ymd = dw_head.GetItemString(1, "snd_ymd")
	if IsNull(is_snd_ymd) or Trim(is_snd_ymd) = "" then
		MessageBox(ls_title,"문자발송예정일을 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("snd_ymd")
		return false
	end if

//	if ls_today <= is_snd_ymd and  ls_TIME > "1400" then
//		messagebox("알림!", "※ 금일 발송은 2시이전에 등록 가능합니다. 익일로 자동 변경됩니다. ")
//
//		select convert(char(08), dateadd(day, 1, :ls_today),112)
//		into :ls_tomorrow
//		from dual;
//		
//		dw_head.setitem(1, "snd_ymd", ls_tomorrow)
//		is_snd_ymd = ls_tomorrow
//		
//	end if


	is_sms_contents = dw_head.GetItemString(1, "smscontents")
	if IsNull(is_sms_contents) or Trim(is_sms_contents) = "" then
		MessageBox(ls_title,"문자 내역을 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("smscontents")
		return false
	end if
end if

if is_only_birth = "Y" then 
	MessageBox("알림!","모든 조건을 무시하고 생일 조건 만으로 조회 합니다!!")
end if

is_season_opt = dw_head.GetItemString(1, "season_opt")
if IsNull(is_season_opt) or Trim(is_season_opt) = "" then
	MessageBox(ls_title,"시즌 조건을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("season_opt")
	return false
end if


is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")



return true
end event

event ue_retrieve();call super::ue_retrieve;String ls_snd_ymd, ls_smscontents, ls_mkt_type, ls_sale_diff,ls_birth_day, ls_only_birth, ls_cist_grade, ls_season
String ls_season_opt, ls_year,  ls_rqst_no, ls_cust_grade,ls_sale_diff2
decimal ldc_sale_amt, ldc_sale_cnt, ldc_mileage
int li_rqst_cnt

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
dw_1.visible = false



il_rows = dw_body.retrieve(is_yymmdd, is_rqst_no, gs_shop_cd, is_opt_ret, is_sale_diff, idc_sale_amt, idc_sale_cnt, idc_mileage, is_birth_day, is_only_birth, is_cust_grade, is_season_opt, is_year, is_season, ii_rqst_cnt, is_sms_contents, is_snd_ymd, is_sale_diff2)
IF il_rows > 0 THEN	
	
		ls_rqst_no  = dw_body.getitemstring(1, "rqst_no")
		
	if IsNull(ls_rqst_no) = false  and LenA(ls_rqst_no) = 4 then
		ls_mkt_type = dw_body.getitemstring(1, "mkt_type")
		ls_snd_ymd = dw_body.getitemstring(1, "snd_ymd")
		ls_smscontents = dw_body.getitemstring(1, "sms_contents")	
		
		ls_sale_diff = dw_body.getitemstring(1,"i_sale_diff")	
		ls_sale_diff2 = dw_body.getitemstring(1,"i_sale_diff2")			
		ldc_sale_amt = dw_body.getitemnumber(1,"i_sale_amt")
		ldc_sale_cnt = dw_body.getitemnumber(1,"i_sale_cnt")		
		ldc_mileage  = dw_body.getitemnumber(1,"i_mileage")				
		ls_birth_day = dw_body.getitemstring(1,"i_birth_day")			
		ls_only_birth = dw_body.getitemstring(1,"i_only_birth")					
		ls_cust_grade = dw_body.getitemstring(1,"i_cust_grade")							
		ls_season_opt = dw_body.getitemstring(1,"i_season_opt")									
		ls_year       = dw_body.getitemstring(1,"i_year")									
		ls_season     = dw_body.getitemstring(1,"i_season")											
		li_rqst_cnt   = dw_body.getitemNumber(1,"i_rqst_cnt")											
		
		dw_head.setitem(1,"opt_ret", ls_mkt_type) 
		dw_head.setitem(1,"snd_ymd", ls_snd_ymd) 
		dw_head.setitem(1,"smscontents", ls_smscontents) 		
		dw_head.setitem(1,"sale_diff", ls_sale_diff) 	
		dw_head.setitem(1,"sale_diff2", ls_sale_diff2) 			
		dw_head.setitem(1,"sale_amt", ldc_sale_amt) 	
		dw_head.setitem(1,"sale_cnt", ldc_sale_cnt) 	
		dw_head.setitem(1,"mileage", ldc_mileage) 	
		dw_head.setitem(1,"birth_day", ls_birth_day) 	
		dw_head.setitem(1,"only_birth", ls_only_birth) 	
		dw_head.setitem(1,"cust_grade", ls_cust_grade) 	
		dw_head.setitem(1,"season_opt", ls_season_opt) 	
		dw_head.setitem(1,"year", ls_year) 	
		dw_head.setitem(1,"season", ls_season) 			
		dw_head.setitem(1,"rqst_cnt", li_rqst_cnt) 					
				
	end if
	
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
dw_1.SetTransObject(SQLCA)
end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_cnt
String ls_data, ls_rqst_no
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF




if isnull(is_rqst_no) then
	
	select count(*)
	into :ll_cnt
	from tb_71085_H (nolock)
	where yymmdd = :is_yymmdd;
	
	if ll_cnt = 0 then
		ls_rqst_no = "0001"

	else
		select right(isnull(max(rqst_no), 0) + 10001, 4)
		into :ls_rqst_no
		from tb_71085_H (nolock)
		where yymmdd = :is_yymmdd;
		
	end if	
else
	ls_rqst_no = is_rqst_no
end if	

FOR i=1 TO ll_row_count
	
   dw_body.SetItemStatus(i, 0, Primary!, DataModified!)
	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)


   IF idw_status = NewModified! or idw_status = DataModified! THEN		   /* Modify Record */ 
		ls_data = dw_body.GetitemString(i, "data") 
		IF ls_data = "New" THEN 
         dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		   dw_body.Setitem(i, "rqst_no",   ls_rqst_no)			
		   dw_body.Setitem(i, "no",   string(i,"0000"))					
	      dw_body.Setitem(i, "reg_id", gs_user_id)
         dw_body.Setitem(i, "reg_dt", ld_datetime)  	  
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_head.Setitem(1, "rqst_no",   ls_rqst_no)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = true
      end if

      if al_rows >= 0 and isnull(is_rqst_no) and is_opt_ret = "B" then
         ib_changed = true
         cb_update.enabled = true
		else	
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
         cb_preview.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = true
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_preview();long ll_rows

/* dw_head 필수입력 column check */
is_yymmdd = dw_head.getitemstring(1, "yymmdd")

ll_rows = dw_1.retrieve(is_yymmdd, gs_shop_cd )

IF ll_rows > 0 THEN		
   dw_1.visible = true
END IF

end event

type cb_close from w_com010_e`cb_close within w_sh215_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh215_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh215_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh215_e
end type

type cb_update from w_com010_e`cb_update within w_sh215_e
end type

type cb_print from w_com010_e`cb_print within w_sh215_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh215_e
integer x = 1650
integer width = 494
boolean enabled = true
string text = "월간요청조회(&V)"
end type

type gb_button from w_com010_e`gb_button within w_sh215_e
end type

type dw_head from w_com010_e`dw_head within w_sh215_e
integer width = 2848
integer height = 516
string dataobject = "d_sh215_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("cust_grade", idw_cust_grade )
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

type ln_1 from w_com010_e`ln_1 within w_sh215_e
integer beginy = 700
integer endy = 700
end type

type ln_2 from w_com010_e`ln_2 within w_sh215_e
integer beginy = 704
integer endy = 704
end type

type dw_body from w_com010_e`dw_body within w_sh215_e
integer y = 712
integer width = 2875
integer height = 1128
string dataobject = "d_sh215_d01"
end type

type dw_print from w_com010_e`dw_print within w_sh215_e
end type

type dw_1 from u_dw within w_sh215_e
boolean visible = false
integer y = 648
integer width = 2875
integer height = 1192
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "해당월 요청작업 리스트"
string dataobject = "d_sh215_d02"
boolean controlmenu = true
end type

event doubleclicked;call super::doubleclicked;string ls_yymmdd, ls_rqst_no

ls_yymmdd  = dw_1.getitemstring(row, "yymmdd")
ls_rqst_no = dw_1.getitemstring(row, "rqst_no")

dw_head.setitem(1, "yymmdd", ls_yymmdd)
dw_head.setitem(1, "rqst_no", ls_rqst_no)

parent.Trigger Event ue_retrieve()

end event

event buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_accept_send, ls_yymmdd, ls_rqst_no
integer Net



	ls_accept_send = this.getitemstring(row, "accept_send")
	ls_yymmdd      = this.getitemstring(row, "yymmdd")	
	ls_rqst_no     = this.getitemstring(row, "rqst_no")		

If dwo.Name = 'cb_cancel'  Then
		
	if  ls_accept_send = "N" then 
		Net = MessageBox("Result", "한번 취소한 요청은 재요청 할 수 없습니다! 계속하시겠습니까?", Exclamation!, OKCancel!, 2)
		IF Net = 1 THEN	
			
			update tb_71085_h set accept_send = "C"
			where yymmdd = :ls_yymmdd
			 and  rqst_no = :ls_rqst_no
			 and  shop_cd = :gs_shop_cd;
			 
			  COMMIT; 
			  
			 messagebox("알림!", "처리 되었습니다!")
			 dw_1.retrieve(ls_yymmdd, gs_shop_cd) 
			 
		ELSE
			messagebox("알림!", "작업이 취소되었습니다!")		
		END IF
	else
		messagebox("경고!", "요청이 처리되었거나 취소된 작업입니다!")		
	end if	


End If

end event

type st_1 from statictext within w_sh215_e
integer x = 416
integer y = 40
integer width = 1225
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※문자요청시에만 저장이 가능하며 "
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh215_e
integer x = 471
integer y = 96
integer width = 1033
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
string text = "저장시 자동으로 요청이 등록됩니다."
boolean focusrectangle = false
end type

