package io.github.sms1875.gamepaper.controller;

import io.github.sms1875.gamepaper.service.firebase.FirebaseStorageService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ImageRetrievalController {

  private final FirebaseStorageService firebaseStorageService;

  public ImageRetrievalController(FirebaseStorageService firebaseStorageService) {
    this.firebaseStorageService = firebaseStorageService;
  }

  @GetMapping("/api/wallpapers/{game}")
  @ResponseBody
  public ResponseEntity<List<String>> getWallpapers(@PathVariable String game) {
    List<String> urls = firebaseStorageService.getImageUrls(game, "wallpapers");
    if (!urls.isEmpty()) {
      return ResponseEntity.ok(urls);
    } else {
      return ResponseEntity.noContent().build();
    }
  }
}
