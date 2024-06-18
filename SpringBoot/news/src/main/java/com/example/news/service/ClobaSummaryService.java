package com.example.news.service;

import com.example.news.dto.ClobaSummary;
import com.example.news.dto.DocumentObject;
import com.example.news.dto.NewsDto;
import com.example.news.dto.OptionObject;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.LinkedHashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class ClobaSummaryService {

    static final String cid = "dw1kyg70mh";
    static final String admin_Key = "sztfT6kLqmPnPtspvrGGzUWutd2wsARZWRZQbVsJ";
    private ClobaSummary clobaSummary;
    private DocumentObject documentObject;
    private OptionObject optionObject;

    public ClobaSummary clobaSum(NewsDto newsDto){
        documentObject = new DocumentObject();
        documentObject.setContent(newsDto.getDescription());
        optionObject = new OptionObject();

        Map<String, Object> parameters = new LinkedHashMap<>();
        parameters.put("document", documentObject);
        parameters.put("option", optionObject);

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());

        RestTemplate restTemplate = new RestTemplate();

        clobaSummary = restTemplate.postForObject(
                "https://naveropenapi.apigw.ntruss.com/text-summary/v1/summarize",
                requestEntity,
                ClobaSummary.class);

        return clobaSummary;
    }

    private HttpHeaders getHeaders() {
        HttpHeaders httpHeaders = new HttpHeaders();

        httpHeaders.set("X-NCP-APIGW-API-KEY-ID", cid);
        httpHeaders.set("X-NCP-APIGW-API-KEY", admin_Key);
        httpHeaders.set("Content-type", "application/json");

        return httpHeaders;
    }
}
