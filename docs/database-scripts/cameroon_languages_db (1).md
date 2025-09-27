# Cameroon Traditional Languages Database

## Database Schema (SQL Structure)

### 1. Languages Table
```sql
CREATE TABLE languages (
    language_id VARCHAR(10) PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL,
    language_family VARCHAR(100),
    region VARCHAR(50),
    speakers_count INT,
    description TEXT,
    iso_code VARCHAR(10)
);

INSERT INTO languages VALUES
('EWO', 'Ewondo', 'Beti-Pahuin (Bantu)', 'Central Region', 577000, 'Principal language of the Beti people, widely spoken in Yaoundé', 'ewo'),
('DUA', 'Duala', 'Coastal Bantu', 'Littoral Region', 300000, 'Historic trading language of the coast', 'dua'),
('FEF', 'Fe''efe''e', 'Grassfields (Bamileke)', 'West Region', 200000, 'Language of the Bafang area', 'fef'),
('FUL', 'Fulfulde', 'Niger-Congo (Atlantic)', 'North Region', 1500000, 'Language of the Fulani people', 'ful'),
('BAS', 'Bassa', 'A40 Bantu', 'Central-Littoral', 230000, 'Language of the Bassa people', 'bas'),
('BAM', 'Bamum', 'Grassfields', 'West Region', 215000, 'Language with its own indigenous script', 'bax');
```

### 2. Categories Table
```sql
CREATE TABLE categories (
    category_id VARCHAR(10) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

INSERT INTO categories VALUES
('GRT', 'Greetings', 'Basic greetings and polite expressions'),
('NUM', 'Numbers', 'Cardinal and ordinal numbers'),
('FAM', 'Family', 'Family members and relationships'),
('FOD', 'Food', 'Food items and cooking terms'),
('BOD', 'Body', 'Body parts and health'),
('TIM', 'Time', 'Time expressions, days, months'),
('COL', 'Colors', 'Color names'),
('ANI', 'Animals', 'Animals and wildlife'),
('NAT', 'Nature', 'Natural elements, weather'),
('VRB', 'Verbs', 'Common action words'),
('ADJ', 'Adjectives', 'Descriptive words'),
('PHR', 'Phrases', 'Common phrases and expressions');
```

### 3. Translations Table
```sql
CREATE TABLE translations (
    translation_id INT PRIMARY KEY AUTO_INCREMENT,
    french_text TEXT NOT NULL,
    language_id VARCHAR(10),
    translation TEXT NOT NULL,
    category_id VARCHAR(10),
    pronunciation TEXT,
    usage_notes TEXT,
    difficulty_level ENUM('beginner', 'intermediate', 'advanced'),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (language_id) REFERENCES languages(language_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
```

## Sample Data

### Greetings and Basic Expressions

