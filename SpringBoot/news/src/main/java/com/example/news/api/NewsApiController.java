package com.example.news.api;

import com.example.news.dto.NewsDto;
import com.example.news.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
public class NewsApiController {

    @Autowired
    private NewsService newsService;

    @GetMapping("/api/news")
    public ResponseEntity<List<NewsDto>> newsList(){
        List<NewsDto> dtos = newsService.getNewsList();
        return ResponseEntity.status(HttpStatus.OK).body(dtos);
    }

    @GetMapping("/api/news/{id}")
    public ResponseEntity<NewsDto> news(@PathVariable Long id){
        NewsDto dto = newsService.getNews(id);
        return ResponseEntity.status(HttpStatus.OK).body(dto);
    }

    @PostMapping("/api/news")
    public ResponseEntity<NewsDto> create(@RequestBody NewsDto newsDto){
        NewsDto dto = newsService.createNews(newsDto);
        return ResponseEntity.status(HttpStatus.OK).body(dto);
    }
}
