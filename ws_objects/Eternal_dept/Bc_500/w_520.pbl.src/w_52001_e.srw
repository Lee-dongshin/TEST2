$PBExportHeader$w_52001_e.srw
$PBExportComments$판매배분 일정관리
forward
global type w_52001_e from w_com020_e
end type
type dw_1 from datawindow within w_52001_e
end type
type cb_season from commandbutton within w_52001_e
end type
type dw_season from datawindow within w_52001_e
end type
end forward

global type w_52001_e from w_com020_e
integer width = 3675
integer height = 2276
dw_1 dw_1
cb_season cb_season
dw_season dw_season
end type
global w_52001_e w_52001_e

type variables
String  is_Brand,  is_yyyy, is_yymm
end variables

on w_52001_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_season=create cb_season
this.dw_season=create dw_season
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_season
this.Control[iCurrent+3]=this.dw_season
end on

on w_52001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_season)
destroy(this.dw_season)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.10                                                  */	
/* 수정일      : 2001.12.10                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

return true	
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */ 
/* 작성일      : 2001.12.10                                                  */
/* 수정일      : 2001.12.10                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_season.retrieve(is_brand)
il_rows = dw_list.retrieve(is_yyyy)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_season.SetTransObject(SQLCA)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
			cb_season.Enabled = true
      end if
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_season.enabled = false
		dw_season.visible = false
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_season.RowCount()
IF dw_season.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_season.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_season.Setitem(i, "brand",  is_brand)
      dw_season.Setitem(i, "reg_id", gs_user_id)
      dw_season.Setitem(i, "reg_dt", ld_datetime)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_season.Setitem(i, "reg_id", gs_user_id)
      dw_season.Setitem(i, "reg_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_season.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52001_e","0")
end event

type cb_close from w_com020_e`cb_close within w_52001_e
end type

type cb_delete from w_com020_e`cb_delete within w_52001_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_52001_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_52001_e
end type

type cb_update from w_com020_e`cb_update within w_52001_e
boolean visible = false
end type

type cb_print from w_com020_e`cb_print within w_52001_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_52001_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_52001_e
end type

type cb_excel from w_com020_e`cb_excel within w_52001_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_52001_e
integer height = 168
string dataobject = "d_52001_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("Brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')
end event

type ln_1 from w_com020_e`ln_1 within w_52001_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_52001_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_52001_e
integer y = 380
integer width = 256
integer height = 1656
string dataobject = "d_52001_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.10                                                  */	
/* 수정일      : 2001.12.10                                                  */
/*===========================================================================*/
DateTime ld_datetime 
String   ls_yymmdd
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
ls_yymmdd = String(ld_datetime, "yyyymmdd")

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_yymm = This.GetItemString(row, 'yymm') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymm) THEN return
il_rows = dw_1.retrieve(is_brand, is_yymm)
dw_body.Reset()

Long   i, ll_row
String ls_week
ll_row  = dw_body.insertRow(0)
ls_week = ""

dw_body.setredraw(False)
FOR i = 1 TO il_rows 
   IF ls_week = "7" THEN
      ll_row = dw_body.insertRow(0)
	END IF
	ls_week = dw_1.GetitemString(i, "week_cd")
	dw_body.Setitem(ll_row, "dd_" + ls_week, MidA(dw_1.GetitemString(i, "yymmdd"), 7, 2))
	dw_body.Setitem(ll_row, "remark_" + ls_week, dw_1.GetitemString(i, "remark"))
	dw_body.Setitem(ll_row, "holiday_yn" + ls_week, dw_1.GetitemString(i, "holiday_yn"))
	dw_body.Setitem(ll_row, "auto_yn" + ls_week, dw_1.GetitemString(i, "auto_yn"))
NEXT
dw_body.setredraw(True)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_52001_e
integer x = 302
integer y = 380
integer width = 3291
integer height = 1656
string dataobject = "d_52001_d02"
end type

event dw_body::buttonclicked;call super::buttonclicked;String   ls_week, ls_dd, ls_yymmdd, ls_auto_yn  
Long     ll_row 
DateTime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
ls_yymmdd = String(ld_datetime, "yyyymmdd")

/* 클릭 요일 산출 */
ls_week = MidA(dwo.name, 3, 1)

