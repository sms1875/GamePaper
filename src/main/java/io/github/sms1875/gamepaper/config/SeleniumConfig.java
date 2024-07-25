package io.github.sms1875.gamepaper.config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import io.github.bonigarcia.wdm.WebDriverManager;

@Configuration
public class SeleniumConfig {

  @Bean
  public WebDriver webDriver() {
    WebDriverManager.chromedriver().setup();
    ChromeOptions options = new ChromeOptions();
    options.addArguments("--headless"); // Run in headless mode for performance
    options.addArguments("--no-sandbox");
    options.addArguments("--disable-dev-shm-usage");
    return new ChromeDriver(options);
  }
}
