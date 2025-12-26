$PBExportHeader$w_32019_e.srw
$PBExportComments$사전원가계산서확인(TasseTasse)
forward
global type w_32019_e from w_com010_e
end type
type dw_mast2 from u_dw within w_32019_e
end type
type dw_1 from datawindow within w_32019_e
end type
end forward

global type w_32019_e from w_com010_e
integer width = 3621
integer height = 2252
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
dw_mast2 dw_mast2
dw_1 dw_1
end type
global w_32019_e w_32019_e

type variables
String is_style_no, is_yymmdd
Decimal idc_ord_qty, idc_in_qty
datetime id_datetime

datawindowchild idw_bae_su

end variables

forward prototypes
public function integer wf_12022_set ()
public function integer wf_style_info (string as_style_no, long al_row, string as_div)
public function integer wf_12020_set ()
end prototypes

public function integer wf_12022_set ();Decimal ldc_tag_price
String  ls_datetime

ldc_tag_price  = dw_body.GetItemDecimal(1, "tag_price")
ls_datetime = String(id_datetime, 'yyyymmdd')

INSERT 
  INTO TB_12022_H 
		 ( STYLE, END_YMD, START_YMD, PRICE, REG_ID, REG_DT )
VALUES ( LEFT(:is_style_no, 8), '99999999', :ls_datetime,
			:ldc_tag_price, :gs_user_id, :id_datetime ) ;
			
IF SQLCA.SQLCODE = -1 Then 
	UPDATE TB_12022_H
		SET PRICE = :ldc_tag_price,
			 MOD_ID    = :gs_user_id,
			 MOD_DT    = :id_datetime
	 WHERE STYLE = LEFT(:is_style_no, 8) 
		AND END_YMD = '99999999' ;
End If
	
Return SQLCA.SQLCODE

end function

public function integer wf_style_info (string as_style_no, long al_row, string as_div);String  ls_cust_cd, ls_cust_nm, ls_out_seq,ls_out_seq_nm, ls_ord_ymd, ls_dlvy_ymd

If as_div = '1' Then
	  SELECT ISNULL(CUST_CD, ' '), ISNULL(dbo.sf_cust_nm(CUST_CD, 'S'), ' '),
				ISNULL(OUT_SEQ,' '), ISNULL(dbo.sf_inter_nm('010',OUT_SEQ),' '), ORD_YMD,
				DLVY_YMD
	    INTO :ls_cust_cd, :ls_cust_nm, :ls_out_seq, :ls_out_seq_nm, :ls_ord_ymd,
		      :ls_dlvy_ymd
   	 FROM VI_12020_1
		WHERE STYLE = LEFT(:as_style_no, 8)
		  AND CHNO  = SUBSTRING(:as_style_no, 9, 1) ;

	If SQLCA.SQLCODE <> 0 Then Return SQLCA.SQLCODE

	
	dw_head.SetItem(al_row, "cust_cd", ls_cust_cd)
	dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
	dw_head.SetItem(al_row, "out_seq", ls_out_seq)
	dw_head.SetItem(al_row, "out_seq_nm", ls_out_seq_nm)
	dw_head.SetItem(al_row, "ord_ymd", ls_ord_ymd)
	dw_head.SetItem(al_row, "dlvy_ymd", ls_dlvy_ymd)
End If

  SELECT ISNULL(SUM(ORD_QTY), 0), ISNULL(SUM(IN_QTY), 0)
	 INTO :idc_ord_qty, :idc_in_qty
	 FROM TB_12030_S
	WHERE STYLE = LEFT(:as_style_no, 8)
	  AND CHNO  = SUBSTRING(:as_style_no, 9, 1) ;

If SQLCA.SQLCODE <> 0 Then Return SQLCA.SQLCODE

dw_head.SetItem(al_row, "ord_qty", idc_ord_qty)
dw_head.SetItem(al_row, "in_qty",  idc_in_qty)

