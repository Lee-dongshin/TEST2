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
type cb_excel1 from cb_excel within w_47009_d
end type
type cb_excel2 from cb_excel within w_47009_d
end type
type dw_2 from datawindow within w_47009_d
end type
type dw_3 from u_dw within w_47009_d
end type
end forward

global type w_47009_d from w_com010_d
cb_rt cb_rt
st_1 st_1
dw_1 dw_1
cb_excel1 cb_excel1
cb_excel2 cb_excel2
dw_2 dw_2
dw_3 dw_3
end type
global w_47009_d w_47009_d

type variables
String is_shop_cd, is_order_no, is_receiver_name, is_receiver_mobile, is_rt_accept, is_rt_proc, is_fr_ymd, is_to_ymd, is_saup_gubn, is_brand
long il_time_stamp
end variables

on w_47009_d.create
int iCurrent
call super::create
this.cb_rt=create cb_rt
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_excel1=create cb_excel1
this.cb_excel2=create cb_excel2
this.dw_2=create dw_2
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_rt
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_excel1
this.Control[iCurrent+5]=this.cb_excel2
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.dw_3
end on

on w_47009_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_rt)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_excel1)
destroy(this.cb_excel2)
destroy(this.dw_2)
destroy(this.dw_3)
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

//사용자 소속 사업장 확인
select CASE WHEN right(isnull(saup_gubn,'00'),1) = 'B' THEN '02'  WHEN right(isnull(saup_gubn,'00'),1) = '4' THEN '02' ELSE isnull(saup_gubn,'00') END
into :is_saup_gubn
from mis.dbo.thb01
where empno = :gs_user_id;



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

is_brand = dw_head.GetItemString(1, "saup_gubn")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"사업장을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("saup_gubn")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shoP_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
 
 	if RightA(is_saup_gubn,1) <> "2" then
			is_shop_cd = "[NJ]%"
	else 		
			is_shop_cd = "[ODA]%"		
	end if		
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
il_time_stamp = dw_head.GetItemNumber(1, "time_stamp")



