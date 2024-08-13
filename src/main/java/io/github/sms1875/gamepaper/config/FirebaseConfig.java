package io.github.sms1875.gamepaper.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import javax.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class FirebaseConfig {

  // application.properties 또는 application.yml 파일에서 설정된 Firebase 서비스 계정 키 파일 경로
  @Value("${firebase.config.path}")
  private String firebaseConfigPath;

  // Firebase Storage 버킷 이름
  @Value("${firebase.storage.bucket}")
  private String firebaseStorageBucket;

  /**
   * Firebase를 초기화하는 메서드입니다.
   * 
   * 서비스 계정 키 파일을 로드하고, 이를 사용하여 FirebaseApp을 초기화합니다.
   * 이 메서드는 Spring이 빈을 초기화한 후 실행됩니다.
   *
   * @throws IOException 서비스 계정 키 파일을 읽는 중 오류가 발생할 수 있습니다.
   */
  @PostConstruct
  public void initialize() throws IOException {
    // FileInputStream을 사용하여 서비스 계정 키 파일을 로드합니다.
    try (FileInputStream serviceAccount = new FileInputStream(firebaseConfigPath)) {

      // Firebase 옵션을 설정하여 인증 정보와 스토리지 버킷을 지정합니다.
      FirebaseOptions options = FirebaseOptions.builder()
          .setCredentials(GoogleCredentials.fromStream(serviceAccount)) // 서비스 계정 키 파일로부터 인증 정보를 로드합니다.
          .setStorageBucket(firebaseStorageBucket) // Firebase Storage 버킷을 설정합니다.
          .build();

      // FirebaseApp을 초기화합니다.
      FirebaseApp.initializeApp(options);
    }
  }
}
