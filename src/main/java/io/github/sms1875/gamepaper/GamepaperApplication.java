package io.github.sms1875.gamepaper;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class GamepaperApplication {

  public static void main(String[] args) {
    SpringApplication.run(GamepaperApplication.class, args);
  }

}