```sql
-- Ewondo Greetings
INSERT INTO translations (french_text, language_id, translation, category_id, pronunciation, difficulty_level) VALUES
('Bonjour', 'EWO', 'Mbolo', 'GRT', 'mm-BOH-loh', 'beginner'),
('Bonsoir', 'EWO', 'Mbolo', 'GRT', 'mm-BOH-loh', 'beginner'),
('Comment allez-vous?', 'EWO', 'Mbolo woe?', 'GRT', 'mm-BOH-loh woh-eh', 'beginner'),
('Merci', 'EWO', 'Akiba', 'GRT', 'ah-KEE-bah', 'beginner'),
('Au revoir', 'EWO', 'Ka yen asu', 'GRT', 'kah yehn ah-SOO', 'beginner'),
('Excuse-moi', 'EWO', 'Ma yem ve', 'GRT', 'mah yehm veh', 'beginner'),

-- Duala Greetings
('Bonjour', 'DUA', 'Mwa boma', 'GRT', 'mwah BOH-mah', 'beginner'),
('Bonsoir', 'DUA', 'Mwa munyenge', 'GRT', 'mwah moon-YEHN-geh', 'beginner'),
('Comment allez-vous?', 'DUA', 'Mwa boma na nde?', 'GRT', 'mwah BOH-mah nah n-deh', 'beginner'),
('Merci', 'DUA', 'Masa', 'GRT', 'MAH-sah', 'beginner'),
('Au revoir', 'DUA', 'Wese', 'GRT', 'WEH-seh', 'beginner'),

-- Fe'efe'e Greetings
('Bonjour', 'FEF', 'Kweni', 'GRT', 'KWEH-nee', 'beginner'),
('Merci', 'FEF', 'Ndongui', 'GRT', 'n-DOHN-gwee', 'beginner'),
('Au revoir', 'FEF', 'Ko''a ntsie', 'GRT', 'koh-ah n-TSEE-eh', 'beginner'),

-- Fulfulde Greetings
('Bonjour', 'FUL', 'Jam waali', 'GRT', 'jahm WAH-lee', 'beginner'),
('Bonsoir', 'FUL', 'Jam mayra', 'GRT', 'jahm MY-rah', 'beginner'),
('Comment allez-vous?', 'FUL', 'Jam tan?', 'GRT', 'jahm tahn', 'beginner'),
('Merci', 'FUL', 'Jarama', 'GRT', 'jah-RAH-mah', 'beginner'),
('Au revoir', 'FUL', 'Selaamaleykum', 'GRT', 'seh-lah-ah-mah-LAY-koom', 'beginner'),

-- Bassa Greetings
('Bonjour', 'BAS', 'Mbolo', 'GRT', 'mm-BOH-loh', 'beginner'),
('Merci', 'BAS', 'Nyango', 'GRT', 'NYAHN-goh', 'beginner'),
('Au revoir', 'BAS', 'Ka nganda', 'GRT', 'kah n-GAHN-dah', 'beginner'),

-- Bamum Greetings
('Bonjour', 'BAM', 'Nshie', 'GRT', 'n-SHEE-eh', 'beginner'),
('Merci', 'BAM', 'Numeni', 'GRT', 'noo-MEH-nee', 'beginner'),
('Au revoir', 'BAM', 'Ka ben', 'GRT', 'kah behn', 'beginner');
```

### Numbers (1-10)

```sql
-- Ewondo Numbers
INSERT INTO translations (french_text, language_id, translation, category_id, pronunciation, difficulty_level) VALUES
('un', 'EWO', 'fok', 'NUM', 'fohk', 'beginner'),
('deux', 'EWO', 'iba', 'NUM', 'ee-BAH', 'beginner'),
('trois', 'EWO', 'ilal', 'NUM', 'ee-LAHL', 'beginner'),
('quatre', 'EWO', 'inai', 'NUM', 'ee-NAH-ee', 'beginner'),
('cinq', 'EWO', 'itan', 'NUM', 'ee-TAHN', 'beginner'),
('six', 'EWO', 'isamaan', 'NUM', 'ee-sah-MAHN', 'beginner'),
('sept', 'EWO', 'isambaal', 'NUM', 'ee-sahm-BAHL', 'beginner'),
('huit', 'EWO', 'mfom', 'NUM', 'mm-FOHM', 'beginner'),
('neuf', 'EWO', 'evus', 'NUM', 'eh-VOOS', 'beginner'),
('dix', 'EWO', 'awom', 'NUM', 'ah-WOHM', 'beginner'),

-- Duala Numbers
('un', 'DUA', 'mosi', 'NUM', 'MOH-see', 'beginner'),
('deux', 'DUA', 'maba', 'NUM', 'mah-BAH', 'beginner'),
('trois', 'DUA', 'malalo', 'NUM', 'mah-LAH-loh', 'beginner'),
('quatre', 'DUA', 'manei', 'NUM', 'mah-NEH-ee', 'beginner'),
('cinq', 'DUA', 'matan', 'NUM', 'mah-TAHN', 'beginner'),
('six', 'DUA', 'motoba', 'NUM', 'moh-TOH-bah', 'beginner'),
('sept', 'DUA', 'nsamba', 'NUM', 'n-SAHM-bah', 'beginner'),
('huit', 'DUA', 'mwambe', 'NUM', 'mwahm-BEH', 'beginner'),
('neuf', 'DUA', 'libua', 'NUM', 'lee-BOO-ah', 'beginner'),
('dix', 'DUA', 'duom', 'NUM', 'DOO-ohm', 'beginner'),

-- Fulfulde Numbers
('un', 'FUL', 'goto', 'NUM', 'GOH-toh', 'beginner'),
('deux', 'FUL', 'didi', 'NUM', 'DEE-dee', 'beginner'),
('trois', 'FUL', 'tati', 'NUM', 'TAH-tee', 'beginner'),
('quatre', 'FUL', 'nayi', 'NUM', 'NAH-yee', 'beginner'),
('cinq', 'FUL', 'jowi', 'NUM', 'JOH-wee', 'beginner'),
('six', 'FUL', 'jeegom', 'NUM', 'JEH-eh-gohm', 'beginner'),
('sept', 'FUL', 'jeeditati', 'NUM', 'jeh-eh-dee-TAH-tee', 'beginner'),
('huit', 'FUL', 'jeetati', 'NUM', 'jeh-eh-TAH-tee', 'beginner'),
('neuf', 'FUL', 'jeenayi', 'NUM', 'jeh-eh-NAH-yee', 'beginner'),
('dix', 'FUL', 'sappo', 'NUM', 'SAHP-poh', 'beginner');
```

