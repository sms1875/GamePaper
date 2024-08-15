package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.domain.Game;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class GameManagementService {
  private static final Logger logger = LoggerFactory.getLogger(GameManagementService.class);

  private final Map<String, Game> games = new ConcurrentHashMap<>();
  private final List<String> gameNames = List.of(
      // "genshinimpact",
      // "mabinogi",
      // "maplestory",
      "nikke"
  // "finalfantasy",
  // "playblackdesert"
  );

  @PostConstruct
  private void init() {
    gameNames.forEach(this::addGame);
  }

  public void addGame(String name) {
    games.put(name.toLowerCase(), new Game(name));
  }

  public Game getGame(String name) {
    return games.get(name.toLowerCase());
  }

  public List<Game> getAllGames() {
    return List.copyOf(games.values());
  }
}
