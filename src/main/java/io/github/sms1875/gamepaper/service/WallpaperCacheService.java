package io.github.sms1875.gamepaper.service;

import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class WallpaperCacheService {
  private final Map<String, List<String>> cache = new ConcurrentHashMap<>();

  public void cacheWallpapers(String game, List<String> wallpapers) {
    cache.put(game.toLowerCase(), wallpapers);
  }

  public List<String> getCachedWallpapers(String game) {
    return cache.get(game.toLowerCase());
  }

  public boolean hasCachedWallpapers(String game) {
    return cache.containsKey(game.toLowerCase());
  }
}