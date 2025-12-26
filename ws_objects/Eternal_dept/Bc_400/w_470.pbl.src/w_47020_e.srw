$PBExportHeader$w_47020_e.srw
$PBExportComments$면세점 리필선정
forward
global type w_47020_e from w_com010_e
end type
type cb_refill from commandbutton within w_47020_e
end type
type st_1 from statictext within w_47020_e
end type
type st_2 from statictext within w_47020_e
end type
end forward

global type w_47020_e from w_com010_e
integer width = 3694
integer height = 2256
cb_refill cb_refill
st_1 st_1
st_2 st_2
end type
global w_47020_e w_47020_e

type variables
DataWindowChild idw_brand, idw_year, idw_season
String is_brand, is_yymmdd, is_fr_ymd, is_to_ymd , is_gubn, is_year, is_season, is_eshop
Long   il_deal_seq 
end variables

forward prototypes
public function boolean wf_body_set ()
public function boolean wf_body_set1 ()
end prototypes

public function boolean wf_body_set ();String  ls_modify,   ls_error
integer i, k,h, l

/* 사이즈 셋 */

dw_body.SetRedraw(False)

ls_modify = 'deal_qty.protect = 1'
  
ls_Error = dw_body.Modify(ls_modify)

IF (ls_Error <> "") THEN 
	MessageBox("modified error", ls_Error + "~n~n" + ls_modify)
	Return False
END IF
	
dw_body.SetRedraw(true)

Return True 

end function

public function boolean wf_body_set1 ();String  ls_modify,   ls_error
integer i, k,h, l

/* 사이즈 셋 */

dw_body.SetRedraw(False)

ls_modify = 'deal_qty.protect = 0'
  
ls_Error = dw_body.Modify(ls_modify)

IF (ls_Error <> "") THEN 
	MessageBox("modified error", ls_Error + "~n~n" + ls_modify)
	Return False
END IF
	
dw_body.SetRedraw(true)

Return True 

end function

on w_47020_e.create
int iCurrent
call super::create
this.cb_refill=create cb_refill
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refill
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
end on

on w_47020_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_refill)
destroy(this.st_1)
destroy(this.st_2)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.10                                                  */	
/* 수정일      : 2002.04.10                                                  */
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

is_yymmdd   = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
is_fr_ymd   = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd   = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")

il_deal_seq = dw_head.GetItemNumber(1, "deal_seq")

