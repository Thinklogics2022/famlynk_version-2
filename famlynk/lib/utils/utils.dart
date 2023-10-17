class FamlynkServiceUrl {
  static const String baseUrl = "http://3.6.49.2:8080";
  // static const String baseUrl = "http://192.168.1.6:8080";
  static const String createUser = baseUrl + "/register/createregister";
  static const String login = baseUrl + "/authenticate/login";
  static const String verifyOtp = baseUrl + "/register/verifyotp/";
  static const String addMember =
      baseUrl + "/familymembers/createfamilymembers/";
  static const String searchAllUser = baseUrl + "/register/retrievemembers/";
  static const String getFamilyMember =
      baseUrl + "/familymembers/retrieveFamilyMembers/";
  static const String searchAddMember = baseUrl + "/familymembers/addfamily/";
  static const String deleteFamilyMember =
      baseUrl + "/familymembers/deletefamilymember/";
  static const String postNewsFeed = baseUrl + "/newsfeed/createnewsfeed";
  static const String getPublicNewsFeed =
      baseUrl + "/newsfeed/retrievenewsfeed/pagination/";
  static const String getFamilyNewsFeed =
      baseUrl + "/newsfeed/retrievefamilynewsfeed/";
  static const String updateFamilyMember =
      baseUrl + "/familymembers/updatefamilymembers/";
  static const String updatePassword =
      baseUrl + "/register/updatepasswordbyemail/";
  static const String myNewsFeed = baseUrl + "/newsfeed/retrieveusernewsfeed/";
  static const String myNewsFeedEdit = baseUrl + "/newsfeed/updatenewsfeed/";
  static const String myNewsFeedDelete = baseUrl + "/newsfeed/deletenewsfeed/";
  static const String profileUser = baseUrl + "/register/retrieveregisterbyid/";
  static const String editProfile = baseUrl + "/register/updateregisterbyid/";
  static const String addComment = baseUrl + "/comment/createcomment";
  static const String getComment = baseUrl + "/comment/retrievecommentbyid/";
  static const String editComment = baseUrl + "/comment/updatecommentbyid/";
  static const String deleteComment = baseUrl + "/comment/deletecomment/";
  static const String like = baseUrl + "/newsfeed/likes/";
  static const String drpdwnAddMember =
      baseUrl + "/familymembers/getsecondlevelrelation/";
  static const String profileUserrr =
      baseUrl + "/register/retrievemembersbyuserid/";
  static const String frgtPswdFormail =
      baseUrl + "/register/retrieveregisterbyemailforpassword/";
  static const String verifyEmail =
      baseUrl + "/register/retrieveregisterbyemailforpassword/";
  static const String verifyOtpforPswd = baseUrl + "/register/verifyotp/";
  static const String resentOTP = baseUrl + "/register/resend/";
  static const String secondLevelRelation =
      baseUrl + "/familymembers/getsecondlevelrelation/";
  static const String thirdLevelRelation =
      baseUrl + "/familymembers/getthirdlevelrelation/";
  static const String individualUser = baseUrl + "/register/getmemberprofile/";
  static const String imgUrl = baseUrl + "/newsfeed/profileandnameupdate/";
  static const String mutualConnection =
      baseUrl + "/familymembers/getmutualconnection/";
  static const String notification =
      baseUrl + "/notify/retrievenotifybyuniqueuserid/";
  static const String acceptNotification =
      baseUrl + "/notify/acceptFamilyMember/";
  static const String declineNotification = baseUrl + "/familymembers/declinefamilymember/";
  static const String familyTree =
      baseUrl + "/familymembers/getFamilyTree/";
}
