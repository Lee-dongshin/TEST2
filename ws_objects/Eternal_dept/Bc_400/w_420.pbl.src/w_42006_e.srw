$PBExportHeader$w_42006_e.srw
$PBExportComments$DPS FILE 생성
forward
global type w_42006_e from w_com010_e
end type
type dw_1 from datawindow within w_42006_e
end type
type dw_2 from datawindow within w_42006_e
end type
type dw_99 from datawindow within w_42006_e
end type
end forward

global type w_42006_e from w_com010_e
integer width = 3675
integer height = 2220
dw_1 dw_1
dw_2 dw_2
dw_99 dw_99
end type
global w_42006_e w_42006_e

type variables
DataWindowchild idw_brand, idw_deal_fg
string is_brand, is_deal_fg, is_yymmdd
integer ii_work_no
end variables

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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

is_yymmdd = dw_head.GetItemString(1, "out_ymd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_deal_fg = dw_head.GetItemString(1, "deal_fg")
if IsNull(is_deal_fg) or Trim(is_deal_fg) = "" then
   MessageBox(ls_title,"배분구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_fg")
   return false
end if

ii_work_no = dw_head.GetItemNumber(1, "work_no")
if IsNull(ii_work_no) or ii_work_no <= 0  then
   MessageBox(ls_title,"작업번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("work_no")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_deal_fg, ii_work_no, is_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")

dw_2.SetTransObject(SQLCA)
dw_99.SetTransObject(SQLCA)
end event

on w_42006_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_99=create dw_99
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_99
end on

on w_42006_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_99)
end on

event ue_print();/*===========================================================================*/
/* 작성일      : 2002.04.25                                                  */	
/* 거래명세서 인쇄                                                           */
/*===========================================================================*/

Long i, ll_row 
String ls_shop_cd, ls_out_ymd, ls_out_no

ll_row = dw_99.Retrieve(is_brand, is_yymmdd, is_deal_fg, ii_work_no) 

FOR i = 1 TO ll_row 
	ls_shop_cd = dw_99.GetitemString(i, "shop_cd") 
	ls_out_ymd = dw_99.GetitemString(i, "yymmdd") 
	ls_out_no  = dw_99.GetitemString(i, "out_no") 
	dw_print.Retrieve(is_brand, ls_out_ymd, ls_shop_cd, '1', ls_out_no, '1')
   IF dw_print.RowCount() > 0 Then
      il_rows = dw_print.Print()
   END IF
NEXT 

This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42006_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42006_e
end type

type cb_delete from w_com010_e`cb_delete within w_42006_e
end type

type cb_insert from w_com010_e`cb_insert within w_42006_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42006_e
end type

type cb_update from w_com010_e`cb_update within w_42006_e
end type

type cb_print from w_com010_e`cb_print within w_42006_e
integer width = 576
string text = "거래명세서 인쇄(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_42006_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_42006_e
end type

type cb_excel from w_com010_e`cb_excel within w_42006_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_42006_e
integer width = 2021
string dataobject = "d_42006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("deal_fg", idw_deal_fg )
idw_deal_fg.SetTransObject(SQLCA)
idw_deal_fg.Retrieve('521')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_e`ln_1 within w_42006_e
end type

type ln_2 from w_com010_e`ln_2 within w_42006_e
end type

type dw_body from w_com010_e`dw_body within w_42006_e
integer y = 464
integer width = 3584
integer height = 1520
string dataobject = "d_42006_d02"
end type

