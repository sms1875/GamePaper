package io.github.sms1875.gamepaper.service.firebase;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.firebase.cloud.StorageClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class FirebaseStorageService {

  private final Storage storage;

  @Value("${firebase.storage.bucket}")
  private String bucketName;

  public FirebaseStorageService() {
    this.storage = StorageClient.getInstance().bucket().getStorage();
  }

  public String uploadFile(byte[] fileData, String fileName, String game, String type) {
    String path = String.format("games/%s/%s/%s", game, type, fileName);

    BlobId blobId = BlobId.of(bucketName, path);
    BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("image/jpeg").build();

    storage.create(blobInfo, fileData);

    return path;
  }

  public List<String> getImageUrls(String game, String type) {
    List<String> urls = new ArrayList<>();
    String prefix = String.format("games/%s/%s/", game, type);

    for (Blob blob : storage.list(bucketName, Storage.BlobListOption.prefix(prefix)).iterateAll()) {
      urls.add(blob.signUrl(15, TimeUnit.MINUTES).toString()); // URL valid for 15 minutes
    }

    return urls;
  }
}
