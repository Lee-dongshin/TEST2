$PBExportHeader$w_57001_e.srw
$PBExportComments$메시지관리
forward
global type w_57001_e from w_com010_e
end type
type tab_1 from tab within w_57001_e
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_57001_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_4 from datawindow within w_57001_e
end type
type dw_5 from datawindow within w_57001_e
end type
type dw_6 from datawindow within w_57001_e
end type
type st_1 from statictext within w_57001_e
end type
type mle_title from multilineedit within w_57001_e
end type
type mle_content from multilineedit within w_57001_e
end type
type mle_url from multilineedit within w_57001_e
end type
type mle_to_id from multilineedit within w_57001_e
end type
type cb_push from commandbutton within w_57001_e
end type
end forward

global type w_57001_e from w_com010_e
integer width = 3662
integer height = 2224
boolean controlmenu = false
event ue_popupmenu ( integer ai_menuitem )
tab_1 tab_1
dw_4 dw_4
dw_5 dw_5
dw_6 dw_6
st_1 st_1
mle_title mle_title
mle_content mle_content
mle_url mle_url
mle_to_id mle_to_id
cb_push cb_push
end type
global w_57001_e w_57001_e

type variables
String is_brand, is_shop_div, is_gubun
String is_yymmdd,is_send_id 
integer ii_mes_seq

end variables

forward prototypes
public subroutine wf_push (string as_shop_cd, string as_yymmdd, string as_send_id, long al_mes_seq)
public subroutine wf_send_msg ()
end prototypes

event ue_popupmenu(integer ai_menuitem);/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
String 	ls_mes_stat
long		ll_row

ll_row = tab_1.tabpage_2.dw_2.GetRow()

IF ll_row < 1 THEN RETURN 

IF ai_menuitem = 1 THEN	//매장별 메시지보내기
	dw_5.Visible = True
	dw_6.Visible = True
	dw_6.InsertRow(1)
ELSE
	ls_mes_stat = tab_1.tabpage_2.dw_2.GetItemString(ll_row,'mes_stat')
	IF ls_mes_stat <> '미발송' THEN
		dw_4.Visible = True
		dw_4.Retrieve(is_yymmdd, is_send_id, ii_mes_seq)
	END IF
END IF



end event

public subroutine wf_push (string as_shop_cd, string as_yymmdd, string as_send_id, long al_mes_seq);string ls_title, ls_content, ls_url, ls_to_id, ls_send_nm

select dbo.sf_user_nm(:gs_user_id)
into :ls_send_nm
from dual;

if as_send_id = '000000' then
	ls_send_nm = ' 본사직원 ' + ls_send_nm
end if


ls_title = MidA(as_yymmdd,5,2) + '/' + MidA(as_yymmdd,7,2) + ls_send_nm + ' 으로부터 받은 메세지가 있습니다.'
ls_content = MidA(as_yymmdd,5,2) + '/' + MidA(as_yymmdd,7,2) + ls_send_nm + ' 으로보터 발송된 신규 수신 메세지가 있습니다.'
ls_url = 'http://smartstore.ibeaucre.co.kr/bnc_shop/W_SH303_D02.asp?yymmdd='+as_yymmdd+'&send_id='+as_send_id+'&mes_seq='+string(al_mes_seq)
ls_to_id = as_shop_cd

gf_push(ls_title, ls_content, ls_url, ls_to_id)
end subroutine

public subroutine wf_send_msg ();String 	ls_check_flag, ls_mes_stat, ls_send_nm
long		ll_row,        i, j
datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF
                                 // 
IF MessageBox("확인" , "메시지를 전송할까요?", Exclamation!, OKCancel!, 2) = 2 THEN 
	return
END IF


dw_4.Reset()
ll_row = dw_5.RowCount()
j = 0

FOR i = 1 TO ll_row
	ls_check_flag = dw_5.GetItemString(i,'check_flag')
	IF ls_check_flag = 'Y' THEN
		j = j + 1
		dw_4.InsertRow(1)
		dw_4.SetItem(1,'yymmdd' , is_yymmdd)
		dw_4.SetItem(1,'send_id', is_send_id)
		dw_4.SetItem(1,'send_dt', ld_datetime)		
		dw_4.SetItem(1,'mes_seq', ii_mes_seq)
		dw_4.SetItem(1,'recv_id', dw_5.GetItemString(i,'shop_cd'))
		dw_4.SetItem(1,'reg_id' , gs_user_id)				
		
		//wf_push(dw_5.GetItemString(i,'shop_cd'), is_yymmdd, is_send_id, ii_mes_seq)       //푸쉬넣기
		
	END IF