type dw_print from w_com010_e`dw_print within w_42006_e
integer x = 1198
integer y = 964
string dataobject = "d_com420"
end type

type dw_1 from datawindow within w_42006_e
integer x = 2277
integer y = 196
integer width = 1298
integer height = 212
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_42006_d03"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;string ls_yymmdd, ls_out_no, ls_shop_cd, ls_dps_yn,ls_ErrMsg
Integer li_deal_seq, li_work_no, li_rtrn, li_int
long    ll_row, II, JJ, KK, ll_ok

CHOOSE CASE dwo.name
//exec sp_42006_d01  'n', '20020204', '1', 1, 'a'		

	CASE "cb_das"	
	parent.Trigger Event ue_keycheck('1') 

   select count(*)
	into :li_int
	from beaucre.dbo.tb_52031_WORK with (nolock)
	WHERE YYMMDD  = :is_yymmdd
	and   deal_fg = :is_deal_fg
	and   work_no = :ii_work_no
	and   BRAND   = :is_brand
	and   trx_chk <> '0'  ;
 
 
   if li_int <> 0  then				
		
		  DECLARE SP_42006_proc1 PROCEDURE FOR SP_42006_proc  
           @yymmdd  = :is_yymmdd,		  
           @brand   = :is_brand,   
           @deal_fg = :is_deal_fg,   
           @work_no = :ii_work_no;
			  
		  EXECUTE SP_42006_proc1;
		  
		IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
			commit  USING SQLCA;
			ll_row = 1
		ELSE
			ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
			rollback  USING SQLCA;
			ll_row = -1
			MessageBox("저장 실패[SP]", ls_ErrMsg)
		END IF
				
		IF ll_row > 0 THEN
			dw_body.SetFocus()		
			messagebox("알림!", "데이터가 생성되었습니다!")
		else
			messagebox("알림!", "데이터 생성이 실패했습니다!")
		end if	
		
	else	
	   li_rtrn = messagebox("경고!", "이미 처리된 작업입니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )	
		
	   if li_rtrn = 1 then
   			
				delete
				from beaucre.dbo.tb_52031_WORK
				WHERE YYMMDD  = :is_yymmdd
				and   deal_fg = :is_deal_fg
				and   work_no = :ii_work_no
				and   BRAND   = :is_brand
				and   trx_chk = '0'  ;
 
			 
			  DECLARE SP_42006_proc2 PROCEDURE FOR SP_42006_proc  
				  @yymmdd  = :is_yymmdd,		  
				  @brand   = :is_brand,   
				  @deal_fg = :is_deal_fg,   
				  @work_no = :ii_work_no;
				  
			  EXECUTE SP_42006_proc2;
			  
			IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
				commit  USING SQLCA;
				ll_row = 1
			ELSE
				ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
				rollback  USING SQLCA;
				ll_row = -1
				MessageBox("저장 실패[SP]", ls_ErrMsg)
			END IF
					
			IF ll_row > 0 THEN
				dw_body.SetFocus()		
				messagebox("알림!", "데이터가 생성되었습니다!")
			else
				messagebox("알림!", "데이터 생성이 실패했습니다!")
			end if	
		else		
        messagebox("경고!", "작업이 취소되었습니다!")
   	end if 
	end if	


	CASE "cb_proc"	
	parent.Trigger Event ue_keycheck('1') 

   dw_2.reset()
	
   select distinct isnull(dps_yn, 'N')
	into :ls_dps_yn
	from tb_52031_h with (nolock)
	WHERE out_ymd = :is_yymmdd
	and   deal_fg = :is_deal_fg
	and   work_no = :ii_work_no
	and   style   like :is_brand + '%' ;
 
 
   if ls_dps_yn = "Y" then
		ll_row = dw_2.retrieve(is_brand,is_yymmdd, is_deal_fg, ii_work_no,  "A")
		
		IF ll_row > 0 THEN
			dw_body.SetFocus()
			dw_2.SaveAs("C:\term\assort\Hss713cj", text!, FALSE)			
			
			messagebox("알림!", "화일이 생성되었습니다!")
		else
			messagebox("알림!", "생성된 화일이 없습니다!")
		end if	
	else	
	   li_rtrn = messagebox("경고!", "이미 처리된 작업입니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )	
	   if li_rtrn = 1 then
        ll_row = dw_2.retrieve(is_brand,is_yymmdd, is_deal_fg, ii_work_no,  "A")
				IF ll_row > 0 THEN
					dw_body.SetFocus()
					dw_2.SaveAs("C:\term\assort\Hss713cj", text!, FALSE)			
					
					messagebox("알림!", "화일이 생성되었습니다!")
				else
					messagebox("알림!", "생성된 화일이 없습니다!")
				end if	
		else		
        messagebox("경고!", "작업이 취소되었습니다!")
   	end if 
	end if	

	CASE "cb_tot"	
 dw_2.reset()
	parent.Trigger Event ue_keycheck('1') 
	ll_row = dw_2.retrieve(is_brand,is_yymmdd, is_deal_fg, ii_work_no, "b")
	IF ll_row > 0 THEN
		dw_body.SetFocus()
		dw_2.SaveAs("C:\term\assort\Hss713cj", text!, FALSE)			
		messagebox("알림!", "화일이 생성되었습니다!")
	else
		messagebox("알림!", "생성된 화일이 없습니다!")
	end if

		
END CHOOSE
	
	

	

end event

event constructor;dw_1.insertrow(0)
end event

type dw_2 from datawindow within w_42006_e
boolean visible = false
integer x = 398
integer y = 712
integer width = 3040
integer height = 484
integer taborder = 40
string title = "none"
string dataobject = "d_42006_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_99 from datawindow within w_42006_e
boolean visible = false
integer x = 2171
integer y = 396
integer width = 411
integer height = 432
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_42006_d99"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

