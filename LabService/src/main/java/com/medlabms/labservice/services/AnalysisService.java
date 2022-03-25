package com.medlabms.labservice.services;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.labservice.models.dtos.AnalysisDTO;
import com.medlabms.labservice.models.entities.Analysis;
import com.medlabms.labservice.repositories.AnalysisRepository;
import com.medlabms.labservice.services.mappers.AnalysisMapper;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@Service
public class AnalysisService {

	private AnalysisRepository analysisRepository;
	private AnalysesGroupService analysesGroupService;
	private AnalysisMapper analysisMapper;

	public AnalysisService(AnalysisRepository analysisRepository, AnalysesGroupService analysesGroupService, AnalysisMapper analysisMapper) {
		this.analysisRepository = analysisRepository;
		this.analysesGroupService = analysesGroupService;
		this.analysisMapper = analysisMapper;
	}

	public Mono<Page<AnalysisDTO>> getAllAnalyses(PageRequest pageRequest) {
		return analysisRepository.findAllBy(pageRequest)
				.flatMap(analysis -> analysesGroupService.getAnalysesGroup(analysis.getAnalysisGroupId())
						.flatMap(analysesGroupDTO -> {
							var analysisDTO = analysisMapper.entityToDtoModel(analysis);
							analysisDTO.setAnalysisGroupName(analysesGroupDTO.getName());
							return Mono.just(analysisDTO);
						}))
				.collectList()
				.zipWith(analysisRepository.count())
				.flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
	}

	public Mono<AnalysisDTO> getAnalysis(String id) {
		return analysisRepository.findById(Long.parseLong(id))
				.flatMap(analysis -> Mono.just(analysisMapper.entityToDtoModel(analysis)));
	}

	public Mono<ResponseEntity<Object>> createAnalysis(AnalysisDTO analysisDTO) {
		return analysisRepository.save(analysisMapper.dtoModelToEntity(analysisDTO))
				.doOnError(throwable -> log.error(throwable.getMessage()))
				.onErrorReturn(new Analysis())
				.flatMap(analysis -> {
					if (analysis.getId() != null)
						return Mono.just(ResponseEntity.ok(analysisMapper.entityToDtoModel(analysis)));
					return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
							.errorMessage("Failed to create analysis").build()));
				});
	}

	public Mono<ResponseEntity<Object>> updateAnalysis(Long id, AnalysisDTO analysisDTO) {
		return analysisRepository.findById(id)
				.flatMap(analysis -> {
					analysisMapper.updateAnalysis(analysisMapper.dtoModelToEntity(analysisDTO), analysis);
					return analysisRepository.save(analysis)
							.onErrorReturn(new Analysis())
							.flatMap(analysis1 -> {
								if (analysis1.getId() != null)
									return Mono.just(ResponseEntity.ok(analysisMapper.entityToDtoModel(analysis1)));
								return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
										.errorMessage("Failed to update analysis").build()));
							});
				});
	}

	public Mono<ResponseEntity<Boolean>> deleteAnalysis(Long id) {
		return analysisRepository.deleteById(id)
				.flatMap(unused -> Mono.just(ResponseEntity.ok(true)))
				.onErrorResume(throwable -> {
					throw new ChildFoundException();
				});
	}
}