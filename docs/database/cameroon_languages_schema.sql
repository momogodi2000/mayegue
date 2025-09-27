-- Cameroon Traditional Languages Database Schema for SQLite
-- Adapted from markdown specification for SQLite compatibility

-- Create languages table
CREATE TABLE languages (
    language_id TEXT PRIMARY KEY,
    language_name TEXT NOT NULL,
    language_family TEXT,
    region TEXT,
    speakers_count INTEGER,
    description TEXT,
    iso_code TEXT
);

-- Insert languages
INSERT INTO languages VALUES
('EWO', 'Ewondo', 'Beti-Pahuin (Bantu)', 'Central Region', 577000, 'Principal language of the Beti people, widely spoken in Yaoundé', 'ewo'),
('DUA', 'Duala', 'Coastal Bantu', 'Littoral Region', 300000, 'Historic trading language of the coast', 'dua'),
('FEF', 'Fe''efe''e', 'Grassfields (Bamileke)', 'West Region', 200000, 'Language of the Bafang area', 'fef'),
('FUL', 'Fulfulde', 'Niger-Congo (Atlantic)', 'North Region', 1500000, 'Language of the Fulani people', 'ful'),
('BAS', 'Bassa', 'A40 Bantu', 'Central-Littoral', 230000, 'Language of the Bassa people', 'bas'),
('BAM', 'Bamum', 'Grassfields', 'West Region', 215000, 'Language with its own indigenous script', 'bax');

-- Create categories table
CREATE TABLE categories (
    category_id TEXT PRIMARY KEY,
    category_name TEXT NOT NULL,
    description TEXT
);

-- Insert categories
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

-- Create translations table
CREATE TABLE translations (
    translation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    french_text TEXT NOT NULL,
    language_id TEXT,
    translation TEXT NOT NULL,
    category_id TEXT,
    pronunciation TEXT,
    usage_notes TEXT,
    difficulty_level TEXT CHECK(difficulty_level IN ('beginner', 'intermediate', 'advanced')),
    created_date TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (language_id) REFERENCES languages(language_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Insert translations data
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

-- Create indexes for better performance
CREATE INDEX idx_translations_language ON translations(language_id);
CREATE INDEX idx_translations_category ON translations(category_id);
CREATE INDEX idx_translations_difficulty ON translations(difficulty_level);
CREATE INDEX idx_translations_french_text ON translations(french_text);