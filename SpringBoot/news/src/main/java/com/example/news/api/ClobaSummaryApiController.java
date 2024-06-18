package com.example.news.api;

import com.example.news.dto.ClobaSummary;
import com.example.news.dto.NewsDto;
import com.example.news.service.ClobaSummaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
public class ClobaSummaryApiController {

    @Autowired
    private ClobaSummaryService clobaSummaryService;

    @PostMapping("/api/summary")
    public ClobaSummary getSummary(@RequestBody NewsDto newsDto){
        return clobaSummaryService.clobaSum(newsDto);
    }
}
