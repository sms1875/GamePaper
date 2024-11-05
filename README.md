# Game Paper App

![프로젝트 이미지](https://github.com/sms1875/GamePaper/blob/master/Frame%201.png?raw=true)

- [Google Playstore Link](https://play.google.com/store/apps/details?id=io.github.sms1875.gamepaper)
  
<br>

## 목차

* [소개](#소개)
* [팀원](#팀원)
* [개발 환경](#개발-환경)
* [기능 설명](#기능-설명)
* [개발 내용](#개발-내용)
  
## 소개

- 사용자가 직접 게임 홈페이지에서 배경화면을 확인할 필요 없이, 손쉽게 핸드폰의 잠금화면과 배경화면에 설정할 수 있는 App 입니다.
- 다양한 게임 목록과 배경화면을 보면서 원하는 배경화면을 적용할 수 있습니다.

<br>

## 팀원

<div align="center">

| **송명석** | **김성훈** |
| :------: |  :------: |
| [<img src="https://avatars.githubusercontent.com/u/67058185?v=4" height=150 width=150> <br/> @sms1875](https://github.com/sms1875) | [<img src="https://avatars.githubusercontent.com/u/59463154?v=4" height=150 width=150> <br/> @fridec13](https://github.com/fridec13) | fridec13
| Flutter, Spring boot, Firebase | UI 디자인 및 사용자 경험 개선 |

</div>

<br>

## 개발 환경

- Tools : VS Code, Android Studio
- Front : Flutter
- Back-end : Spring Boot
- Database : FireStorage
- Security : Firesbase App Check
- 개발 툴 : VS Code, Android Studio
- 서버 배포 : AWS EC2
  
<br>

### 시스템 아키텍처

![시스템 아키텍처](https://github.com/sms1875/GamePaper/blob/master/Frame%201.png?raw=true)

<br>

## 기능 설명

**배경화면 이미지 로드 및 설정**

- Firebase 스토리지를 사용하여 다양한 배경화면 이미지를 저장하고 로드합니다. 사용자는 이러한 이미지를 앱에서 바로 배경화면 또는 잠금화면으로 설정할 수 있습니다.

**이미지 블러 해쉬 미리보기**

- 이미지를 로드할 때 블러 해쉬(blur hash)를 사용하여 빠른 미리보기를 제공합니다. 사용자는 이미지가 완전히 로드되기 전에 저해상도의 블러된 미리보기를 통해 더 빠르고 부드러운 사용자 경험을 누릴 수 있습니다.

**손쉬운 배경화면 설정**

- 사용자는 선택한 배경화면을 간단한 버튼 클릭만으로 자신의 기기에 배경화면 또는 잠금화면으로 설정할 수 있습니다. 이 과정은 Flutter의 네이티브 기능 호출을 통해 손쉽게 이루어집니다.

**게임 데이터 관리 및 진행 상황 저장**

- Firebase Realtime Database 또는 Firestore를 사용하여 다양한 게임 데이터와 사용자 진행 상태를 관리합니다. 사용자가 게임을 중단한 후에도 이전 진행 상황을 저장하여, 재방문 시 계속 이어서 플레이할 수 있습니다.

**사용자 인증 및 데이터 보호**
   
- Firebase Authentication을 통해 사용자 로그인 및 인증 기능을 제공합니다. 이를 통해 사용자의 개인 설정과 데이터를 안전하게 저장하고 관리할 수 있도록 보장합니다.

<br>

### 앱 스크린

### [초기화면]
- 서비스 접속 초기화면으로 splash 화면이 잠시 나온 뒤 다음 페이지가 나타납니다.
    - 로그인이 되어 있지 않은 경우 : SNS 로그인 페이지
    - 로그인이 되어 있는 경우 : README 홈 화면
- SNS(카카오톡, 구글, 페이스북) 로그인 기능은 구현되어 있지 않습니다.

| 초기화면 |
|----------|
|![apply](https://github.com/sms1875/GamePaper/blob/master/asset/apply.gif?raw=true)|


<br>

## 개발 내용

### FrontEnd

```
client/
├─ android/
│  ├─ app/
│  │  ├─ build.gradle
│  │  ├─ google-services.json
│  │  └─ src/
│  │     ├─ debug/AndroidManifest.xml
│  │     ├─ main/
│  │        ├─ AndroidManifest.xml
│  │        ├─ kotlin/io/github/sms1875/gamepaper/MainActivity.kt
│  │        └─ res/
│  │           ├─ drawable/launch_background.xml
│  │           ├─ mipmap-[dpi folders]
│  │           └─ values[-night]
│  ├─ build.gradle
├─ assets/
│  └─ images/logo.png
├─ lib/
│  ├─ config/firebase_options.dart
│  ├─ main.dart
│  ├─ models/
│  │  └─ game.dart
│  ├─ providers/
│  │  ├─ home_provider.dart
│  │  └─ wallpaper_provider.dart
│  ├─ repositories/
│  │  └─ game_repository.dart
│  ├─ screens/
│  │  ├─ home_screen.dart
│  │  └─ wallpaper_screen.dart
│  ├─ services/
│  │  └─ firebase_service.dart
│  ├─ utils/
│  │  └─ handle_error.dart
│  └─ widgets/
│     ├─ common/
│     │  ├─ error_display.dart
│     │  ├─ loading_widget.dart
│     │  └─ load_network_image.dart
│     ├─ home/
│     │  └─ [components]
│     └─ wallpaper/
│        └─ [components]
├─ pubspec.yaml
└─ test/
   └─ widget_test.dart
```

### BackEnd

```
server/
├─ chromedriver-win64/
│  ├─ chromedriver.exe
│  ├─ LICENSE.chromedriver
│  └─ THIRD_PARTY_NOTICES.chromedriver
├─ src/
│  ├─ main/
│  │  ├─ java/io/github/sms1875/gamepaper/
│  │  │  ├─ config/
│  │  │  │  ├─ FirebaseConfig.java
│  │  │  │  └─ SeleniumConfig.java
│  │  │  ├─ controller/
│  │  │  │  ├─ GameController.java
│  │  │  │  ├─ HomeController.java
│  │  │  │  └─ ImageRetrievalController.java
│  │  │  ├─ domain/
│  │  │  │  ├─ Game.java
│  │  │  │  └─ GameStatus.java
│  │  │  └─ service/
│  │  │     ├─ firebase/
│  │  │     │  ├─ FirebaseStorageService.java
│  │  │     │  └─ FirebaseUploadService.java
│  │  │     ├─ [GameManagementService.java, WallpaperProcessingService.java, etc.]
│  │  └─ resources/
│  │     ├─ application.properties
│  │     ├─ META-INF/additional-spring-configuration-metadata.json
│  │     └─ templates/index.html
└─ test/
   └─ java/io/github/sms1875/gamepaper/
      └─ GamepaperApplicationTests.java
```

### 구현

#### FrontEnd

* 이미지 데이터를 Provider에서 관리하여 코드 복잡성을 줄이고 통합하여 관리할 수 있도록 하였습니다.
* 사용자에게 다양한 배경화면을 제공하고, 버튼으로 기기의 배경화면이나 잠금화면으로 간단히 설정할 수 있습니다.
* 이미지가 로딩 중일 경우 ProgressIndicator 대신 BlurHash를 적용하여 블러된 미리보기를 제공합니다.
* Error Code 맵핑을 통해 사용자가 이해하기 쉬운 에러 메시지를 제공합니다.

#### BackEnd

* ㄹㄹㄹ

#### Etc

* Firebase App Check를 사용하여 인증되지 않은 앱의 접근을 제한하였습니다.
* Firestore에서 게임 배경화면 이미지를 관리합니다.

### 최적화

프로파일러를 통한 ?
12313123123123

### 테스트 방법

- **에뮬레이터**: 안드로이드 스튜디오의 에뮬레이터에서 실행하여 테스트 가능.
- **실제 기기**: 실제 기기와 USB 연결 후 Android Studio를 통해 빌드하여 테스트.
