# Analiza projekta dagger-relic

## Autor
- Ime i prezime: **Jovan Vukićević**
- Broj indeksa: **1020/2024**
- Kontakt: **jormundur00@gmail.com**

## Opis analiziranog projekta
**dagger-relic** je mali **gejming endžin** otvorenog koda, prvobitno razvijen za potrebe stručnog kursa **Razvoj video igara u C++-u**, koji je kompanija **Ubisoft** držala tokom akademske 2022/2023. godine na Matematičkom fakultetu u Beogradu. Projekat je napisan u programskom jeziku **C++** i sastoji se od fajla **Main.cpp**, koji definiše igru implementiranu u dagger-u (na glavnoj grani se nalazi implementacija igre **Pong**), i implementacije samog endžina.

**GitHub** repozitorijum projekta: https://github.com/gavrilovmiroslav/dagger-relic </br>
Analizirana grana: `master` </br>
Heš kod analiziranog komita: `5495397`

Uputstva za pokretanje projekta se mogu naći u **README.md** fajlu repozitorijuma projekta.

## Korišćeni alati
- **clang-tidy**:
    - Instalacija alata: `sudo apt install clang-tidy`
    - Reprodukcija rezultata:
        1. Pozicionirati se u `clang-tidy` direktorijum (`cd clang-tidy`),
        2. Dodeliti pravo izvršavanja skripti: `chmod +x run_clang_tidy.sh`,
        3. Pokrenuti skriptu: `./run_clang_tidy.sh`.

## Zaključak

Pokretanjem alata **clang-tidy** otkriven je veliki broj stilskih propusta, koji uglavnom potiču iz autorovog korišćenja starijeg **C**-olikog stila pri pisanju **C++** projekta. Pored toga, alat je identifikovao i propuste koji mogu uticati na performanse aplikacije, poput bespotrebnog kopiranja i korišćenja kopija promenljivih.

