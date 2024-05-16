class WalletRequest{

  String id="";
  String account_number = "";
  String amount = "";
  String approval_status = "";
  String bank = "";
  String ifsc = "";
  String bankaddress = "";
  String user_id="";
  String user_name="";

  WalletRequest(this.id,this.account_number, this.amount, this.approval_status,
      this.bank, this.ifsc, this.bankaddress, this.user_id, this.user_name);
}