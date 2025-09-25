
/// Modèle pour gérer les abonnements aux langues
class LangueAbonnement {
  final String langueId;        // ID ou nom de la langue
  final String niveau;          // Niveau de l’apprenant : Débutant, Intermédiaire, Avancé
  final DateTime? gratuitJusquA; // Date jusqu'à laquelle l’accès est gratuit
  final bool actif;             // Si l’abonnement est actif ou non

  LangueAbonnement({
    required this.langueId,
    this.niveau = 'Débutant',
    this.gratuitJusquA,
    this.actif = true,
  });

  /// Convertit un Map Firestore en LangueAbonnement
  factory LangueAbonnement.fromMap(Map<String, dynamic> map) {
    return LangueAbonnement(
      langueId: map['langueId'] ?? 'inconnu',
      niveau: map['niveau'] ?? 'Débutant',
      gratuitJusquA: map['gratuitJusquA'] != null
          ? DateTime.parse(map['gratuitJusquA'])
          : null,
      actif: map['actif'] ?? true,
    );
  }

  /// Convertit l’objet en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'langueId': langueId,
      'niveau': niveau,
      'gratuitJusquA': gratuitJusquA?.toIso8601String(),
      'actif': actif,
    };
  }

  /// Vérifie si l’utilisateur a encore accès gratuit à la langue
  bool hasAccess() {
    if (!actif) return false;
    if (gratuitJusquA == null) return true; // accès illimité si null
    return DateTime.now().isBefore(gratuitJusquA!);
  }

  /// Mise à jour du niveau
  LangueAbonnement copyWith({String? niveau, DateTime? gratuitJusquA, bool? actif}) {
    return LangueAbonnement(
      langueId: langueId,
      niveau: niveau ?? this.niveau,
      gratuitJusquA: gratuitJusquA ?? this.gratuitJusquA,
      actif: actif ?? this.actif,
    );
  }

  @override
  String toString() {
    return 'LangueAbonnement(langueId: $langueId, niveau: $niveau, gratuitJusquA: $gratuitJusquA, actif: $actif)';
  }
}