### Family Members

```sql
-- Family in Ewondo
INSERT INTO translations (french_text, language_id, translation, category_id, pronunciation, difficulty_level) VALUES
('père', 'EWO', 'tara', 'FAM', 'TAH-rah', 'beginner'),
('mère', 'EWO', 'nga', 'FAM', 'n-GAH', 'beginner'),
('fils', 'EWO', 'moan minga', 'FAM', 'moh-AHN mee-n-GAH', 'beginner'),
('fille', 'EWO', 'moan minga', 'FAM', 'moh-AHN mee-n-GAH', 'beginner'),
('frère', 'EWO', 'nkuu', 'FAM', 'n-KOO', 'beginner'),
('sœur', 'EWO', 'mbok', 'FAM', 'mm-BOHK', 'beginner'),
('grand-père', 'EWO', 'nkukuma', 'FAM', 'n-koo-KOO-mah', 'beginner'),
('grand-mère', 'EWO', 'nnemekukuma', 'FAM', 'n-neh-meh-koo-KOO-mah', 'beginner'),

-- Family in Duala
('père', 'DUA', 'tata', 'FAM', 'TAH-tah', 'beginner'),
('mère', 'DUA', 'mama', 'FAM', 'MAH-mah', 'beginner'),
('fils', 'DUA', 'mwana ma mutu', 'FAM', 'mwah-nah mah moo-TOO', 'beginner'),
('fille', 'DUA', 'mwana ma mutu', 'FAM', 'mwah-nah mah moo-TOO', 'beginner'),
('frère', 'DUA', 'kaka', 'FAM', 'KAH-kah', 'beginner'),
('sœur', 'DUA', 'mba', 'FAM', 'mm-BAH', 'beginner'),

-- Family in Fulfulde
('père', 'FUL', 'baaba', 'FAM', 'BAH-bah', 'beginner'),
('mère', 'FUL', 'yaaya', 'FAM', 'YAH-yah', 'beginner'),
('fils', 'FUL', 'bii''do', 'FAM', 'bee-DOH', 'beginner'),
('fille', 'FUL', 'deb''ere', 'FAM', 'deh-BEH-reh', 'beginner'),
('frère', 'FUL', 'ka''o', 'FAM', 'kah-OH', 'beginner'),
('sœur', 'FUL', 'mba''ru', 'FAM', 'mm-BAH-roo', 'beginner');
```

### Food and Drinks

