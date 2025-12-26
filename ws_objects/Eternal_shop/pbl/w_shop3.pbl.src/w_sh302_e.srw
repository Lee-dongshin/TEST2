$PBExportHeader$w_sh302_e.srw
$PBExportComments$메시지관리[발신메시지관리]
forward
global type w_sh302_e from w_com020_e
end type
type pb_insert from picturebutton within w_sh302_e
end type
type pb_send from picturebutton within w_sh302_e
end type
type pb_delete from picturebutton within w_sh302_e
end type
type cb_1 from commandbutton within w_sh302_e
end type
type gb_1 from groupbox within w_sh302_e
end type
type dw_recv_list from datawindow within w_sh302_e
end type
end forward

global type w_sh302_e from w_com020_e
integer width = 2990
integer height = 2060
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
long backcolor = 16777215
pb_insert pb_insert
pb_send pb_send
pb_delete pb_delete
cb_1 cb_1
gb_1 gb_1
dw_recv_list dw_recv_list
end type
global w_sh302_e w_sh302_e

type variables
String  is_confirm_yn, is_dept_code
datawindowchild  idw_dept_code
end variables

forward prototypes
public subroutine wf_push (string as_shop_cd, string as_yymmdd, string as_send_id, long al_mes_seq)
end prototypes

public subroutine wf_push (string as_shop_cd, string as_yymmdd, string as_send_id, long al_mes_seq);string ls_title, ls_content, ls_url, ls_to_id, ls_shop_nm


select dbo.sf_shop_nm(:as_send_id, 's')
into :ls_shop_nm
from dual;



if IsNull(ls_shop_nm) or Trim(ls_shop_nm) = "" then
  ls_shop_nm = "발송자"
end if

ls_title = MidA(as_yymmdd,1,4) + '/' + MidA(as_yymmdd,5,2) + '/' + MidA(as_yymmdd,7,2) + ' 신규 수신 메세지가 있습니다.'
ls_content = MidA(as_yymmdd,1,4) + '/' + MidA(as_yymmdd,5,2) + '/' + MidA(as_yymmdd,7,2) + ' ' + ls_shop_nm + '님이 보낸 신규 메세지가 있습니다.'
ls_url = 'http://smartstore.ibeaucre.co.kr/bnc_shop/W_SH303_D02.asp?yymmdd='+as_yymmdd+'&send_id='+as_send_id+'&mes_seq='+string(al_mes_seq)
ls_to_id = as_shop_cd

gf_push(ls_title, ls_content, ls_url, ls_to_id)
end subroutine

on w_sh302_e.create
int iCurrent
call super::create
this.pb_insert=create pb_insert
this.pb_send=create pb_send
this.pb_delete=create pb_delete
this.cb_1=create cb_1
this.gb_1=create gb_1
this.dw_recv_list=create dw_recv_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_insert
this.Control[iCurrent+2]=this.pb_send
this.Control[iCurrent+3]=this.pb_delete
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.dw_recv_list
end on

on w_sh302_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_insert)
destroy(this.pb_send)
destroy(this.pb_delete)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.dw_recv_list)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.12 (ktb)                                            */
/*===========================================================================*/
inv_resize.of_Register(pb_send, "FixedToBottom")
inv_resize.of_Register(pb_insert, "FixedToBottom")
inv_resize.of_Register(pb_delete, "FixedToBottom")

inv_resize.of_Register(gb_1, "FixedToBottom&ScaleToRight")

dw_recv_list.SetTransObject(SQLCA)

dw_body.InsertRow(0)
end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.12                                                  */
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

//if mid(gs_shop_cd,3,4) = '2000' then
//	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
//	return false
//end if	
//

is_confirm_yn = dw_head.GetItemString(1, "confirm_yn")
IF is_confirm_yn = "" OR isnull(is_confirm_yn) THEN
	is_confirm_yn = "%"
END IF


is_dept_code = dw_head.GetItemString(1, "dept_code")
IF is_dept_code = "" OR isnull(is_dept_code) THEN
	is_dept_code = "%"
END IF

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.12 (김 태범)                                        */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

il_rows = dw_list.retrieve(gs_shop_cd, is_confirm_yn)

dw_body.Reset()
dw_body.insertRow(0)
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.12  (김 태범)                                       */
/*===========================================================================*/
long     i, ll_row_count,  ll_mes_seq
datetime ld_datetime
string	ls_yymmdd, ls_yn 

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = String(ld_datetime, "yyyymmdd")

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
	SELECT isnull(MAX(mes_seq),0)+1 INTO :ll_mes_seq
     FROM TB_57010_H
    WHERE yymmdd = :ls_yymmdd
      AND send_id= :gs_shop_cd;
   dw_body.Setitem(1, "yymmdd",  ls_yymmdd)
   dw_body.Setitem(1, "send_id", gs_shop_cd)
   dw_body.Setitem(1, "mes_seq", ll_mes_seq)
   dw_body.Setitem(1, "reg_id",  gs_user_id)
	
