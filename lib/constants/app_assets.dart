/// 应用图标资源常量
/// 统一管理本地 assets 图标路径，避免硬编码
class AppAssets {
  // 远程图标基础URL（用于尚未本地化的图标）
  static const String remoteIconBase = 'http://snbc.zglcwl.com/Public/fontImages/';

  // ===== 已本地化的图标（使用 Image.asset） =====

  // Tab 栏图标
  static const String tabHomeSelected = 'images/tab_home_n.png';
  static const String tabHomeUnselected = 'images/tab_home_h.png';
  static const String tabMsgSelected = 'images/tab_msg_n.png';
  static const String tabMsgUnselected = 'images/tab_msg_h.png';
  static const String tabEnterpriseSelected = 'images/tab_qiye_h.png';
  static const String tabEnterpriseUnselected = 'images/tab_qiye_n.png';
  static const String tabMySelected = 'images/tab_my_n.png';
  static const String tabMyUnselected = 'images/tab_my_h.png';

  // 登录相关
  static const String icLauncher = 'images/ic_launcher.png';
  static const String delLoginIcon = 'images/del_login_icon.png';
  static const String loginSeeIcon = 'images/login_see_icon.png';
  static const String loginUnseeIcon = 'images/login_unsee_icon.png';
  static const String deleInIcon = 'images/dele_in_icon.png';
  static const String deleUnIcon = 'images/dele_un_icon.png';

  // 个人中心
  static const String headBg = 'images/head_bg.png';
  static const String headDis = 'images/head_dis.png';

  // 其他
  static const String eyes = 'images/eyes.png';
  static const String downloaderN = 'images/downloader_n.png';
  static const String wechatImg = 'images/wechat_img.png';
  static const String circleOfFriends = 'images/circle_of_friends.png';
  static const String opinionAddimg = 'images/opinion_addimg.png';

  // ===== 尚未本地化的图标（仍使用远程URL） =====
  static const String topBackBtn = '${remoteIconBase}top_back_btn.png';
  static const String buttonNext = '${remoteIconBase}button_next.png';
  static const String myNext = '${remoteIconBase}my_next.png';
  static const String moreImg = '${remoteIconBase}more_img.png';
  static const String moreImg1 = '${remoteIconBase}more_img1.png';
  static const String searchIcon = '${remoteIconBase}search_icon.png';
  static const String downloaderImg = '${remoteIconBase}downloader_img.png';
  static const String pauseIcon = '${remoteIconBase}pause.png';
  static const String playIcon = '${remoteIconBase}play.png';
  static const String deleteImg = '${remoteIconBase}delete_img.png';
  static const String refreshIcon = '${remoteIconBase}refresh.png';
}
