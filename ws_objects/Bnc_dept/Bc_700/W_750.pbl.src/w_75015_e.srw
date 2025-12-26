$PBExportHeader$w_75015_e.srw
$PBExportComments$메일조회
forward
global type w_75015_e from w_com010_e
end type
type dw_frequency from u_dw within w_75015_e
end type
type dw_monetary from u_dw within w_75015_e
end type
type dw_m from datawindow within w_75015_e
end type
type cb_refresh from commandbutton within w_75015_e
end type
type st_1 from statictext within w_75015_e
end type
type st_2 from statictext within w_75015_e
end type
end forward

global type w_75015_e from w_com010_e
integer height = 2232
event type integer ue_save ( string as_rfm )
dw_frequency dw_frequency
dw_monetary dw_monetary
dw_m dw_m
cb_refresh cb_refresh
st_1 st_1
st_2 st_2
end type
global w_75015_e w_75015_e

type variables
string is_RFM
end variables

on w_75015_e.create
int iCurrent
call super::create
this.dw_frequency=create dw_frequency
this.dw_monetary=create dw_monetary
this.dw_m=create dw_m
this.cb_refresh=create cb_refresh
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_frequency
this.Control[iCurrent+2]=this.dw_monetary
this.Control[iCurrent+3]=this.dw_m
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
end on

on w_75015_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_frequency)
destroy(this.dw_monetary)
destroy(this.dw_m)
destroy(this.cb_refresh)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_insert();//
end event

event ue_delete();//
end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
			dw_frequency.Enabled = true
			dw_monetary.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
				dw_frequency.Enabled = true
				dw_monetary.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false

		dw_frequency.Enabled = false
		dw_monetary.Enabled = false
			
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75007_d","0")
end event

type cb_close from w_com010_e`cb_close within w_75015_e
integer taborder = 150
end type

type cb_delete from w_com010_e`cb_delete within w_75015_e
boolean visible = false
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_75015_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_75015_e
end type

type cb_update from w_com010_e`cb_update within w_75015_e
integer taborder = 140
end type

type cb_print from w_com010_e`cb_print within w_75015_e
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_75015_e
boolean visible = false
integer taborder = 120
end type

type gb_button from w_com010_e`gb_button within w_75015_e
end type

type cb_excel from w_com010_e`cb_excel within w_75015_e
boolean visible = false
integer taborder = 130
end type

type dw_head from w_com010_e`dw_head within w_75015_e
boolean visible = false
integer height = 36
end type

type ln_1 from w_com010_e`ln_1 within w_75015_e
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_e`ln_2 within w_75015_e
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_e`dw_body within w_75015_e
integer x = 14
integer y = 184
integer width = 1774
integer height = 920
end type

type dw_print from w_com010_e`dw_print within w_75015_e
end type

type dw_frequency from u_dw within w_75015_e
integer x = 14
integer y = 1116
integer width = 1774
integer height = 920
integer taborder = 50
boolean bringtotop = true
end type

event itemchanged;call super::itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type dw_monetary from u_dw within w_75015_e
integer x = 1792
integer y = 184
integer width = 1815
integer height = 1852
integer taborder = 60
boolean bringtotop = true
end type

event itemchanged;call super::itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type dw_m from datawindow within w_75015_e
integer x = 2981
integer y = 280
integer width = 585
integer height = 648
integer taborder = 50
boolean bringtotop = true
string title = "none"
boolean border = false
boolean livescroll = true
end type

type cb_refresh from commandbutton within w_75015_e
integer x = 1874
integer y = 1552
integer width = 503
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "고객별 RFM 갱신"
end type

event clicked;integer Net

net = messagebox("확인", "RFM 갱신을 하시겠습니까?",Exclamation!, OKCancel!, 2)
if net = 1 then	
		IF parent.Trigger Event ue_keycheck('1') = FALSE THEN RETURN
		
		DECLARE sp_Refresh_RFM PROCEDURE FOR sp_Refresh_RFM; 
		execute sp_Refresh_RFM;	
	
		if sqlca.sqlcode > 0 then
				commit    USING SQLCA;
				
				DECLARE sp_Apply_RFM PROCEDURE FOR sp_Apply_RFM; 
				execute sp_Apply_RFM;	
			
				if sqlca.sqlcode > 0 then
						commit    USING SQLCA;
					
						messagebox("확인", "RFM 갱신 완료")
				else
						rollback  USING SQLCA;
						messagebox("확인", "RFM 갱신중 에러가 발생했습니다..")
				end if
		else
				rollback  USING SQLCA;
				messagebox("확인", "RFM 갱신중 에러가 발생했습니다..")
		end if
end if



end event

type st_1 from statictext within w_75015_e
integer x = 1888
integer y = 1684
integer width = 1687
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 80269524
string text = "※각 고객별로 Recency(구매주기), Frequency(구매횟수),"
boolean focusrectangle = false
end type

type st_2 from statictext within w_75015_e
integer x = 1947
integer y = 1760
integer width = 1029
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 80269524
string text = "Monetary((구매금액) 을 다시 산정한다."
boolean focusrectangle = false
end type