```sql
-- Food in Ewondo
INSERT INTO translations (french_text, language_id, translation, category_id, pronunciation, difficulty_level) VALUES
('eau', 'EWO', 'mam', 'FOD', 'mahm', 'beginner'),
('nourriture', 'EWO', 'bidi', 'FOD', 'BEE-dee', 'beginner'),
('viande', 'EWO', 'nyama', 'FOD', 'NYAH-mah', 'beginner'),
('poisson', 'EWO', 'som', 'FOD', 'sohm', 'beginner'),
('légumes', 'EWO', 'nduma', 'FOD', 'n-DOO-mah', 'beginner'),
('banane', 'EWO', 'kaba', 'FOD', 'KAH-bah', 'beginner'),
('manioc', 'EWO', 'mbong', 'FOD', 'mm-BOHN', 'beginner'),
('riz', 'EWO', 'malaa', 'FOD', 'mah-LAH', 'beginner'),

-- Food in Duala
('eau', 'DUA', 'mema', 'FOD', 'MEH-mah', 'beginner'),
('nourriture', 'DUA', 'bele', 'FOD', 'BEH-leh', 'beginner'),
('viande', 'DUA', 'nyama', 'FOD', 'NYAH-mah', 'beginner'),
('poisson', 'DUA', 'mba', 'FOD', 'mm-BAH', 'beginner'),
('banane', 'DUA', 'kondo', 'FOD', 'KOHN-doh', 'beginner'),
('manioc', 'DUA', 'miondo', 'FOD', 'mee-OHN-doh', 'beginner'),

-- Food in Fulfulde
('eau', 'FUL', 'ndiyam', 'FOD', 'n-DEE-yahm', 'beginner'),
('nourriture', 'FUL', 'yiiyam', 'FOD', 'YEE-yahm', 'beginner'),
('viande', 'FUL', 'nebbe', 'FOD', 'NEH-beh', 'beginner'),
('lait', 'FUL', 'kosam', 'FOD', 'KOH-sahm', 'beginner'),
('mil', 'FUL', 'gawri', 'FOD', 'GAH-wree', 'beginner');
```

### Common Phrases

```sql
-- Common phrases in Ewondo
INSERT INTO translations (french_text, language_id, translation, category_id, pronunciation, difficulty_level) VALUES
('Je ne comprends pas', 'EWO', 'Ma si nkoboo te', 'PHR', 'mah see n-koh-BOH teh', 'intermediate'),
('Où est...?', 'EWO', 'Woe ve...?', 'PHR', 'woh-eh veh', 'intermediate'),
('Combien ça coûte?', 'EWO', 'A nkom mbeni?', 'PHR', 'ah n-kohm mm-BEH-nee', 'intermediate'),
('Je m''appelle...', 'EWO', 'Ma yili...', 'PHR', 'mah YEE-lee', 'intermediate'),
('Parlez-vous français?', 'EWO', 'Ou kala ndaman Fala?', 'PHR', 'oo KAH-lah n-dah-mahn FAH-lah', 'intermediate'),

-- Common phrases in Duala
('Je ne comprends pas', 'DUA', 'Na soma te', 'PHR', 'nah SOH-mah teh', 'intermediate'),
('Où est...?', 'DUA', 'Wapi...?', 'PHR', 'WAH-pee', 'intermediate'),
('Combien ça coûte?', 'DUA', 'Mbama ngando?', 'PHR', 'mm-BAH-mah n-GAHN-doh', 'intermediate'),
('Je m''appelle...', 'DUA', 'Ndina nyam na...', 'PHR', 'n-DEE-nah nyahm nah', 'intermediate'),

-- Common phrases in Fulfulde
('Je ne comprends pas', 'FUL', 'Mi famaani', 'PHR', 'mee fah-MAH-nee', 'intermediate'),
('Où est...?', 'FUL', 'Anto...?', 'PHR', 'AHN-toh', 'intermediate'),
('Combien ça coûte?', 'FUL', 'Noy foti?', 'PHR', 'noy FOH-tee', 'intermediate'),
('Je m''appelle...', 'FUL', 'Innde am ko...', 'PHR', 'ee-n-DEH ahm koh', 'intermediate');
```

### Colors

