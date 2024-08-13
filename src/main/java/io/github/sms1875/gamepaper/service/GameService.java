package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.domain.Game;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class GameService {
  private final Map<String, Game> games = new ConcurrentHashMap<>();

  public GameService() {
    // Initialize with predefined games
    addGame("playblackdesert");
    addGame("Mabinogi");
    addGame("MapleStory");
    addGame("Nikke");
    addGame("finalfantasy");
    addGame("genshinimpact");
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
