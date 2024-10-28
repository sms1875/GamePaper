package io.github.sms1875.gamepaper.config;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SeleniumConfig {

  /**
   * Chrome WebDriver를 설정하고 반환하는 메서드입니다.
   * 
   * WebDriverManager를 사용하여 ChromeDriver를 자동으로 다운로드하고 설정합니다.
   * ChromeDriver에 필요한 옵션을 추가로 설정합니다.
   * 
   * @return 설정된 Chrome WebDriver 인스턴스
   */
  @Bean
  protected WebDriver webDriver() {
    // WebDriverManager를 사용하여 ChromeDriver를 자동으로 설정합니다.
    WebDriverManager.chromedriver().setup();

    // ChromeDriver에 사용할 옵션을 설정합니다.
    ChromeOptions options = new ChromeOptions();
    options.addArguments("--disable-gpu"); // GPU 사용을 비활성화합니다.
    options.addArguments("--ignore-certificate-errors"); // 인증서 오류를 무시합니다.
    options.addArguments("--lang=ko"); // 브라우저 언어를 한국어로 설정합니다.

    // 현재 다운로드된 ChromeDriver의 버전을 가져옵니다.
    String chromeVersion = WebDriverManager.chromedriver().getDownloadedDriverVersion();

    // 사용자 에이전트를 Chrome 버전에 맞게 설정합니다.
    String userAgent = String.format(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36",
        chromeVersion);
    options.addArguments("user-agent=" + userAgent);

    // 설정된 옵션을 사용하여 ChromeDriver 인스턴스를 생성하고 반환합니다.
    return new ChromeDriver(options);
  }
}
