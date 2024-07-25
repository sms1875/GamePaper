package io.github.sms1875.gamepaper.config;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SeleniumConfig {

  @Bean
  public WebDriver webDriver() {
    WebDriverManager.chromedriver().setup();
    ChromeOptions options = new ChromeOptions();
    options.addArguments("--headless", "--disable-gpu", "--ignore-certificate-errors", "--lang=ko");

    String chromeVersion = WebDriverManager.chromedriver().getDownloadedDriverVersion();
    String userAgent = String.format(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36",
        chromeVersion);
    options.addArguments("user-agent=" + userAgent);

    return new ChromeDriver(options);
  }
}