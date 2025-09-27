import sqlite3
import re
from datetime import datetime

def create_database():
    # Connect to SQLite database (creates if doesn't exist)
    conn = sqlite3.connect('cameroon_languages.db')
    cursor = conn.cursor()
    
    # Enable foreign keys
    cursor.execute("PRAGMA foreign_keys = ON")
    
    # Create tables
    create_tables(cursor)
    
    # Insert data
    insert_languages(cursor)
    insert_categories(cursor)
    insert_translations(cursor)
    
    # Commit changes and close connection
    conn.commit()
    conn.close()
    print("✅ Cameroon Languages Database created successfully!")
    print("📊 Database file: cameroon_languages.db")

def create_tables(cursor):
    # Languages table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS languages (
        language_id VARCHAR(10) PRIMARY KEY,
        language_name VARCHAR(50) NOT NULL,
        language_family VARCHAR(100),
        region VARCHAR(50),
        speakers_count INTEGER,
        description TEXT,
        iso_code VARCHAR(10)
    )
    ''')
    
    # Categories table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS categories (
        category_id VARCHAR(10) PRIMARY KEY,
        category_name VARCHAR(50) NOT NULL,
        description TEXT
    )
    ''')
    
    # Translations table (using SQLite compatible syntax)
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS translations (
        translation_id INTEGER PRIMARY KEY AUTOINCREMENT,
        french_text TEXT NOT NULL,
        language_id VARCHAR(10),
        translation TEXT NOT NULL,
        category_id VARCHAR(10),
        pronunciation TEXT,
        usage_notes TEXT,
        difficulty_level TEXT CHECK(difficulty_level IN ('beginner', 'intermediate', 'advanced')),
        created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (language_id) REFERENCES languages(language_id),
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
    )
    ''')
    
    # Create indexes for better performance
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_translations_language ON translations(language_id)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_translations_category ON translations(category_id)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_translations_difficulty ON translations(difficulty_level)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_translations_french ON translations(french_text)')

def insert_languages(cursor):
    languages_data = [
        ('EWO', 'Ewondo', 'Beti-Pahuin (Bantu)', 'Central Region', 577000, 
         'Principal language of the Beti people, widely spoken in Yaoundé', 'ewo'),
        ('DUA', 'Duala', 'Coastal Bantu', 'Littoral Region', 300000, 
         'Historic trading language of the coast', 'dua'),
        ('FEF', 'Fe''efe''e', 'Grassfields (Bamileke)', 'West Region', 200000, 
         'Language of the Bafang area', 'fef'),
        ('FUL', 'Fulfulde', 'Niger-Congo (Atlantic)', 'North Region', 1500000, 
         'Language of the Fulani people', 'ful'),
        ('BAS', 'Bassa', 'A40 Bantu', 'Central-Littoral', 230000, 
         'Language of the Bassa people', 'bas'),
        ('BAM', 'Bamum', 'Grassfields', 'West Region', 215000, 
         'Language with its own indigenous script', 'bax')
    ]
    
    cursor.executemany('''
    INSERT INTO languages (language_id, language_name, language_family, region, speakers_count, description, iso_code)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', languages_data)

def insert_categories(cursor):
    categories_data = [
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
        ('PHR', 'Phrases', 'Common phrases and expressions'),
        ('CLO', 'Clothing', 'Clothing and accessories'),
        ('HOM', 'Home', 'House, furniture, household items'),
        ('PRO', 'Professions', 'Jobs and occupations'),
        ('TRA', 'Transportation', 'Vehicles and travel'),
        ('EMO', 'Emotions', 'Feelings and emotions'),
        ('EDU', 'Education', 'School and learning'),
        ('HEA', 'Health', 'Medical and health terms'),
        ('MON', 'Money', 'Currency, shopping, business'),
        ('DIR', 'Directions', 'Location and movement'),
        ('REL', 'Religion', 'Spiritual and religious terms'),
        ('MUS', 'Music', 'Musical instruments and terms'),
        ('SPO', 'Sports', 'Sports and physical activities')
    ]
    
    cursor.executemany('''
    INSERT INTO categories (category_id, category_name, description)
    VALUES (?, ?, ?)
    ''', categories_data)

