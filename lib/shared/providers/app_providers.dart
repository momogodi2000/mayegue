import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/usecases/login_usecase.dart';
import '../../features/authentication/domain/usecases/register_usecase.dart';
import '../../features/authentication/domain/usecases/logout_usecase.dart';
import '../../features/authentication/domain/usecases/reset_password_usecase.dart';
import '../../features/authentication/domain/usecases/get_current_user_usecase.dart';
import '../../features/authentication/domain/usecases/google_sign_in_usecase.dart';
import '../../features/authentication/domain/usecases/facebook_sign_in_usecase.dart';
import '../../features/authentication/domain/usecases/apple_sign_in_usecase.dart';
import '../../features/authentication/domain/usecases/sign_in_with_phone_number_usecase.dart';
import '../../features/authentication/domain/usecases/verify_phone_number_usecase.dart';
import '../../features/authentication/domain/usecases/forgot_password_usecase.dart';
import '../../features/authentication/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import '../../features/onboarding/presentation/viewmodels/onboarding_viewmodel.dart';
import '../../features/lessons/data/datasources/course_local_datasource.dart';
import '../../features/lessons/data/datasources/lesson_local_datasource.dart';
import '../../features/lessons/data/datasources/progress_local_datasource.dart';
import '../../features/lessons/data/repositories/course_repository_impl.dart';
import '../../features/lessons/data/repositories/lesson_repository_impl.dart';
import '../../features/lessons/data/repositories/progress_repository_impl.dart';
import '../../features/lessons/domain/repositories/course_repository.dart';
import '../../features/lessons/domain/repositories/lesson_repository.dart';
import '../../features/lessons/domain/repositories/progress_repository.dart';
import '../../features/lessons/domain/usecases/course_usecases.dart';
import '../../features/lessons/domain/usecases/lesson_usecases.dart';
import '../../features/lessons/domain/usecases/progress_usecases.dart';
import '../../features/lessons/presentation/viewmodels/courses_viewmodel.dart';
import '../../features/lessons/presentation/viewmodels/lessons_viewmodel.dart';
import '../../features/dictionary/data/datasources/dictionary_remote_datasource.dart';
import '../../features/dictionary/data/datasources/dictionary_local_datasource.dart';
import '../../features/dictionary/data/repositories/dictionary_repository_impl.dart';
import '../../features/dictionary/domain/repositories/dictionary_repository.dart';
import '../../features/dictionary/domain/usecases/search_words_usecase.dart';
import '../../features/dictionary/domain/usecases/get_word_usecase.dart';
import '../../features/dictionary/domain/usecases/save_favorite_word_usecase.dart';
import '../../features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';
import '../../features/gamification/data/datasources/gamification_datasource.dart';
import '../../features/gamification/data/datasources/gamification_local_datasource.dart';
import '../../features/gamification/data/repositories/gamification_repository_impl.dart';
import '../../features/gamification/domain/repositories/gamification_repository.dart';
import '../../features/gamification/domain/usecases/gamification_usecases.dart' as gamification_usecases;
import '../../features/gamification/presentation/viewmodels/gamification_viewmodel.dart';
import '../../features/ai/data/datasources/ai_remote_datasource.dart';
import '../../features/ai/data/repositories/ai_repository_impl.dart';
import '../../features/ai/domain/repositories/ai_repository.dart';
import '../../features/ai/domain/usecases/ai_usecases.dart';
import '../../features/ai/presentation/viewmodels/ai_viewmodels.dart';

