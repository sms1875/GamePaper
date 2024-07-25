package io.github.sms1875.gamepaper.controller;

import io.github.sms1875.gamepaper.service.ImageRetrievalService;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ImageRetrievalController {

  @Autowired
  private ImageRetrievalService imageRetrievalService;

  @GetMapping("/")
  public String home() {
    return "home";
  }

  @GetMapping("/fetchImage")
  public String fetchImage(Model model) {
    List<String> imageUrls = imageRetrievalService.getAllImageUrlsFromAllPages();
    model.addAttribute("imageUrls", imageUrls);
    return "home";
  }
}