is_eshop = dw_head.GetItemString(1, "eshop")

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
   MessageBox(ls_title,"집계구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

if is_brand = "W" then
	is_year   = "%"
	is_season = "%"
//	
//	is_year = dw_head.GetItemString(1, "year")
//	if IsNull(is_year) or Trim(is_year) = "" then
//		MessageBox(ls_title,"제품년도를 입력하십시요!")
//		dw_head.SetFocus()
//		dw_head.SetColumn("year")
//		return false
//	end if
//	
//	
//	is_season = dw_head.GetItemString(1, "season")
//	if IsNull(is_season) or Trim(is_season) = "" then
//		MessageBox(ls_title,"제품시즌을 입력하십시요!")
//		dw_head.SetFocus()
//		dw_head.SetColumn("season")
//		return false
//	end if
	
else
	is_year   = "%"
	is_season = "%"
end if	

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.04.10                                                  */	
/* 수정일      : 2002.04.10                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_fr_ymd, is_to_ymd, il_deal_seq)

IF il_rows > 0 THEN 
	IF dw_body.Object.proc_yn[1] = 'Y' THEN 
		st_1.Text = "이미 출고처리가 되여 있습니다." 
	ELSE
		st_1.Text = "" 
	END IF
   dw_body.SetFocus() 
END IF

This.Trigger Event ue_button(1, il_rows)

IF il_rows > 0 THEN
	IF dw_body.Object.proc_yn[1] = 'Y' THEN 
		wf_body_set()
//		dw_body.Enabled = FALSE 
	else
		wf_body_set1()
	END IF 
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.04.10                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
long  i, ll_row_count, ll_old_qty, ll_new_qty 
datetime ld_datetime 
String   ls_style, ls_chno, ls_color, ls_size, ls_shop_div, ls_ErrMsg

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
		ll_old_qty = dw_body.GetitemNumber(i, "deal_qty", Primary!, TRUE) 
		IF isnull(ll_old_qty) THEN ll_old_qty = 0 
      ll_new_qty = dw_body.GetitemNumber(i, "deal_qty")
		IF isnull(ll_new_qty) THEN ll_new_qty = 0 
		ls_style    = dw_body.GetitemString(i, "style")
		ls_chno     = dw_body.GetitemString(i, "chno")
		ls_color    = dw_body.GetitemString(i, "color")
		ls_size     = dw_body.GetitemString(i, "size")
		ls_shop_div = MidA(dw_body.GetitemString(i, "shop_cd"), 2, 1)
		IF gf_stresv_update (ls_style, ls_chno, ls_color, ls_size, ls_shop_div, ll_new_qty - ll_old_qty, ls_ErrMsg) = FALSE THEN 
			il_rows = -1
			EXIT
		END IF
   END IF
NEXT

IF il_rows = 1 THEN
   il_rows = dw_body.Update()
END IF

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	IF isnull(ls_ErrMsg) = FALSE AND Trim(ls_ErrMsg) <> "" THEN 
		MessageBox("SQL 오류", ls_ErrMsg)
	END IF
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_refill.enabled = false 
      end if
   CASE 5    /* 조건 */
      cb_refill.enabled = true 
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47020_e","0")
end event

type cb_close from w_com010_e`cb_close within w_47020_e
end type

type cb_delete from w_com010_e`cb_delete within w_47020_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_47020_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_47020_e
end type

type cb_update from w_com010_e`cb_update within w_47020_e
end type

type cb_print from w_com010_e`cb_print within w_47020_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_47020_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_47020_e
end type

type cb_excel from w_com010_e`cb_excel within w_47020_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_47020_e
integer y = 156
integer width = 3415
integer height = 200
string dataobject = "d_47020_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

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
		//	  MessageBox("경고","소급할수 없는 일자입니다.")
		//	  Return 1
        END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_47020_e
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_47020_e
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_47020_e
integer x = 0
integer y = 372
integer width = 3611
integer height = 1648
string dataobject = "d_47020_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.15                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "deal_qty" 
    IF Long(data) < 0 THEN
	    Return 1
    END IF
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_47020_e
integer x = 2345
integer y = 760
end type

type cb_refill from commandbutton within w_47020_e
integer x = 407
integer y = 44
integer width = 521
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "리필대상 생성(&B)"
end type

event clicked;String ls_chk, ls_errmsg
Long   ll_cnt, ll_qty
pointer oldpointer  

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

Select top 1
       'Y'
  into :ls_chk 
  from dbo.tb_52031_h_DUTY with (nolock) 
 where out_ymd   =    :is_yymmdd
   and deal_seq  =    :il_deal_seq 
	and style     like :is_brand + '%';
//	and deal_fg   =    '2' ;
IF ls_chk = 'Y' THEN 
	MessageBox("확인", String(il_deal_seq) + "차수에 판매보충(배분) 내역이 생성되여 있습니다.") 
	Return 
END IF

/* 판매 보충 처리 */
This.Enabled = False
oldpointer = SetPointer(HourGlass!)

DECLARE SP_REFILL_MID_DUTY PROCEDURE FOR SP_REFILL_MID_DUTY  
        @brand    = :is_brand, 
        @yymmdd   = :is_yymmdd,    
        @fr_ymd   = :is_fr_ymd, 
        @to_ymd   = :is_to_ymd, 
        @deal_seq = :il_deal_seq, 
        @user_id  = :gs_user_id,
		  @gubn     = :is_gubn,
		  @year		= :is_year,
		  @season   = :is_season,
		  @eshop    = :is_eshop;

EXECUTE SP_REFILL_MID_duty;

IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
   commit  USING SQLCA;
   Select count(distinct style), 
	       isnull(sum(deal_qty), 0)  
     into :ll_cnt, :ll_qty
     from dbo.tb_52031_H_DUTY with (nolock) 
    where out_ymd   =    :is_yymmdd
      and deal_seq  =    :il_deal_seq 
      and style     like :is_brand + '%'
	   and deal_fg   =    '2' ;
	MessageBox("확인", String(ll_cnt) + "모델 " + String(ll_qty, "#,##0") + "pcs 가 처리되였습니다.")
ELSE
   ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
   Rollback  USING SQLCA;
   MessageBox("처리 실패 ", ls_ErrMsg)
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type st_1 from statictext within w_47020_e
integer x = 974
integer y = 56
integer width = 1851
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_2 from statictext within w_47020_e
boolean visible = false
integer x = 955
integer y = 64
integer width = 1673
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 년도/시즌 선택은 W.의 경우에만 적용됩니다!"
boolean focusrectangle = false
end type

