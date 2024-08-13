package io.github.sms1875.gamepaper.controller;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.service.GameService;
import io.github.sms1875.gamepaper.service.firebase.FirebaseStorageService;
import io.github.sms1875.gamepaper.service.WallpaperUpdateScheduler;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ImageRetrievalController {

  private final GameService gameService;
  private final WallpaperUpdateScheduler updateScheduler;
  private final FirebaseStorageService firebaseStorageService;

  public ImageRetrievalController(GameService gameService,
      WallpaperUpdateScheduler updateScheduler,
      FirebaseStorageService firebaseStorageService) {
    this.gameService = gameService;
    this.updateScheduler = updateScheduler;
    this.firebaseStorageService = firebaseStorageService;
  }

  @GetMapping("/")
  public String home(Model model) {
    List<Game> games = gameService.getAllGames();
    model.addAttribute("games", games);
    return "home";
  }

  @GetMapping("/api/games")
  @ResponseBody
  public List<Game> getGames() {
    return gameService.getAllGames();
  }

  @GetMapping("/api/wallpapers/{game}")
  @ResponseBody
  public ResponseEntity<List<String>> getWallpapers(@PathVariable String game) {
    List<String> urls = firebaseStorageService.getImageUrls(game, "wallpapers");
    if (!urls.isEmpty()) {
      return ResponseEntity.ok(urls);
    } else {
      updateScheduler.updateWallpapers();
      return ResponseEntity.accepted().build();
    }
  }
}
