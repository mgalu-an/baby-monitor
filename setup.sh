#!/bin/bash

# 🎯 Baby Monitor - Automatyczna konfiguracja
# Ten skrypt przeprowadzi Cię przez cały proces setupu

# Kolory
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     👶 Baby Monitor - Setup 🚀       ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo ""

# Sprawdź Git
echo -e "${BLUE}🔍 Sprawdzam Git...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git nie jest zainstalowany!${NC}"
    echo "Zainstaluj Git: https://git-scm.com/"
    exit 1
fi
echo -e "${GREEN}✅ Git zainstalowany${NC}"
echo ""

# Sprawdź czy index.html istnieje
if [ ! -f "index.html" ]; then
    echo -e "${RED}❌ Nie znaleziono pliku index.html${NC}"
    echo "Upewnij się, że jesteś w folderze baby-monitor"
    echo "i że plik index.html jest w tym folderze"
    exit 1
fi
echo -e "${GREEN}✅ Znaleziono index.html${NC}"
echo ""

# Sprawdź czy Git jest już zainicjowany
if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Git jest już zainicjowany w tym folderze${NC}"
    echo ""
    read -p "Czy chcesz kontynuować? (t/n): " continue
    if [[ $continue != "t" ]]; then
        exit 0
    fi
else
    echo -e "${BLUE}📦 Inicjalizuję Git...${NC}"
    git init
    git branch -M main
    echo -e "${GREEN}✅ Git zainicjowany${NC}"
fi
echo ""

# Pytanie o URL GitHub
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📋 WAŻNE: Przygotuj URL GitHub${NC}"
echo ""
echo "1. Wejdź na https://github.com"
echo "2. Kliknij zielony przycisk 'New' (lub + → New repository)"
echo "3. Repository name: baby-monitor"
echo "4. Zaznacz 'Public'"
echo "5. NIE zaznaczaj 'Add a README file'"
echo "6. Kliknij 'Create repository'"
echo "7. Skopiuj URL (będzie wyglądał jak: https://github.com/TWOJA-NAZWA/baby-monitor.git)"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "Wklej URL GitHub repozytorium: " github_url

if [[ -z "$github_url" ]]; then
    echo -e "${RED}❌ Nie podano URL!${NC}"
    exit 1
fi

# Dodaj remote (lub zaktualizuj jeśli istnieje)
if git remote | grep -q "origin"; then
    echo -e "${BLUE}🔄 Aktualizuję origin...${NC}"
    git remote set-url origin "$github_url"
else
    echo -e "${BLUE}🔗 Dodaję origin...${NC}"
    git remote add origin "$github_url"
fi
echo -e "${GREEN}✅ Remote skonfigurowany${NC}"
echo ""

# Sprawdź czy Supabase jest skonfigurowany
echo -e "${BLUE}🔍 Sprawdzam konfigurację Supabase...${NC}"
if grep -q "TWÓJ_SUPABASE_URL" index.html; then
    echo -e "${RED}❌ Supabase nie jest skonfigurowany!${NC}"
    echo ""
    echo -e "${YELLOW}Musisz edytować index.html i dodać swoje dane:${NC}"
    echo "1. Otwórz index.html w edytorze"
    echo "2. Znajdź linie:"
    echo "   const SUPABASE_URL = 'TWÓJ_SUPABASE_URL';"
    echo "   const SUPABASE_ANON_KEY = 'TWÓJ_SUPABASE_ANON_KEY';"
    echo "3. Wklej swoje dane z Supabase"
    echo "4. Zapisz plik"
    echo "5. Uruchom ten skrypt ponownie"
    echo ""
    exit 1
fi
echo -e "${GREEN}✅ Supabase skonfigurowany${NC}"
echo ""

# Commit i push
echo -e "${BLUE}💾 Zapisuję zmiany...${NC}"
git add .
git commit -m "Pierwsza wersja Baby Monitor" || true

echo -e "${BLUE}☁️  Wysyłam na GitHub...${NC}"
echo ""
echo -e "${YELLOW}📝 Uwaga: Git może poprosić o dane logowania${NC}"
echo "Username: twoja nazwa użytkownika GitHub"
echo "Password: Personal Access Token (NIE zwykłe hasło!)"
echo ""
echo "Jak stworzyć token:"
echo "GitHub → Settings → Developer settings → Personal access tokens"
echo "→ Generate new token (classic) → zaznacz 'repo' → Generate"
echo ""
read -p "Naciśnij Enter gdy będziesz gotowy..."

git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          ✅ SUKCES! 🎉                ║${NC}"
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo ""
    echo -e "${GREEN}Kod został wysłany na GitHub!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Ostatni krok - włącz GitHub Pages:${NC}"
    echo ""
    echo "1. Wejdź na: $github_url"
    echo "2. Kliknij 'Settings'"
    echo "3. Z lewego menu wybierz 'Pages'"
    echo "4. Source: wybierz 'main' branch"
    echo "5. Folder: '/ (root)'"
    echo "6. Kliknij 'Save'"
    echo "7. Poczekaj 1-2 minuty"
    echo "8. Odśwież stronę - zobaczysz link do aplikacji!"
    echo ""
    
    # Wyciągnij nazwę użytkownika i repo z URL
    repo_name=$(echo $github_url | sed 's/.*github.com[:/]\(.*\)\.git/\1/')
    pages_url="https://$(echo $repo_name | sed 's/\//\.github\.io\//')/"
    
    echo -e "${GREEN}🌐 Twoja aplikacja będzie dostępna pod:${NC}"
    echo -e "${BLUE}$pages_url${NC}"
    echo ""
    echo -e "${YELLOW}💡 Od teraz możesz aktualizować aplikację komendą:${NC}"
    echo -e "${BLUE}./deploy.sh \"opis zmian\"${NC}"
    echo ""
    echo -e "${GREEN}Lub po prostu:${NC}"
    echo -e "${BLUE}git add .${NC}"
    echo -e "${BLUE}git commit -m \"aktualizacja\"${NC}"
    echo -e "${BLUE}git push${NC}"
else
    echo ""
    echo -e "${RED}❌ Wystąpił błąd podczas wysyłania${NC}"
    echo ""
    echo "Możliwe przyczyny:"
    echo "1. Nieprawidłowy URL GitHub"
    echo "2. Brak dostępu do repozytorium"
    echo "3. Nieprawidłowy token"
    echo ""
    echo "Sprawdź komunikaty błędów powyżej"
fi
