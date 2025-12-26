$PBExportHeader$w_47009_d.srw
$PBExportComments$직용몰RT요청처리 조회
forward
global type w_47009_d from w_com010_d
end type
type cb_rt from commandbutton within w_47009_d
end type
type st_1 from statictext within w_47009_d
end type
type dw_1 from u_dw within w_47009_d
end type
end forward

global type w_47009_d from w_com010_d
integer width = 3675
cb_rt cb_rt
st_1 st_1
dw_1 dw_1
end type
global w_47009_d w_47009_d

type variables
String is_shop_cd, is_order_no, is_receiver_name, is_receiver_mobile, is_rt_accept, is_rt_proc, is_fr_ymd, is_to_ymd
end variables

on w_47009_d.create
int iCurrent
call super::create
this.cb_rt=create cb_rt
this.st_1=create st_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_rt
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_1
end on

on w_47009_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_rt)
destroy(this.st_1)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shoP_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
 is_shop_cd = "%"
end if

is_order_no = dw_head.GetItemString(1, "order_no")
if IsNull(is_order_no) or Trim(is_order_no) = "" then
 is_order_no = "%"
end if

is_receiver_name = dw_head.GetItemString(1, "receiver_name")
if IsNull(is_receiver_name) or Trim(is_receiver_name) = "" then
 is_receiver_name = "%"
end if

is_receiver_mobile = dw_head.GetItemString(1, "receiver_mobile")
if IsNull(is_receiver_mobile) or Trim(is_receiver_mobile) = "" then
 is_receiver_mobile = "%"
end if


is_rt_accept = dw_head.GetItemString(1, "rt_accept")
is_rt_proc = dw_head.GetItemString(1, "rt_proc")

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_rt_accept, is_rt_proc, is_shop_cd, is_order_no, is_receiver_name, is_receiver_mobile)
IF il_rows > 0 THEN
	dw_1.retrieve(is_fr_ymd, is_to_ymd, is_rt_accept, is_rt_proc, is_shop_cd, is_order_no, is_receiver_name, is_receiver_mobile)
	dw_body.Object.DataWindow.HorizontalScrollSplit  = 1919
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47009_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")

dw_1.SetTransObject(SQLCA)
end event

event ue_excel();string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_47009_d
end type

type cb_delete from w_com010_d`cb_delete within w_47009_d
end type

type cb_insert from w_com010_d`cb_insert within w_47009_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_47009_d
end type

type cb_update from w_com010_d`cb_update within w_47009_d
end type

type cb_print from w_com010_d`cb_print within w_47009_d
end type

type cb_preview from w_com010_d`cb_preview within w_47009_d
end type

type gb_button from w_com010_d`gb_button within w_47009_d
end type

type cb_excel from w_com010_d`cb_excel within w_47009_d
end type

type dw_head from w_com010_d`dw_head within w_47009_d
string dataobject = "d_47009_h01"
end type

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then 
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		else 
			dw_head.setitem(1, "shop_nm","")
		end if
			
END CHOOSE
//
end event