ELSEIF idw_status = DataModified! THEN		    /* Modify Record */
   dw_body.Setitem(1, "mod_id",  gs_user_id)
   dw_body.Setitem(1, "mod_dt",  ld_datetime)
END IF

dw_list.setredraw(FALSE)
FOR i = dw_recv_list.RowCount() TO 1 step -1 
	ls_yn = dw_recv_list.GetitemString(i, "send_yn")
	IF ls_yn = 'Y' THEN 
		dw_list.insertRow(1)
		dw_list.Setitem(1, "yymmdd",     ls_yymmdd )
		dw_list.Setitem(1, "send_id",    gs_shop_cd)
		dw_list.Setitem(1, "mes_seq",    ll_mes_seq)
		dw_list.Setitem(1, "recv_id",    dw_recv_list.GetitemString(i, "recv_id"))
		dw_list.Setitem(1, "send_dt",    ld_datetime)
		dw_list.Setitem(1, "confirm_yn", 'N')
		dw_list.Setitem(1, "reg_id",     gs_user_id)
		dw_list.Setitem(1, "reg_dt",     ld_datetime)
		dw_list.Setitem(1, "recv_nm",    dw_recv_list.GetitemString(i, "recv_nm"))

		//wf_push(dw_recv_list.GetitemString(i, "recv_id"), ls_yymmdd, gs_shop_cd, ll_mes_seq)       //푸쉬넣기		
		
	END IF 
NEXT

il_rows = dw_body.Update(TRUE, FALSE)
IF il_rows = 1 THEN 
	dw_list.Update(TRUE, FALSE)
END IF 

if il_rows = 1 then
   dw_body.ResetUpdate()
   dw_list.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
   dw_list.retrieve(gs_shop_cd, is_confirm_yn)
end if
dw_list.setredraw(True)

This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com020_e`cb_close within w_sh302_e
integer taborder = 160
end type

type cb_delete from w_com020_e`cb_delete within w_sh302_e
boolean visible = false
integer x = 2135
integer y = 48
integer taborder = 110
end type

type cb_insert from w_com020_e`cb_insert within w_sh302_e
boolean visible = false
integer x = 1792
integer y = 48
integer taborder = 100
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_sh302_e
integer taborder = 60
end type

type cb_update from w_com020_e`cb_update within w_sh302_e
boolean visible = false
integer taborder = 150
end type

type cb_print from w_com020_e`cb_print within w_sh302_e
boolean visible = false
integer taborder = 120
end type

type cb_preview from w_com020_e`cb_preview within w_sh302_e
boolean visible = false
integer taborder = 130
end type

type gb_button from w_com020_e`gb_button within w_sh302_e
long backcolor = 16777215
end type

type dw_head from w_com020_e`dw_head within w_sh302_e
integer height = 160
integer taborder = 50
string dataobject = "d_sh302_h01"
end type

event dw_head::constructor;DataWindowChild ldw_child 

This.GetChild("dept_code", idw_dept_code )
idw_dept_code.SetTransObject(SQLCA)
idw_dept_code.Retrieve(gs_brand)

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
//			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

type ln_1 from w_com020_e`ln_1 within w_sh302_e
integer beginy = 332
integer endx = 2907
integer endy = 332
end type

type ln_2 from w_com020_e`ln_2 within w_sh302_e
integer beginy = 336
integer endx = 2907
integer endy = 336
end type

type dw_list from w_com020_e`dw_list within w_sh302_e
integer y = 344
integer width = 1193
integer height = 1484
integer taborder = 70
string title = "매장"
string dataobject = "d_sh302_d01"
boolean hscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_list::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
addToolTipItem(handle(this), "☞ 메시지 선택")
end event

event dw_list::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.04.12   (김 태범)                                      */
/*===========================================================================*/
String   ls_yymmdd, ls_recv_nm 
Long     ll_mes_seq

IF row <= 0 THEN RETURN 

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_yymmdd 	= this.GetItemString(row,'yymmdd')
ll_mes_seq  = this.GetItemNumber(row,'mes_seq')
ls_recv_nm  = this.GetItemString(row,'recv_nm')

IF dw_body.Retrieve(ls_yymmdd, gs_shop_cd, ll_mes_seq) > 0 THEN 
	dw_body.Setitem(1, "recv_nm", ls_recv_nm) 
END IF


end event

type dw_body from w_com020_e`dw_body within w_sh302_e
integer x = 1193
integer y = 348
integer width = 1719
integer height = 1224
integer taborder = 80
string title = "메시지 내용"
string dataobject = "d_sh302_d02"
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
addToolTipItem(handle(this), "☞ 메시지 내용")
end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		IF dw_body.GetColumnName() <> "mes" THEN
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
END CHOOSE

