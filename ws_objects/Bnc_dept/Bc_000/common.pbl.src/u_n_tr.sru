$PBExportHeader$u_n_tr.sru
$PBExportComments$Extension Transaction class
forward
global type u_n_tr from n_tr
end type
end forward

global type u_n_tr from n_tr
end type
global u_n_tr u_n_tr

type prototypes
function long SP_USER_INFO(string PS_USER_ID,string PS_PASS_WD,string PS_NEW_PASS,ref long PI_USER_LEVEL,ref string PS_DEPT_CD,ref string PS_BRAND,ref string PS_USER_GRP,ref long PI_RETURN,ref string PS_MSG) RPCFUNC ALIAS FOR "dbo.SP_USER_INFO"
function long SP_USER_INFO_test(string PS_USER_ID,string PS_PASS_WD,string PS_NEW_PASS,ref long PI_USER_LEVEL,ref string PS_DEPT_CD,ref string PS_BRAND,ref string PS_USER_GRP,ref long PI_RETURN,ref string PS_MSG) RPCFUNC ALIAS FOR "dbo.SP_USER_INFO_test"
function long SP_GET_OUTNO(string yymmdd,string brand,ref string out_no) RPCFUNC ALIAS FOR "dbo.SP_GET_OUTNO"
function long SP_OutMargin(string yymmdd,string shop_cd,string shop_type,string style,ref string sale_type,ref decimal marjin,ref long dc_rate,ref long curr_price,ref long out_price) RPCFUNC ALIAS FOR "dbo.SP_OutMargin"
function long SP_SaleMargin(string yymmdd,string shop_cd,string shop_type,string style,ref string sale_type,ref decimal marjin,ref long dc_rate,ref long sale_price,ref long sale_collect) RPCFUNC ALIAS FOR "dbo.SP_SaleMargin"
function long SP_OutMargin(string yymmdd,string shop_cd,string shop_type,string style,ref string sale_type,ref decimal marjin,ref decimal dc_rate,ref long curr_price,ref long out_price) RPCFUNC ALIAS FOR "dbo.SP_OutMargin"
function long SP_SaleMargin(string yymmdd,string shop_cd,string shop_type,string style,ref string sale_type,ref decimal marjin,ref decimal dc_rate,ref long sale_price,ref long sale_collect) RPCFUNC ALIAS FOR "dbo.SP_SaleMargin"
function long SP_53007(string flag,string brand,string yymmdd,string user_id) RPCFUNC ALIAS FOR "dbo.SP_53007"

end prototypes

on u_n_tr.create
call super::create
end on

on u_n_tr.destroy
call super::destroy
end on