/// List of all providers for the app
List<SingleChildWidget> getProviders() {
  return [
    // Services
    Provider<FirebaseService>(
      create: (_) => FirebaseService()..initialize(),
    ),
    Provider<StorageService>(
      create: (_) => StorageService()..initialize(),
    ),
    Provider<DioClient>(
      create: (_) => DioClient(),
    ),
    Provider<NetworkInfo>(
      create: (_) => NetworkInfo(Connectivity()),
    ),

    // Data sources
    ProxyProvider<FirebaseService, AuthRemoteDataSource>(
      update: (_, firebaseService, __) => AuthRemoteDataSourceImpl(firebaseService),
    ),

    // Repositories
    ProxyProvider<AuthRemoteDataSource, AuthRepository>(
      update: (_, dataSource, __) => AuthRepositoryImpl(dataSource),
    ),

    // Use cases
    ProxyProvider<AuthRepository, LoginUsecase>(
      update: (_, repository, __) => LoginUsecase(repository),
    ),
    ProxyProvider<AuthRepository, RegisterUsecase>(
      update: (_, repository, __) => RegisterUsecase(repository),
    ),
    ProxyProvider<AuthRepository, LogoutUsecase>(
      update: (_, repository, __) => LogoutUsecase(repository),
    ),
    ProxyProvider<AuthRepository, ResetPasswordUsecase>(
      update: (_, repository, __) => ResetPasswordUsecase(repository),
    ),
    ProxyProvider<AuthRepository, GetCurrentUserUsecase>(
      update: (_, repository, __) => GetCurrentUserUsecase(repository),
    ),
    ProxyProvider<AuthRepository, GoogleSignInUsecase>(
      update: (_, repository, __) => GoogleSignInUsecase(repository),
    ),
    ProxyProvider<AuthRepository, FacebookSignInUsecase>(
      update: (_, repository, __) => FacebookSignInUsecase(repository),
    ),
    ProxyProvider<AuthRepository, AppleSignInUsecase>(
      update: (_, repository, __) => AppleSignInUsecase(repository),
    ),
    ProxyProvider<AuthRepository, SignInWithPhoneNumberUsecase>(
      update: (_, repository, __) => SignInWithPhoneNumberUsecase(repository),
    ),
    ProxyProvider<AuthRepository, VerifyPhoneNumberUsecase>(
      update: (_, repository, __) => VerifyPhoneNumberUsecase(repository),
    ),
    ProxyProvider<AuthRepository, ForgotPasswordUsecase>(
      update: (_, repository, __) => ForgotPasswordUsecase(repository),
    ),

    // Onboarding providers (moved GetOnboardingStatusUsecase here for AuthViewModel dependency)
    ProxyProvider<StorageService, OnboardingLocalDataSource>(
      update: (_, storageService, __) => OnboardingLocalDataSourceImpl(storageService),
    ),
    ProxyProvider<OnboardingLocalDataSource, OnboardingRepository>(
      update: (_, dataSource, __) => OnboardingRepositoryImpl(dataSource),
    ),
    ProxyProvider<OnboardingRepository, GetOnboardingStatusUsecase>(
      update: (_, repository, __) => GetOnboardingStatusUsecase(repository),
    ),

    // View models
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        loginUsecase: context.read<LoginUsecase>(),
        registerUsecase: context.read<RegisterUsecase>(),
        logoutUsecase: context.read<LogoutUsecase>(),
        resetPasswordUsecase: context.read<ResetPasswordUsecase>(),
        getCurrentUserUsecase: context.read<GetCurrentUserUsecase>(),
        googleSignInUsecase: context.read<GoogleSignInUsecase>(),
        facebookSignInUsecase: context.read<FacebookSignInUsecase>(),
        appleSignInUsecase: context.read<AppleSignInUsecase>(),
        signInWithPhoneNumberUsecase: context.read<SignInWithPhoneNumberUsecase>(),
        verifyPhoneNumberUsecase: context.read<VerifyPhoneNumberUsecase>(),
        forgotPasswordUsecase: context.read<ForgotPasswordUsecase>(),
        getOnboardingStatusUsecase: context.read<GetOnboardingStatusUsecase>(),
      ),
    ),

    // Onboarding providers
    ProxyProvider<StorageService, OnboardingLocalDataSource>(
      update: (_, storageService, __) => OnboardingLocalDataSourceImpl(storageService),
    ),
    ProxyProvider<OnboardingLocalDataSource, OnboardingRepository>(
      update: (_, dataSource, __) => OnboardingRepositoryImpl(dataSource),
    ),
    ProxyProvider<OnboardingRepository, CompleteOnboardingUsecase>(
      update: (_, repository, __) => CompleteOnboardingUsecase(repository),
    ),
    ProxyProvider<OnboardingRepository, GetOnboardingDataUsecase>(
      update: (_, repository, __) => GetOnboardingDataUsecase(repository),
    ),
    ProxyProvider<OnboardingRepository, ClearOnboardingDataUsecase>(
      update: (_, repository, __) => ClearOnboardingDataUsecase(repository),
    ),
    ProxyProvider2<CompleteOnboardingUsecase, GetOnboardingStatusUsecase, OnboardingViewModel>(
      update: (_, complete, getStatus, __) => OnboardingViewModel(
        completeOnboardingUsecase: complete,
        getOnboardingStatusUsecase: getStatus,
      ),
    ),

    // Lessons providers
    ProxyProvider<StorageService, CourseLocalDataSource>(
      update: (_, storageService, __) => CourseLocalDataSource()..initialize(),
    ),
    ProxyProvider<StorageService, LessonLocalDataSource>(
      update: (_, storageService, __) => LessonLocalDataSource()..initialize(),
    ),
    ProxyProvider<StorageService, ProgressLocalDataSource>(
      update: (_, storageService, __) => ProgressLocalDataSource()..initialize(),
    ),
    ProxyProvider<CourseLocalDataSource, CourseRepository>(
      update: (_, dataSource, __) => CourseRepositoryImpl(dataSource),
    ),
    ProxyProvider<LessonLocalDataSource, LessonRepository>(
      update: (_, dataSource, __) => LessonRepositoryImpl(dataSource),
    ),
    ProxyProvider<ProgressLocalDataSource, ProgressRepository>(
      update: (_, dataSource, __) => ProgressRepositoryImpl(dataSource),
    ),

    // Course usecases
    ProxyProvider<CourseRepository, GetCoursesUsecase>(
      update: (_, repository, __) => GetCoursesUsecase(repository),
    ),
    ProxyProvider<CourseRepository, GetCoursesByLanguageUsecase>(
      update: (_, repository, __) => GetCoursesByLanguageUsecase(repository),
    ),
    ProxyProvider<CourseRepository, GetCoursesByLevelUsecase>(
      update: (_, repository, __) => GetCoursesByLevelUsecase(repository),
    ),
    ProxyProvider<CourseRepository, GetCourseByIdUsecase>(
      update: (_, repository, __) => GetCourseByIdUsecase(repository),
    ),
    ProxyProvider<CourseRepository, GetEnrolledCoursesUsecase>(
      update: (_, repository, __) => GetEnrolledCoursesUsecase(repository),
    ),
    ProxyProvider<CourseRepository, EnrollInCourseUsecase>(
      update: (_, repository, __) => EnrollInCourseUsecase(repository),
    ),
    ProxyProvider<CourseRepository, UnenrollFromCourseUsecase>(
      update: (_, repository, __) => UnenrollFromCourseUsecase(repository),
    ),
    ProxyProvider<CourseRepository, UpdateCourseProgressUsecase>(
      update: (_, repository, __) => UpdateCourseProgressUsecase(repository),
    ),

    // Lesson usecases
    ProxyProvider<LessonRepository, GetLessonsByCourseUsecase>(
      update: (_, repository, __) => GetLessonsByCourseUsecase(repository),
    ),
    ProxyProvider<LessonRepository, GetLessonByIdUsecase>(
      update: (_, repository, __) => GetLessonByIdUsecase(repository),
    ),
    ProxyProvider<LessonRepository, GetNextLessonUsecase>(
      update: (_, repository, __) => GetNextLessonUsecase(repository),
    ),
    ProxyProvider<LessonRepository, GetPreviousLessonUsecase>(
      update: (_, repository, __) => GetPreviousLessonUsecase(repository),
    ),
    ProxyProvider<LessonRepository, CompleteLessonUsecase>(
      update: (_, repository, __) => CompleteLessonUsecase(repository),
    ),
    ProxyProvider<LessonRepository, ResetLessonUsecase>(
      update: (_, repository, __) => ResetLessonUsecase(repository),
    ),
    ProxyProvider<LessonRepository, CreateLessonUsecase>(
      update: (_, repository, __) => CreateLessonUsecase(repository),
    ),
    ProxyProvider<LessonRepository, UpdateLessonUsecase>(
      update: (_, repository, __) => UpdateLessonUsecase(repository),
    ),
    ProxyProvider<LessonRepository, DeleteLessonUsecase>(
      update: (_, repository, __) => DeleteLessonUsecase(repository),
    ),

    // Progress usecases
    ProxyProvider<ProgressRepository, GetUserProgressUsecase>(
      update: (_, repository, __) => GetUserProgressUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, GetLessonProgressUsecase>(
      update: (_, repository, __) => GetLessonProgressUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, GetCourseProgressUsecase>(
      update: (_, repository, __) => GetCourseProgressUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, SaveProgressUsecase>(
      update: (_, repository, __) => SaveProgressUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, UpdateProgressStatusUsecase>(
      update: (_, repository, __) => UpdateProgressStatusUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, UpdateCurrentPositionUsecase>(
      update: (_, repository, __) => UpdateCurrentPositionUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, UpdateScoreUsecase>(
      update: (_, repository, __) => UpdateScoreUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, AddTimeSpentUsecase>(
      update: (_, repository, __) => AddTimeSpentUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, ResetProgressUsecase>(
      update: (_, repository, __) => ResetProgressUsecase(repository),
    ),
    ProxyProvider<ProgressRepository, DeleteProgressUsecase>(
      update: (_, repository, __) => DeleteProgressUsecase(repository),
    ),

    // ViewModels
    ProxyProvider6<GetCoursesUsecase, GetCoursesByLanguageUsecase, GetCoursesByLevelUsecase, GetEnrolledCoursesUsecase, EnrollInCourseUsecase, UnenrollFromCourseUsecase, CoursesViewModel>(
      update: (_, getCourses, getByLang, getByLevel, getEnrolled, enroll, unenroll, __) => CoursesViewModel(
        getCoursesUsecase: getCourses,
        getCoursesByLanguageUsecase: getByLang,
        getCoursesByLevelUsecase: getByLevel,
        getEnrolledCoursesUsecase: getEnrolled,
        enrollInCourseUsecase: enroll,
        unenrollFromCourseUsecase: unenroll,
      ),
    ),
    ChangeNotifierProvider<LessonsViewModel>(
      create: (context) => LessonsViewModel(
        getLessonsByCourseUsecase: context.read<GetLessonsByCourseUsecase>(),
        getLessonByIdUsecase: context.read<GetLessonByIdUsecase>(),
        getNextLessonUsecase: context.read<GetNextLessonUsecase>(),
        getPreviousLessonUsecase: context.read<GetPreviousLessonUsecase>(),
        completeLessonUsecase: context.read<CompleteLessonUsecase>(),
        resetLessonUsecase: context.read<ResetLessonUsecase>(),
        createLessonUsecase: context.read<CreateLessonUsecase>(),
        updateLessonUsecase: context.read<UpdateLessonUsecase>(),
        deleteLessonUsecase: context.read<DeleteLessonUsecase>(),
      ),
    ),

    // Gamification providers
    ProxyProvider<StorageService, GamificationDataSource>(
      update: (_, storageService, __) => GamificationLocalDataSource()..initialize(),
    ),
    ProxyProvider<GamificationDataSource, GamificationRepository>(
      update: (_, dataSource, __) => GamificationRepositoryImpl(dataSource),
    ),
    ProxyProvider<GamificationRepository, gamification_usecases.GetUserProgressUsecase>(
      update: (_, repository, __) => gamification_usecases.GetUserProgressUsecase(repository),
    ),
    ProxyProvider<GamificationRepository, gamification_usecases.AddPointsUsecase>(
      update: (_, repository, __) => gamification_usecases.AddPointsUsecase(repository),
    ),
    ProxyProvider<GamificationRepository, gamification_usecases.AwardAchievementUsecase>(
      update: (_, repository, __) => gamification_usecases.AwardAchievementUsecase(repository),
    ),
    ProxyProvider<GamificationRepository, gamification_usecases.GetLeaderboardUsecase>(
      update: (_, repository, __) => gamification_usecases.GetLeaderboardUsecase(repository),
    ),
    ProxyProvider<GamificationRepository, gamification_usecases.GetUserAchievementsUsecase>(
      update: (_, repository, __) => gamification_usecases.GetUserAchievementsUsecase(repository),
    ),
    ProxyProvider<GamificationRepository, gamification_usecases.CheckAndUnlockAchievementsUsecase>(
      update: (_, repository, __) => gamification_usecases.CheckAndUnlockAchievementsUsecase(repository),
    ),
    ProxyProvider<GamificationRepository, gamification_usecases.UpdateDailyStreakUsecase>(
      update: (_, repository, __) => gamification_usecases.UpdateDailyStreakUsecase(repository),
    ),
    ChangeNotifierProvider<GamificationViewModel>(
      create: (context) => GamificationViewModel(
        getUserProgressUsecase: context.read<gamification_usecases.GetUserProgressUsecase>(),
        addPointsUsecase: context.read<gamification_usecases.AddPointsUsecase>(),
        awardAchievementUsecase: context.read<gamification_usecases.AwardAchievementUsecase>(),
        getLeaderboardUsecase: context.read<gamification_usecases.GetLeaderboardUsecase>(),
        getUserAchievementsUsecase: context.read<gamification_usecases.GetUserAchievementsUsecase>(),
        checkAndUnlockAchievementsUsecase: context.read<gamification_usecases.CheckAndUnlockAchievementsUsecase>(),
        updateDailyStreakUsecase: context.read<gamification_usecases.UpdateDailyStreakUsecase>(),
      ),
    ),

    // Dictionary providers
    ProxyProvider2<FirebaseService, NetworkInfo, DictionaryRemoteDataSource>(
      update: (_, firebaseService, networkInfo, __) => DictionaryRemoteDataSourceImpl(
        firestore: firebaseService.firestore,
        networkInfo: networkInfo,
      ),
    ),
    ProxyProvider<StorageService, DictionaryLocalDataSource>(
      update: (_, storageService, __) => DictionaryLocalDataSourceImpl(),
    ),
    ProxyProvider2<DictionaryRemoteDataSource, DictionaryLocalDataSource, DictionaryRepository>(
      update: (_, remoteDataSource, localDataSource, __) => DictionaryRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: NetworkInfo(Connectivity()),
      ),
    ),
    ProxyProvider<DictionaryRepository, SearchWordsUsecase>(
      update: (_, repository, __) => SearchWordsUsecase(repository),
    ),
    ProxyProvider<DictionaryRepository, GetWordUsecase>(
      update: (_, repository, __) => GetWordUsecase(repository),
    ),
    ProxyProvider<DictionaryRepository, SaveFavoriteWordUsecase>(
      update: (_, repository, __) => SaveFavoriteWordUsecase(repository),
    ),
    ProxyProvider3<SearchWordsUsecase, GetWordUsecase, SaveFavoriteWordUsecase, DictionaryViewModel>(
      update: (_, search, getWord, saveFavorite, __) => DictionaryViewModel(
        searchWordsUsecase: search,
        getWordUsecase: getWord,
        saveFavoriteWordUsecase: saveFavorite,
      ),
    ),

    // AI providers
    Provider<AiRemoteDataSource>(
      create: (_) => AiRemoteDataSourceImpl(
        apiKey: 'your-openai-api-key', // TODO: Move to environment variables
        baseUrl: 'https://api.openai.com/v1',
      ),
    ),
    ProxyProvider2<AiRemoteDataSource, FirebaseService, AiRepository>(
      update: (_, remoteDataSource, firebaseService, __) => AiRepositoryImpl(
        remoteDataSource: remoteDataSource,
        firestore: firebaseService.firestore,
      ),
    ),

    // AI Use cases
    ProxyProvider<AiRepository, SendMessageToAI>(
      update: (_, repository, __) => SendMessageToAI(repository),
    ),
    ProxyProvider<AiRepository, StartConversation>(
      update: (_, repository, __) => StartConversation(repository),
    ),
    ProxyProvider<AiRepository, GetUserConversations>(
      update: (_, repository, __) => GetUserConversations(repository),
    ),
    ProxyProvider<AiRepository, TranslateText>(
      update: (_, repository, __) => TranslateText(repository),
    ),
    ProxyProvider<AiRepository, AssessPronunciation>(
      update: (_, repository, __) => AssessPronunciation(repository),
    ),
    ProxyProvider<AiRepository, GenerateContent>(
      update: (_, repository, __) => GenerateContent(repository),
    ),
    ProxyProvider<AiRepository, GetPersonalizedRecommendations>(
      update: (_, repository, __) => GetPersonalizedRecommendations(repository),
    ),
    ProxyProvider<AiRepository, GetTranslationHistory>(
      update: (_, repository, __) => GetTranslationHistory(repository),
    ),
    ProxyProvider<AiRepository, GetPronunciationHistory>(
      update: (_, repository, __) => GetPronunciationHistory(repository),
    ),

    // AI ViewModels
    ChangeNotifierProvider<AiChatViewModel>(
      create: (context) => AiChatViewModel(
        sendMessageToAI: context.read<SendMessageToAI>(),
        startConversation: context.read<StartConversation>(),
        getUserConversations: context.read<GetUserConversations>(),
      ),
    ),
    ChangeNotifierProvider<TranslationViewModel>(
      create: (context) => TranslationViewModel(
        translateText: context.read<TranslateText>(),
        getTranslationHistory: context.read<GetTranslationHistory>(),
      ),
    ),
    ChangeNotifierProvider<PronunciationViewModel>(
      create: (context) => PronunciationViewModel(
        assessPronunciation: context.read<AssessPronunciation>(),
        getPronunciationHistory: context.read<GetPronunciationHistory>(),
      ),
    ),
    ChangeNotifierProvider<ContentGenerationViewModel>(
      create: (context) => ContentGenerationViewModel(
        generateContent: context.read<GenerateContent>(),
      ),
    ),
    ChangeNotifierProvider<AiRecommendationsViewModel>(
      create: (context) => AiRecommendationsViewModel(
        getPersonalizedRecommendations: context.read<GetPersonalizedRecommendations>(),
      ),
    ),

    // TODO: Add more providers for other features
  ];
}
