package com.example.news.entity;

import com.example.news.dto.NewsDto;
import jakarta.persistence.*;
import lombok.*;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class News {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private String title;

    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String description;

    @Column
    private String imageUrl;

    public static News createNews(NewsDto newsDto) {
        return new News(newsDto.getId(), newsDto.getTitle(), newsDto.getDescription(), newsDto.getImageUrl());
    }
}