return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//messagebox("", is_saup_gubn)
//messagebox("", is_shop_cd)

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_rt_accept, is_rt_proc, is_shop_cd, is_order_no, is_receiver_name, is_receiver_mobile, il_time_stamp, is_brand)
IF il_rows > 0 THEN
	dw_1.retrieve(is_fr_ymd, is_to_ymd, is_rt_accept, is_rt_proc, is_shop_cd, is_order_no, is_receiver_name, is_receiver_mobile, il_time_stamp, is_brand)
	dw_2.retrieve(is_fr_ymd, is_to_ymd, is_rt_accept, is_rt_proc, is_shop_cd, is_order_no, is_receiver_name, is_receiver_mobile, il_time_stamp, is_brand)	
	dw_body.Object.DataWindow.HorizontalScrollSplit  = 1919
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47009_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(cb_excel1, "FixedToRight")
inv_resize.of_Register(cb_excel2, "FixedToRight")

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div in ('E','D') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "cb_to_shop_cd"				

				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_3.SetItem(al_row, "to_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 

		   gst_cd.ai_div          = 1 //ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div not in ('E','D') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_3.SetRow(al_row)
				   dw_3.SetColumn(as_column)
				END IF 
				dw_3.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_3.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
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

event ue_button(integer ai_cb_div, long al_rows);CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_excel1.enabled = true			
         cb_excel2.enabled = true					
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         cb_excel1.enabled = false			
         cb_excel2.enabled = false					
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_excel1.enabled = false		
      cb_excel2.enabled = false			
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE
end event

event open;call super::open;
select isnull(saup_gubn,'00')
into :is_saup_gubn
from mis.dbo.thb01
where empno = :gs_user_id;


if MidA(is_saup_gubn ,2,1) = "2" or MidA(is_saup_gubn ,2,1) = "B" or MidA(is_saup_gubn ,2,1) = "4" then
 dw_head.Setitem(1, "saup_gubn",  "O")
else  
 dw_head.Setitem(1, "saup_gubn",  "N")
end if 
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
integer x = 951
end type

type cb_preview from w_com010_d`cb_preview within w_47009_d
integer x = 1294
end type

type gb_button from w_com010_d`gb_button within w_47009_d
end type

type cb_excel from w_com010_d`cb_excel within w_47009_d
integer x = 1637
integer width = 439
string text = "Excel_플토(&E)"
end type

type dw_head from w_com010_d`dw_head within w_47009_d
integer height = 300
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

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 


This.GetChild("time_stamp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()
end event

type ln_1 from w_com010_d`ln_1 within w_47009_d
integer beginy = 480
integer endy = 480
end type

type ln_2 from w_com010_d`ln_2 within w_47009_d
integer beginy = 484
integer endy = 484
end type

type dw_body from w_com010_d`dw_body within w_47009_d
integer y = 492
integer width = 3561
integer height = 1508
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


messagebox("", ls_yymmdd + '/' +  ls_ord_ymd + '/' +  ls_shop_cd + '/' +  ls_order_no + '/' +  ls_no)

CHOOSE CASE dwo.name
		
	CASE "mall_gubn"

				if ls_yymmdd < "20201112" then		
					select isnull(mall_gubn,"N")
					into :ls_chk
					from tb_45050_h with (nolock)
					where left(shop_cd,1) = left(:ls_shop_cd,1) 
					and yymmdd     = :ls_yymmdd
					and ord_ymd    = :ls_ord_ymd
					and order_no   = :ls_order_no 
					and no         = :ls_no
					and shop_cd    = :ls_shop_cd;
				else	
					select isnull(mall_gubn,"N")
					into :ls_chk
					from tb_45052_h with (nolock)
					where left(shop_cd,1) = left(:ls_shop_cd,1) 
					and yymmdd     = :ls_yymmdd
					and ord_ymd    = :ls_ord_ymd
					and order_no   = :ls_order_no 
					and no         = :ls_no
					and shop_cd    = :ls_shop_cd;
				end if
			
				if ls_chk = 'Y' then
					
					li_ret = MessageBox("확인!",  "수수료 계산 제외 처리된 내역입니다. 변경시 수수료에 다시 포함됩니다! 계속 하시겠습니까? " ,  Question!, YesNo!)
					if li_ret = 1 then 
					
						if is_brand = 'O' then
							
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
							
							 DECLARE SP_47009_UPDATE2 PROCEDURE FOR SP_47009_UPDATE2  
								@yymmdd   = :ls_yymmdd,   
								@ord_ymd  = :ls_ord_ymd,   
								@shop_cd  = :ls_shop_cd,
								@order_no = :ls_order_no,   			
								@no       = :ls_no,
								@flag	      = :data ;
				
							 EXECUTE SP_47009_UPDATE2 ;
				 
							 COMMIT; 
						end if	 
							
					else		 
						MessageBox("확인!",  "변경이 취소 되었습니다! " )						
					end if
					

				else			
			
					li_ret = MessageBox("확인!",  "수수료 계산에 포함된 내역입니다. 변경시 수수료에서 제외됩니다! 계속 하시겠습니까? " ,  Question!, YesNo!)
					if li_ret = 1 then 
						if is_brand = 'O' then
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
							
							 DECLARE SP_47009_UPDATE3 PROCEDURE FOR SP_47009_UPDATE2  
								@yymmdd   = :ls_yymmdd,   
								@ord_ymd  = :ls_ord_ymd,   
								@shop_cd  = :ls_shop_cd,
								@order_no = :ls_order_no,   			
								@no       = :ls_no,
								@flag	      = :data ;
				
							 EXECUTE SP_47009_UPDATE3 ;
				 
							 COMMIT; 
							
						end if	
					else		 
						MessageBox("확인!",  "변경이 취소 되었습니다! " )						
					end if
					 
				end if	 

END CHOOSE


end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_yymmdd, ls_ord_ymd, ls_shop_cd, ls_order_no, ls_no, ls_fr_shop_cd, ls_style, ls_chno, ls_color, ls_size, ls_order_name, ls_rt_accept
long ll_row



ls_yymmdd 		= this.getitemstring(row,"yymmdd")
ls_ord_ymd 		= this.getitemstring(row,"ord_ymd")
ls_shop_cd 		= this.getitemstring(row,"shop_cd")
ls_order_no 	= this.getitemstring(row,"order_no")
ls_no 			= this.getitemstring(row,"no")
ls_fr_shop_cd 	= this.getitemstring(row,"fr_shop_cd")
ls_style 		= this.getitemstring(row,"style_no")
ls_order_name 	= this.getitemstring(row,"receiver_name")
ls_rt_accept 	= this.getitemstring(row,"rt_accept")

//if ls_rt_accept <> "Y" then
	
	dw_3.visible = true
	dw_3.reset()
	ll_row = dw_3.InsertRow(0)
	
	dw_3.setitem(ll_row, "yymmdd", ls_yymmdd)
	dw_3.setitem(ll_row, "ord_ymd", ls_ord_ymd)
	dw_3.setitem(ll_row, "shop_cd", ls_shop_cd)
	dw_3.setitem(ll_row, "order_no", ls_order_no)
	dw_3.setitem(ll_row, "no", ls_no)
	dw_3.setitem(ll_row, "fr_shop_cd", ls_fr_shop_cd)
	dw_3.setitem(ll_row, "style_no", ls_style)
	dw_3.setitem(ll_row, "receiver_name", ls_order_name)
	
	dw_3.AcceptText()
//end if	
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
string ls_saup_gubn



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


//사용자 소속 사업장 확인
select  CASE WHEN right(isnull(saup_gubn,'00'),1) = 'B' THEN '02' WHEN right(isnull(saup_gubn,'00'),1) = '4' THEN '02' ELSE isnull(saup_gubn,'00') END
into :ls_saup_gubn
from mis.dbo.thb01
where empno = :gs_user_id;



Net = MessageBox("경고", "등록일자 기간동안 대상이 등록됩니다. 계속하시겠습니까?", Exclamation!, OKCancel!, 2)


if gs_user_id = "C20601"  or gs_user_id = "B90168" or gs_user_id = "C20105" or gs_user_id = "C20102"  or gs_user_id = "C30102" or gs_user_id = "991001" or gs_user_id = "C20910"  or gs_user_id = "C30602" then //오미숙 김미현 전경희,박성준(올리브), 이성준(올립)만 작업가능
	Net = Net
else
	Net = 0
end if	

IF Net = 1   THEN 
	
	st_1.visible = true
	
	if RightA(ls_saup_gubn,1) <> "2" then // 보끄레 사업장 사용자
	
	
		if is_to_ymd < "20201112" then
			DECLARE sP_54015_p03 PROCEDURE FOR SP_54015_P03  
				@fr_ymd = :is_fr_ymd,   
				@to_ymd = :is_to_ymd  ;
		
			 EXECUTE SP_54015_P03 ;
		else 	 
			DECLARE sP_54015_p05 PROCEDURE FOR SP_54015_P05  
				@fr_ymd = :is_fr_ymd,   
				@to_ymd = :is_to_ymd  ;
		
			 EXECUTE SP_54015_P05 ;
		end if	
	else
		
			DECLARE sP_54015_p04 PROCEDURE FOR SP_54015_P04  
         @fr_ymd = :is_fr_ymd,   
         @to_ymd = :is_to_ymd  ;

	
		 EXECUTE SP_54015_P04 ;
	
	end if	
	
	
		 
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

type cb_excel1 from cb_excel within w_47009_d
integer x = 2459
integer width = 384
string text = "Excel_화면(&E)"
end type

event clicked;string ls_doc_nm, ls_nm

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
li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_excel2 from cb_excel within w_47009_d
integer x = 2075
integer width = 389
integer taborder = 90
string text = "Excel_사방(&E)"
end type

event clicked;string ls_doc_nm, ls_nm

integer li_ret,li_ret2
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
li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)

li_ret2 = MessageBox("엑셀 실행 선택",  "해당 파일을 OPEN 하시겠습니까? ",  Question!, YesNo!)
	if li_ret2 = 1 then
		OleObject ole_excel
		ole_excel = Create OleObject
		
		ole_excel.connecttonewobject("excel.application")
		
		ole_excel.windowstate = 1
		ole_excel.Application.Visible = true
		ole_excel.workbooks.open(ls_doc_nm)
		
		ole_excel.DisConnectObject()
	
	end if	


end event

type dw_2 from datawindow within w_47009_d
boolean visible = false
integer x = 2798
integer y = 640
integer width = 480
integer height = 840
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_47009_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from u_dw within w_47009_d
boolean visible = false
integer x = 727
integer y = 648
integer width = 2382
integer height = 548
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "지시매장 변경"
string dataobject = "d_47009_d05"
boolean controlmenu = true
boolean vscrollbar = false
boolean livescroll = false
end type

event itemchanged;call super::itemchanged;int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name
	CASE "to_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then 
			return Trigger Event ue_Popup("cb_to_shop_cd", row, data, 1)
//			return Trigger Event ue_Popup("cb_to_shop_cd", row, data, 2)
		else 
			this.setitem(1, "shop_nm","")
		end if
			
END CHOOSE
end event

event buttonclicked;call super::buttonclicked;string ls_column_nm, ls_column_value
Long ll_row,i, ll_row_cnt, ll_row1
integer li_ret, li_shop_chk, li_proc_chk
string ls_yymmdd, ls_ord_ymd, ls_shop_cd, ls_order_no, ls_no, ls_fr_shop_cd, ls_style, ls_chno, ls_color, ls_size, ls_order_name, ls_to_shop_cd


dw_3.AcceptText()

ls_yymmdd 		= this.getitemstring(1,"yymmdd")
ls_ord_ymd 		= this.getitemstring(1,"ord_ymd")
ls_shop_cd 		= this.getitemstring(1,"shop_cd")
ls_order_no 	= this.getitemstring(1,"order_no")
ls_no 			= this.getitemstring(1,"no")
ls_fr_shop_cd 	= this.getitemstring(1,"fr_shop_cd")
ls_style 		= this.getitemstring(1,"style_no")
ls_order_name 	= this.getitemstring(1,"receiver_name")
ls_to_shop_cd  = this.getitemstring(1,"to_shop_cd")

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)
ls_column_value = This.GetItemString(row, ls_column_nm)

Choose Case ls_column_nm
		CASE "to_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		 return trigger Event ue_Popup(dwo.name, row, ls_column_nm, 2)
		 
		CASE "update"	     //  Popup 검색창이 존재하는 항목 		

			select count(*)
			into :li_shop_chk
			from tb_91100_m (nolock)
			where shop_cd = :ls_to_shop_cd;
			
			select count(*)
			into :li_proc_chk
			from tb_45052_h a
			where yymmdd = :ls_yymmdd
			and   ord_ymd = :ls_ord_ymd
			and shop_cd  = :ls_shop_cd
			and order_no = :ls_order_no
			and rt_accept <> "Y"	
			and no = :ls_no;
			
			if li_shop_chk >= 1  and  li_proc_chk  = 1 then
				
					li_ret = MessageBox("확인!",  "지시매장이 변경됩니다! 계속 하시겠습니까? " ,  Question!, YesNo!)
							if li_ret = 1  then 
										
										 update a set a.fr_shop_cd = :ls_to_shop_cd, a.rt_accept = 'N'
										 from tb_45052_h a
										 where yymmdd = :ls_yymmdd
										 and   ord_ymd = :ls_ord_ymd
										 and shop_cd  = :ls_shop_cd
										 and order_no = :ls_order_no
										 and rt_accept <> "Y"	
										 and no = :ls_no;
										 
									   commit  USING SQLCA;		
										MessageBox("알림!",  "변경이 되었습니다! " )	
										dw_3.reset()
										dw_3.visible = false
										trigger Event ue_retrieve()
		 
									
							else		 
								MessageBox("확인!",  "변경이 취소 되었습니다! " )						
							end if
					
			else 			 
				if li_shop_chk < 1 then
					MessageBox("오류!",  "변경대상 매장코드를 확인하세요! " )		
				end if	
				
				if li_proc_chk < 1 then
					MessageBox("오류!",  "매장 직택 처리중인 주문입니다. 다시 한번 확인 바랍니다! " )		
				end if					
			end if
			
		 
End Choose

end event

