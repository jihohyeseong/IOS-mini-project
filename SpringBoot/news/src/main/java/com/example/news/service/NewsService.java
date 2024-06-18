package com.example.news.service;

import com.example.news.dto.NewsDto;
import com.example.news.entity.News;
import com.example.news.repository.NewsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class NewsService {

    @Autowired
    private NewsRepository newsRepository;

    public List<NewsDto> getNewsList() {
        List<News> news = newsRepository.findAll();
        List<NewsDto> newsDtos = new ArrayList<>();
        for(int i = 0; i < news.size(); i++){
            News n = news.get(i);
            NewsDto dto = NewsDto.createNewsDto(n);
            newsDtos.add(dto);
        }
        return newsDtos;
    }

    public NewsDto getNews(Long id) {
        News news = newsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 뉴스 없음"));
        return NewsDto.createNewsDto(news);
    }

    public NewsDto createNews(NewsDto newsDto) {
        News news = News.createNews(newsDto);
        News created = newsRepository.save(news);
        return NewsDto.createNewsDto(created);
    }
}
