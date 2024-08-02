import 'package:wallpaper/models/game.dart';

List<Game> gameList = [
  Game(
    title: 'Black Desert',
    //image: 'assets/images/blackdesert.png',
    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/aa254b7927e20240724075045801.jpg',
    repository: WallpaperData(
      baseUrl: 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/',
      pagingElementSelector: 'div.paging > a',
      pagingAttributeName: 'href',
      imageElementSelector: '#wallpaper_list > li > a[attr-img_m]',
      imageAttributeName: 'attr-img_m',
      pagingUrlPrefix:
          'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/',
    ),
  ),
  Game(
    title: 'Black Desert',
    //image: 'assets/images/blackdesert.png',
    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/9f1607cdcc620240724075032491.jpg',
    repository: WallpaperData(
      baseUrl: 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/',
      pagingElementSelector: 'div.paging > a',
      pagingAttributeName: 'href',
      imageElementSelector: '#wallpaper_list > li > a[attr-img_m]',
      imageAttributeName: 'attr-img_m',
      pagingUrlPrefix:
      'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/',
    ),
  ),
  Game(
    title: 'Black Desert',
    //image: 'assets/images/blackdesert.png',
    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/db2d347483020240724075019471.jpg',
    repository: WallpaperData(
      baseUrl: 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/',
      pagingElementSelector: 'div.paging > a',
      pagingAttributeName: 'href',
      imageElementSelector: '#wallpaper_list > li > a[attr-img_m]',
      imageAttributeName: 'attr-img_m',
      pagingUrlPrefix:
      'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/',
    ),
  ),
  Game(
    title: 'Black Desert',
    //image: 'assets/images/blackdesert.png',
    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/bf216984f8020240724074942751.jpg',
    repository: WallpaperData(
      baseUrl: 'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/',
      pagingElementSelector: 'div.paging > a',
      pagingAttributeName: 'href',
      imageElementSelector: '#wallpaper_list > li > a[attr-img_m]',
      imageAttributeName: 'attr-img_m',
      pagingUrlPrefix:
      'https://www.kr.playblackdesert.com/ko-KR/Data/Wallpaper/',
    ),
  ),
  Game(
    title: 'Mabinogi',
    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/aa254b7927e20240724075045801.jpg',
    //image: 'assets/images/mabinogi.png',
    repository: WallpaperData(
      baseUrl: 'https://mabinogi.nexon.com/page/pds/gallery_wallpaper.asp',
      imageElementSelector:
          '#div_contents > div.board_wrap01 > div.board_data02 > ul > li > a',
      imageAttributeName: 'href',
      imageUrlPattern: RegExp(r"javascript:viewWall2\('(.*?)', \d+\)"),
      imageUrlFilter: (href) => href.contains('1125x2436'),
      imageUrlGroupNumber: 1,
    ),
  ),
  Game(
    title: 'Elden Ring',
    //image: 'assets/images/eldenring.png',
    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/aa254b7927e20240724075045801.jpg',
    repository: WallpaperData(
      baseUrl: 'https://eldenring.bn-ent.net/kr/special/',
      imageElementSelector: '#specialCol > ul.wpList > li > p > a',
      imageAttributeName: 'href',
      imageUrlFilter: (href) => href.contains('1125x2436'),
      imageUrlPrefix: "https://eldenring.bn-ent.net/",
      imageUrlGroupNumber: 0,
    ),
  ),
  Game(
    title: 'Final Fantasy XIV',
    //image: 'assets/images/finalfantasy14.png',

    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/aa254b7927e20240724075045801.jpg',
    repository: WallpaperData(
        baseUrl:
            'https://na.finalfantasyxiv.com/lodestone/special/fankit/smartphone_wallpaper/2_0/#nav_fankit',
        pagingElementSelector:
            '#pc_wallpaper > div > div > ul.nav_select.clearfix > li > a',
        pagingAttributeName: 'href',
        imageElementSelector:
            '#pc_wallpaper > div > div > ul.list_sp_wallpaper.clearfix > li > p > a:nth-child(5)',
        imageAttributeName: 'href',
        pagingUrlPrefix: 'https://na.finalfantasyxiv.com/'),
  ),
  Game(
    title: 'Elder Scrolls Online',
    //image: 'assets/images/elderscrollsonline.png',

    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/aa254b7927e20240724075045801.jpg',
    repository: WallpaperData(
      baseUrl:
          'https://www.elderscrollsonline.com/en-gb/media/category/wallpapers/',
      imageElementSelector:
          '#media-category > div > section > a[data-zl-title*="750x1334"]',
      imageAttributeName: 'data-zl-title',
      imageUrlPattern:
          RegExp(r"<a href='([^']+)'\s+target='_blank'>750x1334</a>"),
      imageUrlGroupNumber: 1,
    ),
  ),
 Game(
    title: 'Heaven Burns Red',
    //image: 'assets/images/heavenburnsred.png',

   image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/aa254b7927e20240724075045801.jpg',
    repository: WallpaperData(
        baseUrl: 'https://heaven-burns-red.com/fankit/sp-wallpaper/',
        imageElementSelector: '.post-content > ul > li > div.clm-buttons > a',
        imageAttributeName: 'href',
        imageUrlFilter: (href) => href.contains('iphone.png'),
        imageUrlPrefix: 'https://heaven-burns-red.com/'),
  ),
  Game(
    title: 'Princess Connect Re:Dive',
    //image: 'assets/images/priconne.png',

    image: 'https://s1.pearlcdn.com/KR/Upload/WALLPAPER/aa254b7927e20240724075045801.jpg',
    repository: WallpaperData(
        baseUrl: 'https://priconne-redive.jp/fankit02/',
        pagingElementSelector: '.pager > ul > li > a',
        pagingAttributeName: 'href',
        pagingUrlFilter: (href) => !href.contains('javascript'),
        imageElementSelector:
            '#contents > div > ul.wallpaper-list > li > ul > li > a',
        imageAttributeName: 'href',
        postElementSelector: "#contents > div > ul.fankit-list > li > a",
        postAttributeName: 'href'),
  ),
];