```sql
-- Colors in Ewondo
INSERT INTO translations (french_text, language_id, translation, category_id, pronunciation, difficulty_level) VALUES
('rouge', 'EWO', 'bibuk', 'COL', 'bee-BOOK', 'beginner'),
('blanc', 'EWO', 'fum', 'COL', 'foom', 'beginner'),
('noir', 'EWO', 'mvie', 'COL', 'mm-VEE-eh', 'beginner'),
('vert', 'EWO', 'esu', 'COL', 'eh-SOO', 'beginner'),
('bleu', 'EWO', 'belu', 'COL', 'BEH-loo', 'beginner'),
('jaune', 'EWO', 'bola', 'COL', 'BOH-lah', 'beginner'),

-- Colors in Duala
('rouge', 'DUA', 'nene', 'COL', 'NEH-neh', 'beginner'),
('blanc', 'DUA', 'mpemba', 'COL', 'mm-PEHM-bah', 'beginner'),
('noir', 'DUA', 'binde', 'COL', 'BEE-n-deh', 'beginner'),
('vert', 'DUA', 'kaki', 'COL', 'KAH-kee', 'beginner'),

-- Colors in Fulfulde
('rouge', 'FUL', 'boodeejo', 'COL', 'boh-DEH-joh', 'beginner'),
('blanc', 'FUL', 'raneeji', 'COL', 'rah-NEH-jee', 'beginner'),
('noir', 'FUL', 'baleejo', 'COL', 'bah-LEH-joh', 'beginner');
```

### Animals

```sql
-- Animals in Ewondo
INSERT INTO translations (french_text, language_id, translation, category_id, pronunciation, difficulty_level) VALUES
('chien', 'EWO', 'mvus', 'ANI', 'mm-VOOS', 'beginner'),
('chat', 'EWO', 'pusi', 'ANI', 'POO-see', 'beginner'),
('éléphant', 'EWO', 'nzog', 'ANI', 'n-ZOHG', 'beginner'),
('lion', 'EWO', 'nkui', 'ANI', 'n-KOO-ee', 'beginner'),
('oiseau', 'EWO', 'non', 'ANI', 'nohn', 'beginner'),
('poule', 'EWO', 'kob', 'ANI', 'kohb', 'beginner'),

-- Animals in Duala
('chien', 'DUA', 'mbwa', 'ANI', 'mm-BWAH', 'beginner'),
('chat', 'DUA', 'paka', 'ANI', 'PAH-kah', 'beginner'),
('éléphant', 'DUA', 'njoku', 'ANI', 'n-JOH-koo', 'beginner'),
('oiseau', 'DUA', 'kake', 'ANI', 'KAH-keh', 'beginner'),

-- Animals in Fulfulde
('chien', 'FUL', 'rawandu', 'ANI', 'rah-WAHN-doo', 'beginner'),
('chat', 'FUL', 'ganyru', 'ANI', 'GAHN-yroo', 'beginner'),
('vache', 'FUL', 'nagge', 'ANI', 'NAHG-geh', 'beginner'),
('chèvre', 'FUL', 'buri', 'ANI', 'BOO-ree', 'beginner'),
('mouton', 'FUL', 'barka', 'ANI', 'BAHR-kah', 'beginner');
```

## NoSQL Structure (MongoDB/JSON)

