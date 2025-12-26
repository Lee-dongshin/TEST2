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
function long SP_CUST_LOGIN(string shop_cd,string pass_wd,string new_pass,ref long user_level,ref string brand,ref string user_grp,ref long pi_ret,ref string msg) RPCFUNC ALIAS FOR "dbo.SP_CUST_LOGIN" 
function long SP_OutMargin(string yymmdd,string shop_cd,string shop_type,string style,ref string sale_type,ref decimal marjin,ref long dc_rate,ref long curr_price,ref long out_price) RPCFUNC ALIAS FOR "dbo.SP_OutMargin" 
function long SP_SaleMargin(string yymmdd,string shop_cd,string shop_type,string style,ref string sale_type,ref decimal marjin,ref long dc_rate,ref long sale_price,ref long sale_collect) RPCFUNC ALIAS FOR "dbo.SP_SaleMargin" 
function long SP_GET_OUTNO(string yymmdd,string brand,ref string out_no) RPCFUNC ALIAS FOR "dbo.SP_GET_OUTNO"

              
end prototypes

on u_n_tr.create
call super::create
end on

on u_n_tr.destroy
call super::destroy
end on

