# Dictionary Module Deprecation Notice

## Status: DEPRECATED

The original dictionary module has been **DEPRECATED** in favor of the new canonical lexicon system.

## Migration Path

### Deprecated Components
- `DictionaryRepository` → Use `LexiconRepository`
- `DictionaryRemoteDataSource` → Use `LexiconRemoteDataSource`
- `DictionaryLocalDataSource` → Use `LexiconLocalDataSource`
- `WordModel`, `TranslationModel`, `PronunciationModel` → Use `DictionaryEntryModel`
- `WordEntity`, `TranslationEntity`, `PronunciationEntity` → Use `DictionaryEntryEntity`

### New Canonical System Benefits
1. **Unified Data Model**: Single `DictionaryEntryModel` replaces multiple fragmented models
2. **AI Integration**: Built-in support for AI-generated content and review workflows
3. **Offline-First**: Complete offline synchronization with conflict resolution
4. **Rich Metadata**: Support for quality scores, review status, contributors, and more
5. **Scalable Architecture**: Designed for 6+ languages with extensible structure

### Migration Tools
Use `DictionaryMigration.migrateWordModel()` to convert legacy data:

```dart
// Legacy
final wordModel = WordModel(...);
final translations = <TranslationModel>[...];

// Convert to new canonical format
final dictionaryEntry = DictionaryMigration.migrateWordModel(wordModel, translations);
```

### Timeline
- ✅ **Phase 1**: New canonical system implemented
- ✅ **Phase 2**: Migration utilities created
- 🚧 **Phase 3**: Gradual deprecation warnings (current)
- ⏳ **Phase 4**: Remove deprecated components (next release)

### Action Required
1. **Developers**: Update imports to use `LexiconRepository` instead of `DictionaryRepository`
2. **Data Migration**: Run migration scripts to convert existing data
3. **Testing**: Verify functionality with new canonical system

## Files to be Removed
- `lib/features/dictionary/data/datasources/dictionary_remote_datasource.dart`
- `lib/features/dictionary/data/datasources/dictionary_local_datasource.dart`
- `lib/features/dictionary/data/repositories/dictionary_repository_impl.dart`
- `lib/features/dictionary/domain/repositories/dictionary_repository.dart`
- `lib/features/dictionary/data/models/word_model.dart`
- `lib/features/dictionary/data/models/translation_model.dart`
- `lib/features/dictionary/data/models/pronunciation_model.dart`
- `lib/features/dictionary/domain/entities/word_entity.dart`
- `lib/features/dictionary/domain/entities/translation_entity.dart`
- `lib/features/dictionary/domain/entities/pronunciation_entity.dart`

## Contact
For migration support or questions, please refer to the implementation team.