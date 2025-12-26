$PBExportHeader$w_sh303_e.srw
$PBExportComments$메시지관리[수신메시지관리]
forward
global type w_sh303_e from w_com020_e
end type
type dw_1 from datawindow within w_sh303_e
end type
end forward

global type w_sh303_e from w_com020_e
integer width = 2958
integer height = 2056
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
dw_1 dw_1
end type
global w_sh303_e w_sh303_e

type variables
String is_confirm_yn, is_level_yn, is_jumn_no, is_yymmdd,is_confirm_yn1
String is_send_id, is_recv_id = "000000", is_send_gubn
integer ii_mes_seq
end variables

on w_sh303_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_sh303_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
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

//if mid(gs_shop_cd,3,4) = '2000' then
//	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
//	return false
//end if	

is_confirm_yn = dw_head.GetItemString(1, "confirm_yn")
IF is_confirm_yn = "" OR isnull(is_confirm_yn) THEN
	is_confirm_yn = ""
END IF


is_send_gubn = dw_head.GetItemString(1, "send_gubn")
IF is_send_gubn = "" OR isnull(is_send_gubn) THEN
	is_confirm_yn = "N"
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

//datetime ld_datetime
//string ls_modify, ls_datetime
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//             "t_user_id.Text = '" + gs_user_id + "'" + &
//             "t_datetime.Text = '" + ls_datetime + "'"
//
//dw_print.Modify(ls_modify)
//

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
string ls_shop_cd
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd,3,4) = "2000" then
	ls_shop_cd = '__2000'
else
	ls_shop_cd = gs_shop_cd
end if	

il_rows = dw_list.retrieve(ls_shop_cd, is_confirm_yn, is_send_gubn)

dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

//This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
dw_body.InsertRow(0)
dw_1.SetTransObject(SQLCA)
//dw_1.InsertRow(0)
end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

type cb_close from w_com020_e`cb_close within w_sh303_e
integer taborder = 160
end type

type cb_delete from w_com020_e`cb_delete within w_sh303_e
boolean visible = false
integer x = 2135
integer y = 48
integer taborder = 110
end type

type cb_insert from w_com020_e`cb_insert within w_sh303_e
boolean visible = false
integer x = 1792
integer y = 48
integer taborder = 100
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_sh303_e
integer x = 2167
integer taborder = 60
end type

type cb_update from w_com020_e`cb_update within w_sh303_e
boolean visible = false
integer taborder = 150
end type

type cb_print from w_com020_e`cb_print within w_sh303_e
boolean visible = false
integer taborder = 120
end type

type cb_preview from w_com020_e`cb_preview within w_sh303_e
boolean visible = false
integer taborder = 130
end type

type gb_button from w_com020_e`gb_button within w_sh303_e
end type

type dw_head from w_com020_e`dw_head within w_sh303_e
integer width = 2784
integer height = 160
integer taborder = 50
string dataobject = "d_sh303_h01"
end type

event dw_head::constructor;DataWindowChild ldw_child 

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
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

type ln_1 from w_com020_e`ln_1 within w_sh303_e
integer beginy = 332
integer endx = 2926
integer endy = 332
end type

type ln_2 from w_com020_e`ln_2 within w_sh303_e
integer beginy = 336
integer endx = 2921
integer endy = 336
end type