NEXT

IF j=0 THEN
	MessageBox("확인","수신 받을 대상이 없습니다!") // 
	return
ELSE
	dw_4.Update()
	Commit;
	tab_1.tabpage_2.dw_2.SetRedRaw(False)
   tab_1.tabpage_2.dw_2.Retrieve(gs_user_id)
	tab_1.tabpage_2.dw_2.SetRedRaw(True)
	MessageBox("확인", "전송되었습니다.")  
END IF


end subroutine

on w_57001_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_4=create dw_4
this.dw_5=create dw_5
this.dw_6=create dw_6
this.st_1=create st_1
this.mle_title=create mle_title
this.mle_content=create mle_content
this.mle_url=create mle_url
this.mle_to_id=create mle_to_id
this.cb_push=create cb_push
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_4
this.Control[iCurrent+3]=this.dw_5
this.Control[iCurrent+4]=this.dw_6
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.mle_title
this.Control[iCurrent+7]=this.mle_content
this.Control[iCurrent+8]=this.mle_url
this.Control[iCurrent+9]=this.mle_to_id
this.Control[iCurrent+10]=this.cb_push
end on

on w_57001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.dw_6)
destroy(this.st_1)
destroy(this.mle_title)
destroy(this.mle_content)
destroy(this.mle_url)
destroy(this.mle_to_id)
destroy(this.cb_push)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보                 										  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
of_SetResize(True)

This.SetMicroHelp("Program Select!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_4, "ScaleToBottom")
inv_resize.of_Register(dw_5, "ScaleToBottom")

st_1.Text = '내용은 2000자 까지 입력 가능합니다.'
tab_1.tabpage_1.Text = '받은메세지'
tab_1.tabpage_2.Text = '보낸메세지'
dw_5.Title = '수신매장선택'
dw_4.Title = '매장별수신메시지조회'

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)



end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
long     i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

