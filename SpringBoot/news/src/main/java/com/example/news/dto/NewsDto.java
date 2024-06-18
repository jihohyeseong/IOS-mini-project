package com.example.news.dto;

import com.example.news.entity.News;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class NewsDto {

    private Long id;
    private String title;
    private String description;
    private String imageUrl;

    public static NewsDto createNewsDto(News n) {
        return new NewsDto(n.getId(), n.getTitle(), n.getDescription(), n.getImageUrl());
    }
}
