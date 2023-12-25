import 'package:dialogix/features/feed/screens/feed_screen.dart';
import 'package:dialogix/features/post/screens/add_post_screen.dart';

class Constants {
  Constants._();
  static const logoPath = 'assets/images/logo.png';
  static const loginEmotePath = 'assets/images/loginEmote.png';
  static const googlePath = 'assets/images/google.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const tabWidgets = [FeedScreen(), AddPostScreen()];
  static const awardsPath = 'assets/images/awards';
  static const iconsPath = 'assets/icons';

  static const archiveAddIcon = '$iconsPath/archive-add.svg';
  static const arrowBottomIcon = '$iconsPath/arrow-bottom.svg';
  static const arrowUpIcon = '$iconsPath/arrow-up.svg';
  static const giftIcon = '$iconsPath/gift.svg';
  static const homeIcon = '$iconsPath/home.svg';
  static const imageIcon = '$iconsPath/image.svg';
  static const linkIcon = '$iconsPath/link.svg';
  static const logoutIcon = '$iconsPath/logout.svg';
  static const commentIcon = '$iconsPath/message-text.svg';
  static const moreIcon = '$iconsPath/more.svg';
  static const searchIcon = '$iconsPath/search-normal.svg';
  static const modIcon = '$iconsPath/security-user.svg';
  static const settingsIcon = '$iconsPath/setting.svg';
  static const textBlockIcon = '$iconsPath/text-block.svg';
  static const trashIcon = '$iconsPath/trash.svg';
  static const userOctagonIcon = '$iconsPath/user-octagon.svg';
  static const verifyIcon = '$iconsPath/verify.svg';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}
