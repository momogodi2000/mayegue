import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/word_entity.dart';
import '../repositories/dictionary_repository.dart';

/// Use case for searching words
class SearchWordsUsecase implements UseCase<List<WordEntity>, SearchWordsParams> {
  final DictionaryRepository repository;

  SearchWordsUsecase(this.repository);

  @override
  Future<Either<Failure, List<WordEntity>>> call(SearchWordsParams params) async {
    return await repository.searchWords(params.query, language: params.language);
  }
}

/// Parameters for SearchWordsUsecase
class SearchWordsParams extends Equatable {
  final String query;
  final String? language;

  const SearchWordsParams({
    required this.query,
    this.language,
  });

  @override
  List<Object?> get props => [query, language];
}
