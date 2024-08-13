package io.github.sms1875.gamepaper.controller;

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
import java.util.stream.Collectors;

@Controller
public class ImageRetrievalController {

  private final GameService gameService;
  private final WallpaperUpdateScheduler updateScheduler;
  private final FirebaseStorageService firebaseStorageService;

  public ImageRetrievalController(GameService gameService,
      WallpaperUpdateScheduler updateScheduler, FirebaseStorageService firebaseStorageService) {
    this.gameService = gameService;
    this.updateScheduler = updateScheduler;
    this.firebaseStorageService = firebaseStorageService;
  }

  @GetMapping("/")
  public String home(Model model) {
    List<GameService.Game> games = gameService.getAllGames();
    model.addAttribute("games", games);
    return "home";
  }

  @GetMapping("/api/games")
  @ResponseBody
  public List<GameDto> getGames() {
    return gameService.getAllGames().stream()
        .map(game -> new GameDto(game.getName(), game.getStatus().toString(), game.getLastUpdated()))
        .collect(Collectors.toList());
  }

  @GetMapping("/api/wallpapers/{game}")
  @ResponseBody
  public ResponseEntity<List<String>> getWallpapers(@PathVariable String game) {
    List<String> urls = firebaseStorageService.getImageUrls(game, "wallpapers");
    if (!urls.isEmpty()) {
      return ResponseEntity.ok(urls);
    } else {
      updateScheduler.updateGameWallpapers(gameService.getGame(game));
      return ResponseEntity.accepted().build();
    }
  }

  private static class GameDto {
    public final String name;
    public final String status;
    public final long lastUpdated;

    public GameDto(String name, String status, long lastUpdated) {
      this.name = name;
      this.status = status;
      this.lastUpdated = lastUpdated;
    }
  }
}
