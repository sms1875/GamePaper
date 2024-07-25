package io.github.sms1875.gamepaper.service;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface GameImageRetrievalService {
  List<String> getImageUrls();

  CompletableFuture<List<String>> getImageUrlsAsync();

  String getGameName();
}