```json
{
  "languages_database": {
    "languages": [
      {
        "id": "ewo",
        "name": "Ewondo",
        "family": "Beti-Pahuin (Bantu)",
        "region": "Central Region",
        "speakers": 577000,
        "description": "Principal language of the Beti people, widely spoken in Yaoundé",
        "iso_code": "ewo"
      },
      {
        "id": "dua",
        "name": "Duala",
        "family": "Coastal Bantu",
        "region": "Littoral Region",
        "speakers": 300000,
        "description": "Historic trading language of the coast",
        "iso_code": "dua"
      },
      {
        "id": "fef",
        "name": "Fe'efe'e",
        "family": "Grassfields (Bamileke)",
        "region": "West Region",
        "speakers": 200000,
        "description": "Language of the Bafang area",
        "iso_code": "fef"
      },
      {
        "id": "ful",
        "name": "Fulfulde",
        "family": "Niger-Congo (Atlantic)",
        "region": "North Region",
        "speakers": 1500000,
        "description": "Language of the Fulani people",
        "iso_code": "ful"
      },
      {
        "id": "bas",
        "name": "Bassa",
        "family": "A40 Bantu",
        "region": "Central-Littoral",
        "speakers": 230000,
        "description": "Language of the Bassa people",
        "iso_code": "bas"
      },
      {
        "id": "bam",
        "name": "Bamum",
        "family": "Grassfields",
        "region": "West Region",
        "speakers": 215000,
        "description": "Language with its own indigenous script",
        "iso_code": "bax"
      }
    ],
    "translations": {
      "greetings": [
        {
          "french": "Bonjour",
          "translations": {
            "ewo": {
              "text": "Mbolo",
              "pronunciation": "mm-BOH-loh",
              "usage": "Universal greeting for any time of day"
            },
            "dua": {
              "text": "Mwa boma",
              "pronunciation": "mwah BOH-mah",
              "usage": "Morning greeting"
            },
            "fef": {
              "text": "Kweni",
              "pronunciation": "KWEH-nee",
              "usage": "General greeting"
            },
            "ful": {
              "text": "Jam waali",
              "pronunciation": "jahm WAH-lee",
              "usage": "Morning greeting"
            },
            "bas": {
              "text": "Mbolo",
              "pronunciation": "mm-BOH-loh",
              "usage": "General greeting"
            },
            "bam": {
              "text": "Nshie",
              "pronunciation": "n-SHEE-eh",
              "usage": "General greeting"
            }
          }
        },
        {
          "french": "Comment allez-vous?",
          "translations": {
            "ewo": {
              "text": "Mbolo woe?",
              "pronunciation": "mm-BOH-loh woh-eh",
              "usage": "How are you?"
            },
            "dua": {
              "text": "Mwa boma na nde?",
              "pronunciation": "mwah BOH-mah nah n-deh",
              "usage": "How are you doing?"
            },
            "ful": {
              "text": "Jam tan?",
              "pronunciation": "jahm tahn",
              "usage": "How are you?"
            }
          }
        }
      ],
      "numbers": [
        {
          "french": "un",
          "translations": {
            "ewo": { "text": "fok", "pronunciation": "fohk" },
            "dua": { "text": "mosi", "pronunciation": "MOH-see" },
            "ful": { "text": "goto", "pronunciation": "GOH-toh" },
            "bas": { "text": "mosi", "pronunciation": "MOH-see" },
            "bam": { "text": "pāq", "pronunciation": "pahk" }
          }
        },
        {
          "french": "deux",
          "translations": {
            "ewo": { "text": "iba", "pronunciation": "ee-BAH" },
            "dua": { "text": "maba", "pronunciation": "mah-BAH" },
            "ful": { "text": "didi", "pronunciation": "DEE-dee" },
            "bas": { "text": "maba", "pronunciation": "mah-BAH" },
            "bam": { "text": "tū", "pronunciation": "too" }
          }
        }
      ],
      "family": [
        {
          "french": "père",
          "translations": {
            "ewo": { "text": "tara", "pronunciation": "TAH-rah" },
            "dua": { "text": "tata", "pronunciation": "TAH-tah" },
            "ful": { "text": "baaba", "pronunciation": "BAH-bah" },
            "bas": { "text": "tata", "pronunciation": "TAH-tah" },
            "bam": { "text": "pa", "pronunciation": "pah" }
          }
        },
        {
          "french": "mère",
          "translations": {
            "ewo": { "text": "nga", "pronunciation": "n-GAH" },
            "dua": { "text": "mama", "pronunciation": "MAH-mah" },
            "ful": { "text": "yaaya", "pronunciation": "YAH-yah" },
            "bas": { "text": "nya", "pronunciation": "n-YAH" },
            "bam": { "text": "mā", "pronunciation": "mah" }
          }
        }
      ],
      "food": [
        {
          "french": "eau",
          "translations": {
            "ewo": { "text": "mam", "pronunciation": "mahm" },
            "dua": { "text": "mema", "pronunciation": "MEH-mah" },
            "ful": { "text": "ndiyam", "pronunciation": "n-DEE-yahm" },
            "bas": { "text": "mam", "pronunciation": "mahm" },
            "bam": { "text": "fù", "pronunciation": "foo" }
          }
        },
        {
          "french": "nourriture",
          "translations": {
            "ewo": { "text": "bidi", "pronunciation": "BEE-dee" },
            "dua": { "text": "bele", "pronunciation": "BEH-leh" },
            "ful": { "text": "yiiyam", "pronunciation": "YEE-yahm" },
            "bas": { "text": "bilong", "pronunciation": "bee-LOHNG" },
            "bam": { "text": "shù", "pronunciation": "shoo" }
          }
        }
      ],
      "common_phrases": [
        {
          "french": "Je ne comprends pas",
          "translations": {
            "ewo": {
              "text": "Ma si nkoboo te",
              "pronunciation": "mah see n-koh-BOH teh",
              "literal": "I don't understand"
            },
            "dua": {
              "text": "Na soma te",
              "pronunciation": "nah SOH-mah teh",
              "literal": "I don't understand"
            },
            "ful": {
              "text": "Mi famaani",
              "pronunciation": "mee fah-MAH-nee",
              "literal": "I don't understand"
            }
          }
        },
        {
          "french": "Où est...?",
          "translations": {
            "ewo": {
              "text": "Woe ve...?",
              "pronunciation": "woh-eh veh",
              "literal": "Where is...?"
            },
            "dua": {
              "text": "Wapi...?",
              "pronunciation": "WAH-pee",
              "literal": "Where...?"
            },
            "ful": {
              "text": "Anto...?",
              "pronunciation": "AHN-toh",
              "literal": "Where...?"
            }
          }
        }
      ]
    }
  }
}
```