/* 자료 수정 가능여부 체크 */
ls_dd = This.GetitemString(row, "dd_" + ls_week) 
IF isnull(ls_dd) OR Trim(ls_dd) = "" THEN 
	RETURN
END IF 
IF ls_yymmdd > is_yymm + ls_dd THEN
	MessageBox("경고", "과거 날짜는 변경할수 없습니다.")
	Return
ELSEIF ls_yymmdd = is_yymm + ls_dd AND String(ld_datetime, "hhmm") > '1930' THEN 
	MessageBox("경고", "자동판매 배분 작업시간이후에는 수정할수 없습니다.")
	Return
END IF

/* 자동 취소여부 체크 */
IF This.GetitemString(row, "auto_yn" + ls_week) = 'N' THEN
	ls_auto_yn = 'Y'
ELSE
	ls_auto_yn = 'N'
END IF

/* 취소여부 자료 셋 */
This.Setitem(row, "auto_yn" + ls_week, ls_auto_yn)

/* 자료 저장 [시간 체크 관계로 바로 저장처리] */
ll_row = dw_1.Find("yymmdd = '" + is_yymm + ls_dd + "'", 1, dw_1.RowCount())
dw_1.Setitem(ll_row, "auto_yn", ls_auto_yn)
IF dw_1.Object.row_stat[ll_row] = 'NEW' THEN
   dw_1.SetItemStatus(ll_row, 0, Primary!, NewModified!)
   dw_1.Setitem(ll_row, "reg_id", gs_user_id)
	dw_1.Setitem(ll_row, "row_stat", 'MOD')
ELSE
   dw_1.Setitem(ll_row, "mod_id", gs_user_id)
   dw_1.Setitem(ll_row, "mod_dt", ld_datetime)
END IF

il_rows = dw_1.Update()
if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

end event

type st_1 from w_com020_e`st_1 within w_52001_e
integer x = 283
integer y = 380
integer height = 1656
end type

type dw_print from w_com020_e`dw_print within w_52001_e
end type

type dw_1 from datawindow within w_52001_e
boolean visible = false
integer x = 2245
integer y = 304
integer width = 649
integer height = 432
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_52001_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_season from commandbutton within w_52001_e
integer x = 1294
integer y = 44
integer width = 549
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "판매보충 운영 시즌"
end type

event clicked;dw_season.visible = True
dw_list.Enabled   = False 
dw_body.Enabled   = False

DataWindowChild ldw_child 

dw_season.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', is_brand, '%')
end event

type dw_season from datawindow within w_52001_e
event ue_syscommend pbm_syscommand
boolean visible = false
integer x = 1271
integer y = 360
integer width = 969
integer height = 808
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "판매보충 운영시즌"
string dataobject = "d_52001_d10"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_syscommend;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return

end event

event buttonclicked;CHOOSE CASE dwo.name 
	CASE "b_close"
		IF This.modifiedcount() > 0 OR This.deletedcount() > 0 THEN 
         CHOOSE CASE gf_update_yn(Parent.title)
      	   CASE 1
		         IF Parent.Trigger Event ue_update() < 1 THEN
			         return
               END IF		
	         CASE 2
					This.Retrieve(is_brand)
          		This.visible = False
               dw_list.Enabled   = True
               dw_body.Enabled   = True
               dw_body.SetFocus()
	         CASE 3
		        return
         END CHOOSE
		ELSE
   		This.visible      = False 
         dw_list.Enabled   = True   
         dw_body.Enabled   = True   
			dw_body.SetFocus()
		END IF
	CASE "b_update"
		Parent.Trigger Event ue_update()
END CHOOSE 
end event

event constructor;DataWindowChild ldw_child 

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', gs_brand, '%')
end event

event itemchanged;DataWindowChild ldw_season
string ls_year

this.accepttext()

CHOOSE CASE dwo.name
	CASE  "year"
		ls_year = data
	
		this.getchild("season",ldw_season)
		ldw_season.settransobject(sqlca)
		ldw_season.retrieve('003', is_brand, ls_year)
		ldw_season.insertrow(1)
		ldw_season.Setitem(1, "inter_cd", "%")
		ldw_season.Setitem(1, "inter_nm", "전체")
		
		
END CHOOSE

end event

