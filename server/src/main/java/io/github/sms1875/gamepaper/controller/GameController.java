package io.github.sms1875.gamepaper.controller;

import io.github.sms1875.gamepaper.domain.Game;
import io.github.sms1875.gamepaper.service.GameManagementService;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class GameController {

  private final GameManagementService gameManagementService;

  public GameController(GameManagementService gameManagementService) {
    this.gameManagementService = gameManagementService;
  }

  @GetMapping("/api/games")
  @ResponseBody
  public List<Game> getGames() {
    return gameManagementService.getAllGames();
  }

  @GetMapping("/api/games/{game}")
  @ResponseBody
  public Game getGame(@PathVariable String game) {
    return gameManagementService.getGame(game);
  }
}
