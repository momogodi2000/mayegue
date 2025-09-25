import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_local_datasource.dart';

/// Lesson repository implementation
class LessonRepositoryImpl implements LessonRepository {
  final LessonLocalDataSource localDataSource;

  LessonRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Lesson>>> getLessonsByCourse(String courseId) async {
    try {
      final lessonModels = await localDataSource.getLessonsByCourse(courseId);
      final lessons = lessonModels.map((model) => model.toEntity()).toList();
      return Right(lessons);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Lesson>> getLessonById(String lessonId) async {
    try {
      final lessonModel = await localDataSource.getLessonById(lessonId);
      return Right(lessonModel.toEntity());
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Lesson?>> getNextLesson(String courseId, int currentOrder) async {
    try {
      final lessonModel = await localDataSource.getNextLesson(courseId, currentOrder);
      return Right(lessonModel?.toEntity());
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Lesson?>> getPreviousLesson(String courseId, int currentOrder) async {
    try {
      final lessonModel = await localDataSource.getPreviousLesson(courseId, currentOrder);
      return Right(lessonModel?.toEntity());
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> updateLessonStatus(String lessonId, LessonStatus status) async {
    try {
      final result = await localDataSource.updateLessonStatus(lessonId, status);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> completeLesson(String lessonId) async {
    try {
      final result = await localDataSource.completeLesson(lessonId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> resetLesson(String lessonId) async {
    try {
      final result = await localDataSource.resetLesson(lessonId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }
}