Return 0
end event

event dw_body::editchanged;//

end event

event dw_body::itemchanged;//

end event

type st_1 from w_com020_e`st_1 within w_sh302_e
boolean visible = false
integer x = 1157
integer y = 344
integer height = 1500
boolean enabled = false
end type

type dw_print from w_com020_e`dw_print within w_sh302_e
end type

type pb_insert from picturebutton within w_sh302_e
integer x = 1742
integer y = 1624
integer width = 183
integer height = 160
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "new01.gif"
alignment htextalign = left!
end type

event constructor;addToolTipItem(handle(this), "☞ 새로운 메시지를 추가합니다!")
end event

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.12   (김 태범)                                      */
/*===========================================================================*/
dw_body.Reset()
dw_body.InsertRow(0)
dw_body.SetFocus()
dw_body.SetColumn("title")

end event

type pb_send from picturebutton within w_sh302_e
integer x = 2162
integer y = 1624
integer width = 183
integer height = 160
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "send01.gif"
alignment htextalign = left!
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
addToolTipItem(handle(this), "☞ 메시지를 보냅니다!!!")
end event

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.12   (김 태범)                                      */
/*===========================================================================*/
String ls_recv_nm, ls_mes

dw_body.AcceptText()

ls_recv_nm = dw_body.GetitemString(1, "recv_nm")
IF isnull(ls_recv_nm) or Trim(ls_recv_nm) = '' THEN
	MessageBox("오류", "수신 받을 대상이 없습니다!")
	RETURN 
END IF

ls_mes = dw_body.GetitemString(1, "mes")
IF isnull(ls_mes) or Trim(ls_mes) = '' THEN
	MessageBox("오류", "보낼 메시지가 없습니다!")
	RETURN 
END IF

Parent.Trigger Event ue_update()


end event

type pb_delete from picturebutton within w_sh302_e
integer x = 1952
integer y = 1624
integer width = 183
integer height = 160
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "delete01.gif"
alignment htextalign = left!
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
addToolTipItem(handle(this), "☞ 삭제합니다!")
end event

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.12   (김 태범)                                      */
/*===========================================================================*/
IF dw_body.RowCount() < 1 THEN RETURN 

dw_body.setredraw(False)
dw_body.DeleteRow(1)
il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	Parent.Trigger Event ue_retrieve()
   dw_body.InsertRow(0)
   dw_body.SetFocus()
   dw_body.SetColumn("title")
else
   rollback  USING SQLCA;
end if

dw_body.setredraw(True)

end event

type cb_1 from commandbutton within w_sh302_e
integer x = 1170
integer y = 44
integer width = 347
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "수신자 목록"
end type

event clicked;dw_recv_list.reset()
is_dept_code = dw_head.GetItemString(1, "dept_code")
IF is_dept_code = "" OR isnull(is_dept_code) THEN
	is_dept_code = "%"
END IF

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

IF dw_recv_list.RowCount() < 1 THEN 
	dw_recv_list.Retrieve(gs_shop_cd, gs_brand, is_dept_code)
END IF 

dw_recv_list.visible = True
//sle_find.visible     = True
dw_head.Enabled      = False 
dw_list.Enabled      = False 
dw_body.Enabled      = False 
cb_1.Enabled         = False

//sle_find.SetFocus()
end event

type gb_1 from groupbox within w_sh302_e
integer x = 1193
integer y = 1576
integer width = 1719
integer height = 244
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711935
long backcolor = 15793151
end type

type dw_recv_list from datawindow within w_sh302_e
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 768
integer y = 212
integer width = 1463
integer height = 1452
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "수신자 목록"
string dataobject = "d_sh302_d05"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event ue_syscommand;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return

end event

event buttonclicked;Long i 
String ls_recv_list
 
CHOOSE CASE dwo.name 
	CASE 'b_yes'
		FOR i = 1 TO This.RowCount() 
			This.object.send_yn[i] = 'Y'
		NEXT 
	CASE 'b_no'
		FOR i = 1 TO This.RowCount()
			This.object.send_yn[i] = 'N'
		NEXT 
	CASE 'b_ent'
		FOR i = 1 TO This.RowCount()
         IF This.object.send_yn[i] = 'Y' THEN
				ls_recv_list = ls_recv_list + This.object.recv_nm[i] + ','
			END IF 
		NEXT 
		dw_body.Setitem(1, "recv_nm", ls_recv_list) 
		This.Visible     = False 
  //    sle_find.visible = False  
      dw_head.Enabled  = True  
      dw_list.Enabled  = True  
      dw_body.Enabled  = True  
      cb_1.Enabled     = True 
END CHOOSE 
end event