Return 0

end function

public function integer wf_12020_set ();Decimal ldc_busi_price, ldc_md_price, ldc_tag_price, ldc_expense, ldc_margin, ldc_imsi_price

ldc_busi_price = dw_body.GetItemDecimal(1, "tag_price")
ldc_md_price   = dw_body.GetItemDecimal(1, "md_price")
ldc_tag_price  = dw_body.GetItemDecimal(1, "tag_price")
ldc_expense  = dw_body.GetItemDecimal(1, "expense")
ldc_margin   = dw_body.GetItemDecimal(1, "margin")
ldc_imsi_price   = dw_body.GetItemDecimal(1, "imsi_price")


  UPDATE TB_12020_M
     SET BUSI_PRICE = :ldc_busi_price,
	  		MD_PRICE   = :ldc_md_price,
			TAG_PRICE  = :ldc_tag_price,
	      EXPENSE    = :ldc_expense,
			MARGIN     = :ldc_margin,			
			MOD_ID     = :gs_user_id,
			MOD_DT     = :id_datetime			
						
	WHERE STYLE = LEFT(:is_style_no, 8) ;



  UPDATE tasse.dbo.TB_12020_M
     SET MD_PRICE   = :ldc_imsi_price						
	WHERE STYLE = LEFT(:is_style_no, 8) ;
	
Return SQLCA.SQLCODE




end function

on w_32019_e.create
int iCurrent
call super::create
this.dw_mast2=create dw_mast2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast2
this.Control[iCurrent+2]=this.dw_1
end on

on w_32019_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast2)
destroy(this.dw_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/
string ls_style_no
Long ll_rows2, ll_find2
Decimal ldc_mmat_price1, ldc_smat_price1, ldc_mmat_price2, ldc_smat_price2

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


 
ll_rows2 = dw_mast2.retrieve(is_style_no,'0')

ldc_mmat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "mmat_price")
ldc_smat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "smat_price")		
il_rows  = dw_body.retrieve(is_style_no, ldc_mmat_price2, ldc_smat_price2)

dw_body.SetItemStatus(1, "mmat_price", Primary!, DataModified!)
dw_body.SetItemStatus(1, "smat_price", Primary!, DataModified!)
dw_body.SetItemStatus(1, "napum_price", Primary!, DataModified!)

IF il_rows > 0 THEN
	idw_bae_su.settransobject(sqlca)
	idw_bae_su.retrieve('T') //타스타스 전용
	dw_body.setitem(1,"season_bae_su",MidA(is_style_no,3,2))
	dw_body.setcolumn("season_bae_su")
	
	ll_find2 = dw_mast2.Find("price = 0", 1, dw_mast2.RowCount())
	If ll_find2 > 0 Then 
		dw_mast2.Object.t_error.Text = "아직 발주하지 않은 자재가 있습니다!"
		dw_body.Object.curr_price.Protect = 1
		dw_body.Object.curr_price.BackGround.Color = RGB(192, 192, 192)
		dw_body.Object.md_price.Protect   = 1
		dw_body.Object.md_price.BackGround.Color   = RGB(192, 192, 192)
//		dw_body.Object.tag_price.Protect  = 1
//		dw_body.Object.tag_price.BackGround.Color  = RGB(192, 192, 192)
	End IF

	If idc_in_qty <> 0 Then
