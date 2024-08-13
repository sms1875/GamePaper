package io.github.sms1875.gamepaper.config;

import org.springframework.context.annotation.Configuration;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import java.io.FileInputStream;
import java.io.IOException;
import javax.annotation.PostConstruct;

@Configuration
public class FirebaseConfig {

  @PostConstruct
  public void initialize() throws IOException {
    FileInputStream serviceAccount = new FileInputStream("src/main/resources/FirebaseAccountKey.json");

    FirebaseOptions options = FirebaseOptions.builder()
        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
        .setStorageBucket("gamepaper-e336e.appspot.com")
        .build();

    FirebaseApp.initializeApp(options);
  }
}
