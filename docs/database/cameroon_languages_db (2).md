-- Cameroon Traditional Languages Translation Database
-- French to Traditional Languages (Duala, Ewondo, Fulfude, Basaa, Bamileke, etc.)

-- =====================================================
-- DATABASE SCHEMA
-- =====================================================

CREATE DATABASE IF NOT EXISTS cameroon_languages;
USE cameroon_languages;

-- Languages Table
CREATE TABLE languages (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_code VARCHAR(10) UNIQUE NOT NULL,
    language_name VARCHAR(50) NOT NULL,
    language_family VARCHAR(100),
    speakers_count INT,
    region VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Word Categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    category_description VARCHAR(200)
);

-- Main Translations Table
CREATE TABLE translations (
    translation_id INT PRIMARY KEY AUTO_INCREMENT,
    french_word VARCHAR(100) NOT NULL,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    INDEX idx_french_word (french_word)
);

-- Language Specific Translations
CREATE TABLE word_translations (
    word_id INT PRIMARY KEY AUTO_INCREMENT,
    translation_id INT NOT NULL,
    language_id INT NOT NULL,
    translated_word VARCHAR(100) NOT NULL,
    pronunciation VARCHAR(100),
    tone_marks VARCHAR(50),
    audio_file_path VARCHAR(255),
    FOREIGN KEY (translation_id) REFERENCES translations(translation_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id),
    INDEX idx_translation_language (translation_id, language_id)
);