is_yymmdd = String(Date(ld_datetime),"yyyymmdd")

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	   IF dw_body.GetitemString(i, "send_fg") = '1' THEN
		   is_send_id = '000000' 
		ELSE
		   is_send_id = gs_user_id 
		END IF 
		SELECT isnull(MAX(mes_seq),0)+1 
		  INTO :ii_mes_seq
        FROM TB_57010_H WITH (NOLOCK) 
       WHERE yymmdd = :is_yymmdd
         AND send_id= :is_send_id;
      dw_body.Setitem(i, "yymmdd",  is_yymmdd)
      dw_body.Setitem(i, "send_id", is_send_id)
      dw_body.Setitem(i, "mes_seq", ii_mes_seq)
      dw_body.Setitem(i, "reg_id",  gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	tab_1.tabpage_2.dw_2.SetRedRaw(False)
   tab_1.tabpage_2.dw_2.Retrieve(gs_user_id)
	tab_1.tabpage_2.dw_2.SetRedRaw(True)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

dw_5.Visible = True
dw_6.Visible = True
dw_6.InsertRow(1)

return il_rows

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

tab_1.tabpage_1.dw_1.Retrieve(gs_user_id,is_brand, is_gubun)
tab_1.tabpage_2.dw_2.Retrieve(gs_user_id)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_delete();call super::ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
long		ll_row

ll_row = tab_1.tabpage_2.dw_2.GetRow()
tab_1.tabpage_2.dw_2.deleterow(ll_row)

ib_changed = false
cb_update.enabled = false

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if


end event

event ue_insert();call super::ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
tab_1.SelectTab(2)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_gubun = dw_head.GetItemString(1, "gubun")
if IsNull(is_gubun) or Trim(is_gubun) = "" then
   is_gubun = '%'   
end if

return true

end event

event open;call super::open;dw_head.Setitem(1,'Brand', '%')
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_57001_e","0")
end event

type cb_close from w_com010_e`cb_close within w_57001_e
end type

type cb_delete from w_com010_e`cb_delete within w_57001_e
boolean enabled = true
end type

type cb_insert from w_com010_e`cb_insert within w_57001_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_57001_e
end type

type cb_update from w_com010_e`cb_update within w_57001_e
end type

type cb_print from w_com010_e`cb_print within w_57001_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_57001_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_57001_e
end type

type cb_excel from w_com010_e`cb_excel within w_57001_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_57001_e
integer width = 1577
integer height = 92
string dataobject = "d_57001_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')



end event

type ln_1 from w_com010_e`ln_1 within w_57001_e
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_57001_e
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_57001_e
integer x = 18
integer y = 960
integer width = 3575
integer height = 1092
string dataobject = "d_57001_d03"
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

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

type dw_print from w_com010_e`dw_print within w_57001_e
end type

type tab_1 from tab within w_57001_e
integer x = 9
integer y = 276
integer width = 3589
integer height = 680
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
cb_delete.Enabled = False
//dw_body.Enabled = False
dw_body.Reset()
dw_body.InsertRow(1)
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 568
long backcolor = 79741120
string text = "받은메시지"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer y = 16
integer width = 3547
integer height = 548
integer taborder = 110
string title = "none"
string dataobject = "d_57001_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
String 	ls_yymmdd, ls_send_id, ls_recv_id, ls_confirm_yn
int		li_mes_seq
datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF row > 0 THEN
	ls_yymmdd 	= this.GetItemString(row,'yymmdd')
	ls_send_id	= this.GetItemString(row,'send_id')
	li_mes_seq  = this.GetItemNumber(row,'mes_seq')
   ls_recv_id	= this.GetItemString(row,'recv_id')
	
	dw_body.Retrieve(ls_yymmdd, ls_send_id, li_mes_seq)
   IF ls_recv_id = '000000' THEN 
		dw_body.Setitem(1, "send_fg", '1')
	ELSE
		dw_body.Setitem(1, "send_fg", '2')
	END IF 
	ls_confirm_yn 	= this.GetItemString(row,'confirm_yn')
	IF isnull(ls_confirm_yn) OR ls_confirm_yn = 'N' THEN
		UPDATE TB_57011_H
         SET confirm_yn = 'Y', 
			    confirm_dt = :ld_datetime
       WHERE yymmdd		= :ls_yymmdd
         AND send_id	   = :ls_send_id
         AND mes_seq	   = :li_mes_seq
			AND recv_id    = :ls_recv_id;
		Commit USING SQLCA;	
		this.SetItem(row,'mes_stat',  '확인')
		this.SetItem(row,'confirm_yn','Y')
		this.SetItem(row,'confirm_dt',ld_datetime)
	END IF
ELSE
	return
END IF

this.selectRow(0, false);
this.setRow(row);
this.selectRow(row, true);
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 568
long backcolor = 79741120
string text = "보낸메시지"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer y = 16
integer width = 3547
integer height = 552
integer taborder = 10
string title = "none"
string dataobject = "d_57001_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
String 	ls_yymmdd, ls_send_id, ls_mes_stat
int		li_mes_seq

IF row > 0 THEN

	this.selectRow(0, false);
	this.setRow(row);
	this.selectRow(row, true);

	ls_yymmdd 	= this.GetItemString(row,'yymmdd')
	ls_send_id	= this.GetItemString(row,'send_id')
	li_mes_seq  = this.GetItemNumber(row,'mes_seq')

	dw_body.Retrieve(ls_yymmdd, ls_send_id, li_mes_seq)
   IF ls_send_id = '000000' THEN
		dw_body.Setitem(1, "send_fg", '1')
	ELSE
		dw_body.Setitem(1, "send_fg", '2')
	END IF 
	ls_mes_stat = this.GetItemString(row,'mes_stat')
	IF ls_mes_stat = '미발송' THEN
		 cb_delete.enabled = True
	ELSE
		 cb_delete.enabled = False
	END IF
ELSE
	return
END IF


end event

event doubleclicked;String 	ls_yymmdd,ls_send_id,ls_mes_stat
int		li_mes_seq

IF row > 0 THEN
	this.selectRow(0, false);
	this.setRow(row);
	this.selectRow(row, true);
	ls_mes_stat = this.GetItemString(row,  'mes_stat')
	IF ls_mes_stat =  '미발송'  THEN
	ELSE
		ls_yymmdd 	= this.GetItemString(row,'yymmdd')
		ls_send_id	= this.GetItemString(row,'send_id')
		li_mes_seq  = this.GetItemNumber(row,'mes_seq')
		dw_4.Visible = True
		dw_4.Retrieve(ls_yymmdd, ls_send_id, li_mes_seq)
	END IF
END IF


end event

event rbuttondown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
String ls_mes_stat
int	 li_mes_seq

IF row < 1 THEN  RETURN 

this.selectRow(0, false)
this.setRow(row)
this.selectRow(row, true)

is_yymmdd 	= this.GetItemString(row,'yymmdd')
is_send_id	= this.GetItemString(row,'send_id')
ii_mes_seq  = this.GetItemNumber(row,'mes_seq')

m_popup1 NewMenu
	
NewMenu = CREATE m_popup1
	
NewMenu.PopMenu(PointerX() + 50, PointerY() + 300)

end event

type dw_4 from datawindow within w_57001_e
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 229
integer y = 84
integer width = 2702
integer height = 1732
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "매장별수신메시지조회"
string dataobject = "d_57001_d04"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event type long ue_syscommand(unsignedlong commandtype, integer xpos, integer ypos);/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return  0
end event

event buttonclicked;IF dwo.name = "cb_mes_close" THEN
   dw_4.Visible = False
END IF

end event

type dw_5 from datawindow within w_57001_e
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 635
integer y = 184
integer width = 1755
integer height = 1704
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "수신매장선택"
string dataobject = "d_57001_d05"
boolean vscrollbar = true
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

return

end event

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
DatawindowChild ldc

This.GetChild("brand", ldc)
ldc.SetTransObject(SQLCA)
ldc.Retrieve('001')

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
Long i
			
CHOOSE CASE dwo.name
	CASE "cb_allselect"
		FOR i = 1 TO This.RowCount()
			This.SetItem(i,'check_flag','Y')
		NEXT
	CASE "cb_allcancel"
		FOR i = 1 TO This.RowCount()
			This.SetItem(i,'check_flag','N')
		NEXT
	CASE "cb_close_shop"
			This.Visible = False
			dw_6.Visible = False
	CASE "cb_mes_send"
			wf_send_msg()
END CHOOSE


end event

event clicked;gf_tsort(dw_5)
end event

type dw_6 from datawindow within w_57001_e
boolean visible = false
integer x = 663
integer y = 288
integer width = 1618
integer height = 196
integer taborder = 110
boolean bringtotop = true
string title = "none"
string dataobject = "d_57001_d06"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
DatawindowChild ldc

This.GetChild("brand", ldc)
ldc.SetTransObject(SQLCA)
ldc.Retrieve('001')
ldc.InsertRow(1)
ldc.SetItem(1, "inter_cd", '%')
ldc.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_div", ldc)
ldc.SetTransObject(SQLCA)
ldc.Retrieve('910')
ldc.InsertRow(1)
ldc.SetItem(1, "inter_cd", '%')
ldc.SetItem(1, "inter_nm", '전체')
ldc.SetFilter("inter_cd <> 'A' and inter_cd <> 'T' and inter_cd <> 'X' and inter_cd <> 'Z'")
ldc.Filter()
ldc.InsertRow(1)
ldc.SetItem(1, "inter_cd", 'X')
ldc.SetItem(1, "inter_nm", '생산업체')


This.GetChild("empno", ldc)
ldc.SetTransObject(SQLCA)
ldc.Retrieve(gs_brand)
ldc.InsertRow(0)
end event

event buttonclicked;string ls_empno, ls_recv_id

is_brand = dw_6.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
	MessageBox("확인요망", "브랜드를 선택 하십시요!")
	This.SetColumn("brand")
	Return 
end if

is_shop_div = dw_6.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
	MessageBox("확인요망", "유통망을 선택 하십시요!")
	This.SetColumn("shop_div")
	Return 
end if

ls_empno = dw_6.GetItemString(1, "empno")
if IsNull(ls_empno) or Trim(ls_empno) = "" then
	ls_empno = "%"	
end if

ls_recv_id = dw_6.GetItemString(1, "recv_id")

dw_5.retrieve(is_brand, is_shop_div, ls_empno, ls_recv_id) 

end event

event itemchanged;datawindowchild ldc

dw_5.Reset()

CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", ldc)
		ldc.SetTransObject(SQLCA)
		ldc.Retrieve(data)
		ldc.InsertRow(0)
END CHOOSE



end event

type st_1 from statictext within w_57001_e
integer x = 759
integer y = 292
integer width = 974
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "내용은 2000자 까지 입력 가능합니다."
boolean focusrectangle = false
end type

type mle_title from multilineedit within w_57001_e
boolean visible = false
integer x = 2048
integer y = 76
integer width = 480
integer height = 68
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type mle_content from multilineedit within w_57001_e
boolean visible = false
integer x = 2080
integer y = 156
integer width = 480
integer height = 68
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type mle_url from multilineedit within w_57001_e
boolean visible = false
integer x = 2144
integer y = 212
integer width = 480
integer height = 68
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type mle_to_id from multilineedit within w_57001_e
boolean visible = false
integer x = 2181
integer y = 260
integer width = 480
integer height = 68
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_push from commandbutton within w_57001_e
boolean visible = false
integer x = 2217
integer y = 16
integer width = 402
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "PUSH"
end type

event clicked;string ls_title, ls_content, ls_url, ls_to_id

ls_title = mle_title.text
ls_content = mle_content.text
ls_url = mle_url.text
ls_to_id = mle_to_id.text

gf_push(ls_title, ls_content, ls_url, ls_to_id)


end event

