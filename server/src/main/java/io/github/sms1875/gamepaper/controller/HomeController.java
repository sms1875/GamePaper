package io.github.sms1875.gamepaper.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

  @GetMapping("/")
  public String home() {
    return "index"; // src/main/resources/templates/index.html
  }
}