//		dw_body.Object.curr_price.Protect = 1
//		dw_body.Object.curr_price.BackGround.Color = RGB(192, 192, 192)
//		dw_body.Object.md_price.Protect   = 1
//		dw_body.Object.md_price.BackGround.Color   = RGB(192, 192, 192)
//		dw_body.Object.tag_price.Protect  = 1
//		dw_body.Object.tag_price.BackGround.Color  = RGB(192, 192, 192)
	End IF
	
	If ll_find2 = 0 Then
		ldc_mmat_price1 = dw_body.GetItemDecimal(1, "mmat_price")
		ldc_mmat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "mmat_price")
		ldc_smat_price1 = dw_body.GetItemDecimal(1, "smat_price")
		ldc_smat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "smat_price")
		If ldc_mmat_price1 <> ldc_mmat_price2 or ldc_smat_price1 <> ldc_smat_price2 Then


			IF  ldc_mmat_price1 = 0 or idc_in_qty = 0  THEN
				 dw_body.SetItem(1, "mmat_price", ldc_mmat_price2 )
			END IF
			
			IF  ldc_smat_price1 = 0  or idc_in_qty = 0  THEN
				 dw_body.SetItem(1, "smat_price", ldc_smat_price2 )
			END IF
			
			ib_changed = true
			cb_update.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
		Else
			cb_print.enabled = TRUE
			cb_preview.enabled = TRUE
			cb_excel.enabled = TRUE
		End If
	Else
		cb_print.enabled = TRUE
		cb_preview.enabled = TRUE
		cb_excel.enabled = TRUE
	End IF
	
   dw_body.SetFocus()
END IF

il_rows  = dw_1.retrieve(is_style_no)
dw_1.setitem(1,"season_bae_su", MidA(is_style_no,3,2) )


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

dw_1.setfocus()
dw_1.setcolumn("season_bae_su")

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
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