type ln_1 from w_com010_d`ln_1 within w_47009_d
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_d`ln_2 within w_47009_d
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_d`dw_body within w_47009_d
integer x = 14
integer y = 432
integer width = 3579
integer height = 1568
string dataobject = "d_47009_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;String ls_brand, ls_yymmdd, ls_rt_no, ls_no, ls_fg, ls_ord_ymd, ls_shop_cd, ls_order_no, ls_rt_proc, ls_chk, ls_fr_shop_cd,ls_proc_chk, ls_chk_time
integer li_ret

ls_yymmdd   = This.GetitemString(row, "yymmdd")
ls_ord_ymd  = This.GetitemString(row, "ord_ymd")
ls_shop_cd  = This.GetitemString(row, "shop_cd")
ls_order_no = This.GetitemString(row, "order_no")
ls_no       = This.GetitemString(row, "no")

CHOOSE CASE dwo.name
		
	CASE "mall_gubn"

			
				select isnull(mall_gubn,"N")
				into :ls_chk
				from tb_45050_h with (nolock)
				where left(shop_cd,1) = left(:ls_shop_cd,1) 
				and yymmdd     = :ls_yymmdd
				and ord_ymd    = :ls_ord_ymd
				and order_no   = :ls_order_no 
				and no         = :ls_no
				and shop_cd    = :ls_shop_cd;
			
				if ls_chk = 'Y' then
					
					li_ret = MessageBox("확인!",  "수수료 계산 제외 처리된 내역입니다. 변경시 수수료에 다시 포함됩니다! 계속 하시겠습니까? " ,  Question!, YesNo!)
					if li_ret = 1 then 
					
							 DECLARE SP_47009_UPDATE PROCEDURE FOR SP_47009_UPDATE  
								@yymmdd   = :ls_yymmdd,   
								@ord_ymd  = :ls_ord_ymd,   
								@shop_cd  = :ls_shop_cd,
								@order_no = :ls_order_no,   			
								@no       = :ls_no,
								@flag	      = :data ;
				
							 EXECUTE SP_47009_UPDATE ;
				 
							 COMMIT; 
					else		 
						MessageBox("확인!",  "변경이 취소 되었습니다! " )						
					end if
					

				else			
			
					li_ret = MessageBox("확인!",  "수수료 계산에 포함된 내역입니다. 변경시 수수료에서 제외됩니다! 계속 하시겠습니까? " ,  Question!, YesNo!)
					if li_ret = 1 then 
					
							 DECLARE SP_47009_UPDATE1 PROCEDURE FOR SP_47009_UPDATE  
								@yymmdd   = :ls_yymmdd,   
								@ord_ymd  = :ls_ord_ymd,   
								@shop_cd  = :ls_shop_cd,
								@order_no = :ls_order_no,   			
								@no       = :ls_no,
								@flag	    = :data ;
				
							 EXECUTE SP_47009_UPDATE1 ;
				 
							 COMMIT; 
					else		 
						MessageBox("확인!",  "변경이 취소 되었습니다! " )						
					end if
					 
				end if	 

END CHOOSE


end event

type dw_print from w_com010_d`dw_print within w_47009_d
end type

type cb_rt from commandbutton within w_47009_d
integer x = 23
integer y = 44
integer width = 439
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "매장RT의뢰"
end type

event clicked;integer Net

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox("알림!","등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox("알림!","등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
end if


Net = MessageBox("경고", "등록일자 기간동안 미출고RT 입력 대상이 등록됩니다. 계속하시겠습니까?", Exclamation!, OKCancel!, 2)

IF Net = 1 THEN 
	
	st_1.visible = true
	
		DECLARE sP_54015_p03 PROCEDURE FOR SP_54015_P03  
         @fr_ymd = :is_fr_ymd,   
         @to_ymd = :is_to_ymd  ;

	
		 EXECUTE SP_54015_P03 ;
		 
		IF SQLCA.SQLCODE = -1 THEN 
			rollback  USING SQLCA;				
			MessageBox("SQL오류", SQLCA.SqlErrText) 
			st_1.visible = false			
			Return -1 			
		ELSE
 		  MessageBox("알림", "작업이 완료되었습니다!")
			commit  USING SQLCA;
			st_1.visible = false			
		END IF 		
	

ELSE

  MessageBox("알림", "작업이 취소되었습니다!")

END IF
end event

type st_1 from statictext within w_47009_d
boolean visible = false
integer x = 480
integer y = 68
integer width = 814
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
string text = "<-- 작업이 처리 중입니다!"
boolean focusrectangle = false
end type

type dw_1 from u_dw within w_47009_d
boolean visible = false
integer x = 5
integer y = 2020
integer width = 3561
integer height = 1568
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_47009_d03"
boolean hscrollbar = true
end type

