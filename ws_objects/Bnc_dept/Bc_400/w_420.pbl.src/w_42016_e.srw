$PBExportHeader$w_42016_e.srw
$PBExportComments$기타출고일괄처리
forward
global type w_42016_e from w_com010_e
end type
end forward

global type w_42016_e from w_com010_e
end type
global w_42016_e w_42016_e

type variables
String is_house,  is_jup_gubn, is_acc_gubn,  is_yymmdd  
String is_brand,  is_year,     is_season,    is_remark  
Datawindowchild idw_brand
end variables

on w_42016_e.create
call super::create
end on

on w_42016_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
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

is_house = dw_head.GetItemString(1, "house")
if IsNull(is_house) or Trim(is_house) = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_acc_gubn = dw_head.GetItemString(1, "acc_gubn")
IF is_jup_gubn = '02' THEN
	if IsNull(is_acc_gubn) or Trim(is_acc_gubn) = "" then
		MessageBox(ls_title,"회계구분 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("acc_gubn")
		return false
	end if
END IF

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

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


if is_brand = "V" or is_brand = "B" or is_brand = "F" or is_brand = "L" then
			messagebox("주의", "이터널 브랜드의 경우 이터널영업관리를 이용하세요!")
			 return false	
//			return -1
//			Return 0
End if		

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_remark = dw_head.GetItemString(1, "remark")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
Long i

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_house, is_brand, is_year, is_season, is_remark)
IF il_rows > 0 THEN
   FOR i=1 TO il_rows 
       dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
   NEXT
   dw_body.SetFocus()
	dw_head.Setitem(1, "out_no", "")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_update.enabled = true
         cb_print.enabled = false
		end if
   CASE 5    /* 조건 */
      cb_retrieve.Text = "산출(&Q)"
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String   ls_out_no 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF dw_body.GetItemStatus(1, 0, Primary!) = NewModified! THEN
//   IF gf_style_outno(is_yymmdd, is_brand, ls_out_no) = FALSE THEN RETURN -1
	
	select substring(convert(varchar(5), convert(decimal(5),	isnull(max(out_no), '0')) + 10001), 2, 4)
	into :ls_out_no
	from	tb_42010_h with (nolock)
	  where	house_cd	= :is_house
		  and	yymmdd	= :is_yymmdd;
		  

	if isnull(ls_out_no)  or ls_out_no = "0000" then return -1 
	
	
ELSE
	ls_out_no = dw_body.GetitemString(1, "out_no")
END IF 

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "out_no",   ls_Out_no)
      dw_body.Setitem(i, "no",       String(i, "0000"))
      dw_body.Setitem(i, "jup_gubn", is_jup_gubn)
      dw_body.Setitem(i, "acc_gubn", is_acc_gubn)
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	dw_head.Setitem(1, "out_no", ls_out_no)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;is_jup_gubn = '02'

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42016_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42016_e
end type

type cb_delete from w_com010_e`cb_delete within w_42016_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_42016_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42016_e
string text = "산출(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_42016_e
end type

type cb_print from w_com010_e`cb_print within w_42016_e
end type

type cb_preview from w_com010_e`cb_preview within w_42016_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_42016_e
end type

type cb_excel from w_com010_e`cb_excel within w_42016_e
end type

type dw_head from w_com010_e`dw_head within w_42016_e
integer height = 240
string dataobject = "d_42016_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("house", ldw_child)
ldw_child.SetTransObject(Sqlca)
ldw_child.Retrieve()

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(Sqlca)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

This.GetChild("acc_gubn", ldw_child)
ldw_child.SetTransObject(Sqlca)
ldw_child.Retrieve('027')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;DataWindowChild ldw_child 


CHOOSE CASE dwo.name
	CASE "brand", "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",ldw_child)
			ldw_child.settransobject(sqlca)
			ldw_child.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')

END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_42016_e
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_e`ln_2 within w_42016_e
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_e`dw_body within w_42016_e
integer y = 440
integer width = 3570
integer height = 1556
string dataobject = "d_42016_d01"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/
Long ll_tag_price 

CHOOSE CASE dwo.name
	CASE "qty" 
		ll_tag_price = This.GetitemNumber(row, "tag_price")
		This.Setitem(row, "amt", ll_tag_price * long(data))
END CHOOSE

end event

event dw_body::ue_keydown;call super::ue_keydown;/*===========================================================================*/
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

type dw_print from w_com010_e`dw_print within w_42016_e
end type

