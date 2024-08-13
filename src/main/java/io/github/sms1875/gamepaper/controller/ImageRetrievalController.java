package io.github.sms1875.gamepaper.controller;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.service.GameService;
import io.github.sms1875.gamepaper.service.firebase.FirebaseStorageService;
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
  private final FirebaseStorageService firebaseStorageService;

  public ImageRetrievalController(GameService gameService, FirebaseStorageService firebaseStorageService) {
    this.gameService = gameService;
    this.firebaseStorageService = firebaseStorageService;
  }

  /**
   * 홈페이지를 렌더링합니다.
   *
   * @param model 뷰에 전달할 데이터
   * @return 홈 뷰 이름
   */
  @GetMapping("/")
  public String home(Model model) {
    List<Game> games = gameService.getAllGames();
    model.addAttribute("games", games);
    return "home";
  }

  /**
   * 모든 게임의 정보를 JSON 형태로 반환합니다.
   *
   * @return 게임 목록
   */
  @GetMapping("/api/games")
  @ResponseBody
  public List<Game> getGames() {
    return gameService.getAllGames();
  }

  /**
   * 특정 게임의 월페이퍼 URL을 반환합니다.
   *
   * @param game 게임 이름
   * @return 월페이퍼 URL 목록
   */
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
