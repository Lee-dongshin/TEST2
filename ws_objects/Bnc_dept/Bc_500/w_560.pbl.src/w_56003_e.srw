$PBExportHeader$w_56003_e.srw
$PBExportComments$마진율복사
forward
global type w_56003_e from w_com010_e
end type
type dw_1 from datawindow within w_56003_e
end type
end forward

global type w_56003_e from w_com010_e
integer width = 3689
integer height = 2296
dw_1 dw_1
end type
global w_56003_e w_56003_e

type variables
String is_brand, is_shop_div, is_shop_grp 
String is_chk

end variables

on w_56003_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_56003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToBottom")

dw_1.InsertRow(0)

end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2002.02.20																  */	
/* 수정일      : 2002.02.20																  */
/*===========================================================================*/
u_head_set lu_head_set

dw_head.Setitem(1, "shop_div", "%")
dw_head.Setitem(1, "shop_grp", "%")

lu_head_set = create u_head_set
lu_head_set.uf_set(dw_1)
if IsValid (lu_head_set) then
   DESTROY lu_head_set
end if

dw_1.Setitem(1, "shop_type", "1")
dw_1.Setitem(1, "basic_yn",  "N")

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
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
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G') then
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


is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_shop_grp = dw_head.GetItemString(1, "shop_grp")
if IsNull(is_shop_grp) or Trim(is_shop_grp) = "" then
   MessageBox(ls_title,"백화점계열 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_grp")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
DataWindowChild ldw_child
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, '%')
ldw_child.insertrow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")			

il_rows = dw_body.retrieve(is_brand, is_shop_div, is_shop_grp)
IF il_rows > 0 THEN 
	is_chk = 'N'
	dw_1.SetColumn("shop_cd")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         dw_1.Enabled = True 
			dw_1.SetFocus()
      end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      dw_1.Enabled = False
END CHOOSE

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_1.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "'" + &
			                         "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_1.SetRow(al_row)
				dw_1.SetColumn(as_column)
				dw_1.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_1.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_1.SetColumn("year")
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/
long   i, ll_row_count
String ls_yymmdd, ls_fr_shop_cd, ls_year, ls_season, ls_shop_type, ls_basic_yn 
String ls_to_shop_cd, ls_ErrMsg

IF dw_1.AcceptText()    <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1

ll_row_count = dw_body.RowCount()

/* 기준내역 항목을 가져온다 */
ls_yymmdd     = String(dw_1.GetitemDate(1, "yymmdd"), "yyyymmdd") 
ls_fr_shop_cd = dw_1.GetitemString(1, "shop_cd") 
ls_shop_type  = dw_1.GetitemString(1, "shop_type") 
ls_year       = dw_1.GetitemString(1, "year") 
ls_season     = dw_1.GetitemString(1, "season") 
ls_basic_yn   = dw_1.GetitemString(1, "basic_yn") 

IF isnull(ls_fr_shop_cd) OR Trim(ls_fr_shop_cd) = "" THEN 
	MessageBox("오류", "기준매장코드를 등록 하십시요! ") 
	dw_1.SetFocus()
	dw_1.SetColumn("shop_cd")
	RETURN 0 
END IF 

IF isnull(ls_year) OR Trim(ls_year) = "" THEN 
	MessageBox("오류", "시즌년도를 등록 하십시요! ") 
	dw_1.SetFocus()
	dw_1.SetColumn("year")
	RETURN 0 
END IF 

FOR i=1 TO ll_row_count
	 IF dw_body.Object.yn_chk[i] = 'N' THEN CONTINUE 
	 ls_to_shop_cd = dw_body.GetitemString(i, "shop_cd")
    DECLARE SP_56003 PROCEDURE FOR SP_56003  
            @yymmdd       = :ls_yymmdd, 
            @fr_brand     = :is_brand, 
            @fr_shop_cd   = :ls_fr_shop_cd, 
            @fr_shop_type = :ls_shop_type, 
            @fr_year      = :ls_year, 
            @fr_season    = :ls_season, 
            @basic_yn     = :ls_basic_yn, 
            @to_shop_cd   = :ls_to_shop_cd, 
            @mod_id       = :gs_user_id ; 
    EXECUTE SP_56003;
    IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
	    il_rows = 1
       commit  USING SQLCA;
	 ELSE
	    ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" + SQLCA.SQLERRTEXT
       Rollback  USING SQLCA;
	    MessageBox("저장 실패 [" + ls_to_shop_cd + "]", ls_ErrMsg)
	    il_rows = -1 
		 EXIT
	 END IF
NEXT

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56003_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56003_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_56003_e
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_56003_e
boolean visible = false
integer taborder = 50
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56003_e
end type

type cb_update from w_com010_e`cb_update within w_56003_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_56003_e
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_56003_e
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_56003_e
end type

type cb_excel from w_com010_e`cb_excel within w_56003_e
boolean visible = false
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_56003_e
integer height = 168
string dataobject = "d_56003_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild  ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')
ldw_child.SetFilter("inter_data2 = 'Y'")
ldw_child.Filter()
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")

This.GetChild("shop_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('912')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")

end event

type ln_1 from w_com010_e`ln_1 within w_56003_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_56003_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_56003_e
integer x = 1751
integer y = 376
integer width = 1842
integer height = 1672
integer taborder = 40
string dataobject = "d_56003_d02"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i 

IF dwo.name = "b_chk" THEN 
	IF is_chk = 'Y' THEN
		is_chk = 'N' 
	ELSE
		is_chk = 'Y' 
   END IF 
	FOR i = 1 TO This.RowCount() 
		This.Setitem(i, "yn_chk", is_chk) 
	NEXT 
END IF
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

type dw_print from w_com010_e`dw_print within w_56003_e
end type

type dw_1 from datawindow within w_56003_e
event ue_syscommand pbm_syscommand
event ue_keydown pbm_dwnkey
integer x = 5
integer y = 376
integer width = 1737
integer height = 1672
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "기준매장 "
string dataobject = "d_56003_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_syscommand;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

Return 

end event

event ue_keydown;/*===========================================================================*/
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

event constructor;DataWindowChild ldw_Child 

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("911") 
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%") 
ldw_child.Setitem(1, "inter_nm", "전체") 

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("003", gs_brand, '%') 

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
String   ls_yymmdd
String ls_year, ls_brand
DataWindowChild ldw_child

ib_changed = true
cb_update.enabled = true

CHOOSE CASE dwo.name
	CASE "yymmdd"	
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		

		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
//		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', is_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")								
END CHOOSE

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event itemerror;Return 1
end event