## Database Indexes (for SQL optimization)

```sql
-- Create indexes for better performance
CREATE INDEX idx_translations_language ON translations(language_id);
CREATE INDEX idx_translations_category ON translations(category_id);
CREATE INDEX idx_translations_difficulty ON translations(difficulty_level);
CREATE INDEX idx_translations_french_text ON translations(french_text);
CREATE FULLTEXT INDEX idx_translations_search ON translations(french_text, translation);
```

## API Query Examples

### Get all greetings in Ewondo
```sql
SELECT t.french_text, t.translation, t.pronunciation 
FROM translations t 
JOIN languages l ON t.language_id = l.language_id 
WHERE l.language_name = 'Ewondo' AND t.category_id = 'GRT';
```

### Get beginner level vocabulary for all languages
```sql
SELECT l.language_name, t.french_text, t.translation, t.pronunciation 
FROM translations t 
JOIN languages l ON t.language_id = l.language_id 
WHERE t.difficulty_level = 'beginner' 
ORDER BY l.language_name, t.category_id;
```

### Search for specific French word across all languages
```sql
SELECT l.language_name, t.translation, t.pronunciation 
FROM translations t 
JOIN languages l ON t.language_id = l.language_id 
WHERE t.french_text = 'merci';
```

## Usage Notes

1. **Pronunciation Guide**: 
   - Pronunciations use simplified phonetic spelling
   - Capital letters indicate stressed syllables
   - Double letters indicate longer sounds

2. **Cultural Context**:
   - Many greetings can be used throughout the day
   - Some languages have time-specific greetings
   - Fulfulde includes Islamic influences due to the Fulani's predominantly Muslim culture

3. **Data Accuracy**:
   - This database provides commonly used translations
   - Regional variations may exist
   - Consult native speakers for verification of less common terms

4. **Expandability**:
   - Structure allows easy addition of new categories
   - Support for multiple dialects within each language
   - Metadata fields for usage context and difficulty levels

This database structure provides a comprehensive foundation for a Cameroonian language learning application with real-world vocabulary and phrases across six major traditional languages.