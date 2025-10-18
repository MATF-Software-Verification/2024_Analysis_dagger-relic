# Analiza projekta dagger-relic

## Autor
- Ime i prezime: **Jovan Vukićević**
- Broj indeksa: **1020/2024**
- Kontakt: **jormundur00@gmail.com**

## Opis analiziranog projekta
**dagger-relic** je mali **gejming endžin** otvorenog koda, prvobitno razvijen za potrebe stručnog kursa **Razvoj video igara u C++-u**, koji je kompanija **Ubisoft** držala tokom akademske 2022/2023. godine na Matematičkom fakultetu u Beogradu. Projekat je napisan u programskom jeziku **C++** i sastoji se od fajla **Main.cpp**, koji definiše igru implementiranu u dagger-u , i implementacije samog endžina. Kako se na main grani projekta nalazi minimalistička implementacija igre **Pong**, mi u ovoj analizi analiziramo granu `team/straw-hat-crew`, na kojoj je pravljena igra koja koristi više elemenata endžina.

**GitHub** repozitorijum projekta: https://github.com/gavrilovmiroslav/dagger-relic </br>
Analizirana grana: `team/straw-hat-crew` </br>
Heš kod analiziranog komita: `5495397`

Uputstva za pokretanje projekta se mogu naći u **README.md** fajlu repozitorijuma projekta.

## Korišćeni alati
- **clang-tidy**:
    - Instalacija alata: `sudo apt install clang-tidy`
    - Reprodukcija rezultata:
        1. Pozicionirati se u `clang-tidy` direktorijum (`cd clang-tidy`),
        2. Dodeliti pravo izvršavanja skripti: `chmod +x run_clang_tidy.sh`,
        3. Pokrenuti skriptu: `./run_clang_tidy.sh`.
- **Valgrind Memcheck:**
    - Instalacija alata: `sudo apt install valgrind`
    - Reprodukcija rezultata:
        1. Pozicionirati se u `valgrind/memcheck` direktorijum (`cd valgrind/memcheck`),
        2. Dodeliti pravo izvršavanja skripti: `chmod +x run_memcheck.sh`,
        3. Pokrenuti skriptu: `./run_memcheck.sh`.
- **Valgrind Massif**
    - Instalacija alata: `sudo apt install valgrind`
    - Opciona instalacija pomoćnog alata za parsiranje rezultata: `sudo apt install massif-visualizer`
    - Reprodukcija rezultata:
        1. Pozicionirati se u `valgrind/massif` direktorijum (`cd valgrind/massif`),
        2. Dodeliti pravo izvršavanja skripti: `chmod +x run_massif.sh`,
        3. Pokrenuti skriptu: `./run_massif.sh`,
        4. Parsirati generisani izveštaj sa `ms_print <izveštaj>` ili `massif-visualizer <izveštaj>`.

## Zaključak

Pokretanjem alata **clang-tidy** otkriven je veliki broj stilskih propusta, koji uglavnom potiču iz autorovog korišćenja starijeg **C**-olikog stila pri pisanju **C++** projekta, kao i korišćenja velikog broja *magičnih brojeva*. Pored toga, alat je identifikovao i propuste koji mogu uticati na performanse aplikacije, poput bespotrebnog kopiranja i korišćenja kopija promenljivih.

Pokretanjem alata **Valgrind Memcheck** je otkriven problem korišćenja polja objekta pre nego što je inicijalizovano, što dovodi do nedefinisanog ponašanja programa. Osim toga, pronađeno je nekoliko definitivnih curenja memorije, gde su veća curenja produkti nedostatka destruktora `TimeRenderer` i `ScoreRenderer` objekata (pa i oslobađanja njihovih dinamički alociranih polja), dok se manje curenje zasnivalno na nedostatku oslobađanja pokazivača tekstura.

Pokretanjem alata **Valgrind Massif** je analizirana upotreba hipa tokom izvršavanja programa. Zaključeno je za najveći deo upotrebe hipa zasluženo učitavanje tekstura, koje se radi *odjednom*. Kako aplikacija odmah po učitavanju tekstura koristi sve teksture, nema potrebe za ručnim učitavanjem tekstura onda kada su potrebne (što bi predstavljalo optimizaciju u slučajevima gde se ne koriste sve teksture u isto vreme). Zauzeće hip memorije je takođe povećano više nego potrebno zbog odabira opcije `SDL_INIT_EVERYTHING` pri inicijalizovanju **SDL** biblioteke/sistema, jer time automatski inicijalizujemo i podsisteme koje ne koristimo u našoj aplikaciji (kao podrška za zvuk ili džojstik kontrolere).