is_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(is_style_no) or Trim(is_style_no) = "" then
   MessageBox(ls_title,"품번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if

is_yymmdd = String(dw_head.GetItemDateTime(1, "yymmdd"), 'yyyymmdd')
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

idc_ord_qty = dw_head.GetItemDecimal(1, "ord_qty")
if IsNull(idc_ord_qty) then
	idc_ord_qty = 1
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/
String     ls_style_no
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"				
			IF ai_div = 1 and LeftA(as_data,1) = 'T' THEN 	/* Tasse Tasse 전용 원가*/
				IF wf_style_info(as_data, al_row, '1') = 0 THEN
			//		RETURN 0
					
					if gs_brand <> "K" then						
						RETURN 0
					else 
						if gs_brand <> MidA(as_data,1,1) then
							Return 1
						else 
							RETURN 0
						end if	
					end if						
					
				END IF
			END IF
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = "WHERE brand = 'T' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
				ELSE
					gst_cd.Item_where = ""
				END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				ls_style_no = lds_Source.GetItemString(1,"style_no")

				dw_head.SetItem(al_row, "style_no", ls_style_no)
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"cust_cd"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_nm"))
				dw_head.SetItem(al_row, "out_seq", lds_Source.GetItemString(1,"out_seq"))
				dw_head.SetItem(al_row, "out_seq_nm", lds_Source.GetItemString(1,"out_seq_nm"))
				dw_head.SetItem(al_row, "ord_ymd", lds_Source.GetItemString(1,"ord_ymd"))
				dw_head.SetItem(al_row, "dlvy_ymd", lds_Source.GetItemString(1,"dlvy_ymd"))

				IF wf_style_info(ls_style_no, al_row, '2') <> 0 THEN
					MessageBox("입력오류", "발주수량 조회에 실패하였습니다!")
					RETURN 1
				END IF
				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("style_no")
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

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
datetime ld_datetime

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
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
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


/* Data window Resize */
inv_resize.of_Register(dw_mast2, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_mast2.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
inv_resize.of_Register(dw_1, "FixedToRight")

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
end if

dw_head.setitem(1,"style_no",gsv_cd.gs_cd10)
post event ue_retrieve()


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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_mast2.Enabled = true
         dw_body.Enabled = true
         dw_body.SetFocus()

			cb_excel.enabled = true
			cb_update.enabled = true
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_mast2.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.15                                                  */	
/* 수정일      : 2002.01.15                                                  */
/*===========================================================================*/
string ls_style, is_style_info, ls_napum_agree, ls_chno
decimal ldc_tag_price

IF dw_body.AcceptText() <> 1 THEN RETURN -1

ldc_tag_price = dw_body.getitemdecimal(1,"tag_price")
dw_body.setitem(1,"curr_price",ldc_tag_price)
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(id_datetime) = FALSE THEN
	Return 0
END IF


idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = DataModified! THEN		/* Modify Record */
	dw_body.Setitem(1, "mod_id", gs_user_id)
	dw_body.Setitem(1, "mod_dt", id_datetime)
	If MidA(is_style_no, 9, 1) = '0' or MidA(is_style_no, 9, 1) = 'S' Then
		If wf_12022_set() <> 0 Then
			MessageBox("저장오류", "품번 단가를 저장하는데 실패하였습니다.")
			rollback  USING SQLCA;
			Return -1
		end if
		If wf_12020_set() <> 0 Then
			MessageBox("저장오류", "제품을 저장하는데 실패하였습니다.")
			rollback  USING SQLCA;
			Return -1
		end if
	End IF
END IF

il_rows = dw_body.Update(TRUE, FALSE)


if il_rows = 1 then
   dw_body.ResetUpdate()
	il_rows = dw_1.Update(TRUE, FALSE)
	if il_rows = 1 then
		dw_1.ResetUpdate()
	end if

	ls_style = LeftA(is_style_no,8)
	ls_chno  = MidA(is_style_no,9,1)
	is_style_info = dw_body.GetitemString(1,"style_info")
	
	update tb_12020_m set style_info = :is_style_info 
	where style = :ls_style;
	
	ls_napum_agree = dw_1.getitemstring(1,"napum_agree")
	
	update tb_12021_d set napum_agree = :ls_napum_agree
	where style = :ls_style
	and   chno  = :ls_chno;

   commit USING SQLCA;
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.22                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title
IF dw_body.AcceptText() <> 1 THEN RETURN
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

//ls_modify =  "t_style.Text = '" + is_style_no  + "'" + &
//             "t_yymmdd.Text = '" + String(is_yymmdd,"@@@@/@@/@@")  + "'" + &
//				 "t_ord_qty.Text = '" + String(dw_head.getitemdecimal(1, 'ord_qty'), "#,##0") + "'" + &
//				 "t_out_seq.Text = '" + dw_head.getitemstring(1, 'out_seq') + "'" + &
//				 "t_out_seq_nm.Text = '" + dw_head.getitemstring(1, 'out_seq_nm') + "'" + &
//				 "t_cust_cd.Text = '" + dw_head.getitemstring(1, 'cust_cd') + "'" + &
//				 "t_cust_nm.Text = '" + dw_head.getitemstring(1,  'cust_nm')  + "'" + &
//				 "t_ord_ymd.Text = '" + string(dw_head.getitemstring(1, 'ord_ymd'),"@@@@/@@/@@")  + "'" + &
//				 "t_dlvy_ymd.Text = '" + string(dw_head.getitemstring(1, 'dlvy_ymd'),"@@@@/@@/@@")  + "'"  + &
//   	   	 "t_mat_price.Text = '" + String(dw_body.getitemNumber(1, 'mat_price'), "#,##0") + "'" + & 
//				 "t_make_price.Text = '" + String(dw_body.getitemNumber(1, 'make_price'), "#,##0") + "'" + &
//				 "t_etc_price.Text = '" + String(dw_body.getitemNumber(1, 'etc_price'), "#,###") + "'" + &
//				 "t_won_price.Text = '" + String(dw_body.getitemNumber(1, 'won_price'), "#,##0") + "'" + &
//				 "t_expense.Text = '" + String(dw_body.getitemNumber(1, 'expense'), "#,##0") + "'" + &
//				 "t_margin.Text = '" + String(dw_body.getitemNumber(1, 'margin'), "#,##0") + "'" + &
//				 "t_napum.Text = '" + String(dw_body.getitemNumber(1, 'napum'), "#,##0") + "'" + &
//				 "t_chu_price.Text = '" + String(dw_body.getitemNumber(1, 'chu_price'), "#,##0") + "'"
////				 "t_busi_price.Text = '" + String(dw_body.getitemNumber(1, 'busi_price'), "#,##0") + "'" + &
////				 "t_tag_price.Text = '" + String(dw_body.getitemNumber(1, 'tag_price'), "#,##0") + "'"				 
////
//dw_print.Modify(ls_modify)
//
//dw_print.object.season_bae_su.text = idw_bae_su.getitemstring(idw_bae_su.GetRow(),"ord_baesu")
//
//
//
//
dw_print.object.t_style.Text = is_style_no 

dw_print.object.t_yymmdd.Text = String(is_yymmdd,"@@@@/@@/@@") 
dw_print.object.t_ord_qty.Text = String(dw_head.getitemdecimal(1, 'ord_qty'), "#,##0")
dw_print.object.t_out_seq.Text = dw_head.getitemstring(1, 'out_seq')
dw_print.object.t_out_seq_nm.Text = dw_head.getitemstring(1, 'out_seq_nm') 
dw_print.object.t_cust_cd.Text = dw_head.getitemstring(1, 'cust_cd') 
dw_print.object.t_cust_nm.Text = dw_head.getitemstring(1,  'cust_nm')  
dw_print.object.t_ord_ymd.Text = string(dw_head.getitemstring(1, 'ord_ymd'),"@@@@/@@/@@") 
dw_print.object.t_dlvy_ymd.Text = string(dw_head.getitemstring(1, 'dlvy_ymd'),"@@@@/@@/@@")   
dw_print.object.t_mat_price.Text = String(dw_body.getitemNumber(1, 'mat_price'), "#,##0") 
dw_print.object.t_make_price.Text = String(dw_body.getitemNumber(1, 'make_price'), "#,##0")
dw_print.object.t_etc_price.Text = String(dw_body.getitemNumber(1, 'etc_price'), "#,###") 
dw_print.object.t_won_price.Text = String(dw_body.getitemNumber(1, 'won_price'), "#,##0") 
dw_print.object.t_expense.Text = String(dw_body.getitemNumber(1, 'expense'), "#,##0") 
dw_print.object.t_margin.Text = String(dw_body.getitemNumber(1, 'margin'), "#,##0") 
dw_print.object.t_napum.Text = String(dw_body.getitemNumber(1, 'napum'), "#,##0")
dw_print.object.t_chu_price.Text = String(dw_body.getitemNumber(1, 'tag_price'), "#,##0")

dw_print.object.season_bae_su.text = idw_bae_su.getitemstring(idw_bae_su.GetRow(),"ord_baesu")

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long ll_rows2, ll_find2
Decimal ldc_mmat_price1, ldc_smat_price1, ldc_mmat_price2, ldc_smat_price2

This.Trigger Event ue_title ()
//dw_print.retrieve(is_style_no)
dw_mast2.ShareData(dw_print)
		ldc_mmat_price1 = dw_print.GetItemDecimal(1, "mmat_price")
		ldc_mmat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "mmat_price")
		ldc_smat_price1 = dw_print.GetItemDecimal(1, "smat_price")
		ldc_smat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "smat_price")
		If ldc_mmat_price1 <> ldc_mmat_price2 or ldc_smat_price1 <> ldc_smat_price2 Then
			dw_print.SetItem(1, "mmat_price", ldc_mmat_price2 )
			dw_print.SetItem(1, "smat_price", ldc_smat_price2 )
	   end if
		

dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32010_e","0")
end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/
String     ls_style_no
Boolean    lb_check 
DataStore  lds_Source

IF LeftA(gsv_cd.gs_cd10,1) = 'T' THEN 	/* Tasse Tasse 전용 원가*/
	IF wf_style_info(gsv_cd.gs_cd10, 1, '1') = 0 THEN
		RETURN 0
	END IF
END IF

	gst_cd.window_title    = "STYLE 코드 검색" 
	gst_cd.datawindow_nm   = "d_com010" 
	gst_cd.default_where   = "WHERE brand = 'T' "
	IF Trim(gsv_cd.gs_cd10) <> "" THEN
		gst_cd.Item_where = " STYLE LIKE '" + LeftA(gsv_cd.gs_cd10, 8) + "%' "
	ELSE
		gst_cd.Item_where = ""
	END IF

lds_Source = Create DataStore
OpenWithParm(W_COM200, lds_Source)

IF Isvalid(Message.PowerObjectParm) THEN
	ib_itemchanged = True
	lds_Source = Message.PowerObjectParm
	dw_head.SetRow(1)
	dw_head.SetColumn("style_no")
	ls_style_no = lds_Source.GetItemString(1,"style_no")

	dw_head.SetItem(1, "style_no", ls_style_no)
	dw_head.SetItem(1, "cust_cd", lds_Source.GetItemString(1,"cust_cd"))
	dw_head.SetItem(1, "cust_nm", lds_Source.GetItemString(1,"cust_nm"))
	dw_head.SetItem(1, "out_seq", lds_Source.GetItemString(1,"out_seq"))
	dw_head.SetItem(1, "out_seq_nm", lds_Source.GetItemString(1,"out_seq_nm"))
	dw_head.SetItem(1, "ord_ymd", lds_Source.GetItemString(1,"ord_ymd"))
	dw_head.SetItem(1, "dlvy_ymd", lds_Source.GetItemString(1,"dlvy_ymd"))

	IF wf_style_info(ls_style_no, 1, '2') <> 0 THEN
		MessageBox("입력오류", "발주수량 조회에 실패하였습니다!")
		RETURN 1
	END IF
	
	/* 다음컬럼으로 이동 */
	dw_head.SetColumn("style_no")
	ib_itemchanged = False 
	lb_check = TRUE 
