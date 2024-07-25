package io.github.sms1875.gamepaper.controller;

import io.github.sms1875.gamepaper.service.GameImageRetrievalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
public class ImageRetrievalController {

  private final Map<String, GameImageRetrievalService> gameServices;

  @Autowired
  public ImageRetrievalController(Map<String, GameImageRetrievalService> gameServices) {
    this.gameServices = gameServices;
  }

  @GetMapping("/")
  public String home() {
    return "home";
  }

  @GetMapping("/fetchImages")
  @ResponseBody
  public ResponseEntity<?> fetchImages(@RequestParam("game") String game) {
    GameImageRetrievalService service = gameServices.get(game.toLowerCase());
    if (service != null) {
      List<String> imageUrls = service.getImageUrls();
      return ResponseEntity.ok(imageUrls);
    } else {
      return ResponseEntity.badRequest().body("Unsupported game: " + game);
    }
  }
}