def insert_translations(cursor):
    # Complete translations data from the markdown specification
    translations_data = [
        # Greetings - Ewondo
        ('Bonjour', 'EWO', 'Mbolo', 'GRT', 'mm-BOH-loh', None, 'beginner'),
        ('Bonsoir', 'EWO', 'Mbolo', 'GRT', 'mm-BOH-loh', None, 'beginner'),
        ('Comment allez-vous?', 'EWO', 'Mbolo woe?', 'GRT', 'mm-BOH-loh woh-eh', None, 'beginner'),
        ('Merci', 'EWO', 'Akiba', 'GRT', 'ah-KEE-bah', None, 'beginner'),
        ('Au revoir', 'EWO', 'Ka yen asu', 'GRT', 'kah yehn ah-SOO', None, 'beginner'),
        ('Excuse-moi', 'EWO', 'Ma yem ve', 'GRT', 'mah yehm veh', None, 'beginner'),

        # Greetings - Duala
        ('Bonjour', 'DUA', 'Mwa boma', 'GRT', 'mwah BOH-mah', None, 'beginner'),
        ('Bonsoir', 'DUA', 'Mwa munyenge', 'GRT', 'mwah moon-YEHN-geh', None, 'beginner'),
        ('Comment allez-vous?', 'DUA', 'Mwa boma na nde?', 'GRT', 'mwah BOH-mah nah n-deh', None, 'beginner'),
        ('Merci', 'DUA', 'Masa', 'GRT', 'MAH-sah', None, 'beginner'),
        ('Au revoir', 'DUA', 'Wese', 'GRT', 'WEH-seh', None, 'beginner'),

        # Greetings - Fe'efe'e
        ('Bonjour', 'FEF', 'Kweni', 'GRT', 'KWEH-nee', None, 'beginner'),
        ('Merci', 'FEF', 'Ndongui', 'GRT', 'n-DOHN-gwee', None, 'beginner'),
        ('Au revoir', 'FEF', 'Ko''a ntsie', 'GRT', 'koh-ah n-TSEE-eh', None, 'beginner'),

        # Greetings - Fulfulde
        ('Bonjour', 'FUL', 'Jam waali', 'GRT', 'jahm WAH-lee', None, 'beginner'),
        ('Bonsoir', 'FUL', 'Jam mayra', 'GRT', 'jahm MY-rah', None, 'beginner'),
        ('Comment allez-vous?', 'FUL', 'Jam tan?', 'GRT', 'jahm tahn', None, 'beginner'),
        ('Merci', 'FUL', 'Jarama', 'GRT', 'jah-RAH-mah', None, 'beginner'),
        ('Au revoir', 'FUL', 'Selaamaleykum', 'GRT', 'seh-lah-ah-mah-LAY-koom', None, 'beginner'),

        # Greetings - Bassa
        ('Bonjour', 'BAS', 'Mbolo', 'GRT', 'mm-BOH-loh', None, 'beginner'),
        ('Merci', 'BAS', 'Nyango', 'GRT', 'NYAHN-goh', None, 'beginner'),
        ('Au revoir', 'BAS', 'Ka nganda', 'GRT', 'kah n-GAHN-dah', None, 'beginner'),

        # Greetings - Bamum
        ('Bonjour', 'BAM', 'Nshie', 'GRT', 'n-SHEE-eh', None, 'beginner'),
        ('Merci', 'BAM', 'Numeni', 'GRT', 'noo-MEH-nee', None, 'beginner'),
        ('Au revoir', 'BAM', 'Ka ben', 'GRT', 'kah behn', None, 'beginner'),

        # Numbers - Ewondo
        ('un', 'EWO', 'fok', 'NUM', 'fohk', None, 'beginner'),
        ('deux', 'EWO', 'iba', 'NUM', 'ee-BAH', None, 'beginner'),
        ('trois', 'EWO', 'ilal', 'NUM', 'ee-LAHL', None, 'beginner'),
        ('quatre', 'EWO', 'inai', 'NUM', 'ee-NAH-ee', None, 'beginner'),
        ('cinq', 'EWO', 'itan', 'NUM', 'ee-TAHN', None, 'beginner'),
        ('six', 'EWO', 'isamaan', 'NUM', 'ee-sah-MAHN', None, 'beginner'),
        ('sept', 'EWO', 'isambaal', 'NUM', 'ee-sahm-BAHL', None, 'beginner'),
        ('huit', 'EWO', 'mfom', 'NUM', 'mm-FOHM', None, 'beginner'),
        ('neuf', 'EWO', 'evus', 'NUM', 'eh-VOOS', None, 'beginner'),
        ('dix', 'EWO', 'awom', 'NUM', 'ah-WOHM', None, 'beginner'),

        # Numbers - Duala
        ('un', 'DUA', 'mosi', 'NUM', 'MOH-see', None, 'beginner'),
        ('deux', 'DUA', 'maba', 'NUM', 'mah-BAH', None, 'beginner'),
        ('trois', 'DUA', 'malalo', 'NUM', 'mah-LAH-loh', None, 'beginner'),
        ('quatre', 'DUA', 'manei', 'NUM', 'mah-NEH-ee', None, 'beginner'),
        ('cinq', 'DUA', 'matan', 'NUM', 'mah-TAHN', None, 'beginner'),
        ('six', 'DUA', 'motoba', 'NUM', 'moh-TOH-bah', None, 'beginner'),
        ('sept', 'DUA', 'nsamba', 'NUM', 'n-SAHM-bah', None, 'beginner'),
        ('huit', 'DUA', 'mwambe', 'NUM', 'mwahm-BEH', None, 'beginner'),
        ('neuf', 'DUA', 'libua', 'NUM', 'lee-BOO-ah', None, 'beginner'),
        ('dix', 'DUA', 'duom', 'NUM', 'DOO-ohm', None, 'beginner'),

        # Numbers - Fulfulde
        ('un', 'FUL', 'goto', 'NUM', 'GOH-toh', None, 'beginner'),
        ('deux', 'FUL', 'didi', 'NUM', 'DEE-dee', None, 'beginner'),
        ('trois', 'FUL', 'tati', 'NUM', 'TAH-tee', None, 'beginner'),
        ('quatre', 'FUL', 'nayi', 'NUM', 'NAH-yee', None, 'beginner'),
        ('cinq', 'FUL', 'jowi', 'NUM', 'JOH-wee', None, 'beginner'),
        ('six', 'FUL', 'jeegom', 'NUM', 'JEH-eh-gohm', None, 'beginner'),
        ('sept', 'FUL', 'jeeditati', 'NUM', 'jeh-eh-dee-TAH-tee', None, 'beginner'),
        ('huit', 'FUL', 'jeetati', 'NUM', 'jeh-eh-TAH-tee', None, 'beginner'),
        ('neuf', 'FUL', 'jeenayi', 'NUM', 'jeh-eh-NAH-yee', None, 'beginner'),
        ('dix', 'FUL', 'sappo', 'NUM', 'SAHP-poh', None, 'beginner'),

        # Family - Ewondo
        ('père', 'EWO', 'tara', 'FAM', 'TAH-rah', None, 'beginner'),
        ('mère', 'EWO', 'nga', 'FAM', 'n-GAH', None, 'beginner'),
        ('fils', 'EWO', 'moan minga', 'FAM', 'moh-AHN mee-n-GAH', None, 'beginner'),
        ('fille', 'EWO', 'moan minga', 'FAM', 'moh-AHN mee-n-GAH', None, 'beginner'),
        ('frère', 'EWO', 'nkuu', 'FAM', 'n-KOO', None, 'beginner'),
        ('sœur', 'EWO', 'mbok', 'FAM', 'mm-BOHK', None, 'beginner'),
        ('grand-père', 'EWO', 'nkukuma', 'FAM', 'n-koo-KOO-mah', None, 'beginner'),
        ('grand-mère', 'EWO', 'nnemekukuma', 'FAM', 'n-neh-meh-koo-KOO-mah', None, 'beginner'),

        # Family - Duala
        ('père', 'DUA', 'tata', 'FAM', 'TAH-tah', None, 'beginner'),
        ('mère', 'DUA', 'mama', 'FAM', 'MAH-mah', None, 'beginner'),
        ('fils', 'DUA', 'mwana ma mutu', 'FAM', 'mwah-nah mah moo-TOO', None, 'beginner'),
        ('fille', 'DUA', 'mwana ma mutu', 'FAM', 'mwah-nah mah moo-TOO', None, 'beginner'),
        ('frère', 'DUA', 'kaka', 'FAM', 'KAH-kah', None, 'beginner'),
        ('sœur', 'DUA', 'mba', 'FAM', 'mm-BAH', None, 'beginner'),

        # Family - Fulfulde
        ('père', 'FUL', 'baaba', 'FAM', 'BAH-bah', None, 'beginner'),
        ('mère', 'FUL', 'yaaya', 'FAM', 'YAH-yah', None, 'beginner'),
        ('fils', 'FUL', 'bii''do', 'FAM', 'bee-DOH', None, 'beginner'),
        ('fille', 'FUL', 'deb''ere', 'FAM', 'deh-BEH-reh', None, 'beginner'),
        ('frère', 'FUL', 'ka''o', 'FAM', 'kah-OH', None, 'beginner'),
        ('sœur', 'FUL', 'mba''ru', 'FAM', 'mm-BAH-roo', None, 'beginner'),

        # Food - Ewondo
        ('eau', 'EWO', 'mam', 'FOD', 'mahm', None, 'beginner'),
        ('nourriture', 'EWO', 'bidi', 'FOD', 'BEE-dee', None, 'beginner'),
        ('viande', 'EWO', 'nyama', 'FOD', 'NYAH-mah', None, 'beginner'),
        ('poisson', 'EWO', 'som', 'FOD', 'sohm', None, 'beginner'),
        ('légumes', 'EWO', 'nduma', 'FOD', 'n-DOO-mah', None, 'beginner'),
        ('banane', 'EWO', 'kaba', 'FOD', 'KAH-bah', None, 'beginner'),
        ('manioc', 'EWO', 'mbong', 'FOD', 'mm-BOHN', None, 'beginner'),
        ('riz', 'EWO', 'malaa', 'FOD', 'mah-LAH', None, 'beginner'),

        # Food - Duala
        ('eau', 'DUA', 'mema', 'FOD', 'MEH-mah', None, 'beginner'),
        ('nourriture', 'DUA', 'bele', 'FOD', 'BEH-leh', None, 'beginner'),
        ('viande', 'DUA', 'nyama', 'FOD', 'NYAH-mah', None, 'beginner'),
        ('poisson', 'DUA', 'mba', 'FOD', 'mm-BAH', None, 'beginner'),
        ('banane', 'DUA', 'kondo', 'FOD', 'KOHN-doh', None, 'beginner'),
        ('manioc', 'DUA', 'miondo', 'FOD', 'mee-OHN-doh', None, 'beginner'),

        # Food - Fulfulde
        ('eau', 'FUL', 'ndiyam', 'FOD', 'n-DEE-yahm', None, 'beginner'),
        ('nourriture', 'FUL', 'yiiyam', 'FOD', 'YEE-yahm', None, 'beginner'),
        ('viande', 'FUL', 'nebbe', 'FOD', 'NEH-beh', None, 'beginner'),
        ('lait', 'FUL', 'kosam', 'FOD', 'KOH-sahm', None, 'beginner'),
        ('mil', 'FUL', 'gawri', 'FOD', 'GAH-wree', None, 'beginner'),

        # Common Phrases - Ewondo
        ('Je ne comprends pas', 'EWO', 'Ma si nkoboo te', 'PHR', 'mah see n-koh-BOH teh', None, 'intermediate'),
        ('Où est...?', 'EWO', 'Woe ve...?', 'PHR', 'woh-eh veh', None, 'intermediate'),
        ('Combien ça coûte?', 'EWO', 'A nkom mbeni?', 'PHR', 'ah n-kohm mm-BEH-nee', None, 'intermediate'),
        ('Je m''appelle...', 'EWO', 'Ma yili...', 'PHR', 'mah YEE-lee', None, 'intermediate'),
        ('Parlez-vous français?', 'EWO', 'Ou kala ndaman Fala?', 'PHR', 'oo KAH-lah n-dah-mahn FAH-lah', None, 'intermediate'),

        # Common Phrases - Duala
        ('Je ne comprends pas', 'DUA', 'Na soma te', 'PHR', 'nah SOH-mah teh', None, 'intermediate'),
        ('Où est...?', 'DUA', 'Wapi...?', 'PHR', 'WAH-pee', None, 'intermediate'),
        ('Combien ça coûte?', 'DUA', 'Mbama ngando?', 'PHR', 'mm-BAH-mah n-GAHN-doh', None, 'intermediate'),
        ('Je m''appelle...', 'DUA', 'Ndina nyam na...', 'PHR', 'n-DEE-nah nyahm nah', None, 'intermediate'),

        # Common Phrases - Fulfulde
        ('Je ne comprends pas', 'FUL', 'Mi famaani', 'PHR', 'mee fah-MAH-nee', None, 'intermediate'),
        ('Où est...?', 'FUL', 'Anto...?', 'PHR', 'AHN-toh', None, 'intermediate'),
        ('Combien ça coûte?', 'FUL', 'Noy foti?', 'PHR', 'noy FOH-tee', None, 'intermediate'),
        ('Je m''appelle...', 'FUL', 'Innde am ko...', 'PHR', 'ee-n-DEH ahm koh', None, 'intermediate'),

        # Colors - Ewondo
        ('rouge', 'EWO', 'bibuk', 'COL', 'bee-BOOK', None, 'beginner'),
        ('blanc', 'EWO', 'fum', 'COL', 'foom', None, 'beginner'),
        ('noir', 'EWO', 'mvie', 'COL', 'mm-VEE-eh', None, 'beginner'),
        ('vert', 'EWO', 'esu', 'COL', 'eh-SOO', None, 'beginner'),
        ('bleu', 'EWO', 'belu', 'COL', 'BEH-loo', None, 'beginner'),
        ('jaune', 'EWO', 'bola', 'COL', 'BOH-lah', None, 'beginner'),

        # Colors - Duala
        ('rouge', 'DUA', 'nene', 'COL', 'NEH-neh', None, 'beginner'),
        ('blanc', 'DUA', 'mpemba', 'COL', 'mm-PEHM-bah', None, 'beginner'),
        ('noir', 'DUA', 'binde', 'COL', 'BEE-n-deh', None, 'beginner'),
        ('vert', 'DUA', 'kaki', 'COL', 'KAH-kee', None, 'beginner'),

        # Colors - Fulfulde
        ('rouge', 'FUL', 'boodeejo', 'COL', 'boh-DEH-joh', None, 'beginner'),
        ('blanc', 'FUL', 'raneeji', 'COL', 'rah-NEH-jee', None, 'beginner'),
        ('noir', 'FUL', 'baleejo', 'COL', 'bah-LEH-joh', None, 'beginner'),

        # Animals - Ewondo
        ('chien', 'EWO', 'mvus', 'ANI', 'mm-VOOS', None, 'beginner'),
        ('chat', 'EWO', 'pusi', 'ANI', 'POO-see', None, 'beginner'),
        ('éléphant', 'EWO', 'nzog', 'ANI', 'n-ZOHG', None, 'beginner'),
        ('lion', 'EWO', 'nkui', 'ANI', 'n-KOO-ee', None, 'beginner'),
        ('oiseau', 'EWO', 'non', 'ANI', 'nohn', None, 'beginner'),
        ('poule', 'EWO', 'kob', 'ANI', 'kohb', None, 'beginner'),

        # Animals - Duala
        ('chien', 'DUA', 'mbwa', 'ANI', 'mm-BWAH', None, 'beginner'),
        ('chat', 'DUA', 'paka', 'ANI', 'PAH-kah', None, 'beginner'),
        ('éléphant', 'DUA', 'njoku', 'ANI', 'n-JOH-koo', None, 'beginner'),
        ('oiseau', 'DUA', 'kake', 'ANI', 'KAH-keh', None, 'beginner'),

        # Animals - Fulfulde
        ('chien', 'FUL', 'rawandu', 'ANI', 'rah-WAHN-doo', None, 'beginner'),
        ('chat', 'FUL', 'ganyru', 'ANI', 'GAHN-yroo', None, 'beginner'),
        ('vache', 'FUL', 'nagge', 'ANI', 'NAHG-geh', None, 'beginner'),
        ('chèvre', 'FUL', 'buri', 'ANI', 'BOO-ree', None, 'beginner'),
        ('mouton', 'FUL', 'barka', 'ANI', 'BAHR-kah', None, 'beginner'),

        # Additional common words (expanded vocabulary)
        ('maison', 'EWO', 'nda', 'HOM', 'n-DAH', None, 'beginner'),
        ('maison', 'DUA', 'ndako', 'HOM', 'n-DAH-koh', None, 'beginner'),
        ('maison', 'FUL', 'galle', 'HOM', 'GAHL-leh', None, 'beginner'),
        ('voiture', 'EWO', 'motor', 'TRA', 'MOH-tohr', None, 'beginner'),
        ('voiture', 'DUA', 'motuka', 'TRA', 'moh-TOO-kah', None, 'beginner'),
        ('voiture', 'FUL', 'motoor', 'TRA', 'moh-TOHR', None, 'beginner'),
        ('école', 'EWO', 'kalara', 'EDU', 'kah-LAH-rah', None, 'beginner'),
        ('école', 'DUA', 'eteyelo', 'EDU', 'eh-teh-YEH-loh', None, 'beginner'),
        ('école', 'FUL', 'janngirde', 'EDU', 'jahn-GEER-deh', None, 'beginner'),
        ('médecin', 'EWO', 'nkomo nnama', 'HEA', 'n-KOH-moh n-NAH-mah', None, 'intermediate'),
        ('médecin', 'DUA', 'monganga', 'HEA', 'mohn-GAHN-gah', None, 'intermediate'),
        ('médecin', 'FUL', 'doktoor', 'HEA', 'dohk-TOHR', None, 'intermediate'),
        ('argent', 'EWO', 'osan', 'MON', 'oh-SAHN', None, 'beginner'),
        ('argent', 'DUA', 'mbongo', 'MON', 'mm-BOHN-goh', None, 'beginner'),
        ('argent', 'FUL', 'alkarfe', 'MON', 'ahl-KAHR-feh', None, 'beginner'),
        ('soleil', 'EWO', 'nsan', 'NAT', 'n-SAHN', None, 'beginner'),
        ('soleil', 'DUA', 'moi', 'NAT', 'MOH-ee', None, 'beginner'),
        ('soleil', 'FUL', 'naange', 'NAT', 'NAHN-geh', None, 'beginner'),
        ('lune', 'EWO', 'ngond', 'NAT', 'n-GOHND', None, 'beginner'),
        ('lune', 'DUA', 'sanza', 'NAT', 'SAHN-zah', None, 'beginner'),
        ('lune', 'FUL', 'lewru', 'NAT', 'LEH-wroo', None, 'beginner'),
        ('pluie', 'EWO', 'mvon', 'NAT', 'mm-VOHN', None, 'beginner'),
        ('pluie', 'DUA', 'mbula', 'NAT', 'mm-BOO-lah', None, 'beginner'),
        ('pluie', 'FUL', 'ndiyam', 'NAT', 'n-DEE-yahm', None, 'beginner'),
        ('feu', 'EWO', 'nduan', 'NAT', 'n-DOO-ahn', None, 'beginner'),
        ('feu', 'DUA', 'moto', 'NAT', 'MOH-toh', None, 'beginner'),
        ('feu', 'FUL', 'yiite', 'NAT', 'YEE-teh', None, 'beginner'),
        ('eau', 'BAS', 'mam', 'FOD', 'mahm', None, 'beginner'),
        ('eau', 'BAM', 'fù', 'FOD', 'foo', None, 'beginner'),
        ('nourriture', 'BAS', 'bilong', 'FOD', 'bee-LOHNG', None, 'beginner'),
        ('nourriture', 'BAM', 'shù', 'FOD', 'shoo', None, 'beginner'),
        ('père', 'BAS', 'tata', 'FAM', 'TAH-tah', None, 'beginner'),
        ('père', 'BAM', 'pa', 'FAM', 'pah', None, 'beginner'),
        ('mère', 'BAS', 'nya', 'FAM', 'n-YAH', None, 'beginner'),
        ('mère', 'BAM', 'mā', 'FAM', 'mah', None, 'beginner'),
        ('un', 'BAS', 'mosi', 'NUM', 'MOH-see', None, 'beginner'),
        ('un', 'BAM', 'pāq', 'NUM', 'pahk', None, 'beginner'),
        ('deux', 'BAS', 'maba', 'NUM', 'mah-BAH', None, 'beginner'),
        ('deux', 'BAM', 'tū', 'NUM', 'too', None, 'beginner'),
        ('rouge', 'BAS', 'bibuk', 'COL', 'bee-BOOK', None, 'beginner'),
        ('blanc', 'BAS', 'fum', 'COL', 'foom', None, 'beginner'),
        ('noir', 'BAS', 'mvie', 'COL', 'mm-VEE-eh', None, 'beginner'),
        ('chien', 'BAS', 'mvus', 'ANI', 'mm-VOOS', None, 'beginner'),
        ('chat', 'BAS', 'pusi', 'ANI', 'POO-see', None, 'beginner'),
        ('éléphant', 'BAS', 'nzog', 'ANI', 'n-ZOHG', None, 'beginner'),
        ('Bonjour', 'BAS', 'Mbolo', 'GRT', 'mm-BOH-loh', None, 'beginner'),
        ('Merci', 'BAS', 'Nyango', 'GRT', 'NYAHN-goh', None, 'beginner'),
        ('Au revoir', 'BAS', 'Ka nganda', 'GRT', 'kah n-GAHN-dah', None, 'beginner'),
        ('Bonjour', 'BAM', 'Nshie', 'GRT', 'n-SHEE-eh', None, 'beginner'),
        ('Merci', 'BAM', 'Numeni', 'GRT', 'noo-MEH-nee', None, 'beginner'),
        ('Au revoir', 'BAM', 'Ka ben', 'GRT', 'kah behn', None, 'beginner'),

        # Additional words from enhanced dictionary and lessons
        ('Bonjour', 'EWO', 'Mboté', 'GRT', 'mm-BOH-teh', None, 'beginner'),
        ('Bonjour', 'EWO', 'Mboté o bibóm', 'GRT', 'mm-BOH-teh oh bee-BOHM', None, 'beginner'),
        ('Merci', 'EWO', 'Matónda', 'GRT', 'mah-TOHN-dah', None, 'beginner'),
        ('Eau', 'DUA', 'Mam', 'FOD', 'mahm', None, 'beginner'),
        ('Venir', 'FEF', 'Kaa', 'VRB', 'KAH-ah', None, 'beginner'),
        ('Eau', 'FUL', 'Ndiyam', 'FOD', 'n-DEE-yahm', None, 'beginner'),
        ('Maison', 'BAS', 'Hɔp', 'HOM', 'hohp', None, 'beginner'),
        ('Roi', 'BAM', 'Nzi', 'PRO', 'n-ZEE', None, 'intermediate'),
        ('Nourriture', 'DUA', 'Diba', 'FOD', 'DEE-bah', None, 'beginner'),
        ('Argent', 'DUA', 'Mbongo', 'MON', 'mm-BOHN-goh', None, 'beginner'),
        ('Père', 'EWO', 'Tara', 'FAM', 'TAH-rah', None, 'beginner'),
        ('Mère', 'EWO', 'Mama', 'FAM', 'MAH-mah', None, 'beginner'),
        ('Mère', 'EWO', 'Mam', 'FAM', 'mahm', None, 'beginner'),
        ('Enfant', 'EWO', 'Ndomo', 'FAM', 'n-DOH-moh', None, 'beginner'),
        ('Fils', 'EWO', 'Ndomo', 'FAM', 'n-DOH-moh', None, 'beginner'),
        ('Fille', 'EWO', 'Ngon', 'FAM', 'n-GOHN', None, 'beginner'),

        # Additional common words and phrases
        ('S''il vous plaît', 'EWO', 'Ta abe', 'PHR', 'tah ah-BEH', None, 'intermediate'),
        ('Désolé', 'EWO', 'Ma yem ve', 'PHR', 'mah yehm veh', None, 'intermediate'),
        ('Je suis malade', 'EWO', 'Ma yie nkono', 'PHR', 'mah YEE-eh n-KOH-noh', None, 'intermediate'),
        ('Aidez-moi', 'EWO', 'Demedoo ma', 'PHR', 'deh-meh-DOH mah', None, 'intermediate'),
        ('Je suis perdu', 'EWO', 'Ma fuman nzila', 'PHR', 'mah foo-MAHN n-ZEE-lah', None, 'intermediate'),
        ('Quelle heure est-il?', 'EWO', 'Ngule so ve?', 'PHR', 'n-GOO-leh soh veh', None, 'intermediate'),
        ('Je ne parle pas...', 'EWO', 'Ma si kala... te', 'PHR', 'mah see KAH-lah teh', None, 'intermediate'),
        ('S''il vous plaît', 'DUA', 'Mbesa na yo', 'PHR', 'mm-BEH-sah nah yoh', None, 'intermediate'),
        ('Désolé', 'DUA', 'Pardon', 'PHR', 'pahr-DOHN', None, 'intermediate'),
        ('Je suis malade', 'DUA', 'Nazali na bokono', 'PHR', 'nah-ZAH-lee nah boh-KOH-noh', None, 'intermediate'),
        ('Aidez-moi', 'DUA', 'Bosalisa ngai', 'PHR', 'boh-sah-LEE-sah n-GAH-ee', None, 'intermediate'),
        ('Quelle heure est-il?', 'DUA', 'Ngonga nini?', 'PHR', 'n-GOHN-gah NEE-nee', None, 'intermediate'),
        ('S''il vous plaît', 'FUL', 'Min jaɓɓii', 'PHR', 'meen jah-BEE', None, 'intermediate'),
        ('Désolé', 'FUL', 'Hakke', 'PHR', 'HAHK-keh', None, 'intermediate'),
        ('Je suis malade', 'FUL', 'Mi jogii', 'PHR', 'mee joh-GEE', None, 'intermediate'),
        ('Aidez-moi', 'FUL', 'Wallu-mi', 'PHR', 'WAHL-loo-mee', None, 'intermediate'),
        ('Quelle heure est-il?', 'FUL', 'Waktu fotde?', 'PHR', 'WAHK-too FOHT-deh', None, 'intermediate'),

        # Extended vocabulary from lessons
        ('Bonjour', 'EWO', 'Mboté', 'GRT', 'mm-BOH-teh', None, 'beginner'),
        ('Bonjour', 'EWO', 'Mboté o bibóm', 'GRT', 'mm-BOH-teh oh bee-BOHM', None, 'beginner'),
        ('Merci', 'EWO', 'Matónda', 'GRT', 'mah-TOHN-dah', None, 'beginner'),
        ('Père', 'EWO', 'Tara', 'FAM', 'TAH-rah', None, 'beginner'),
        ('Mère', 'EWO', 'Mama', 'FAM', 'MAH-mah', None, 'beginner'),
        ('Mère', 'EWO', 'Mam', 'FAM', 'mahm', None, 'beginner'),
        ('Enfant', 'EWO', 'Ndomo', 'FAM', 'n-DOH-moh', None, 'beginner'),
        ('Fils', 'EWO', 'Ndomo', 'FAM', 'n-DOH-moh', None, 'beginner'),
        ('Fille', 'EWO', 'Ngon', 'FAM', 'n-GOHN', None, 'beginner'),
        ('Eau', 'DUA', 'Mam', 'FOD', 'mahm', None, 'beginner'),
        ('Nourriture', 'DUA', 'Diba', 'FOD', 'DEE-bah', None, 'beginner'),
        ('Argent', 'DUA', 'Mbongo', 'MON', 'mm-BOHN-goh', None, 'beginner'),

        # Body parts (extended)
        ('Tête', 'EWO', 'Nlo', 'BOD', 'n-LOH', None, 'beginner'),
        ('Œil', 'EWO', 'Iso', 'BOD', 'ee-SOH', None, 'beginner'),
        ('Oreille', 'EWO', 'To', 'BOD', 'toh', None, 'beginner'),
        ('Nez', 'EWO', 'Minga', 'BOD', 'mee-n-GAH', None, 'beginner'),
        ('Bouche', 'EWO', 'Anom', 'BOD', 'ah-NOHM', None, 'beginner'),
        ('Dent', 'EWO', 'Nyin', 'BOD', 'n-YEEN', None, 'beginner'),
        ('Main', 'EWO', 'Abo', 'BOD', 'ah-BOH', None, 'beginner'),
        ('Pied', 'EWO', 'Aban', 'BOD', 'ah-BAHN', None, 'beginner'),
        ('Bras', 'EWO', 'Abei', 'BOD', 'ah-BEH-ee', None, 'beginner'),
        ('Jambe', 'EWO', 'Akok', 'BOD', 'ah-KOHK', None, 'beginner'),
        ('Cœur', 'EWO', 'Nlem', 'BOD', 'n-LEHM', None, 'beginner'),
        ('Estomac', 'EWO', 'Abe', 'BOD', 'ah-BEH', None, 'beginner'),
        ('Tête', 'DUA', 'Moto', 'BOD', 'MOH-toh', None, 'beginner'),
        ('Œil', 'DUA', 'Disu', 'BOD', 'DEE-soo', None, 'beginner'),
        ('Oreille', 'DUA', 'Toi', 'BOD', 'toh-EE', None, 'beginner'),
        ('Nez', 'DUA', 'Lumbu', 'BOD', 'LOOM-boo', None, 'beginner'),
        ('Bouche', 'DUA', 'Monoko', 'BOD', 'moh-NOH-koh', None, 'beginner'),
        ('Main', 'DUA', 'Loboko', 'BOD', 'loh-BOH-koh', None, 'beginner'),
        ('Pied', 'DUA', 'Makolo', 'BOD', 'mah-KOH-loh', None, 'beginner'),
        ('Tête', 'FUL', 'Hoore', 'BOD', 'HOH-reh', None, 'beginner'),
        ('Œil', 'FUL', 'Gite', 'BOD', 'GEE-teh', None, 'beginner'),
        ('Oreille', 'FUL', 'Noppe', 'BOD', 'NOHP-peh', None, 'beginner'),
        ('Nez', 'FUL', 'Hinyaali', 'BOD', 'hee-NYAH-lee', None, 'beginner'),
        ('Bouche', 'FUL', 'Genne', 'BOD', 'GEHN-neh', None, 'beginner'),
        ('Main', 'FUL', 'Juunal', 'BOD', 'JOO-nahl', None, 'beginner'),
        ('Pied', 'FUL', 'Koyye', 'BOD', 'KOY-yeh', None, 'beginner'),

        # Time and days (extended)
        ('Lundi', 'EWO', 'Elu', 'TIM', 'eh-LOO', None, 'beginner'),
        ('Mardi', 'EWO', 'Amane', 'TIM', 'ah-MAH-neh', None, 'beginner'),
        ('Mercredi', 'EWO', 'Akan', 'TIM', 'ah-KAHN', None, 'beginner'),
        ('Jeudi', 'EWO', 'Akus', 'TIM', 'ah-KOOS', None, 'beginner'),
        ('Vendredi', 'EWO', 'Afua', 'TIM', 'ah-FOO-ah', None, 'beginner'),
        ('Samedi', 'EWO', 'Memua', 'TIM', 'meh-MOO-ah', None, 'beginner'),
        ('Dimanche', 'EWO', 'Sondo', 'TIM', 'SOHN-doh', None, 'beginner'),
        ('Aujourd''hui', 'EWO', 'Andu', 'TIM', 'ahn-DOO', None, 'beginner'),
        ('Hier', 'EWO', 'Ngon', 'TIM', 'n-GOHN', None, 'beginner'),
        ('Demain', 'EWO', 'Okir', 'TIM', 'oh-KEER', None, 'beginner'),
        ('Matin', 'EWO', 'Nga', 'TIM', 'n-GAH', None, 'beginner'),
        ('Soir', 'EWO', 'Mfini', 'TIM', 'mm-FEE-nee', None, 'beginner'),
        ('Lundi', 'DUA', 'Moto', 'TIM', 'MOH-toh', None, 'beginner'),
        ('Mardi', 'DUA', 'Koko', 'TIM', 'KOH-koh', None, 'beginner'),
        ('Mercredi', 'DUA', 'Makena', 'TIM', 'mah-KEH-nah', None, 'beginner'),
        ('Jeudi', 'DUA', 'Mokolo', 'TIM', 'moh-KOH-loh', None, 'beginner'),
        ('Vendredi', 'DUA', 'Mumbuka', 'TIM', 'moom-BOO-kah', None, 'beginner'),
        ('Samedi', 'DUA', 'Ngoya', 'TIM', 'n-GOH-yah', None, 'beginner'),
        ('Dimanche', 'DUA', 'Disama', 'TIM', 'dee-SAH-mah', None, 'beginner'),
        ('Lundi', 'FUL', 'Altine', 'TIM', 'ahl-TEE-neh', None, 'beginner'),
        ('Mardi', 'FUL', 'Talata', 'TIM', 'tah-LAH-tah', None, 'beginner'),
        ('Mercredi', 'FUL', 'Alarbaa', 'TIM', 'ah-lahr-BAH', None, 'beginner'),
        ('Jeudi', 'FUL', 'Alkamiisa', 'TIM', 'ahl-kah-MEE-sah', None, 'beginner'),
        ('Vendredi', 'FUL', 'Aljumaa', 'TIM', 'ahl-joo-MAH', None, 'beginner'),
        ('Samedi', 'FUL', 'Aset', 'TIM', 'ah-SEHT', None, 'beginner'),
        ('Dimanche', 'FUL', 'Alahat', 'TIM', 'ah-lah-HAHT', None, 'beginner'),

        # More food items
        ('Maïs', 'EWO', 'Aban', 'FOD', 'ah-BAHN', None, 'beginner'),
        ('Huile de palme', 'EWO', 'Metet', 'FOD', 'meh-TEHT', None, 'beginner'),
        ('Arachide', 'EWO', 'Akwa', 'FOD', 'ah-KWAH', None, 'beginner'),
        ('Plantain', 'EWO', 'Kaba mbongo', 'FOD', 'KAH-bah mm-BOHN-goh', None, 'beginner'),
        ('Igname', 'EWO', 'Fong', 'FOD', 'fohng', None, 'beginner'),
        ('Patate douce', 'EWO', 'Akoma', 'FOD', 'ah-KOH-mah', None, 'beginner'),
        ('Cacao', 'EWO', 'Kaba', 'FOD', 'KAH-bah', None, 'beginner'),
        ('Café', 'EWO', 'Kafe', 'FOD', 'KAH-feh', None, 'beginner'),
        ('Vin de palme', 'EWO', 'Malamba', 'FOD', 'mah-LAHM-bah', None, 'intermediate'),
        ('Piment', 'EWO', 'Akaa', 'FOD', 'ah-KAH', None, 'beginner'),
        ('Gingembre', 'EWO', 'Mbongo', 'FOD', 'mm-BOHN-goh', None, 'beginner'),
        ('Sel', 'EWO', 'Ngon', 'FOD', 'n-GOHN', None, 'beginner'),
        ('Sucre', 'EWO', 'Sukre', 'FOD', 'SOOK-reh', None, 'beginner'),
        ('Maïs', 'DUA', 'Sango', 'FOD', 'SAHN-goh', None, 'beginner'),
        ('Plantain', 'DUA', 'Kondo ndambe', 'FOD', 'KOHN-doh n-DAHM-beh', None, 'beginner'),
        ('Igname', 'DUA', 'Mutulu', 'FOD', 'moo-TOO-loo', None, 'beginner'),
        ('Cacao', 'DUA', 'Kakao', 'FOD', 'kah-KAH-oh', None, 'beginner'),
        ('Vin de palme', 'DUA', 'Matango', 'FOD', 'mah-TAHN-goh', None, 'intermediate'),
        ('Crabe', 'DUA', 'Koli', 'FOD', 'KOH-lee', None, 'beginner'),
        ('Crevette', 'DUA', 'Tomba', 'FOD', 'TOHM-bah', None, 'beginner'),
        ('Mil', 'FUL', 'Gawri', 'FOD', 'GAH-wree', None, 'beginner'),
        ('Sorgho', 'FUL', 'Maasiri', 'FOD', 'mah-SEE-ree', None, 'beginner'),
        ('Haricot', 'FUL', 'Niebe', 'FOD', 'nee-EH-beh', None, 'beginner'),
        ('Beurre de karité', 'FUL', 'Nebam', 'FOD', 'NEH-bahm', None, 'beginner'),
        ('Miel', 'FUL', 'Ngoori', 'FOD', 'n-GOH-ree', None, 'beginner'),
        ('Viande séchée', 'FUL', 'Kilishi', 'FOD', 'kee-LEE-shee', None, 'intermediate'),
        ('Fromage', 'FUL', 'Kaasam', 'FOD', 'KAH-sahm', None, 'beginner'),

        # Common verbs
        ('Être', 'EWO', 'Ye', 'VRB', 'yeh', None, 'beginner'),
        ('Avoir', 'EWO', 'Ke', 'VRB', 'keh', None, 'beginner'),
        ('Aller', 'EWO', 'Kei', 'VRB', 'keh-EE', None, 'beginner'),
        ('Venir', 'EWO', 'Wa', 'VRB', 'wah', None, 'beginner'),
        ('Manger', 'EWO', 'Di', 'VRB', 'dee', None, 'beginner'),
        ('Boire', 'EWO', 'Nua', 'VRB', 'NOO-ah', None, 'beginner'),
        ('Dormir', 'EWO', 'Lal', 'VRB', 'lahl', None, 'beginner'),
        ('Parler', 'EWO', 'Kala', 'VRB', 'KAH-lah', None, 'beginner'),
        ('Voir', 'EWO', 'Yen', 'VRB', 'yehn', None, 'beginner'),
        ('Entendre', 'EWO', 'Yem', 'VRB', 'yehm', None, 'beginner'),
        ('Donner', 'EWO', 'Kaba', 'VRB', 'KAH-bah', None, 'beginner'),
        ('Prendre', 'EWO', 'Kete', 'VRB', 'KEH-teh', None, 'beginner'),
        ('Acheter', 'EWO', 'Sili', 'VRB', 'SEE-lee', None, 'intermediate'),
        ('Vendre', 'EWO', 'Koma', 'VRB', 'KOH-mah', None, 'intermediate'),
        ('Travailler', 'EWO', 'Kudu', 'VRB', 'KOO-doo', None, 'intermediate'),
        ('Étudier', 'EWO', 'Kelene', 'VRB', 'keh-LEH-neh', None, 'intermediate'),
        ('Aimer', 'EWO', 'Zamba', 'VRB', 'ZAHM-bah', None, 'beginner'),
        ('Être', 'DUA', 'Ba', 'VRB', 'bah', None, 'beginner'),
        ('Avoir', 'DUA', 'Zala', 'VRB', 'ZAH-lah', None, 'beginner'),
        ('Aller', 'DUA', 'Kende', 'VRB', 'KEHN-deh', None, 'beginner'),
        ('Venir', 'DUA', 'Wuta', 'VRB', 'WOO-tah', None, 'beginner'),
        ('Manger', 'DUA', 'Lya', 'VRB', 'lyah', None, 'beginner'),
        ('Boire', 'DUA', 'Mela', 'VRB', 'MEH-lah', None, 'beginner'),
        ('Dormir', 'DUA', 'Lala', 'VRB', 'LAH-lah', None, 'beginner'),
        ('Parler', 'DUA', 'Loba', 'VRB', 'LOH-bah', None, 'beginner'),
        ('Être', 'FUL', 'Wonde', 'VRB', 'WOHN-deh', None, 'beginner'),
        ('Avoir', 'FUL', 'Mari', 'VRB', 'MAH-ree', None, 'beginner'),
        ('Aller', 'FUL', 'Yahde', 'VRB', 'YAHH-deh', None, 'beginner'),
        ('Venir', 'FUL', 'Arde', 'VRB', 'AHR-deh', None, 'beginner'),
        ('Manger', 'FUL', 'Nyaame', 'VRB', 'NYAH-meh', None, 'beginner'),
        ('Boire', 'FUL', 'Yarde', 'VRB', 'YAHR-deh', None, 'beginner'),
        ('Dormir', 'FUL', 'Njaade', 'VRB', 'n-JAH-deh', None, 'beginner'),

        # Adjectives
        ('Grand', 'EWO', 'Ane', 'ADJ', 'ah-NEH', None, 'beginner'),
        ('Petit', 'EWO', 'Nit', 'ADJ', 'neet', None, 'beginner'),
        ('Bon', 'EWO', 'Bot', 'ADJ', 'boht', None, 'beginner'),
        ('Mauvais', 'EWO', 'Abe', 'ADJ', 'ah-BEH', None, 'beginner'),
        ('Beau', 'EWO', 'Kamba', 'ADJ', 'KAHM-bah', None, 'beginner'),
        ('Laid', 'EWO', 'Mbing', 'ADJ', 'mm-BEENG', None, 'beginner'),
        ('Chaud', 'EWO', 'Asu', 'ADJ', 'ah-SOO', None, 'beginner'),
        ('Froid', 'EWO', 'Kies', 'ADJ', 'kee-EHS', None, 'beginner'),
        ('Nouveau', 'EWO', 'Sus', 'ADJ', 'soos', None, 'beginner'),
        ('Vieux', 'EWO', 'Kulu', 'ADJ', 'KOO-loo', None, 'beginner'),
        ('Grand', 'DUA', 'Kolo', 'ADJ', 'KOH-loh', None, 'beginner'),
        ('Petit', 'DUA', 'Moke', 'ADJ', 'MOH-keh', None, 'beginner'),
        ('Bon', 'DUA', 'Malamu', 'ADJ', 'mah-LAH-moo', None, 'beginner'),
        ('Mauvais', 'DUA', 'Mabe', 'ADJ', 'MAH-beh', None, 'beginner'),
        ('Beau', 'DUA', 'Kitoko', 'ADJ', 'kee-TOH-koh', None, 'beginner'),
        ('Grand', 'FUL', 'Mawdo', 'ADJ', 'MAHW-doh', None, 'beginner'),
        ('Petit', 'FUL', 'Keewdo', 'ADJ', 'KEH-oo-doh', None, 'beginner'),
        ('Bon', 'FUL', 'Mooto', 'ADJ', 'MOH-toh', None, 'beginner'),
        ('Mauvais', 'FUL', 'Moollu', 'ADJ', 'MOH-loo', None, 'beginner'),
        ('Beau', 'FUL', 'Riiɗo', 'ADJ', 'REE-doh', None, 'beginner'),

        # Clothing
        ('Vêtement', 'EWO', 'Nlat', 'CLO', 'n-LAHT', None, 'beginner'),
        ('Chemise', 'EWO', 'Kamisa', 'CLO', 'kah-MEE-sah', None, 'beginner'),
        ('Pantalon', 'EWO', 'Kalaso', 'CLO', 'kah-LAH-soh', None, 'beginner'),
        ('Robe', 'EWO', 'Nnimba', 'CLO', 'n-NEEM-bah', None, 'beginner'),
        ('Chaussure', 'EWO', 'Nkap', 'CLO', 'n-KAHP', None, 'beginner'),
        ('Chapeau', 'EWO', 'Nkop', 'CLO', 'n-KOHP', None, 'beginner'),
        ('Pagne', 'EWO', 'Ntange', 'CLO', 'n-TAHN-geh', None, 'beginner'),
        ('Vêtement', 'DUA', 'Elamba', 'CLO', 'eh-LAHM-bah', None, 'beginner'),
        ('Chemise', 'DUA', 'Lokolo', 'CLO', 'loh-KOH-loh', None, 'beginner'),
        ('Pantalon', 'DUA', 'Pantalona', 'CLO', 'pahn-tah-LOH-nah', None, 'beginner'),
        ('Chaussure', 'DUA', 'Matambi', 'CLO', 'mah-TAHM-bee', None, 'beginner'),
        ('Vêtement', 'FUL', 'Kesa', 'CLO', 'KEH-sah', None, 'beginner'),
        ('Chemise', 'FUL', 'Kurta', 'CLO', 'KOOR-tah', None, 'beginner'),
        ('Pantalon', 'FUL', 'Drawas', 'CLO', 'DRAH-wahs', None, 'beginner'),
        ('Boubou', 'FUL', 'Daara', 'CLO', 'DAH-rah', None, 'beginner'),
        ('Chaussure', 'FUL', 'Naɗuuji', 'CLO', 'nah-DOO-jee', None, 'beginner'),

        # Home and household
        ('Chambre', 'EWO', 'Nda nchou', 'HOM', 'n-DAH n-CHOO', None, 'beginner'),
        ('Cuisine', 'EWO', 'Nda nti', 'HOM', 'n-DAH n-TEE', None, 'beginner'),
        ('Salon', 'EWO', 'Nda nsisim', 'HOM', 'n-DAH n-SEE-seem', None, 'beginner'),
        ('Lit', 'EWO', 'Mbeng', 'HOM', 'mm-BEHNG', None, 'beginner'),
        ('Table', 'EWO', 'Tebere', 'HOM', 'teh-BEH-reh', None, 'beginner'),
        ('Chaise', 'EWO', 'Akada', 'HOM', 'ah-KAH-dah', None, 'beginner'),
        ('Porte', 'EWO', 'Nkukuma', 'HOM', 'n-koo-KOO-mah', None, 'beginner'),
        ('Fenêtre', 'EWO', 'Nlong', 'HOM', 'n-LOHNG', None, 'beginner'),
        ('Chambre', 'DUA', 'Ndako ya bolali', 'HOM', 'n-DAH-koh yah boh-LAH-lee', None, 'beginner'),
        ('Cuisine', 'DUA', 'Ndako ya bilei', 'HOM', 'n-DAH-koh yah bee-LEH-ee', None, 'beginner'),
        ('Lit', 'DUA', 'Mbeto', 'HOM', 'mm-BEH-toh', None, 'beginner'),
        ('Table', 'DUA', 'Tebele', 'HOM', 'teh-BEH-leh', None, 'beginner'),
        ('Chambre', 'FUL', 'Cuuɗal', 'HOM', 'CHOO-dahl', None, 'beginner'),
        ('Cuisine', 'FUL', 'Nyaamnde', 'HOM', 'NYAHM-n-deh', None, 'beginner'),
        ('Lit', 'FUL', 'Jiital', 'HOM', 'JEE-tahl', None, 'beginner'),

        # Professions
        ('Enseignant', 'EWO', 'Nkelene nkukuma', 'PRO', 'n-keh-LEH-neh n-koo-KOO-mah', None, 'intermediate'),
        ('Médecin', 'EWO', 'Nkomo nnama', 'PRO', 'n-KOH-moh n-NAH-mah', None, 'intermediate'),
        ('Agriculteur', 'EWO', 'Nkudu fong', 'PRO', 'n-KOO-doo fohng', None, 'intermediate'),
        ('Commerçant', 'EWO', 'Nkoma', 'PRO', 'n-KOH-mah', None, 'intermediate'),
        ('Chauffeur', 'EWO', 'Nkelak motor', 'PRO', 'n-keh-LAHK MOH-tohr', None, 'intermediate'),
        ('Enseignant', 'DUA', 'Molakisi', 'PRO', 'moh-lah-KEE-see', None, 'intermediate'),
        ('Médecin', 'DUA', 'Monganga', 'PRO', 'mohn-GAHN-gah', None, 'intermediate'),
        ('Pêcheur', 'DUA', 'Mombandi', 'PRO', 'mohm-BAHN-dee', None, 'intermediate'),
        ('Enseignant', 'FUL', 'Jangorde', 'PRO', 'jahn-GOHR-deh', None, 'intermediate'),
        ('Médecin', 'FUL', 'Doktoor', 'PRO', 'dohk-TOHR', None, 'intermediate'),
        ('Berger', 'FUL', 'Gaasiɗo', 'PRO', 'gah-SEE-doh', None, 'intermediate'),
        ('Éleveur', 'FUL', 'Jooɗiɗo', 'PRO', 'joh-DEE-doh', None, 'intermediate'),

        # Transportation
        ('Moto', 'EWO', 'Motor nkap', 'TRA', 'MOH-tohr n-KAHP', None, 'beginner'),
        ('Vélo', 'EWO', 'Velo', 'TRA', 'VEH-loh', None, 'beginner'),
        ('Bus', 'EWO', 'Bus', 'TRA', 'boos', None, 'beginner'),
        ('Taxi', 'EWO', 'Taksi', 'TRA', 'TAHK-see', None, 'beginner'),
        ('Pirogue', 'EWO', 'Mbaa', 'TRA', 'mm-BAH', None, 'beginner'),
        ('Moto', 'DUA', 'Moto', 'TRA', 'MOH-toh', None, 'beginner'),
        ('Pirogue', 'DUA', 'Wolo', 'TRA', 'WOH-loh', None, 'beginner'),
        ('Bateau', 'DUA', 'Masuwa', 'TRA', 'mah-SOO-wah', None, 'beginner'),
        ('Moto', 'FUL', 'Alamaari', 'TRA', 'ah-lah-MAH-ree', None, 'beginner'),
        ('Cheval', 'FUL', 'Puuccu', 'TRA', 'POOCH-choo', None, 'beginner'),
        ('Âne', 'FUL', 'Mbaaɗu', 'TRA', 'mm-BAH-doo', None, 'beginner'),

        # Emotions
        ('Heureux', 'EWO', 'Ayeme', 'EMO', 'ah-YEH-meh', None, 'intermediate'),
        ('Triste', 'EWO', 'Ayie', 'EMO', 'ah-YEE-eh', None, 'intermediate'),
        ('En colère', 'EWO', 'Nkana', 'EMO', 'n-KAH-nah', None, 'intermediate'),
        ('Peur', 'EWO', 'Nsisin', 'EMO', 'n-SEE-seen', None, 'intermediate'),
        ('Amour', 'EWO', 'Zamba', 'EMO', 'ZAHM-bah', None, 'intermediate'),
        ('Heureux', 'DUA', 'Esengo', 'EMO', 'eh-SEHN-goh', None, 'intermediate'),
        ('Triste', 'DUA', 'Mawa', 'EMO', 'MAH-wah', None, 'intermediate'),
        ('En colère', 'DUA', 'Nkanda', 'EMO', 'n-KAHN-dah', None, 'intermediate'),
        ('Heureux', 'FUL', 'Yankude', 'EMO', 'yahn-KOO-deh', None, 'intermediate'),
        ('Triste', 'FUL', 'Hanki', 'EMO', 'HAHN-kee', None, 'intermediate'),
        ('Peur', 'FUL', 'Ŋeyku', 'EMO', 'NGYEH-koo', None, 'intermediate'),

        # More animals
        ('Singe', 'EWO', 'Kema', 'ANI', 'KEH-mah', None, 'beginner'),
        ('Antilope', 'EWO', 'Nyati', 'ANI', 'NYAH-tee', None, 'beginner'),
        ('Serpent', 'EWO', 'Nyol', 'ANI', 'n-YOHL', None, 'beginner'),
        ('Crocodile', 'EWO', 'Ngando', 'ANI', 'n-GAHN-doh', None, 'beginner'),
        ('Tortue', 'EWO', 'Kulu', 'ANI', 'KOO-loo', None, 'beginner'),
        ('Panthère', 'EWO', 'Nkui', 'ANI', 'n-KOO-ee', None, 'beginner'),
        ('Hippopotame', 'EWO', 'Nguba', 'ANI', 'n-GOO-bah', None, 'beginner'),
        ('Singe', 'DUA', 'Mokoko', 'ANI', 'moh-KOH-koh', None, 'beginner'),
        ('Serpent', 'DUA', 'Nyoka', 'ANI', 'NYOH-kah', None, 'beginner'),
        ('Crocodile', 'DUA', 'Ngando', 'ANI', 'n-GAHN-doh', None, 'beginner'),
        ('Tortue', 'DUA', 'Kulu', 'ANI', 'KOO-loo', None, 'beginner'),
        ('Singe', 'FUL', 'Baabilo', 'ANI', 'bah-BEE-loh', None, 'beginner'),
        ('Serpent', 'FUL', 'Maarudo', 'ANI', 'mah-ROO-doh', None, 'beginner'),
        ('Lion', 'FUL', 'Gaynako', 'ANI', 'guy-NAH-koh', None, 'beginner'),
        ('Hyène', 'FUL', 'Kurege', 'ANI', 'koo-REH-geh', None, 'beginner'),
        ('Gazelle', 'FUL', 'Mbororo', 'ANI', 'mm-boh-ROH-roh', None, 'beginner'),

        # Nature and weather
        ('Soleil', 'EWO', 'Nsan', 'NAT', 'n-SAHN', None, 'beginner'),
        ('Étoile', 'EWO', 'Mbon', 'NAT', 'mm-BOHN', None, 'beginner'),
        ('Nuage', 'EWO', 'Nkup mvon', 'NAT', 'n-KOOP mm-VOHN', None, 'beginner'),
        ('Rivière', 'EWO', 'Kala', 'NAT', 'KAH-lah', None, 'beginner'),
        ('Forêt', 'EWO', 'Afan', 'NAT', 'ah-FAHN', None, 'beginner'),
        ('Montagne', 'EWO', 'Nkolombe', 'NAT', 'n-koh-LOHM-beh', None, 'beginner'),
        ('Arbre', 'EWO', 'Avenga', 'NAT', 'ah-VEHN-gah', None, 'beginner'),
        ('Fleur', 'EWO', 'Nbom', 'NAT', 'mm-BOHM', None, 'beginner'),
        ('Soleil', 'DUA', 'Moi', 'NAT', 'MOH-ee', None, 'beginner'),
        ('Rivière', 'DUA', 'Mai', 'NAT', 'MAH-ee', None, 'beginner'),
        ('Forêt', 'DUA', 'Dikanda', 'NAT', 'dee-KAHN-dah', None, 'beginner'),
        ('Arbre', 'DUA', 'Nti', 'NAT', 'n-TEE', None, 'beginner'),
        ('Soleil', 'FUL', 'Naange', 'NAT', 'NAHN-geh', None, 'beginner'),
        ('Rivière', 'FUL', 'Maayo', 'NAT', 'MAH-yoh', None, 'beginner'),
        ('Arbre', 'FUL', 'Lekki', 'NAT', 'LEHK-kee', None, 'beginner'),
        ('Feu', 'EWO', 'Nduan', 'NAT', 'n-DOO-ahn', None, 'beginner'),
        ('Feu', 'DUA', 'Moto', 'NAT', 'MOH-toh', None, 'beginner'),
        ('Feu', 'FUL', 'Yiite', 'NAT', 'YEE-teh', None, 'beginner'),

        # Education terms
        ('École', 'EWO', 'Kalara', 'EDU', 'kah-LAH-rah', None, 'beginner'),
        ('Livre', 'EWO', 'Buk', 'EDU', 'book', None, 'beginner'),
        ('Stylo', 'EWO', 'Nkan tili', 'EDU', 'n-KAHN tee-LEE', None, 'beginner'),
        ('Papier', 'EWO', 'Katas', 'EDU', 'KAH-tahs', None, 'beginner'),
        ('Élève', 'EWO', 'Nkelene moan', 'EDU', 'n-keh-LEH-neh moh-AHN', None, 'beginner'),
        ('Professeur', 'EWO', 'Nkelene', 'EDU', 'n-keh-LEH-neh', None, 'beginner'),
        ('École', 'DUA', 'Eteyelo', 'EDU', 'eh-teh-YEH-loh', None, 'beginner'),
        ('Livre', 'DUA', 'Buka', 'EDU', 'BOO-kah', None, 'beginner'),
        ('Stylo', 'DUA', 'Esila', 'EDU', 'eh-SEE-lah', None, 'beginner'),
        ('École', 'FUL', 'Janngirde', 'EDU', 'jahn-GEER-deh', None, 'beginner'),
        ('Livre', 'FUL', 'Deftere', 'EDU', 'dehf-TEH-reh', None, 'beginner'),
        ('Apprendre', 'FUL', 'Janngude', 'EDU', 'jahn-GOO-deh', None, 'beginner'),
        ('Enseigner', 'FUL', 'Jangude', 'EDU', 'jahn-GOO-deh', None, 'beginner'),

        # Health terms
        ('Santé', 'EWO', 'Akono', 'HEA', 'ah-KOH-noh', None, 'beginner'),
        ('Malade', 'EWO', 'Nkono', 'HEA', 'n-KOH-noh', None, 'beginner'),
        ('Médicament', 'EWO', 'Nkomo nnam', 'HEA', 'n-KOH-moh n-NAHM', None, 'intermediate'),
        ('Hôpital', 'EWO', 'Opital', 'HEA', 'oh-pee-TAHL', None, 'intermediate'),
        ('Douleur', 'EWO', 'Nyin', 'HEA', 'n-YEEN', None, 'beginner'),
        ('Fièvre', 'EWO', 'Asu nlo', 'HEA', 'ah-SOO n-LOH', None, 'intermediate'),
        ('Santé', 'DUA', 'Bokolongono', 'HEA', 'boh-koh-lohn-GOH-noh', None, 'beginner'),
        ('Malade', 'DUA', 'Bokono', 'HEA', 'boh-KOH-noh', None, 'beginner'),
        ('Hôpital', 'DUA', 'Ndako ya bokono', 'HEA', 'n-DAH-koh yah boh-KOH-noh', None, 'intermediate'),
        ('Santé', 'FUL', 'Werɗude', 'HEA', 'wehr-DOO-deh', None, 'beginner'),
        ('Malade', 'FUL', 'Jogi', 'HEA', 'JOH-gee', None, 'beginner'),
        ('Médicament', 'FUL', 'Lekki', 'HEA', 'LEHK-kee', None, 'intermediate'),
        ('Hôpital', 'FUL', 'Safrirde', 'HEA', 'sahf-REER-deh', None, 'intermediate'),

        # Money and shopping (extended)
        ('Prix', 'EWO', 'Nkom', 'MON', 'n-KOHM', None, 'beginner'),
        ('Cher', 'EWO', 'Nkom ane', 'MON', 'n-KOHM ah-NEH', None, 'beginner'),
        ('Bon marché', 'EWO', 'Nkom nit', 'MON', 'n-KOHM neet', None, 'beginner'),
        ('Marché', 'EWO', 'Zom', 'MON', 'zohm', None, 'beginner'),
        ('Boutique', 'EWO', 'Magazin', 'MON', 'mah-gah-ZEEN', None, 'beginner'),
        ('Prix', 'DUA', 'Ntalo', 'MON', 'n-TAH-loh', None, 'beginner'),
        ('Marché', 'DUA', 'Zando', 'MON', 'ZAHN-doh', None, 'beginner'),
        ('Prix', 'FUL', 'Sariya', 'MON', 'sah-REE-yah', None, 'beginner'),
        ('Marché', 'FUL', 'Luumo', 'MON', 'LOO-moh', None, 'beginner'),
        ('Vendre', 'FUL', 'Jaynde', 'MON', 'JAYN-deh', None, 'beginner'),

        # Directions
        ('Gauche', 'EWO', 'Nkinda', 'DIR', 'n-KEEN-dah', None, 'beginner'),
        ('Droite', 'EWO', 'Nnam', 'DIR', 'n-NAHM', None, 'beginner'),
        ('Devant', 'EWO', 'Mbas', 'DIR', 'mm-BAHS', None, 'beginner'),
        ('Derrière', 'EWO', 'Esu', 'DIR', 'eh-SOO', None, 'beginner'),
        ('Ici', 'EWO', 'Va', 'DIR', 'vah', None, 'beginner'),
        ('Là-bas', 'EWO', 'Vana', 'DIR', 'VAH-nah', None, 'beginner'),
        ('Près', 'EWO', 'Koba', 'DIR', 'KOH-bah', None, 'beginner'),
        ('Loin', 'EWO', 'Ane', 'DIR', 'ah-NEH', None, 'beginner'),
        ('Gauche', 'DUA', 'Epai', 'DIR', 'eh-PAH-ee', None, 'beginner'),
        ('Droite', 'DUA', 'Mobali', 'DIR', 'moh-BAH-lee', None, 'beginner'),
        ('Devant', 'DUA', 'Liboso', 'DIR', 'lee-BOH-soh', None, 'beginner'),
        ('Derrière', 'DUA', 'Nsima', 'DIR', 'n-SEE-mah', None, 'beginner'),
        ('Ici', 'DUA', 'Awa', 'DIR', 'AH-wah', None, 'beginner'),
        ('Gauche', 'FUL', 'Nano', 'DIR', 'NAH-noh', None, 'beginner'),
        ('Droite', 'FUL', 'Nanndu', 'DIR', 'NAHN-doo', None, 'beginner'),
        ('Devant', 'FUL', 'Yeeso', 'DIR', 'YEH-soh', None, 'beginner'),
        ('Derrière', 'FUL', 'Caggal', 'DIR', 'CHAHG-gahl', None, 'beginner'),
        ('Ici', 'FUL', 'Inoon', 'DIR', 'ee-NOHN', None, 'beginner'),

        # Religious terms
        ('Dieu', 'EWO', 'Zamba', 'REL', 'ZAHM-bah', None, 'beginner'),
        ('Église', 'EWO', 'Nda Zamba', 'REL', 'n-DAH ZAHM-bah', None, 'beginner'),
        ('Prière', 'EWO', 'Nsambel', 'REL', 'n-sahm-BEHL', None, 'beginner'),
        ('Dimanche', 'EWO', 'Sondo', 'REL', 'SOHN-doh', None, 'beginner'),
        ('Dieu', 'DUA', 'Nyambe', 'REL', 'NYAHM-beh', None, 'beginner'),
        ('Église', 'DUA', 'Ndako ya Nyambe', 'REL', 'n-DAH-koh yah NYAHM-beh', None, 'beginner'),
        ('Dieu', 'FUL', 'Alla', 'REL', 'AHL-lah', None, 'beginner'),
        ('Mosquée', 'FUL', 'Juulirde', 'REL', 'joo-LEER-deh', None, 'beginner'),
        ('Prière', 'FUL', 'Juulde', 'REL', 'JOOL-deh', None, 'beginner'),
        ('Vendredi', 'FUL', 'Aljumaa', 'REL', 'ahl-joo-MAH', None, 'beginner'),

        # Music and entertainment
        ('Musique', 'EWO', 'Nvet', 'MUS', 'n-VEHT', None, 'beginner'),
        ('Danse', 'EWO', 'Bikutsi', 'MUS', 'bee-KOOT-see', None, 'beginner'),
        ('Tambour', 'EWO', 'Nkul', 'MUS', 'n-KOOL', None, 'beginner'),
        ('Chant', 'EWO', 'Nvet', 'MUS', 'n-VEHT', None, 'beginner'),
        ('Musique', 'DUA', 'Miziki', 'MUS', 'mee-ZEE-kee', None, 'beginner'),
        ('Danse', 'DUA', 'Dina', 'MUS', 'DEE-nah', None, 'beginner'),
        ('Tambour', 'DUA', 'Ngoma', 'MUS', 'n-GOH-mah', None, 'beginner'),
        ('Musique', 'FUL', 'Gimde', 'MUS', 'GEEM-deh', None, 'beginner'),
        ('Danse', 'FUL', 'Dillere', 'MUS', 'deel-LEH-reh', None, 'beginner'),
        ('Tambour', 'FUL', 'Tabala', 'MUS', 'tah-BAH-lah', None, 'beginner'),

        # Sports
        ('Football', 'EWO', 'Ndem', 'SPO', 'n-DEHM', None, 'beginner'),
        ('Courir', 'EWO', 'Kumba', 'SPO', 'KOOM-bah', None, 'beginner'),
        ('Nager', 'EWO', 'Vaa mam', 'SPO', 'vah mahm', None, 'beginner'),
        ('Football', 'DUA', 'Mpira', 'SPO', 'mm-PEE-rah', None, 'beginner'),
        ('Courir', 'DUA', 'Pota', 'SPO', 'POH-tah', None, 'beginner'),
        ('Football', 'FUL', 'Balle', 'SPO', 'BAHL-leh', None, 'beginner'),
        ('Courir', 'FUL', 'Yaalende', 'SPO', 'yah-LEHN-deh', None, 'beginner'),
        ('Lutte', 'FUL', 'Dageere', 'SPO', 'dah-GEH-reh', None, 'beginner'),
    ]
    
    cursor.executemany('''
    INSERT INTO translations (french_text, language_id, translation, category_id, pronunciation, usage_notes, difficulty_level)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', translations_data)

def query_examples():
    """Example queries to test the database"""
    conn = sqlite3.connect('cameroon_languages.db')
    cursor = conn.cursor()
    
    print("\n📋 Example Queries:")
    
    # Get all greetings in Ewondo
    cursor.execute('''
    SELECT t.french_text, t.translation, t.pronunciation 
    FROM translations t 
    JOIN languages l ON t.language_id = l.language_id 
    WHERE l.language_name = 'Ewondo' AND t.category_id = 'GRT'
    ''')
    
    print("\n1. Ewondo Greetings:")
    for row in cursor.fetchall():
        print(f"  {row[0]} -> {row[1]} ({row[2]})")
    
    # Count words per language
    cursor.execute('''
    SELECT l.language_name, COUNT(t.translation_id) as word_count
    FROM languages l
    LEFT JOIN translations t ON l.language_id = t.language_id
    GROUP BY l.language_name
    ORDER BY word_count DESC
    ''')
    
    print("\n2. Word Count per Language:")
    for row in cursor.fetchall():
        print(f"  {row[0]}: {row[1]} words")
    
    conn.close()

if __name__ == "__main__":
    create_database()
    query_examples()