type dw_list from w_com020_e`dw_list within w_sh303_e
integer y = 344
integer width = 823
integer height = 1472
integer taborder = 70
string title = "매장"
string dataobject = "d_sh303_d01"
boolean hscrollbar = true
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
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/
String ls_confirm_yn, ls_yymmdd, ls_level_opt
datetime ld_datetime

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF row > 0 THEN
  is_yymmdd = ""
  is_confirm_yn1 = ""
	
   ls_yymmdd      = this.GetItemString(row,'yymmdd')
   is_send_id     = this.GetItemString(row,'send_id')
   ii_mes_seq     = this.GetItemNumber(row,'mes_seq')
   ls_confirm_yn 	= this.GetItemString(row,'confirm_yn')
   ls_level_opt	= this.GetItemString(row,'level_opt')
	if ls_level_opt = "A"  or ls_confirm_yn = 'Y' then
	   dw_body.Retrieve(ls_yymmdd, is_send_id, ii_mes_seq)
	end if	
   this.selectRow(0, false)
   this.setRow(row)
   this.selectRow(row, true)
	
if	ls_level_opt = "A" then
	
   IF isnull(ls_confirm_yn) OR ls_confirm_yn = 'N' THEN
      UPDATE TB_57011_H
   	   SET confirm_yn = 'Y', 
			    confirm_dt = :ld_datetime, 
				 mod_dt     = :ld_datetime, 
				 mod_id     = :gs_shop_cd 
	    WHERE yymmdd		= :ls_yymmdd
	      AND send_id	   = :is_send_id
	      AND mes_seq	   = :ii_mes_seq
	      AND recv_id	   = :gs_shop_cd;
	   Commit USING SQLCA;
	   dw_list.SetItem(row,'confirm_yn','Y')
	   dw_list.SetItem(row,'confirm_dt',ld_datetime)
   END IF
else	
	 IF isnull(ls_confirm_yn) OR ls_confirm_yn = 'N' THEN		
		  dw_1.reset()
		  dw_1.InsertRow(0)
		  dw_1.visible = true 	
		  is_yymmdd = ls_yymmdd
		  is_confirm_yn1 = ls_confirm_yn 
     END IF
  
end if	
	
END IF


end event

type dw_body from w_com020_e`dw_body within w_sh303_e
integer x = 837
integer y = 344
integer width = 2057
integer height = 1468
integer taborder = 80
string title = "메시지 내용"
string dataobject = "d_sh303_d02"
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

type st_1 from w_com020_e`st_1 within w_sh303_e
integer x = 818
integer y = 344
integer height = 1500
end type

type dw_print from w_com020_e`dw_print within w_sh303_e
end type

type dw_1 from datawindow within w_sh303_e
boolean visible = false
integer x = 635
integer y = 476
integer width = 1390
integer height = 584
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "주민번호확인"
string dataobject = "d_sh303_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;string ls_jumin_no, ls_kname, ls_chk_yn
int li_chk_cnt
datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

this.AcceptText()


ls_jumin_no = this.getitemstring(row, "jumin_no")

CHOOSE CASE dwo.name


	CASE "cb_confirm"	     //  Popup 검색창이 존재하는 항목 
		select kname, count(*)
		into :ls_kname, :li_chk_cnt
		from vi_93010_4
		where jumn_no = :ls_jumin_no
		and   shop_cd = :gs_shop_cd
		group by kname;
		
		if li_chk_cnt > 0 then 
		is_level_yn = "Y"
		is_jumn_no  = ls_jumin_no
		messagebox("알림!", ls_kname + "님 확인이 완료되었습니다!")
		
	 IF isnull(is_confirm_yn1) OR is_confirm_yn1 = 'N' and is_level_yn = 'Y' THEN
      UPDATE TB_57011_H
   	   SET confirm_yn = :is_level_yn, 
			    confirm_dt = :ld_datetime, 
				 mod_dt     = :ld_datetime, 
				 mod_id     = :gs_shop_cd ,
				 level_yn   = :is_level_yn,
				 jumn_no    = :is_jumn_no
	    WHERE yymmdd		= :is_yymmdd
	      AND send_id	   = :is_send_id
	      AND mes_seq	   = :ii_mes_seq
	      AND recv_id	   = :gs_shop_cd;
	   Commit USING SQLCA;

   END IF	
		
		
		this.visible = false
	   dw_body.Retrieve(is_yymmdd, is_send_id, ii_mes_seq)
		else	
		is_level_yn = "N"
		is_jumn_no  = ""
		messagebox("알림!", "주민번호 오류 또는 메니저가 아니므로 미확인 되었습니다!")		
		end if	
		
	
		

	CASE "cb_cancel"	     //  Popup 검색창이 존재하는 항목 
		is_level_yn = "N"
		is_jumn_no  = ""
		messagebox("알림!", "취소 되었습니다!")		
		this.visible = false	
		
	
END CHOOSE



end event