-- Common Phrases Table
CREATE TABLE phrases (
    phrase_id INT PRIMARY KEY AUTO_INCREMENT,
    french_phrase TEXT NOT NULL,
    category_id INT,
    context VARCHAR(200),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Phrase Translations
CREATE TABLE phrase_translations (
    phrase_translation_id INT PRIMARY KEY AUTO_INCREMENT,
    phrase_id INT NOT NULL,
    language_id INT NOT NULL,
    translated_phrase TEXT NOT NULL,
    pronunciation TEXT,
    literal_translation TEXT,
    FOREIGN KEY (phrase_id) REFERENCES phrases(phrase_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

-- =====================================================
-- INSERT LANGUAGE DATA
-- =====================================================

INSERT INTO languages (language_code, language_name, language_family, speakers_count, region) VALUES
('fr', 'Français', 'Romance', 10000000, 'National'),
('dua', 'Duala', 'Bantu', 800000, 'Littoral'),
('ewo', 'Ewondo', 'Bantu', 600000, 'Centre'),
('ful', 'Fulfude', 'Atlantic', 1000000, 'Nord/Adamaoua'),
('bas', 'Basaa', 'Bantu', 300000, 'Littoral/Centre'),
('bam', 'Bamun', 'Grassfields Bantu', 420000, 'Ouest'),
('nso', 'Lamnso', 'Grassfields Bantu', 280000, 'Nord-Ouest'),
('bum', 'Bulu', 'Bantu', 250000, 'Sud'),
('gho', 'Ghomala', 'Grassfields Bantu', 350000, 'Ouest'),
('med', 'Medumba', 'Grassfields Bantu', 300000, 'Ouest');

-- =====================================================
-- INSERT CATEGORIES
-- =====================================================

INSERT INTO categories (category_name, category_description) VALUES
('Salutations', 'Greetings and basic courtesy'),
('Nombres', 'Numbers and counting'),
('Famille', 'Family members'),
('Nourriture', 'Food and drinks'),
('Corps', 'Body parts'),
('Temps', 'Time expressions'),
('Nature', 'Nature and environment'),
('Verbes_Communs', 'Common verbs'),
('Adjectifs', 'Common adjectives'),
('Questions', 'Question words'),
('Maison', 'House and home'),
('Transport', 'Transportation'),
('Commerce', 'Trade and commerce'),
('Emotions', 'Feelings and emotions'),
('Couleurs', 'Colors');

-- =====================================================
-- INSERT COMMON WORDS WITH TRANSLATIONS
-- =====================================================

-- SALUTATIONS
INSERT INTO translations (french_word, category_id) VALUES
('Bonjour', 1),
('Bonsoir', 1),
('Merci', 1),
('S''il vous plaît', 1),
('Pardon', 1),
('Au revoir', 1),
('Oui', 1),
('Non', 1),
('Comment allez-vous?', 1),
('Bienvenue', 1);

-- Insert Duala translations for greetings
INSERT INTO word_translations (translation_id, language_id, translated_word, pronunciation) VALUES
(1, 2, 'Idiba', 'ee-dee-bah'),
(1, 2, 'Bwam bwa', 'bwahm bwah'),
(2, 2, 'Buya', 'boo-yah'),
(3, 2, 'Na si', 'nah see'),
(4, 2, 'Mbole', 'm-boh-leh'),
(5, 2, 'Sori', 'soh-ree'),
(6, 2, 'Na la o', 'nah lah oh'),
(7, 2, 'Ee', 'eh-eh'),
(8, 2, 'To', 'toh'),
(9, 2, 'O nja?', 'oh n-jah'),
(10, 2, 'Musango', 'moo-sahn-goh');

-- Insert Ewondo translations for greetings
INSERT INTO word_translations (translation_id, language_id, translated_word, pronunciation) VALUES
(1, 3, 'Mbolo', 'm-boh-loh'),
(2, 3, 'Wuna nga', 'woo-nah n-gah'),
(3, 3, 'Akiba', 'ah-kee-bah'),
(4, 3, 'Ta abe', 'tah ah-beh'),
(5, 3, 'Dulu', 'doo-loo'),
(6, 3, 'Ke a dulu', 'keh ah doo-loo'),
(7, 3, 'Oë', 'oh-eh'),
(8, 3, 'Kak', 'kahk'),
(9, 3, 'O ne ya?', 'oh neh yah'),
(10, 3, 'Aboui', 'ah-boo-ee');

-- Insert Fulfude translations for greetings
INSERT INTO word_translations (translation_id, language_id, translated_word, pronunciation) VALUES
(1, 4, 'Jam na', 'jahm nah'),
(1, 4, 'Jam waali', 'jahm wah-lee'),
(2, 4, 'Jam hiiri', 'jahm hee-ree'),
(3, 4, 'A jaraama', 'ah jah-rah-mah'),
(4, 4, 'Alkuleeri', 'ahl-koo-leh-ree'),
(5, 4, 'Yaafoo', 'yah-foo'),
(6, 4, 'Sey yeeso', 'say yeh-soh'),
(7, 4, 'Eey', 'eh-ey'),
(8, 4, 'Alaa', 'ah-lah'),
(9, 4, 'No mbiyete?', 'noh m-bee-yeh-teh'),
(10, 4, 'Jam tan', 'jahm tahn');

-- NUMBERS
INSERT INTO translations (french_word, category_id) VALUES
('Un/Une', 2),
('Deux', 2),
('Trois', 2),
('Quatre', 2),
('Cinq', 2),
('Six', 2),
('Sept', 2),
('Huit', 2),
('Neuf', 2),
('Dix', 2);

-- Duala numbers
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(11, 2, 'Ewom'),
(12, 2, 'Bebá'),
(13, 2, 'Belalo'),
(14, 2, 'Benei'),
(15, 2, 'Betan'),
(16, 2, 'Mutoba'),
(17, 2, 'Samba'),
(18, 2, 'Lombe'),
(19, 2, 'Dibua'),
(20, 2, 'Diom');

-- Ewondo numbers
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(11, 3, 'Fok'),
(12, 3, 'Bae'),
(13, 3, 'Lae'),
(14, 3, 'Nye'),
(15, 3, 'Tan'),
(16, 3, 'Saman'),
(17, 3, 'Zamgbwal'),
(18, 3, 'Mwom'),
(19, 3, 'Ebul'),
(20, 3, 'Awom');

-- Fulfude numbers
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(11, 4, 'Gootol'),
(12, 4, 'Didi'),
(13, 4, 'Tati'),
(14, 4, 'Nayi'),
(15, 4, 'Joyi'),
(16, 4, 'Jeegom'),
(17, 4, 'Jeedidi'),
(18, 4, 'Jeetati'),
(19, 4, 'Jeenayi'),
(20, 4, 'Sappo');

-- FAMILY
INSERT INTO translations (french_word, category_id) VALUES
('Père', 3),
('Mère', 3),
('Enfant', 3),
('Fils', 3),
('Fille', 3),
('Frère', 3),
('Soeur', 3),
('Grand-père', 3),
('Grand-mère', 3),
('Oncle', 3);

-- Duala family terms
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(21, 2, 'Papa'),
(22, 2, 'Mama'),
(23, 2, 'Muna'),
(24, 2, 'Muna mume'),
(25, 2, 'Muna mwala'),
(26, 2, 'Ndomi na mume'),
(27, 2, 'Ndomi na mwala'),
(28, 2, 'Nkukuma'),
(29, 2, 'Mama mukulu'),
(30, 2, 'Toko');

-- Ewondo family terms
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(21, 3, 'Tare'),
(22, 3, 'Nya'),
(23, 3, 'Mon'),
(24, 3, 'Mon fam'),
(25, 3, 'Mon minga'),
(26, 3, 'Ndom mod'),
(27, 3, 'Kal minga'),
(28, 3, 'Tare mben'),
(29, 3, 'Nya mben'),
(30, 3, 'Nnom tare');

-- FOOD
INSERT INTO translations (french_word, category_id) VALUES
('Eau', 4),
('Pain', 4),
('Riz', 4),
('Viande', 4),
('Poisson', 4),
('Légume', 4),
('Fruit', 4),
('Sel', 4),
('Huile', 4),
('Manioc', 4);

-- Duala food terms
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(31, 2, 'Madiba'),
(32, 2, 'Mukate'),
(33, 2, 'Loso'),
(34, 2, 'Nyama'),
(35, 2, 'Su'),
(36, 2, 'Ndian'),
(37, 2, 'Buma'),
(38, 2, 'Ngwa'),
(39, 2, 'Manya'),
(40, 2, 'Mintoumba');

-- Ewondo food terms
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(31, 3, 'Mendim'),
(32, 3, 'Fufu'),
(33, 3, 'Ndongo'),
(34, 3, 'Tit'),
(35, 3, 'Kos'),
(36, 3, 'Bifok'),
(37, 3, 'Asa'),
(38, 3, 'Si'),
(39, 3, 'Mbal'),
(40, 3, 'Mboong');

-- BODY PARTS
INSERT INTO translations (french_word, category_id) VALUES
('Tête', 5),
('Main', 5),
('Pied', 5),
('Oeil', 5),
('Bouche', 5),
('Nez', 5),
('Oreille', 5),
('Coeur', 5),
('Ventre', 5),
('Dos', 5);

-- Duala body parts
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(41, 2, 'Mutu'),
(42, 2, 'Dia'),
(43, 2, 'Mwenge'),
(44, 2, 'Diso'),
(45, 2, 'Mudumbu'),
(46, 2, 'Dipeo'),
(47, 2, 'Ditoi'),
(48, 2, 'Mulema'),
(49, 2, 'Dibum'),
(50, 2, 'Mukongo');

-- Ewondo body parts
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(41, 3, 'Nlo'),
(42, 3, 'Wo'),
(43, 3, 'Abo'),
(44, 3, 'Dis'),
(45, 3, 'Anyu'),
(46, 3, 'Dzu'),
(47, 3, 'Atu'),
(48, 3, 'Nlem'),
(49, 3, 'Abum'),
(50, 3, 'Mvus');

-- COMMON VERBS
INSERT INTO translations (french_word, category_id) VALUES
('Manger', 8),
('Boire', 8),
('Dormir', 8),
('Marcher', 8),
('Parler', 8),
('Voir', 8),
('Entendre', 8),
('Venir', 8),
('Aller', 8),
('Faire', 8);

-- Duala verbs
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(51, 2, 'Dia'),
(52, 2, 'Nwa'),
(53, 2, 'Nongo'),
(54, 2, 'Enda'),
(55, 2, 'Tuba'),
(56, 2, 'Ena'),
(57, 2, 'Oka'),
(58, 2, 'Powa'),
(59, 2, 'Ala'),
(60, 2, 'Bola');

-- Ewondo verbs
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(51, 3, 'Di'),
(52, 3, 'Nyu'),
(53, 3, 'Wo'),
(54, 3, 'Wulu'),
(55, 3, 'Kobe'),
(56, 3, 'Yen'),
(57, 3, 'Og'),
(58, 3, 'So'),
(59, 3, 'Ke'),
(60, 3, 'Bo');

-- COLORS
INSERT INTO translations (french_word, category_id) VALUES
('Blanc', 15),
('Noir', 15),
('Rouge', 15),
('Bleu', 15),
('Vert', 15),
('Jaune', 15),
('Orange', 15),
('Marron', 15);

-- Duala colors
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(61, 2, 'Pembe'),
(62, 2, 'Etititi'),
(63, 2, 'Bwea'),
(64, 2, 'Bulu'),
(65, 2, 'Pia'),
(66, 2, 'Yelo'),
(67, 2, 'Oranji'),
(68, 2, 'Maron');

-- Ewondo colors
INSERT INTO word_translations (translation_id, language_id, translated_word) VALUES
(61, 3, 'Afub'),
(62, 3, 'Evindi'),
(63, 3, 'Ekui'),
(64, 3, 'Mbalu'),
(65, 3, 'Ayon'),
(66, 3, 'Osoe'),
(67, 3, 'Osoe ekui'),
(68, 3, 'Abum si');

-- =====================================================
-- INSERT COMMON PHRASES
-- =====================================================

INSERT INTO phrases (french_phrase, category_id, context) VALUES
('Comment vous appelez-vous?', 1, 'Introduction'),
('Je m''appelle...', 1, 'Introduction'),
('D''où venez-vous?', 1, 'Introduction'),
('Je viens de...', 1, 'Introduction'),
('Quel âge avez-vous?', 1, 'Personal'),
('J''ai ... ans', 1, 'Personal'),
('Où allez-vous?', 1, 'Direction'),
('Je vais à...', 1, 'Direction'),
('Combien ça coûte?', 13, 'Shopping'),
('C''est trop cher', 13, 'Shopping'),
('Donnez-moi...', 13, 'Shopping'),
('J''ai faim', 4, 'Needs'),
('J''ai soif', 4, 'Needs'),
('Je suis fatigué', 14, 'Feelings'),
('Je suis content', 14, 'Feelings'),
('Je ne comprends pas', 1, 'Communication'),
('Parlez-vous français?', 1, 'Communication'),
('Aidez-moi', 1, 'Help'),
('Où est...?', 1, 'Direction'),
('À quelle heure?', 6, 'Time');

-- Duala phrase translations
INSERT INTO phrase_translations (phrase_id, language_id, translated_phrase, literal_translation) VALUES
(1, 2, 'Nde dina lao?', 'What name yours?'),
(2, 2, 'Dina lam nde...', 'Name mine is...'),
(3, 2, 'O sodi oi?', 'You come where?'),
(4, 2, 'Na sodi...', 'I come...'),
(5, 2, 'O si myaka mea?', 'You have years how many?'),
(6, 2, 'Na si myaka...', 'I have years...'),
(7, 2, 'O ma ala oi?', 'You will go where?'),
(8, 2, 'Na ma ala o...', 'I will go to...'),
(9, 2, 'E wusi mbongo mea?', 'It costs money how much?'),
(10, 2, 'E wusi ndedi', 'It costs much'),
(11, 2, 'Bola nam...', 'Give me...'),
(12, 2, 'Nja e nyang na', 'Hunger is killing me'),
(13, 2, 'Madiba ma nyang na', 'Water is killing me'),
(14, 2, 'Na lembi', 'I tired'),
(15, 2, 'Mulema mwam mu enga', 'Heart mine is happy'),
(16, 2, 'Na si biya te', 'I have understanding not'),
(17, 2, 'O tubi français?', 'You speak French?'),
(18, 2, 'Dima na', 'Help me'),
(19, 2, 'Wea?', 'Where?'),
(20, 2, 'Wenge mbu?', 'Time which?');

-- Ewondo phrase translations
INSERT INTO phrase_translations (phrase_id, language_id, translated_phrase, literal_translation) VALUES
(1, 3, 'Wa yem dze?', 'You call what?'),
(2, 3, 'Ma yem...', 'I call...'),
(3, 3, 'O to ve?', 'You from where?'),
(4, 3, 'Ma to...', 'I from...'),
(5, 3, 'O bele mbu?', 'You have years how many?'),
(6, 3, 'Ma bele mbu...', 'I have years...'),
(7, 3, 'O ke ve?', 'You go where?'),
(8, 3, 'Ma ke...', 'I go...'),
(9, 3, 'E ne akui?', 'It is how much?'),
(10, 3, 'E ne ngan', 'It is expensive'),
(11, 3, 'Volan ma...', 'Give me...'),
(12, 3, 'Zeng i nye ma', 'Hunger has me'),
(13, 3, 'Mendim me wog ma', 'Water wants me'),
(14, 3, 'Ma kube mod', 'I tired person'),
(15, 3, 'Nlem wam u ne mven', 'Heart mine is good'),
(16, 3, 'Ma wog ki', 'I hear not'),
(17, 3, 'O kobe français?', 'You speak French?'),
(18, 3, 'Voele ma', 'Help me'),
(19, 3, 'Ve?', 'Where?'),
(20, 3, 'Awola dze?', 'Hour what?');

-- Fulfude phrase translations  
INSERT INTO phrase_translations (phrase_id, language_id, translated_phrase, literal_translation) VALUES
(1, 4, 'No mbiyete daa?', 'You called what?'),
(2, 4, 'Miin ind-mi...', 'I name mine...'),
(3, 4, 'Hol to njahata?', 'Where from you come?'),
(4, 4, 'Mi yahi to...', 'I come from...'),
(5, 4, 'Duubi ma njoni?', 'Years yours how many?'),
(6, 4, 'Mi dunya duubi...', 'I have years...'),
(7, 4, 'Hol to njaha?', 'Where to you go?'),
(8, 4, 'Mi yaha to...', 'I go to...'),
(9, 4, 'Noy foti?', 'How much cost?'),
(10, 4, 'Ina boodi', 'It much'),
(11, 4, 'Hokku am...', 'Give me...'),
(12, 4, 'Peeku nani', 'Hunger has me'),
(13, 4, 'Yoore nani', 'Thirst has me'),
(14, 4, 'Mi tampi', 'I tired'),
(15, 4, 'Mi welti', 'I happy'),
(16, 4, 'Mi fahamaaki', 'I understand not'),
(17, 4, 'A haala français?', 'You speak French?'),
(18, 4, 'Walle am', 'Help me'),
(19, 4, 'To hol?', 'To where?'),
(20, 4, 'Sahaa man?', 'Hour which?');

-- =====================================================
-- CREATE VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for complete word translations
CREATE VIEW complete_word_translations AS
SELECT 
    t.french_word,
    c.category_name,
    l.language_name,
    wt.translated_word,
    wt.pronunciation
FROM translations t
JOIN word_translations wt ON t.translation_id = wt.translation_id
JOIN languages l ON wt.language_id = l.language_id
LEFT JOIN categories c ON t.category_id = c.category_id
ORDER BY t.french_word, l.language_name;

-- View for phrase translations
CREATE VIEW complete_phrase_translations AS
SELECT 
    p.french_phrase,
    p.context,
    l.language_name,
    pt.translated_phrase,
    pt.literal_translation
FROM phrases p
JOIN phrase_translations pt ON p.phrase_id = pt.phrase_id
JOIN languages l ON pt.language_id = l.language_id
ORDER BY p.phrase_id, l.language_name;

-- =====================================================
-- SAMPLE QUERIES
-- =====================================================

-- Get all Duala translations
-- SELECT * FROM complete_word_translations WHERE language_name = 'Duala';

-- Get greetings in all languages
-- SELECT * FROM complete_word_translations WHERE category_name = 'Salutations';

-- Get a specific word in all languages
-- SELECT * FROM complete_word_translations WHERE french_word = 'Bonjour';

-- Get all phrases in Ewondo
-- SELECT * FROM complete_phrase_translations WHERE language_name = 'Ewondo';

-- Count translations per language
-- SELECT l.language_name, COUNT(wt.word_id) as translation_count
-- FROM languages l
-- LEFT JOIN word_translations wt ON l.language_id = wt.language_id
-- GROUP BY l.language_name
-- ORDER BY translation_count DESC;