ELSE
	lb_check = FALSE 
END IF
Destroy  lds_Source


RETURN 0

end event

type cb_close from w_com010_e`cb_close within w_32019_e
integer taborder = 120
end type

type cb_delete from w_com010_e`cb_delete within w_32019_e
boolean visible = false
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_32019_e
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_32019_e
end type

type cb_update from w_com010_e`cb_update within w_32019_e
integer taborder = 110
end type

type cb_print from w_com010_e`cb_print within w_32019_e
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_32019_e
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_32019_e
end type

type cb_excel from w_com010_e`cb_excel within w_32019_e
boolean visible = false
integer taborder = 100
end type

type dw_head from w_com010_e`dw_head within w_32019_e
integer y = 148
integer height = 208
string dataobject = "d_32018_h01"
boolean livescroll = false
end type

event dw_head::constructor;//DataWindowChild ldw_child
//
//This.GetChild("item", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve()
//
end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_32019_e
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com010_e`ln_2 within w_32019_e
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_e`dw_body within w_32019_e
integer x = 9
integer y = 368
integer height = 560
integer taborder = 50
string dataobject = "d_32018_d02"
boolean vscrollbar = false
boolean livescroll = false
end type

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

event dw_body::constructor;call super::constructor;this.getchild("season_bae_su",idw_bae_su)
idw_bae_su.settransobject(sqlca)
idw_bae_su.retrieve(GS_BRAND)


end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_32019_e
integer x = 201
integer y = 588
string dataobject = "d_32018_r01"
end type

type dw_mast2 from u_dw within w_32019_e
integer x = 9
integer y = 932
integer width = 3589
integer height = 1132
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_32018_d01"
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_1 from datawindow within w_32019_e
integer x = 2816
integer y = 376
integer width = 777
integer height = 548
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_32019_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false


end event

