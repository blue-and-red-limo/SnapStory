package com.ssafy.snapstory.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.ssafy.snapstory.exception.not_found.PhotoNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import marvin.image.MarvinImage;
import org.marvinproject.image.transform.scale.Scale;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class AwsS3Service {

    private final AmazonS3 amazonS3;
    @Value("${cloud.aws.s3.bucket}")
    private String bucket;
    @Value("${aws-cloud.aws.s3.bucket.url}")
    private String bucketUrl;

//    public String uploadImage(MultipartFile photo) {
//        //파일이 없는 경우
//        if (photo.getSize() == 0) {
//            throw new PhotoNotFoundException();
//        }
//
//        String fileName = createFileName(photo.getOriginalFilename());
//        ObjectMetadata objectMetadata = new ObjectMetadata();
//        objectMetadata.setContentLength(photo.getSize());
//        objectMetadata.setContentType(photo.getContentType());
//
//        try (InputStream inputStream = photo.getInputStream()) {
//            amazonS3.putObject(new PutObjectRequest(bucket, fileName, inputStream, objectMetadata)
//                    .withCannedAcl(CannedAccessControlList.PublicRead));
//        } catch (IOException e) {
//            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "이미지 업로드에 실패했습니다.");
//        }
//
//        return fileName;
//    }

    public void deleteImage(String fileName) {
        amazonS3.deleteObject(new DeleteObjectRequest(bucket, fileName));
    }

    private String createFileName(String fileName) {
        return UUID.randomUUID().toString().concat(getFileExtension(fileName));
    }

    private String getFileExtension(String fileName) {
        try {
            return fileName.substring(fileName.lastIndexOf("."));
        } catch (StringIndexOutOfBoundsException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "잘못된 형식의 파일(" + fileName + ") 입니다.");
        }
    }

    public String uploadImage(String url) throws IOException {
        //파일이 없는 경우
        if (url.length() == 0) {
            throw new PhotoNotFoundException();
        }
        URL imgURL = new URL(url);
        UUID uuid=UUID.randomUUID();
        String fileName = "images/"+uuid+".png";
        String fileFormat = "png";
        BufferedImage image = ImageIO.read(imgURL);
        //resizer 실횅
        MultipartFile photo = resizer(fileName,fileFormat,image,400);
        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentLength(photo.getSize());
        objectMetadata.setContentType(photo.getContentType());

        try (InputStream inputStream = photo.getInputStream()) {
            amazonS3.putObject(new PutObjectRequest(bucket, fileName, inputStream, objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead));
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "이미지 업로드에 실패했습니다.");
        }

        return fileName;
    }
    @Transactional
    public MultipartFile resizer(String fileName, String fileFormat, BufferedImage image, int width) {

        try {
            int originWidth = image.getWidth();
            int originHeight = image.getHeight();

            MarvinImage imageMarvin = new MarvinImage(image);

            Scale scale = new Scale();
            scale.load();
            scale.setAttribute("newWidth", width);
            scale.setAttribute("newHeight", width * originHeight / originWidth);//비율유지를 위해 높이 유지
            scale.process(imageMarvin.clone(), imageMarvin, null, null, false);

            BufferedImage imageNoAlpha = imageMarvin.getBufferedImageNoAlpha();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(imageNoAlpha, fileFormat, baos);
            baos.flush();

            return new CustomMultipartFile(fileName,fileFormat,"image/png", baos.toByteArray());

        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "파일을 줄이는데 실패했습니다.");
        }
    }
    public class CustomMultipartFile implements MultipartFile {

        private final String name;

        private String originalFilename;

        private String contentType;

        private final byte[] content;
        boolean isEmpty;


        public CustomMultipartFile(String name, String originalFilename, String contentType, byte[] content) {
            Assert.hasLength(name, "Name must not be null");
            this.name = name;
            this.originalFilename = (originalFilename != null ? originalFilename : "");
            this.contentType = contentType;
            this.content = (content != null ? content : new byte[0]);
            this.isEmpty = false;
        }

        @Override
        public String getName() {
            return this.name;
        }

        @Override
        public String getOriginalFilename() {
            return this.originalFilename;
        }

        @Override
        public String getContentType() {
            return this.contentType;
        }

        @Override
        public boolean isEmpty() {
            return (this.content.length == 0);
        }

        @Override
        public long getSize() {
            return this.content.length;
        }

        @Override
        public byte[] getBytes() throws IOException {
            return this.content;
        }

        @Override
        public InputStream getInputStream() throws IOException {
            return new ByteArrayInputStream(this.content);
        }

        @Override
        public void transferTo(File dest) throws IOException, IllegalStateException {
            FileCopyUtils.copy(this.content, dest);
        }

    }
}
